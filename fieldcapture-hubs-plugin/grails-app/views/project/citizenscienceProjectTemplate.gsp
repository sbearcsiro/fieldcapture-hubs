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
        sitesDeleteUrl: "${createLink(controller: 'site', action: 'ajaxDeleteSitesFromProject', id:project.projectId)}",
        siteDeleteUrl: "${createLink(controller: 'site', action: 'ajaxDeleteSiteFromProject', id:project.projectId)}",
        siteViewUrl: "${createLink(controller: 'site', action: 'index')}",
        siteEditUrl: "${createLink(controller: 'site', action: 'edit')}",
        removeSiteUrl: "${createLink(controller: 'site', action: '')}",
        activityEditUrl: "${createLink(controller: 'activity', action: 'edit')}",
        activityEnterDataUrl: "${createLink(controller: 'activity', action: 'enterData')}",
        activityPrintUrl: "${createLink(controller: 'activity', action: 'print')}",
        activityCreateUrl: "${createLink(controller: 'activity', action: 'createPlan')}",
        activityUpdateUrl: "${createLink(controller: 'activity', action: 'ajaxUpdate')}",
        activityDeleteUrl: "${createLink(controller: 'activity', action: 'ajaxDelete')}",
        activityViewUrl: "${createLink(controller: 'activity', action: 'index')}",
        siteCreateUrl: "${createLink(controller: 'site', action: 'createForProject', params: [projectId:project.projectId])}",
        siteSelectUrl: "${createLink(controller: 'site', action: 'select', params:[projectId:project.projectId])}&returnTo=${createLink(controller: 'project', action: 'index', id: project.projectId)}",
        siteUploadUrl: "${createLink(controller: 'site', action: 'uploadShapeFile', params:[projectId:project.projectId])}&returnTo=${createLink(controller: 'project', action: 'index', id: project.projectId)}",
        starProjectUrl: "${createLink(controller: 'project', action: 'starProject')}",
        addUserRoleUrl: "${createLink(controller: 'user', action: 'addUserAsRoleToProject')}",
        removeUserWithRoleUrl: "${createLink(controller: 'user', action: 'removeUserWithRole')}",
        projectMembersUrl: "${createLink(controller: 'project', action: 'getMembersForProjectId')}",
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
    <div class="row-fluid">
        <!-- content  -->
        <ul class="nav nav-pills">
            <li class="active">
                <a href="#about" data-toggle="pill">About</a>
            </li>
            <li><a href="#news" data-toggle="pill">News</a></li>
            <li><a href="#records" data-toggle="pill">Records</a></li>
            <li><a href="#locations" data-toggle="pill">Locations</a></li>
            <li><a href="#documents" data-toggle="pill">Documents</a></li>
            <li><a href="#admin" data-toggle="pill">Admin</a></li>
        </ul>
    </div>
    <div class="pill-content">
        <div class="pill-pane active" id="about">
            <div class="row-fluid" data-bind="template:detailsTemplate"></div>
        </div>
        <div class="pill-pane" id="news">
            <div class="row-fluid">
                <span class="span6">
                    <div class="well">
                        <div class="well-title">News and events</div>
                        <div data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'Nothing at this time'"></div>

                    </div>
                </span>
                <span class="span6">
                    <div class="well">
                        <div class="well-title">Project stories</div>
                        <div data-bind="html:projectStories()?projectStories.markdownToHtml():'Nothing at this time'"></div>
                    </div>
                </span>
            </div>
        </div>
        <div class="pill-pane" id="records">
            <g:render template="/shared/activitiesList"
                      model="[activities:activities ?: [], sites:project.sites ?: [], showSites:true, wordForActivity:'survey']"/>
        </div>
        <div class="pill-pane" id="locations">
            <!-- ko stopBinding:true -->
            <g:render template="/site/sitesList" model="[wordForSite:'location']"/>
            <!-- /ko -->
        </div>
        <div class="pill-pane" id="documents">
            Documents
        </div>
        <div class="pill-pane" id="admin">
            Admin
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

</script>
<script id="noMainImageTemplate" type="text/html">
<span class="span3">
    <div class="well">


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

<span class="span6">

    <div class="well" data-bind="html:description.markdownToHtml()"></div>

</span>
<span class="span3">
    <div class="well">
        <div class="well-title">Get Involved!</div>
        <div data-bind="visible:getInvolved(), text:getInvolved"></div>
        <hr/>
        <div style="padding-bottom:5px;">To start contributing:</div>
        <button class="btn btn-primary">Sign in</button> OR
        <button class="btn btn-primary">Register</button>

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