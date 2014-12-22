
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

        var activities = <fc:modelAsJavascript model="${activities}"/>;
        var outputModels = <fc:modelAsJavascript model="${outputModels}"/>;

        var helpHover = function(helpText) {
            return '<a href="#" class="helphover" data-original-title="" data-placement="top" data-container="body" data-content="'+helpText+'">'+
                       '<i class="icon-question-sign">&nbsp;</i>'+
                   '</a>';
        };
        var columns = [];
        $.each(outputModels, function(i, outputModel) {
            $.each(outputModel.dataModel, function(i, dataItem) {

                if (dataItem.computed) {
                    return;
                }
                var columnHeader = dataItem.label ? dataItem.label : dataItem.name;
                if (dataItem.description) {
                    columnHeader += helpHover(dataItem.description);
                }

                var editor = OutputValueEditor;
                if (dataItem.constraints) {
                    editor = OutputSelectEditor;
                }
                
                columns.push({
                    id: dataItem.name,
                    name: columnHeader,
                    field: dataItem.name,
                    outputName:outputModel.name,
                    options:dataItem.constraints,
                    editor:editor
                });
            });
        });

        // Add the project columns
        var projectColumn = {name:'Project', id:'projectName', field:'projectName', formatter:activityLinkFormatter};
        var progressColumn = {name:'Progress', id:'progress', field:'progress', formatter:progressFormatter};

        columns = [projectColumn].concat(columns, progressColumn);

        var grid = new Slick.Grid("#myGrid", activities, columns, options);

        $('#save').click(function() {
            var activities = grid.getData();

            // TODO Need to validate each row
            $.each(activities, function(i, activity) {
                var outputData = {outputs:activity.outputs};
                var url = fcConfig.saveUrl+'/'+activity.activityId;
                $.ajax(url, {type:'POST', data:JSON.stringify(outputData), dataType:'json', contentType:'application/json'}).done(
                    function(data) {
                        window.location = fcConfig.returnTo;
                    });
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