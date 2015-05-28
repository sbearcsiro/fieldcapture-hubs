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

    def "The user can create a citizen science project"() {

        logout(browser)
        login(browser, "fc-te@outlook.com", "testing!")

        when: "navigate to the create project page"
        to ProjectDetails

        then: "blank"
        at ProjectDetails
    }
}
