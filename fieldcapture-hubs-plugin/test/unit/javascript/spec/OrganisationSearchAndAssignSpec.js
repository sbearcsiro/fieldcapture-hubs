describe("OrganisationSelectionViewModel Spec", function () {

    var organisations = [
        { name:'Org 1'},
        { name:'Org 2'},
        { name:'Org 3'},
        { name:'Org 4'},
        { name:'Org 5'},
        { name:'Org 6'},
        { name:'Org 7'}
    ];

    var userOrgs = [
        {name:'My org 1'},
        {name:'My org 2'}
    ];

    it("should update search results from both lists when a term is supplied", function () {

        var searchableList = new OrganisationSelectionViewModel(organisations, userOrgs);
        searchableList.term('1');

        expect(searchableList.otherResults()).toEqual([{name:'Org 1'}]);
        expect(searchableList.userOrganisationResults()).toEqual([{name:'My org 1'}]);

        searchableList.term('Org');
        expect(searchableList.otherResults()).toEqual(organisations);
        expect(searchableList.userOrganisationResults()).toEqual(userOrgs);

        searchableList.term('Org 3');
        expect(searchableList.otherResults()[0]).toEqual({name:'Org 3'});
        expect(searchableList.userOrganisationResults()[0]).toEqual({name:'My org 1'});


    });

    it("should return all results when no term is supplied", function() {

        var searchableList = new OrganisationSelectionViewModel(organisations, userOrgs);
        expect(searchableList.otherResults()).toEqual(organisations);
        expect(searchableList.userOrganisationResults()).toEqual(userOrgs);

        searchableList.term('1');
        searchableList.term('');
        expect(searchableList.otherResults()).toEqual(organisations);
        expect(searchableList.userOrganisationResults()).toEqual(userOrgs);

    });

    it("should maintain a selection based on the supplied search keys", function() {
        var searchableList = new OrganisationSelectionViewModel(organisations, userOrgs);
        searchableList.select({name:'Org 5'});

        expect(searchableList.isSelected({name:'Org 5'})).toBe(true);
        expect(searchableList.isSelected({name:'Org 1'})).toBe(false);

        expect(searchableList.term()).toBe('Org 5');
    });

    it("should allow the term and results to be reset", function() {
        var searchableList = new OrganisationSelectionViewModel(organisations, userOrgs);
        searchableList.term('5');

        searchableList.clearSelection();
        expect(searchableList.term()).toBe('');

        expect(searchableList.otherResults()).toEqual(organisations);
        expect(searchableList.userOrganisationResults()).toEqual(userOrgs);

        searchableList.select({name:'Org 5'});

        searchableList.clearSelection();
        expect(searchableList.term()).toBe('');

        expect(searchableList.otherResults()).toEqual(organisations);
        expect(searchableList.userOrganisationResults()).toEqual(userOrgs);

    });

    it("should set the all viewed flag when the number of visible rows is less than 4", function() {
        var searchableList = new OrganisationSelectionViewModel(organisations, userOrgs);
        searchableList.term('5');

        expect(searchableList.allViewed()).toBe(true);
    });

});
