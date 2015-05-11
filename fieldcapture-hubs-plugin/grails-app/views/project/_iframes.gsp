</br>
<h3>Embedded Videos</h3>
<div class="well" >
    <div class="row-fluid">
        <div class="span12 text-left">

            <table style="width:100%;">
                <thead>
                <tr>
                    <th></th>
                    <th>Embedded Videos</th>
                    <th></th>
                </tr>
                </thead>
                <tbody data-bind="foreach : iframes" >

                <tr>
                    <td width="5%"><span data-bind="text: $index()+1"></span>
                    </td>
                    <td width="85%">
                        <textarea style="width:98%;" data-validation-engine="validate[required]"  data-bind="value: code"  rows="5"></textarea>
                    </td>
                    <td width="10%"><i class="icon-remove" data-bind="click: $parent.removeiFrames"></i></td>
                </tr>
                </tbody>
                <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button type="button" class="btn btn-small" data-bind="click: addiFrames">
                            <i class="icon-plus"></i> Add a row</button>
                    </td>
                </tr>
            </table>
            <div id="save-iframe-details-result-placeholder"></div>
            <button type="button"  data-bind="click: saveiFrames.bind($data, '${createLink(action: 'ajaxUpdate', id: project.projectId)}')" class="btn btn-primary">Save</button>
        </div>

    </div>
</div>
