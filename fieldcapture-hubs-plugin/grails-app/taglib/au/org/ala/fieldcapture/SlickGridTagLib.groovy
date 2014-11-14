package au.org.ala.fieldcapture

import grails.converters.JSON

class SlickGridTagLib {
    static namespace = "fc"

    def slickGridOptions = { attrs ->
        def options = [
            editable: true,
            enableAddRow: true,
            enableCellNavigation: true,
            asyncEditorLoading: true,
            forceFitColumns: true,

            topPanelHeight: 25
        ] as JSON

        out << "var options = JSON.parse('${options.toString().encodeAsJavaScript()}');"
    }

    def slickGridColumns = { attrs ->
        def dataModel = attrs.model
        def columns = []
        dataModel.each {

            def editor = null
            switch(it.dataType) {
                case 'number':
                    editor = 'Integer'
                    break;
                case 'integer':
                    editor = 'Integer'
                    break;
                case 'text':
                    editor = 'Text'
                    break;
                case 'date':
                case 'simpleDate':
                    editor = 'Date'
                    break;
                case 'image':
                    break;
                case 'embeddedImages':
                    break;
                case 'species':
                    break;
                case 'stringList':
                    break;
                case 'boolean':
                    editor = 'Checkbox'
                    break;
                case 'lookupRange':
                    break; // do nothing
            }
            if (editor) {
                columns << [id: it.name, name: it.label ?: it.name, field: it.name, editorType:editor]
            }
        }
        out << "JSON.parse('${(columns as JSON).toString().encodeAsJavaScript()}');"



    }

    def slickGridData = { attrs ->

        out << "JSON.parse('${(attrs.data as JSON).toString().encodeAsJavaScript()}');"

    }

}
