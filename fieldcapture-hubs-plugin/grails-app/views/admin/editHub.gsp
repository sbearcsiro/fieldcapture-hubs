<!doctype html>
<html>
<head>
    <meta name="layout" content="adminLayout"/>
    <title>Metadata | Admin | Data capture | Atlas of Living Australia</title>
    <r:require modules="jquery,knockout,jqueryValidationEngine"/>
</head>

<body>

<content tag="pageTitle">Create / Edit Hub</content>

<div class="alert" data-bind="visible:transients.message()">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <span data-bind="text:transients.message"></span>
</div>

<div>
    Enter hub id: <input type="text" name="selectHub" data-bind="value:transients.selectedHub">
</div>

<form class="form-horizontal validationEngineContainer" data-bind="visible:transients.selectedHub()">
    <div class="control-group">
        <label class="control-label" for="name">Hub id (used in the URL, so keep short)</label>
        <div class="controls required">
            <input type="text" id="name" class="input-xxlarge" data-bind="value:id" data-validation-engine="validate[required]" readonly="readonly" placeholder="Hub id">
        </div>
    </div>
    <div class="control-group">
        <label class="control-label" for="description">Title</label>
        <div class="controls required">
            <textarea rows="3" class="input-xxlarge" data-bind="value:title" data-validation-engine="validate[required]" id="description" placeholder="Displays as a heading on the home page"></textarea>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label" for="supported-programs">Supported Programs (Projects in this hub can only select from these programs)</label>
        <div class="controls">
            <ul id="supported-programs" data-bind="foreach:transients.programNames" class="unstyled">
                <li><label><input type="checkbox" data-bind="checked:$root.supportedPrograms, attr:{value:$data}"> <span data-bind="text:$data"></span></label></li>
            </ul>

        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="available-facets">Available Facets (Only these facets will display on the home page)</label>
        <div class="controls">
            <ul id="available-facets" data-bind="foreach:transients.availableFacets" class="unstyled">
                <li><label><input type="checkbox" data-bind="checked:$root.availableFacets, attr:{value:$data}"> <span data-bind="text:$data"></span> <span data-bind="text:$root.facetOrder($data)"></span></label></li>
            </ul>

        </div>

    </div>

    <div class="control-group">
        <label class="control-label" for="default-facets">Default Facet Query (Searches will automatically include these facets)</label>
        <div class="controls">
            <input type="text" class="input-xxlarge" id="default-facets" data-bind="value:defaultFacetQuery" placeholder="query string as produced by the home page">
        </div>
    </div>

    <div class="form-actions">
        <button type="button" id="save" data-bind="click:save" class="btn btn-primary">Save</button>
        <button type="button" id="cancel" class="btn">Cancel</button>
    </div>
</form>

<r:script>

    $(function() {
        var saveSettingsUrl = '${createLink(controller:'admin', action: 'saveHubSettings')}';
        var getSettingsUrl = '${createLink(controller:'admin', action: 'loadHubSettings')}';

        var HubSettingsViewModel = function(programsModel) {
           var self = this;

           self.id = ko.observable();
           self.title = ko.observable();
           self.supportedPrograms = ko.observableArray();
           self.availableFacets = ko.observableArray();
           self.defaultFacetQuery = ko.observable();
           var programNames = $.map(programsModel.programs, function(program, i) {
               return program.name;
           });
           self.transients = {
                availableFacets:['status','organisationFacet','associatedProgramFacet','associatedSubProgramFacet','mainThemeFacet','stateFacet','nrmFacet','lgaFacet','mvgFacet','ibraFacet','imcra4_pbFacet','otherFacet'],
                programNames:programNames,
                message:ko.observable(),
                selectedHub:ko.observable()
           };

            self.facetOrder = function(facet) {

                var facetList = self.availableFacets ? self.availableFacets : [];
                var index = facetList.indexOf(facet);

                return index >= 0 ? '('+(index + 1)+')' : '';
            }

           self.loadSettings = function(settings) {
               self.id(settings.id);
               self.title(settings.title);
               self.supportedPrograms(self.orEmptyArray(settings.supportedPrograms));
               self.availableFacets(self.orEmptyArray(settings.availableFacets));
               self.defaultFacetQuery(self.orBlank(settings.defaultFacetQuery));
           };

           self.transients.selectedHub.subscribe(function(newValue) {
               $.get(getSettingsUrl, {id:newValue, format:'json'}, function(data) {
                    if (!data.id) {
                        self.transients.message('Creating a new hub with id: '+newValue);
                        data.id = newValue;
                    }
                    else {
                        self.transients.message('');
                    }
                    self.loadSettings(data);

               }, 'json').fail(function() {
                 self.transients.message('Error loading hub details');
               });
           });

           self.orEmptyArray = function(value) {
               if (value === undefined || value === null) {
                   return [];
               }
               return value;
           }
           self.orBlank = function(value) {
               if (value === undefined || value === null) {
                   return '';
               }
               return value;
           }


           self.save = function() {
               var json = JSON.stringify(ko.mapping.toJS(self, {ignore:'transients'}));
               $.ajax(saveSettingsUrl, {type:'POST', data:json, contentType:'application/json'}).done( function(data) {
                if (data.errors) {
                    self.transients.message(data.errors);
                }
                else {
                    self.transients.message('Hub saved!');
                }

            }).fail( function() {

                self.transients.message('An error occurred saving the settings.');
            });
           };

        };
        var programsModel = <fc:modelAsJavascript model="${programsModel}"/>;
        var viewModel = new HubSettingsViewModel(programsModel);

        ko.applyBindings(viewModel);
        $('.validationEngineContainer').validationEngine();
    });

</r:script>

</body>
</html>