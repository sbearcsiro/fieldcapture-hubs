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
    <style type="text/css">
    #pt-root label {
        font-weight: bold;
        text-align: right;
        padding: 4px;
    }
    .projecttag {
        background: orange;
        color: white;
        padding: 4px;
    }
    </style>
    <script type="text/javascript" src="//www.google.com/jsapi"></script>
    <r:require modules="js_iso8601,projects"/>
</head>

<body>
<div id="wrapper" class="container-fluid">
    <div class="row-fluid">
        <h2><g:message code="project.citizenScience.heading"/></h2>
        <span style="font-size:150%;color:red"><g:message code="project.citizenScience.preamble"/></span>
    </div>

    <div class="row-fluid"><g:message code="project.citizenScience.preamble1"/></div>
    <div id="pt-root" class="row-fluid">
        <div class="well">
            <div class="row-fluid">
                <label class="span2" for="pt-search">Search Filter</label>
                <input class="span9" type="text" name="pt-search" id="pt-search"/>
                <a href="javascript:void(0);" title="Only show projects which contain the search term" id="pt-search-link" class="span1 pull-right btn"><g:message code="g.filter" /></a>
            </div>
            <div class="row-fluid">
                <span class="span2">&nbsp;</span>
                <span class="span10"><g:message code="project.citizenScience.search"/></span>
            </div>
            <div class="row-fluid">
                <label class="span2">Toggle</label>
                <div class="span2">
                    <button id="pt-search-all" type="button" class="btn" disabled>All</button>
                    <button id="pt-search-active" type="button" class="btn">Active</button>
                </div>
                <label class="span2" for="pt-sort">Sort</label>
                <div class="span2">
                    <g:select name="pt-sort" from="['Name','Aim','Organisation Name','Status']"  keys="['name','aim','organisationName','status']"/>
                </div>
                <label class="span2" for="pt-dir">Order</label>
                <div class="span2">
                    <g:select name="pt-dir" from="['Ascending','Descending']" keys="[1,-1]"/>
                </div>
            </div>
        </div>

        <table class="table table-bordered table-hover" id="projectTable">
            <tbody data-bind="foreach:pageProjects">
            <tr>
                <td style="width:200px">
                    <div style="width:200px;height:150px;overflow:hidden">
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
                        Project successfully launched. <a data-bind="attr:{href:indexUrl}">
                        <span style="font-weight:bold">View the project page</span></a>
                    </div>
                    <div data-bind="visible:transients.daysRemaining() < 0">
                        <b>Project status: </b>Project ongoing. <a data-bind="attr:{href:indexUrl}">
                        <span style="font-weight:bold">View the project page</span></a>
                    </div>
                    TAGS:
                    <span class="projecttag" data-bind="visible:isNoCost,click:doTag.bind($data,'noCost')"><g:message code="project.tag.noCost"/></span>
                    <span class="projecttag" data-bind="visible:hasTeachingMaterials,click:doTag.bind($data,'teach')"><g:message code="project.tag.teach"/></span>
                    <span class="projecttag" data-bind="visible:isDIY,click:doTag.bind($data,'diy')"><g:message code="project.tag.diy"/></span>
                    <span class="projecttag" data-bind="visible:isSuitableForChildren,click:doTag.bind($data,'children')"><g:message code="project.tag.children"/></span>
                    <span class="projecttag" data-bind="visible:difficulty == 'Easy',click:doTag.bind($data,'difficultyEasy')"><g:message code="project.tag.difficultyEasy"/></span>
                    <span class="projecttag" data-bind="visible:difficulty == 'Medium',click:doTag.bind($data,'difficultyMedium')"><g:message code="project.tag.difficultyMedium"/></span>
                    <span class="projecttag" data-bind="visible:difficulty == 'Hard',click:doTag.bind($data,'difficultyHard')"><g:message code="project.tag.difficultyHard"/></span>
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
        var vm = new ProjectViewModel({
            coverage: props[2],
            aim: props[1],
            isExternal: props[10],
            name: props[14],
            organisationId: props[15],
            organisationName: props[16],
            status: props[17],
            urlWeb: props[19],
            links: props[13]
        }, false, []);
        vm.projectId = props[0];
        vm.indexUrl = "${createLink()}/" + props[0];
        vm.transients.daysRemaining = ko.observable(props[3]);
        vm.transients.daysTotal = ko.observable(props[5]);
        vm.since = ko.pureComputed(function(){
          var daysSince = props[4];
          if (daysSince < 0) return "";
          if (daysSince === 0) return "today";
          if (daysSince === 1) return "yesterday";
          if (daysSince < 30) return daysSince + " days ago";
          if (daysSince === 30) return "one month ago";
          if (daysSince < 365) return (daysSince / 30).toFixed(1) + " months ago";
          if (daysSince === 365) return "one year ago";
          return (daysSince / 365).toFixed(1) + " years ago";
        });
        vm.difficulty = props[6];
        vm.hasTeachingMaterials = props[7];
        vm.isDIY = props[8];
        vm.isEditable = props[9];
        vm.isNoCost = props[11];
        vm.isSuitableForChildren = props[12];
        vm.orgUrl = props[15] && ("${createLink(controller:'organisation',action:'index')}/" + props[15]);
        vm.urlImage = props[18];
        vm.doTag = doTag;
        var x, urls = [];
        if (vm.urlWeb()) urls.push('<a href="' + fixUrl(vm.urlWeb()) + '">Website</a>');
        for (x = "", docs = vm.transients.mobileApps(), i = 0; i < docs.length; i++)
          x += '&nbsp;<a href="' + docs[i].link.url + '"><img class="logo-small" src="' + docs[i].logo(fcConfig.logoLocation) + '"/></a>';
        if (x) urls.push("Mobile Apps&nbsp;" + x);
        for (x = "", docs = vm.transients.socialMedia(), i = 0; i < docs.length; i++)
          x += '&nbsp;<a href="' + docs[i].link.url + '"><img class="logo-small" src="' + docs[i].logo(fcConfig.logoLocation) + '"/></a>';
        if (x) urls.push("Social Media&nbsp;" + x);
        vm.links = urls.join('&nbsp;&nbsp;|&nbsp;&nbsp;') || '';
        vm.searchText = (vm.name() + ' ' + vm.aim() + ' ' + vm.organisationName()).toLowerCase();
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

    var searchTerm = '', perPage = 5, sortBy = 'name', sortOrder = 1;

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
    doTag('${showTag}');

    var showActiveOnly, showTag;
    function doTag(tag) {
      showTag = tag;
      doSearch(true);
    }

    /*************************************************\
     *  Filter projects by search term
     \*************************************************/
    function doSearch(force) {
        var val = $('#pt-search').val().toLowerCase();
        if (!force && val === searchTerm) return;
        searchTerm = val;
        projects = [];
        for (var i = 0; i < allProjects.length; i++) {
            var item = allProjects[i];
            if (!item) continue;
            if (showActiveOnly && item.transients.daysRemaining() == 0) continue;
            if (showTag === 'children' && !item.isSuitableForChildren) continue;
            if (showTag === 'difficultyEasy' && item.difficulty != 'Easy') continue;
            if (showTag === 'difficultyMedium' && item.difficulty != 'Medium') continue;
            if (showTag === 'difficultyHard' && item.difficulty != 'Hard') continue;
            if (showTag === 'diy' && !item.isDIY) continue;
            if (showTag === 'noCost' && !item.isNoCost) continue;
            if (showTag === 'teach' && !item.hasTeachingMaterials) continue;
            if (item.searchText.indexOf(searchTerm) >= 0)
                projects.push(item);
        }
        offset = 0;
        total = projects.length;
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
    $('#pt-search-all').click(function() {
        $(this).attr("disabled", "disabled");
        $('#pt-search-active').removeAttr("disabled");
        showActiveOnly = false;
        doSearch(true);
    });
    $('#pt-search-active').click(function() {
        $(this).attr("disabled", "disabled");
        $('#pt-search-all').removeAttr("disabled");
        showActiveOnly = true;
        doSearch(true);
    });
});
</r:script>
</body>
</html>
