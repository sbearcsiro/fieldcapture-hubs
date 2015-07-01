<style type="text/css">
.projecttag {
    background: orange;
    color: white;
    padding: 4px;
}
</style>
<div id="carousel" class="row-fluid slider-pro" data-bind="visible:mainImageUrl()">
    <div class="sp-slides">

        <div class="sp-slide">
            <img class="sp-image" data-bind="attr:{'data-src':mainImageUrl}"/>

            <p class="sp-layer sp-white sp-padding"
               data-position="topLeft" data-width="100%" data-bind="visible:urlWeb"
               data-show-transition="down" data-show-delay="0" data-hide-transition="up">
                <strong>Get involved!</strong> Visit us at <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a>
            </p>

        </div>
    </div>
</div>

<div id="weburl" data-bind="visible:!mainImageUrl()">
    <div data-bind="visible:urlWeb()"><strong>Get involved!</strong> Visit us at <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a></div>
</div>

<div class="container-fluid">
    <hr/>
    <div class="row-fluid">
        <span class="span6">
            <div class="well">
                <div class="well-title">About the project</div>
                <div data-bind="visible:aim">
                    <b style="text-decoration: underline;">Aim</b><br/>
                    <span data-bind="text:aim"></span>
                    <p/>
                </div>
                <div data-bind="visible:aim">
                    <b style="text-decoration: underline;">Description</b><br/>
                    <span data-bind="html:description.markdownToHtml()"></span>
                </div>
            </div>
        </span>
        <span class="span6">
            <div class="well">
                <div class="well-title">Get Involved!</div>
                <div data-bind="visible:getInvolved(), text:getInvolved"></div>
                <hr/>
                <div class="row-fluid nav nav-pills" data-bind="visible:transients.daysRemaining() > 0">
                    <li class="active pull-right">
                        <a data-bind="visible:isExternal() && urlWeb(),attr:{href:urlWeb}">Get Started</a>
                        <a data-bind="visible:!isExternal(),attr:{href:'${createLink(action:'survey',id:project.projectId)}'}">Get Started</a>
                    </li>
                </div>
                <g:render template="/shared/listDocumentLinks"
                          model="${[transients:transients,imageUrl:resource(dir:'/images/filetypes')]}"/>
            </div>
            <span class="projecttag" data-bind="visible:!hasParticipantCost()"><g:message code="project.tag.noCost"/></span>
            <span class="projecttag" data-bind="visible:hasTeachingMaterials()"><g:message code="project.tag.teach"/></span>
            <span class="projecttag" data-bind="visible:isDIY()"><g:message code="project.tag.diy"/></span>
            <span class="projecttag" data-bind="visible:isSuitableForChildren()"><g:message code="project.tag.children"/></span>
            <span class="projecttag" data-bind="visible:difficulty() == 'Easy'"><g:message code="project.tag.difficultyEasy"/></span>
            <span class="projecttag" data-bind="visible:difficulty() == 'Medium'"><g:message code="project.tag.difficultyMedium"/></span>
            <span class="projecttag" data-bind="visible:difficulty() == 'Hard'"><g:message code="project.tag.difficultyHard"/></span>
            <span class="projecttag" data-bind="visible:scienceType(),text:scienceType()"></span>
        </span>
    </div>
</div>
