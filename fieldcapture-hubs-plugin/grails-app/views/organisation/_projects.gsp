<g:if test="${!disableProjectCreation}">
    <div class="row-fluid">
    <a href="${createLink(controller:'project', action: 'create', params: [organisationId: organisation.organisationId])}"
       class="btn btn-small pull-right">
        <i class="icon-file"></i>&nbsp;<g:message code="project.create.crumb"/></a>
    </div>
</g:if>
<g:if test="${organisation.projects}">
    <!-- ko stopBinding: true -->
    <div id="pt-root" class="row-fluid">
        <g:render template="/project/projectsList"/>
    </div>
    <!-- /ko -->
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
    <div class="row-fluid">
        <span class="span12"><h4>${organisation.name} is not currently involved in any projects.</h4></span>
    </div>
</g:else>
