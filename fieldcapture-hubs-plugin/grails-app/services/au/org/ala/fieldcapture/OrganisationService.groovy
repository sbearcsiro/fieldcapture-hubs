package au.org.ala.fieldcapture

class OrganisationService {

    def grailsApplication, webService, projectService
    def get(String id, view = '') {

        def url = "${grailsApplication.config.ecodata.baseUrl}organisation/$id?view=$view"
        def organisation = webService.getJson(url)


        if (organisation) {
            def resp = projectService.search([serviceProviderName:'Manpower'])
            if (resp?.resp?.projects) {
                organisation.projects?.addAll(resp.resp.projects)
            }
        }

        organisation
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
