<style type="text/css">
#surveyLink a {
    color:white;
    background:green;
    padding:10px
}
</style>
<div id="carousel" class="row-fluid slider-pro" data-bind="visible:mainImageUrl()">
    <div class="sp-slides">

        <div class="sp-slide">
            <img class="sp-image" data-bind="attr:{'data-src':mainImageUrl}"/>

            <p class="sp-layer sp-white sp-padding"
               data-position="topLeft" data-width="100%" data-bind="visible:urlWeb"
               data-show-transition="down" data-show-delay="0" data-hide-transition="up">
                <strong>Visit us at <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a></strong>
            </p>

        </div>
    </div>
</div>

<div id="weburl" data-bind="visible:!mainImageUrl()">
    <div data-bind="visible:urlWeb()"><strong>Visit us at <a data-bind="attr:{href:urlWeb}"><span data-bind="text:urlWeb"></span></a></strong></div>
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
                <div id="surveyLink" class="row-fluid" data-bind="visible:transients.daysRemaining() != 0 && (!isExternal() || urlWeb())">
                    <a class="btn pull-right" data-bind="visible:isExternal(),attr:{href:urlWeb}">Get Started</a>
                    <a class="btn pull-right" data-bind="visible:!isExternal(),attr:{href:'${createLink(action:'survey',id:project.projectId)}'}">Get Started</a>
                    <br class="clearfix"></br>
                </div>
                <g:render template="/shared/listDocumentLinks"
                          model="${[transients:transients,imageUrl:resource(dir:'/images/filetypes')]}"/>
                <g:render template="tags"/>
            </div>
        </span>
    </div>
</div>
