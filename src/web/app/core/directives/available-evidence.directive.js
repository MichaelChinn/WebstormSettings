(function () {
'use strict';

    angular.module('stateeval.core')
    .directive('availableEvidence', availableEvidenceDirective)
    .controller('availableEvidenceController', availableEvidenceController);

    availableEvidenceDirective.$inject = [];
    function availableEvidenceDirective() {
        return {
            restrict: 'E',
            scope: {
                row: '=',
                selected: '='
            },
            templateUrl: 'app/core/views/available-evidence.directive.html',
            controller: 'availableEvidenceController as vm',
            bindToController: true


        }
    }

    availableEvidenceController.$inject = ['utils', 'enums', '$scope', 'evidenceCollectionService'];
    function availableEvidenceController(utils, enums, $scope, evidenceCollectionService) {
        var vm = this;
        console.log('Available Evidence');
        vm.getSafeHtml = utils.getSafeHtml;
        vm.evidenceCollectionService = evidenceCollectionService;
        vm.enums = enums;
        vm.check = check;
        function check(select) {
            select.state = !select.state;
            var index = vm.selected.indexOf(select.evidence);
            if(~index) {
                vm.selected.splice(index, 1);
            } else {
                vm.selected.push(select.evidence);
            }
        }
    }
}) ();
