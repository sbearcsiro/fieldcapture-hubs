
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
  <title>Create | Activity | Field Capture</title>
  <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jstimezonedetect/1.0.4/jstz.min.js"></script>
  <r:script disposition="head">
    var fcConfig = {
        serverUrl: "${grailsApplication.config.grails.serverURL}",
        projectViewUrl: "${createLink(controller: 'project', action: 'index')}/",
        siteViewUrl: "${createLink(controller: 'site', action: 'index')}/"
        },
        here = document.location.href;
  </r:script>
  <r:require modules="knockout,jqueryValidationEngine,datepicker,slickgrid"/>
    <style type="text/css">
        input.editor-text {box-sizing:border-box; width: 100%;}
    </style>
</head>
<body>
<div class="row-fluid">
    <span class="span12">
    <div id="myGrid" style="width:100%;height:500px;"></div>
    </span>
</div>
<r:script>

    $(function () {

        //var options = {
        //    editable: true,
        //    enableAddRow: true,
        //    enableCellNavigation: true,
        //    asyncEditorLoading: true,
        //    forceFitColumns: false,
        //    topPanelHeight: 25
        //};
        <fc:slickGridOptions/>

        var columnDefns = <fc:slickGridColumns model="${model}"/>
        var columns = [];
        $.each(columnDefns, function(i, col) {
            columns.push($.extend({}, col, {editor:Slick.Editors[col.editorType]}));
        });


        var data = <fc:slickGridData data="${data}"/>;



        grid = new Slick.Grid("#myGrid", data, columns, options);
    })

</r:script>

</body>
</html>