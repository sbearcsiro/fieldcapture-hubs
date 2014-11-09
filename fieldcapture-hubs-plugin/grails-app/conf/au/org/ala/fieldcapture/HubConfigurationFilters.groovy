package au.org.ala.fieldcapture

class HubConfigurationFilters {

    def settingService

    def filters = {
        all(controller: '*', action: '*') {
            before = {
                settingService.loadHubConfig(params.hub)
                request.setAttribute('hubConfig', SettingService.getHubConfig())
            }
            after = { Map model ->

            }
            afterView = { Exception e ->
                // The settings are cleared in a servlet filter so they are available during page rendering.
            }
        }
    }
}
