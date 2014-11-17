package au.org.ala.fieldcapture

import org.codehaus.groovy.grails.web.json.JSONArray


class OrganisationService {

    def grailsApplication, webService, projectService
    def get(String id, view = '') {

        def url = "${grailsApplication.config.ecodata.baseUrl}organisation/$id?view=$view"
        def organisation = webService.getJson(url)


        organisation.projects = getProjectsByName(organisation)

        organisation
    }

    private def getProjectsByName(organisation) {
        def projects = new JSONArray()
        if (!organisation) {
            return projects
        }

        def resp = projectService.search([serviceProviderName:organisation.name])

        if (resp?.resp?.projects) {
            projects.addAll(resp.resp.projects)
        }

        resp = projectService.search([organisationName:organisation.name])

        if (resp?.resp?.projects) {
            projects.addAll(resp.resp.projects)
        }
        projects
    }


    def list() {
        def url = "${grailsApplication.config.ecodata.baseUrl}organisation/"
        webService.getJson(url)
    }

    def update(id, organisation) {
        def url = "${grailsApplication.config.ecodata.baseUrl}organisation/$id"
        webService.doPost(url, organisation)
    }
}
