package au.org.ala.fieldcapture

import geb.Browser
import geb.spock.GebReportingSpec
import org.openqa.selenium.Cookie
import pages.EntryPage
import pages.LoginPage

/**
 * Helper class for functional tests in fieldcapture.  Contains common actions such as logging in and logging out.
 */
class FieldcaptureFunctionalTest extends GebReportingSpec {

    /**
     * This method will drop the ecodata-test database, then load the data stored in the
     * test/functional/resources/${dataSetName} directory.
     * It is intended to ensure the database is in a known state to facilitate functional testing.
     * If the loading script fails, an Exception will be thrown.
     *
     * N.B. Running the script requires the current working directory to be the root of the fieldcapture-hub project.
     * (Which should be the case unless the tests are being run via an IDE)
     *
     * @param dataSetName identifies the data set to load.
     *
     */
    void useDataSet(String dataSetName) {
        println "pwd".execute().text

        int exitCode = "scripts/loadFunctionalTestData.sh ${dataSetName}".execute().waitFor()
        if (exitCode != 0) {
            throw new RuntimeException("Loading data set ${dataSetName} failed.  Exit code: ${exitCode}")
        }
    }

    def login(Browser browser, username, password) {

        browser.to LoginPage, service: getConfig().baseUrl+EntryPage.url
        browser.page.username = username
        browser.page.password = password
        browser.page.submit()

        browser.at EntryPage

        browser.driver.manage().addCookie(new Cookie("hide-intro", "1"))
    }

    def logout(Browser browser) {
        browser.go 'https://auth.ala.org.au/cas/logout'

    }
}
