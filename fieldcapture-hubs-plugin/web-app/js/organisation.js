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

    var logoDocument = null, bannerDocument = null, mainImageDocument = null;

    if (props.documents !== undefined && props.documents.length > 0) {
        logoDocument = $.grep(props.documents, function(elem, index) { return elem.role == 'logo'})[0];
        bannerDocument = $.grep(props.documents, function(elem, index) { return elem.role == 'banner'})[0];
        mainImageDocument = $.grep(props.documents, function(elem, index) { return elem.role == 'mainImage'})[0];
    }
    this.logoDocument = ko.observable(logoDocument);
    this.bannerDocument = ko.observable(bannerDocument);
    this.mainImageDocument = ko.observable(mainImageDocument);

    this.logoUrl = ko.computed(function() {
        return self.logoDocument() ? self.logoDocument().url : null;
    });
    this.bannerUrl = ko.computed(function() {
        return self.bannerDocument() ? 'url('+self.bannerDocument().url+')' : null;
    });
    this.mainImageUrl = ko.computed(function() {
        return self.mainImageDocument() ? self.mainImageDocument().url : null;
    });

    this.detailsTemplate = ko.computed(function() {
        return self.mainImageUrl() ? 'hasMainImageTemplate' : 'noMainImageTemplate';
    });


    this.projects = props.projects;

    self.attachLogoImage = function() {
        self.attachDocument('logo', self.logoDocument);
    };
    self.attachBannerImage = function() {
        self.attachDocument('banner', self.bannerDocument);
    };
    self.attachMainImage = function() {
        self.attachDocument('mainImage', self.mainImageDocument);
    };

    self.attachDocument = function(role, callback) {
        showDocumentAttachInModal(fcConfig.documentUpdateUrl, new DocumentViewModel({role:role, 'public':true},{key:'organisationId', value:self.organisationId}, {roles:[{id:role, name:role}], showSettings:false}), '#attachDocument')
            .done(function(result){
                callback(new DocumentViewModel(result));
            });
    };

    self.removeBannerImage = function() {
        self.deleteDocument(self.bannerDocument().documentId, self.bannerDocument);
    };

    self.removeLogoImage = function() {
        self.deleteDocument(self.logoDocument().documentId, self.logoDocument);
    };

    self.removeMainImage = function() {
        self.deleteDocument(self.mainImageDocument().documentId, self.mainImageDocument);
    };


    self.deleteDocument = function(documentId, callback) {
        $.post(fcConfig.documentDeleteUrl+'/'+documentId);
        callback(null);
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

    this.save = function() {
        if ($('.validationEngineContainer').validationEngine('validate')) {
            var orgData = JSON.stringify(ko.mapping.toJS(self, {ignore:'breadcrumbName'}));
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
    }
}