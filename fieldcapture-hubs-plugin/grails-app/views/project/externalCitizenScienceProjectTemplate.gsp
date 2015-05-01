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

    <r:require modules="gmap3,mapWithFeatures,knockout,datepicker,amplify,jqueryValidationEngine, projects, attachDocuments, wmd, sliderpro"/>
</head>
<g:render template="banner"/>

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
<g:if test="${user?.isAdmin}">
    <div class="container-fluid">
        <div class="row-fluid">
            <!-- content  -->
            <ul class="nav nav-pills">
                <li class="active">
                    <a href="#about" data-toggle="pill">About</a>
                </li>
                <li><a href="#admin" data-toggle="pill">Admin</a></li>
            </ul>
        </div>
    </div>
    <div class="pill-content">
        <div class="pill-pane active" id="about">

            <g:render template="aboutCitizenScienceProject"/>
        </div>
        <div class="pill-pane" id="admin">
            Admin
        </div>
    </div>
</g:if>
<g:else>
    <g:render template="aboutCitizenScienceProject"/>
</g:else>

<r:script>
    $(function() {
        var organisations = <fc:modelAsJavascript model="${organisations?:[]}"/>;
        var project = <fc:modelAsJavascript model="${project}"/>;
        var projectViewModel = new ProjectViewModel(project, ${user?.isEditor?:false}, organisations);

        ko.applyBindings(projectViewModel);

        if (projectViewModel.mainImageUrl()) {
            $( '#carousel' ).sliderPro({
                width: '100%',
                height: 400,
                arrows: false, // at the moment we only support 1 image
                buttons: false,
                waitForLayers: true,
                fade: true,
                autoplay: false,
                autoScaleLayers: false,
                touchSwipe:false // at the moment we only support 1 image
            });
        }
    });
</r:script>
</body>
</html>