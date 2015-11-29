/**
 * Created by anne on 7/4/2015.
 */
/* jshint -W117, -W030 */

describe('rubricUtils', function() {

    beforeEach(function() {
        bard.appModule('stateeval.core');
        bard.inject('rubricUtils', '$sce');
    });

    it('expect rubricUtils to exist ', function() {
        expect(rubricUtils).toBeDefined();
    });
});
