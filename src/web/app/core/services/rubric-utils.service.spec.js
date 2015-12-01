
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
        bard.inject('rubricUtils', '_');
    });

    it('expect rubricUtils.getStudentGrowthProcess/ResultsRubricRow(C3) to return SG 3.1/2', function() {
        var c3 = _.find(TR_StateFramework.frameworkNodes, {shortName: 'C3'});
        expect(rubricUtils.getStudentGrowthProcessRubricRow(c3).shortName).toEqual('SG 3.1');
        expect(rubricUtils.getStudentGrowthResultsRubricRow(c3).shortName).toEqual('SG 3.2');
    });

    it('expect rubricUtils.getStudentGrowthFrameworkNodes to return C3, C6, and C8', function() {
        var nodes = rubricUtils.getStudentGrowthFrameworkNodes(TR_StateFramework.frameworkNodes);
        expect(nodes.length).toEqual(3);
        expect(_.find(nodes, {shortName: 'C3'})).not.toBe(null);
        expect(_.find(nodes, {shortName: 'C6'})).not.toBe(null);
        expect(_.find(nodes, {shortName: 'C8'})).not.toBe(null);
    });

    it('expect rubricUtils.getStudentGrowthRubricRows to return SG 3.1, 3.2, 6.1, 6.2, 8.1', function() {
        var nodes = rubricUtils.getStudentGrowthFrameworkNodes(TR_StateFramework.frameworkNodes);
        var rows = rubricUtils.getStudentGrowthRubricRows(nodes);
        expect(rows.length).toEqual(5);
        expect(_.find(rows, {shortName: 'SG 3.1'})).not.toBe(null);
        expect(_.find(rows, {shortName: 'SG 3.2'})).not.toBe(null);
        expect(_.find(rows, {shortName: 'SG 6.1'})).not.toBe(null);
        expect(_.find(rows, {shortName: 'SG 6.2'})).not.toBe(null);
        expect(_.find(rows, {shortName: 'SG 8.1'})).not.toBe(null);
    });

    it('expect rubricUtils.getStudentGrowthRubricRowsForFrameworkNode to return SG 3.1, 3.2', function() {
        var nodes = rubricUtils.getStudentGrowthFrameworkNodes(TR_StateFramework.frameworkNodes);
        var c3 = _.find(nodes, {shortName: 'C3'});
        var rows = rubricUtils.getStudentGrowthRubricRowsForFrameworkNode(c3);
        expect(rows.length).toEqual(2);
        expect(_.find(rows, {shortName: 'SG 3.1'})).not.toBe(null);
        expect(_.find(rows, {shortName: 'SG 3.2'})).not.toBe(null);
    });

});

