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
