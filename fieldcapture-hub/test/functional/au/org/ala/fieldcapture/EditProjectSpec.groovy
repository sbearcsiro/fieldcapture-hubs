package au.org.ala.fieldcapture

import pages.EditProject
import spock.lang.Stepwise

/**
 * Specification for the edit project use case.
 */
@Stepwise
class EditProjectSpec extends FieldcaptureFunctionalTest {

    def setup() {
        useDataSet("data-set-1")
    }


    def "edit a project"() {

        setup:
        logout(browser)
        login(browser, "fc-ta@outlook.com", "testing!")
        def projectId = '9c99e298-1af3-4d46-aef2-470f9ec0277a' // From data-set-1

        when:
        to EditProject, id:projectId

        then:
        organisation.organisationName == 'Test organisation 3'


    }
}
