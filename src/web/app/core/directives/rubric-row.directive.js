(function () {
    'use strict';

    angular.module('stateeval.core')
        .directive('rubricRow', rubricRowDirective)
        .controller('rubricRowController', rubricRowController);

    rubricRowDirective.$inject = ['$parse', 'rubricUtils'];
    function rubricRowDirective($parse, rubricUtils) {
        return {
            restrict: 'E',
            scope: {
                row: '=',
                toggle: '=',
                selected: '='
            },
            templateUrl: 'app/core/views/rubric-row.directive.html',
            controller: 'rubricRowController as vm',
            bindToController: true
        }
    }

    rubricRowController.$inject = ['utils', 'enums', 'evidenceCollectionService', '$scope'];
    function rubricRowController(utils, enums, evidenceCollectionService, $scope) {
        var vm = this;
        $scope.name = 'RUBRIC ROW';
        vm.enums = enums;
        vm.active = 'rr_score_active_btn';
        vm.btnSize = 'btn-xs';
        vm.getSafeHtml = utils.getSafeHtml;
        vm.evidenceCollectionService = evidenceCollectionService;
        vm.root = vm.row.root;
        vm.score = vm.row.score;
        vm.mouseUp = evidenceCollectionService.state.functionality ? mouseUp : function () {};
        vm.show = show;
        console.log('Rubric Row Directive');

        function show(id) {
            vm.toggle[id] = !vm.toggle[id];
        }

        function mouseUp(row, level) {
            var list = [];
            for(var i in vm.selected) {
                list.push(evidenceCollectionService.newAlignedEvidence(vm.selected[i]));
            }
            return vm.row.root.addNewEvaluation(level, utils.getSelectedText(), list, row);
        }

        //todo mouseup fires when clicks end on PLS
    }
})();
