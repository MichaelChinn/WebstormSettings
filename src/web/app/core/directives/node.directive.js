(function () {
    'use strict';

    angular.module('stateeval.core')
        .directive('node', nodeDirective)
        .controller('nodeController', nodeController);

    nodeDirective.$inject = ['evidenceCollectionService'];
    function nodeDirective(evidenceCollectionService) {
        return {
            restrict: 'E',
            replace: true,
            scope: {
                node: '='
            },
            templateUrl: 'app/core/views/node.html',
            controller: 'nodeController as vm',
            bindToController: true
        }
    }

    nodeController.$inject = ['enums', 'evidenceCollectionService', '$scope'];
    function nodeController(enums, evidenceCollectionService, $scope) {
        var vm = this;
        vm.enums = enums;
        vm.evidenceCollectionService = evidenceCollectionService;
        console.log('Node Directive');
        vm.active = 'framework_node_score_active_btn';
        vm.btnSize = 'btn-sm';
        vm.root = vm.node.root;
        $scope.$watch('vm.node', function (newVal) {
            vm.score = vm.node.score;
        });
    }
})();
