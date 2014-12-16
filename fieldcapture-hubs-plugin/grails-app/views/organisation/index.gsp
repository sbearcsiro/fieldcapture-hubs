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
            documentUpdateUrl: '${g.createLink(controller:"proxy", action:"documentUpdate")}',
            documentDeleteUrl: '${g.createLink(controller:"proxy", action:"deleteDocument")}',
            organisationDeleteUrl: '${g.createLink(action:"ajaxDelete", id:"${organisation.organisationId}")}',
            organisationEditUrl: '${g.createLink(action:"edit", id:"${organisation.organisationId}")}',
            organisationListUrl: '${g.createLink(action:"list")}',
            dashboardUrl: "${g.createLink(controller: 'report', action: 'dashboardReport', params: params)}"
            };
    </r:script>
    <r:require modules="wmd,knockout,mapWithFeatures,amplify,organisation"/>

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
                    <li class="tab"><a id="project-tab" data-toggle="tab" href="#projects">Projects</a></li>
                    <li class="tab"><a id="dashboard-tab" data-toggle="tab" href="#dashboard">Dashboard</a></li>

                </ul>
            </div>
            <div class="tab-content row-fluid">
                <div class="tab-pane" id="projects">
                        <g:render template="/shared/projectsList"/>
                </div>

                <div class="tab-pane" id="dashboard">
                    <div class="loading-message">
                        <r:img dir="images" file="loading.gif" alt="saving icon"/> Loading...
                    </div>
                </div>

                <g:if test="${organisation.reports}">
                    <!-- ko stopBinding: true -->
                <div class="tab-pane active" id="reporting">

                        <table class="table table-striped" style="width:100%;">
                            <thead>

                            <tr>
                                <th>Programme</th>
                                <th>Report Activity</th>
                                <th>Date Due<br/><label for="hide-future-reports"><input id="hide-future-reports" type="checkbox" data-bind="checked:hideFutureReports"> Current reports only</label>
                                </th>
                                <th>Actions</th>
                                <th>Report Progress</th>
                                <th>Status<br/><label for="hide-approved-reports"><input id="hide-approved-reports" type="checkbox" data-bind="checked:hideFutureReports"> Hide approved reports</label></th>
                            </tr>
                            </thead>
                            <tbody data-bind="foreach:filteredReports">

                                <tr>
                                    <td data-bind="text:programme"></td>
                                    <td><a data-bind="attr:{href:editUrl}"><span data-bind="text:description"></span></a></td>
                                    <td data-bind="text:dueDate.formattedDate()"></td>
                                    <td><button type="button" class="btn btn-container" data-bind="click:$root.editReport"><i class="icon-edit" title="Edit report"></i></button></td>
                                    <td>
                                        <div class="progress active"  data-bind="css:{'progress-success':percentComplete>=100, 'progress-info':percentComplete < 100}">
                                            <div class="bar" data-bind="style:{width:percentComplete+'%'}"></div>
                                        </div>
                                        <div class="progress-label"> <span data-bind="text:'Reporting completed for '+finishedCount+' of '+count+' projects'"></span></div>

                                    </td>
                                    <td><span class="label" data-bind="text:approvalStatus, css:{'label-success':approvalStatus=='Report approved', 'label-info':approvalStatus=='Report submitted', 'label-warning':approvalStatus == 'Report not submitted'}"></span></td>
                                </tr>


                            </tbody>

                    </table>
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

        var dashboardShown = false;
        $('#dashboard-tab').on('shown', function (e) {

            if (!dashboardShown) {
                dashboardShown = true;

                $.get(fcConfig.dashboardUrl, {fq:'organisationFacet:'+organisation.name}, function(data) {
                    $('#dashboard').html(data);
                    $('#dashboard .helphover').popover({animation: true, trigger:'hover', container:'body'});
                });

            }
        });

        var reports = <fc:modelAsJavascript model="${organisation.reports}"/>;

        var ReportViewModel = function(report) {
            $.extend(this, report);

            this.dueDate = ko.observable(report.dueDate).extend({simpleDate:false})
            var baseUrl = '${createLink(action:'report', id:organisation.organisationId)}';
            this.editUrl = baseUrl + '?type='+report.type+'&plannedStartDate='+report.plannedStartDate+'&plannedEndDate='+report.plannedEndDate;

            this.percentComplete = function() {
                if (report.count == 0) {
                    return 0;
                }
                return report.finishedCount / report.count * 100;
            }();
        };

        var ReportsViewModel = function(reports) {
            var self = this;
            self.allReports = ko.observableArray(reports);
            self.hideApproved = ko.observable(true);
            self.hideFutureReports = ko.observable(true);

            self.filteredReports = ko.computed(function() {
                if (!self.hideApproved() && !self.hideFutureReports()) {
                    return self.allReports();
                }
                var filteredReports = [];
                $.each(self.allReports(), function(i, report) {
                    if (self.hideApproved() && report.publicationStatus === 'published') {
                        return;
                    }
                    var nextMonth = '2014-12-31';

                    console.log(report.dueDate);
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
            }



        };
        ko.applyBindings(new ReportsViewModel(reports), document.getElementById('reporting'));

    });

</r:script>

</body>


</html>