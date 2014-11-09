<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta name="layout" content="${grailsApplication.config.layout.skin?:'main'}"/>
  <title>Organisations | Field Capture</title>
  <script type="text/javascript" src="${grailsApplication.config.google.maps.url}"></script>
  <r:script disposition="head">
        var fcConfig = {
            serverUrl: "${grailsApplication.config.grails.serverURL}",
            createOrganisationUrl: "${createLink(controller: 'organisation', action: 'create')}",
            viewOrganisationUrl: "${createLink(controller: 'organisation', action: 'index')}",

            };
  </r:script>
  <r:require modules="knockout,mapWithFeatures,amplify"/>
</head>
<body>
<div class="container-fluid">
  <ul class="breadcrumb">
    <li>
      <g:link controller="home">Home</g:link><span class="divider">/</span>
    </li>
    <li class="active">Organisations<span class="divider"></span></li>
  </ul>

  <div class="row-fluid">
    <span class="span12">
      <button class="btn" data-bind="click:addOrganisation">New</button>
    </span>

  </div>


  <div class="row-fluid">
    <span class="span12">
      <table class="table table-condensed" id="organisations">
        <thead>
          <tr>
            <td>Name</td>
            <td>Description</td>
          </tr>
        </thead>
        <tbody  data-bind="foreach:currentPage">
          <tr>
            <td><a data-bind="attr:{href:fcConfig.viewOrganisationUrl+'/'+organisationId}"><span data-bind="text:name"></span></a></td>
            <td data-bind="text:description"></td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td><button data-bind="click:next">Next</button></td>
            <td><button data-bind="click:prev">Prev</button></td>

          </tr>
        </tfoot>

      </table>
    </span>

  </div>


</div>
<r:script>

    $(function () {


        var OrganisationsViewModel = function(organisations) {
            var self = this;
            this.allOrganisations = ko.observableArray(organisations)
            this.pageNum = ko.observable(1)
            this.organisationsPerPage = 10;

            this.totalPages = ko.computed(function() {
                var count = self.allOrganisations().length;
                var pageCount = count / self.organisationsPerPage;
                return count % self.organisationsPerPage > 0 ? pageCount + 1 : pageCount;

            });

            this.currentPage = ko.computed(function() {
                var first = (self.pageNum()-1) * self.organisationsPerPage;
                return self.allOrganisations().slice(first, first+self.organisationsPerPage);
            });

            this.hasPrev = ko.computed(function() {
                return self.pageNum() > 1;
            })

            this.hasNext = ko.computed(function() {
                return self.pageNum() < self.totalPages();
            });

            this.next = function() {
                if (self.hasNext()) {
                    self.pageNum(self.pageNum()+1);
                }
            };
            this.prev = function() {
                if (self.hasPrev()) {
                    self.pageNum(self.pageNum()-1);
                }
            };

            this.addOrganisation = function() {
                window.location = fcConfig.createOrganisationUrl;
            }


        }

        var organisations = <fc:encodeModel model="${organisations}" default="${[]}"/>
        var organisationsViewModel = new OrganisationsViewModel(organisations);

        ko.applyBindings(organisationsViewModel);

});




</r:script>

</body>


</html>