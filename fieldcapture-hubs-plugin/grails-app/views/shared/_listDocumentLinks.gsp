<div class="clearfix" data-bind="visible:transients.mobileApps">
    Mobile Apps: <span data-bind="foreach:transients.mobileApps">
    <a data-bind="attr:{href:link.url}"><img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/></a>
</span>
</div>
<div class="clearfix" data-bind="visible:transients.socialMedia">
    Social Media: <span data-bind="foreach:transients.socialMedia">
    <a data-bind="attr:{href:link.url}"><img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/></a>
</span>
</div>
