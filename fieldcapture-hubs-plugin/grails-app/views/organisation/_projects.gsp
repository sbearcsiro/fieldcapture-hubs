<g:if test="${!config.disableProjectCreation}">
    <a href="${createLink(controller:'project', action: 'create', params: [organisationId: organisation.organisationId])}"
       class="btn btn-small">
        <i class="icon-file"></i>&nbsp;<g:message code="project.create.crumb"/></a>
</g:if>
<g:if test="${organisation.projects}">
    <table id="projectList" class="table

                    table-striped" style="width:100%;">
        <thead></thead>
        <tbody></tbody>
        <tfoot>
        <tr></tr>

        </tfoot>
    </table>
</g:if>
<g:else>
    <span class="span12"><h4>${organisation.name} is not currently involved in any projects.</h4></span>
</g:else>
