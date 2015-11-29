(function () {
    'use strict';

    angular.module('stateeval.core')
        .directive('evidenceCollection', evidenceCollectionDirective)
        .controller('evidenceCollectionController', evidenceCollectionController);

    evidenceCollectionDirective.$inject = [];
    function evidenceCollectionDirective() {
        return {
            restrict: 'E',
            scope: {
                evidenceCollection: '=',
                defaults: '='
            },
            templateUrl: 'app/core/views/evidence-collection.directive.html',
            controller: 'evidenceCollectionController as vm',
            bindToController: true
        }
    }

    evidenceCollectionController.$inject = ['utils', 'enums', 'evidenceCollectionService', '$scope',
        'activeUserContextService', '$rootScope'];
    function evidenceCollectionController(utils, enums, evidenceCollectionService, $scope,
                                          activeUserContextService, $rootScope) {
        var vm = this;
        vm.toggle = [];
        vm.evidenceCollectionService = evidenceCollectionService;
        console.log('Evidence Collection Directive');
        vm.defaults = vm.defaults || {};
        var name = activeUserContextService.context.framework.name;
        vm.node = vm.defaults.node || vm.evidenceCollection.tree[name][vm.evidenceCollection.tree[name].nodes[0]];
        vm.row = vm.defaults.row || vm.node[vm.node.rows[0]];

        $rootScope.$on('change-framework', function () {
            var name = activeUserContextService.context.framework.name;
            vm.node = vm.evidenceCollection.tree[name][vm.evidenceCollection.tree[name].nodes[0]];
            vm.row = vm.node[vm.node.rows[0]];
        });


    }
})();
