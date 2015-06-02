package pages

import geb.Module
import geb.Page
import geb.navigator.Navigator
import org.openqa.selenium.Keys

class ProjectDetails extends Page {

    static url = "project/create"

    static at = { title == "Create | Project | Field Capture"}

    static content = {
        projectType { $('[data-bind~=value:projectType]') }
        recordUsingALA { $('[data-bind~=booleanValue:isExternal]') }
        organisation { module OrganisationSearch }
        name { $('[data-bind~=value:name]') }
        description { $('[data-bind~=value:name]') }
        contactEmailAddress { $('') }
        plannedStartDate { $('#plannedStartDate') }
        plannedEndDate { $('#plannedEndDate') }
        getInvolved { $('[data-bind~=value:getInvolved]') }
        scienceType { $('[data-bind~=value:scienceType]') }

        saveButton { $('#save') }
        cancelButton { $('#cancel') }

    }

    def setDate(Navigator dateField, String date) {
        dateField.value(date)
        dateField << Keys.chord(Keys.ENTER) // Dismisses the popup calendar
    }
    // Pressing submit actually does an ajax call then changes the page using JavaScript.
    def save() {
        saveButton.click()
    }
    def cancel() {
        cancelButton.click()
    }
}


class OrganisationSearch extends Module {
    static content = {
        organisationName { $('#organisationName')}
        results {}
        notOnList { $('[data-bind~=checked:organisationNotPresent') }
        clearButton {$('[data-bind~=click:clearSelection')}
        registerButton {$('#registerOrganisation')}
    }
    def clearSelection() {
        clearButton.click()
    }

    def selectOrganisation(name) {
        $('a [data-bind~=text:'+name+']').click()
    }

}

