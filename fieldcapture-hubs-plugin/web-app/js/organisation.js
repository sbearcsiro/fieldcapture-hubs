/**
 * Knockout view model for organisation pages.
 * @param props JSON/javascript representation of the organisation.
 * @constructor
 */
createOrganisationViewModel = function (props) {
    var orgModel = new Documents();
    orgModel.organisationId = props.organisationId;
    orgModel.name = ko.observable(props.name);
    orgModel.description = ko.observable(props.description).extend({markdown:true});
    orgModel.url = ko.observable(props.url);
    orgModel.newsAndEvents = ko.observable(props.newsAndEvents).extend({markdown:true});;

    orgModel.breadcrumbName = ko.computed(function() {
        return orgModel.name()?orgModel.name():'New Organisation';
    });

    orgModel.detailsTemplate = ko.computed(function() {
        return orgModel.mainImageUrl() ? 'hasMainImageTemplate' : 'noMainImageTemplate';
    });

    orgModel.projects = props.projects;

    orgModel.deleteOrganisation = function() {
        if (window.confirm("Delete this organisation?  Are you sure?")) {
            $.post(fcConfig.organisationDeleteUrl).complete(function() {
                    window.location = fcConfig.organisationListUrl;
                }
            );
        };
    };

    orgModel.editOrganisation = function() {
       window.location = fcConfig.organisationEditUrl;

    };

    orgModel.toJS = function() {
        return ko.mapping.toJS(orgModel,
            {ignore:['breadcrumbName', 'mainImageUrl', 'bannerUrl', 'logoUrl', 'detailsTemplate']}
        );

    };

    orgModel.save = function() {
        if ($('.validationEngineContainer').validationEngine('validate')) {

            var orgJs = orgModel.toJS();
            var orgData = JSON.stringify(orgJs);
            $.ajax(fcConfig.organisationSaveUrl, {type:'POST', data:orgData, contentType:'application/json'}).done( function(data) {
                if (data.errors) {

                }
                else {
                    var orgId = orgModel.organisationId?orgModel.organisationId:data.organisationId;
                    window.location = fcConfig.organisationViewUrl+'/'+orgId;
                }

            }).fail( function() {

            });
        }
    };

    if (props.documents !== undefined && props.documents.length > 0) {
        $.each(['logo', 'banner', 'mainImage'], function(i, role){
            var document = orgModel.findDocumentByRole(props.documents, role);
            if (document) {
                orgModel.documents.push(document);
            }
        });
    }

    return orgModel;

}