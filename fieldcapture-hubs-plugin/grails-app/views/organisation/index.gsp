<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
    <title>${organisation.name.encodeAsHTML()} | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>

    <r:script disposition="head">
        var fcConfig = {
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            viewProjectUrl: "${createLink(controller:'project', action:'index')}",
            updateProjectUrl: "${createLink(controller: 'project', action:'ajaxUpdate')}",
            documentUpdateUrl: '${g.createLink(controller:"proxy", action:"documentUpdate")}',
            documentDeleteUrl: '${g.createLink(controller:"proxy", action:"deleteDocument")}',
            organisationDeleteUrl: '${g.createLink(action:"ajaxDelete", id:"${organisation.organisationId}")}',
            organisationEditUrl: '${g.createLink(action:"edit", id:"${organisation.organisationId}")}',
            organisationListUrl: '${g.createLink(action:"list")}',
            organisationViewUrl: '${g.createLink(action:"index", id:"${organisation.organisationId}")}',
            adHocReportsUrl: '${g.createLink(action:"getAdHocReportTypes")}',
            dashboardUrl: "${g.createLink(controller: 'report', action: 'loadReport')}",
            activityViewUrl: '${g.createLink(controller: 'activity', action:'index')}',
            activityEditUrl: '${g.createLink(controller: 'activity', action:'enterData')}',
            reportCreateUrl: '${g.createLink( action:'createAdHocReport')}',
            returnTo: '${g.createLink(action:'index', id:"${organisation.organisationId}")}'
            };
    </r:script>
    <r:require modules="wmd,knockout,mapWithFeatures,amplify,organisation,projects,jquery_bootstrap_datatable,datepicker"/>

</head>
<body>


    <div class="container-fluid organisation-header organisation-banner" data-bind="style:{'backgroundImage':bannerUrl}">
        <div class="row-fluid">
            <ul class="breadcrumb">
                <li>
                    <g:link controller="home">Home</g:link> <span class="divider">/</span>
                </li>
                <li class="active"><g:link controller="organisation" action="list">Organisations</g:link> <span class="divider">/</span></li>
                <li class="active" data-bind="text:name"/>
            </ul>
            <button class="btn pull-right btn-warn" data-bind="click:deleteOrganisation"><i class="icon-remove"></i> Delete</button>
            <button class="btn pull-right" data-bind="click:editOrganisation"><i class="icon-edit"></i> Edit</button>

            <h2 data-bind="text:name"></h2>

        </div>
    </div>
    <div class="container-fluid">

        <div class="row-fluid" data-bind="template:detailsTemplate"></div>

        <g:if test="${organisation.projects}">

            <div class="row-fluid">
                <ul class="nav nav-tabs" data-tabs="tabs">
                    <g:if test="${organisation.reports}"><li class="active tab"><a id="reporting-tab" data-toggle="tab" href="#reporting">Reporting</a></li></g:if>
                    <li class="<g:if test="${!organisation.reports}">active </g:if>tab"><a id="project-tab" data-toggle="tab" href="#projects">Projects</a></li>
                    <li class="tab"><a id="dashboard-tab" data-toggle="tab" href="#dashboard">Dashboard</a></li>

                </ul>
            </div>
            <div class="row-fluid" id="save-agreement-result-placeholder"></div>
            <div class="tab-content row-fluid">
                <div class="<g:if test="${!organisation.reports}">active </g:if>tab-pane" id="projects">
                        <table id="projectList" class="table table-striped" style="width:100%;">
                            <thead></thead>
                            <tbody></tbody>
                            <tfoot>
                            <tr><td colspan="6"></td><td><strong><span class="total"></span></strong></td><td></td></tr>
                            </tfoot>
                        </table>
                </div>

                <div class="tab-pane" id="dashboard">
                    <div class="row-fluid">
                        <span class="span12"><h4>Report: </h4><select id="dashboardType" name="dashboardType"><g:if test="${organisation.reports}"><option value="greenArmy">Green Army</option></g:if><option value="outputs">Activity Outputs</option></select></span>
                    </div>
                    <div class="loading-message">
                        <r:img dir="images" file="loading.gif" alt="saving icon"/> Loading...
                    </div>
                    <div id="dashboard-content">

                    </div>

                </div>

                <g:if test="${organisation.reports}">
                    <!-- ko stopBinding: true -->

                    <div class="tab-pane active" id="reporting">

                        <div class="control-group" style="margin-bottom: 5px;">
                            <span class="controls"><button class="btn btn-success pull-right" style="margin-bottom: 5px;" data-bind="click:addReport"><i class="icon-white icon-plus"></i> New ad hoc Report</button></span>
                        </div>

                        <table class="table table-striped" style="width:100%;">
                            <thead>

                            <tr>
                                <th>Actions</th>
                                <th>Programme</th>
                                <th>Report Activity</th>
                                <th>Date Due<br/><label for="hide-future-reports"><input id="hide-future-reports" type="checkbox" data-bind="checked:hideFutureReports"> Current reports only</label>
                                </th>

                                <th>Report Progress</th>
                                <th>Status<br/><label for="hide-approved-reports"><input id="hide-approved-reports" type="checkbox" data-bind="checked:hideApprovedReports"> Hide approved reports</label></th>
                            </tr>
                            </thead>
                            <tbody data-bind="foreach:{ data:filteredReports, as:'report' }">

                                <tr>
                                    <td>
                                        <button type="button" class="btn btn-container" data-bind="click:$root.viewAllReports"><i data-bind="css:{'icon-plus':!activitiesVisible(), 'icon-minus':activitiesVisible()}" title="List all project reports"></i></button>
                                        <button type="button" class="btn btn-container" data-bind="visible:editable, click:$root.editReport"><i class="icon-edit" data-bind="attr:{title:title}" title="Edit reports for all projects in spreadsheet format"></i></button>
                                    </td>
                                    <td data-bind="text:report.programme"></td>
                                    <td><a data-bind="visible:editable, attr:{href:editUrl, title:title}" title="Edit reports for all projects in spreadsheet format"><span data-bind="text:description"></span></a>
                                        <span data-bind="visible:!editable, text:description"></span>
                                    </td>
                                    <td data-bind="text:dueDate.formattedDate()"></td>
                                    <td>
                                        <div class="progress active"  data-bind="css:{'progress-success':percentComplete>=100, 'progress-info':percentComplete < 100}">
                                            <div class="bar" data-bind="style:{width:percentComplete+'%'}"></div>
                                        </div>
                                        <div class="progress-label"> <span data-bind="text:'Reporting completed for '+finishedCount+' of '+count+' projects'"></span></div>

                                    </td>
                                    <td><span class="label" data-bind="text:approvalStatus, css:{'label-success':approvalStatus=='Report approved', 'label-info':approvalStatus=='Report submitted', 'label-warning':approvalStatus == 'Report not submitted'}"></span></td>

                                <tr data-bind="visible:report.activitiesVisible()">
                                    <td colspan="6">
                                        <table style="width:100%">
                                            <thead>
                                            <tr>
                                                <td>Project</td> <td>Report</td><td>Report Status</td><td>Stage Report Status</td>
                                            </tr>
                                            </thead>
                                            <tbody data-bind="foreach:{data:report.activities, as:'activity'}">

                                                <tr>

                                                    <td>
                                                        <a data-bind="attr:{'href':fcConfig.viewProjectUrl+'/'+projectId}" title="Open the project page">
                                                            <span data-bind="text:$root.getProject(projectId).name"></span>
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <a data-bind="attr:{'href':fcConfig.activityEditUrl+'/'+activityId+'?returnTo='+fcConfig.organisationViewUrl}" title="Enter data for the report">
                                                            <span data-bind="text:description"></span>
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <span class="label" data-bind="text:progress, activityProgress:progress"></span>
                                                    </td>
                                                    <td>
                                                        <span class="label" data-bind="text:$root.publicationStatusLabel(publicationStatus), css:{'label-success':publicationStatus=='published', 'label-info':publicationStatus=='pendingApproval', 'label-warning':publicationStatus == 'unpublished' || !publicationStatus}"></span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>

                            </tr>
                            </tbody>

                    </table>

                    <div id="addReport" class="modal fade" data-bind="with:newReport" style="display:none;">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" id="title">Add Report</h4>
                                </div>

                                <div class="modal-body">
                                    <form class="form-horizontal" id="reportForm">

                                        <div class="control-group">
                                            <label class="control-label" for="project">Project</label>

                                            <div class="controls">
                                                <select id="project" style="width: 97%;" data-bind="options:$parent.projects, optionsText: 'name', value:project"></select>
                                            </div>
                                        </div>

                                        <div class="control-group">
                                            <label class="control-label" for="project">Report Type</label>

                                            <div class="controls">
                                                <select id="reportType" style="width: 97%;" data-bind="enable:project(), options:availableReports, value:type"></select>
                                            </div>
                                        </div>


                                    </form>
                                </div>
                                <div class="modal-footer control-group">
                                    <div class="controls">
                                        <button type="button" class="btn btn-success"
                                                data-bind="enable:type() && project(), click:save">Create</button>
                                        <button class="btn" data-bind="click:function() {$('#addReport').modal('hide')}">Cancel</button>


                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                    </div>

                    <!-- /ko -->
                </g:if>

            </div>

        </g:if>
        <g:else>
            <div class="row-fluid">
               <span class="span12"><h4>${organisation.name} is not currently involved in any projects.</h4></span>
            </div>
        </g:else>
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
    <span class="span3">
        <h4>News and events</h4>
        <div class="well" data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'Nothing at this time'"></div>

    </span>
</script>
<script id="noMainImageTemplate" type="text/html">
    <span class="span9">
        <h4>Description</h4>
        <div class="well" data-bind="html:description.markdownToHtml()"></div>
        <div class="smallFont" data-bind="visible:url()">Learn more at: <a data-bind="attr:{href:url}"><span data-bind="text:url"></span></a></div>

    </span>
    <span class="span3">
        <h4>News and events</h4>
        <div class="well" data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'Nothing at this time'">

        </div>

    </span>
</script>

<r:script>

    $(function () {

        var organisation =<fc:modelAsJavascript model="${organisation}"/>;
        var organisationViewModel = new OrganisationViewModel(organisation);

        ko.applyBindings(organisationViewModel);


        var reports = <fc:modelAsJavascript model="${organisation.reports}"/>;
        var projects = <fc:modelAsJavascript model="${organisation.projects}"/>;


        var ActivityViewModel = function(activity) {
            var self = this;
            $.extend(self, activity);
            self.publicationStatus = activity.publicationStatus ? activity.publicationStatus : 'not approved';
        };

        var ReportViewModel = function(report) {
            $.extend(this, report);
            var self = this;

            self.dueDate = ko.observable(report.dueDate).extend({simpleDate:false})
            var baseUrl = '${createLink(action:'report', id:organisation.organisationId)}';
            self.editUrl = '';
            self.percentComplete = function() {
                if (report.count == 0) {
                    return 0;
                }
                return report.finishedCount / report.count * 100;
            }();

            self.toggleActivities = function() {
                self.activitiesVisible(!self.activitiesVisible());
            };
            self.activitiesVisible = ko.observable(false);
            self.activities = [];
            $.each(report.activities, function(i, activity) {
                self.activities.push(new ActivityViewModel(activity));
            });
            self.editable = report.bulkEditable || self.activities.length == 1;
            self.title = 'Expand the activity list to complete the reports';
            if (report.bulkEditable) {
                self.title = 'Click to complete the reports in a spreadsheet format';
                self.editUrl = baseUrl + '?type='+report.type+'&plannedStartDate='+report.plannedStartDate+'&plannedEndDate='+report.plannedEndDate+'&returnTo='+fcConfig.returnTo;
            }
            else if (self.editable) {
                self.title = 'Click to complete the report';
                self.editUrl = fcConfig.activityEditUrl + '/' + self.activities[0].activityId + '?returnTo='+fcConfig.organisationViewUrl;
            }
        };

        var ReportsViewModel = function(reports, projects) {
            var self = this;
            self.projects = projects;
            self.allReports = ko.observableArray(reports);
            self.hideApprovedReports = ko.observable(true);
            self.hideFutureReports = ko.observable(true);

            self.filteredReports = ko.computed(function() {
                if (!self.hideApprovedReports() && !self.hideFutureReports()) {
                    return self.allReports();
                }
                var filteredReports = [];
                var nextMonth = moment().add(1, 'months').format();

                $.each(self.allReports(), function(i, report) {
                    if (self.hideApprovedReports() && report.publicationStatus === 'published') {
                        return;
                    }

                    if (self.hideFutureReports() && report.dueDate > nextMonth) {
                        return;
                    }
                    filteredReports.push(new ReportViewModel(report));
                });
                filteredReports.sort(function(r1, r2) {

                    var result = ( ( r1.dueDate() == r2.dueDate() ) ? 0 : ( ( r1.dueDate() > r2.dueDate() ) ? 1 : -1 ) );
                    if (result === 0) {
                        result = ( ( r1.type == r2.type ) ? 0 : ( ( r1.type > r2.type ) ? 1 : -1 ) );
                    }
                    return result;
                });
                return filteredReports;
            });

            self.editReport = function(report) {
                window.location = report.editUrl;
            };

            self.viewAllReports = function(report) {
                report.toggleActivities();
            };

            self.getProject = function(projectId) {
                var projects = $.grep(self.projects, function(project) {
                    return project.projectId === projectId;
                });
                return projects ? projects[0] : {name:''};
            };

            self.addReport = function() {
                $('#addReport').modal('show');
            };

            self.publicationStatusLabel = function(publicationStatus) {
                switch (publicationStatus) {
                    case 'unpublished':
                        return '${g.message(code: 'report.publicationStatus.unpublished')}';
                    case 'pendingApproval':
                        return '${g.message(code:'report.publicationStatus.pendingApproval')}';
                    case 'published':
                        return '${g.message(code:'report.publicationStatus.published')}';
                    default:
                        return '${g.message(code: 'report.publicationStatus.')}';
                }
            };


            // Data model for the new report dialog.
            var AdHocReportViewModel = function() {

                var self = this;
                self.project =ko.observable();
                self.type = ko.observable();

                self.projectId = ko.computed(function() {
                    if (self.project()) {
                        return self.project().projectId;
                    }
                });
                self.plannedStartDate = ko.computed(function() {
                    if (self.project()) {
                        return self.project().plannedStartDate;
                    }
                });
                self.plannedEndDate = ko.computed(function() {
                    if (self.project()) {
                        return self.project().plannedEndDate;
                    }
                });
                self.availableReports = ko.observableArray([]);

                self.project.subscribe(function(project) {
                    $.get(fcConfig.adHocReportsUrl+'/'+project.projectId).done(function(data) {
                        self.availableReports(data);
                    })

                });

                self.save = function() {
                    var reportDetails = ko.mapping.toJS(this, {'ignore':['project', 'save']});

                    var reportUrl = fcConfig.reportCreateUrl + '?' + $.param(reportDetails) + '&returnTo='+fcConfig.organisationViewUrl;

                    window.location.href = reportUrl;
                };
            };
            self.newReport = new AdHocReportViewModel();

        };
        <g:if test="${organisation.projects && organisation.reports}">
        ko.applyBindings(new ReportsViewModel(reports, projects), document.getElementById('reporting'));
        </g:if>
    $('#dashboardType').change(function(e) {
        var $content = $('#dashboard-content');
        var $loading = $('.loading-message');
        $content.hide();
        $loading.show();

        var reportType = $('#dashboardType').val();

         $.get(fcConfig.dashboardUrl, {fq:'organisationFacet:'+organisation.name, report:reportType}).done(function(data) {
            $content.html(data);
            $loading.hide();
            $content.show();
            $('#dashboard-content .helphover').popover({animation: true, trigger:'hover', container:'body'});
        });

    }).trigger('change');

    var projectUrlRenderer = function(data, type, row, meta) {
        var projectId = projects[meta.row].projectId;
        return '<a href="'+fcConfig.viewProjectUrl+'/'+projectId+'">'+data+'</a>';
        };
        var dateRenderer = function(data) {
            return convertToSimpleDate(data, false);
        };
        var agreementDateRenderer = function(data, type, row, meta) {
            var program = projects[meta.row].associatedProgram;
            if (program && program == 'Green Army') {
                var cell = '<a class="agreementDate">';


                if (!data) {
                    cell += 'Enter date';
                }
                else {
                    cell += dateRenderer(data);
                }
                cell += '</a>';
                return cell;
            }

            return 'n/a';
        }
        var statusRenderer = function(data) {
            var badge = 'badge';
            if (data == 'active') {
                badge += ' badge-success';
            }
            return '<span class="'+badge+'">'+data+'</span>';
        }
        var projectListHeader =  [{title:'Grant ID', width:'10%', render:projectUrlRenderer}, {title:'Name', width:'30%'}, {title:'Agreement Date', width:'10%', render:agreementDateRenderer}, {title:'From Date', width:'10%', render:dateRenderer}, {title:'To Date', width:'10%', render:dateRenderer}, {title:'Status', width:'10%', render:statusRenderer}, {title:'Funding', width:'10%'}, {title:'Programme', width:'10%'}];

        var projectRows = [];
        $.each(projects, function(i, project) {
            projectRows.push([project.grantId || '', project.name || '', project.serviceProviderAgreementDate || '', project.plannedStartDate || '', project.plannedEndDate || '', project.status || '', project.funding || '', project.associatedProgram || '']);
        });


        /** changes the cell contents to display a date picker and autosaves the agreement date once the date changes */
        var editAgreementDate = function(e) {

            var api = $('#projectList').dataTable().api();
            var cell = $(e.target).parents('td');
            cell.addClass('editing');
            var apiCell = api.cell('.editing');
            var value = apiCell.data();

            var current = cell.children();
            current.hide();
            var input = $('<input name="agreementDate" class="input-small">').datepicker({format: 'dd-mm-yyyy', autoclose: true}).appendTo(cell);

            var currentDate = stringToDate(value);
            if (currentDate) {
                var widget = input.data("datepicker");
                widget.setDate(currentDate);
            }
            input.datepicker('show');

            var changeHandler = function() {
                var project = projects[apiCell.index().row];
                cell.removeClass('editing');
                var date = input.datepicker('getDate');
                input.remove();
                var spinner = $('<r:img dir="images" file="ajax-saver.gif" alt="saving icon"/>').css('margin-left', '10px');
                cell.append(spinner);
                current.show();
                var isoDate = convertToIsoDate(date);
                $.ajax({
                         url: fcConfig.updateProjectUrl+'/'+project.projectId,
                         type: 'POST',
                         data: '{"serviceProviderAgreementDate":"'+isoDate+'"}',
                         contentType: 'application/json',
                         success: function (data) {
                             if (data.error) {
                                 alert(data.detail + ' \n' + data.error);
                             } else {
                                 apiCell.data(isoDate);
                             }
                         },
                         error: function (data) {
                             if (data.status == 401) {
                                alert("You do not have permission to edit this project.");
                             }
                             else {
                                alert('An unhandled error occurred: ' + data.status);
                             }
                        },
                        complete: function () {
                            spinner.remove();
                        }
                        });
            };

            ko.utils.registerEventHandler(input, "changeDate", changeHandler);
            ko.utils.registerEventHandler(input, "hide", changeHandler);

        };

        $('#projectList').dataTable( {
            "data": projectRows,
            "autoWidth":false,
            "columns": projectListHeader,
            "initComplete":function(settings) {
                $('#projectList tbody').on('click', 'a.agreementDate', editAgreementDate);
            },
            "footerCallback": function ( tfoot, data, start, end, display ) {
                var api = this.api();

                // Remove the formatting to get integer data for summation
                var intVal = function ( i ) {
                    return typeof i === 'string' ?
                        i.replace(/[\$,]/g, '')*1 :
                        typeof i === 'number' ?
                            i : 0;
                };

                // Total over all pages
                var total = api
                    .column( 6 )
                    .data()
                    .reduce( function (a, b) {
                        return intVal(a) + intVal(b);
                    } );

                // Total over this page
                var pageTotal = api
                    .column( 6, { page: 'current'} )
                    .data()
                    .reduce( function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0 );

                // Update footer
                $(api.column(6).footer()).find('span.total').text(
                    '$'+pageTotal +' ( $'+ total +' total)'
                );
            }
        });
    });

</r:script>

</body>


</html>