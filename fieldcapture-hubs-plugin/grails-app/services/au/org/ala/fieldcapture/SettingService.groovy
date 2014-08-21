package au.org.ala.fieldcapture

import grails.converters.JSON
import groovy.text.GStringTemplateEngine

class SettingService {

    private static def ThreadLocal localHubConfig = new ThreadLocal()

    public static void setHubConfig(hubConfig) {
        localHubConfig.set(hubConfig)
    }

    public static void clearHubConfig() {
        localHubConfig.remove()
    }

    public static Map getHubConfig() {
        return localHubConfig.get()
    }

    def webService, cacheService
    def grailsApplication

    def getSettingText(SettingPageType type) {
        def key = localHubConfig.get().settingsPageKeyPrefix + type.key

        get(key)

    }

    def setSettingText(SettingPageType type, String content) {
        def key = localHubConfig.get().settingsPageKeyPrefix + type.key

        cacheService.clear(key)
        String url = grailsApplication.config.ecodata.baseUrl + "setting/ajaxSetSettingText/${key}"
        webService.doPost(url, [settingText: content, key: key])
    }

    private def get(key) {
        String url = grailsApplication.config.ecodata.baseUrl + "setting/ajaxGetSettingTextForKey?key=${key}"
        def res = cacheService.get(key,{ webService.getJson(url) })
        return res?.settingText?:""
    }

    /**
     * Allows for basic GString style substitution into a Settings page.  If the saved template text includes
     * ${}, these will be substituted for values in the supplied model
     * @param type identifies the settings page to return.
     * @param substitutionModel values to substitute into the page.
     * @return the settings page after substitutions have been made.
     */
    def getSettingText(SettingPageType type, substitutionModel) {
        String templateText = getSettingText(type)
        GStringTemplateEngine templateEngine = new GStringTemplateEngine();
        return templateEngine.createTemplate(templateText).make(substitutionModel).toString()
    }

    def getProjectSettings(projectId) {
        def settings = get(projectId+'.settings')
        return settings ? JSON.parse(settings) : [:]
    }

}
