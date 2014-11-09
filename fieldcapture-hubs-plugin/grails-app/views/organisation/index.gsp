<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
    <title>${organisation.name.encodeAsHTML()} | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <r:script disposition="head">
        var fcConfig = {
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            viewProjectUrl: "${createLink(controller:'project', action:'index')}",
            documentUpdateUrl: '${g.createLink(controller:"proxy", action:"documentUpdate")}',
            documentDeleteUrl: '${g.createLink(controller:"proxy", action:"deleteDocument")}',
            organisationDeleteUrl: '${g.createLink(action:"ajaxDelete", id:"${organisation.organisationId}")}',
            organisationEditUrl: '${g.createLink(action:"edit", id:"${organisation.organisationId}")}',
            organisationListUrl: '${g.createLink(action:"list")}'
            };
    </r:script>
    <r:require modules="wmd,knockout,mapWithFeatures,amplify,organisation"/>

    <style type="text/css">
        .organisation-header {
            background-repeat: no-repeat;
            background-position: right;
            background-color: #f0f0e8;
            margin-top: -10px;
            margin-bottom: 10px;
            padding-top: 10px;
            border-bottom: 1px solid #ddd;

        }
    </style>
</head>
<body>


    <div class="container-fluid organisation-header" data-bind="style:{'backgroundImage':bannerUrl}">
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
            <span class="span12" >
                <h4>Projects</h4>
                <div class="row-fluid">
                    <g:render template="/shared/projectsList"/>
                </div>
            </span>

        </div>
    </div>



<script id="hasMainImageTemplate" type="text/html">
    <span class="span3">
        <img data-bind="attr:{src:mainImageUrl}" style="width:100%;">
    </span>

    <span class="span6">
        <h4>Description</h4>
        <div class="well" data-bind="html:description.markdownToHtml()"></div>
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
    </span>
    <span class="span3">
        <h4>News and events</h4>
        <div class="well" data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'Nothing at this time'">

        </div>

    </span>
</script>

<r:script>

    $(function () {

        var organisation = <fc:encodeModel model="${organisation}"/>
        var organisationViewModel = new OrganisationViewModel(organisation);

        ko.applyBindings(organisationViewModel);

    });




</r:script>

</body>


</html>