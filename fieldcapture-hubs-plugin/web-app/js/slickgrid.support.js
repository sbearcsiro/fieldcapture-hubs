/**
 * Support for bulk editing activities using slick grid.
 */
function OutputValueEditor(args) {
    var $input;
    var defaultValue;
    var scope = this;

    this.init = function () {
        $input = $("<INPUT type=text class='editor-text' data-prompt-target='blah'/>")
            .addClass(args.column.validationRules)// Using class because of way jqueryValidationEngine determines the pattern used.
            .appendTo(args.container)
            //.bind("keydown.nav", function (e) {
            //    if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
            //        e.stopImmediatePropagation();
            //    }
            //})
            .focus()
            .select();

        validationSupport.addValidationSupport($input, args.item, args.column.field);
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

        $input.closest('.validationEngineContainer').validationEngine('validate'); // A single field validation returns the opposite of what it should?

        /** always return true as otherwise focus traversal will be blocked by the grid */
        return {
            valid: true,
            msg: null
        };
    };

    this.init();
}

function OutputSelectEditor(args) {
    var $select;
    var defaultValue;
    var scope = this;

    this.init = function () {

        $select = $("<SELECT tabIndex='0' class='editor-yesno'></SELECT>");
        for (var i=0; i<args.column.options.length; i++) {
            $select.append($("<OPTION name=\""+args.column.options[i]+"\" value=\""+args.column.options[i]+"\">"+args.column.options[i]+"</OPTION>"));
        }
        $select.appendTo(args.container);
        $select.focus();

        validationSupport.addValidationSupport($input, args.item, args.column.field);
    };

    this.destroy = function () {
        $select.remove();
    };

    this.focus = function () {
        $select.focus();
        $select.size == args.column.options.length;
    };

    this.loadValue = function (item) {

        defaultValue = args.grid.getOptions().dataItemColumnValueExtractor(item, args.column);

        $select.val(defaultValue);
        $select.select();
    };

    this.serializeValue = function () {
        return ($select.val());
    };

    this.applyValue = function (item, state) {
        outputValueEditor(item, args.column, state);
    };

    this.isValueChanged = function () {
        return ($select.val() != defaultValue);
    };

    this.validate = function () {

        $select.closest('.validationEngineContainer').validationEngine('validate'); // A single field validation returns the opposite of what it should?

        return {
            valid: true,
            msg: null
        };
    };

    this.init();
}

/*
 * An example of a "detached" editor.
 * The UI is added onto document BODY and .position(), .show() and .hide() are implemented.
 * KeyDown events are also handled to provide handling for Tab, Shift-Tab, Esc and Ctrl-Enter.
 */
function LongTextEditor(args) {
    var $input, $wrapper;
    var defaultValue;
    var scope = this;

    this.init = function () {
        var $container = $("body");

        $wrapper = $("<DIV style='z-index:10000;position:absolute;background:white;padding:5px;border:3px solid gray; -moz-border-radius:10px; border-radius:10px;'/>")
            .appendTo($container);

        $input = $("<TEXTAREA hidefocus rows=5 style='backround:white;width:250px;height:80px;border:0;outline:0'>")
            .appendTo($wrapper);

        $("<DIV style='text-align:right'><BUTTON>Save</BUTTON><BUTTON>Cancel</BUTTON></DIV>")
            .appendTo($wrapper);

        $wrapper.find("button:first").bind("click", this.save);
        $wrapper.find("button:last").bind("click", this.cancel);
        $input.bind("keydown", this.handleKeyDown);

        scope.position(args.position);
        $input.focus().select();

        validationSupport.addValidationSupport($input, args.item, args.column.field);
    };

    this.handleKeyDown = function (e) {
        if (e.which == $.ui.keyCode.ENTER && e.ctrlKey) {
            scope.save();
        } else if (e.which == $.ui.keyCode.ESCAPE) {
            e.preventDefault();
            scope.cancel();
        } else if (e.which == $.ui.keyCode.TAB && e.shiftKey) {
            e.preventDefault();
            args.grid.navigatePrev();
        } else if (e.which == $.ui.keyCode.TAB) {
            e.preventDefault();
            args.grid.navigateNext();
        }
    };

    this.save = function () {
        args.commitChanges();
    };

    this.cancel = function () {
        $input.val(defaultValue);
        args.cancelChanges();
    };

    this.hide = function () {
        $wrapper.hide();
    };

    this.show = function () {
        $wrapper.show();
    };

    this.position = function (position) {
        $wrapper
            .css("top", position.top - 5)
            .css("left", position.left - 5)
    };

    this.destroy = function () {
        $wrapper.remove();
    };

    this.focus = function () {
        $input.focus();
    };

    this.loadValue = function (item) {
        defaultValue = args.grid.getOptions().dataItemColumnValueExtractor(item, args.column);
        $input.val(defaultValue);
        $input.select();
    };

    this.serializeValue = function () {
        return $input.val();
    };

    this.applyValue = function (item, state) {
        outputValueEditor(item, args.column, state);
    };

    this.isValueChanged = function () {
        return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
    };

    this.validate = function () {
        $input.closest('.validationEngineContainer').validationEngine('validate'); // A single field validation returns the opposite of what it should?

        return {
            valid: true,
            msg: null
        };
    };

    this.init();
}


function findOutput(activity, name) {
    if (!name) {
        return;
    }
    var output = ko.utils.arrayFirst(activity.outputModels, function(output) {
        return output.name === name;
    });
    return output;

}

// The item is an activity containing an array of outputs.
var outputValueExtractor = function(item, column) {
    if (column.outputName) {
        var output = findOutput(item, column.outputName);
        return output ? ko.utils.unwrapObservable(output.data[column.field]) : '';
    }
    return item[column.field];
};

var outputValueEditor = function(item, column, value) {
    if (column.outputName) {
        var output = findOutput(item, column.outputName);
        if (!output) {
            output = {name:column.outputName, data:{}, activityId: item.activityId};
            item.outputs.push(output);
        }
        output.data[column.field](value);
    }

};

function validate(grid, activity, outputModels) {

    var activityValid = true;
    $.each(outputModels, function(i, outputModel) {
        var output = findOutput(activity, outputModel.name);

        var results = validateOutput(output, outputModel.dataModel);

        $.each(results, function(j, result) {
           if (!result.valid) {
               var columnIdx = columnIndex(result.field, outputModel.dataModel);
               var node = grid.getCellNode(activity.row, columnIdx);
               console.log("Invalid: "+result.field+", message="+result.error);
               if (node) {
                   validationSupport._buildPrompt($(node), result.field, result.error);
                   activityValid = false;
               }
           }
        });
    });
    return activityValid;

};

function columnIndex(name, outputModel) {
    var index = -1;
    $.each(outputModel.dataModel, function(i, item) {
        if (item.name == name) {
            index = i;
            return false;
        }
    });
    return index;
}

function validateOutput(output, outputModel) {

    var results = [];
    $.each(outputModel.dataModel, function(i, dataItem) {
        var value = output.data[dataItem.name];
        var validations = dataItem.validate;
        if (validations) {
            validations = validations.split(',');

            $.each(validations, function(j, validation) {
                var args = undefined;
                var validatorName = validation;
                var argsIndex = validation.indexOf('[');
                if (argsIndex > 0) {
                    validatorName = validation.substring(0, argsIndex);
                    args = validation.substring(argsIndex+1, validation.length-1);

                }

                var validator = validators[validatorName];
                if (validator) {
                    results.push(validator(dataItem.name, value(), args));
                }


            });
        }

    });
    return results;
};

validators = {
    required: function(field, value) {
        if (!value) {
            var error = $.validationEngineLanguage.allRules.required.alertText;
            return {field:field, valid:false, error:error};
        }
        return {field:field, valid:true};
    },
    min: function(field, value, args) {
        var min = Number(args);
        var value = Number(value);
        if (!value || value < min) {
            var error = $.validationEngineLanguage.allRules.min.alertText + min;
            return {field:field, valid:false, error:error};
        }
        return {field:field, valid:true};
    }
}



//---- taken from jqueryValidationEngine with minor modifications ------
var validationSupport = {

    defaults:{

        // Name of the event triggering field validation
        validationEventTrigger: "blur",
        // Automatically scroll viewport to the first error
        scroll: true,
        // Focus on the first input
        focusFirstField:true,
        // Show prompts, set to false to disable prompts
        showPrompts: true,
        // Should we attempt to validate non-visible input fields contained in the form? (Useful in cases of tabbed containers, e.g. jQuery-UI tabs)
        validateNonVisibleFields: false,
        // Opening box position, possible locations are: topLeft,
        // topRight, bottomLeft, centerRight, bottomRight, inline
        // inline gets inserted after the validated field or into an element specified in data-prompt-target
        promptPosition: "topRight",
        bindMethod:"bind",
        // internal, automatically set to true when it parse a _ajax rule
        inlineAjax: false,
        // if set to true, the form data is sent asynchronously via ajax to the form.action url (get)
        ajaxFormValidation: false,
        // The url to send the submit ajax validation (default to action)
        ajaxFormValidationURL: false,
        // HTTP method used for ajax validation
        ajaxFormValidationMethod: 'get',
        // Ajax form validation callback method: boolean onComplete(form, status, errors, options)
        // retuns false if the form.submit event needs to be canceled.
        onAjaxFormComplete: $.noop,
        // called right before the ajax call, may return false to cancel
        onBeforeAjaxFormValidation: $.noop,
        // Stops form from submitting and execute function assiciated with it
        onValidationComplete: false,

        // Used when you have a form fields too close and the errors messages are on top of other disturbing viewing messages
        doNotShowAllErrosOnSubmit: false,
        // Object where you store custom messages to override the default error messages
        custom_error_messages:{},
        // true if you want to vind the input fields
        binded: true,
        // set to true, when the prompt arrow needs to be displayed
        showArrow: true,
        // did one of the validation fail ? kept global to stop further ajax validations
        isError: false,
        // Limit how many displayed errors a field can have
        maxErrorsPerField: false,

        // Caches field validation status, typically only bad status are created.
        // the array is used during ajax form validation to detect issues early and prevent an expensive submit
        ajaxValidCache: {},
        // Auto update prompt position after window resize
        autoPositionUpdate: false,

        InvalidFields: [],
        onFieldSuccess: false,
        onFieldFailure: false,
        onSuccess: false,
        onFailure: false,
        validateAttribute: "class",
        addSuccessCssClassToField: "",
        addFailureCssClassToField: "",

        // Auto-hide prompt
        autoHidePrompt: false,
        // Delay before auto-hide
        autoHideDelay: 10000,
        // Fade out duration while hiding the validations
        fadeDuration: 0.3,
        // Use Prettify select library
        prettySelect: false,
        // Add css class on prompt
        addPromptClass : "",
        // Custom ID uses prefix
        usePrefix: "",
        // Custom ID uses suffix
        useSuffix: "",
        // Only show one message per error prompt
        showOneMessage: false
    },

    promptId: function(name) {
        return name+'Error';
    },

    findPrompt: function(name) {
        return $('#'+this.promptId(name));
    },

    removePrompt: function(name) {
        this.findPrompt(name).remove();
    },

    addValidationSupport: function($elem, activity, fieldName) {
        $elem.on('jqv.field.result', function(event, field, error, messageString) {

            if (!activity.invalidColumns) {
                activity.invalidColumns = {};
            }
            validationSupport.removePrompt(fieldName);
            if (error) {
                activity.invalidColumns[fieldName] = messageString;

                validationSupport._buildPrompt(field, fieldName, messageString);
            }
            else {
                activity.invalidColumns[fieldName] = null;

            }

        });
    },

    /**
     * Builds and shades a prompt for the given field.
     *
     * @param {jqObject} field
     * @param {String} name the name of the data attribute being validated.
     * @param {String} promptText html text to display type
     * @param {String} type the type of bubble: 'pass' (green), 'load' (black) anything else (red)
     * @param {boolean} ajaxed - use to mark fields than being validated with ajax
     * @param {Map} options user options
     */
    _buildPrompt: function (field, name, promptText, type, ajaxed, options) {

        if (!options) {
            options = this.defaults;
        }
        // create the prompt
        var prompt = $('<div>');
        //prompt.addClass(methods._getClassName(field.attr("id")) + "formError");
        // add a class name to identify the parent form of the prompt
        //prompt.addClass("parentForm" + methods._getClassName(field.closest('form, .validationEngineContainer').attr("id")));
        prompt.addClass("formError");
        prompt.attr('id', this.promptId(name));

        switch (type) {
            case "pass":
                prompt.addClass("greenPopup");
                break;
            case "load":
                prompt.addClass("blackPopup");
                break;
            default:
            /* it has error  */
            //alert("unknown popup type:"+type);
        }
        if (ajaxed)
            prompt.addClass("ajaxed");

        // create the prompt content
        var promptContent = $('<div>').addClass("formErrorContent").html(promptText).appendTo(prompt);

        // determine position type
        var positionType = field.data("promptPosition") || options.promptPosition;

        // create the css arrow pointing at the field
        // note that there is no triangle on max-checkbox and radio
        if (options.showArrow) {
            var arrow = $('<div>').addClass("formErrorArrow");

            //prompt positioning adjustment support. Usage: positionType:Xshift,Yshift (for ex.: bottomLeft:+20 or bottomLeft:-20,+10)
            if (typeof(positionType) == 'string') {
                var pos = positionType.indexOf(":");
                if (pos != -1)
                    positionType = positionType.substring(0, pos);
            }

            switch (positionType) {
                case "bottomLeft":
                case "bottomRight":
                    prompt.find(".formErrorContent").before(arrow);
                    arrow.addClass("formErrorArrowBottom").html('<div class="line1"><!-- --></div><div class="line2"><!-- --></div><div class="line3"><!-- --></div><div class="line4"><!-- --></div><div class="line5"><!-- --></div><div class="line6"><!-- --></div><div class="line7"><!-- --></div><div class="line8"><!-- --></div><div class="line9"><!-- --></div><div class="line10"><!-- --></div>');
                    break;
                case "topLeft":
                case "topRight":
                    arrow.html('<div class="line10"><!-- --></div><div class="line9"><!-- --></div><div class="line8"><!-- --></div><div class="line7"><!-- --></div><div class="line6"><!-- --></div><div class="line5"><!-- --></div><div class="line4"><!-- --></div><div class="line3"><!-- --></div><div class="line2"><!-- --></div><div class="line1"><!-- --></div>');
                    prompt.append(arrow);
                    break;
            }
        }
        // Add custom prompt class
        if (options.addPromptClass)
            prompt.addClass(options.addPromptClass);

        // Add custom prompt class defined in element
        var requiredOverride = field.attr('data-required-class');
        if (requiredOverride !== undefined) {
            prompt.addClass(requiredOverride);
        } else {
            if (options.prettySelect) {
                if ($('#' + field.attr('id')).next().is('select')) {
                    var prettyOverrideClass = $('#' + field.attr('id').substr(options.usePrefix.length).substring(options.useSuffix.length)).attr('data-required-class');
                    if (prettyOverrideClass !== undefined) {
                        prompt.addClass(prettyOverrideClass);
                    }
                }
            }
        }

        prompt.css({
            "opacity": 0
        });

        $('body').append(prompt); // Slickgrid uses overflow:none a lot.

        var pos = validationSupport._calculatePosition(field, prompt, options);

        prompt.css({
            'position': positionType === 'inline' ? 'relative' : 'absolute',
            "top": pos.callerTopPosition,
            "left": pos.callerleftPosition,
            "marginTop": pos.marginTopSize,
            "opacity": 0
        }).data("callerField", field);


        if (options.autoHidePrompt) {
            setTimeout(function () {
                prompt.animate({
                    "opacity": 0
                }, function () {
                    prompt.closest('.formErrorOuter').remove();
                    prompt.remove();
                });
            }, options.autoHideDelay);
        }
        return prompt.animate({
            "opacity": 0.87
        });
    },
    /**
     * Calculates prompt position
     *
     * @param {jqObject}
     *            field
     * @param {jqObject}
     *            the prompt
     * @param {Map}
     *            options
     * @return positions
     */
    _calculatePosition: function (field, promptElmt, options) {

        var promptTopPosition, promptleftPosition, marginTopSize;
        var fieldWidth = field.width();
        var fieldLeft = field.offset().left;
        var fieldTop = field.offset().top;
        var fieldHeight = field.height();
        var promptHeight = promptElmt.height();


        // is the form contained in an overflown container?
        promptTopPosition = promptleftPosition = 0;
        // compensation for the arrow
        marginTopSize = -promptHeight;


        //prompt positioning adjustment support
        //now you can adjust prompt position
        //usage: positionType:Xshift,Yshift
        //for example:
        //   bottomLeft:+20 means bottomLeft position shifted by 20 pixels right horizontally
        //   topRight:20, -15 means topRight position shifted by 20 pixels to right and 15 pixels to top
        //You can use +pixels, - pixels. If no sign is provided than + is default.
        var positionType = field.data("promptPosition") || options.promptPosition;
        var shift1 = "";
        var shift2 = "";
        var shiftX = 0;
        var shiftY = 0;
        if (typeof(positionType) == 'string') {
            //do we have any position adjustments ?
            if (positionType.indexOf(":") != -1) {
                shift1 = positionType.substring(positionType.indexOf(":") + 1);
                positionType = positionType.substring(0, positionType.indexOf(":"));

                //if any advanced positioning will be needed (percents or something else) - parser should be added here
                //for now we use simple parseInt()

                //do we have second parameter?
                if (shift1.indexOf(",") != -1) {
                    shift2 = shift1.substring(shift1.indexOf(",") + 1);
                    shift1 = shift1.substring(0, shift1.indexOf(","));
                    shiftY = parseInt(shift2);
                    if (isNaN(shiftY)) shiftY = 0;
                }
                ;

                shiftX = parseInt(shift1);
                if (isNaN(shift1)) shift1 = 0;

            }
            ;
        }
        ;


        switch (positionType) {
            default:
            case "topRight":
                promptleftPosition += fieldLeft + fieldWidth - 30;
                promptTopPosition += fieldTop;
                break;

            case "topLeft":
                promptTopPosition += fieldTop;
                promptleftPosition += fieldLeft;
                break;

            case "centerRight":
                promptTopPosition = fieldTop + 4;
                marginTopSize = 0;
                promptleftPosition = fieldLeft + field.outerWidth(true) + 5;
                break;
            case "centerLeft":
                promptleftPosition = fieldLeft - (promptElmt.width() + 2);
                promptTopPosition = fieldTop + 4;
                marginTopSize = 0;

                break;

            case "bottomLeft":
                promptTopPosition = fieldTop + field.height() + 5;
                marginTopSize = 0;
                promptleftPosition = fieldLeft;
                break;
            case "bottomRight":
                promptleftPosition = fieldLeft + fieldWidth - 30;
                promptTopPosition = fieldTop + field.height() + 5;
                marginTopSize = 0;
                break;
            case "inline":
                promptleftPosition = 0;
                promptTopPosition = 0;
                marginTopSize = 0;
        }
        ;


        //apply adjusments if any
        promptleftPosition += shiftX;
        promptTopPosition += shiftY;

        return {
            "callerTopPosition": promptTopPosition + "px",
            "callerleftPosition": promptleftPosition + "px",
            "marginTopSize": marginTopSize + "px"
        };
    }
};
