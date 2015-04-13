
var Site = function (site, feature) {
    var self = this;
    this.name = ko.observable(site.name);
    this.siteId = site.siteId;
    this.state = ko.observable('');
    this.nrm = ko.observable('');
    this.address = ko.observable("");
    this.feature = feature;
    this.setAddress = function (address) {
        if (address.indexOf(', Australia') === address.length - 11) {
            address = address.substr(0, address.length - 11);
        }
        self.address(address);
    };
};

var SitesViewModel =  function(sites, map, mapFeatures, isUserEditor) {

    var self = this;
    // sites
    var features = [];
    if (mapFeatures.features) {
        features = mapFeatures.features;
    }
    self.sites = $.map(sites, function (obj, i) {
        return new Site(obj, features[i])
    });
    self.sitesFilter = ko.observable("");
    self.throttledFilter = ko.computed(self.sitesFilter).extend({throttle: 400});
    self.filteredSites = ko.observableArray(self.sites);
    self.displayedSites = ko.observableArray();
    self.offset = ko.observable(0);
    self.pageSize = 10;
    self.isUserEditor = ko.observable(isUserEditor);
    self.getSiteName = function (siteId) {
        var site;
        if (siteId !== undefined && siteId !== '') {
            site = $.grep(self.sites, function (obj, i) {
                return (obj.siteId === siteId);
            });
            if (site.length > 0) {
                return site[0].name();
            }
        }
        return '';
    };
    // Animation callbacks for the lists
    self.showElement = function (elem) {
        if (elem.nodeType === 1) $(elem).hide().slideDown()
    };
    self.hideElement = function (elem) {
        if (elem.nodeType === 1) $(elem).slideUp(function () {
            $(elem).remove();
        })
    };
    self.clearSiteFilter = function () {
        self.sitesFilter("");
    };
    self.nextPage = function () {
        self.offset(self.offset() + self.pageSize);
        self.displaySites();
    };
    self.prevPage = function () {
        self.offset(self.offset() - self.pageSize);
        self.displaySites();
    };
    self.displaySites = function () {
        map.clearFeatures();

        self.displayedSites(self.filteredSites.slice(self.offset(), self.offset() + self.pageSize));

        var features = $.map(self.displayedSites(), function (obj, i) {
            return obj.feature;
        });
        map.replaceAllFeatures(features);

    };

    self.throttledFilter.subscribe(function (val) {
        self.offset(0);

        self.filterSites(val);
    });

    self.filterSites = function (filter) {
        if (filter) {
            var regex = new RegExp('\\b' + filter, 'i');

            self.filteredSites([]);
            $.each(self.sites, function (i, site) {
                if (regex.test(site.name())) {
                    self.filteredSites.push(site);
                }
            });
            self.displaySites();
        }
        else {
            self.filteredSites(self.sites);
            self.displaySites();
        }
    };
    self.clearFilter = function (model, event) {

        self.sitesFilter("");
    };
    self.map = ko.observable();

    this.highlight = function () {
        map.highlightFeatureById(this.name());
    };
    this.unhighlight = function () {
        map.unHighlightFeatureById(this.name());
    };
    this.removeAllSites = function () {
        bootbox.confirm("Are you sure you want to remove these sites? This will remove the links to this project but will NOT remove the sites from the site.", function (result) {
            if (result) {
                var that = this;
                $.get(fcConfig.sitesDeleteUrl, function (data) {
                    if (data.status === 'deleted') {
                        //self.sites.remove(that);
                    }
                    //FIXME - currently doing a page reload, not nice
                    document.location.href = here;
                });
            }
        });
    };
    this.editSite = function (site) {
        var url = fcConfig.siteEditUrl + '/' + site.siteId + '?returnTo=' + fcConfig.returnTo;
        document.location.href = url;
    };
    this.deleteSite = function (site) {
        bootbox.confirm("Are you sure you want to remove this site from this project?", function (result) {
            if (result) {

                $.get(fcConfig.siteDeleteUrl + '?siteId=' + site.siteId, function (data) {
                    $.each(self.sites, function (i, tmpSite) {
                        if (site.siteId === tmpSite.siteId) {
                            self.sites.splice(i, 1);
                            return false;
                        }
                    });
                    self.filterSites(self.sitesFilter());
                });

            }
        });
    };
    this.viewSite = function (site) {
        var url = fcConfig.siteViewUrl + '/' + site.siteId + '?returnTo=' + fcConfig.returnTo;
        document.location.href = url;
    };
    this.addSite = function () {
        document.location.href = fcConfig.siteCreateUrl;
    };
    this.addExistingSite = function () {
        document.location.href = fcConfig.siteSelectUrl;
    };
    this.uploadShapefile = function () {
        document.location.href = fcConfig.siteUploadUrl;
    };
    self.triggerGeocoding = function () {
        if (!map) {
            return;
        }
        ko.utils.arrayForEach(self.sites, function (site) {
            map.getAddressById(site.name(), site.setAddress);
        });
    };
};