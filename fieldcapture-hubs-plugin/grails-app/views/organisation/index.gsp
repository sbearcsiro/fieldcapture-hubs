<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
    <title>${organisation.name.encodeAsHTML()} | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>

    <r:script disposition="head">
        var fcConfig = {
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            viewProjectUrl: "${createLink(controller:'project', action:'index')}",
            documentUpdateUrl: '${g.createLink(controller:"proxy", action:"documentUpdate")}',
            documentDeleteUrl: '${g.createLink(controller:"proxy", action:"deleteDocument")}',
            organisationDeleteUrl: '${g.createLink(action:"ajaxDelete", id:"${organisation.organisationId}")}',
            organisationEditUrl: '${g.createLink(action:"edit", id:"${organisation.organisationId}")}',
            organisationListUrl: '${g.createLink(action:"list")}',
            dashboardUrl: "${g.createLink(controller: 'report', action: 'dashboardReport', params: params)}"
            };
    </r:script>
    <r:require modules="wmd,knockout,mapWithFeatures,amplify,organisation"/>

</head>
<body>


    <div class="container-fluid organisation-header organisation-banner" data-bind="style:{'backgroundImage':bannerUrl}">
        <div class="row-fluid">
            <ul class="breadcrumb">
                <li>
                    <g:link controller="home">Home</g:link> <span class="divider">/</span>
                </li>
                <li class="active"><g:link controller="organisation" action="list">Organisations</g:link> <span class="divider">/</span></li>
                <li class="active" data-bind="text:name"/>
            </ul>
            <button class="btn pull-right btn-warn" data-bind="click:deleteOrganisation"><i class="icon-remove"></i> Delete</button>
            <button class="btn pull-right" data-bind="click:editOrganisation"><i class="icon-edit"></i> Edit</button>

            <h2 data-bind="text:name"></h2>

        </div>
    </div>
    <div class="container-fluid">

        <div class="row-fluid" data-bind="template:detailsTemplate"></div>


        <div class="row-fluid">
            <ul class="nav nav-tabs" data-tabs="tabs">
                <li class="active tab"><a id="project-tab" data-toggle="tab" href="#projects">Projects</a></li>
                <li class="tab"><a id="dashboard-tab" data-toggle="tab" href="#dashboard">Dashboard</a></li>
            </ul>
        </div>
    </div>

<div class="tab-content">
    <div class="tab-pane active" id="projects">
            <g:render template="/shared/projectsList"/>
    </div>

    <div class="tab-pane" id="dashboard">
        <div class="loading-message">
            <r:img dir="images" file="loading.gif" alt="saving icon"/> Loading...
        </div>
    </div>

</div>



<script id="hasMainImageTemplate" type="text/html">
    <span class="span3">
        <img data-bind="attr:{src:mainImageUrl}" style="width:100%;">
    </span>

    <span class="span6">
        <h4>Description</h4>
        <div class="well" data-bind="html:description.markdownToHtml()"></div>
        <div class="smallFont" data-bind="visible:url()">Learn more at: <a data-bind="attr:{href:url}"><span data-bind="text:url"></span></a></div>
    </span>
    <span class="span3">
        <h4>News and events</h4>
        <div class="well" data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'Nothing at this time'"></div>

    </span>
</script>
<script id="noMainImageTemplate" type="text/html">
    <span class="span9">
        <h4>Description</h4>
        <div class="well" data-bind="html:description.markdownToHtml()"></div>
        <div class="smallFont" data-bind="visible:url()">Learn more at: <a data-bind="attr:{href:url}"><span data-bind="text:url"></span></a></div>

    </span>
    <span class="span3">
        <h4>News and events</h4>
        <div class="well" data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'Nothing at this time'">

        </div>

    </span>
</script>

<r:script>

    $(function () {

        var organisation =<fc:modelAsJavascript model="${organisation}"/>;
        var organisationViewModel = new OrganisationViewModel(organisation);

        ko.applyBindings(organisationViewModel);

        var dashboardShown = false;
        $('#dashboard-tab').on('shown', function (e) {

            if (!dashboardShown) {
                dashboardShown = true;

                $.get(fcConfig.dashboardUrl, {fq:'organisationFacet:'+organisation.name}, function(data) {
                    $('#dashboard').html(data);
                    $('#dashboard .helphover').popover({animation: true, trigger:'hover', container:'body'});
                });

            }
        });

    });






</r:script>

</body>


</html>