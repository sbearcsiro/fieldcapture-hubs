<div class="container-fluid project-header project-banner" data-bind="style:{'backgroundImage':bannerUrl}">
    <div class="row-fluid">
        <ul class="breadcrumb">
            <li>
                <g:link controller="home">Home</g:link> <span class="divider">/</span>
            </li>
            <li class="active">Projects <span class="divider">/</span></li>
            <li class="active" data-bind="text:name"/>
        </ul>

        <span data-bind="visible:logoUrl"><img data-bind="attr:{'src':logoUrl}"></span><h2 data-bind="text:name"></h2>
        <h4 data-bind="text:organisationName"></h4>
    </div>
</div>