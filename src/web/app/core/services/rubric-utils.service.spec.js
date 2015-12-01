
/*describe('rubricUtils', function() {

 var core = {};

 beforeEach(angular.mock.module('stateeval.core'));

 beforeEach(inject(function(_rubricUtils_) {
 rubricUtils = _rubricUtils_;
 }));

 it('rubricUtils should exist', function() {
 expect(rubricUtils).toBeDefined();
 });
 });*/

describe('rubricUtils', function() {

    beforeEach(function() {
        bard.appModule('stateeval.core');
        bard.inject('rubricUtils');
    });

    it('expect rubricUtils to exist ', function() {
        expect(rubricUtils).toBeDefined();
    });
});

