var ProjectActivity = function (o, pActivityForms, projectId, selected){
    var self = this;
    self.projectActivityId = ko.observable(o.projectActivityId);
    self.projectId = ko.observable(o.projectId ? o.projectId  : projectId);
    self.name = ko.observable(o.name ? o.name : "Survey name");
    self.description = ko.observable(o.description);
    self.status = ko.observable(o.status ? o.status : "active");
    self.startDate = ko.observable(o.startDate).extend({simpleDate:false});
    self.endDate = ko.observable(o.endDate).extend({simpleDate:false});
    self.commentsAllowed = ko.observable(o.commentsAllowed ? o.commentsAllowed : false);
    self.published = ko.observable(o.published ? o.published : false);
    self.current = ko.observable(selected);
    self.pActivityFormName = ko.observable(o.pActivityFormName);
    self.access = new AccessVisibilityViewModel(o.access ? o.access : []);

    var images = [];
    $.each(pActivityForms, function(index, form){
        if(form.name == self.pActivityFormName()){
            images = form.images ? form.images : [];
        }
    });

    self.pActivityFormImages =  ko.observableArray($.map(images, function (obj, i) {
        return new ImagesViewModel(obj);
    }));

    self.pActivityForms = pActivityForms;

    self.pActivityFormName.subscribe(function(formName) {
        self.pActivityFormImages.removeAll();
        $.each(self.pActivityForms, function(index, form){
            if(form.name == formName && form.images){
                for(var i =0; i < form.images.length; i++){
                    self.pActivityFormImages.push(new ImagesViewModel(form.images[i]));
                }
            }
        });
    });

    self.asJSON = function(by){
        var jsData;
        if(by == "access"){
            jsData = {};
            jsData.access =  ko.mapping.toJS(self.access, {ignore:[]});
        }
        else if(by == "form"){
            jsData = {};
            jsData.access =  ko.mapping.toJS(self.access, {ignore:[]});
        }
        else if(by == "info"){
            jsData = ko.mapping.toJS(self, {ignore:['current','pActivityForms','pActivityFormImages', 'access']});
        }
        return JSON.stringify(jsData, function (key, value) { return value === undefined ? "" : value; });
    }

};

var AccessVisibilityViewModel = function (o){
    var self = this;
    self.recordVisibility = ko.observable(o.recordVisibility);
    self.userCanChangeVisibility  = ko.observable(o.userCanChangeVisibility);
    self.coordinateSystem = ko.observable(o.coordinateSystem);
};

var ImagesViewModel = function(image){
    var self = this;
    self.thumbnail = ko.observable(image.thumbnail);
    self.url = ko.observable(image.url);
};

function ProjectActivitiesViewModel(pActivities, pActivityForms, projectId) {
    var self = this;
    self.projectId = ko.observable(projectId);
    self.coordinateSystems = [{id:'"WGS84"', name:'WGS84'}, {id:'"GDA94"', name:'GDA94'},{id:'EPSG:4326', name:'EPSG:4326'}];
    self.visibility = [{id: 'OWNER_ONLY_ACCESS', name:'Owner Only'},{id:'LIMITED_PUBLIC_ACCESS', name:'Limited public viewing'}, {id:'PUBLIC_ACCESS',name:'Full public access'}];
    self.pActivityForms = pActivityForms;

    self.formNames = ko.observableArray($.map(pActivityForms ? pActivityForms : [], function (obj, i) {
        return obj.name;
    }));

    self.projectActivities = ko.observableArray($.map(pActivities, function (obj, i) {
        return new ProjectActivity(obj, pActivityForms, self.projectId(), i == 0 ? true : false);
    }));

    self.addProjectActivity = function() {
        self.reset();
        self.projectActivities.push(new ProjectActivity([], self.pActivityForms, self.projectId(), true));
        initialiseValidator();
    };

    self.reset = function(){
        $.each(self.projectActivities(), function(i, obj){
            obj.current(false);
        });
    };

    self.setCurrent = function(pActivity) {
        self.reset();
        pActivity.current(true);
    };

    self.saveAccess = function(access){
        var caller = "access";
        self.genericUpdate(self.current().asJSON(caller), caller);
    };

    self.saveForm = function(){
        var caller = "form";
        self.genericUpdate(self.current().asJSON(caller), caller);
    };

    self.saveInfo = function(){
        var caller = "info";
        self.genericUpdate(self.current().asJSON(caller), caller);
    };


    self.deleteProjectActivity = function() {
        bootbox.confirm("Are you sure you want to delete the survey?", function (result) {
            if (result) {
                var that = this;

                var pActivity;
                $.each(self.projectActivities(), function(i, obj){
                    if(obj.current()){
                        obj.status("deleted");
                        pActivity = obj;
                    }
                });

                if(pActivity.projectActivityId() === undefined){
                    self.projectActivities.remove(pActivity);
                    if(self.projectActivities().length > 0){
                        self.projectActivities()[0].current(true);
                    }
                    showAlert("Successfully deleted.", "alert-success",  'project-activities-info-result-placeholder');
                }
                else{
                    self.genericUpdate(self.current().asJSON("info"), "info");
                }
            }
        });

    };

    self.current = function (){
        var pActivity;
        $.each(self.projectActivities(), function(i, obj){
            if(obj.current()){
                pActivity = obj;
            }
        });
        return pActivity;
    };

    self.genericUpdate = function(model, caller, message){
        if (!$('#project-activities-'+caller+'-validation').validationEngine('validate')){
            return;
        }

        message = typeof message !== 'undefined' ? message : 'Successfully updated';
        var pActivity = self.current();
        var url = pActivity.projectActivityId() ? fcConfig.projectActivityUpdateUrl + "/" +
                    pActivity.projectActivityId() : fcConfig.projectActivityCreateUrl;

        var divId = 'project-activities-'+ caller +'-result-placeholder';
        if(caller != "info" && pActivity.projectActivityId() === undefined){
            showAlert("You need to save 'Survey Info' details before updating other constraints.", "alert-error",  divId);
            return;
        }

        $.ajax({
            url: url,
            type: 'POST',
            data: model,
            contentType: 'application/json',
            success: function (data) {

                if (data.error) {
                    showAlert("Error :" + data.text, "alert-error", divId);
                }
                else if(data.resp && data.resp.projectActivityId) {
                    $.each(self.projectActivities(), function(i, obj){
                        if(obj.current()){
                            obj.projectActivityId(data.resp.projectActivityId);
                        }
                    });
                    showAlert(message, "alert-success",  divId);
                }
                else{
                    if(pActivity.status() == "deleted"){
                        self.projectActivities.remove(pActivity);
                        if(self.projectActivities().length > 0){
                            self.projectActivities()[0].current(true);
                        }
                        showAlert(message, "alert-success",  divId);
                    }else{
                        showAlert(message, "alert-success",  divId);
                    }
                }
            },
            error: function (data) {
                var status = data.status;
                showAlert("Error : An unhandled error occurred" + data.status, "alert-error", divId);
            }
        });
    };
}

function initialiseValidator(){
    $('#project-activities-info-validation').validationEngine();
    $('#project-activities-form-validation').validationEngine();
    $('#project-activities-access-validation').validationEngine();
}
