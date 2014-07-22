package au.org.ala.fieldcapture

import javax.servlet.*
/**
 * Exposes some thread local configuration based on the URL.
 */
class HubConfigurationFilter implements Filter {

    void init(FilterConfig config) {}

    void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {

        try {
            // Lookup portal from database?  Or simply parse the URL?  Or access request?
            def hubConfig = [
                    bannerUrl : 'http://www.greateasternranges.org.au/templates/rt_chapelco/images/main/bg-header-mt.png',
                    title: 'Great Eastern Ranges',
                    settingsPageKeyPrefix : 'ger.',
                    availableFacets: "organisationFacet,associatedProgramFacet,associatedSubProgramFacet,fundingSourceFacet,mainThemeFacet,statesFacet,nrmsFacet,lgasFacet,mvgsFacet,ibraFacet,imcra4_pbFacet,otherFacet",
                    defaultFacetQuery: ['otherFacet:GER National Corridor']
            ]
            SettingService.setHubConfig(hubConfig)
            request.setAttribute('hubConfig', hubConfig)

            chain.doFilter(request, response)
        }
        finally {
            SettingService.clearHubConfig()
        }
    }

    void destroy() {}
}
