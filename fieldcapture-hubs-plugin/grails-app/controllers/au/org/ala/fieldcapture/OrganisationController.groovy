package au.org.ala.fieldcapture

import grails.converters.JSON

class OrganisationController {

    def organisationService, searchService, documentService

    def list() {
        def organisations = organisationService.list()
        println organisations
        [organisations:organisations.list?:[]]
    }

    def index(String id) {
        def organisation = organisationService.get(id, 'all')

        // Get dashboard information for the organisation.
        def dashboard = searchService.dashboardReport([fq:'organisationFacet:'+organisation.name])

        [organisation:organisation, dashboard:dashboard]
    }

    def create() {
        [organisation:[:]]
    }

    def edit(String id) {
        def organisation = organisationService.get(id)

        [organisation:organisation]
    }

    def delete(String id) {
        organisationService.update(id, [status:'deleted'])

        redirect action: 'list'
    }

    def ajaxDelete(String id) {
        def result = organisationService.update(id, [status:'deleted'])

        response.contentType = 'application/json'
        render result as JSON
    }

    def ajaxUpdate() {
        def organisationDetails = request.JSON

        def documents = organisationDetails.remove('documents')
        def result = organisationService.update(organisationDetails.organisationId?:'', organisationDetails)

        documents.each { doc ->
            doc.organisationId = organisationDetails.organisationId?:result.resp?.organisationId
            documentService.saveStagedImageDocument(doc)

        }
        if (result.error) {
            render result as JSON
        } else {
            //println "json result is " + (result as JSON)
            render result.resp as JSON
        }
    }
}
