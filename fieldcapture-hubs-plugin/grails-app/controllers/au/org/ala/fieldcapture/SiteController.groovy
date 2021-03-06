package au.org.ala.fieldcapture
import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONArray

class SiteController {

    def siteService, projectService, activityService, metadataService, userService, searchService, importService, webService

    static defaultAction = "index"

    static ignore = ['action','controller','id']

    def search = {
        params.fq = "docType:site"
        def results = searchService.fulltextSearch(params)
        render results as JSON
    }

    def select(){
        // permissions check
        if (!projectService.canUserEditProject(userService.getCurrentUserId(), params.projectId)) {
            flash.message = "Access denied: User does not have <b>editor</b> permission for projectId ${params.projectId}"
            redirect(controller:'project', action:'index', id: params.projectId)
        }
        render view: 'select', model: [project:projectService.get(params.projectId)]
    }

    def create(){
        render view: 'edit', model: [create:true, documents:[]]
    }

    def createForProject(){
        def project = projectService.getRich(params.projectId)
        // permissions check
        if (!projectService.canUserEditProject(userService.getCurrentUserId(), params.projectId)) {
            flash.message = "Access denied: User does not have <b>editor</b> permission for projectId ${params.projectId}"
            redirect(controller:'project', action:'index', id: params.projectId)
        }
        render view: 'edit', model: [create:true, project:project, documents:[]]
    }

    def index(String id) {
        //log.debug(id)
        def site = siteService.get(id, [view: 'scores'])
        if (site) {
            // permissions check - can't use annotation as we have to know the projectId in order to lookup access right
            if (!isUserMemberOfSiteProjects(site)) {
                flash.message = "Access denied: User does not have permission to view site: ${id}"
                redirect(controller:'home', action:'index')
            }

            // inject the metadata model for each activity
            site.activities.each {
                it.model = metadataService.getActivityModel(it.type)
            }
            //siteService.injectLocationMetadata(site)
            [site: site,
             //activities: activityService.activitiesForProject(id),
             mapFeatures: siteService.getMapFeatures(site)]
        } else {
            //forward(action: 'list', model: [error: 'no such id'])
            render 'no such site'
        }
    }

    def edit(String id) {
        def result = siteService.getRaw(id)
        if (!result.site) {
            render 'no such site'
        } else if (!isUserMemberOfSiteProjects(result.site)) {
            // check user has permissions to edit - user must have edit access to
            // ALL linked projects to proceed.
            flash.message = "Access denied: User does not have <b>editor</b> permission to edit site: ${id}"
            redirect(controller:'home', action:'index')
        } else {
            result
        }
    }

    def downloadShapefile(String id) {

        def site = siteService.get(id)
        if (site) {
            // permissions check - can't use annotation as we have to know the projectId in order to lookup access right
            if (!isUserMemberOfSiteProjects(site)) {
                flash.message = "Access denied: User does not have permission to view site: ${id}"
                redirect(controller: 'home', action: 'index')
            }
        }
        def url = grailsApplication.config.ecodata.baseUrl + "site/${id}.shp"
        def resp = webService.proxyGetRequest(response, url, true, true,960000)
        if (resp.status != 200) {
            render view:'/error', model:[error:resp.error]
        }
    }

    def ajaxDeleteSitesFromProject(String id){
        // permissions check - id is the projectId here
        if (!projectService.canUserEditProject(userService.getCurrentUserId(), id)) {
            render status:403, text: "Access denied: User does not have permission to edit site: ${id}"
            return
        }

        def status = siteService.deleteSitesFromProject(id)
        if (status < 400) {
            def result = [status: 'deleted']
            render result as JSON
        } else {
            def result = [status: status]
            render result as JSON
        }
    }

    def ajaxDeleteSiteFromProject(String id) {
        def projectId = id
        def siteId = params.siteId
        if (!projectId || !siteId) {
            render status:400, text:'The siteId parameter is mandatory'
            return
        }
        if (!projectService.canUserEditProject(userService.getCurrentUserId(), projectId)) {
            render status:403, text: "Access denied: User does not have permission to edit sites for project: ${projectId}"
            return
        }

        def site = siteService.get(siteId, [raw:'true'])
        def projects = site.projects
        projects.remove(projectId)

        def result = siteService.update(siteId, [projects:projects])
        render result as JSON

    }

    def ajaxDelete(String id) {
        // permissions check
        if (!isUserMemberOfSiteProjects(siteService.get(id))) {
            render status:403, text: "Access denied: User does not have permission to edit site: ${id}"
            return
        }

        def status = siteService.delete(id)
        if (status < 400) {
            def result = [status: 'deleted']
            render result as JSON
        } else {
            def result = [status: status]
            render result as JSON
        }
    }

    def update(String id) {

        log.debug("Updating site: " + id)

        // permissions check
        if (!isUserMemberOfSiteProjects(siteService.get(id))) {
            render status:403, text: "Access denied: User does not have permission to edit site: ${id}"
            return
        }

        //params.each { println it }
        //todo: need to detect 'cleared' values which will be missing from the params
        def values = [:]
        // filter params to remove:
        //  1. keys in the ignore list; &
        //  2. keys with dot notation - the controller will automatically marshall these into maps &
        //  3. keys in nested maps with dot notation
        removeKeysWithDotNotation(params).each { k, v ->
            if (!(k in ignore)) {
                values[k] = reMarshallRepeatingObjects(v);
            }
        }
        //log.debug (values as JSON).toString()
        siteService.update(id, values)
        chain(action: 'index', id:  id)
    }

    def uploadShapeFile() {
        if (!projectService.canUserEditProject(userService.getCurrentUserId(), params.projectId)) {
            flash.message = "Access denied: User does not have <b>editor</b> permission for projectId ${params.projectId}"
            redirect(url: params.returnTo)
        }

        if (request.respondsTo('getFile')) {
            def f = request.getFile('shapefile')


            def result =  siteService.uploadShapefile(f)

            if (!result.error && result.content.size() > 1) {
                def content = result.content
                def shapeFileId = content.remove('shp_id')
                def firstShape = content["0"]
                def attributeNames = []
                firstShape.each {key, value ->
                    attributeNames << key
                }
                def shapes = content.collect {key, value ->
                    [id:(key), values:(value)]
                }
                JSON.use("nullSafe") // JSONNull is rendered as empty string.
                render view:'upload', model:[projectId: params.projectId, shapeFileId:shapeFileId, shapes:shapes, attributeNames:attributeNames]
            }

            else {
                //flag error for extension
                def message ='There was an error uploading the shapefile.  Please send an email to support for further assistance.'

                flash.message = "An error was encountered when processing the shapefile: ${message}"
                render view:'upload', model:[projectId: params.projectId, returnTo:params.returnTo]
            }

        } else {
            render view:'upload', model:[projectId: params.projectId, returnTo:params.returnTo]
        }
    }

    def createSitesFromShapefile() {
        def siteData = request.JSON
        def progress = [total:siteData.sites.size(), uploaded:0]

        try {
            session.uploadProgress = progress

            siteData.sites.each {
                siteService.createSiteFromUploadedShapefile(siteData.shapeFileId, it.id, it.externalId, it.name, it.description?:'No description supplied', siteData.projectId)
                progress.uploaded = progress.uploaded + 1
            }
        }
        finally {
            progress.finished = true
        }

        def result = [message:'success', progress:progress]
        render result as JSON
    }

    def siteUploadProgress() {
        def progress = session.uploadProgress?:[:]
        render progress as JSON
    }




    def createGeometryForGrantId(String grantId, String geometryPid, Double centroidLat, Double centroidLong) {
        def projects = importService.allProjectsWithGrantId(grantId)
        if (projects) {
            def sites = []
            projects.each {project ->
                def metadata = metadataService.getLocationMetadataForPoint(centroidLat, centroidLong)
                def strLat =  "" + centroidLat + ""
                def strLon = "" + centroidLong + ""
                def values = [extent: [source: 'pid', geometry: [pid: geometryPid, type: 'pid', state: metadata.state, nrm: metadata.nrm, lga: metadata.lga, locality: metadata.locality, centre: [strLon, strLat]]], projects: [project.projectId], name: "Project area for " + grantId]
                sites << siteService.create(values)
            }
            def result = [result:sites]
            render result as JSON
        } else {
            render "EMPTY"
        }
    }

    def createPointForGrantId(String grantId, String geometryPid, Double lat, Double lon) {
        def projects = importService.allProjectsWithGrantId(grantId)
        if (projects) {
            def sites = []
            projects.each {project ->
                def metadata = metadataService.getLocationMetadataForPoint(lat, lon)
                def strLat =  "" + lat + ""
                def strLon = "" + lon + ""
                def values = [extent: [source: 'point', geometry: [pid: geometryPid, type: 'point', decimalLatitude: strLat, decimalLongitude: strLon, centre: [strLon, strLat], coordinates: [strLon, strLat], datum: "WGS84", state: metadata.state, nrm: metadata.nrm, lga: metadata.lga, locality: metadata.locality, mvg: metadata.mvg, mvs: metadata.mvs]], projects: [project.projectId], name: "Project area for " + grantId]
                sites << siteService.create(values)
            }
            def result = [result:sites]
            render result as JSON
        } else {
            render "EMPTY"
        }
    }

    def updateSiteCentrePoint(String grantId, Double lat, Double lon) {
        def project = importService.findProjectByGrantId(grantId)
        if (project) {
            def site = importService.findProjectSiteByName(project, grantId)
            if (site) {
                def strLat =  "" + lat + ""
                def strLon = "" + lon + ""
                site.extent.geometry.centre = [strLon, strLat]
                siteService.update(site.siteId, site)
                render site as JSON
            } else {
                render "COULD NOT FIND SITE"
            }
        } else {
            render "EMPTY"
        }
    }

    def ajaxUpdateProjects() {
        def postBody = request.JSON
        log.debug "Body: " + postBody
        log.debug "Params:"
        params.each { println it }
        //todo: need to detect 'cleared' values which will be missing from the params - implement _destroy
        def values = [:]
        // filter params to remove:
        //  1. keys in the ignore list; &
        //  2. keys with dot notation - the controller will automatically marshall these into maps &
        //  3. keys in nested maps with dot notation
        postBody.each { k, v ->
            if (!(k in ignore)) {
                values[k] = v //reMarshallRepeatingObjects(v);
            }
        }
        log.debug "values: " + (values as JSON).toString()

        def result = siteService.updateProjectAssociations(values)
        if(result.error){
            response.status = 500
        } else {
            render result as JSON
        }
    }

    def ajaxUpdate(String id) {
        def postBody = request.JSON
        log.debug "Body: " + postBody
        log.debug "Params:"
        params.each { println it }
        //todo: need to detect 'cleared' values which will be missing from the params - implement _destroy
        def values = [:]
        // filter params to remove:
        //  1. keys in the ignore list; &
        //  2. keys with dot notation - the controller will automatically marshall these into maps &
        //  3. keys in nested maps with dot notation
        postBody.each { k, v ->
            if (!(k in ignore)) {
                values[k] = v //reMarshallRepeatingObjects(v);
            }
        }
        log.debug (values as JSON).toString()

        def result = [:]
        // check user has persmissions to edit/update site - user must have 'editor' access to
        // ALL linked projects to proceed.
        String userId = userService.getCurrentUserId()
        values.projects?.each { projectId ->
            if (!projectService.canUserEditProject(userId, projectId)) {
                flash.message = "Error: access denied: User does not have <b>editor</b> permission for projectId ${projectId}"
                result = [status: 'error']
                //render result as JSON
            }
        }

        if (!result)
            result = siteService.updateRaw(id, values)
        render result as JSON
    }

    def locationLookup(String id) {
        def md = [:]
        def site = siteService.get(id)
        if (!site || site.error) {
            md = [error: 'no such site']
        } else {
            md = siteService.getLocationMetadata(site)
            if (!md) {
                md = [error: 'no metadata found']
            }
        }
        render md as JSON
    }

    /**
     * Looks up the site metadata (used for facetting) based on the supplied
     * point and returns it as JSON.
     * @param lat the latitude of the point (or centre of a shape)
     * @param lon the longitude of the point (or centre of a shape)
     */
    def locationMetadataForPoint() {
        def lat = params.lat
        def lon = params.lon


        if (!lat || !lon) {
            response.status = 400
            def result = [error:'lat and lon parameters are required']
            render result as JSON
        }
        if (!lat.isDouble() || !lon.isDouble()) {
            response.status = 400
            def result = [error:'invalid lat and lon supplied']
            render result as JSON
        }

        render metadataService.getLocationMetadataForPoint(lat, lon) as JSON
    }

    def projectsForSite(String id) {
        def projects = siteService.projectsForSite(id) ?: []
        //log.debug projects
        render projects as JSON
    }

    /**
     * Re-marshalls a map of arrays to an array of maps.
     *
     * Grails marshalling of repeating fields with names in dot notation: eg
     * <pre>
     *     <bs:textField name="shape.pid" label="Shape PID"/>
     *     <bs:textField name="shape.name" label="Shape name"/>
     *     <bs:textField name="shape.pid" label="Shape PID"/>
     *     <bs:textField name="shape.name" label="Shape name"/>
     * </pre>
     * produces a map like:
     *  [name:['shape1','shape2'],pid:['23','24']]
     * while we want:
     *  [[name:'shape1',pid:'23'],[name:'shape2',pid:'24']]
     *
     * We indicate that we want this style of marshalling (the other is also valid) by adding a hidden
     * field data-marshalling='list'.
     *
     * @param value the map to re-marshall
     * @return re-marshalled map
     */
    def reMarshallRepeatingObjects(value) {
        if (!(value instanceof HashMap)) {
            return value
        }
        if (value.handling != 'repeating') {
            return value
        }
        value.remove('handling')
        def list = []
        def len = value.collect({ it.value.size() }).max()
        (0..len-1).each { idx ->
            def newMap = [:]
            value.keySet().each { key ->
                newMap[key] = reMarshallRepeatingObjects(value[key][idx])
            }
            list << newMap
        }
        list
    }

    def removeKeysWithDotNotation(value) {
        if (value instanceof String) {
            return value
        }
        if (value instanceof Object[]) {
            return stripBlankElements(value)
        }
        // assume map for now
        def iter = value.entrySet().iterator()
        while (iter.hasNext()) {
            def entry = iter.next()
            if (entry.key.indexOf('.') >= 0) {
                iter.remove()
            }
            entry.value = removeKeysWithDotNotation(entry.value)
        }
        value
    }

    def stripBlankElements(list) {
        list.findAll {it}
    }

    // debug only
    def features(String id) {
        def site = siteService.get(id)
        if (site) {
            render siteService.getMapFeatures(site)
        } else {
            render 'no such site'
        }
    }

    /**
     * Check each of the site's projects if logged in user is a member
     *
     * @param site
     * @return
     */
    private Boolean isUserMemberOfSiteProjects(site) {
        Boolean userCanEdit = false

        site.projects.each { p ->
            // handle both 'raw' and normal (project is a Map) output from siteService.get()
            def pId = (p instanceof Map && p.containsKey('projectId')) ? p.projectId : p
            if (pId && projectService.canUserEditProject(userService.getCurrentUserId(), pId)) {
                userCanEdit = true
            }
        }

        userCanEdit
    }
}
