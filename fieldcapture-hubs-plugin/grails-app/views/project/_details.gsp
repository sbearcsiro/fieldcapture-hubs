    <div class="row-fluid">
        <div class="span6">
            <h4 class="header"><g:message code="project.details.tell"/></h4>

            <div class="control-group">
                <label class="control-label span3" for="name"><g:message code="g.project.name"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" name="name" data-bind="value:name"
                           data-validation-engine="validate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="description"><g:message code="g.project.description"/>:</label>

                <div class="controls span9">
                    <g:textArea class="span12" name="description" data-bind="value:description"
                              data-validation-engine="validate[required]" rows="3"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="aim"><g:message code="project.details.aim"/></label>

                <div class="controls span9">
                    <g:textArea class="span12" name="aim" data-bind="value:aim"
                              data-validation-engine="validate[required]" rows="2"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="manager"><g:message code="project.details.manager"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" type="email" data-bind="value:manager" name="manager"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="plannedStartDate"><g:message code="g.project.plannedStartDate"/>:
                <fc:iconHelp><g:message code="g.project.plannedStartDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker targetField="plannedStartDate.date" name="plannedStartDate"
                                   id="plannedStartDate" data-validation-engine="validate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="plannedEndDate"><g:message code="g.project.plannedEndDate"/>:
                <fc:iconHelp><g:message code="g.project.plannedEndDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker targetField="plannedEndDate.date" name="plannedEndDate"
                                   id="plannedEndDate" data-validation-engine="validate[future[plannedStartDate]]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="actualStartDate"><g:message code="g.project.actualStartDate"/>:
                <fc:iconHelp><g:message code="g.project.actualStartDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker targetField="actualStartDate.date" name="actualStartDate" id="actualStartDate"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="actualEndDate"><g:message code="g.project.actualEndDate"/>:
                <fc:iconHelp><g:message code="g.project.actualEndDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker targetField="actualEndDate.date" name="actualEndDate" id="actualEndDate"/>
                </div>
            </div>
        </div>

        <div data-bind="visible:!isCitizenScience()" class="span6">
            <h4 class="header">&nbsp;</h4>

            <div class="control-group">
                <label class="control-label span3" for="externalId"><g:message code="g.project.externalId"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" name="externalId" data-bind="value:externalId"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="grantId"><g:message code="g.project.grantId"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" name="grantId" data-bind="value:grantId"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="funding"><g:message code="g.project.funding"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" name="funding" data-bind="value:funding"
                                 data-validation-engine="validate[custom[number]]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="program"><g:message code="g.program.name"/>:</label>

                <div class="controls span9">
                    <select class="span12" id="program"
                            data-bind="value:associatedProgram,options:transients.programs,optionsCaption: 'Choose...'"
                            data-validation-engine="validate[required]"></select>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="subProgram"><g:message code="g.subprogram.name"/>:</label>

                <div class="controls span9">
                    <select class="span12" id="subProgram"
                            data-bind="value:associatedSubProgram,options:transients.subprogramsToDisplay,optionsCaption: 'Choose...'"></select>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3"
                       for="orgGrantee"><g:message code="project.details.orgGrantee"/>:</label>

                <div class="controls span9">
                    <select class="span12" id="orgGrantee"
                            data-bind="options:transients.organisations, optionsText:'name', optionsValue:'uid', value:orgIdGrantee, optionsCaption: 'Choose...'"></select>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3"
                       for="orgSponsor"><g:message code="project.details.orgSponsor"/>:</label>

                <div class="controls span9">
                    <select class="span12" id="orgSponsor"
                            data-bind="options:transients.organisations, optionsText:'name', optionsValue:'uid', value:orgIdSponsor, optionsCaption: 'Choose...'"></select>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3"
                       for="orgSvcProvider"><g:message code="project.details.orgSvcProvider"/>:</label>

                <div class="controls span9">
                    <select class="span12" id="orgSvcProvider"
                            data-bind="options:transients.organisations, optionsText:'name', optionsValue:'uid', value:orgIdSvcProvider, optionsCaption: 'Choose...'"></select>
                </div>
            </div>
        </div>

        <div data-bind="visible:isCitizenScience()" class="span6">
            <h4 class="header span12"><g:message code="project.details.involved"/></h4>

            <div class="clearfix control-group">
                <label class="control-label span3" for="getInvolved"><g:message code="project.details.involved"/></label>

                <div class="controls span9">
                    <g:textArea class="span12" name="getInvolved" data-bind="value:getInvolved"
                              rows="2"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3"
                       for="scienceType"><g:message code="project.details.scienceType"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" name="scienceType" data-bind="value:scienceType"/>
                </div>
            </div>
        </div>
    </div>

    <hr class="clearfix"/>
        <g:render template="/site/map" model="${pageScope.variables}"/>
    <hr class="clearfix"/>

    <div class="row-fluid">
        <div class="span6">
            <h4 class="header"><g:message code="project.details.find"/>:</h4>

            <div class="control-group">
                <label class="control-label span3" for="urlWeb"><g:message code="g.website"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" tye="url" name="urlWeb" data-bind="value:urlWeb"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="urlAndroid"><g:message code="g.android"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" tye="url" name="urlAndroid" data-bind="value:urlAndroid"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="urlITunes"><g:message code="g.iTunes"/>:</label>

                <div class="controls span9">
                    <g:textField class="span12" tye="url" name="urlITunes" data-bind="value:urlITunes"/>
                </div>
            </div>
        </div>

        <div class="span6">
            <h4 class="header">&nbsp;</h4>

            <div class="control-group">
                <label class="control-label span3" for="keywords"><g:message code="g.keywords"/>:</label>

                <div class="controls span9">
                    <g:textArea class="span12" name="keywords" data-bind="value:keywords" rows="2"/>
                </div>
            </div>
        </div>
    </div>
<r:script>
function initViewModel() {
    var organisations = ${institutions}, organisationsMap = {}, organisationsRMap = {};
    organisations.map(function(org) {
        organisationsMap[org.uid] = org.name;
        organisationsRMap[org.name] = org.uid;
    })
    function ViewModel (data, activityTypes) {
        var self = this;
        self.actualEndDate = ko.observable(data.actualEndDate).extend({simpleDate: false});
        self.actualStartDate = ko.observable(data.actualStartDate).extend({simpleDate: false});
        self.aim = ko.observable(data.aim);
        self.associatedProgram = ko.observable(); // don't initialise yet
        self.associatedSubProgram = ko.observable(data.associatedSubProgram);
        self.description = ko.observable(data.description);
        self.externalId = ko.observable(data.externalId);
        self.funding = ko.observable(data.funding).extend({currency:{}});
        self.getInvolved = ko.observable(data.getInvolved);
        self.grantId = ko.observable(data.grantId);
        self.isCitizenScience = ko.observable(data.isCitizenScience);
        self.keywords = ko.observable(data.keywords);
        self.manager = ko.observable(data.manager);
        self.name = ko.observable(data.name);
        self.organisationId = ko.observable(data.organisationId || organisationsRMap[data.organisationName]);
        self.organisationName = ko.computed(function() {
            return organisationsMap[self.organisationId()];
        });
        self.orgIdGrantee = ko.observable(data.orgIdGrantee);
        self.orgIdSponsor = ko.observable(data.orgIdSponsor);
        self.orgIdSvcProvider = ko.observable(data.orgIdSvcProvider);
        self.plannedEndDate = ko.observable(data.plannedEndDate).extend({simpleDate: false});
        self.plannedStartDate = ko.observable(data.plannedStartDate).extend({simpleDate: false});
        self.projectSiteId = data.projectSiteId;
        self.projectType = ko.observable(data.projectType || "works");
        self.scienceType = ko.observable(data.scienceType);
        self.selectedActivities = ko.observableArray();
        self.urlAndroid = ko.observable(data.urlAndroid);
        self.urlITunes = ko.observable(data.urlITunes);
        self.urlWeb = ko.observable(data.urlWeb);

        self.transients = {};
        self.transients.organisations = organisations;
        self.transients.activitySource = ko.observable('program');
        self.transients.activityTypes = activityTypes;
        self.transients.programs = [];
        self.transients.subprograms = {};
        self.transients.subprogramsToDisplay = ko.computed(function () {
            return self.transients.subprograms[self.associatedProgram()];
        });

        var programsModel = <fc:modelAsJavascript model="${programs}"/>;
        $.each(programsModel.programs, function (i, program) {
            self.transients.programs.push(program.name);
            self.transients.subprograms[program.name] = $.map(program.subprograms,function (obj, i){return obj.name});
        });
        self.associatedProgram(data.associatedProgram); // to trigger the computation of sub-programs

        self.save = function () {
            if ($('#validation-container').validationEngine('validate')) {
                if (self.transients.activitySource() === 'program') {
                    self.selectedActivities([]);
                }

                var jsData = ko.toJS(self);
                delete jsData.transients;
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
                        var status = data.status;
                        alert('An unhandled error occurred: ' + data.status);
                    }
                });
            }
        }
    }

    var activityTypes = JSON.parse('${(activityTypes as grails.converters.JSON).toString().encodeAsJavaScript()}');
    return new ViewModel(${project ?: [:]}, activityTypes);
}
</r:script>
