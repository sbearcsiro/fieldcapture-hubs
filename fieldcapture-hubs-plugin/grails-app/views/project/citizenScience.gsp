<%@ page import="grails.converters.JSON; au.org.ala.fieldcapture.SettingPageType" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta name="layout" content="${hubConfig.skin}"/>
    <title><g:message code="g.citizenScience"/> | <g:message code="g.fieldCapture"/></title>
    <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
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
        background: grey;
        padding: 6px;
        text-align: center;
    }
    #pt-downloadLink {
        margin-bottom: 10px;
    }
    </style>
</head>
<body>
<div id="wrapper" class="container-fluid">
    <div class="row-fluid">
        <div class="span6" id="heading">
            <h1 class="pull-left"><g:message code="project.citizenScience.heading"/></h1>
        </div>
        <g:if test="${user}">
            <button id="newPortal" type="button" class="pull-right btn"><g:message
                    code="project.citizenScience.portalLink"/></button>
        </g:if>
    </div>

    <div class="row-fluid"><g:message code="project.citizenScience.preamble"/></div>
    <div id="pt-root" class="row-fluid">
        <div class="well">
            <g:if test="${fc.userIsAlaOrFcAdmin()}">
                <div class="row-fluid">
                    <a href="${createLink(action:'citizenScience',params:[download:true])}" id="pt-downloadLink" class="btn btn-warning span2 pull-right"
                   title="Download metadata for projects in JSON format">
                    <i class="icon-download"></i><g:message code="g.download" /></a>
                </div>
            </g:if>
            <div class="row-fluid">
                <span class="span2" id="pt-resultsReturned"></span>
                <div class="span8 input-append">
                    <input class="span12" type="text" name="pt-search" id="pt-search"/>
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
                        <g:select name="pt-sort" from="['Name','Aim and Description','Organisation Name','Status']"  keys="['name','aim','organisationName','status']"/>
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
                    <label for="pt-search-active"><g:message code="project.search.active" /></label>
                    <input id="pt-search-active" type="checkbox" />
                </div>
                <div class="span4">
                    <label for="pt-search-diy"><g:message code="project.search.diy" /></label>
                    <input id="pt-search-diy" type="checkbox" />
                </div>
                <div class="span4">
                    <label for="pt-search-noCost"><g:message code="project.search.noCost" /></label>
                    <input id="pt-search-noCost" type="checkbox" />
                </div>
            </div>
            <div class="row-fluid">
                <div class="span4">
                    <label for="pt-search-teach"><g:message code="project.search.teach" /></label>
                    <input id="pt-search-teach" type="checkbox" />
                </div>
                <div class="span4">
                    <label for="pt-search-children"><g:message code="project.search.children" /></label>
                    <input id="pt-search-children" type="checkbox" />
                </div>
            </div>
        </div>

        <table class="table table-bordered table-hover" id="projectTable">
            <tbody data-bind="foreach:pageProjects">
            <tr>
                <td style="width:200px">
                    <div class="projectLogo">
                        <img style="max-width:100%;max-height:100%" data-bind="attr:{alt:'No image provided',title:name,src:urlImage}"/>
                    </div>
                </td>
                <td>
                    <a data-bind="attr:{href:indexUrl}">
                        <span data-bind="text:name" style="font-size:150%;font-weight:bold"></span>
                    </a>
                    <div data-bind="visible:orgUrl">
                        <span style="font-size:80%;color:grey">Added <!--ko text:since--><!--/ko--> to&nbsp;</span>
                        <a data-bind="attr:{href:orgUrl}">
                            <span data-bind="text:organisationName"></span></a>
                    </div>
                    <div data-bind="text:aim"></div>
                    <div>
                        <i class="icon-info-sign"></i><span data-bind="html:links"/>
                    </div>
                    <br/>
                    <div data-bind="visible:transients.daysRemaining() > 0">
                        <b>Project status</b>
                        <g:render template="daysline"/>
                        To find out more and back this project, <a data-bind="attr:{href:indexUrl}">
                        <span style="font-weight:bold">view the project page</span></a>
                    </div>
                    <div data-bind="visible:transients.daysRemaining() == 0">
                        <b>Project status</b>
                        <g:render template="daysline"/>
                        Project successfully concluded. <a data-bind="attr:{href:indexUrl}">
                        <span style="font-weight:bold">View the project page</span></a>
                    </div>
                    <div data-bind="visible:transients.daysRemaining() < 0">
                        <b>Project status: </b>Project ongoing. <a data-bind="attr:{href:indexUrl}">
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
        var vm = new CreateCitizenScienceFinderProjectViewModel(props);
        var x, urls = [];
        if (vm.urlWeb()) urls.push('<a href="' + vm.urlWeb() + '">Website</a>');
        for (x = "", docs = vm.transients.mobileApps(), i = 0; i < docs.length; i++)
          x += '&nbsp;<a href="' + docs[i].link.url + '"><img class="logo-small" src="' + docs[i].logo(fcConfig.logoLocation) + '"/></a>';
        if (x) urls.push("Mobile Apps&nbsp;" + x);
        for (x = "", docs = vm.transients.socialMedia(), i = 0; i < docs.length; i++)
          x += '&nbsp;<a href="' + docs[i].link.url + '"><img class="logo-small" src="' + docs[i].logo(fcConfig.logoLocation) + '"/></a>';
        if (x) urls.push("Social Media&nbsp;" + x);
        vm.links = urls.join('&nbsp;&nbsp;|&nbsp;&nbsp;') || '';
        vm.searchText = (vm.name() + ' ' + vm.aim() + ' ' + vm.organisationName()).toLowerCase();
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

    /* the base url of the home server */
    var baseUrl = fcConfig.baseUrl;

    /** load projects and show first page **/
    allProjects.sort(comparator); // full list is sorted by name
    projects = allProjects;
    updateTotal();
    populateTable();

    /*************************************************\
     *  Filter projects by search term
     \*************************************************/
    var showActiveOnly, showSuitableForChildrenOnly, showDifficultyOnly, showDIYOnly, showNoCostOnly, showTeachOnly;
    function doSearch(force) {
        var val = $('#pt-search').val().toLowerCase();
        if (!force && val == searchTerm) return;
        searchTerm = val;
        projects = [];
        for (var i = 0; i < allProjects.length; i++) {
            var item = allProjects[i];
            if (!item) continue;
            if (showActiveOnly && item.status() != 'active') continue;
            if (showSuitableForChildrenOnly && !item.isSuitableForChildren()) continue;
            if (showDifficultyOnly && item.difficulty() != showDifficultyOnly) continue;
            if (showDIYOnly && !item.isDIY()) continue;
            if (showTeachOnly && !item.hasTeachingMaterials()) continue;
            if (showNoCostOnly && item.hasParticipantCost()) continue;
            if (item.searchText.indexOf(searchTerm) >= 0)
                projects.push(item);
        }
        offset = 0;
        updateTotal();
        populateTable();
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
        var $pago = $("<div class='pagination'></div>");
        // add prev
        if (offset > 0)
            $pago.append('<a href="javascript:pago.prevPage();">&lt;</a></li>');
        for (var i = currentPage - 3, n = 0; i <= maxPage && n < 7; i++) {
            if (i < 1) continue;
            n++;
            if (i == currentPage)
                $pago.append('<a href="#" class="currentStep">' + i + '</a>');
            else
                $pago.append('<a href="javascript:pago.gotoPage(' + i + ');">' + i + '</a>');
        }
        // add next
        if ((offset + perPage) < total)
            $pago.append('<a href="javascript:pago.nextPage();">&gt;</a>');

        $('div#pt-navLinks').html($pago);
    }

    window.pago = {
        gotoPage: function(pageNum) {
            offset = (pageNum - 1) * perPage;
            populateTable();
        },
        prevPage: function() {
            offset -= perPage;
            populateTable();
        },
        nextPage: function() {
            offset += perPage;
            populateTable();
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
        projects = allProjects;
        $('#pt-per-page').val(perPage = 20);
        $('#pt-sort').val(sortBy = 'name');
        $('#pt-dir').val(sortOrder = 1);
        offset = 0;
        updateTotal();
        populateTable();
    });
    $('#pt-search-active').on('change', function() {
        showActiveOnly = $(this).prop('checked');
        doSearch(true);
    });
    $('#pt-search-children').on('change', function() {
        showSuitableForChildrenOnly = $(this).prop('checked');
        doSearch(true);
    });
    $('#pt-search-difficulty').change(function () {
        showDifficultyOnly = $(this).val();
        if (showDifficultyOnly === "Any") showDifficultyOnly = null;
        doSearch(true);
    });
    $('#pt-search-diy').on('change', function() {
        showDIYOnly = $(this).prop('checked');
        doSearch(true);
    });
    $('#pt-search-noCost').on('change', function() {
        showNoCostOnly = $(this).prop('checked');
        doSearch(true);
    });
    $('#pt-search-teach').on('change', function() {
        showTeachOnly = $(this).prop('checked');
        doSearch(true);
    });

    $("#newPortal").on("click", function() {
        document.location.href = "${createLink(controller:'project',action:'create',params:[citizenScience:true])}";
    });
});
</r:script>
</body>
</html>
