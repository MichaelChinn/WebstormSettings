(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('rubricHelper', rubricHelperDirective)
        .controller('rubricHelperController', rubricHelperController);

    rubricHelperDirective.$inject = ['$rootScope', '$q', '$http', '$timeout'];
    rubricHelperController.$inject = ['$scope', 'activeUserContextService', 'userPromptService',
        'config', '_', '$rootScope', '$stateParams', 'evidenceCollectionService'];
    function rubricHelperDirective($rootScope, $q, $http, $timeout) {
        return {
            restrict: 'E',
            scope: {
                userPrompts: '='
            },
            templateUrl: 'app/core/views/rubric-helper.html',
            link: function (scope, elm, attrs) {
                scope.$watch('framework', function (newValue, oldValue) {

                });
            },
            controller: 'rubricHelperController as vm'
        }
    }

    function rubricHelperController($scope, activeUserContextService, userPromptService, config, _, $rootScope, $stateParams, evidenceCollectionService) {
        var vm = this;
        vm.rubricRowClicked = rubricRowClicked;
        vm.frameworkNodeClicked = frameworkNodeClicked;

        activate();

        function activate() {
            var evalSessionId = $stateParams.evalSessionId;
            //alert(evalSessionId);

            vm.framework = activeUserContextService.getActiveFramework();
            if ($stateParams.rubricRowId) {
                var selectedRubricRowId = parseInt($stateParams.rubricRowId);

                if (vm.framework && vm.framework.frameworkNodes.length > 0) {
                    for (var i in vm.framework.frameworkNodes) {
                        var node = vm.framework.frameworkNodes[i];
                        if (_.findIndex(node.rubricRows, {id: selectedRubricRowId}) >= 0) {
                            vm.highlightNode = node;
                            return;
                        }
                    }
                }
            }
        }

        $rootScope.$on('change-framework', function () {
            setupFrameworkContext();
        });

        function setupFrameworkContext() {
            if (activeUserContextService.getActiveFramework() != null) {
                vm.framework = activeUserContextService.getActiveFramework();
            }
        }

        function rubricRowClicked(rubricRow, frameworkNode) {
            rubricRow.frameworkNodeShortName = frameworkNode.shortName;

            if ($scope.$parent.vm.rubricRowClicked) {
                $scope.$parent.vm.rubricRowClicked(frameworkNode, rubricRow);
            }
            evidenceCollectionService.state.view = "row";
            $scope.$parent.vm.row = $scope.$parent.vm.evidenceCollection.rubric[rubricRow.id];

        }

        function frameworkNodeClicked(frameworkNode) {
            if ($scope.$parent.vm.frameworkNodeClicked) {
                $scope.$parent.vm.frameworkNodeClicked(frameworkNode);
            }
            evidenceCollectionService.state.view = "node";
            $scope.$parent.vm.node = $scope.$parent.vm.evidenceCollection.getNode(frameworkNode.shortName);
        }

    }
})();


