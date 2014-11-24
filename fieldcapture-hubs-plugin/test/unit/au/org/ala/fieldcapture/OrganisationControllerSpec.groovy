package au.org.ala.fieldcapture

import grails.converters.JSON
import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * Tests the OrganisationController class.
 */
@TestFor(OrganisationController)
class OrganisationControllerSpec extends Specification {

    def organisationService = Mock(OrganisationService)
    def searchService = Mock(SearchService)
    def documentService = Mock(DocumentService)

    def setup() {
        controller.organisationService = organisationService
        controller.searchService = searchService
        controller.documentService = documentService
    }

    def "retrieve an organisation by id"() {

        given:
        def testOrg = testOrganisation()
        organisationService.get(_,_) >> testOrg
        searchService.dashboardReport(_) >> [:]

        when:
        def model = controller.index('id')

        then:
        model.organisation == testOrg
        model.dashboard == [:]
    }

    def "retrieve an organisation that doesn't exist"() {
        given:
        organisationService.get(_) >> null

        when:
        controller.index('missing id')

        then:
        response.redirectedUrl == '/home'
        flash.message != null
    }

    def "edit an organisation"() {
        given:
        def testOrg = testOrganisation()
        organisationService.get(_) >> testOrg

        when:
        def model = controller.edit('id')

        then:
        model.organisation == testOrg
    }

    def "edit an organisation that doesn't exist"() {
        given:
        organisationService.get(_) >> null

        when:
        controller.edit('missing id')

        then:
        response.redirectedUrl == '/home'
        flash.message != null
    }


    def "soft delete an organisation"() {
        when:
        controller.ajaxDelete('id')
        then:
        1 * organisationService.update('id', [status:'deleted'])
    }

    def "update an organisation successfully"() {

        setup:
        def document = [organisationId: 'id', name:'name', description:'description']
        def organisation = testOrganisation()
        organisation.documents = [document]
        request.json = (organisation as JSON).toString()
        request.addHeader('Accept', 'application/json')
        request.format = 'json'

        when:
        controller.ajaxUpdate()
        println response.status

        then:

        1 * organisationService.update('id', _) >> [resp:[organisationId:'id']]
        1 * documentService.saveStagedImageDocument(document) >> [:]
        response.json.organisationId == 'id'
    }

    private Map testOrganisation() {
        def org = [organisationId:'id', name:'name', description:'description']

        return org
    }
}
