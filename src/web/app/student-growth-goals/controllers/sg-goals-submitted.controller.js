/**
 * goalsController - controller
 */
(function() {
    'use strict';

angular
    .module('stateeval.student-growth-goals')
    .controller('sgGoalsSubmittedController', sgGoalsSubmittedController);

    sgGoalsSubmittedController.$inject = ['studentGrowthBuildService', '$q', '$stateParams', 'activeUserContextService',
        '$state', 'config', 'enums', 'utils', 'rubricUtils', 'studentGrowthAdminService', 'workAreaService'];

/* @ngInject */
function sgGoalsSubmittedController(studentGrowthBuildService, $q, $stateParams, activeUserContextService,
         $state, config, enums, utils, rubricUtils, studentGrowthAdminService, workAreaService) {
    var vm = this;

    vm.submittedBundles = [];

    vm.viewBundle = viewBundle;
      vm.getSafeHtml = utils.getSafeHtml;
    vm.bundleAlignmentWithEval = bundleAlignmentWithEval;

    ////////////////////////////

    activate();

    function activate() {

        vm.isEvalutee = activeUserContextService.context.isEvaluatee();

        vm.evaluationType = activeUserContextService.context.evaluatee.evalData.evalType;

        studentGrowthBuildService.getSubmittedBundlesForEvaluation().then(function(submittedBundles) {
            vm.submittedBundles = submittedBundles;
        });

    }

    function bundleAlignmentWithEval(bundle) {
        var alignmentString = '';
        bundle.alignedRubricRows.forEach(function (rr) {
            if (alignmentString != '') {
                alignmentString += ', ';
            }
            var rrEval = _.findWhere(bundle.rubricRowEvaluations, {rubricRowId: rr.id});
            if (rrEval != undefined) {
                alignmentString += '<span class="badge badge-default">' + rr.shortName + '</span>';
            }
            else {
                alignmentString += rr.shortName;
            }
        });

        return utils.getSafeHtml(alignmentString);
    }

    function viewBundle(bundle) {
        $state.go('sg-bundle-setup', {id:bundle.id});
    }
}

})();