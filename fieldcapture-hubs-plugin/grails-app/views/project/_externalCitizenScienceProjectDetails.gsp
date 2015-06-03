<style type="text/css">
    .block-header {
        position: relative;
        top:-19px;
        left:-5px;
        padding-bottom: 7px;
        border-bottom: 1px solid lightgrey;
    }
</style>

<div class="well">
    <h4 class="block-header">Project metadata</h4>
    <div class="row-fluid">

        <div class="clearfix control-group">
            <label class="control-label span3" for="name"><g:message code="project.type"/><fc:iconHelp><g:message code="project.type.help"/></fc:iconHelp></label>

            <div class="controls span9">
                <select data-bind="value:transients.projectKind, options:transients.availableProjectTypes, optionsText:'name', optionsValue:'value'"  <g:if test="${params.citizenScience}">disabled</g:if> data-validation-engine="validate[required]"></select>
            </div>
        </div>
    </div>
    <div class="row-fluid">

        <div class="clearfix control-group">
            <label class="control-label span3" for="name"><g:message code="project.useALA"/><fc:iconHelp><g:message code="project.useALA.help"/></fc:iconHelp></label>

            <div class="controls span9">
                <select data-bind="booleanValue:isExternal, options:[{label:'Yes', value:'true'}, {label:'No', value:'false'}], optionsText:'label', optionsValue:'value', optionsCaption:'Select...'" data-validation-engine="validate[required]">

                </select>
            </div>
        </div>
    </div>
    <!-- ko stopBinding: true -->
    <div id="organisationSearch">
        <div class="row-fluid">

            <div class="clearfix control-group">

                <label class="control-label span3" for="organisationName"><g:message code="project.organisationNameSearch"/><fc:iconHelp><g:message code="project.organisationName.help"/></fc:iconHelp></label>
                <div class="span6 controls">
                    <div class="input-append" style="width:100%;">
                        <input id="organisationName" style="width:90%" type="text" placeholder="Start typing a name here" data-bind="value:term, valueUpdate:'afterkeydown', disable:selection"><button class="btn" type="button" data-bind="click:clearSelection"><i class='icon-search' data-bind="css:{'icon-search':!term(), 'icon-remove':term()}"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <div class="row-fluid" data-bind="slideVisible:!selection()">
            <div class="span9">
                <div class="control-label span12" style="display:none;" data-bind="visible:!selection() && allViewed()">
                    <label for="organisationNotPresent">My organisation is not on the list &nbsp;<input type="checkbox" id="organisationNotPresent" data-bind="checked:organisationNotPresent"></label>
                </div>
                <div style="display:none;" data-bind="visible:!selection() && allViewed() && organisationNotPresent()">
                    <button class="btn btn-success" style="float:right" data-bind="click:function() {createOrganisation();}">Register my organisation</button>
                </div>
            </div>

            <div class="span9">

                <div style="padding-left:5px;"><b>Organisation Search Results</b> (Click an organisation to select it)</div>
                <div style="background:white; border: 1px solid lightgrey; border-radius: 4px; height:8em; overflow-y:scroll" data-bind="event:{scroll:scrolled}">
                    <ul id="organisation-list" class="nav nav-list">
                        <li class="nav-header" style="display:none;" data-bind="visible:userOrganisationResults().length">Your organisations</li>
                        <!-- ko foreach:userOrganisationResults -->
                            <li data-bind="css:{active:$root.isSelected($data)}"><a data-bind="click:$root.select, text:name"></a></li>
                        <!-- /ko -->
                        <li class="nav-header" style="display:none;" data-bind="visible:userOrganisationResults().length && otherResults().length">Other organisations</li>
                        <!-- ko foreach:otherResults -->
                            <li data-bind="css:{active:$root.isSelected($data)}"><a data-bind="click:$root.select, text:name"></a></li>
                        <!-- /ko -->
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!-- /ko -->

</div>

<div class="row-fluid">
    <div class="span12">
        <div class="well">
            <h4 class="block-header"><g:message code="project.details.tell"/></h4>

            <div class="clearfix control-group">
                <label class="control-label span3" for="name"><g:message code="g.project.name"/>:</label>

                <div class="controls span9">
                    <g:textField style="width:90%;" name="name" data-bind="value:name"
                                 data-validation-engine="validate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="description"><g:message code="g.project.description"/>:</label>

                <div class="controls span9">
                    <g:textArea style="width:90%;" name="description" data-bind="value:description"
                                data-validation-engine="validate[required]" rows="3"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="manager"><g:message code="project.details.manager"/>:</label>

                <div class="controls span9">
                    <g:textField style="width:90%;" type="email" data-bind="value:manager" name="manager"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="plannedStartDate"><g:message code="g.project.plannedStartDate"/>:
                <fc:iconHelp><g:message code="g.project.plannedStartDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker class="input-small" targetField="plannedStartDate.date" name="plannedStartDate"
                                   id="plannedStartDate" data-validation-engine="validate[required]"/>
                </div>
            </div>

            <div class="clearfix control-group">
                <label class="control-label span3" for="plannedEndDate"><g:message code="g.project.plannedEndDate"/>:
                <fc:iconHelp><g:message code="g.project.plannedEndDate.help"/></fc:iconHelp>
                </label>

                <div class="controls span9">
                    <fc:datePicker class="input-small" targetField="plannedEndDate.date" name="plannedEndDate"
                                   id="plannedEndDate" data-validation-engine="validate[future[plannedStartDate]]"/>
                </div>
            </div>
        </div>

    </div>
</div>

<div class="row-fluid">
    <div class="well">
        <h4 class="block-header"><g:message code="project.details.involved"/></h4>

        <div class="clearfix control-group">
            <label class="control-label span3" for="getInvolved"><g:message code="project.details.involved"/></label>

            <div class="controls span9">
                <g:textArea style="width:90%;" name="getInvolved" data-bind="value:getInvolved"
                            rows="2"/>
            </div>
        </div>

        <div class="clearfix control-group">
            <label class="control-label span3"
                   for="scienceType"><g:message code="project.details.scienceType"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" name="scienceType" data-bind="value:scienceType"/>
            </div>
        </div>
    </div>
</div>

<div class="row-fluid">
    <div class="well">
        <h4 class="block-header"><g:message code="project.details.find"/>:</h4>

        <div class="control-group">
            <label class="control-label span3" for="urlWeb"><g:message code="g.website"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" tye="url" name="urlWeb" data-bind="value:urlWeb" data-validation-engine="validate[custom[url]]"/>
            </div>
        </div>

        <div class="clearfix control-group">
            <label class="control-label span3" for="urlAndroid"><g:message code="g.android"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" tye="url" name="urlAndroid" data-bind="value:urlAndroid" data-validation-engine="validate[custom[url]]"/>
            </div>
        </div>

        <div class="clearfix control-group">
            <label class="control-label span3" for="urlITunes"><g:message code="g.iTunes"/>:</label>

            <div class="controls span9">
                <g:textField style="width:90%;" tye="url" name="urlITunes" data-bind="value:urlITunes" data-validation-engine="validate[custom[url]]"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label span3" for="keywords"><g:message code="g.keywords"/>:</label>

            <div class="controls span9">
                <g:textArea style="width:90%;" name="keywords" data-bind="value:keywords" rows="2"/>
            </div>
        </div>

    </div>
</div>

<div class="row-fluid">
    <div class="well">
        <h4 class="block-header"><g:message code="project.details.image"/></h4>

        <div class="control-group">
            <label class="control-label span3" for="logo">Project Logo:</label>
            <img class="span6" data-bind="visible:logoUrl(),attr:{src:logoUrl}">
            <span class="span3">
                <span class="btn fileinput-button pull-right"
                      data-url="${createLink(controller: 'image', action: 'upload')}"
                      data-role="logo"
                      data-owner-type="projectId"
                      data-owner-id="${project?.projectId}"
                      data-bind="stagedImageUpload:documents, visible:!logoUrl()"><i class="icon-plus"></i> <input
                        id="logo" type="file" name="files"><span>Attach</span></span>

                <button class="btn main-image-button" data-bind="click:removeLogoImage, visible:logoUrl()"><i class="icon-minus"></i> Remove</button>
            </span>
        </div>

        <div class="control-group">
            <label class="control-label span3" for="mainImage">Feature Graphic:</label>
            <img class="span6" data-bind="visible:mainImageUrl(),attr:{src:mainImageUrl}">
            <span class="span3">
                <span class="btn fileinput-button pull-right"
                      data-url="${createLink(controller: 'image', action: 'upload')}"
                      data-role="mainImage"
                      data-owner-type="projectId"
                      data-owner-id="${project?.projectId}"
                      data-bind="stagedImageUpload:documents, visible:!mainImageUrl()"><i class="icon-plus"></i> <input
                        id="mainImage" type="file" name="files"><span>Attach</span></span>

                <button class="btn main-image-button" data-bind="click:removeMainImage,  visible:mainImageUrl()"><i class="icon-minus"></i> Remove</button>
            </span>
        </div>

        <div class="control-group">
            <label class="control-label span3" for="bannerImage">Banner:</label>
            <img class="span6" data-bind="visible:bannerUrl(),attr:{src:bannerUrl}">
            <span class="span3">
                <span class="btn fileinput-button pull-right"
                      data-url="${createLink(controller: 'image', action: 'upload')}"
                      data-role="banner"
                      data-owner-type="projectId"
                      data-owner-id="${project?.projectId}"
                      data-bind="stagedImageUpload:documents, visible:!bannerUrl()"><i class="icon-plus"></i> <input
                        id="bannerImage" type="file" name="files"><span>Attach</span></span>

                <button class="btn main-image-button" data-bind="click:removeBannerImage,  visible:bannerUrl()"><i class="icon-minus"></i> Remove</button>
            </span>
        </div>

    </div>
</div>

<div class="row-fluid">
    <div class="well">
    <h4 class="block-header"><g:message code="project.details.site"/></h4>
    <g:set var="mapHeight" value="400px"/>
    <g:render template="/site/simpleSite" model="${pageScope.variables}"/>
</div>
</div>
