<div class="control-group">
    <label class="control-label span3">Mobile Apps:</label>
    <table class="controls span9">
        <tbody data-bind="foreach:mobileApps">
        <tr>
            <td><img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/></td>
            <td><input type="url" data-bind="value:url, attr:{id:'lnk-'+role}"
                       data-validation-engine="validate[required,custom[url]]"/></td>
            <td><a href="#" class="rmv-link" data-bind="attr:{'data-lnkrole':role}"><i class="icon-remove"></i></a></td>
        </tr>
        </tbody>
        <tfoot data-bind="visible:mobileAppsUnspecified().length > 0">
        <tr><td colspan="3">
            <select id="addMobileApp"
                    data-bind="options:mobileAppsUnspecified,optionsText:'name',optionsValue:'role',optionsCaption:'Add mobile app...'"></select>
        </td></tr>
        </tfoot>
    </table>
</div>

<div class="control-group">
    <label class="control-label span3">Social Media:</label>
    <table class="controls span9">
        <tbody data-bind="foreach:socialMedia">
        <tr>
            <td><img class="logo-small" data-bind="attr:{src:logo('${imageUrl}')}"/></td>
            <td><input type="url" data-bind="value:url, attr:{id:'lnk-'+role}"
                       data-validation-engine="validate[required,custom[url]]"/></td>
            <td><a href="#" class="rmv-link" data-bind="attr:{'data-lnkrole':role}"><i class="icon-remove"></i></a></td>
        </tr>
        </tbody>
        <tfoot data-bind="visible:socialMediaUnspecified().length > 0">
        <tr><td colspan="3">
            <select id="addSocialMedia"
                    data-bind="options:socialMediaUnspecified,optionsText:'name',optionsValue:'role',optionsCaption:'Add social media link...'"></select>
        </td></tr>
        </tfoot>
    </table>
</div>
<r:script>
    function initEditDocumentLinks(viewModel) {
        function onRemoveLink(e) {
            viewModel.removeLink($(this).attr('data-lnkrole'));
            $('.rmv-link').click(onRemoveLink);
            e.preventDefault();
        }
        function onAddLink() {
            var role = $(this).val();
            if (!role) return;
            viewModel.addLink(role, "");
            $('.rmv-link').click(onRemoveLink);
        }

        $('#addMobileApp').change(onAddLink);
        $('#addSocialMedia').change(onAddLink);
        $('.rmv-link').click(onRemoveLink);
    }
</r:script>