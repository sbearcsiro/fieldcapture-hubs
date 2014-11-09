<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
    <title>Edit | ${organisation.name.encodeAsHTML()} | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <r:script disposition="head">
        var fcConfig = {
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            viewProjectUrl: "${createLink(controller:'project', action:'index')}",
            documentUpdateUrl: '${g.createLink(controller:"proxy", action:"documentUpdate")}',
            documentDeleteUrl: '${g.createLink(controller:"proxy", action:"deleteDocument")}',
            organisationDeleteUrl: '${g.createLink(action:"ajaxDelete", id:"${organisation.organisationId}")}',
            organisationEditUrl: '${g.createLink(action:"edit", id:"${organisation.organisationId}")}',
            organisationViewUrl: '${g.createLink(action:"index")}',
            organisationListUrl: '${g.createLink(action:"list")}',
            organisationSaveUrl: "${createLink(action:'ajaxUpdate')}"

            };
    </r:script>
    <r:require modules="wmd,knockout,mapWithFeatures,amplify,jqueryValidationEngine,organisation"/>

    <style type="text/css">
        .organisation-header {
            background-repeat: no-repeat;
            background-position: right;
            background-color: #f0f0e8;
            margin-top: -10px;
            margin-bottom: 10px;
            padding-top: 10px;
            border-bottom: 1px solid #ddd;
            margin:3px;

        }

        .image-box {
            border-style:dashed;
            border-color: grey;
            border-width: 1px;
            border-bottom: 1px dashed grey;
        }


        h2, h4, img, .demphasise {
            opacity: 0.5;
        }

        .demphasise {
            display: inline;
        }

        span.demphasise * {
            opacity: 0.5;
        }

        .alert.instructions {
            color: black;
            border-color: darkgray;
        }
        .alert.instructions .close {
            opacity: .5;
        }
        .alert.instructions h4 {
            color: black;
            opacity: .5;
        }

        .popup-edit {
            margin-bottom: 5px;
            margin-top: 2px;
        }
    </style>
</head>
<body>
<div class="alert instructions" style="margin-left: 10px; margin-right:10px;">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <h4>Edit organisation - ${organisation.name}</h4>
    Edit the page content inline below.  When you are finished, use the save button at the bottom of the page.
</div>

<div class="container-fluid organisation-header image-box" data-bind="style:{'backgroundImage':bannerUrl}">

    <div class="row-fluid">
        <ul class="breadcrumb demphasise">
            <li>
                <g:link controller="home">Home</g:link> <span class="divider">/</span>
            </li>
            <li class="active">Organisations <span class="divider">/</span></li>
            <li class="active" data-bind="text:name"/>
        </ul>
    </div>
    <div class="row-fluid">
        <span class="span9"><button class="pull-left btn" style="margin-top:5px; margin-right:5px;"><i class="icon-edit"></i></button><h2 data-bind="text:name" style="display:inline"></h2></span>
        <span class="span3">
        <button class="btn pull-right" data-bind="click:attachBannerImage, visible:!bannerUrl()"><i class="icon-plus"></i> Attach Background Image</button>
        <button class="btn pull-right" data-bind="click:removeBannerImage, visible:bannerUrl()"><i class="icon-remove"></i> Remove Background Image</button>
        </span>


    </div>
</div>
<div class="container-fluid">
    <div class="row-fluid">
        <span class="span3 image-box" style="text-align: center; min-height:300px; position:relative">
            <img data-bind="attr:{src:mainImageUrl}" style="width:100%;">
            <button class="btn" data-bind="click:attachMainImage, visible:!mainImageUrl()" style="top:120px; left:0; right:0; width:140px; margin:auto; position:absolute;"><i class="icon-plus"></i> Attach Image</button>
            <button class="btn" data-bind="click:removeMainImage,  visible:mainImageUrl()" style="top:120px; left:0; right:0; width:140px; margin:auto; position:absolute;"><i class="icon-plus"></i> Remove Image</button>
        </span>


        <span class="span6">
            <button class="btn popup-edit" data-bind="click:editDescription"><i class="icon-edit"></i></button> <h4 class="demphasise">Description</h4>
            <div class="well">

                <span class="demphasise" data-bind="html:description.markdownToHtml()"></span>
            </div>
        </span>

        <span class="span3">
            <button class="btn popup-edit" data-bind="click:editNewsAndEvents"><i class="icon-edit"></i></button> <h4 class="demphasise">News and events</h4>
            <div class="well">
                <span class="demphasise"  data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'No news is good news...'"></span>

            </div>

        </span>
    </div>

    <div class="form-actions" style="text-align:right">
        <button type="button" id="save" data-bind="click:save" class="btn btn-primary">Save</button>
        <button type="button" id="cancel" class="btn">Cancel</button>
    </div>


</div>

<g:render template="/shared/attachDocument"/>
<g:render template="/shared/markdownEditorModal"/>

<r:script>

    $(function () {

        var OrganisationEditViewModel = function(organisation) {
            var self = this;
            OrganisationViewModel.call(self, organisation);

            self.editDescription = function() {
                editWithMarkdown('Edit organisation description', self.description);
            };
            self.editNewsAndEvents = function() {
                editWithMarkdown('Edit news and events', self.newsAndEvents);
            };


        };

        var organisation = <fc:encodeModel model="${organisation}"/>
        var organisationViewModel = new OrganisationEditViewModel(organisation);

        ko.applyBindings(organisationViewModel);

    });


</r:script>

</body>


</html>