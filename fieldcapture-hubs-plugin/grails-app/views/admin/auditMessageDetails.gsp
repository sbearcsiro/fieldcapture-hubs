<%@ page import="au.org.ala.fieldcapture.DateUtils" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="adminLayout"/>
		<title>Admin - Audit Message Detail | Data capture | Atlas of Living Australia</title>
		<style type="text/css" media="screen">
		</style>
	</head>
	<body>
        <r:require modules="pretty_text_diff"/>
        <h4>Audit ${message.entityType?.substring(message.entityType?.lastIndexOf('.')+1)}: ${message?.entity?.name} ${message?.entity?.type} </h4>



    <div class="row-fluid">
        <div class="span6">
            <h4>${userDetails?.displayName} <g:encodeAs codec="HTML">${message.userId ?: '<anon>'}</g:encodeAs> </h4>
            <h5><small>${message?.eventType} : ${DateUtils.displayFormatWithTime(message?.date)}</small></h5>
        </div>
        <div class="span6 text-right">
            <button id="toggle-ids" type="button" class="btn btn-default btn-small">Show Ids</button>
            <div id="ids" class="span12">
                <h6>
                    <strong>Id: </Strong><small>${message?.id}</small>
                </h6>
                <h6>
                    <Strong>Entity Id: </Strong>
                    <small><g:encodeAs codec="HTML">${message?.entityId}</g:encodeAs></small>
                </h6>
            </div>
        </div>
    </div>


    <div class="well well-small" id="wrapper">
        <div class="pull-right">
            <table>
                <tr>
                    <td style="background: #c6ffc6;"></td><td>Inserted</td>
                    <td style="background: #ffc6c6;"></td><td>Deleted</td>
                </tr>
            </table>
        </div>
        <table class="table table-striped table-bordered table-hover">
            <thead>
            <tr>
                <th width="30%"><h4>Before</h4></th>
                <th width="30%"><h4>After</h4></th>
                <th width="40%"><h4>What's changed? </h4>
                </th>
            </tr>
            </thead>
            <tbody>
            <tr>
                    <td class="original"><fc:renderJsonObject object="${compare?.entity}" /></td>
                    <td class="changed"><fc:renderJsonObject object="${message?.entity}" /></td>
                    <td style="line-height:1;" class="diff1"></td>
                </tr>
            </tbody>
        </table>
    </div>

    </body>
</html>

<r:script type="text/javascript">
    $(document).ready(function() {
        $( "#ids").hide();
        $("#wrapper tr").prettyTextDiff({
            cleanup: true,
            diffContainer: ".diff1"
        });
        $( "#toggle-ids" ).click(function() {
            $( "#ids" ).toggle();
        });
    });
</r:script>
