describe("ProjectViewModel Spec", function () {

    it("should be able to be initialised from an object literal", function () {

        var projectData = {
            name:'Name',
            description:'Description'
        };
        var organisations = [];
        var isEditor = true;
        var project = new ProjectViewModel(projectData, isEditor, organisations);

        expect(project.name()).toEqual(projectData.name);
        expect(project.description()).toEqual(projectData.description);
    });


});
