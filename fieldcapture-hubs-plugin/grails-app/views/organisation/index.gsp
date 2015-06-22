<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title>${organisation.name.encodeAsHTML()} | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <g:set var="loadPermissionsUrl" value="${createLink(controller: 'organisation', action: 'getMembersForOrganisation', id:organisation.organisationId)}"/>

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
            organisationMembersUrl: "${loadPermissionsUrl}",
            adHocReportsUrl: '${g.createLink(action:"getAdHocReportTypes")}',
            dashboardUrl: "${g.createLink(controller: 'report', action: 'loadReport')}",
            activityViewUrl: '${g.createLink(controller: 'activity', action:'index')}',
            activityEditUrl: '${g.createLink(controller: 'activity', action:'enterData')}',
            reportCreateUrl: '${g.createLink( action:'createAdHocReport')}',
            submitReportUrl: '${g.createLink( action:'ajaxSubmitReport', id:"${organisation.organisationId}")}',
            approveReportUrl: '${g.createLink( action:'ajaxApproveReport', id:"${organisation.organisationId}")}',
            rejectReportUrl: '${g.createLink( action:'ajaxRejectReport', id:"${organisation.organisationId}")}',
            returnTo: '${g.createLink(action:'index', id:"${organisation.organisationId}")}'
            };
    </r:script>
    <style type="text/css">
        #projectList th {
            white-space: normal;
        }
        .admin-action {
            width:7em;
        }
    </style>
    <r:require modules="wmd,knockout,mapWithFeatures,amplify,organisation,projects,jquery_bootstrap_datatable,datepicker,jqueryValidationEngine"/>
</head>
<body>


    <div class="container-fluid organisation-header organisation-banner" data-bind="style:{'backgroundImage':asBackgroundImage(bannerUrl())}">
        <div class="row-fluid">
            <ul class="breadcrumb">
                <li>
                    <g:link controller="home">Home</g:link> <span class="divider">/</span>
                </li>
                <li class="active"><g:link controller="organisation" action="list">Organisations</g:link> <span class="divider">/</span></li>
                <li class="active" data-bind="text:name"/>
            </ul>

            <h2 data-bind="text:name"></h2>
        </div>
    </div>
    <div class="container-fluid">

        <g:render template="/shared/flashScopeMessage"/>
        <div class="row-fluid space-after" data-bind="template:detailsTemplate"></div>

            <div class="row-fluid">
                <ul class="nav nav-tabs" data-tabs="tabs">

                    <ul id="organisationTabs" class="nav nav-tabs big-tabs">
                        <fc:tabList tabs="${content}"/>
                    </ul>
                </ul>
            </div>
            <div class="row-fluid" id="save-agreement-result-placeholder"></div>
            <div class="tab-content row-fluid">

                <fc:tabContent tabs="${content}"/>

            </div>
    </div>


<script id="hasMainImageTemplate" type="text/html">
    <span class="span3">
        <img data-bind="attr:{src:mainImageUrl}" style="width:100%;">
    </span>

    <span class="span6">
        <h4>Description</h4>
        <div class="well" data-bind="html:description.markdownToHtml()"></div>
        <span data-bind="visible:orgType()"><h4 style="display:inline">Type&nbsp;</h4> <span data-bind="text:orgTypeDisplayOnly"></span></span>
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
        <span data-bind="visible:orgType()"><h4 style="display:inline">Type&nbsp;</h4><span data-bind="text:orgTypeDisplayOnly"></span></span>
        <div class="smallFont" data-bind="visible:url()">Learn more at: <a data-bind="attr:{href:url}"><span data-bind="text:url"></span></a></div>
    </span>
    <span class="span3">
        <h4>News and events</h4>
        <div class="well" data-bind="html:newsAndEvents()?newsAndEvents.markdownToHtml():'Nothing at this time'">

        </div>

    </span>
</script>
<g:render template="/shared/declaration"/>

<r:script>

    $(function () {

        var organisation =<fc:modelAsJavascript model="${organisation}"/>;
        var organisationViewModel = new OrganisationViewModel(organisation);

        ko.applyBindings(organisationViewModel);


        var projects = <fc:modelAsJavascript model="${organisation.projects}"/>;
        $.each(projects, function(i, project) {
            project.startDate = project.contractStartDate || project.plannedStartDate;
            project.duration = project.contractDurationInWeeks || project.plannedDurationInWeeks;
        });

        <g:if test="${content.reporting?.visible}">
            var reports = <fc:modelAsJavascript model="${organisation.reports}"/>;
            ko.applyBindings(new ReportsViewModel(reports, projects), document.getElementById('reporting-content'));
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

        var organisationTabStorageKey = 'organisation-page-tab';
        var initialisedSites = false;
        $('a[data-toggle="tab"]').on('shown', function (e) {
            var tab = e.currentTarget.hash;
            amplify.store(organisationTabStorageKey, tab);
            if (!initialisedSites && tab == '#sites') { // Google maps doesn't initialise well unless it is visible.
                generateMap(['organisationFacet:'+organisation.name], false, {includeLegend:false});
                initialisedSites = true;
            }
        });

        var storedTab = amplify.store(organisationTabStorageKey);

        if (storedTab) {
            $(storedTab + '-tab').tab('show');
        }

        var projectUrlRenderer = function(data, type, row, meta) {
            var projectId = projects[meta.row].projectId;
            return '<a href="'+fcConfig.viewProjectUrl+'/'+projectId+'">'+data+'</a>';
        };
        var dateRenderer = function(data, type, row) {
            if (type == 'display' || type == 'filter') {
                return convertToSimpleDate(data, false);
            }
            return data;
        };
        var agreementDateRenderer = function(data, type, row, meta) {
            var program = projects[meta.row].associatedProgram;
            if (program && program == 'Green Army') {
                var cell = '<a class="agreementDate">';


                if (!data) {
                    cell += 'Enter date';
                }
                else {
                    cell += dateRenderer(data, type, row);
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
        var projectListHeader =  [
            {title:'Grant ID', width:'10%', render:projectUrlRenderer, data:'grantId'},
            <g:if test="${showReports}">{title:'Work Order', width:'10%', data:'workOrderId', defaultContent:''},</g:if>
            {title:'Name', width:'25%', data:'name'},
            <g:if test="${showReports}">{title:'Agreement Date', width:'10%', render:agreementDateRenderer, data:'serviceProviderAgreementDate'},</g:if>
            {title:'Contracted Start Date', width:'8%', render:dateRenderer, data:'startDate'},
            {title:'Contracted Project Length (weeks)', width:'4%', data:'duration', defaultContent:''},
            {title:'From Date', width:'8%', render:dateRenderer, data:'plannedStartDate'},
            {title:'To Date', width:'8%', render:dateRenderer, data:'plannedEndDate'},
            {title:'Actual duration', width:'4%', data:'plannedDurationInWeeks', defaultContent:''},

            {title:'Status', width:'4%', render:statusRenderer, data:'status'},
            {title:'Funding', width:'8%', data:'funding'},
            {title:'Programme', width:'13%', data:'associatedProgram'}];

        /** changes the cell contents to display a date picker and autosaves the agreement date once the date changes */
        var editAgreementDate = function(e) {

            var api = $('#projectList').dataTable().api();
            var cell = $(e.target).parents('td');
            cell.addClass('editing');
            var apiCell = api.cell('.editing');
            var value = apiCell.data();

            var current = cell.children();
            current.hide();
            var span = $('<span class="input-append"/>').appendTo(cell);
            var input = $('<input name="agreementDate" class="input-small">').datepicker({format: 'dd-mm-yyyy', autoclose: true, clearBtn:true, keyboardNavigation:false}).appendTo(span);

            var saveDate = function(isoDate) {
                cell.removeClass('editing');
                span.remove();
                var spinner = $('<r:img dir="images" file="ajax-saver.gif" alt="saving icon"/>').css('margin-left', '10px');
                cell.append(spinner);
                current.show();
                var project = projects[apiCell.index().row];
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
            }

            var currentDate = stringToDate(value);
            if (currentDate) {
                var widget = input.data("datepicker");
                widget.setDate(currentDate);
            }
            input.datepicker('show');

            var changeHandler = function() {
                var dateVal = input.val();
                var isoDate = '';
                if (dateVal) {
                    var date = input.datepicker('getDate');
                    isoDate = convertToIsoDate(date);
                }

                if (isoDate != value) {
                    saveDate(isoDate);
                }
                else {
                    noSave();
                }

            };

            var noSave = function() {
                cell.removeClass('editing');
                span.remove();
                current.show();
            };


            ko.utils.registerEventHandler(input, "hide", changeHandler);
        };

        $('#projectList').dataTable( {
            "data": projects,
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

                var fundingColumn = -1;
                $.each(projectListHeader, function(i, column) {
                    if (column.data == 'funding') {
                        fundingColumn = i;
                        return false;
                    }
                });

                if (fundingColumn < 0) {
                    return;
                }
                // Total over all pages
                var total = api
                    .column( fundingColumn )
                    .data()
                    .reduce( function (a, b) {
                        return intVal(a) + intVal(b);
                    } );

                // Total over this page
                var pageTotal = api
                    .column( fundingColumn, { page: 'current'} )
                    .data()
                    .reduce( function (a, b) {
                        return intVal(a) + intVal(b);
                    }, 0 );

                // Update footer
                var footerRow = $(api.table().footer()).find('tr');
                var col = footerRow.find('td.fundingTotal');
                if (!col.length) {
                    footerRow.append('<td colspan="'+fundingColumn+'"></td>');
                    footerRow.append('<td class="fundingTotal">$'+pageTotal + ' ($'+total + ' total)'+'</td>');

                }
                else {
                    col.text('$'+pageTotal + ' ($'+total + ' total)');
                }

            }
        });


        <g:if test="${content.admin.visible}">
        populatePermissionsTable(fcConfig.organisationMembersUrl);
        </g:if>
    });

</r:script>

</body>


</html>