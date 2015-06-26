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
               data-position="topLeft" data-width="100%"
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
                <hr/>
                <span data-bind="text:aim"></span>
                <hr/>
                <span data-bind="html:description.markdownToHtml()"></span>
            </div>
        </span>
        <span class="span6">
            <div class="well">
                <div class="well-title">Get Involved!</div>
                <div data-bind="visible:getInvolved(), text:getInvolved"></div>
                <hr/>
                <div class="row-fluid" data-bind="visible:urlWeb">
                    <a class="pull-right" data-bind="attr:{href:urlWeb}">
                        <button type="button" class="btn">Get Started</button>
                    </a>
                </div>
                <g:render template="/shared/listDocumentLinks"
                          model="${[transients:transients,imageUrl:resource(dir:'/images/filetypes')]}"/>
            </div>
            <a href="${createLink(controller: 'project', action: 'citizenScience', params: [tag:'noCost'])}" data-bind="visible:!hasParticipantCost()"><span class="projecttag"><g:message code="project.tag.noCost"/></span></a>
            <a href="${createLink(controller: 'project', action: 'citizenScience', params: [tag:'teach'])}" data-bind="visible:hasTeachingMaterials()"><span class="projecttag"><g:message code="project.tag.teach"/></span></a>
            <a href="${createLink(controller: 'project', action: 'citizenScience', params: [tag:'diy'])}" data-bind="visible:isDIY()"><span class="projecttag"><g:message code="project.tag.diy"/></span></a>
            <a href="${createLink(controller: 'project', action: 'citizenScience', params: [tag:'children'])}" data-bind="visible:isSuitableForChildren()"><span class="projecttag"><g:message code="project.tag.children"/></span></a>
            <a href="${createLink(controller: 'project', action: 'citizenScience', params: [tag:'difficultyEasy'])}" data-bind="visible:difficulty() == 'Easy'"><span class="projecttag"><g:message code="project.tag.difficultyEasy"/></span></a>
            <a href="${createLink(controller: 'project', action: 'citizenScience', params: [tag:'difficultyMedium'])}" data-bind="visible:difficulty() == 'Medium'"><span class="projecttag"><g:message code="project.tag.difficultyMedium"/></span></a>
            <a href="${createLink(controller: 'project', action: 'citizenScience', params: [tag:'difficultyHard'])}" data-bind="visible:difficulty() == 'Hard'"><span class="projecttag"><g:message code="project.tag.difficultyHard"/></span></a>
        </span>
    </div>
</div>
<div id="map"></div>