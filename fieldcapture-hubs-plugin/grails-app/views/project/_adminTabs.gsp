<div class="tab-pane" id="admin">
    <!-- ADMIN -->
    <div class="row-fluid">
        <div class="span2 large-space-before">
            <ul id="adminNav" class="nav nav-tabs nav-stacked ">
                <li class='active'><a href="#projectSettings" id="projectDetails-tab" data-toggle="tab"><i class="icon-chevron-right"></i> Project settings</a></li>
                <li><a href="#projectActivity" id="projectActivity-tab" data-toggle="tab"><i class="icon-chevron-right"></i> Project surveys</a></li>
                <li><a href="#editNewsAndEvents" id="editnewsandevents-tab" data-toggle="tab"><i class="icon-chevron-right"></i> News and events</a></li>
                <li><a href="#editProjectStories" id="editProjectStories-tab" data-toggle="tab"><i class="icon-chevron-right"></i> Project stories</a></li>
            </ul>
        </div>
        <div class="span10">
            <div class="pill-content">

                <!-- PROJECT Settings -->
                <div id="projectSettings" class="pill-pane active">
                    <div class="row-fluid">
                        <p><button class="btn btn-small admin-action" data-bind="click:editProject"><i class="icon-edit"></i> Edit</button> Edit the project details and content</p>
                        <g:if test="${fc.userIsAlaOrFcAdmin()}"><p><button class="admin-action btn btn-small btn-danger" data-bind="click:deleteProject"><i class="icon-remove icon-white"></i> Delete</button> Delete this project. <strong>This cannot be undone</strong></p></g:if>
                    </div>

                    <h3>Project Access</h3>
                    <g:render template="/admin/addPermissions" model="[addUserUrl:g.createLink(controller:'user', action:'addUserAsRoleToProject'), entityId:project.projectId]"/>
                    <g:render template="/admin/permissionTable" model="[loadPermissionsUrl:g.createLink(controller:'project', action:'getMembersForProjectId', id:project.projectId), removeUserUrl:g.createLink(controller:'user', action:'removeUserWithRoleFromProject'), entityId:project.projectId, user:user]"/>
                </div>

                <div id="editNewsAndEvents" class="pill-pane">
                    <g:render template="editProjectContent" model="${[attributeName:'newsAndEvents', header:'News and events']}"/>
                </div>

                <div id="editProjectStories" class="pill-pane">
                    <g:render template="editProjectContent" model="${[attributeName:'projectStories', header:'Project stories']}"/>
                </div>

                <div id="projectActivity" class="pill-pane">
                    <g:render template="/projectActivity/pActivities" model="[projectActivities : projectActivities]" />
                </div>

            </div>
        </div>
    </div>
</div>