/**
 * Created by anne on 11/6/2015.
 */
(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .directive('artifactEvidenceSummary', artifactEvidenceSummary)
        .controller('artifactEvidenceSummaryController', artifactEvidenceSummaryController);

    artifactEvidenceSummaryController.$inject = ['artifactService', 'activeUserContextService', 'utils', 'enums'];

    function artifactEvidenceSummary() {
        return {
            restrict: 'E',
            scope: {
                artifact: '='
            },
            templateUrl: 'app/artifacts/views/artifact-evidence-summary.directive.html',
            controller: 'artifactEvidenceSummaryController as vm',
            bindToController: true
        }
    }

    function artifactEvidenceSummaryController(artifactService, activeUserContextService, utils, enums) {
        var vm = this;
        vm.enums = enums;

        // from directive scope
        // vm.artifact

        vm.evaluateeTerm = utils.getEvaluateeTermUpperCase(activeUserContextService.context.workArea().evaluationType);
        vm.showSummary = true;
        vm.source = '';

        vm.itemTypeToString = utils.mapLibItemTypeToString;
        vm.itemDisplayName = artifactService.libItemDisplayName;
        vm.viewItem = artifactService.viewItem;
        vm.getSafeHtml = utils.getSafeHtml;

        activate();

        function activate() {

            if (vm.artifact.createdByUserId === activeUserContextService.context.evaluatee.id) {
                vm.source = utils.getEvaluateeTermUpperCase(activeUserContextService.context.framework.evaluationType);
            }
            else {
                vm.source = 'Evaluator';
            }
        }

    }

}) ();
