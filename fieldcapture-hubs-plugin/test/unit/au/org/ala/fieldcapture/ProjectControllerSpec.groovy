package au.org.ala.fieldcapture

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * Specification for the ProjectController
 */
@TestFor(ProjectController)
class ProjectControllerSpec extends Specification {

    def userServiceStub = Stub(UserService)
    def metadataServiceStub = Stub(MetadataService)
    def projectServiceStub = Stub(ProjectService)

    void setup() {
        controller.userService = userServiceStub
        controller.metadataService = metadataServiceStub
        controller.projectService = projectServiceStub
        metadataServiceStub.organisationList() >> [list:[buildOrganisation(), buildOrganisation(), buildOrganisation()]]
        userServiceStub.getOrganisationIdsForUserId(_) >> ['1']
    }

    void "creating a citizen science project should pre-populate the citizen science project type"() {

        when:
        userServiceStub.getUser() >> [userId:'1234']

        params.citizenScience = true
        def model = controller.create()

        then:
        model.project.isCitizenScience == true
        model.project.projectType == 'survey'
    }

    void "creating a project should pre-populate the organisation if the user is a member of exactly one organisation"() {
        when:
        userServiceStub.getUser() >> [userId:'1234']

        def model = controller.create()

        then:
        model.project.organisationId == '1'
    }

    void "the create method should split the organisations into two lists for the convenience of the page"() {
        when:
        userServiceStub.getUser() >> [userId:'1234']

        def model = controller.create()

        then:
        model.userOrganisations.size() == 1
        model.userOrganisations[0].organisationId == '1'

        model.organisations.size() == 2
        ["2", "3"].each { orgId ->
            model.organisations.find{it.organisationId == orgId}.organisationId == orgId
        }
    }

    int orgCount = 0;
    private Map buildOrganisation() {
        [organisationId:Integer.toString(++orgCount), name:"Organisation ${orgCount}"]
    }

}
