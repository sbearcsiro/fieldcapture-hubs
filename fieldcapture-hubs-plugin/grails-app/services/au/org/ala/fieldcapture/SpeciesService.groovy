package au.org.ala.fieldcapture

class SpeciesService {

    def webService, grailsApplication

    def searchForSpecies(searchTerm, limit = 10, listId = null) {

        // Try the project species list first.
        if (listId) {
            def results = filterSpeciesList(searchTerm, listId)
            if (results.count) {
                return results
            }
        }
        def results = searchBie(searchTerm, limit)
        return results
    }

    /**
     * Searches for an exact match of scientific name in the BIE and optionally a project list.
     * @param scientificName the scientific name of the taxa to search for.
     * @param listId the list to search if desired.
     * @return the matching taxa, or null if not match was found.
     */
    def searchByScientificName(scientificName, listId = null) {
        def results = searchForSpecies(scientificName, 10, listId)
        return results?.autoCompleteList?.find {it.name.equalsIgnoreCase(scientificName)}
    }

    /**
     * Searches the "name" returned by the Species List service for the supplied search term and reformats the
     * results to match those returned by the bie.
     * @param query the term to search for.
     * @param listId the id of the list to search.
     * @return a JSON formatted String of the form {"autoCompleteList":[{...results...}]}
     */
    private def filterSpeciesList(String query, String listId) {
        def listContents = webService.getJson("${grailsApplication.config.lists.baseURL}/ws/speciesListItems/${listId}", false)

        def filtered = listContents.findResults({it.name?.toLowerCase().contains(query.toLowerCase()) ? [id: it.id, listId: listId, name: it.name, scientificNameMatches:[it.name], guid:it.lsid]: null})

        def results = [:];
        results.autoCompleteList = filtered
        results.count = filtered.size()

        return results
    }

    def searchBie(searchTerm, limit) {
        if (!limit) {
            limit = 10
        }
        def encodedQuery = URLEncoder.encode(searchTerm, "UTF-8")
        def url = "${grailsApplication.config.bie.baseURL}/ws/search/auto.jsonp?q=${encodedQuery}&limit=${limit}&idxType=TAXON"

        webService.getJson(url)
    }

    def searchSpeciesList(sort = 'listName', max = 100, offset = 0) {
        webService.getJson("${grailsApplication.config.lists.baseURL}/ws/speciesList?sort=${sort}&max=${max}&offset=${offset}")
    }

    def addSpeciesList(postBody) {
       webService.doPost("${grailsApplication.config.lists.baseURL}/ws/speciesList", postBody)
    }

}
