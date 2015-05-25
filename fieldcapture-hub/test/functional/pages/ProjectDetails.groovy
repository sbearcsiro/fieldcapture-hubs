package pages

import geb.Module
import geb.Page

class ProjectDetails extends Page {

    static url = "project/create"

    static at = { title == "Create | Project | Field Capture"}

    static content = {
        projectType { module ProjectType }
        organisation { module OrganisationSearch }
    }

    // Pressing submit actually does an ajax call then changes the page using JavaScript.
    def save() {
        saveButton.click()
    }
    def cancel() {

    }
}

class ProjectType extends Module {

    static content = {
        type { $('[data-bind~=value:projectType]') }
        recordUsingALA { $('[data-bind~=value:isExternal]') }
    }
}

class OrganisationSearch extends Module {
    static content = {
        organisationName { $('[]')}
        results {}
        notOnList {}
        registerButton {}
    }
}

