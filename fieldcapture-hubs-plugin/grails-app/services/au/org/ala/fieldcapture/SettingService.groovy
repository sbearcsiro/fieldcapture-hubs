package au.org.ala.fieldcapture

import grails.converters.JSON
import groovy.text.GStringTemplateEngine

class SettingService {

    private static def ThreadLocal localHubConfig = new ThreadLocal()
    private static final String HUB_CONFIG_KEY_SUFFIX = '.hub.configuration'

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

    /**
     * Checks if there is a configuration defined for the specified hub.
     */
    boolean isValidHub(hub) {
        getHubSettings(hub) as boolean
    }

    def loadHubConfig(hub) {
        def settings = getHubSettings(hub)
        if (!settings) {
            settings = [
                    settingsPageKeyPrefix:'',
                    availableFacets: "status,organisationFacet,associatedProgramFacet,associatedSubProgramFacet,mainThemeFacet,stateFacet,nrmFacet,lgaFacet,mvgFacet,ibraFacet,imcra4_pbFacet,otherFacet"
            ]
        }

        SettingService.setHubConfig(settings)


        // Lookup portal from database?  Or simply parse the URL?  Or access request?
//        def hubConfig = [
//                bannerUrl            : 'http://www.greateasternranges.org.au/templates/rt_chapelco/images/main/bg-header-mt.png',
//                logoUrl              : 'http://www.greateasternranges.org.au/wp-content/themes/ger/images/ger-logo-205x150px.png',
//                title                : 'Great Eastern Ranges',
//                settingsPageKeyPrefix: 'ger.',
//                availableFacets      : "organisationFacet,gerSubRegionFacet,associatedProgramFacet,mainThemeFacet,stateFacet,lgaFacet,mvgFacet",
//                defaultFacetQuery    : ['otherFacet:Great Eastern Ranges Initiative']
//        ]


    }

    def getSettingText(SettingPageType type) {
        def key = localHubConfig.get().settingsPageKeyPrefix + type.key

        get(key)

    }

    def setSettingText(SettingPageType type, String content) {
        def key = localHubConfig.get().settingsPageKeyPrefix + type.key

        set(key, content)
    }

    private def get(key) {
        String url = grailsApplication.config.ecodata.baseUrl + "setting/ajaxGetSettingTextForKey?key=${key}"
        def res = cacheService.get(key,{ webService.getJson(url) })
        return res?.settingText?:""
    }

    private def getJson(key) {
        cacheService.get(key, {
            def settings = get(key)
            return settings ? JSON.parse(settings) : [:]
        })
    }

    private def set(key, settings) {
        cacheService.clear(key)
        String url = grailsApplication.config.ecodata.baseUrl + "setting/ajaxSetSettingText/${key}"
        webService.doPost(url, [settingText: settings, key: key])
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

    private def projectSettingsKey(projectId) {
        return projectId+'.settings'
    }

    def getProjectSettings(projectId) {
        getJson(projectSettingsKey(projectId))
    }

    def updateProjectSettings(projectId, settings) {
        def key = projectSettingsKey(projectId)
        set(key, (settings as JSON).toString())
    }

    private def hubSettingsKey(hub) {
        if (!hub) {
            throw new IllegalArgumentException("the hub parameter must not be null")
        }
        return hub+HUB_CONFIG_KEY_SUFFIX
    }

    def getHubSettings(hub) {
        if (!hub) { hub = 'default' }
        getJson(hubSettingsKey(hub))
    }

    def updateHubSettings(hub, settings) {
        set(hubSettingsKey(hub), settings)
    }

}
