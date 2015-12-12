/**
 * goalsController - controller
 */
(function() {
    'use strict';

angular
    .module('stateeval.student-growth-goals')
    .controller('sgGoalsPrivateController', sgGoalsPrivateController);

    sgGoalsPrivateController.$inject = ['studentGrowthBuildService', '$q', '$stateParams', 'activeUserContextService',
        '$state', 'config', 'enums', 'utils', 'rubricUtils', 'studentGrowthAdminService', 'workAreaService'];

/* @ngInject */
function sgGoalsPrivateController(studentGrowthBuildService, $q, $stateParams, activeUserContextService,
         $state, config, enums, utils, rubricUtils, studentGrowthAdminService, workAreaService) {
    var vm = this;

     vm.settingsSubmitted = false;

    vm.inProgressBundles = [];

    vm.submit = submit;
    vm.editBundle = editBundle;
    vm.deleteBundle = deleteBundle;
    vm.createBundle = createBundle;
    vm.getSafeHtml = utils.getSafeHtml;
    vm.bundleCriteriaAlignmentAsString = bundleCriteriaAlignmentAsString;
    vm.evaluationType = null;

    ////////////////////////////

    activate();

    function activate() {

        vm.evaluationType = activeUserContextService.context.evaluatee.evalData.evalType;

        studentGrowthBuildService.getInProgressBundlesForEvaluation().then(function(bundles) {
            vm.inProgressBundles = bundles;

            studentGrowthAdminService.getSettingsHaveBeenSubmitted(vm.evaluationType)
                .then(function(data) {
                    vm.settingsSubmitted = data;
                })
        });
    }

    function bundleCriteriaAlignmentAsString(bundle) {
        var alignment = "";
        bundle.goals.forEach(function(g) {
            if (alignment !== "") {
                alignment+= " ";
            }
            alignment+= g.frameworkNodeShortName;
        });
        return alignment;
    }

    function deleteBundle(bundle) {
        studentGrowthBuildService.deleteBundleForEvaluation(bundle).then(function () {
            vm.inProgressBundles = _.reject(vm.inProgressBundles, {id: bundle.id});
        });
    }

    function editBundle(bundle) {
        $state.go('sg-bundle-setup', {id:bundle.id});
    }

    function createBundle() {
        var bundle = studentGrowthBuildService.newBundle();
        studentGrowthBuildService.createBundleForEvaluation(bundle).then(function() {
            $state.go('sg-bundle-setup', {id:bundle.id});
        })
    }

    function submit(bundle) {
        studentGrowthBuildService.submitBundleforEvaluation(bundle).then(function () {
            vm.inProgressBundles = _.reject(vm.inProgressBundles, {id: bundle.id});
        });
    }
}

})();