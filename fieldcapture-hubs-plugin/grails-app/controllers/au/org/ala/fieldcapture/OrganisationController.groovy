package au.org.ala.fieldcapture

import grails.converters.JSON

class OrganisationController {

    def organisationService

    def list() {
        def organisations = organisationService.list()
        println organisations
        [organisations:organisations.list?:[]]
    }

    def index(String id) {
        def organisation = organisationService.get(id, 'all')

        [organisation:organisation]
    }

    def create() {
        render model:[organisation:[:]]
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
        def result = organisationService.update(organisationDetails.organisationId?:'', organisationDetails)

        if (result.error) {
            render result as JSON
        } else {
            //println "json result is " + (result as JSON)
            render result.resp as JSON
        }
    }
}
