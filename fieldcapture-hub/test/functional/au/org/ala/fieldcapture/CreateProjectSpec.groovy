package au.org.ala.fieldcapture

import geb.spock.GebReportingSpec
import spock.lang.Stepwise

@Stepwise
class CreateProjectSpec extends GebReportingSpec {

    def "Blah"() {

        logout(browser)
        login(browser, "fc-te@outlook.com", "testing!")

        when: "go to new activity page"
        def projectId = "cb5497a9-0f36-4fef-9f6a-9ea832c5b68c"
        via AddActivityPage, projectId:projectId

        then:
        at ProjectIndex
    }
}
