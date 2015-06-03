package au.org.ala.fieldcapture

import grails.converters.JSON

class ProjectActivityController {
    def projectActivityService, metadataService, speciesService
    static ignore = ['action','controller','id']

    def getAllByProject(id){

    }

    // TODO: add security.
    def ajaxCreate() {

        def postBody = request.JSON
        log.debug "Body: " + postBody
        log.debug "Params:"
        params.each { println it }
        def values = [:]
        postBody.each { k, v ->
            if (!(k in ignore)) {
                values[k] = v
            }
        }
        log.debug "values: " + (values as JSON).toString()
        def result = projectActivityService.create(values)

        if(result.error){
            response.status = 500
        } else {
            render result as JSON
        }
    }

    def ajaxUpdate(String id) {
        def postBody = request.JSON
        log.debug "Body: " + postBody
        log.debug "Params:"
        params.each { println it }
        def values = [:]
        postBody.each { k, v ->
            if (!(k in ignore)) {
                values[k] = v
            }
        }
        log.debug "values: " + (values as JSON).toString()
        def result = projectActivityService.update(id, values)

        if(result.error){
            response.status = 500
        } else {
            render result as JSON
        }
    }

    // ActivityType can be ProjectActivty or Task based activity
    // Search only for ProjectActivity
    // Search project type activity
    def searchActivity (){
        //def outputModels = activityModel.outputs.collect { metadataService.annotatedOutputDataModel(it) }
    }
}
