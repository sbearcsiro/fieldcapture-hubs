<div class="control-group">
    <label class="control-label span3">Mobile Apps:</label>

    <div class="controls span9">
        <span data-bind="foreach:mobileApps">
            <img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/>
            <g:textField style="width:70%;" type="url" name="urlWeb" data-bind="name=value:url" data-validation-engine="validate[custom[url]]"/>
            <br/>
        </span>

    </div>
</div>
<div class="clearfix" data-bind="visible:socialMedia">
    Social Media: <span data-bind="foreach:socialMedia">
    <a data-bind="attr:{href:url}"><img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/></a>
</span>
</div>
