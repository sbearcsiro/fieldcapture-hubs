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
    def siteServiceMock = Mock(SiteService)

    void setup() {
        controller.userService = userServiceStub
        controller.metadataService = metadataServiceStub
        controller.projectService = projectServiceStub
        controller.siteService = siteServiceMock
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

    void "the edit method should overwrite the project organisation if returning from the create organisation workflow"() {
        def siteId = 'site1'

        when:
        def projectId = 'project1'
        userServiceStub.getUser() >> [userId:'1234']
        projectServiceStub.get(projectId, _) >> [organisationId:'org1', projectId:projectId, name:'Test', projectSiteId:siteId]

        params.organisationId = 'org2'
        def model = controller.edit(projectId)

        then:
        1 * siteServiceMock.getRaw(siteId) >> [:]
        model.project.projectId == projectId
        model.project.organisationId == 'org2'
    }

    void "the edit method should split the organisations into two lists for the convenience of the page"() {
        def siteId = 'site1'

        when:
        def projectId = 'project1'
        userServiceStub.getUser() >> [userId:'1234']
        projectServiceStub.get(projectId, _) >> [organisationId:'org1', projectId:projectId, name:'Test', projectSiteId:siteId]
        def model = controller.edit(projectId)

        then:
        1 * siteServiceMock.getRaw(siteId) >> [:]
        model.userOrganisations.size() == 1
        model.userOrganisations[0].organisationId == '1'

        model.organisations.size() == 2
        ["2", "3"].each { orgId ->
            model.organisations.find{it.organisationId == orgId}.organisationId == orgId
        }
        model.project.projectId == projectId
        model.project.organisationId == 'org1'
        model.project.name == 'Test'
    }

    int orgCount = 0;
    private Map buildOrganisation() {
        [organisationId:Integer.toString(++orgCount), name:"Organisation ${orgCount}"]
    }

}
