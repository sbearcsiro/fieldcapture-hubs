<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
      <link rel="stylesheet" href="http://openlayers.org/dev/theme/default/style.css" type="text/css"/>
      <link rel="stylesheet" href="http://openlayers.org/dev/examples/style.css" type="text/css"/>
    <title>WFS: GetFeature Example (GeoServer)</title>
      <!--g:javascript src="OpenLayers/OpenLayers.js" /-->
    <script src="http://openlayers.org/dev/OpenLayers.js"></script>
    <script type="text/javascript">
        var map, layer, select, hover, control;

        function init(){
            OpenLayers.ProxyHost= "http://localhost:8070/pt/proxy?url=";
            map = new OpenLayers.Map('map', {
                controls: [
                    new OpenLayers.Control.PanZoom(),
                    new OpenLayers.Control.Permalink(),
                    new OpenLayers.Control.Navigation()
                ]
            });
            layer = new OpenLayers.Layer.WMS(
                "States WMS/WFS",
                "http://v2.suite.opengeo.org/geoserver/ows",
                {layers: 'usa:states', format: 'image/gif'}
            );
            select = new OpenLayers.Layer.Vector("Selection", {styleMap:
                new OpenLayers.Style(OpenLayers.Feature.Vector.style["select"])
            });
            hover = new OpenLayers.Layer.Vector("Hover");
            map.addLayers([layer, hover, select]);

            control = new OpenLayers.Control.GetFeature({
                protocol: OpenLayers.Protocol.WFS.fromWMSLayer(layer),
                box: true,
                hover: false,
                multipleKey: "shiftKey",
                toggleKey: "ctrlKey"
            });
            control.events.register("featureselected", this, function(e) {
//                alert("fs");
                select.addFeatures([e.feature]);
            });
            control.events.register("featureunselected", this, function(e) {
//                alert("fu");
                select.removeFeatures([e.feature]);
            });
            control.events.register("hoverfeature", this, function(e) {
//                alert("hf");
                hover.addFeatures([e.feature]);
            });
            control.events.register("outfeature", this, function(e) {
//                alert("of");
                hover.removeFeatures([e.feature]);
            });
            map.addControl(control);
            control.activate();

            map.setCenter(new OpenLayers.Bounds(-140.444336,25.115234,-44.438477,50.580078).getCenterLonLat(), 3);
        }
    </script>
  </head>
  <body onload="init()">
<h1 id="title">WFS GetFeature Example (GeoServer)</h1>

<div id="tags">
WFS, GetFeature
</div>

<p id="shortdesc">
    Shows how to use the GetFeature control to select features from a WMS layer.
</p>

<div id="map" class="smallmap"></div>

<div id="docs">
    <p>
        Click or drag a box to select features, use the Shift key to add
        features to the selection, use the Ctrl key to toggle a feature's
        selected status. Note that this control also has a hover option, which
        is enabled in this example. This gives you a visual feedback by loading
        the feature underneath the mouse pointer from the WFS, but causes a lot
        of GetFeature requests to be issued.
    </p>
</div>
</body>
</html>