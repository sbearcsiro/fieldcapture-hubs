package au.org.ala.fieldcapture

import grails.converters.JSON

class HomeController {

    def projectService
    def siteService
    def activityService
    def searchService
    def settingService
    def metadataService

    @PreAuthorise(accessLevel = 'alaAdmin', redirectController = "admin")
    def advanced() {
        [
            projects: projectService.list(),
            sites: siteService.list(),
            //sites: siteService.injectLocationMetadata(siteService.list()),
            activities: activityService.list(),
            assessments: activityService.assessments(),
        ]
    }
    def index() {
        params.facets = SettingService.getHubConfig().availableFacets //"organisationFacet,associatedProgramFacet,associatedSubProgramFacet,fundingSourceFacet,mainThemeFacet,statesFacet,nrmsFacet,lgasFacet,mvgsFacet,ibraFacet,imcra4_pbFacet,otherFacet"

        def allFacets = []
        allFacets += SettingService.getHubConfig().defaultFacetQuery?:[]
        def userFacets = params.getList('fq').grep{it.contains('Facet') && it.contains(':')}

        // Workaround for each partnership region in the GER being a separate layer and each layer name is
        // prefixed with GER to make it discoverable in the spatial portal.
        // TODO implement an optional display name lookup for facet values.
        def modifiedFacets = userFacets.collect{
            def nameVal = it.split(':');
            def val = nameVal[1]
            if (nameVal[0] == 'gerSubRegionFacet') {
                val = 'GER '+ val
            }
            return nameVal[0]+':'+val
        }

        params.put('fq', modifiedFacets)

        allFacets += userFacets
        def selectedFacets = allFacets.collectEntries{
            def nameVal = it.split(':')

            def name = nameVal[0].substring(0, nameVal[0].indexOf('Facet'))

            return [(name):nameVal[1]]
        }

        def facetConfig = metadataService.getGeographicFacetConfig()

        def geographicFacetConfig = []
        selectedFacets.each {name, value ->
            def config = facetConfig[name]
            if (config) {
                if (config[value]) {
                    geographicFacetConfig << config[value]
                }
            }
        }

        def resp = searchService.HomePageFacets(params)
        resp?.facets?.gerSubRegionFacet?.terms?.each {
            if (it.term.startsWith('GER')) {
                it.term = it.term.substring(4)
            }
        }
        [   facetsList: params.facets.tokenize(","),
            geographicFacets:geographicFacetConfig,
            description: settingService.getSettingText(SettingPageType.DESCRIPTION),
            results: resp ]
    }

    def tabbed() {
        [ geoPoints: searchService.allGeoPoints(params) ]
    }

    def geoService() {
        params.max = params.max?:9999
        if(params.geo){
            render searchService.allProjectsWithSites(params) as JSON
        } else {
            render searchService.allProjects(params) as JSON
        }
    }

    def getProjectsForIds() {
        render searchService.getProjectsForIds(params) as JSON
    }

    def myProfile() {
        redirect(controller: 'user')
    }

    def about() {
        renderStaticPage(SettingPageType.ABOUT, true)
    }

    def help() {
        renderStaticPage(SettingPageType.HELP, false)
    }

    def contacts() {
        renderStaticPage(SettingPageType.CONTACTS, false)
    }

    def staticPage(String id) {
        def settingType = SettingPageType.getForName(id)
        if (settingType) {
            renderStaticPage(settingType)
        } else {
            response.sendError(404)
            return
        }
    }

    private renderStaticPage(SettingPageType settingType, showNews = false) {
        def content = settingService.getSettingText(settingType)
        render view: 'about', model: [settingType: settingType, content: content, showNews:showNews]
    }
}
