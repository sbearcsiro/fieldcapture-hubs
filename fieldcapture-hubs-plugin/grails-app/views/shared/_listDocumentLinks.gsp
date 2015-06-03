<div class="clearfix" data-bind="visible:mobileApps">
    Mobile Apps: <span data-bind="foreach:mobileApps">
    <a data-bind="attr:{href:url}"><img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/></a>
</span>
</div>
<div class="clearfix" data-bind="visible:socialMedia">
    Social Media: <span data-bind="foreach:socialMedia">
    <a data-bind="attr:{href:url}"><img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/></a>
</span>
</div>
