<div class="row-fluid">
    <div class="span6">
        <div class="well">
            <h4 class="header"><g:message code="project.details.tell"/></h4>

            <div class="clearfix control-group">
                <label class="control-label span3" for="name"><g:message code="g.project.name"/>:</label>

                <div class="controls span9">
                    <g:textField style="width:90%;" name="name" data-bind="value:name"
                                 data-validation-engine="validate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="description"><g:message code="g.project.description"/>:</label>

                <div class="controls span9">
                    <g:textArea style="width:90%;" name="description" data-bind="value:description"
                                data-validation-engine="validate[required]" rows="3"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="manager"><g:message code="project.details.manager"/>:</label>

                <div class="controls span9">
                    <g:textField style="width:90%;" type="email" data-bind="value:manager" name="manager"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="plannedStartDate"><g:message code="g.project.plannedStartDate"/>:
                <fc:iconHelp><g:message code="g.project.plannedStartDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker class="input-small" targetField="plannedStartDate.date" name="plannedStartDate"
                                   id="plannedStartDate" data-validation-engine="validate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="plannedEndDate"><g:message code="g.project.plannedEndDate"/>:
                <fc:iconHelp><g:message code="g.project.plannedEndDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker class="input-small" targetField="plannedEndDate.date" name="plannedEndDate"
                                   id="plannedEndDate" data-validation-engine="validate[future[plannedStartDate]]"/>
                </div>
            </div>
        </div>

        <div class="well">
            <h4 class="header"><g:message code="project.details.image"/></h4>

            <div class="control-group">
                <label class="control-label span3" for="logo">Project Logo:</label>
                <img class="span6" data-bind="visible:logoUrl(),attr:{src:logoUrl}">
                <span class="span3">
                <span class="btn fileinput-button pull-right"
                      data-url="${createLink(controller: 'image', action: 'upload')}"
                      data-role="logo"
                      data-owner-type="projectId"
                      data-owner-id="${project?.projectId}"
                      data-bind="stagedImageUpload:documents, visible:!logoUrl()"><i class="icon-plus"></i> <input
                        id="logo" type="file" name="files"><span>Attach</span></span>

                <button class="btn main-image-button" data-bind="click:removeLogoImage, visible:logoUrl()"><i class="icon-minus"></i> Remove</button>
                </span>
            </div>

            <div class="control-group">
                <label class="control-label span3" for="mainImage">Feature Graphic:</label>
                <img class="span6" data-bind="visible:mainImageUrl(),attr:{src:mainImageUrl}">
                <span class="span3">
                    <span class="btn fileinput-button pull-right"
                          data-url="${createLink(controller: 'image', action: 'upload')}"
                          data-role="mainImage"
                          data-owner-type="projectId"
                          data-owner-id="${project?.projectId}"
                          data-bind="stagedImageUpload:documents, visible:!mainImageUrl()"><i class="icon-plus"></i> <input
                            id="mainImage" type="file" name="files"><span>Attach</span></span>

                    <button class="btn main-image-button" data-bind="click:removeMainImage,  visible:mainImageUrl()"><i class="icon-minus"></i> Remove</button>
                </span>
            </div>

            <div class="control-group">
                <label class="control-label span3" for="bannerImage">Banner:</label>
                <img class="span6" data-bind="visible:bannerUrl(),attr:{src:bannerUrl}">
                <span class="span3">
                    <span class="btn fileinput-button pull-right"
                          data-url="${createLink(controller: 'image', action: 'upload')}"
                          data-role="banner"
                          data-owner-type="projectId"
                          data-owner-id="${project?.projectId}"
                          data-bind="stagedImageUpload:documents, visible:!bannerUrl()"><i class="icon-plus"></i> <input
                            id="bannerImage" type="file" name="files"><span>Attach</span></span>

                    <button class="btn main-image-button" data-bind="click:removeBannerImage,  visible:bannerUrl()"><i class="icon-minus"></i> Remove</button>
                </span>
            </div>

        </div>
    </div>


    <div class="span6 well">
        <h4 class="header span12"><g:message code="project.details.involved"/></h4>

        <div class="clearfix control-group">
            <label class="control-label span3" for="getInvolved"><g:message code="project.details.involved"/></label>

            <div class="controls span9">
                <g:textArea style="width:90%;" name="getInvolved" data-bind="value:getInvolved"
                            rows="2"/>
            </div>
        </div>

        <div class="clearfix control-group">
            <label class="control-label span3"
                   for="scienceType"><g:message code="project.details.scienceType"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" name="scienceType" data-bind="value:scienceType"/>
            </div>
        </div>

        <h4 class="header"><g:message code="project.details.find"/>:</h4>

        <div class="control-group">
            <label class="control-label span3" for="urlWeb"><g:message code="g.website"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" tye="url" name="urlWeb" data-bind="value:urlWeb"/>
            </div>
        </div>

        <div class="clearfix control-group">
            <label class="control-label span3" for="urlAndroid"><g:message code="g.android"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" tye="url" name="urlAndroid" data-bind="value:urlAndroid"/>
            </div>
        </div>

        <div class="clearfix control-group">
            <label class="control-label span3" for="urlITunes"><g:message code="g.iTunes"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" tye="url" name="urlITunes" data-bind="value:urlITunes"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label span3" for="keywords"><g:message code="g.keywords"/>:</label>

            <div class="controls span9">
                <g:textArea style="width:90%;" name="keywords" data-bind="value:keywords" rows="2"/>
            </div>
        </div>

    </div>
</div>


<div class="row-fluid">
<hr class="clearfix"/>
<h4 class="header" style="display:inline"><g:message code="project.details.site"/></h4><fc:iconHelp title="Extent of the site">The extent of the site can be represented by
                a polygon, radius or point. KML, WKT and shape files are supported for uploading polygons.
                As are PID's of existing features in the Atlas Spatial Portal.</fc:iconHelp>

<g:render template="/site/simpleSite" model="${pageScope.variables}"/>
<hr class="clearfix"/>
</div>

<r:script>
function initViewModel() {

    function ViewModel (data, activityTypes, organisations) {
        var self = this;
        $.extend(self, new ProjectViewModel(data, true, organisations));
        self.actualEndDate = ko.observable(data.actualEndDate).extend({simpleDate: false});
        self.actualStartDate = ko.observable(data.actualStartDate).extend({simpleDate: false});
        self.orgIdGrantee = ko.observable(data.orgIdGrantee);
        self.orgIdSponsor = ko.observable(data.orgIdSponsor);
        self.orgIdSvcProvider = ko.observable(data.orgIdSvcProvider);
        self.selectedActivities = ko.observableArray();
        self.transients.activitySource = ko.observable('program');
        self.transients.activityTypes = activityTypes;
        self.transients.subprogramsToDisplay = ko.computed(function () {
            return self.transients.subprograms[self.associatedProgram()];
        });

        self.save = function () {
            if ($('#validation-container').validationEngine('validate')) {
                if (self.transients.activitySource() === 'program') {
                    self.selectedActivities([]);
                }

                var jsData = ko.mapping.toJS(self, {ignore:['mainImageUrl', 'transients', 'dataSharing']});
                jsData.urlAndroid = fixUrl(jsData.urlAndroid);
                jsData.urlITunes  = fixUrl(jsData.urlITunes);
                jsData.urlWeb = fixUrl(jsData.urlWeb);
                jsData.isDataSharing = self.dataSharing() === 'Enabled';
                if (!jsData.dataSharingLicense) jsData.dataSharingLicense = 'other';
                var json = JSON.stringify(jsData);
                var id = "${project?.projectId ? '/' + project.projectId : ''}";
                $.ajax({
                    url: "${createLink(action: 'ajaxUpdate')}" + id,
                    type: 'POST',
                    data: json,
                    contentType: 'application/json',
                    success: function (data) {
                        if (data.error) {
                            alert(data.detail + ' \n' + data.error);
                        } else {
                            var projectId = "${project?.projectId}" || data.projectId;
                            document.location.href = "${createLink(action: 'index')}/" + projectId;

                        }
                    },
                    error: function (data) {
                        alert('An unhandled error occurred: ' + data.status);
                    }
                });
            }
        }
    }

    function fixUrl(url) {
        return typeof url == 'string' && url.indexOf("://") < 0? ("http://" + url): url;
    }

    var programsModel = <fc:modelAsJavascript model="${programs}"/>;
    var organisations = <fc:modelAsJavascript model="${organisations?:[]}"/>;
    var activityTypes = JSON.parse('${(activityTypes as grails.converters.JSON).toString().encodeAsJavaScript()}');
    var viewModel =  new ViewModel(${project ?: [:]}, activityTypes, organisations);
    viewModel.loadPrograms(programsModel);
    return viewModel;
}
</r:script>
