<!-- ko stopBinding: true -->
<div id="sitemap">
            <script type="text/javascript" src="${grailsApplication.config.google.drawmaps.url}"></script>
            <div class="row-fluid">
                <g:hiddenField name="id" value="${site?.siteId}"/>
                <div>
                    <label for="name">Site name</label>
                    <h1>
                        <input data-bind="value: name" data-validation-engine="validate[required]"
                               class="span8" id="name" type="text" value="${site?.name?.encodeAsHTML()}"
                               placeholder="Enter a name for the new site"/>
                    </h1>
                </div>
            </div>
            <g:if test="${project && controllerName.equals('site')}">
            <div class="row-fluid" style="padding-bottom:15px;">
                <span>Project name:</span>
                <g:link controller="project" action="index" id="${project?.projectId}">${project?.name?.encodeAsHTML()}</g:link>
            </div>
            </g:if>
            <div class="row-fluid">
                <div class="span3">
                    <label for="externalId">External Id
                        <fc:iconHelp title="External id">Identifier code for the site - used in external documents.</fc:iconHelp>
                    </label>
                    <input data-bind="value:externalId" id="externalId" type="text" class="span12"/>
                </div>
                <div class="span3">
                    <label for="siteType">Type</label>
                    %{--<input data-bind="value: type" id="siteType" type="text" class="span12"/>--}%
                    <g:select id="siteType"
                              data-bind="value: type"
                              class="span12"
                              name='type'
                              from="['Works Area','Project Extent']"
                              keys="['worksArea','projectArea']"/>
                </div>
                <div class="span3">
                    <label for="siteContext">Context</label>
                    %{--<input data-bind="value: context" id="siteContext" type="text" class="span12"/>--}%
                    <g:select id="siteContext"
                              data-bind="value: context"
                              class="span12"
                              name='context'
                              from="['choose site context','Pastoral','Industrial','Urban','Coastal', 'Reserve', 'Private land']"
                              keys="['none','Pastoral','Industrial','Urban','Coastal','Reserve', 'Private land']"/>
                </div>
                <div class="span3">
                    <label for="siteArea">Area (decimal hectares)
                        <fc:iconHelp title="Area of site">The area in decimal hectares (4dp) enclosed within the boundary of the shape file.</fc:iconHelp></label>
                    <input data-bind="value: area" id="siteArea" type="text" class="span12"/>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span6">
                    <fc:textArea data-bind="value: description" id="description" label="Description" class="span12" rows="3" cols="50"/>
                </div>
                <div class="span6">
                    <fc:textArea data-bind="value: notes" id="notes" label="Notes" class="span12" rows="3" cols="50"/>
                </div>
            </div>

            <h2>Extent of site</h2>
            <fc:iconHelp title="Extent of the site">The extent of the site can be represented by
                a polygon, radius or point. KML, WKT and shape files are supported for uploading polygons.
                As are PID's of existing features in the Atlas Spatial Portal.</fc:iconHelp>

            <div class="row-fluid">

                <div class="span6">
                    <div id="mapForExtent" class="smallMap span6" style="width:100%;height:600px;"></div>
                </div>

                <div class="span6">

                    <div class="well well-small">

                        <div>
                            <h4>Define extent using:
                            <g:select class="input-medium" data-bind="value: extentSource"
                                      name='extentSource'
                                      from="['choose type','point','known shape','draw a shape']"
                                      keys="['none','point','pid','drawn']"/>
                            </h4>
                        </div>

                        <div id="map-controls" data-bind="visible: extent().source() == 'drawn' ">
                            <ul id="control-buttons">
                                <li class="active" id="pointer" title="Drag to move. Double click or use the zoom control to zoom.">
                                    <a href="javascript:void(0);" class="btn active draw-tool-btn">
                                    %{--<img src="${resource(dir:'bootstrap/img',file:'pointer.png')}" alt="pointer"/>--}%
                                    <img src="${resource(dir:'images',file:'glyphicons_347_hand_up.png')}" alt="center and radius"/>
                                    <span class="drawButtonLabel">Move & zoom</span>
                                    </a>
                                </li>
                                <li id="circle" title="Click at centre and drag the desired radius. Values can be adjusted in the boxes.">
                                    <a href="javascript:void(0);" class="btn draw-tool-btn">
                                    %{--<img src="${resource(dir:'images/map',file:'circle.png')}" alt="center and radius"/>--}%
                                    <img src="${resource(dir:'images',file:'glyphicons_095_vector_path_circle.png')}" alt="center and radius"/>
                                    <span class="drawButtonLabel">Draw circle</span>
                                    </a>
                                </li>
                                <li id="rectangle" title="Click and drag a rectangle.">
                                    <a href="javascript:void(0);" class="btn draw-tool-btn">
                                    %{--<img src="${resource(dir:'images/map',file:'rectangle.png')}" alt="rectangle"/>--}%
                                    <img src="${resource(dir:'images',file:'glyphicons_094_vector_path_square.png')}" alt="rectangle"/>
                                    <span class="drawButtonLabel">Draw rect</span>
                                    </a>
                                </li>
                                <li id="polygon" title="Click any number of times to draw a polygon. Double click to close the polygon.">
                                    <a href="javascript:void(0);" class="btn draw-tool-btn">
                                    %{--<img src="${resource(dir:'images/map',file:'polygon.png')}" alt="polygon"/>--}%
                                    <img src="${resource(dir:'images',file:'glyphicons_096_vector_path_polygon.png')}" alt="polygon"/>
                                    <span class="drawButtonLabel">Draw polygon</span>
                                    </a>
                                </li>
                                <li id="clear" title="Clear the region from the map.">
                                    <a href="javascript:void(0);" class="btn draw-tool-btn">
                                    %{--<img src="${resource(dir:'images/map',file:'clear.png')}" alt="clear"/>--}%
                                    <img src="${resource(dir:'images',file:'glyphicons_016_bin.png')}" alt="clear"/>
                                    <span class="drawButtonLabel">Clear</span>
                                    </a>
                                </li>
                                <li id="reset" title="Zoom and centre on Australia.">
                                    <a href="javascript:void(0);" class="btn draw-tool-btn">
                                    <img src="${resource(dir:'images',file:'reset.png')}" alt="reset map"/>
                                    <span class="drawButtonLabel">Reset</span>
                                    </a>
                                </li>
                                <li id="zoomToExtent" title="Zoom to extent of drawn shape.">
                                    <a href="javascript:zoomToShapeBounds();" class="btn draw-tool-btn">
                                    <img src="${resource(dir:'images',file:'glyphicons_186_move.png')}" alt="zoom to extent of drawn shape"/>
                                    <span class="drawButtonLabel">Zoom</span>
                                    </a>
                                </li>
                            </ul>
                         </div>

                         <div style="padding-top:10px;" data-bind="template: { name: extent().source, data: extent, afterRender: extent().renderMap}"></div>
                        </div>

                    <div class="well well-small">
                        <h4>Points of interest
                            <fc:iconHelp title="Points of interest">You can specify any number of points
                            of interest with a site. Points of interest may include photo points
                            or the locations of previous survey work.</fc:iconHelp>
                        </h4>
                        <div class="row-fluid" id="pointsOfInterest" >
                            <div class="span12" data-bind="foreach: poi">
                                <div>
                                    <div data-bind="template: { name: 'poi'}" ></div>
                                    <button type="button" class="btn btn-danger" style="margin-bottom:20px;" data-bind="click: $parent.removePOI, visible:!hasPhotoPointDocuments">Remove</button>
                                </div>
                                <hr/>
                            </div>
                        </div>
                        <div class="row-fluid">
                            <button type="button" data-bind="click: newPOI, visible: poi.length == 0" class="btn">Add a POI</button>
                            <button type="button" data-bind="click: newPOI, visible: poi.length > 0" class="btn">Add another POI</button>
                        </div>
                    </div>
                </div>
            </div>

<!-- templates -->
<script type="text/html" id="none">
    %{--<span>Choose a type</span>--}%
</script>

<script type="text/html" id="point">
<div class="drawLocationDiv row-fluid">
    <div class="span12">
        <div class="row-fluid controls-row">
            <fc:textField data-bind="value:geometry().decimalLatitude, event: { change: renderMap }" data-validation-engine="validate[required,custom[number],min[-90],max[0]]" outerClass="span6" label="Latitude"/>
            <fc:textField data-bind="value:geometry().decimalLongitude, event: { change: renderMap }" data-validation-engine="validate[required,custom[number],min[-180],max[180]]" data-prompt-position="topRight:-150" outerClass="span6" label="Longitude"/>
        </div>
        <div class="row-fluid controls-row">
            <fc:textField data-bind="value:geometry().uncertainty, enable: hasCoordinate()" outerClass="span4" label="Uncertainty"/>
            <fc:textField data-bind="value:geometry().precision, enable: hasCoordinate()" outerClass="span4" label="Precision"/>
            %{-- CG - only supporting WGS84 at the moment --}%
            <fc:textField data-bind="value:geometry().datum, enable: hasCoordinate()" outerClass="span4" label="Datum" placeholder="WGS84" readonly="readonly"/>
        </div>
    </div>
    <div class="row-fluid controls-row gazProperties">
        <span class="label label-success">State/territory</span> <span data-bind="text:geometry().state"></span>
    </div>
    <div class="row-fluid controls-row gazProperties">
        <span class="label label-success">Local Gov. Area</span> <span data-bind="text:geometry().lga"></span>
    </div>
    <div class="row-fluid controls-row gazProperties">
        <span class="label label-success">NRM</span> <span data-bind="text:geometry().nrm"></span>
    </div>
    <div class="row-fluid controls-row gazProperties">
        <span class="label label-success">Locality</span> <span data-bind="text:geometry().locality"></span>
    </div>
    <div class="row-fluid controls-row gazProperties">
        <span class="label label-success">NVIS major vegetation group:</span> <span data-bind="text:geometry().mvg"></span>
    </div>

    <div class="row-fluid controls-row gazProperties">
        <span class="label label-success">NVIS major vegetation subgroup:</span> <span data-bind="text:geometry().mvs"></span>
    </div>
</div>
</script>

    <script type="text/html" id="poi">
    <div class="drawLocationDiv row-fluid">
        <div class="span12">
            <div class="row-fluid alert" style="box-sizing:border-box;" data-bind="visible:hasPhotoPointDocuments">
                This point of interest has documents attached and cannot be removed.
            </div>
            <div class="row-fluid controls-row">
                <fc:textField data-bind="value:name" outerClass="span6" label="Name" data-validation-engine="validate[required]"/>
            </div>
            <div class="row-fluid controls-row">
                <fc:textArea rows="2" data-bind="value:description" outerClass="span12" class="span12" label="Description"/>
            </div>
            <div class="row-fluid controls-row">
                <label for="type">Point type</label>
                <g:select data-bind="value: type"
                          name='type'
                          from="['choose type','photopoint', 'location of previous surveys', 'other']"
                          keys="['none','photopoint', 'survey', 'other']"/>
            </div>
            <div class="row-fluid controls-row">
                <fc:textField data-bind="value:geometry().decimalLatitude" outerClass="span4" label="Latitude" data-validation-engine="validate[required,custom[number],min[-90],max[0]]" data-prompt-position="topRight:-150"/>
                <fc:textField data-bind="value:geometry().decimalLongitude" outerClass="span4" label="Longitude" data-validation-engine="validate[required,custom[number],min[-180],max[180]]"/>
                <fc:textField data-bind="value:geometry().bearing" outerClass="span4" label="Bearing (degrees)" data-validation-engine="validate[custom[number],min[0],max[360]]" data-prompt-position="topRight:-150"/>
            </div>
            <div class="row-fluid controls-row" style="display:none;">
                <fc:textField data-bind="value:geometry().uncertainty, enable: hasCoordinate()" outerClass="span4" label="Uncertainty"/>
                <fc:textField data-bind="value:geometry().precision, enable: hasCoordinate()" outerClass="span4" label="Precision"/>
                <fc:textField data-bind="value:geometry().datum, enable: hasCoordinate()" outerClass="span4" label="Datum" placeholder="e.g. WGS84"/>
            </div>
        </div>
    </div>
    </script>

    <script type="text/html" id="pid">
    <div id="pidLocationDiv" class="drawLocationDiv row-fluid">
        <div class="span12">
            <select data-bind="
            options: layers(),
            optionsCaption:'Choose a layer...',
            optionsValue: 'id',
            optionsText:'name',
            value: chosenLayer,
            event: { change: refreshObjectList }"></select>
            <select data-bind="options: layerObjects, disable: layerObjects().length == 0,
            optionsCaption:'Choose shape ...',
            optionsValue: 'pid',
            optionsText:'name', value: layerObject, event: { change: updateSelectedPid }"></select>
            <div class="row-fluid controls-row" style="display:none;">
                <span class="label label-success">PID</span> <span data-bind="text:geometry().pid"></span>
            </div>
            <div class="row-fluid controls-row">
                <span class="label label-success">Name</span> <span data-bind="text:geometry().name"></span>
            </div>
            <div class="row-fluid controls-row" style="display:none;">
                <span class="label label-success">LayerID</span> <span data-bind="text:geometry().fid"></span>
            </div>
            <div class="row-fluid controls-row">
                <span class="label label-success">Layer</span> <span data-bind="text:geometry().layerName"></span>
            </div>
            <div class="row-fluid controls-row">
                <span class="label label-success">Area (km&sup2;)</span> <span data-bind="text:geometry().area"></span>
            </div>
        </div>
    </div>
    </script>

    <script type="text/html" id="upload">
    <h3> Not implemented - waiting on web services...</h3>
    </script>

    <script type="text/html" id="drawn">
    <div id="drawnLocationDiv" class="drawLocationDiv row-fluid">
        <div class="span12">

            <div class="row-fluid controls-row" style="display:none;">
                <span class="label label-success">Type</span> <span data-bind="text:geometry().type"></span>
            </div>
            <div class="row-fluid controls-row" data-bind="visible: geometry!=null && geometry().areaKmSq!=null && geometry().areaKmSq != '' ">
                <span class="label label-success">Area (km&sup2;)</span> <span data-bind="text:geometry().areaKmSq"></span>
            </div>

            <div class="row-fluid controls-row gazProperties" data-bind="visible: geometry!=null && geometry().state!=null && geometry().state!=''">
                <span class="label label-success">State/territory</span> <span data-bind="text:geometry().state"></span>
            </div>

            <div class="row-fluid controls-row gazProperties" data-bind="visible: geometry!=null && geometry().lga!=null && geometry().lga!=''">
                <span class="label label-success">Local Gov. Area</span> <span data-bind="text:geometry().lga"></span>
            </div>

            <div class="row-fluid controls-row gazProperties">
                <span class="label label-success">NRM</span> <span data-bind="text:geometry().nrm"></span>
            </div>

            <div class="row-fluid controls-row gazProperties">
                <span class="label label-success">Locality</span> <span data-bind="text:geometry().locality"></span>
            </div>

            <div class="row-fluid controls-row gazProperties">
                <span class="label label-success">NVIS major vegetation group:</span> <span data-bind="text:geometry().mvg"></span>
            </div>

            <div class="row-fluid controls-row gazProperties">
                <span class="label label-success">NVIS major vegetation subgroup:</span> <span data-bind="text:geometry().mvs"></span>
            </div>

            <div style="display:none;" class="row-fluid controls-row">
                <span class="label label-success">Center</span> <span data-bind="text:geometry().centre"></span>
            </div>
            <div class="row-fluid controls-row circleProperties propertyGroup">
                <span class="label label-success">Radius (m)</span> <span data-bind="text:geometry().radius"></span>
            </div>

            <div style="display:none;" class="row-fluid controls-row  propertyGroup">
                <span class="label">GeoJSON</span> <span data-bind="text:ko.toJSON(geometry())"></span>
            </div>

            <div class="row-fluid controls-row rectangleProperties propertyGroup">
                <span class="label label-success">Latitude (SW)</span> <span data-bind="text:geometry().minLat"></span>
                <span class="label label-success">Longitude (SW)</span> <span data-bind="text:geometry().minLon"></span>
            </div>
            <div class="row-fluid controls-row rectangleProperties propertyGroup">
                <span class="label label-success">Latitude (NE)</span> <span data-bind="text:geometry().maxLat"></span>
                <span class="label label-success">Longitude (NE)</span> <span data-bind="text:geometry().maxLon"></span>
            </div>
        </div>
        %{--<div class="smallMap span8" style="width:500px;height:300px;"></div>--}%
    </div>
    </script>
</div>
<!-- /ko -->

<r:script>
function initSiteViewModel() {
    var siteViewModel;

    // server side generated paths & properties
    var SERVER_CONF = {
        siteData: ${site?:[] as grails.converters.JSON},
        spatialService: '${createLink(controller:'proxy',action:'feature')}',
        intersectService: "${createLink(controller: 'proxy', action: 'intersect')}",
        featuresService: "${createLink(controller: 'proxy', action: 'features')}",
        featureService: "${createLink(controller: 'proxy', action: 'feature')}",
        spatialWms: '${grailsApplication.config.spatial.geoserverUrl}'
    };

    var savedSiteData = {
        siteId: "${site?.siteId}",
        name : "${site?.name?.encodeAsJavaScript()}",
        externalId : "${site?.externalId}",
        context : "${site?.context}",
        type : "${site?.type}",
        extent: ${site?.extent?:'null'},
        poi: ${site?.poi?:'[]'},
        area : "${site?.area}",
        description : "${site?.description?.encodeAsJavaScript()}",
        notes : "${site?.notes?.encodeAsJavaScript()}",
        documents : JSON.parse('${(siteDocuments?:documents).encodeAsJavaScript()}'),
    <g:if test="${project}">
        projects : ['${project.projectId}'],
    </g:if>
    <g:else>
        projects : ${site?.projects?:'[]'}
    </g:else>
    };


    (function(){

        function SiteViewModelWithMapIntegration (siteData) {
            var self = $.extend(this, new SiteViewModel(siteData));

            self.renderPOIs = function(){
               // console.log('Rendering the POIs now');
                removeMarkers();
                for(var i=0; i<self.poi().length; i++){
                    //console.log('Rendering the POI: ' + self.poi()[i].geometry().decimalLatitude() +':'+ self.poi()[i].geometry().decimalLongitude());
                    addMarker(self.poi()[i].geometry().decimalLatitude(), self.poi()[i].geometry().decimalLongitude(), self.poi()[i].name(), self.poi()[i].dragEvent)
                }
            };
            self.newPOI = function(){
                //get the center of the map
                var lngLat = getMapCentre();
                var randomBit = (self.poi().length + 1) /1000;
                var poi = new POI({name:'Point of interest #' + (self.poi().length + 1) , geometry:{decimalLongitude:lngLat[0] - (0.001+randomBit),decimalLatitude:lngLat[1] - (0.001+randomBit)}}, false);
                self.addPOI(poi);
                self.watchPOIGeometryChanges(poi);

            };
            self.notImplemented = function () {
                alert("Not implemented yet.")
            };

            self.watchPOIGeometryChanges = function(poi) {
                poi.geometry().decimalLatitude.subscribe(self.renderPOIs);
                poi.geometry().decimalLongitude.subscribe(self.renderPOIs);
            };
            self.poi.subscribe(self.renderPOIs);
            $.each(self.poi(), function(i, poi) {
                self.watchPOIGeometryChanges(poi);
            });

            self.renderSavedShape = function(){
                var currentDrawnShape = ko.toJS(self.extent().geometry);
                //retrieve the current shape if exists
                if(currentDrawnShape !== undefined){
                    if(currentDrawnShape.type == 'Polygon'){
                        showOnMap('polygon', geoJsonToPath(currentDrawnShape));
                        zoomToShapeBounds();
                    } else if(currentDrawnShape.type == 'Circle'){
                        console.log('Redrawing circle');
                        showOnMap('circle', currentDrawnShape.coordinates[1],currentDrawnShape.coordinates[0],currentDrawnShape.radius);
                        zoomToShapeBounds();
                    } else if(currentDrawnShape.type == 'Rectangle'){
                        console.log('Redrawing rectangle');
                        var shapeBounds = new google.maps.LatLngBounds(
                            new google.maps.LatLng(currentDrawnShape.minLat,currentDrawnShape.minLon),
                            new google.maps.LatLng(currentDrawnShape.maxLat,currentDrawnShape.maxLon)
                        );
                        //render on the map
                        showOnMap('rectangle', shapeBounds);
                        zoomToShapeBounds();
                    } else if(currentDrawnShape.type == 'pid'){
                        console.log('Loading the PID...' + currentDrawnShape.pid);
                        showObjectOnMap(currentDrawnShape.pid);
                        siteViewModel.extent().setCurrentPID();
                    } else if(currentDrawnShape.type == 'Point'){
                        console.log('Loading the point...' + currentDrawnShape.pid);
                        showOnMap('point', currentDrawnShape.decimalLatitude, currentDrawnShape.decimalLongitude,'site name');
                        zoomToShapeBounds();
                        showSatellite();
                        //addMarker(currentDrawnShape.decimalLatitude,currentDrawnShape.decimalLongitude);
                    }
                }
            };
            self.shapeDrawn = function(source, type, shape) {
                var drawnShape;
                if (source === 'clear') {
                    drawnShape = null;

                } else {

                    switch (type) {
                        case google.maps.drawing.OverlayType.CIRCLE:
                            /*// don't show or set circle props if source is a locality
                             if (source === "user-drawn") {*/
                            var center = shape.getCenter();
                            // set coord display

                            var calcAreaKm = ((3.14 * shape.getRadius() * shape.getRadius())/1000)/1000;

                            //calculate the area
                            drawnShape = {
                                type:'Circle',
                                userDrawn: 'Circle',
                                coordinates:[center.lng(), center.lat()],
                                centre: [center.lng(), center.lat()],
                                radius: shape.getRadius(),
                                areaKmSq:calcAreaKm
                            };
                            break;
                        case google.maps.drawing.OverlayType.RECTANGLE:
                            var bounds = shape.getBounds(),
                                    sw = bounds.getSouthWest(),
                                    ne = bounds.getNorthEast();

                            //calculate the area
                            var mvcArray = new google.maps.MVCArray();
                            mvcArray.push(new google.maps.LatLng(sw.lat(), sw.lng()));
                            mvcArray.push(new google.maps.LatLng(ne.lat(), sw.lng()));
                            mvcArray.push(new google.maps.LatLng(ne.lat(), ne.lng()));
                            mvcArray.push(new google.maps.LatLng(sw.lat(), ne.lng()));
                            mvcArray.push(new google.maps.LatLng(sw.lat(), sw.lng()));

                            var calculatedArea = google.maps.geometry.spherical.computeArea(mvcArray);
                            var calcAreaKm = ((calculatedArea)/1000)/1000;

                            var centreY = (sw.lat() + ne.lat())/2;
                            var centreX =  (sw.lng() + ne.lng())/2;

                            drawnShape = {
                                type: 'Polygon',
                                userDrawn: 'Rectangle',
                                coordinates:[[
                                    [sw.lng(),sw.lat()],
                                    [sw.lng(),ne.lat()],
                                    [ne.lng(),ne.lat()],
                                    [ne.lng(),sw.lat()],
                                    [ne.lng(),sw.lat()]
                                ]],
                                bbox:[sw.lat(),sw.lng(),ne.lat(),ne.lng()],
                                areaKmSq:calcAreaKm,
                                centre: [centreX,centreY]
                            }
                            break;
                        case google.maps.drawing.OverlayType.POLYGON:
                            /*
                             * Note that the path received from the drawing manager does not end by repeating the starting
                             * point (number coords = number vertices). However the path derived from a WKT does repeat
                             * (num coords = num vertices + 1). So we need to check whether the last coord is the same as the
                             * first and if so ignore it.
                             */
                            var path;

                            if(shape.getPath()){
                                path = shape.getPath();
                            } else {
                                path = shape;
                            }

                            //calculate the area
                            var calculatedAreaInSqM = google.maps.geometry.spherical.computeArea(path);
                            var calcAreaKm = ((calculatedAreaInSqM)/1000)/1000;


                            //get the centre point of a polygon ??
                            var minLat=90,
                                    minLng=180,
                                    maxLat=-90,
                                    maxLng=-180;

                            // There appears to have been an API change here - this is required locally but it
                            // still works without this change in test and prod.
                            var pathArray = path;
                            if (typeof(path.getArray) === 'function') {
                                pathArray = path.getArray();
                            }
                            $.each(pathArray, function(i){
                              //console.log(path.getAt(i));
                              var coord = path.getAt(i);
                              if(coord.lat()>maxLat) maxLat = coord.lat();
                              if(coord.lat()<minLat) minLat = coord.lat();
                              if(coord.lng()>maxLng) maxLng = coord.lng();
                              if(coord.lng()<minLng) minLng = coord.lng();
                            });
                            var centreX = minLng + ((maxLng - minLng) / 2);
                            var centreY = minLat + ((maxLat - minLat) / 2);

                            drawnShape = {
                                type:'Polygon',
                                userDrawn: 'Polygon',
                                coordinates: polygonToGeoJson(path),
                                areaKmSq: calcAreaKm,
                                centre: [centreX,centreY]
                            };
                            break;
                        case google.maps.drawing.OverlayType.MARKER:
                            siteViewModel.extent().updateGeometry(shape.getPosition());
                            // This call is too expensive to do while dragging so the marker has been decorated with
                            // the event information.
                            if (!shape.dragging) {
                                siteViewModel.refreshGazInfo();
                            }

                            break;
                    }

                }
                //set the drawn shape
                if(drawnShape != null && type !== google.maps.drawing.OverlayType.MARKER){
                    siteViewModel.extent().updateGeom(drawnShape);
                    siteViewModel.refreshGazInfo();
                }
            };
            self.mapInitialised = function(map) {
                self.loadExtent();
                self.renderPOIs();
                self.renderSavedShape();
                setCurrentShapeCallback(self.shapeDrawn);
            }

        };

        //retrieve serialised model
        siteViewModel = new SiteViewModelWithMapIntegration(savedSiteData);
        ko.applyBindings(siteViewModel, document.getElementById("sitemap"));

        init_map({
            spatialService: SERVER_CONF.spatialService,
            spatialWms: SERVER_CONF.spatialWms,
            mapContainer: 'mapForExtent'
        });


        siteViewModel.mapInitialised(window);


    }());

    return siteViewModel;
}
</r:script>
