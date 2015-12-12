(function () {
    'use strict';
    angular.module('stateeval.prompt')
        .directive('frameworkTree', frameworkTreeDirective)
        .controller('frameWorkTreeController', frameWorkTreeController);

    frameworkTreeDirective.$inject = ['$rootScope', '$q', '$http', '$timeout'];
    frameWorkTreeController.$inject = ['$scope'];
    function frameworkTreeDirective($rootScope, $q, $http, $timeout) {
        return {
            restrict: 'E',
            scope: {
                framework: '=',
                rubricRows: '='
            },
            templateUrl: 'app/prompt/views/framework-tree.html',
            link: function (scope, elm, attrs) {
                scope.$watch('framework', function (newValue, oldValue) {

                });
            },
            controller: 'frameWorkTreeController as vm'
        }
    }

    function frameWorkTreeController($scope) {
        var vm = this;
        vm.framewrok = $scope.framework;
        vm.rubricRows = $scope.rubricRows;
        vm.treeDataSource = {};
        vm.treeOptions = {
        }

        $scope.$watch('rubricRows', function (newValue, oldValue) {
            vm.rubricRows = newValue;
        });

        $scope.$watch('framework', function (newValue, oldValue) {
            vm.framewrok = newValue;
            if (newValue) {
                vm.treeData = newValue.frameworkNodes.map(function (fn) {
                    var count = 0;
                    var node = {
                        id: fn.id,
                        text: fn.shortName + " " + fn.title,

                        items: fn.rubricRows.map(function (rubRow) {
                            var rubricRow = {
                                id: rubRow.id,
                                text: rubRow.title
                            };

                            if (_.findWhere(vm.rubricRows, { id: rubricRow.id })) {
                                rubricRow.isChecked = true;
                                count++;
                            }

                            return rubricRow;
                        })
                    };

                    node.selectedCount = count;
                    return node;
                });

                vm.treeDataSource = new kendo.data.HierarchicalDataSource({
                    data: vm.treeData
                });
            }

            console.log(vm.framework);
        });

        vm.nodeClicked = function (dataItem) {
            if (!vm.rubricRows) {
                vm.rubricRows = [];
            }

            var alignment = _.findWhere(vm.rubricRows, { id: dataItem.id });

            if (dataItem.isChecked) {
                dataItem.parentNode().selectedCount++;
                if (!alignment) {
                    vm.rubricRows.push({ Id: dataItem.id });
                }

            } else {
                dataItem.parentNode().selectedCount--;
                if (alignment) {
                    vm.rubricRows = _.without(vm.rubricRows, alignment);

                }
            }

            $scope.rubricRows = vm.rubricRows;
        }
    }
})();


