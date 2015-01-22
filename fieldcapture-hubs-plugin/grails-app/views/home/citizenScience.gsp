<%@ page import="grails.converters.JSON; au.org.ala.fieldcapture.SettingPageType" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="layout" content="${grailsApplication.config.layout.skin ?: 'main'}"/>
    <title><g:message code="g.citizenScience"/> | <g:message code="g.fieldCapture"/></title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <r:script disposition="head">
    var fcConfig = {
        baseUrl: "${grailsApplication.config.grails.serverURL}",
        spatialBaseUrl: "${grailsApplication.config.spatial.baseUrl}",
        spatialWmsCacheUrl: "${grailsApplication.config.spatial.wms.cache.url}",
        spatialWmsUrl: "${grailsApplication.config.spatial.wms.url}",
        sldPolgonDefaultUrl: "${grailsApplication.config.sld.polgon.default.url}",
        sldPolgonHighlightUrl: "${grailsApplication.config.sld.polgon.highlight.url}",
        dashboardUrl: "${g.createLink(controller: 'report', action: 'dashboardReport', params: params)}"
    }
    </r:script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <r:require modules="knockout,mapWithFeatures,jquery_bootstrap_datatable,js_iso8601,wmd"/>
</head>

<body>
<div id="wrapper" class="container-fluid">
    <div class="row-fluid">
        <div class="span6" id="heading">
            <h1 class="pull-left"><g:message code="home.citizenScience.heading"/></h1>
        </div>
        <g:if test="${user}">
            <div class="pull-right space-after">
                <button data-bind="click:newPortal" type="button" class="btn"><g:message
                        code="home.citizenScience.portalLink"/></button>
                <a href="${createLink(controller: 'project', action: 'create', params: [citizenScience: true])}"
                   class="btn btn-small">
                    <i class="icon-file"></i>&nbsp;<g:message code="home.citizenScience.registerLink"/></a>
            </div>
        </g:if>
    </div>

    <div class="row-fluid"><g:message code="home.citizenScience.preamble"/></div>

    <div class="row-fluid">
        <p class="pull-right" data-bind="visible: projects.length > 0"><g:message code="g.clickToSort"/></p>
    </div>

    <div class="row-fluid">
        <div class="span12">
            <h3 class="pull-left"><g:message code="home.citizenScience.tableHeading"/></h3>
        </div>
    </div>

    <div class="row-fluid">
        <div class="span12">
            <table class="table table-striped" id="projectsTable">
                <thead>
                <tr>
                    <th><g:message code="g.coverage"/></th>
                    <th><g:message code="g.project.name"/></th>
                    <th><g:message code="g.project.description"/></th>
                    <th><g:message code="g.org.name"/></th>
                    <th><g:message code="g.status"/></th>
                    <th><g:message code="g.website"/></th>
                    <th><g:message code="g.appsLinks"/></th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>
<r:script>
function moreOrLess(dom, more) {
    dom = $(dom).closest("DIV");
    dom.hide();
    if (more)
        dom.next().show();
    else
        dom.prev().show();
}
$(document).ready(function () {
    function moreless(text, maxLength) {
        if (text.length < maxLength) return text;
        return '<div>' + text.substring(0, maxLength - 4)
                + '... <a onclick="moreOrLess(this, true)"><g:message code="g.more"/></a></div><div style="display:none">'
                + text + '<a onclick="moreOrLess(this)"><g:message code="g.less"/></a></div>';
    }
    var markdown = new Showdown.converter();
    var ProjectVM = function (props) {
        var pid = props[0];
        this.coverage = props[1];
        this.description = markdown.makeHtml(props[2]);
        this.descriptionTrimmed = moreless(this.description, 100);
        this.editLink = props[3]? '<a href="${createLink(controller: 'project', action: 'edit')}/' + pid + '"><i class="icon-edit"></a>': '';
        this.name = '<a href="${createLink(controller: 'project', action: 'index')}/' + pid + '">' + props[4] + '</a>';
        this.organisationName = props[5];
        this.status = props[6];
        this.urlApps = props[7];
        this.urlWeb = props[8];
    }
	var dt = $('#projectsTable').DataTable( {
		columns: [
			{ data: 'coverage' },
			{ data: 'name' },
			{ data: 'descriptionTrimmed' },
			{ data: 'organisationName' },
			{ data: 'status' },
			{ data: 'urlWeb' },
			{ data: 'urlApps' },
			{ data: 'editLink' },
		],
		language: {
    		searchPlaceholder: "Enter a location, topic, organisation, or project"
		}
	} );
	dt.rows.add([
    <g:each var="p" in="${projects}">new ProjectVM(${p as JSON}),</g:each>
    ]).draw();
});
</r:script>
</body>
</html>