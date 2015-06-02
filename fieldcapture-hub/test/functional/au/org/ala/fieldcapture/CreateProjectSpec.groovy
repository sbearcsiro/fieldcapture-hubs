package au.org.ala.fieldcapture

import pages.ProjectDetails
import pages.EntryPage

import spock.lang.Stepwise

@Stepwise
class CreateProjectSpec extends FieldcaptureFunctionalTest {

    def "The user must be logged in to create a project"() {

        logout(browser)

        when: "attempt to create a project"
        via ProjectDetails

        then: "redirected to the home page with an error"
        at EntryPage
    }

    def "If the user is not a member of an organisation then they must select one via a search"() {
        logout(browser)
        login(browser, "fc-te@outlook.com", "testing!")

        given: "navigate to the create project page"
        to ProjectDetails, citizenScience:true

        expect:
        at ProjectDetails
        organisation.organisationName == ''

        when: "search for an organisation"
        organisation.organisationName = "Test"

        then: "The available organisations have been narrowed"


        when: "an organisation is selected"
        organisation.selectOrganisation("Test 1")

        then: "The search field is disabled and updated to match the organisation name"
        organisationName == "Test 1"
        organisationName.is(":disabled")

    }

    def "The user can create a citizen science project"() {

        logout(browser)
        login(browser, "fc-te@outlook.com", "testing!")

        given: "navigate to the create project page"
        to ProjectDetails, citizenScience:true

        expect:
        at ProjectDetails

        when: "enter project details"
        //projectType = 'Citizen Science Project' // The field should be pre-selected and disabled
        recordUsingALA = 'Yes'
        organisationName = 'Type Something here'

        submit()

        then: "at the newly created project page"
        waitFor { at ProjectIndex }


    }
}
