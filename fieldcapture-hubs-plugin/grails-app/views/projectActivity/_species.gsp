<div id="pActivitySurvey">
        <h5>You can constrain the species available for selection in this survey to:</h5>
        </br>

        <!-- ko foreach: projectActivities -->

            <!-- ko if: current -->
            <div class="well">
                <div class="row-fluid">
                    <div class="span4 text-left">
                        <div class="controls">
                            <select style="width:98%;" data-validation-engine="validate[required]" data-bind="options: $root.speciesOptions, optionsText:'name', optionsValue:'id', value: species.type, optionsCaption: 'Please select'" ></select>
                        </div>
                    </div>

                </div>


                <div data-bind="visible: species.singleInfoVisible" class="row-fluid">
                    <div class="span4 text-left">
                        <div class="controls">
                            <span data-bind="if: species.singleSpecies.guid">
                                <a data-bind="attr:{href: species.transients.bioProfileUrl}" target="_blank"><small data-bind="text: species.singleSpecies.name"></small></a>
                           </span>
                           </br>
                            <input style="width:80%;" type="text" placeholder="Search species"
                                data-bind="value:species.singleSpecies.transients.textFieldValue,
                                            event:{focusout: species.singleSpecies.focusLost},
                                            autocomplete:{
                                                url:'http://devt.ala.org.au:8088/fieldcapture-hub/search/species',
                                                render: species.singleSpecies.renderItem,
                                                listId: species.singleSpecies.list,
                                                result: species.singleSpecies.speciesSelected,
                                                valueChangeCallback: species.singleSpecies.textFieldChanged
                                            }" data-validation-engine="validate[required]">

                        </div>

                    </div>
                </div>

                <span data-bind="visible: species.groupInfoVisible, if: species.speciesLists().length > 0">
                    <div class="row-fluid">
                        <div class="span12 text-left">

                            <!-- ko foreach: species.speciesLists -->
                            <span data-bind="text: $index()+1"></span>
                            <a class="btn btn-link" target="_blank" data-bind="attr:{href: transients.url}">
                                <small data-bind="text: listName"></small>
                            </a>
                            <button data-bind="click: $parent.species.removeSpeciesLists" class="btn btn-link"><small>X</small></button>
                            </br>
                            <!-- /ko -->
                        </div>
                    </br>
                    </div>
                </span>


            </div>

            <!-- Group species -->
            <span data-bind="visible: species.groupInfoVisible">

                <span data-bind="if: species.groupInfoVisible">
                    <div class="well">
                        <div class="span12 text-left">
                             <div class="controls">
                                <!-- <a data-bind="click: species.allSpeciesLists.loadAllSpeciesLists" target="blank" href="${grailsApplication.config.lists.baseURL}"><b>Choose from existing species lists</b></a> -->
                                <a data-bind="click: species.transients.toggleShowExistingSpeciesLists" href="#"><b>Choose from existing species lists</b></a>
                                (OR)
                                <!-- <a target="blank" href="${grailsApplication.config.lists.baseURL}"><b>Add new species lists</b></a> -->
                                <a target="blank" data-bind="click: species.transients.toggleShowAddSpeciesLists" href="#"><b>Add new species lists</b></a>
                            </div>
                        </div>

                        </br>

                        <g:render template="/projectActivity/addSpecies" />

                        </br>

                        <g:render template="/projectActivity/chooseSpecies" />

                    </div>

                </span>

            </span>

        <!-- /ko -->

        <!-- /ko -->

    </br>
    <div class="row-fluid pull-right">

        <div class="span12">
            <button class="btn-primary btn block" data-bind="click: saveSpecies"> Save </button>
        </div>

    </div>

</div>


