package au.org.ala.fieldcapture

import grails.converters.JSON

/**
 * Processes requests relating to organisations in field capture.
 */
class OrganisationController {

    def organisationService, searchService, documentService, userService, roleService

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
            def roles = roleService.getRoles()
            // Get dashboard information for the response.
            def dashboard = searchService.dashboardReport([fq: 'organisationFacet:' + organisation.name])
            def members = organisationService.getMembersOfOrganisation(id)
            def user = userService.getUser()
            def userId = user?.userId

            def orgRole = members.find{it.userId == userId}

            [organisation: organisation,
             dashboard: dashboard,
             roles:roles,
             user:user,
             isAdmin:orgRole?.role == RoleService.PROJECT_ADMIN_ROLE,
             isGrantManager:orgRole?.role == RoleService.GRANT_MANAGER_ROLE]
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

    def getMembersForOrganisation(String id) {
        def adminUserId = userService.getCurrentUserId()

        if (id && adminUserId) {
            if (organisationService.isUserAdminForOrganisation(id) || organisationService.isUserGrantManagerForOrganisation(id)) {
                render organisationService.getMembersOfOrganisation(id) as JSON
            } else {
                render status:403, text: 'Permission denied'
            }
        } else if (adminUserId) {
            render status:400, text: 'Required params not provided: id'
        } else if (id) {
            render status:403, text: 'User not logged-in or does not have permission'
        } else {
            render status:500, text: 'Unexpected error'
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
