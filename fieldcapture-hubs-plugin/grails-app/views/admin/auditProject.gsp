<%@ page import="au.org.ala.fieldcapture.DateUtils" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="adminLayout"/>
		<title>Admin - Audit Project | Data capture | Atlas of Living Australia</title>
		<style type="text/css" media="screen">
		</style>
	</head>
	<body>
        <r:require modules="jquery_bootstrap_datatable"/>

        <div class="row">
            <a href="${createLink(action:'audit')}" class="btn"><i class="icon-backward"></i> Back</a>
        </div>

        <div class="row">
             <h3>Project Audit - ${project.name}</h3>
             <h4>Grant Id : ${project.grantId}</h4>
             <h4>External Id : ${project.externalId}</h4>
        </div>

        <div class="row well well-small">
            <g:if test="${messages}">
                <table style="width: 95%;" class="table table-striped table-bordered table-hover" id="project-list">
                    <thead>
                        <th>Date</th>
                        <th>Action</th>
                        <th>Type</th>
                        <th>Name</th>
                        <th>User</th>
                        <th></th>
                    </thead>
                    <tbody>
                        <g:each in="${messages}" var="message">
                            <tr>
                                <td>${DateUtils.displayFormatWithTime(message?.date)}</td>
                                <td>${message.eventType}</td>
                                <td>${message.entityType?.substring(message.entityType?.lastIndexOf('.')+1)}</td>
                                <td>${message.entity?.name} ${message.entity?.type} <small>(${message.entityId})</small></td>
                                <g:set var="displayName" value="${userMap[message.userId] ?: message.userId }" />
                                <td><g:encodeAs codec="HTML">${displayName}</g:encodeAs></td>
                                <td><a class="btn btn-small" href="${createLink(action:'auditMessageDetails', params:[id:message.id, compareId: message.entity.compareId])}">
                                        <i class="icon-search"></i>
                                    </a>
                                </td>
                            </tr>
                        </g:each>
                    </tbody>
                </table>

            </g:if>
            <g:else>
                <div>No messages found!</div>
            </g:else>
        </div>


    </body>
</html>

<r:script type="text/javascript">
    $(document).ready(function() {
        $('#project-list').DataTable({
            "bSort": false,
            "oLanguage": {
                "sSearch": "Filter by: "
            }
        });
        $('.dataTables_filter input').attr("placeholder", "Date, Action, Type, Name, User");
    });
</r:script>

