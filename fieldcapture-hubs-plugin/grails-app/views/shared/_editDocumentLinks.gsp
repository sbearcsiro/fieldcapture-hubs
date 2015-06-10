<div class="control-group">
    <label class="control-label span3">Mobile Apps:</label>
    <table class="controls span9">
        <tbody data-bind="foreach:transients.mobileApps">
        <tr>
            <td><img class="logo-small" data-bind="attr:{alt:name,title:name,src:logo('${imageUrl}')}"/></td>
            <td><input type="url" data-bind="value:link.url"
                       data-validation-engine="validate[required,custom[url]]"/></td>
            <td><a href="#" data-bind="click:remove"><i class="icon-remove"></i></a></td>
        </tr>
        </tbody>
        <tfoot data-bind="visible:transients.mobileAppsUnspecified().length > 0">
        <tr><td colspan="3">
            <select id="addMobileApp"
                    data-bind="options:transients.mobileAppsUnspecified,optionsText:'name',optionsValue:'role',value:transients.mobileAppToAdd,optionsCaption:'Add mobile app...'"></select>
        </td></tr>
        </tfoot>
    </table>
</div>

<div class="control-group">
    <label class="control-label span3">Social Media:</label>
    <table class="controls span9">
        <tbody data-bind="foreach:transients.socialMedia">
        <tr>
            <td><img class="logo-small" data-bind="attr:{alt:name,title:name,src:logo('${imageUrl}')}"/></td>
            <td><input type="url" data-bind="value:link.url"
                       data-validation-engine="validate[required,custom[url]]"/></td>
            <td><a href="#" data-bind="click:remove"><i class="icon-remove"></i></a></td>
        </tr>
        </tbody>
        <tfoot data-bind="visible:transients.socialMediaUnspecified().length > 0">
        <tr><td colspan="3">
            <select id="addSocialMedia"
                    data-bind="options:transients.socialMediaUnspecified,optionsText:'name',optionsValue:'role',value:transients.socialMediaToAdd,optionsCaption:'Add social media link...'"></select>
        </td></tr>
        </tfoot>
    </table>
</div>
