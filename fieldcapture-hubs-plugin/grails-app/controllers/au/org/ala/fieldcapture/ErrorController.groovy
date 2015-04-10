package au.org.ala.fieldcapture

class ErrorController {

    def settingService, cookieService
    def response404() {

        def hub = cookieService.getCookie(SettingService.LAST_ACCESSED_HUB)
        settingService.loadHubConfig(hub)
        render view:'/404'
    }

    def response500() {
        render view:'/error'
    }
}
