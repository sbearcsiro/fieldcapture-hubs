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
        imageLocation:"${resource(dir:'/images/filetypes')}",
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
    <li><g:link controller="project" action="index"
                id="${project.projectId}">${project.name?.encodeAsHTML()}</g:link> <span class="divider">/</span>
    </li>
    <li class="active"><g:message code="g.edit"/></li>
</ul>
<form id="projectDetails" class="form-horizontal">
    <g:set var="template" value="${project.isCitizenScience?'externalCitizenScienceProjectDetails':'details'}"/>
    <g:render template="${template}" model="${pageScope.variables}"/>
</form>
<div class="form-actions">
    <button type="button" id="save" class="btn btn-primary"><g:message code="g.save"/></button>
    <button type="button" id="cancel" class="btn"><g:message code="g.cancel"/></button>
</div>

<g:if env="development">
    <hr/>

    <div class="expandable-debug">
        <h3>Debug</h3>

        <div>
            <h4>KO model</h4>
            <pre data-bind="text:ko.toJSON($root,null,2)"></pre>
            <h4>Project</h4>
            <pre>${project.encodeAsHTML()}</pre>
            <label class="control-label" for="currentStage">Current stage of project</label>
            <!-- later this will be a dropdown to pick from activity stages -->
            <g:textField class="" name="currentStage" data-bind="value:currentStage"/>
        </div>
    </div>
    </div>
</g:if>
</div>
<r:script>
$(function(){

    function initViewModel() {

        function ViewModel (data, activityTypes, organisations) {
            var self = this;
            $.extend(self, new ProjectViewModel(data, true, organisations));

            self.save = function () {
                if ($('#projectDetails').validationEngine('validate')) {

                    var json = viewModel.modelAsJSON();
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
            };
        }

        var programsModel = <fc:modelAsJavascript model="${programs}"/>;
        var organisations = <fc:modelAsJavascript model="${organisations?:[]}"/>;
        var activityTypes = JSON.parse('${(activityTypes as grails.converters.JSON).toString().encodeAsJavaScript()}');
        var project = <fc:modelAsJavascript model="${project?:[:]}"/>;
        var viewModel =  new ViewModel(project, activityTypes, organisations);
        viewModel.loadPrograms(programsModel);
        return viewModel;
    };

    $('#projectDetails').validationEngine();
    $('.helphover').popover({animation: true, trigger:'hover'});

    var viewModel = initViewModel();
    initEditDocumentLinks(viewModel); // used by shared/_editDocumentLinks.gsp template
    viewModel.projectSite = initSiteViewModel();
    viewModel.projectSite.name = ko.computed(function() {
        return 'Project area for '+viewModel.name();
    });
    viewModel.projectSite.type("projectArea");
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
        viewModel.save();
    });
 });
</r:script>

</body>
</html>