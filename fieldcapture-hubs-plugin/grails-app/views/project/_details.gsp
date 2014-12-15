<form id="projectDetails" class="form-horizontal">
    <div class="row-fluid">
        <div class="span6">
            <h4 class="header"><g:message code="project.details.tell"/></h4>

            <div class="control-group">
                <label class="control-label span2" for="name"><g:message code="g.project.name"/>:</label>

                <div class="controls span10">
                    <input class="span12" id="name" data-bind="value:name"
                           data-validation-engine="validate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="description"><g:message code="g.project.description"/>:</label>

                <div class="controls span10">
                    <textarea class="span12" id="description" data-bind="value:description"
                              data-validation-engine="validate[required]" rows="3"></textarea>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="aim"><g:message code="project.details.aim"/></label>

                <div class="controls span10">
                    <textarea class="span12" id="aim" data-bind="value:aim"
                              data-validation-engine="validate[required]" rows="2"></textarea>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2"
                       for="organisation"><g:message code="project.details.org"/>:</label>

                <div class="controls span10">
                    <select class="span12" id="organisation"
                            data-bind="options:transients.organisations, optionsText:'name', optionsValue:'uid', value:organisation, optionsCaption: 'Choose...'"></select>
                    <label class="text-center"><g:message code="project.details.orgCustom"/></label>
                    <input class="span12" id="organisationName" data-bind="value:organisationName"
                           data-validation-engine="validate[funcCall[exclusive[organisation,You can only specify one organisation. One field must be cleared.]]]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="manager"><g:message code="project.details.manager"/>:</label>

                <div class="controls span10">
                    <input class="span12" type="email" data-bind="value:manager" id="manager"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="startDate"><g:message code="g.project.startDate"/>:
                <fc:iconHelp><g:message code="g.project.startDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span10">
                    <fc:datePicker targetField="plannedStartDate.date" name="startDate"
                                   id="startDate" data-validation-engine="validdate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="endDate"><g:message code="g.project.endDate"/>:
                <fc:iconHelp><g:message code="g.project.endDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span10">
                    <fc:datePicker targetField="plannedEndDate.date" name="endDate"
                                   id="endDate" data-validation-engine="validate[future[startDate]]"/>
                </div>
            </div>
        </div>

        <div data-bind="visible:projectType() != 'citizen'" class="span6">
            <h4 class="header">&nbsp;</h4>

            <div class="control-group">
                <label class="control-label span2" for="externalId"><g:message code="g.project.externalId"/>:</label>

                <div class="controls span10">
                    <g:textField class="span12" name="externalId" data-bind="value:externalId"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="grantId"><g:message code="g.project.grantId"/>:</label>

                <div class="controls span10">
                    <g:textField class="span12" name="grantId" data-bind="value:grantId"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="funding"><g:message code="g.project.funding"/>:</label>

                <div class="controls span10">
                    <g:textField class="span12" id="funding" name="funding" data-bind="value:funding"
                                 data-validation-engine="validate[custom[number]]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="program"><g:message code="g.program.name"/>:</label>

                <div class="controls span10">
                    <select class="span12" id="program"
                            data-bind="value:associatedProgram,options:transients.programs,optionsCaption: 'Choose...'"
                            data-validation-engine="validate[required]"></select>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="subProgram"><g:message code="g.subprogram.name"/>:</label>

                <div class="controls span10">
                    <select class="span12" id="subProgram"
                            data-bind="value:associatedSubProgram,options:transients.subprogramsToDisplay,optionsCaption: 'Choose...'"></select>
                </div>
            </div>
        </div>

        <div data-bind="visible:projectType() == 'citizen'" class="span6">
            <h4 class="header span12"><g:message code="project.details.involved"/></h4>

            <div class="control-group">
                <label class="control-label span2"
                       for="participants"><g:message code="project.details.participants"/></label>

                <div class="controls span10">
                    <input class="span12" id="participants" data-bind="value:participants"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="getInvolved"><g:message code="project.details.involved"/></label>

                <div class="controls span10">
                    <textarea class="span12" id="getInvolved" data-bind="value:getInvolved"
                              rows="2"></textarea>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2"
                       for="scienceType"><g:message code="project.details.scienceType"/>:</label>

                <div class="controls span10">
                    <input class="span12" id="scienceType" data-bind="value:scienceType"/>
                </div>
            </div>
        </div>
    </div>

    <div class="row-fluid">
        <div class="span6">
            <h4 class="header"><g:message code="project.details.find"/>:</h4>

            <div class="control-group">
                <label class="control-label span2" for="urlWeb"><g:message code="g.website"/>:</label>

                <div class="controls span10">
                    <input class="span12" id="urlWeb" data-bind="value:urlWeb"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="urlAndroid"><g:message code="g.android"/>:</label>

                <div class="controls span10">
                    <input class="span12" id="urlAndroid" data-bind="value:urlAndroid"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span2" for="urlITunes"><g:message code="g.iTunes"/>:</label>

                <div class="controls span10">
                    <input class="span12" id="urlITunes" data-bind="value:urlITunes"/>
                </div>
            </div>
        </div>

        <div class="span6">
            <h4 class="header">&nbsp;</h4>

            <div class="control-group">
                <label class="control-label span2" for="keywords"><g:message code="g.keywords"/>:</label>

                <div class="controls span10">
                    <textarea class="span12" id="keywords" data-bind="value:keywords" rows="2"></textarea>
                </div>
            </div>
        </div>
    </div>
</form>
<r:script>
$(function(){
    var organisations = ${institutions};
    function ViewModel (data, activityTypes) {
        var self = this;
        self.aim = ko.observable(data.aim);
        self.associatedProgram = ko.observable(); // don't initialise yet
        self.associatedSubProgram = ko.observable(data.associatedSubProgram);
        self.currentStage = ko.observable(data.currentStage);
        self.description = ko.observable(data.description);
        self.externalId = ko.observable(data.externalId);
        self.funding = ko.observable(data.funding).extend({currency:{}});
        self.getInvolved = ko.observable(data.getInvolved);
        self.grantId = ko.observable(data.grantId);
        self.keywords = ko.observable(data.keywords);
        self.manager = ko.observable(data.manager);
        self.name = ko.observable(data.name);
        self.participants = ko.observable(data.participants);
        self.projectType = ko.observable(data.projectType);
        self.organisation = ko.observable(data.organisation);
        self.organisationName = ko.observable(data.organisationName);
        self.plannedEndDate = ko.observable(data.plannedEndDate).extend({simpleDate: false});
        self.plannedStartDate = ko.observable(data.plannedStartDate).extend({simpleDate: false});
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

        self.removeTransients = function (jsData) {
            delete jsData.transients;
            return jsData;
        };
        self.save = function () {
            if ($('#validation-container').validationEngine('validate')) {
                if (self.transients.activitySource() === 'program') {
                    self.selectedActivities([]);
                }

                var jsData = ko.toJS(self);
                var json = JSON.stringify(self.removeTransients(jsData));
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
    ko.applyBindings(new ViewModel(${project ?: [:]}, activityTypes), document.getElementById("projectDetails"));
});
</r:script>
