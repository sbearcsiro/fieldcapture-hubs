<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.layout.skin ?: 'main'}"/>
    <title>${project?.name?.encodeAsHTML()} | <g:message code="g.projects"/> | <g:message code="g.fieldCapture"/></title>
    <r:require modules="knockout,jqueryValidationEngine,datepicker"/>
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
<g:render template="details" model="${pageScope.variables}"/>
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
    $('#validation-container').validationEngine();
    $('.helphover').popover({animation: true, trigger:'hover'});

    var viewModel = ko.dataFor(document.getElementById("projectDetails"));
    $('#cancel').click(function () {
        document.location.href = viewModel.projectType() == 'simple'? "${createLink(controller: 'home', action: 'citizenScience')}" :
            "${createLink(action: 'index', id: project?.projectId)}";
    });
    $('#save').click(function () {
        viewModel.save();
    });
 });
</r:script>
</body>
</html>