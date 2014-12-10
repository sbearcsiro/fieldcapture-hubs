/**
 * Support for bulk editing activities using slick grid.
 */
function OutputValueEditor(args) {
    var $input;
    var defaultValue;
    var errorDialog;
    var errorDialogOriginalOffset;
    var scope = this;

    this.init = function () {
        $input = $("<INPUT type=text class='editor-text' data-prompt-target='blah'/>")
            .addClass(args.column.validationRules)// Using class because of way jqueryValidationEngine determines the pattern used.
            .appendTo(args.container)
            .bind("keydown.nav", function (e) {
                if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
                    e.stopImmediatePropagation();
                }
            })
            .focus()
            .select();
    };

    this.destroy = function () {
        $input.remove();
    };

    this.focus = function () {
        $input.focus();
    };

    this.getValue = function () {
        return $input.val();
    };

    this.setValue = function (val) {
        $input.val(val);
    };

    this.loadValue = function (item) {
        defaultValue = args.grid.getOptions().dataItemColumnValueExtractor(item, args.column);
        $input.val(defaultValue);
        $input[0].defaultValue = defaultValue;
        $input.select();
    };

    this.serializeValue = function () {
        return $input.val();
    };

    this.applyValue = function (item, state) {
        outputValueEditor(item, args.column, state);
    };

    this.isValueChanged = function () {
        /*return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);*/
        return true;
    };

    this.validate = function () {

        var result = $input.closest('.validationEngineContainer').validationEngine('validate'); // A single field validation returns the opposite of what it should?

        if (!result) {
            console.log("validation failed!");
            if (!errorDialog) {
                console.log("finding error dialog");
                var originalErrorDialog = $input.prev('.formError');
                errorDialogOriginalOffset = originalErrorDialog.offset();

                errorDialog = originalErrorDialog.clone();

                console.log(errorDialog);
                $('body').append(errorDialog);
                errorDialog.offset(errorDialogOriginalOffset);
                errorDialog.animate({opacity:0.87});
            }



            return {
                valid:false,
                msg:'invalid!'
            }
        }

        if (errorDialog) {
            errorDialog.remove();
        }


        return {
            valid: true,
            msg: null
        };
    };

    this.init();
}

// The item is an activity containing an array of outputs.
var outputValueExtractor = function(item, column) {
    if (column.outputName) {
        var output = ko.utils.arrayFirst(item.outputs, function(output) {
            return output.name === column.outputName;
        });
        return output ? output.data[column.field] : '';
    }
    return item[column.field];
};

var outputValueEditor = function(item, column, value) {
    if (column.outputName) {
        var output = ko.utils.arrayFirst(item.outputs, function(output) {
            return output.name === column.outputName;
        });
        if (output) {
            output.data[column.field] = value;
        }
    }
    item[column.field] = value;
};

var progressFormatter = function( row, cell, value, columnDef, dataContext ) {
    return '<span class="btn-info">'+value+"</span>";
};
