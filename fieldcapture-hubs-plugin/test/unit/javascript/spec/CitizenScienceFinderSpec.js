describe("Citizen Science Project Finder Spec", function () {
    beforeAll(function() {
        window.fcConfig = {
            imageLocation:'/'
        }
    });
    afterAll(function() {
        delete window.fcConfig;
    });

    it("should be able to be initialised from an object literal", function () {
        var projectData = [
          'pid',
          'aim',
          'coverage',
          10, // daysRemaining
          10, // daysSince
          20, // daysTotal
          'Easy', // difficulty
          false, // hasTeachingMaterials
          true, // isDIY
          false, // isEditable
          false, // isExternal
          true, // isNoCost
          true, // isSuitableForChildren
          [], // links
          'name',
          'orgid',
          'orgname',
          'active',
          null, // urlImage
          null // urlWeb
        ];
        var project = new CreateCitizenScienceFinderProjectViewModel(projectData);

        expect(project.aim()).toEqual(projectData[1]);
        expect(project.transients.daysRemaining()).toEqual(projectData[3]);
        expect(project.since()).toEqual(projectData[4] + " days ago");
        expect(project.transients.daysTotal()).toEqual(projectData[5]);
        expect(project.difficulty()).toEqual(projectData[6]);
        expect(project.hasTeachingMaterials()).toEqual(projectData[7]);
        expect(project.isDIY()).toEqual(projectData[8]);
        expect(project.isExternal()).toEqual(projectData[10]);
        expect(project.hasParticipantCost()).toEqual(!projectData[11]);
        expect(project.isSuitableForChildren()).toEqual(projectData[12]);
        expect(project.name()).toEqual(projectData[14]);
        expect(project.organisationId()).toEqual(projectData[15]);
        expect(project.organisationName()).toEqual(projectData[16]);
        expect(project.status()).toEqual(projectData[17]);
    });
});
