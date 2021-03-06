package au.org.ala.fieldcapture

import com.vividsolutions.jts.geom.Geometry
import com.vividsolutions.jts.geom.Point
import com.vividsolutions.jts.io.WKTReader
import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.mapping.LinkGenerator
import org.geotools.kml.v22.KMLConfiguration
import org.geotools.xml.Parser
import org.opengis.feature.simple.SimpleFeature

class SiteService {

    def webService, grailsApplication, commonService, metadataService, userService
    def documentService
    LinkGenerator grailsLinkGenerator

    def list() {
        webService.getJson(grailsApplication.config.ecodata.baseUrl + 'site/').list
    }

    def projectsForSite(siteId) {
        get(siteId)?.projects
    }

    /**
     * Creates a site extent object from a supplied latitude and longitude in the correct format, and populates the facet metadata for the extent.
     * @param lat the latitude of the point.
     * @param lon the longitude of the point.
     * @return a Map containing the site extent in the correct format (see the metaModel())
     */
    def siteExtentFromPoint(lat, lon) {

        def extent = [:].withDefault{[:]}
        extent.source = 'point'
        extent.geometry.type = 'Point'
        extent.geometry.decimalLatitude = lat
        extent.geometry.decimalLongitude = lon
        extent.geometry.coordinates = [lon, lat]
        extent.geometry.centre = [lon, lat]
        extent.geometry << metadataService.getLocationMetadataForPoint(lat, lon)
        extent
    }

    def getLocationMetadata(site) {
        //log.debug site
        def loc = getFirstPointLocation(site)
        //log.debug "loc = " + loc
        if (loc && loc.geometry?.decimalLatitude && loc.geometry?.decimalLongitude) {
            return metadataService.getLocationMetadataForPoint(loc.geometry.decimalLatitude, loc.geometry.decimalLongitude)
        }
        return null
    }

    def injectLocationMetadata(List sites) {
        sites.each { site ->
            injectLocationMetadata(site)
        }
        sites
    }

    def injectLocationMetadata(Object site) {
        def loc = getFirstPointLocation(site)
        if (loc && loc.geometry?.decimalLatitude && loc.geometry?.decimalLongitude) {
            site << metadataService.getLocationMetadataForPoint(loc.geometry.decimalLatitude, loc.geometry.decimalLongitude)
        }
        site
    }

    def getFirstPointLocation(site) {
        site.location?.find {
            it.type == 'locationTypePoint'
        }
    }

    def getSitesFromIdList(ids) {
        def result = []
        ids.each {
            result << get(it)
        }
        result
    }

    def addPhotoPoint(siteId, photoPoint) {
        photoPoint.type = 'photopoint'
        addPOI(siteId, photoPoint)
    }

    def addPOI(siteId, poi) {

        if (!siteId) {
            throw new IllegalArgumentException("The siteId parameter cannot be null")
        }
        def url = "${grailsApplication.config.ecodata.baseUrl}site/${siteId}/poi"
        webService.doPost(url, poi)
    }

    def get(id, Map urlParams = [:]) {
        if (!id) return null
        webService.getJson(grailsApplication.config.ecodata.baseUrl + 'site/' + id +
                commonService.buildUrlParamsFromMap(urlParams))
    }

    def getRaw(id) {
        def site = get(id, [raw:'true'])
        if (!site || site.error) return [:]

        if (site.shapePid && !(site.shapePid instanceof JSONArray)) {
            log.debug "converting to array"
            site.shapePid = [site.shapePid] as JSONArray
        }
        def documents = documentService.getDocumentsForSite(site.siteId).resp?.documents?:[]
        [site: site, documents:documents as JSON, meta: metaModel()]
    }

    def updateRaw(id, values) {
        //if its a drawn shape, save and get a PID
        if(values?.extent?.source == 'drawn'){
            def shapePid = persistSiteExtent(values.name, values.extent.geometry)
            values.extent.geometry.pid = shapePid.resp?.id
        }

        if (id) {
            update(id, values)
            [status: 'updated']
        } else {
            def resp = create(values)
            [status: 'created', id:resp.resp.siteId]
        }
    }

    def create(body){
        webService.doPost(grailsApplication.config.ecodata.baseUrl + 'site/', body)
    }

    def update(id, body) {
        webService.doPost(grailsApplication.config.ecodata.baseUrl + 'site/' + id, body)
    }

    def updateProjectAssociations(body) {
        webService.doPost(grailsApplication.config.ecodata.baseUrl + 'project/updateSites/' + body.projectId, body)
    }

    /** uploads a shapefile to the spatial portal */
    def uploadShapefile(shapefile) {
        def userId = userService.getUser().userId
        def url = "${grailsApplication.config.spatial.layersUrl}/shape/upload/shp?user_id=${userId}&api_key=${grailsApplication.config.api_key}"

        return webService.postMultipart(url, [:], shapefile)
    }

    /**
     * Creates a site for a specified project from the supplied site data.
     * @param shapeFileId the id of the shapefile in the spatial portal
     * @param siteId the id of the shape to use (as returned by the spatial portal upload)
     * @param name the name for the site
     * @param description the description for the site
     * @param projectId the project the site should be associated with.
     */
    def createSiteFromUploadedShapefile(shapeFileId, siteId, externalId, name, description, projectId) {
        def baseUrl = "${grailsApplication.config.spatial.layersUrl}/shape/upload/shp"
        def userId = userService.getUser().userId

        def site = [name:name, description: description, user_id:userId, api_key:grailsApplication.config.api_key]

        def url = "${baseUrl}/${shapeFileId}/${siteId}"

        def result = webService.doPost(url, site)
        if (!result.error) {
            def id = result.resp.id

            Point centriod = calculateSiteCentroid(id)
            createSite(projectId, name, description, externalId, id, centriod.getY(), centriod.getX())
        }
    }

    /**
     * Creates (and saves) a site definition from a name, description and lat/lon.
     * @param projectId the project the site should be associated with.
     * @param name a name for the site.
     * @param description a description of the site.
     * @param lat latitude of the site centroid.
     * @param lon longitude of the site centroid.
     */
    def createSiteFromPoint(projectId, name, description, lat, lon) {
        def site = [name:name, description:description, projects:[projectId]]
        site.extent = siteExtentFromPoint(lat, lon)

        create(site)
    }

    /**
     * Creates sites for a project from the supplied KML.  The Placemark elements in the KML are used to create
     * the sites, other contextual and styling information is ignored.
     * @param kml the KML that defines the sites to be created
     * @param projectId the project the sites will be assigned to.
     */
    def createSitesFromKml(kml, projectId) {

        def url = "${grailsApplication.config.spatial.layersUrl}/shape/upload/wkt"
        def userId = userService.getUser().userId

        Parser parser = new Parser(new KMLConfiguration())
        SimpleFeature f = parser.parse(new StringReader(kml))

        def placemarks = []
        extractPlacemarks(f, placemarks)

        def sites = []

        placemarks.each { SimpleFeature placemark ->
            def name = placemark.getAttribute('name')
            def description = placemark.getAttribute('description')

            Geometry geom = placemark.getDefaultGeometry()
            def site = [name:name, description: description, user_id:userId, api_key:grailsApplication.config.api_key, wkt:geom.toText()]

            def result = webService.doPost(url, site)
            if (!result.error) {
                def id = result.resp.id
                if (!result.resp.error) {
                    sites << createSite(projectId, name, description, '', id, geom.centroid.getY(), geom.centroid.getX())
                }
            }

        }
        return sites
    }

    /**
     * Extracts any features that have a geometry attached, in the case of KML these will likely be placemarks.
     */
    def extractPlacemarks(features, placemarks) {
        if (!features) {
            return
        }
        features.each { SimpleFeature feature ->
            if (feature.getDefaultGeometry()) {
                placemarks << feature
            }
            else {
                extractPlacemarks(feature.getAttribute('Feature'), placemarks)
            }
        }
    }


    /** Returns the centroid (as a Point) of a site in the spatial portal */
    def calculateSiteCentroid(spatialPortalSiteId) {

        def getWktUrl = "${grailsApplication.config.spatial.baseUrl}/ws/shape/wkt"
        def wkt = webService.get("${getWktUrl}/${spatialPortalSiteId}")
        Geometry geom = new WKTReader().read(wkt)
        return geom.getCentroid()
    }

    def createSite(projectId, name, description, externalId, geometryPid, centroidLat, centroidLong) {
        def metadata = metadataService.getLocationMetadataForPoint(centroidLat, centroidLong)
        def strLat =  "" + centroidLat + ""
        def strLon = "" + centroidLong + ""
        def values = [extent: [source: 'pid', geometry: [pid: geometryPid, type: 'pid', state: metadata.state, nrm: metadata.nrm, lga: metadata.lga, locality: metadata.locality, mvg: metadata.mvg, mvs: metadata.mvs, centre: [strLon, strLat]]], projects: [projectId], name: name, description: description, externalId:externalId]
        return create(values)
    }

    def persistSiteExtent(name, geometry) {

        def resp = null
        if(geometry?.type == 'Circle'){
           def body = [name: "test", description: "my description", user_id: "1551", api_key: "b3f3c932-ba88-4ad5-b429-f947475024af"]
           def url = grailsApplication.config.spatial.layersUrl + "/shape/upload/pointradius/" +
                    geometry?.coordinates[1] + '/' + geometry?.coordinates[0] + '/' + (geometry?.radius / 1000)
           resp = webService.doPost(url, body)
        } else if (geometry?.type == 'Polygon'){
           def body = [geojson: geometry, name: name, description:'my description', user_id: '1551', api_key: "b3f3c932-ba88-4ad5-b429-f947475024af"]
           resp = webService.doPost(grailsApplication.config.spatial.layersUrl + "/shape/upload/geojson", body)
        }
        resp
    }

    def delete(id) {
        webService.doDelete(grailsApplication.config.ecodata.baseUrl + 'site/' + id)
    }

    def deleteSitesFromProject(projectId){
        webService.doDelete(grailsApplication.config.ecodata.baseUrl + 'project/deleteSites/' + projectId)
    }

    /**
     * Returns json that describes in a generic fashion the features to be placed on a map that
     * will represent the site's locations.
     *
     * If no extent is defined, returns an empty JSON object.
     *
     * @param site
     */
    def getMapFeatures(site) {
        def featuresMap = [zoomToBounds: true, zoomLimit: 15, highlightOnHover: true, features: []]
        switch (site.extent?.source) {
            case 'point':
                featuresMap.features << site.extent.geometry
                break
            case 'pid':
                featuresMap.features << site.extent.geometry
                break
            case 'drawn' :
                featuresMap.features << site.extent.geometry
                break
            default:
                featuresMap = [:]
        }

        def asJSON = featuresMap as JSON

        log.debug asJSON

        asJSON
    }

    static metaModel() {
        return [domain: 'site',
                model: [
                        [name:'siteName', type:'text', immutable:true],
                        [name:'externalId', type:'text'],
                        [name:'type', type:'text'],
                        [name:'area', type:'text'],
                        [name:'description', type:'text'],
                        [name:'notes', type:'text'],
                        [name:'extent', type:'Location', itemModel: [
                                [name:'name', type: 'text'],
                                [name:'type', type:'list', itemType:'text', listValues:[
                                        'locationTypeNone','locationTypePoint','locationTypePid','locationTypeUpload',
                                ]],
                                [name:'geometry', type:'list', itemType:[
                                        [name:'NoneLocation', type:'null'],
                                        [name:'PointLocation', type:'list', itemType:[
                                                [name:'decimalLatitude', type:'latLng'],
                                                [name:'decimalLongitude', type:'latLng'],
                                                [name:'uncertainty', type:'text'],
                                                [name:'precision', type:'text'],
                                                [name:'datum', type:'text']
                                        ]],
                                        [name:'PidLocation', type:'list', itemType:[
                                                [name:'pid', type: 'text']
                                        ]],
                                        [name:'UploadLocation', type:'list', itemType:[
                                                [name:'shape', type: 'text'],
                                                [name:'pid', type: 'text']
                                        ]],
                                        [name:'DrawnLocation', type:'list', itemType:[
                                                [name:'decimalLatitude', type:'latLng'],
                                                [name:'decimalLongitude', type:'latLng'],
                                                [name:'radius', type:'text'],
                                                [name:'wkt', type:'text']
                                        ]]
                                ]]
                            ]
                        ],
                        [name:'location', type:'list', itemType: 'Location', itemModel: [
                                [name:'name', type: 'text'],
                                [name:'type', type:'list', itemType:'text', listValues:[
                                        'locationTypeNone','locationTypePoint','locationTypePid','locationTypeUpload',
                                ]],
                                [name:'data', type:'list', itemType:[
                                        [name:'NoneLocation', type:'null'],
                                        [name:'PointLocation', type:'list', itemType:[
                                                [name:'decimalLatitude', type:'latLng'],
                                                [name:'decimalLongitude', type:'latLng'],
                                                [name:'uncertainty', type:'text'],
                                                [name:'precision', type:'text'],
                                                [name:'datum', type:'text']
                                        ]],
                                        [name:'PidLocation', type:'list', itemType:[
                                                [name:'pid', type: 'text']
                                        ]],
                                        [name:'UploadLocation', type:'list', itemType:[
                                                [name:'shape', type: 'text'],
                                                [name:'pid', type: 'text']
                                        ]],
                                        [name:'DrawnLocation', type:'list', itemType:[
                                                [name:'decimalLatitude', type:'latLng'],
                                                [name:'decimalLongitude', type:'latLng'],
                                                [name:'radius', type:'text'],
                                                [name:'wkt', type:'text']
                                        ]]
                                ]]
                            ]
                        ],
                ]
            ]
    }
}