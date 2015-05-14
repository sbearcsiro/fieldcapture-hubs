/**
 * Knockout view model for organisation pages.
 * @param props JSON/javascript representation of the organisation.
 * @constructor
 */
OrganisationViewModel = function (props) {
    var self = $.extend(this, new Documents());
    var orgTypesMap = {
    aquarium:'Aquarium',
    archive:'Archive',
    botanicGarden:'Botanic Garden',
    conservation:'Conservation',
    fieldStation:'Field Station',
    government:'Government',
    governmentDepartment:'Government Department',
    herbarium:'Herbarium',
    historicalSociety:'Historical Society',
    horticulturalInstitution:'Horticultural Institution',
    independentExpert:'Independent Expert',
    industry:'Industry',
    laboratory:'Laboratory',
    library:'Library',
    management:'Management',
    museum:'Museum',
    natureEducationCenter:'Nature Education Center',
    nonUniversityCollege:'Non-University College',
    park:'Park',
    repository:'Repository',
    researchInstitute:'Research Institute',
    school:'School',
    scienceCenter:'Science Center',
    society:'Society',
    university:'University',
    voluntaryObserver:'Voluntary Observer',
    zoo:'Zoo'
    }
    
    self.organisationId = props.organisationId;
    self.orgType = ko.observable(props.orgType);
    self.orgTypeDisplayOnly = ko.computed(function() {
        return orgTypesMap[self.orgType()] || "Unspecified";
    });
    self.name = ko.observable(props.name);
    self.description = ko.observable(props.description).extend({markdown:true});
    self.url = ko.observable(props.url);
    self.newsAndEvents = ko.observable(props.newsAndEvents).extend({markdown:true});;

    self.breadcrumbName = ko.computed(function() {
        return self.name()?self.name():'New Organisation';
    });

    self.detailsTemplate = ko.computed(function() {
        return self.mainImageUrl() ? 'hasMainImageTemplate' : 'noMainImageTemplate';
    });

    self.projects = props.projects;

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

    self.transients = {};
    self.transients.orgTypes = [];
    for (var ot in orgTypesMap) {
        if (orgTypesMap.hasOwnProperty(ot))
            self.transients.orgTypes.push({orgType:ot, name:orgTypesMap[ot]});
    }

    self.toJS = function() {
        return ko.mapping.toJS(self,
            {ignore:['breadcrumbName', 'mainImageUrl', 'bannerUrl', 'logoUrl', 'detailsTemplate', 'transients']}
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

    return self;

}