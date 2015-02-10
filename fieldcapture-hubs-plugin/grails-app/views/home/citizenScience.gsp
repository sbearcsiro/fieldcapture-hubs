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
    <r:require modules="knockout,projectsTable,js_iso8601,wmd"/>
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
    <div id="pt-root" class="span9">
        <div class="well">
            <div class="row-fluid">
                    <span id="pt-resultsReturned"></span>
                    <div class="input-append">
                        <input type="text" name="pt-search" id="pt-search"/>
                        <a href="javascript:void(0);" title="Only show projects which contain the search term" id="pt-search-link" class="btn"><g:message code="g.search" /></a>
                        <a href="javascript:void(0);" id="pt-reset"><a href="javascript:reset()" title="Remove all filters and sorting options" class="btn"><g:message code="g.reset" /></a></a>
                    </div>
                <a href="#" id="pt-downloadLink" class="btn pull-right"
                   title="Download metadata for projects in JSON format">
                    <i class="icon-download"></i><g:message code="g.download" /></a>
            </div>
            <div id="pt-searchControls">
                <div id="pt-sortWidgets" class="row-fluid">
                    <div class="span4">
                        <label for="pt-per-page"><g:message code="g.projects"/>&nbsp;<g:message code="g.perPage"/></label>
                        <g:select id="pt-per-page" name="pt-per-page" from="${[10,20,50,100,500]}" value="${pageSize ?: 20}"/>
                    </div>
                    <div class="span4">
                        <label for="pt-sort"><g:message code="g.sortBy" /></label>
                        <g:select id="pt-sort" name="pt-sort" from="${['name','description','organisationName','status']}"/>
                    </div>
                    <div class="span4">
                        <label for="pt-dir"><g:message code="g.sortOrder" /></label>
                        <g:select id="pt-dir" name="pt-dir" from="${['ascending','descending']}"/>
                    </div>
                </div>
            </div><!--drop downs-->
        </div>

        <div id="pt-results">
            <div id="pt-loading"><g:message code="project.table.loading" /> ..</div>
        </div>

        <div id="pt-searchNavBar" class="clearfix">
            <div id="pt-navLinks"></div>
        </div>
    </div>
</div>
<r:script>
    $(document).ready(function () {
        loadProjectsdTable([
            <g:each var="p" in="${projects}">${p as JSON},</g:each>
        ]);
    });
</r:script>
</body>
</html>