<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.layout.skin ?: 'main'}"/>
    <title>New | Projects | Field Capture</title>
    <r:require modules="knockout,jqueryValidationEngine,datepicker,fuelux"/>
</head>

<body>
<div class="container-fluid  fuelux">

<ul class="breadcrumb">
    <li><g:link controller="home">Home</g:link> <span class="divider">/</span></li>
    <li class="active">Create new project</li>
</ul>


<div class="row-fluid wizard" data-initialize="wizard" id="newProjectWizard">
    <ul class="steps">
        <li data-step="1" class="active"><span class="badge">1</span>Project Type<span class="chevron"></span></li>
        <li data-step="2" class="active"><span class="badge">2</span>Project Details<span class="chevron"></span></li>
        <li data-step="3" class="active"><span class="badge">3</span>Settings<span class="chevron"></span></li>
    </ul>

    <div class="step-content">

        <div class="step-pane active validationEngineContainer" data-step="1">

            <div class="row-fluid">
                <h3>Select the applicable type of project?</h3>
                <div class="control-group">

                    <span><label for="nrm" class="control-label"><input type="radio" name="projectType" value="nrm" id="nrm" checked="checked" data-validation-engine="validate[minCheckbox[1]]"> <strong>Works and site based projects</strong></label></span>
                    Choose this option for projects which have a schedule of actions (activities). Each record in the database requires a new activity to be added to the schedule before data can be recorded against it.
                    <p>Examples include: Projects to enhance, restore, protect or manage environmental assets, etc.</p>
                    <span><label for="simple" class="control-label"><input type="radio" name="projectType" value="simple" id="simple" disabled="disabled" data-validation-engine="validate[minCheckbox[1]]"> <strong>Citizen Science or biological surveys </strong> (not yet implemented)</label></span>
                    Choose this option for survey-based projects where activity forms can be selected and used repeatedly (ie. not in association with a schedule of actions).
                    <p>Examples include: Single or multi-species citizen science projects, Waterwatch surveys, ecological surveys, etc.</p>
                </div>
                <p>
                    <strong>Note:</strong> Both project types use the same suite of available data recording forms, but the way that they are used is different in each.
                </p>
            </div>
        </div>

        <div class="step-pane validationEngineContainer" data-step="2">
            <div class="row-fluid">
                <div class="control-group">
                    <label for="name" class="control-label">Project name</label>
                    <div class="controls">
                        <input type="text" class="input-xxlarge" id="name" data-bind="value: name"
                               data-validation-engine="validate[required]"/>
                    </div>
                </div>
            </div>

            <div class="row-fluid">
                <div class="control-group span5">
                    <label class="control-label">Choose an organisation</label>
                    <select class="input-xlarge" id="organisation"
                            data-bind="options:transients.organisations, optionsText:'name', optionsValue:'uid', value:organisation, optionsCaption: 'Choose...'"></select>
                </div>
                <span class="control-group span1" style="margin-top: 28px;"><b>OR</b></span>

                <div class="control-group span6">
                    <label class="control-label">Enter the name of an organisation or person</label>
                    <input class="input-xlarge" data-bind="value:organisationName" id="organisationName"
                           data-validation-engine="validate[funcCall[exclusive[organisation,You  can only specify one organisation. One field must be cleared.]]]"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="control-group">
                    <label for="description" class="control-label">Project description</label>

                    <div class="controls">
                        <textarea data-bind="value:description" class="input-xxlarge" id="description" rows="3"
                                  cols="50"></textarea>
                    </div>
                </div>
            </div>

            <div class="row-fluid">
                <div class="control-group span4">
                    <label class="control-label" for="externalId">External id</label>

                    <div class="controls">
                        <g:textField class="" name="externalId" data-bind="value:externalId"/>
                    </div>
                </div>

                <div class="control-group span4">
                    <label class="control-label" for="grantId">Grant id</label>

                    <div class="controls">
                        <g:textField class="" name="grantId" data-bind="value:grantId"/>
                    </div>
                </div>
            </div>

            <div class="row-fluid">
                <div class="control-group span4">
                    <label class="control-label" for="manager">Project manager</label>

                    <div class="controls">
                        <g:textField class="" name="manager" data-bind="value:manager"/>
                    </div>
                </div>

                <div class="control-group span4">
                    <label class="control-label" for="manager">Project funding</label>

                    <div class="controls">
                        <g:textField class="" name="funding" data-bind="value:funding"
                                     data-validation-engine="validate[custom[number]]"/>
                    </div>
                </div>

            </div>

            <div class="row-fluid">
                <div class="span4">
                    <label class="control-label">Program name</label>
                    <select data-bind="value:associatedProgram,options:transients.programs,optionsCaption: 'Choose...'"
                            data-validation-engine="validate[required]"></select>
                </div>

                <div class="span4">
                    <label class="control-label">Sub-program name</label>
                    <select data-bind="value:associatedSubProgram,options:transients.subprogramsToDisplay,optionsCaption: 'Choose...'"></select>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span4">
                    <label for="startDate">Planned start date
                    <fc:iconHelp title="Start date">Date the project is intended to commence.</fc:iconHelp>
                    </label>

                    <div class="input-append">
                        <fc:datePicker targetField="plannedStartDate.date" name="startDate"
                                       data-validation-engine="validate[required]" size="input-large"/>
                    </div>
                </div>

                <div class="span4">
                    <label for="endDate">Planned end date
                    <fc:iconHelp title="End date">Date the project is intended to finish.</fc:iconHelp>
                    </label>

                    <div class="input-append">
                        <fc:datePicker targetField="plannedEndDate.date" name="endDate"
                                       data-validation-engine="validate[future[startDate]]"
                                       size="input-large"/>
                    </div>
                </div>
            </div>





        </div>
        <div class="step-pane validationEngineContainer" data-step="3">
            <h3>Project Activities</h3>
            Select the types of activities this project requires.

            <div><input type="checkbox" id="selectAll"> Select all</div>
            <div data-bind="foreach:transients.activityTypes" id="activityTypes">
                <strong><span data-bind="text:name"></span></strong>
                <ul class="unstyled" data-bind="foreach:list">
                    <li><input type="checkbox" name="activity" data-bind="checked:$root.selectedActivities,value:name,attr:{id:'activity'+$index()}" data-validation-engine="validate[minCheckbox[1]]"> <span data-bind="text:name"></span></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="form-actions" style="clear:both;">
        <button class="btn btn-default btn-prev"><span class="glyphicon glyphicon-arrow-left"></span>Prev</button>
        <button class="btn btn-default btn-next" data-last="Save">Next<span class="glyphicon glyphicon-arrow-right"></span></button>
    </div>
</div>

<g:if env="development">
    <hr/>

    <div class="expandable-debug">
        <h3>Debug</h3>

        <div>
            <h4>KO model</h4>
            <pre data-bind="text:ko.toJSON($root,null,2)"></pre>
            <h4>Project</h4>
            <pre>${project.encodeAsHTML()}</pre>
            <label class="control-label" for="currentStage">Current stage of project</label>
            <!-- later this will be a dropdown to pick from activity stages -->
            <g:textField class="" name="currentStage" data-bind="value:currentStage"/>
        </div>
    </div>
    </div>
</g:if>
</div>
<r:script>

    $(function(){

        $('.validationEngineContainer').validationEngine();

        $('.helphover').popover({animation: true, trigger:'hover'});

        $('#cancel').click(function () {
            document.location.href = "${create ? createLink(controller: 'home', action: 'index') :
        createLink(action: 'index', id: project?.projectId)}";
        });

        var organisations = ${institutions};

        function ViewModel (data, activityTypes) {
            var self = this;
            self.name = ko.observable(data.name);
            self.description = ko.observable(data.description);
            self.externalId = ko.observable(data.externalId);
            self.grantId = ko.observable(data.grantId);
            self.manager = ko.observable(data.manager);
            self.associatedProgram = ko.observable(); // don't initialise yet
            self.associatedSubProgram = ko.observable(data.associatedSubProgram);
            self.plannedStartDate = ko.observable(data.plannedStartDate).extend({simpleDate: false});
            self.plannedEndDate = ko.observable(data.plannedEndDate).extend({simpleDate: false});
            self.currentStage = ko.observable(data.currentStage);
            self.organisation = ko.observable(data.organisation);
            self.organisationName = ko.observable(data.organisationName);
            self.funding = ko.observable(data.funding).extend({currency:{}});
            self.selectedActivities = ko.observableArray();

            self.transients = {};
            self.transients.organisations = organisations;
            self.transients.activityTypes = activityTypes;
            self.transients.programs = [];
            self.transients.subprograms = {};
            self.transients.subprogramsToDisplay = ko.computed(function () {
                return self.transients.subprograms[self.associatedProgram()];
            });

            self.loadPrograms = function (programsModel) {
                $.each(programsModel.programs, function (i, program) {
                    self.transients.programs.push(program.name);
                    self.transients.subprograms[program.name] = $.map(program.subprograms,function (obj, i){return obj.name});
                });
                self.associatedProgram(data.associatedProgram); // to trigger the computation of sub-programs
            };

            self.removeTransients = function (jsData) {
                delete jsData.transients;
                return jsData;
            };
            self.save = function () {
                if ($('#validation-container').validationEngine('validate')) {
                    var jsData = ko.toJS(self);
                    var json = JSON.stringify(self.removeTransients(jsData));
                    var id = "${project?.projectId ? '/' + project.projectId : ''}";
                    $.ajax({
                        url: "${createLink(action: 'ajaxCreate')}" + id,
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
        var viewModel = new ViewModel(${project ?: [:]}, activityTypes);
        viewModel.loadPrograms(${programs});
        ko.applyBindings(viewModel);

        $('#selectAll').change(function() {
            if ($('#selectAll').is(':checked')) {
                $('#activityTypes input[type=checkbox]').attr('checked', 'checked');
            }
            else {
                $('#activityTypes input[type=checkbox]').removeAttr('checked');
            }
        });
        $('.wizard').on('finished.fu.wizard', function() {
            viewModel.save();
        }).on('actionclicked.fu.wizard', function(e) {
            var selected = $(this).wizard('selectedItem');
           if (!$('.step-pane[data-step='+selected.step+']').validationEngine('validate')) {
                e.preventDefault();
            }
        });

    });

</r:script>

</body>
</html>