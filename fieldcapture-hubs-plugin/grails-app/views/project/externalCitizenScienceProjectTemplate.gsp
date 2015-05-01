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
        organisationLinkBaseUrl: "${grailsApplication.config.collectory.baseURL + 'public/show/'}",
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
    <r:require modules="gmap3,mapWithFeatures,knockout,datepicker,amplify,jqueryValidationEngine, projects, attachDocuments, wmd, sliderpro"/>
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

    <div id="carousel" class="row-fluid slider-pro" data-bind="visible:mainImageUrl()">
        <div class="sp-slides">

            <div class="sp-slide">
                <img class="sp-image" data-bind="attr:{'data-src':mainImageUrl}"/>

                <p class="sp-layer sp-white sp-padding"
                   data-position="topLeft" data-width="100%"
                   data-show-transition="down" data-show-delay="100" data-hide-transition="up">
                    <strong>Get involved!</strong> Visit us at <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a>
                </p>

            </div>
        </div>
    </div>

    <div id="weburl" data-bind="visible:!mainImageUrl()">
        <div data-bind="visible:urlWeb()"><strong>Get involved!</strong> Visit us at <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a></div>
    </div>

    <hr/>
    <div class="row-fluid">
        <span class="span6">
            <div class="well">
                <div class="well-title">About us</div>
                <span data-bind="html:description.markdownToHtml()"></span>
            </div>
        </span>
        <span class="span6">
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
    </div>
</div>

<r:script>
    $(function() {
        var organisations = <fc:modelAsJavascript model="${organisations?:[]}"/>;
        var project = <fc:modelAsJavascript model="${project}"/>;
        var projectViewModel = new ProjectViewModel(project, ${user?.isEditor?:false}, organisations);

        ko.applyBindings(projectViewModel);

        if (projectViewModel.mainImageUrl()) {
            $( '#carousel' ).sliderPro({
                width: '100%',
                height: 500,
                arrows: false,
                buttons: false,
                waitForLayers: true,
                fade: true,
                autoplay: false,
                autoScaleLayers: false
            });
        }
    });
</r:script>
</body>
</html>