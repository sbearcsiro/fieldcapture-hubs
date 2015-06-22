<div id="pActivityAccess">
        </br>

        <!-- ko foreach: projectActivities -->
            <!-- ko if: current -->
            <div class="row-fluid">
                <div class="span4 text-right">
                    <label class="control-label"> Default record visibility: </label>
                </div>
                <div class="span4 text-left">
                    <div class="controls">
                        <select style="width:98%;" data-validation-engine="validate[required]"
                         data-bind="options: $root.visibility, optionsText:'name', optionsValue:'id', value: access.recordVisibility, optionsCaption: 'Please select'"></select>
                    </div>
                </div>

            </div>


             <div class="row-fluid">
                <div class="span4 text-right">
                    <label class="control-label"> Coordinate reference system: </label>
                </div>
                <div class="span4 text-left">
                    <div class="controls">
                        <select style="width:98%;" data-validation-engine="validate[required]"
                        data-bind="options: $root.coordinateSystems, optionsText:'name', optionsValue:'id', value: access.coordinateSystem, optionsCaption: 'Please select'" ></select>
                    </div>
                </div>

            </div>

             <div class="row-fluid">
                <div class="span4 text-right">
                    <label class="control-label"> Record visibility modifiable by users: </label>
                </div>
                <div class="span4 text-left">
                    <div class="controls">
                        <input type="checkbox" data-bind="checked: access.userCanChangeVisibility" />
                    </div>
                </div>

            </div>



            <!-- /ko -->
        <!-- /ko -->

    </br>
    <div class="row-fluid pull-right">

        <div class="span12">
            <button class="btn-primary btn block" data-bind="click: saveAccess"> Save </button>
        </div>

    </div>

</div>


