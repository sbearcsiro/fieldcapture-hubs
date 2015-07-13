<%@ page import="grails.converters.JSON; au.org.ala.fieldcapture.SettingPageType" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title><g:message code="g.citizenScience"/> | <g:message code="g.fieldCapture"/></title>
    <r:script disposition="head">
    var fcConfig = {
        baseUrl: "${grailsApplication.config.grails.serverURL}",
        spatialBaseUrl: "${grailsApplication.config.spatial.baseUrl}",
        spatialWmsCacheUrl: "${grailsApplication.config.spatial.wms.cache.url}",
        spatialWmsUrl: "${grailsApplication.config.spatial.wms.url}",
        sldPolgonDefaultUrl: "${grailsApplication.config.sld.polgon.default.url}",
        sldPolgonHighlightUrl: "${grailsApplication.config.sld.polgon.highlight.url}",
        organisationLinkBaseUrl: "${createLink(controller: 'organisation', action: 'index')}",
        imageLocation:"${resource(dir:'/images')}",
        logoLocation:"${resource(dir:'/images/filetypes')}",
        dashboardUrl: "${g.createLink(controller: 'report', action: 'dashboardReport', params: params)}"
    }
    </r:script>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <r:require modules="js_iso8601,projects"/>
    <style type="text/css">
    .projectLogo {
        width: 200px;
        height: 150px;
        line-height: 146px;
        overflow: hidden;
        padding: 1px;
        text-align: center;
    }
    input[type=checkbox] {
        margin-right: 5px;
    }
    #pt-downloadLink {
        margin-bottom: 10px;
    }
    </style>
</head>
<body>
<div id="wrapper" class="content container-fluid">
    <div class="row-fluid">
        <div class="span6" id="heading">
            <h1 class="pull-left"><g:message code="project.citizenScience.heading"/></h1>
        </div>
        <g:if test="${user}">
            <button id="newPortal" type="button" class="pull-right btn"><g:message
                    code="project.citizenScience.portalLink"/></button>
        </g:if>
    </div>

    <div id="pt-root" class="row-fluid">
        <div class="well">
            <g:if test="${fc.userIsAlaOrFcAdmin()}">
                <div class="row-fluid">
                    <a href="${createLink(action:'citizenScience',params:[download:true])}" id="pt-downloadLink" class="btn btn-warning span2 pull-right"
                   title="Download metadata for projects in JSON format">
                    <i class="icon-download"></i>&nbsp;<g:message code="g.download" /></a>
                </div>
            </g:if>
            <div class="row-fluid">
                <span class="span2" id="pt-resultsReturned"></span>
                <div class="span8 input-append">
                    <input class="span12" type="text" name="pt-search" id="pt-search" placeholder="Enter a search term"/>
                </div>
                <div class="span2">
                    <a href="javascript:void(0);" title="Only show projects which contain the search term" id="pt-search-link" class="btn"><g:message code="g.search" /></a>
                    <a href="javascript:void(0);" title="Remove all filters and sorting options" id="pt-reset" class="btn"><g:message code="g.reset" /></a>
                </div>
            </div>
            <div id="pt-searchControls" class="row-fluid">
                <div id="pt-sortWidgets">
                    <div class="span3">
                        <label for="pt-per-page"><g:message code="g.projects"/>&nbsp;<g:message code="g.perPage"/></label>
                        <g:select name="pt-per-page" from="[20,50,100,500]"/>
                    </div>
                    <div class="span3">
                        <label for="pt-sort"><g:message code="g.sortBy" /></label>
                        <g:select name="pt-sort" from="['Name','Aim','Organisation Name','Status']"  keys="['name','aim','organisationName','daysStatus']"/>
                    </div>
                    <div class="span3">
                        <label for="pt-dir"><g:message code="g.sortOrder" /></label>
                        <g:select name="pt-dir" from="['Ascending','Descending']" keys="[1,-1]"/>
                    </div>
                    <div class="span3">
                        <label for="pt-search-difficulty"><g:message code="project.search.difficulty" /></label>
                        <g:select name="pt-search-difficulty" from="['Any','Easy','Medium','Hard']"/>
                    </div>
                </div>
            </div><!--drop downs-->
            <div class="row-fluid">
                <div class="span4">
                    <label class="checkbox"><input id="pt-search-active" type="checkbox" checked /><g:message code="project.search.active" /></label>
                </div>
                <div class="span4">
                    <label class="checkbox"><input id="pt-search-diy" type="checkbox" /><g:message code="project.tag.diy" /></label>
                </div>
                <div class="span4">
                    <label class="checkbox"><input id="pt-search-noCost" type="checkbox" /><g:message code="project.tag.noCost" /></label>
                </div>
            </div>
            <div class="row-fluid">
                <div class="span4">
                    <label class="checkbox"><input id="pt-search-teach" type="checkbox" /><g:message code="project.tag.teach" /></label>
                </div>
                <div class="span4">
                    <label class="checkbox"><input id="pt-search-children" type="checkbox" /><g:message code="project.tag.children" /></label>
                </div>
                <div class="span4">
                    <label class="checkbox"><input id="pt-search-mobile" type="checkbox" /><g:message code="project.search.mobile" /></label>
                </div>
            </div>
        </div>

        <table class="table table-hover" id="projectTable">
            <tbody data-bind="foreach:pageProjects">
            <tr style="border-bottom: 2px solid grey">
                <td style="width:200px">
                    <div class="projectLogo well">
                        <img style="max-width:100%;max-height:100%" alt="No image provided" data-bind="attr:{title:name,src:urlImage}"/>
                    </div>
                </td>
                <td>
                    <a data-bind="attr:{href:indexUrl}">
                        <span data-bind="text:name" style="font-size:150%;font-weight:bold"></span>
                    </a>
                    <div data-bind="visible:orgUrl">
                        <span data-bind="visible:transients.daysSince() < 0" style="font-size:80%;color:grey">Starts <!--ko text:since--><!--/ko--> for&nbsp;</span>
                        <span data-bind="visible:transients.daysSince() >= 0" style="font-size:80%;color:grey">Added <!--ko text:since--><!--/ko--> to&nbsp;</span>
                        <a data-bind="text:organisationName,attr:{href:orgUrl}"></a>
                    </div>
                    <div data-bind="text:aim"></div>
                    <div style="padding: 4px">
                        <i class="icon-info-sign"></i>&nbsp;<span data-bind="html:links"/>
                    </div>
                    <div>
                        TAGS:&nbsp;<g:render template="tags"/>
                    </div>
                    <br/>
                    <div data-bind="visible:transients.daysRemaining() > 0">
                        <b>Project status</b>
                        <g:render template="daysline"/>
                    </div>
                    <div data-bind="visible:transients.daysRemaining() == 0">
                        <b>Project status</b>
                        <g:render template="daysline"/>
                        Project concluded. <a data-bind="attr:{href:indexUrl}">
                        <span style="font-weight:bold">View the project page</span></a>
                    </div>
                </td>
                <td style="width:10em">
                    <g:render template="dayscount"/>
                </td>
            </tr>
            </tbody>
        </table>

        <div id="pt-searchNavBar" class="clearfix">
            <div id="pt-navLinks"></div>
        </div>
    </div>
</div>
<r:script>
$(document).ready(function () {
    var markdown = new Showdown.converter();
    function createVM(props) {
        var vm = new CitizenScienceFinderProjectViewModel(props);
        var x, urls = [];
        if (vm.urlWeb()) urls.push('<a href="' + vm.urlWeb() + '">Website</a>');
        for (x = "", docs = vm.transients.mobileApps(), i = 0; i < docs.length; i++)
          x += '&nbsp;<a href="' + docs[i].link.url + '"><img class="logo-small" src="' + docs[i].logo(fcConfig.logoLocation) + '"/></a>';
        if (x) urls.push("Mobile Apps&nbsp;" + x);
        for (x = "", docs = vm.transients.socialMedia(), i = 0; i < docs.length; i++)
          x += '&nbsp;<a href="' + docs[i].link.url + '"><img class="logo-small" src="' + docs[i].logo(fcConfig.logoLocation) + '"/></a>';
        if (x) urls.push("Social Media&nbsp;" + x);
        vm.links = urls.join('&nbsp;&nbsp;|&nbsp;&nbsp;') || '';
        vm.searchText = (vm.name() + ' ' + vm.aim() + ' ' + vm.description() + ' ' + vm.keywords() + ' ' + vm.transients.scienceTypeDisplay() + ' ' + vm.locality + ' ' + vm.state + ' ' + vm.organisationName()).toLowerCase();
        vm.indexUrl = "${createLink()}/" + vm.projectId;
        vm.orgUrl = vm.organisationId() && ("${createLink(controller:'organisation',action:'index')}/" + vm.organisationId());
        return vm;
    }

    var allProjects = [
    <g:each var="p" in="${projects}">createVM(${p as JSON}),</g:each>
    ];

    /* holds current filtered list */
    var projects;

    /* pagination offset into the record set */
    var offset = 0;

    /* size of current filtered list */
    var total = 0;

    var searchTerm = '', perPage = 20, sortBy = 'name', sortOrder = 1;

    /* window into current page */
    function pageVM() {
        this.pageProjects = ko.observableArray();
    }
    var pageWindow = new pageVM();
    ko.applyBindings(pageWindow);

    /*************************************************\
     *  Filter projects by search term
     \*************************************************/
    function doSearch(force) {
      var showActiveOnly = $('#pt-search-active').prop('checked'),
          showSuitableForChildrenOnly = $('#pt-search-children').prop('checked'),
          showDifficultyOnly = $('#pt-search-difficulty').val(),
          showDIYOnly = $('#pt-search-diy').prop('checked'),
          showNoCostOnly = $('#pt-search-noCost').prop('checked'),
          showTeachOnly = $('#pt-search-teach').prop('checked'),
          showWithMobileAppsOnly = $('#pt-search-mobile').prop('checked'),
          val = $('#pt-search').val().toLowerCase();
        if (showDifficultyOnly === "Any") showDifficultyOnly = null;
        if (!force && val == searchTerm) return;
        searchTerm = val;
        projects = [];
        for (var i = 0; i < allProjects.length; i++) {
            var item = allProjects[i];
            if (!item) continue;
            if (showActiveOnly && item.daysStatus() != 'active') continue;
            if (showSuitableForChildrenOnly && !item.isSuitableForChildren()) continue;
            if (showDifficultyOnly && item.difficulty() != showDifficultyOnly) continue;
            if (showDIYOnly && !item.isDIY()) continue;
            if (showTeachOnly && !item.hasTeachingMaterials()) continue;
            if (showNoCostOnly && item.hasParticipantCost()) continue;
            if (showWithMobileAppsOnly && !item.transients.mobileApps().length) continue;
            if (item.searchText.indexOf(searchTerm) >= 0)
                projects.push(item);
        }
        offset = 0;
        updateTotal();
        populateTable();
    }
    function doSearchForce() {
        doSearch(true);
    }

    /*************************************************\
     *  Show filtered projects on current page
     \*************************************************/
    function populateTable() {
        pageWindow.pageProjects(projects.slice(offset, offset + perPage));
        pageWindow.pageProjects.valueHasMutated();
        showPaginator();
    }

    /** display the current size of the filtered list **/
    function updateTotal() {
        total = projects.length;
        $('#pt-resultsReturned').html("Found <strong>" + total + "</strong> " + (total == 1 ? 'project.' : 'projects.'));
    }

    /*************************************************\
     *  Pagination
     \*************************************************/
    /** build and append the pagination widget **/
    function showPaginator() {
        if (total <= perPage) {
            // no pagination required
            $('div#pt-navLinks').html("");
            return;
        }
        var currentPage = Math.floor(offset / perPage) + 1;
        var maxPage = Math.ceil(total / perPage);
        var $ul = $("<ul></ul>");
        // add prev
        if (offset > 0)
            $ul.append('<li><a href="javascript:pago.prevPage();">&lt;</a></li>');
        for (var i = currentPage - 3, n = 0; i <= maxPage && n < 7; i++) {
            if (i < 1) continue;
            n++;
            if (i == currentPage)
                $ul.append('<li><a href="#" class="currentStep">' + i + '</a></li>');
            else
                $ul.append('<li><a href="javascript:pago.gotoPage(' + i + ');">' + i + '</a></li>');
        }
        // add next
        if ((offset + perPage) < total)
            $ul.append('<li><a href="javascript:pago.nextPage();">&gt;</a></li>');

        var $pago = $("<div class='pagination'></div>");
        $pago.append($ul);
        $('div#pt-navLinks').html($pago);
    }

    window.pago = {
        gotoPage: function(pageNum) {
            offset = (pageNum - 1) * perPage;
            populateTable();
            $('html,body').scrollTop(0);
        },
        prevPage: function() {
            offset -= perPage;
            populateTable();
            $('html,body').scrollTop(0);
        },
        nextPage: function() {
            offset += perPage;
            populateTable();
            $('html,body').scrollTop(0);
        }
    }

    /* comparator for data projects */
    function comparator(a, b) {
        var va = a[sortBy](), vb = b[sortBy]();
        va = va? va.toLowerCase(): '';
        vb = vb? vb.toLowerCase(): '';
        if (va == vb && sortBy != 'name') { // sort on name
            va = a.name().toLowerCase();
            vb = b.name().toLowerCase();
        }
        return (va < vb ? -1 : (va > vb ? 1 : 0)) * sortOrder;
    }

    $('#pt-per-page').change(function () {
        perPage = $(this).val();
        offset = 0;
        populateTable();
    });
    $('#pt-sort').change(function () {
        sortBy = $(this).val();
        projects.sort(comparator);
        populateTable();
    });
    $('#pt-dir').change(function () {
        sortOrder = $(this).val();
        projects.sort(comparator);
        populateTable();
    });
    $('#pt-search-link').click(function () {
        doSearch();
    });
    $('#pt-search').keypress(function (event) {
        if (event.which == 13) {
            event.preventDefault();
            doSearch();
        }
    });
    $('#pt-reset').click(function () {
        $('#pt-search').val('');
        doSearchForce();
    });
    $('#pt-search-active').on('change', doSearchForce);
    $('#pt-search-children').on('change', doSearchForce);
    $('#pt-search-difficulty').change(doSearchForce);
    $('#pt-search-diy').on('change', doSearchForce);
    $('#pt-search-noCost').on('change', doSearchForce);
    $('#pt-search-teach').on('change', doSearchForce);
    $('#pt-search-mobile').on('change', doSearchForce);

    $("#newPortal").on("click", function() {
        document.location.href = "${createLink(controller:'project',action:'create',params:[citizenScience:true])}";
    });

    /** load projects and show first page **/
    allProjects.sort(comparator); // full list is sorted by name
    doSearchForce();
});
</r:script>
</body>
</html>
