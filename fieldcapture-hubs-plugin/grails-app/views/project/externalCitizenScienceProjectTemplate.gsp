<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title>${project?.name.encodeAsHTML()} | Project | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <r:script disposition="head">
    var fcConfig = {
        serverUrl: "${grailsApplication.config.grails.serverURL}",
        projectUpdateUrl: "${createLink(action: 'ajaxUpdate', id: project.projectId)}",
        spatialBaseUrl: "${grailsApplication.config.spatial.baseUrl}",
        spatialWmsCacheUrl: "${grailsApplication.config.spatial.wms.cache.url}",
        spatialWmsUrl: "${grailsApplication.config.spatial.wms.url}",
        sldPolgonDefaultUrl: "${grailsApplication.config.sld.polgon.default.url}",
        sldPolgonHighlightUrl: "${grailsApplication.config.sld.polgon.highlight.url}",
        organisationLinkBaseUrl: "${createLink(controller: 'organisation', action: 'index')}",
        returnTo: "${createLink(controller: 'project', action: 'index', id: project.projectId)}"
        },
        here = window.location.href;

    </r:script>

    <style type="text/css">
    .well-title {
        border-bottom: 1px solid lightgrey;
        font-weight: bold;
        padding-bottom:5px;
        margin-bottom:10px;
        font-size:larger;
    }
    </style>

    <!--[if gte IE 8]>
        <style>
           .thumbnail > img {
                max-width: 400px;
            }
            .thumbnail {
                max-width: 410px;
            }
        </style>
    <![endif]-->
    <r:require modules="gmap3,mapWithFeatures,knockout,datepicker,amplify,jqueryValidationEngine, projects, attachDocuments, wmd"/>
</head>
<body>

<g:render template="banner"/>
<div class="container-fluid">
    <div class="row-fluid">
        <div class="row-fluid">
            <div class="clearfix">
                <g:if test="${flash.errorMessage || flash.message}">
                    <div class="span5">
                        <div class="alert alert-error">
                            <button class="close" onclick="$('.alert').fadeOut();" href="#">×</button>
                            ${flash.errorMessage?:flash.message}
                        </div>
                    </div>
                </g:if>

            </div>
        </div>
    </div>

    <div class="row-fluid" data-bind="template:detailsTemplate"></div>

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

</script>
<script id="noMainImageTemplate" type="text/html">


<span class="span6">

    <div class="well" data-bind="html:description.markdownToHtml()"></div>

</span>
<span class="span3">
    <div class="well">
        <div class="well-title">Get Involved!</div>
        <div data-bind="visible:getInvolved(), text:getInvolved"></div>
        <hr/>
        <div style="padding-bottom:5px;">Visit the project website to get started!</div>
        <div class="row-fluid" data-bind="visible:urlWeb">
            <div class="span6">
                <label>Project web site:</label>
            </div>
            <div class="span6">
                <span data-bind="text:urlWeb"></span>
            </div>
        </div>
        <div class="row-fluid" data-bind="visible:urlAndroid">
            <div class="span6">
                <label>Android app:</label>
            </div>
            <div class="span6">
                <span data-bind="text:urlWeb"></span>
            </div>
        </div>
        <div class="row-fluid" data-bind="visible:urlITunes">
            <div class="span6">
                <label>iTunes app:</label>
            </div>
            <div class="span6">
                <span data-bind="text:urlITunes"></span>
            </div>
        </div>

    </div>
</span>

</script>
<r:script>
    $(function() {
        var organisations = <fc:modelAsJavascript model="${organisations?:[]}"/>;
        var project = <fc:modelAsJavascript model="${project}"/>;
        var projectViewModel = new ProjectViewModel(project, ${user?.isEditor?:false}, organisations);

        var ViewModel = function() {
            var self = this;
            $.extend(this, projectViewModel);

            this.detailsTemplate = ko.computed(function() {
                return self.mainImageUrl() ? 'hasMainImageTemplate' : 'noMainImageTemplate';
            });
        }
        ko.applyBindings(new ViewModel());

        initialiseSites(project.sites);
    });
</r:script>
</body>
</html>