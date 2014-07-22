package au.org.ala.fieldcapture

import groovy.text.GStringTemplateEngine

class SettingService {

    private static def ThreadLocal localHhubConfig = new ThreadLocal()

    public static void setHubConfig(hubConfig) {
        localHhubConfig.set(hubConfig)
    }

    public static void clearHubConfig() {
        localHhubConfig.remove()
    }

    public static Map getHubConfig() {
        return localHhubConfig.get()
    }

    def webService, cacheService
    def grailsApplication

    def getSettingText(SettingPageType type) {
        def key = localHhubConfig.get().settingsPageKeyPrefix + type.key

        String url = grailsApplication.config.ecodata.baseUrl + "setting/ajaxGetSettingTextForKey?key=${key}"
        def res = cacheService.get(key,{ webService.getJson(url) })
        return res?.settingText?:""
    }

    def setSettingText(SettingPageType type, String content) {
        def key = localHhubConfig.get().settingsPageKeyPrefix + type.key

        cacheService.clear(key)
        String url = grailsApplication.config.ecodata.baseUrl + "setting/ajaxSetSettingText/${key}"
        webService.doPost(url, [settingText: content, key: key])
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

}
