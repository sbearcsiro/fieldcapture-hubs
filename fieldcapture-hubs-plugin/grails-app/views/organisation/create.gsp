<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title>Create | Organisation | Field Capture</title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
    <r:script disposition="head">
        var fcConfig = {
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            organisationSaveUrl: "${createLink(action:'ajaxUpdate')}",
            organisationViewUrl: "${createLink(action:'index')}",
            documentUpdateUrl: "${createLink(controller:"proxy", action:"documentUpdate")}",
            returnTo: "${params.returnTo}"
            };
    </r:script>
    <r:require modules="knockout,jqueryValidationEngine,amplify,organisation"/>
    <style type="text/css">
        td {padding:4px;}
    </style>
</head>
<body>
<div class="container-fluid">
    <ul class="breadcrumb">
        <li>
            <g:link controller="home">Home</g:link> <span class="divider">/</span>
        </li>
        <li class="active"><g:link controller="organisation" action="list">Organisations</g:link> <span class="divider">/</span></li>
        <li class="active" data-bind="text:breadcrumbName"></li>
    </ul>

    <g:render template="organisationDetails"/>

</div>

<r:script>

    $(function () {
        var organisation = <fc:modelAsJavascript model="${organisation}"/>;
        var organisationViewModel = new OrganisationViewModel(organisation);
        autoSaveModel(organisationViewModel, fcConfig.organisationSaveUrl, {blockUIOnSave:true, blockUISaveMessage:'Creating organisation....'});
        organisationViewModel.save = function() {
            if ($('.validationEngineContainer').validationEngine('validate')) {
                organisationViewModel.saveWithErrorDetection(
                    function(data) {
                        var orgId = self.organisationId?self.organisationId:data.organisationId;

                        var url;
                        if (fcConfig.returnTo) {
                            if (fcConfig.returnTo.indexOf('?') > 0) {
                                url = fcConfig.returnTo+'&organisationId='+orgId;
                            }
                            else {
                                url = fcConfig.returnTo+'?organisationId='+orgId;
                            }
                        }
                        else {
                            url = fcConfig.organisationViewUrl+'/'+orgId;
                        }
                        window.location.href = url;
                    },
                    undefined,
                    {
                        serializeModel:function() {return organisationViewModel.modelToJSON(true);}
                    }
                );

            }
        };

        ko.applyBindings(organisationViewModel);
        $('.validationEngineContainer').validationEngine();

        $("#cancel").on("click", function() {
            document.location.href = "${createLink(action:'list')}";
        })

    });


</r:script>

</body>


</html>