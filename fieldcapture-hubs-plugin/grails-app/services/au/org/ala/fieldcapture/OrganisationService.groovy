package au.org.ala.fieldcapture

import org.codehaus.groovy.grails.web.json.JSONArray


class OrganisationService {

    def grailsApplication, webService, projectService, userService


    private def mapAttributesToCollectory(props) {
        def mapKeyEcoDataToCollectory = [
                description: 'pubDescription',
                name: 'name',
                mainImageDocument: '', // ignore this property
                projects: '', // ignore this property
                uploadConfig: '', // ignore this property
                organisationId: 'uid',
                url: 'websiteUrl'
        ]
        def collectoryProps = [
                api_key: grailsApplication.config.api_key
        ]
        def hiddenJSON = [:]
        props.each { k, v ->
            if (v != null) {
                def keyCollectory = mapKeyEcoDataToCollectory[k]
                if (keyCollectory == null) // not mapped to first class collectory property
                    hiddenJSON[k] = v
                else if (keyCollectory != '') // not to be ignored
                    collectoryProps[keyCollectory] = v
            }
        }
//        collectoryProps.hiddenJSON = hiddenJSON
//        println("collectory institution hiddenJSON = " + hiddenJSON)
        collectoryProps
    }

    def get(String id, view = '') {

        def url = "${grailsApplication.config.ecodata.baseUrl}organisation/$id?view=$view"
        def organisation = webService.getJson(url)


        organisation.projects = getProjectsByName(organisation)

        organisation
    }

    private def getProjectsByName(organisation) {
        def projects = new JSONArray()
        if (!organisation) {
            return projects
        }

        def resp = projectService.search([serviceProviderName:organisation.name, view:'enhanced'])

        if (resp?.resp?.projects) {
            projects.addAll(resp.resp.projects)
        }

        resp = projectService.search([organisationName:organisation.name, view:'enhanced'])

        if (resp?.resp?.projects) {
            projects.addAll(resp.resp.projects.findAll{it.serviceProviderName != organisation.name}) // Exclude duplicates.
        }
        projects
    }


    def list() {
        def url = "${grailsApplication.config.ecodata.baseUrl}organisation/"
        def organisations = webService.getJson(url)
        def institutions = webService.getJson("${grailsApplication.config.collectory.baseURL}ws/institution/")
        if (institutions instanceof List) {
            // create any institutions in collectory which are not yet in ecodata as an organisation
            def organisationsMap = [:]
            organisations.list.each {
                if (it.collectoryInstitutionId) organisationsMap.put(it.collectoryInstitutionId, it)
            }
            institutions.each({it ->
                if (!organisationsMap[it.uid]) {
                    def result = webService.doPost(url, [collectoryInstitutionId: it.uid,
                                                        name: it.name,
                                                        description: it.pubDescription?:"",
                                                        url: it.websiteUrl])
                    def orgId = result.resp?.organisationId
                    if (orgId) organisations.list.push(webService.getJson(url + orgId))
                }
            })
        }
        organisations
    }

    def update(id, organisation) {

        if (!id) { // create an institution in collectory to hold organisation meta data
            def collectoryProps = mapAttributesToCollectory(organisation)
            def result = webService.doPost(grailsApplication.config.collectory.baseURL + 'ws/institution/', collectoryProps)
            organisation.collectoryInstitutionId = webService.extractCollectoryIdFromHttpHeaders(result?.headers)
        }

        def url = "${grailsApplication.config.ecodata.baseUrl}organisation/$id"
        def result = webService.doPost(url, organisation)

        if (id) { // update existing institution in collectory to hold organisation meta data
            url = "${grailsApplication.config.ecodata.baseUrl}organisation/$id"
            organisation = webService.getJson(url)
            ['id','dateCreated','documents','lastUpdated','organisationId','projects','mainImageDocument','uploadConfig'].each { organisation.remove(it) }
            def collectoryProps = mapAttributesToCollectory(organisation)
            webService.doPost(grailsApplication.config.collectory.baseURL + 'ws/institution/' + organisation.collectoryInstitutionId, collectoryProps)
        }

        result
    }

    def isUserAdminForOrganisation(organisationId) {
        def userIsAdmin

        if (!userService.user) {
            return false
        }
        if (userService.userIsSiteAdmin()) {
            userIsAdmin = true
        } else {
            userIsAdmin = userService.isUserAdminForOrganisation(userService.user.userId, organisationId)
        }

        userIsAdmin
    }

    def isUserGrantManagerForOrganisation(organisationId) {
        def userIsAdmin

        if (!userService.user) {
            return false
        }
        if (userService.userIsSiteAdmin()) {
            userIsAdmin = true
        } else {
            userIsAdmin = userService.isUserGrantManagerForOrganisation(userService.user.userId, organisationId)
        }

        userIsAdmin
    }

    /**
     * Get the list of users (members) who have any level of permission for the requested organisationId
     *
     * @param organisationId the organisationId of interest.
     */
    def getMembersOfOrganisation(organisationId) {
        def url = grailsApplication.config.ecodata.baseUrl + "permissions/getMembersForOrganisation/${organisationId}"
        webService.getJson(url)
    }

    /**
     * Adds a user with the supplied role to the identified organisation.
     * Adds the same user with the same role to all of the organisation's projects.
     *
     * @param userId the id of the user to add permissions for.
     * @param organisationId the organisation to add permissions for.
     * @param role the role to assign to the user.
     */
    def addUserAsRoleToOrganisation(String userId, String organisationId, String role) {

        def organisation = get(organisationId, 'flat')
        userService.addUserAsRoleToOrganisation(userId, organisationId, role)
        organisation.projects.each {
            userService.addUserAsRoleToProject(userId, it.projectId, role)
        }
    }

    /**
     * Removes the user access with the supplied role from the identified organisation.
     * Removes the same user from all of the organisation's projects.
     *
     * @param userId the id of the user to remove permissions for.
     * @param organisationId the organisation to remove permissions for.

     */
    def removeUserWithRoleFromOrganisation(String userId, String organisationId, String role) {
        def organisation = get(organisationId, 'flat')
        userService.removeUserWithRoleFromOrganisation(userId, organisationId, role)
        organisation.projects.each {
            userService.removeUserWithRole(it.projectId, userId, role)
        }
    }

}
