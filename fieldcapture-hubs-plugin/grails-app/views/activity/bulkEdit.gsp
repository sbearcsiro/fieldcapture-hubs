
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
  <title>Create | Activity | Field Capture</title>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jstimezonedetect/1.0.4/jstz.min.js"></script>
  <r:script disposition="head">
    var fcConfig = {
        organisationViewUrl: "${createLink(controller:'organisation', action:'index', id:organisation.organisationId)}",
        serverUrl: "${grailsApplication.config.grails.serverURL}",
        projectViewUrl: "${createLink(controller: 'project', action: 'index')}/",
        saveUrl: "${createLink(controller:'activity', action:'ajaxUpdate')}",
        siteViewUrl: "${createLink(controller: 'site', action: 'index')}/",
        returnTo: "${params.returnTo}"
        },
        here = document.location.href;
  </r:script>
  <r:require modules="knockout,jqueryValidationEngine,datepicker,slickgrid"/>
    <style type="text/css">
        input.editor-text {box-sizing:border-box; width: 100%;}
        .slick-column-name { white-space: normal; }
        .slick-header-column.ui-state-default { background: #DAE0B9; height: 100%; font-weight: bold;}
        .slick-header { background: #DAE0B9; }

    </style>
</head>
<body>

<div class="container-fluid">
    <ul class="breadcrumb">
        <li><g:link controller="home">Home</g:link> <span class="divider">/</span></li>
        <li><a href="${createLink(controller:'organisation', action:'index', id:organisation.organisationId)}" class="clickable">Organisation</a> <span class="divider">/</span></li>
        <li class="active">
            ${title}
        </li>
    </ul>
    <div class="row-fluid">
        <h2>${title}</h2>
    </div>

    <div class="instructions well">
        Each row of the table below allows the monthly status report for a single project to be completed.  Not all projects need to be edited at once.  If you would prefer to edit the report for an individual project, click the link in the "Project column".  When you are finished, press the save button.
    </div>

    <div class="row-fluid">
        <span class="span12">
        <div id="myGrid" style="width:100%;"></div>
        </span>
    </div>
    <div class="row-fluid">
        <div class="form-actions" style="text-align:right">
            <button type="button" id="save" class="btn btn-primary">Save</button>
            <button type="button" id="cancel" class="btn">Cancel</button>
        </div>
    </div>
</div>
<r:script>

    $(function () {

    <g:each in="${outputModels}" var="outputModel">
        <g:if test="${outputModel.name != 'Photo Points'}">
            <g:set var="blockId" value="${fc.toSingleWord([name: outputModel.name])}"/>
            <g:set var="model" value="${outputModel.dataModel}"/>



            var viewModelName = "${blockId}ViewModel",
                viewModelInstance = viewModelName + "Instance";

            // load dynamic models - usually objects in a list
                <md:jsModelObjects model="${model}" site="${site}" speciesLists="${speciesLists}" edit="true"
                                   viewModelInstance="${blockId}ViewModelInstance"/>

                this[viewModelName] = function (output) {
                    var self = this;
                    self.name = "${outputModel.name}";
                self.outputId = orBlank(output.outputId);

                self.data = {};
                self.transients = {};
                self.transients.dummy = ko.observable();

                // add declarations for dynamic data
                <md:jsViewModel model="${model}" output="${outputModel.name}" edit="true"
                                viewModelInstance="${blockId}ViewModelInstance"/>

                // this will be called when generating a savable model to remove transient properties
                self.removeBeforeSave = function (jsData) {
                    // add code to remove any transients added by the dynamic tags
                    <md:jsRemoveBeforeSave model="${model}"/>
                    delete jsData.activityType;
                    delete jsData.transients;
                    return jsData;
                };

            // this returns a JS object ready for saving
            self.modelForSaving = function () {
                // get model as a plain javascript object
                var jsData = ko.mapping.toJS(self, {'ignore':['transients']});
                // get rid of any transient observables
                return self.removeBeforeSave(jsData);
            };

            // this is a version of toJSON that just returns the model as it will be saved
            // it is used for detecting when the model is modified (in a way that should invoke a save)
            // the ko.toJSON conversion is preserved so we can use it to view the active model for debugging
            self.modelAsJSON = function () {
                return JSON.stringify(self.modelForSaving());
            };

            self.loadData = function (data) {
                // load dynamic data
                <md:jsLoadModel model="${model}"/>

                // if there is no data in tables then add an empty row for the user to add data
                if (typeof self.addRow === 'function' && self.rowCount() === 0) {
                    self.addRow();
                }
                self.transients.dummy.notifySubscribers();
            };

            if (output && output.data) {
                self.loadData(output.data);
            }
            self.dirtyFlag = ko.dirtyFlag(self, false);
        };
</g:if>
</g:each>


        var options = {
            editable: true,
            enableCellNavigation: true,
            dataItemColumnValueExtractor: outputValueExtractor,
            forceFitColumns: true,
            autoHeight:true,
            topPanelHeight: 25
        };
        var activityLinkFormatter = function( row, cell, value, columnDef, dataContext ) {
            return '<a title="'+value+'" href="'+'${createLink(controller: "activity", action:"enterData")}'+'/'+dataContext.activityId+'">'+value+'</a>';
        };

        var progressFormatter = function( row, cell, value, columnDef, dataContext ) {

            var saving = dataContext.saving();

            var progress = ko.utils.unwrapObservable(value);
            var result =  "<span class=\"label "+activityProgressClass(progress)+"\">"+progress+"</span>"
            if (saving) {
                result += '<r:img dir="images" file="ajax-saver.gif" alt="saving icon"/>'
            }
            return result;
        };


        var activities = <fc:modelAsJavascript model="${activities}"/>;
        var outputModels = <fc:modelAsJavascript model="${outputModels}"/>;

        var top = this;


        var activityModels = [];
        var ActivityViewModel = function(activity) {
            var self = this;

            $.extend(self, activity);
            self.outputModels = [];
            self.progress = ko.observable(activity.progress);

            $.each(outputModels, function(i, outputModel) {

                var viewModelName = outputModel.name.replace(/ /g , '_')+'ViewModel';

                if (activity.outputs) {
                    var output = {};
                    var result = $.grep(activity.outputs, function(output) {
                        return output.name == outputModel.name;
                    });
                    if (result && result[0]) {
                        output = result[0];
                    }
                    self.outputModels.push(new top[viewModelName](output));
                }
            });

            self.isDirty = ko.computed(function() {
                var dirty = false;
                $.each(self.outputModels, function(i, outputModel) {
                    if (outputModel.dirtyFlag.isDirty()) {
                        dirty = true;
                        return false;
                    }
                });
                return dirty;
            });

            self.isDirty.subscribe(function(dirty) {

                if (activity.progress == 'planned') {
                    if (dirty) {
                        self.progress('started');
                    }
                    else {
                        self.progress('planned');
                    }
                }
            });

            self.saving = ko.observable(false);

            self.modelForSaving = function() {
                var outputData = [];
                var activityForSaving = {outputs:outputData, progress:'finished', activityId:activity.activityId};
                $.each(self.outputModels, function(i, outputModel) {
                    if (outputModel.dirtyFlag.isDirty()) {
                        outputData.push(outputModel.modelForSaving());
                    }

                });
                return activityForSaving;
            }
        };

        $.each(activities, function(i, activity) {
            activityModels.push(new ActivityViewModel(activity));
        });

        var helpHover = function(helpText) {
            return '<a href="#" class="helphover" data-original-title="" data-placement="top" data-container="body" data-content="'+helpText+'">'+
                       '<i class="icon-question-sign">&nbsp;</i>'+
                   '</a>';
        };
        var columns = [];
        $.each(outputModels, function(i, outputModel) {
            $.each(outputModel.annotatedModel, function(i, dataItem) {

                if (dataItem.computed) {
                    return;
                }
                var columnHeader = dataItem.shortDescription ? dataItem.shortDescription : dataItem.label ? dataItem.label : dataItem.name;
                if (dataItem.description) {
                    columnHeader += helpHover(dataItem.description);
                }

                var editor = OutputValueEditor;
                if (dataItem.constraints) {
                    editor = OutputSelectEditor;
                }
                else if (dataItem.viewType == 'textarea') {
                    editor = LongTextEditor;
                }

                var column = {
                    id: dataItem.name,
                    name: columnHeader,
                    field: dataItem.name,
                    outputName:outputModel.name,
                    options:dataItem.constraints,
                    editor:editor,
                    cssClass:'text-center'
                };
                if (dataItem.validate) {
                    column.validationRules = 'validate['+dataItem.validate+']';
                }
                columns.push(column);
            });
        });

        // Add the project columns
        var projectColumn = {name:'Project', id:'projectName', field:'grantId', formatter:activityLinkFormatter, minWidth:100};
        var progressColumn = {name:'Progress', id:'progress', field:'progress', formatter:progressFormatter};

        columns = [projectColumn].concat(columns, progressColumn);

        var grid = new Slick.Grid("#myGrid", activityModels, columns, options);
        $('.slick-cell.r4')[0].click();

        $('#save').click(function() {
            Slick.GlobalEditorLock.commitCurrentEdit();
            var activities = grid.getData();

            var valid = true;

            var pendingSaves = [];
            $.each(activityModels, function(i, activity) {
                var url = fcConfig.saveUrl+'/'+activity.activityId;

                if (activity.isDirty()) {

                    activity.row = i;

                    valid = valid && validate(grid, activity, outputModels);
                    activity.saving(true);
                    grid.invalidateRow(i);
                    grid.render();
                    var data = JSON.stringify(activity.modelForSaving());

                    var promise = $.ajax(url, {type:'POST', data:data, dataType:'json', contentType:'application/json'}).done(
                        function(data) {
                            activity.progress('finished');
                        }
                    ).always(function() {
                        activity.saving(false);
                        grid.invalidateRow(i);
                        grid.render();
                    });

                    pendingSaves.push(promise);

                }

            });
            $.when.apply($, pendingSaves).done(function() {
                if (valid) {
                    if (pendingSaves.length ==0) {
                        alert('Nothing to save.');
                    }
                    else {
                        document.location.href = fcConfig.returnTo;
                    }
                }
                else {
                    alert('Please correct validation errors and press Save again');
                }
            });
        });

        $('#cancel').click(function() {
            window.location = fcConfig.returnTo;
        });

        // Hacky slickgrid / jqueryValidationEngine integration for some amount of user experience consistency.
        $('.slick-row').addClass('validationEngineContainer').validationEngine({scroll:false});

         $('.helphover').popover({animation: true, trigger:'hover'});
    });

</r:script>

</body>
</html>