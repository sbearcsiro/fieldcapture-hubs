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
                <div class="well-title">About us</div>
                <span data-bind="html:description.markdownToHtml()"></span>
            </div>
        </span>
        <span class="span6">
            <div class="well">
                <div class="well-title">Get Involved!</div>
                <div data-bind="visible:getInvolved(), text:getInvolved"></div>
                <hr/>
                <div style="padding-bottom:5px;">Visit the project website to get started!</div>
                <div class="row-fluid" data-bind="visible:urlWeb">
                    <div class="span6">
                        <label>Project web site:</label>
                    </div>
                    <div class="span6">
                        <span data-bind="text:urlWeb"></span>
                    </div>
                </div>
                <div class="row-fluid" data-bind="visible:mobileAppLinks">
                    <div class="span6">
                        <label>Mobile apps:</label>
                    </div>
                    <div class="span6">
                        <span data-bind="html:mobileAppLinks"></span>
                    </div>
                </div>
                <div class="row-fluid" data-bind="visible:socialMediaLinks">
                    <div class="span6">
                        <label>Social media:</label>
                    </div>
                    <div class="span6">
                        <span data-bind="html:socialMediaLinks"></span>
                    </div>
                </div>

            </div>
        </span>
    </div>
</div>