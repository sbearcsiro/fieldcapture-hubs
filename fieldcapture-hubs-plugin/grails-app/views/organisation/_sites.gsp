<div class="tab-pane active" id="mapView">
    <div class="map-box">
        <div id="map" style="width: 100%; height: 100%;"></div>
    </div>

    <div style=" float: right;" id="map-info">
        <span id="numberOfProjects">${organisation.projects?.size() ?: 0}</span> projects with <span id="numberOfSites">[calculating]</span>
    </div>
</div>

<r:script>

    function generateMap(markBy, facetList) {
        markBy =  (markBy === undefined) || markBy == "-1" ? "" : "&markBy="+markBy;

        var url = "${createLink(controller:'nocas', action:'geoService')}?max=10000&geo=true"+markBy;

        if (facetList && facetList.length > 0) {
            url += "&fq=" + facetList.join("&fq=");
        }

        $("#legend-table").hide();
        $("#map-colorby-status").show();
        $.getJSON(url, function(data) {

            var features = [];
            var projectIdMap = {};
            var bounds = new google.maps.LatLngBounds();
            var geoPoints = data;
            var legends = [];

            if (geoPoints.total) {
                var projectLinkPrefix = "${createLink(controller:'project')}/";
                var siteLinkPrefix = "${createLink(controller:'site')}/";
                $("#numberOfSites").html(geoPoints.total + " sites");

                if (geoPoints.total > 0) {
                    var staticColors =
                            ['#458B00','#FF0000','#FF00FF','#282828','#8B4513','#FF8000','#1E90FF','#a549f6','#20988e','#afaec9',
                                '#dc0430','#aa7f69','#1077f1','#6da1ab','#3598e6','#95294d','#f27ad5','#dfd06e','#c16b54','#34f242'];
                    $.each(geoPoints.selectedFacetTerms, function(i,facet){
                        var legend = {};
                        var hex = i < staticColors.length ? staticColors[facet.index] : getRandomColor();
                        legend.color = hex;
                        legend.legendName = facet.legendName;
                        legend.count = facet.count;
                        legends.push(legend);
                    });
                    $.each(geoPoints.projects, function(j, project) {
                        var projectId = project.projectId
                        var projectName = project.name

                        if (project.geo && project.geo.length > 0) {
                            $.each(project.geo, function(k, el) {
                                var point = {
                                    type: "dot",
                                    id: projectId,
                                    name: projectName,
                                    popup: generatePopup(projectLinkPrefix,projectId,projectName,project.org,siteLinkPrefix,el.siteId, el.siteName),
                                    latitude: el.loc.lat,
                                    longitude: el.loc.lon,
                                    color: "-1"
                                }
                                var lat = parseFloat(point.latitude);
                                var lon = parseFloat(point.longitude);
                                if (!isNaN(lat) && !isNaN(lon)) {
                                    if (lat >= -90 && lat <=90 && lon >= -180 && lon <= 180) {
                                        if(el.index !== undefined && el.index != null){
                                            point.color = legends[el.index].color;
                                            point.legendName = el.legendName;
                                        }
                                        features.push(point);
                                        bounds.extend(new google.maps.LatLng(el.loc.lat,el.loc.lon));
                                        if (projectId) {
                                            projectIdMap[projectId] = true;
                                        }
                                    }
                                }

                            });
                        }
                    });

                    if (facetList && facetList.length > 0) {
                        // convert projectIdMap to a list and add to global var
                        projectListIds = []; // clear the list
                        for (var id in projectIdMap) {
                            projectListIds.push(id);
                        }
                    } else {
                        projectListIds = []; // clear the list
                    }
                }
            }

            //To reduce memory footprint and leak, make sure to clear feature before loading new feature.
            alaMap.map ? clearMap() : "";
            $("#legend-table").fadeIn();
            $("#map-colorby-status").hide();

            initialiseMap(features, bounds);
            mapBounds = bounds;
            //updateProjectTable();
            features.length > 0 ? showLegends(legends) : "";

        }).error(function (request, status, error) {
            console.error("AJAX error", status, error);
        });
    }

    function initialiseMap(features, bounds){
        var mapData = {
            "zoomToBounds": true,
            "zoomLimit": 12,
            "highlightOnHover": false,
            "features": features
        };
        var layers = ${(geographicFacets?:[] as grails.converters.JSON).toString()};
        $.each(layers, function(i, layer) {
            layer.type = 'pid';
            layer.style = 'polygon';
            layer.excludeBounds = true;
            mapData.features.push(layer);
        });

        init_map_with_features({
                    mapContainer: "map",
                    zoomToBounds:true,
                    scrollwheel: false,
                    zoomLimit:16,
                    featureService: "${createLink(controller: 'proxy', action:'feature')}",
                    wmsServer: "${grailsApplication.config.spatial.geoserverUrl}"
                },
                mapData
        );

        if (!bounds.isEmpty()) {
            alaMap.map.fitBounds(bounds);
        } else {
            alaMap.map.setZoom(4);
        }

        // Create the DIV to hold the control and
        // call the HomeControl() constructor passing
        // in this DIV.
        %{--var homeControlDiv = document.createElement('div');--}%
        %{--var homeControl = new HomeControl(homeControlDiv, alaMap.map);--}%
        %{--homeControlDiv.index = 2;--}%
        %{--alaMap.map.controls[google.maps.ControlPosition.BOTTOM_LEFT].push(homeControlDiv);--}%

        %{--var homeToggleControlDiv = document.createElement('div');--}%
        %{--var toggleControl = new HomeToggleControl(homeToggleControlDiv, alaMap.map);--}%
        %{--homeToggleControlDiv.index = 1;--}%
        %{--alaMap.map.controls[google.maps.ControlPosition.BOTTOM_LEFT].push(homeToggleControlDiv);--}%

        var numSitesHtml = "";
        if(features.length > 0){
            numSitesHtml = features.length + " sites";
        } else {
            numSitesHtml = "0 sites <span class=\"label label-important\">No georeferenced points for the selected projects</span>";
        }

        $("#numberOfSites").html(numSitesHtml);
    }


    function generatePopup(projectLinkPrefix, projectId, projectName, orgName, siteLinkPrefix, siteId, siteName){

        //console.log('Generating popup for ' + siteId);

        var html = "<div class='projectInfoWindow'>";

        if (projectId && projectName) {
            html += "<div><i class='icon-home'></i> <a href='" +
                    projectLinkPrefix + projectId + "'>" +projectName + "</a></div>";
        }

        if(orgName !== undefined && orgName != ''){
            html += "<div><i class='icon-user'></i> Org name: " +orgName + "</div>";
        }

        html+= "<div><i class='icon-map-marker'></i> Site: <a href='" +siteLinkPrefix + siteId + "'>" + siteName + "</a></div>";
        return html;
    }
</r:script>
