package au.org.ala.fieldcapture

import grails.converters.JSON

/**
 * Proxies to the ecodata DocumentController/DocumentService.
 */
class DocumentService {

    def webService, grailsApplication

    def createTextDocument(doc, content) {
        doc.content = content
        updateDocument(doc)
    }

    def updateDocument(doc) {
        def url = grailsApplication.config.ecodata.baseUrl + "document/"+doc.documentId

        return webService.doPost(url, doc)
    }

    def createDocument(doc, contentType, inputStream) {

        def url = grailsApplication.config.ecodata.baseUrl + "document"

        def params = [document:doc as JSON]
        return webService.postMultipart(url, params, inputStream, contentType, doc.filename)
    }

    def getDocumentsForSite(id) {
        def url = "${grailsApplication.config.ecodata.baseUrl}site/${id}/documents"
        return webService.doPost(url, [:])
    }
}
