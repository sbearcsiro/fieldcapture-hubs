/**
 * Knockout view model for organisation pages.
 * @param props JSON/javascript representation of the organisation.
 * @constructor
 */
var OrganisationViewModel = function (props) {
    var self = this;
    this.organisationId = props.organisationId;
    this.name = ko.observable(props.name);
    this.description = ko.observable(props.description).extend({markdown:true});
    this.url = ko.observable(props.url);
    this.newsAndEvents = ko.observable(props.newsAndEvents).extend({markdown:true});;

    this.breadcrumbName = ko.computed(function() {
        return self.name()?self.name():'New Organisation';
    });

    self.documents = ko.observableArray();

    self.findDocumentByRole = function(documents, role) {
        for (var i=0; i<documents.length; i++) {
            if (documents[i].role === role && documents[i].status !== 'deleted') {
                return documents[i];
            }
        }
        return null;
    };
    this.logoUrl = ko.computed(function() {
        var logoDocument = self.findDocumentByRole(self.documents(), 'logo');
        return logoDocument ? logoDocument.url : null;
    });
    this.bannerUrl = ko.computed(function() {
        var bannerDocument = self.findDocumentByRole(self.documents(), 'banner');
        return bannerDocument ? 'url('+bannerDocument.url+')' : null;
    });
    this.mainImageUrl = ko.computed(function() {
        var mainImageDocument = self.findDocumentByRole(self.documents(), 'mainImage');
        return mainImageDocument ? mainImageDocument.url : null;
    });

    this.detailsTemplate = ko.computed(function() {
        return self.mainImageUrl() ? 'hasMainImageTemplate' : 'noMainImageTemplate';
    });

    this.projects = props.projects;

    self.removeBannerImage = function() {
        self.deleteDocument('banner');
    };

    self.removeLogoImage = function() {
        self.deleteDocument('logo');
    };

    self.removeMainImage = function() {
        self.deleteDocument('mainImage');
    };


    self.deleteDocument = function(role) {
        var doc = self.findDocumentByRole(self.documents(), role);
        if (doc) {
            if (doc.documentId) {
                doc.status = 'deleted';
                self.documents.valueHasMutated(); // observableArrays don't fire events when contained objects are mutated.
            }
            else {
                self.documents.remove(doc);
            }
        }
    };

    self.deleteOrganisation = function() {
        if (window.confirm("Delete this organisation?  Are you sure?")) {
            $.post(fcConfig.organisationDeleteUrl).complete(function() {
                    window.location = fcConfig.organisationListUrl;
                }
            );
        };
    };

    self.editOrganisation = function() {
       window.location = fcConfig.organisationEditUrl;

    };

    self.toJS = function() {
        return ko.mapping.toJS(self,
            {ignore:['breadcrumbName', 'mainImageUrl', 'bannerUrl', 'logoUrl', 'detailsTemplate']}
        );

    };

    self.save = function() {
        if ($('.validationEngineContainer').validationEngine('validate')) {

            var orgJs = self.toJS();
            var orgData = JSON.stringify(orgJs);
            $.ajax(fcConfig.organisationSaveUrl, {type:'POST', data:orgData, contentType:'application/json'}).done( function(data) {
                if (data.errors) {

                }
                else {
                    var orgId = self.organisationId?self.organisationId:data.organisationId;
                    window.location = fcConfig.organisationViewUrl+'/'+orgId;
                }

            }).fail( function() {

            });
        }
    };

    if (props.documents !== undefined && props.documents.length > 0) {
        $.each(['logo', 'banner', 'mainImage'], function(i, role){
            var document = self.findDocumentByRole(props.documents, role);
            if (document) {
                self.documents.push(document);
            }
        });
    }

}