package au.org.ala.fieldcapture

import grails.converters.JSON

class HomeController {

    def projectService
    def siteService
    def activityService
    def searchService
    def settingService
    def metadataService
    def userService;

    @PreAuthorise(accessLevel = 'alaAdmin', redirectController = "admin")
    def advanced() {
        [
                projects   : projectService.list(),
                sites      : siteService.list(),
                //sites: siteService.injectLocationMetadata(siteService.list()),
                activities : activityService.list(),
                assessments: activityService.assessments(),
        ]
    }

    def index() {
        def facetsList = SettingService.getHubConfig().availableFacets
        //"organisationFacet,associatedProgramFacet,associatedSubProgramFacet,fundingSourceFacet,mainThemeFacet,statesFacet,nrmsFacet,lgasFacet,mvgsFacet,ibraFacet,imcra4_pbFacet,otherFacet"

        def allFacets = params.getList('fq') + (SettingService.getHubConfig().defaultFacetQuery ?: [])

        def selectedGeographicFacets = findSelectedGeographicFacets(allFacets)

        def resp = searchService.HomePageFacets(params)

        [facetsList      : facetsList,
         geographicFacets: selectedGeographicFacets,
         description     : settingService.getSettingText(SettingPageType.DESCRIPTION),
         results         : resp]
    }

    def citizenScience() {
        def user = userService.getUser()
        def userId = user?.userId
        [user: user,
         projects: projectService.list(false, true).collect {
            // pass array instead of object to reduce size
            [it.projectId,
             it.coverage ?: '',
             it.description,
             userId && projectService.canUserEditProject(userId, it.projectId) ? 'y' : '',
             it.name,
             it.organisationName?:metadataService.getInstitutionName(it.organisationId),
             it.status,
             (it.urlAndroid ?: '') + ' ' + (it.urlITunes ?: ''),
             it.urlWeb ?: '']
        }];
    }

    /**
     * The purpose of this method is to enable the display of the spatial object corresponding to a selected
     * value from a geographic facet (e.g. to display the polygon representing NSW on the map if the user has
     * selected NSW from the "state" facet list.
     *
     * First we check to see if we have a geographic facet configuration for any of the user's facet selections.
     * If so, we find the spatial object configuration matching the selected value and add that to the returned
     * model.  The selected polygon can then be requested by PID from geoserver.
     *
     * By convention, the facet field names in the search index have a suffix of "Facet" whereas the facet configuration
     * doesn't include the word "Facet" (although maybe it should).
     */
    private ArrayList findSelectedGeographicFacets(Collection allFacets) {
        def selectedFacets = allFacets.collectEntries {
            def nameVal = it.split(':')
            return [(nameVal[0]): nameVal[1]]
        }

        def facetConfig = metadataService.getGeographicFacetConfig()

        def selectedGeographicFacets = []
        selectedFacets.each { name, value ->

            def matchingFacet = facetConfig.find { name.startsWith(it.key) }
            if (matchingFacet) {
                def matchingValue = matchingFacet.value.find { it.key == value }
                if (matchingValue) {
                    selectedGeographicFacets << matchingValue.value
                }
            }
        }
        selectedGeographicFacets
    }

    def tabbed() {
        [geoPoints: searchService.allGeoPoints(params)]
    }

    def geoService() {
        params.max = params.max ?: 9999
        if (params.geo) {
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
        render view: 'about', model: [settingType: settingType, content: content, showNews: showNews]
    }
}
