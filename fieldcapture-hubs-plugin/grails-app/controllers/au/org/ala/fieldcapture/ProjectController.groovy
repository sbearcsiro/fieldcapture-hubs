package au.org.ala.fieldcapture
import grails.converters.JSON
import org.joda.time.DateTime

class ProjectController {

    def projectService, metadataService, organisationService, commonService, activityService, userService, webService, roleService, grailsApplication
    def siteService, documentService
    static defaultAction = "index"
    static ignore = ['action','controller','id']

    def index(String id) {
        session.removeAttribute('citizenScienceOrgId')
        def project = projectService.get(id, 'brief')
        def roles = roleService.getRoles()

        if (!project || project.error) {
            flash.message = "Project not found with id: ${id}"
            if (project?.error) {
                flash.message += "<br/>${project.error}"
                log.warn project.error
            }
            redirect(controller: 'home', model: [error: flash.message])
        } else {
            project.sites?.sort {it.name}
            def user = userService.getUser()
            def members = projectService.getMembersForProjectId(id)
            def admins = members.findAll{ it.role == "admin" }.collect{ it.userName }.join(",") // comma separated list of user email addresses

            if (user) {
                user.metaClass.isAdmin = projectService.isUserAdminForProject(user.userId, id)?:false
                user.metaClass.isCaseManager = projectService.isUserCaseManagerForProject(user.userId, id)?:false
                user.metaClass.isEditor = projectService.canUserEditProject(user.userId, id)?:false
                user.metaClass.hasViewAccess = projectService.canUserViewProject(user.userId, id)?:false
            }
            def model = [project: project,
             activities: activityService.activitiesForProject(id),
             mapFeatures: commonService.getMapFeatures(project),
             isProjectStarredByUser: userService.isProjectStarredByUser(user?.userId?:"0", project.projectId)?.isProjectStarredByUser,
             user: user,
             roles: roles,
             admins: admins,
             activityTypes: projectService.activityTypesList(),
             metrics: projectService.summary(id),
             outputTargetMetadata: metadataService.getOutputTargetsByOutputByActivity(),
             organisations: organisationService.list().list,
             programs: projectService.programsModel(),
             today:DateUtils.format(new DateTime()),
             themes:metadataService.getThemesForProject(project)
            ]

            render view:projectView(project), model:model
        }
    }

    private String projectView(project) {
        if (project.isExternal) {
            if (project.isCitizenScience) {
                return 'externalCitizenScienceProjectTemplate'
            }
        }
        return project.projectType == 'survey'?'citizenScienceProjectTemplate':'index'
    }

    @PreAuthorise
    def edit(String id) {
        session.removeAttribute('citizenScienceOrgId')
        def project = projectService.get(id, 'all')
        def organisations = organisationService.list()
        if (project) {
            def siteInfo = siteService.getRaw(project.projectSiteId)
            [project: project,
             siteDocuments: siteInfo.documents?:'[]',
             site: siteInfo.site,
             organisations: organisations.list,
             programs: metadataService.programsModel()]
        } else {
            forward(action: 'list', model: [error: 'no such id'])
        }
    }

    def create() {
        def user = userService.getUser()
        if (!user) {
            flash.message = "You do not have permission to perform that operation"
            redirect controller: 'home', action: 'index'
        }

        def csOrgId = session.getAttribute('citizenScienceOrgId')?: ""

        // Prepopulate the project as appropriate.
        def project = [:]
        if (params.organisationId) {
            project.organisationId = params.organisationId
        }
        if (csOrgId) {
            project.isCitizenScience = true
        }
        def userOrgIds = userService.getOrganisationIdsForUserId(user.userId)
        def organisations = metadataService.organisationList().list ?: []
        def groupedOrganisations = organisations.groupBy{organisation -> organisation.organisationId in userOrgIds ? "user" : "other"}

        // Default the project organisation if the user is a member of a single organisation.
        if (userOrgIds.size() == 1) {
            project.organisationId = userOrgIds[0]
        }
        session.removeAttribute('citizenScienceOrgId')
        [
                citizenScienceOrgId: csOrgId,
                organisationId: params.organisationId,
                siteDocuments: '[]',
                userOrganisations: groupedOrganisations.user ?: [],
                organisations: groupedOrganisations.other ?: [],
                programs: projectService.programsModel(),
                activityTypes: metadataService.activityTypesList(),
                project:project
        ]
    }

    def citizenScience() {
        def today = new Date()
        def user = userService.getUser()
        def userId = user?.userId
        def projects = projectService.list(false, true).collect {
            def urlImage
            it.documents.each { doc ->
                if (doc.role == documentService.ROLE_LOGO)
                    urlImage = doc.url
                else if (!urlImage && doc.isPrimaryProjectImage)
                    urlImage = doc.url
            }
            [
                projectId  : it.projectId,
                coverage   : it.coverage ?: '',
                description: it.description,
                isActive   : !it.actualEndDate || it.actualEndDate >= today,
                isEditable : userId && projectService.canUserEditProject(userId, it.projectId),
                isExternal : it.isExternal && true, // force it to boolean
                links      : it.links,
                name       : it.name,
                organisationId: it.organisationId,
                organisationName: it.organisationName ?: organisationService.getNameFromId(it.organisationId),
                status     : it.status,
                urlImage   : urlImage,
                urlWeb     : it.urlWeb
            ]
        }
        if (params.download as boolean) {
            response.setHeader("Content-Disposition","attachment; filename=\"projects.json\"");
            // This is returned to the browswer as a text response due to workaround the warning
            // displayed by IE8/9 when JSON is returned from an iframe submit.
            response.setContentType('text/plain;charset=UTF8')
            def resultJson = projects as JSON
            render resultJson.toString()
        } else {
            [
                user: user,
                projects: projects.collect {
                    // pass array instead of object to reduce JSON size
                    [it.projectId,
                     it.coverage,
                     it.description,
                     it.isActive,
                     it.isEditable,
                     it.isExternal,
                     it.name,
                     it.organisationId,
                     it.organisationName,
                     it.status,
                     it.urlImage,
                     it.urlWeb,
                     it.links
                    ]
                }
            ]
        }
    }

    /**
     * Updates existing or creates new output.
     *
     * If id is blank, a new project will be created
     *
     * @param id projectId
     * @return
     */
    def ajaxUpdate(String id) {
        def postBody = request.JSON
        log.debug "Body: ${postBody}"
        log.debug "Params: ${params}"
        def values = [:]
        // filter params to remove keys in the ignore list
        postBody.each { k, v ->
            if (!(k in ignore)) {
                values[k] = v
            }
        }

        // The rule currently is that anyone is allowed to create a project so we only do these checks for
        // existing projects.
        def userId = userService.getUser()?.userId
        if (id) {
            if (!projectService.canUserEditProject(userId, id)) {
                render status:401, text: "User ${userId} does not have edit permissions for project ${id}"
                log.debug "user not caseManager"
                return
            }

            if (values.containsKey("planStatus") && values.planStatus =~ /approved/) {
                // check to see if user has caseManager permissions
                if (!projectService.isUserCaseManagerForProject(userId, id)) {
                    render status:401, text: "User does not have caseManager permissions for project"
                    log.warn "User ${userId} who is not a caseManager attempting to change planStatus for project ${id}"
                    return
                }
            }
        } else if (!userId) {
            render status: 401, text: 'You do not have permission to create a project'
        }


        log.debug "json=" + (values as JSON).toString()
        log.debug "id=${id} class=${id?.getClass()}"
        def projectSite = values.remove("projectSite")
        def documents = values.remove('documents')
        def links = values.remove('links')
        def result = id? projectService.update(id, values): projectService.create(values)
        log.debug "result is " + result
        if (documents && !result.error) {
            if (!id) id = result.resp.projectId
            documents.each { doc ->
                doc.projectId = id
                doc.isPrimaryProjectImage = doc.role == 'mainImage'
                if (doc.isPrimaryProjectImage) doc.public = true
                documentService.saveStagedImageDocument(doc)
            }
        }
        if (links && !result.error) {
            if (!id) id = result.resp.projectId
            links.each { link ->
                link.projectId = id
                documentService.saveLink(link)
            }
        }
        if (projectSite && !result.error) {
            if (!id) id = result.resp.projectId
            if (!projectSite.projects)
                projectSite.projects = [id]
            else if (!projectSite.projects.contains(id))
                projectSite.projects += id
            def siteResult = siteService.updateRaw(values.projectSiteId, projectSite)
            if (siteResult.status == 'error')
                result = [error:'SiteService failed']
            else if (siteResult.status == 'created') {
                def updateResult = projectService.update(id, [projectSiteId: siteResult.id])
                if (updateResult.error) result = updateResult
            }
        }
        if (result.error) {
            render result as JSON
        } else {
            //println "json result is " + (result as JSON)
            render result.resp as JSON
        }
    }




    @PreAuthorise
    def update(String id) {
        //params.each { println it }
        projectService.update(id, params)
        chain action: 'index', id: id
    }

    @PreAuthorise(accessLevel = 'admin')
    def delete(String id) {
        projectService.delete(id)
        forward(controller: 'home')
    }

    def list() {
        // will show a list of projects
        // but for now just go home
        forward(controller: 'home')
    }

    def species(String id) {
        def project = projectService.get(id, 'brief')
        def activityTypes = metadataService.activityTypesList();
        render view:'/species/select', model: [project:project, activityTypes:activityTypes]
    }

    /**
     * Star or unstar a project for a user
     * Action is determined by the URI endpoint, either: /add | /remove
     *
     * @return
     */
    def starProject() {
        String act = params.id?.toLowerCase() // rest path starProject/add or starProject/remove
        String userId = params.userId
        String projectId = params.projectId

        if (act && userId && projectId) {
            if (act == "add") {
                render userService.addStarProjectForUser(userId, projectId) as JSON
            } else if (act == "remove") {
                render userService.removeStarProjectForUser(userId, projectId) as JSON
            } else {
                render status:400, text: 'Required endpoint (path) must be one of: add | remove'
            }
        } else {
            render status:400, text: 'Required params not provided: userId, projectId'
        }
    }

    def getMembersForProjectId() {
        String projectId = params.id
        def adminUserId = userService.getCurrentUserId()

        if (projectId && adminUserId) {
            if (projectService.isUserAdminForProject(adminUserId, projectId) || projectService.isUserCaseManagerForProject(adminUserId, projectId)) {
                render projectService.getMembersForProjectId(projectId) as JSON
            } else {
                render status:403, text: 'Permission denied'
            }
        } else if (adminUserId) {
            render status:400, text: 'Required params not provided: id'
        } else if (projectId) {
            render status:403, text: 'User not logged-in or does not have permission'
        } else {
            render status:500, text: 'Unexpected error'
        }
    }

    @PreAuthorise(accessLevel = 'siteAdmin', redirectController ='home', redirectAction = 'index')
    def downloadProjectData() {
        String projectId = params.id

        if (!projectId) {
            render status:400, text: 'Required params not provided: id'
        }
        else{
            def path = "project/downloadProjectData/${projectId}"

            if (params.view == 'xlsx' || params.view == 'json') {
                path += ".${params.view}"
            }else{
                path += ".json"
            }
            def url = grailsApplication.config.ecodata.baseUrl + path
            webService.proxyGetRequest(response, url, true, true,120000)
        }
    }
}
