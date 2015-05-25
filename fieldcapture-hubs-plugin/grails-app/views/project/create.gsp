<%@ page import="net.sf.json.JSON; org.codehaus.groovy.grails.web.json.JSONArray" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title>${project?.name?.encodeAsHTML()} | <g:message code="g.projects"/> | <g:message code="g.fieldCapture"/></title>
    <r:script disposition="head">
    var fcConfig = {
        organisationLinkBaseUrl: "${createLink(controller: 'organisation', action: 'index')}",
        spatialService: '${createLink(controller:'proxy',action:'feature')}',
        intersectService: "${createLink(controller: 'proxy', action: 'intersect')}",
        featuresService: "${createLink(controller: 'proxy', action: 'features')}",
        featureService: "${createLink(controller: 'proxy', action: 'feature')}",
        spatialWms: "${grailsApplication.config.spatial.geoserverUrl}",
        geocodeUrl: "${grailsApplication.config.google.geocode.url}",
        siteMetaDataUrl: "${createLink(controller:'site', action:'locationMetadataForPoint')}",
        returnTo: "${createLink(controller: 'project', action: 'index', id: project?.projectId)}"
        },
        here = window.location.href;

    </r:script>
    <r:require modules="knockout,jqueryValidationEngine,datepicker,amplify,drawmap,jQueryFileUpload,projects"/>
</head>

<body>
<div class="container-fluid validationEngineContainer" id="validation-container">

<ul class="breadcrumb">
    <li><g:link controller="home"><g:message code="g.home"/></g:link> <span class="divider">/</span></li>

    <li class="active">Create Project</li>
</ul>
<form id="projectDetails" class="form-horizontal">
    <g:set var="template" value="${params.citizenScience?'externalCitizenScienceProjectDetails':'details'}"/>
    <g:render template="${template}" model="${pageScope.variables}"/>
</form>
<div class="form-actions">
    <button type="button" id="save" class="btn btn-primary"><g:message code="g.save"/></button>
    <button type="button" id="cancel" class="btn"><g:message code="g.cancel"/></button>
</div>

</div>
<r:script>
$(function(){

    function initViewModel() {

        var programsModel = <fc:modelAsJavascript model="${programs}"/>;
        var organisations = <fc:modelAsJavascript model="${organisations?:[]}"/>;
        var activityTypes = JSON.parse('${(activityTypes as grails.converters.JSON).toString().encodeAsJavaScript()}');
        var project = <fc:modelAsJavascript model="${project?:[:]}"/>;
        var viewModel =  new ProjectViewModel(project, true, organisations);
        viewModel.loadPrograms(programsModel);
        return viewModel;
    };

    $('#projectDetails').validationEngine();
    $('.helphover').popover({animation: true, trigger:'hover'});

    var viewModel = initViewModel();
    var siteViewModel = initSiteViewModel({type:'projectArea'});
    siteViewModel.name = ko.computed(function() {
        return 'Project area for '+viewModel.name();
    });

    $("#siteType").prop("disabled", 'disabled');
    ko.applyBindings(viewModel, document.getElementById("projectDetails"));
    $('#cancel').click(function () {
    <g:if test="${citizenScience}">
        document.location.href = "${createLink(action: 'citizenScience')}";
    </g:if>
    <g:else>
        document.location.href = "${createLink(action: 'index', id: project?.projectId)}";
    </g:else>
    });
    $('#save').click(function () {
        if ($('#projectDetails').validationEngine('validate')) {

            var projectData = viewModel.toJS();
            var siteData = siteViewModel.toJS();
            var documents = ko.mapping.toJS(viewModel.documents());

            // Assemble the data into the package expected by the service.
            projectData.projectSite = siteData;
            projectData.documents = documents;

            var json = JSON.stringify(projectData);
            var id = "${project?.projectId ? '/' + project.projectId : ''}";
            $.ajax({
                url: "${createLink(action: 'ajaxUpdate')}" + id,
                type: 'POST',
                data: json,
                contentType: 'application/json',
                success: function (data) {
                    if (data.error) {
                        alert(data.detail + ' \n' + data.error);
                    } else {
                        var projectId = "${project?.projectId}" || data.projectId;
                        document.location.href = "${createLink(action: 'index')}/" + projectId;

                    }
                },
                error: function (data) {
                    alert('An unhandled error occurred: ' + data.status);
                }
            });
        }
    });
 });
</r:script>

</body>
</html>