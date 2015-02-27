package au.org.ala.fieldcapture

import grails.converters.JSON

/**
 * Processes requests relating to organisations in field capture.
 */
class OrganisationController {

    def organisationService, searchService, documentService

    def list() {
        def organisations = organisationService.list()
        [organisations:organisations.list?:[]]
    }

    def index(String id) {
        def organisation = organisationService.get(id, 'all')

        if (!organisation || organisation.error) {
            organisationNotFound(id, organisation)
        }
        else {
            // Get dashboard information for the response.
            def dashboard = searchService.dashboardReport([fq: 'organisationFacet:' + organisation.name])

            [organisation: organisation, dashboard: dashboard, isAdmin:organisationService.isUserAdminForOrganisation(id)]
        }
    }

    def create() {
        [organisation:[:]]
    }

    def edit(String id) {
        def organisation = organisationService.get(id)

        if (!organisation || organisation.error) {
            organisationNotFound(id, organisation)
        }
        else {
            [organisation: organisation]
        }
    }

    def delete(String id) {
        organisationService.update(id, [status:'deleted'])

        redirect action: 'list'
    }

    def ajaxDelete(String id) {
        def result = organisationService.update(id, [status:'deleted'])

        respond result
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
            render result.resp as JSON
        }
    }

    /**
     * Redirects to the home page with an error message in flash scope.
     * @param response the response that triggered this method call.
     */
    private void organisationNotFound(id, response) {
        flash.message = "No organisation found with id: ${id}"
        if (response?.error) {
            flash.message += "<br/>${response.error}"
        }
        redirect(controller: 'home', model: [error: flash.message])
    }
}
