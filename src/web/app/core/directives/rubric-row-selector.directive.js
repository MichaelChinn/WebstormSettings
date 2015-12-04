(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('rubricRowSelector', rubricRowSelectorDirective)
        .controller('rubricRowSelectorController', rubricRowSelectorController);

    rubricRowSelectorDirective.$inject = ['$rootScope', '$q', '$http', '$timeout'];
    rubricRowSelectorController.$inject = ['$scope', 'activeUserContextService', 'frameworkService',
        'config', '_', '$rootScope'];
    function rubricRowSelectorDirective($rootScope, $q, $http, $timeout) {
        return {
            restrict: 'E',
            scope: {
                evaluationType: '=',
                rubricRows: '=',
                doneFcn: '='
            },
            templateUrl: 'app/core/views/rubric-row-selector.html',
            link: function (scope, elm, attrs) {
                scope.$watch('framework', function (newValue, oldValue) {

                });
            },
            controller: 'rubricRowSelectorController as vm'
        }
    }

    function rubricRowSelectorController($scope, activeUserContextService, frameworkService, config, _, $rootScope) {
        var vm = this;

        vm.toggleEditMode = toggleEditMode;
        vm.clear = clear;
        vm.frameworkNodeIsAligned = frameworkNodeIsAligned;
        vm.rubricRowIsAligned = rubricRowIsAligned;
        vm.editMode=true;
        vm.editModeBtnText = 'Done';
        vm.framework = null;
        vm.rubricRows = $scope.rubricRows;
        vm.doneFcn = $scope.doneFcn;
        vm.treeOptions = {
        };

        vm.treeData = {};
        vm.treeDataSource = new kendo.data.HierarchicalDataSource({
            transport: {
                read: function (e) {
                    e.success(vm.treeData);
                    //e.error("XHR response", "status code", "error message");
                }
            }
        });
        $rootScope.$on('change-framework', function () {
            vm.framework = activeUserContextService.getActiveFramework();
            populateTree();
        });

        activate();

        function activate() {
            var districtCode = activeUserContextService.getActiveDistrictCode();
            vm.framework = activeUserContextService.getActiveFramework();
            populateTree();
        }

        function clear() {
            vm.rubricRows = [];
            populateTree();
        }

        function toggleEditMode() {
            vm.editMode=!vm.editMode;
            vm.editModeBtnText = vm.editMode?"Done":"Edit";
            if (vm.editMode) {
                populateTree();
            }
            else if (vm.doneFcn) {
                vm.doneFcn();
            }
        }

        function frameworkNodeIsAligned(fn) {
            if (!vm.rubricRows) {
                return false;
            }
            var aligned = false;
            for (var i=0; i<fn.rubricRows.length; ++i) {
                var exists  = _.find(vm.rubricRows, {id: fn.rubricRows[i].id});
                if (exists) {
                    aligned = true;
                    break;
                }
            }
            return aligned;
        }
        function rubricRowIsAligned(rr) {

            return !vm.rubricRows?false: _.findWhere(vm.rubricRows, {id: rr.id});
        }

        $scope.$watch('rubricRows', function (newValue, oldValue) {
            vm.rubricRows = newValue;
            if (vm.rubricRows) {
                vm.editMode = vm.rubricRows.length===0;
                vm.editModeBtnText = vm.editMode?"Done":"Edit";
                if (vm.editMode && vm.framework) {
                    // todo: this is causing the frameworknode to collapse
                    populateTree();
                }
            }
        });

        function populateTree() {
            if (vm.framework) {
                vm.treeData = vm.framework.frameworkNodes.map(function (fn) {
                    var count = 0;
                    var node = {

                        //goes through each element of the frameworkNodes[]
                        id: fn.id,
                        text: fn.shortName + " " + fn.title,

                        //sets id and creates a name
                        items: fn.rubricRows.map(function (rubRow) {
                            var rubricRow = {
                                id: rubRow.id,
                                text: rubRow.title
                            };
                            //for each element of the rubric row in that frameworkNode
                            //sets id and creates name
                            if (_.findWhere(vm.rubricRows, { id: rubricRow.id })) {
                                rubricRow.isChecked = true;
                                count++;
                            }
                            //checks the boxes of the newly changed view and creates count

                            return rubricRow;
                        })
                    };

                    node.selectedCount = count;
                    //creates aggregate count
                    return node;
                    //replaces the tree data
                });
                vm.treeDataSource.read();
            }
        }

        vm.nodeClicked = function (dataItem, rowClicked) {
            if (rowClicked) {
                dataItem.isChecked = !dataItem.isChecked;
            }
            
            if (!dataItem.parentNode()) {
                return;
            }

            if (!vm.rubricRows) {
                vm.rubricRows = [];
            }

            var alignment = _.findWhere(vm.rubricRows, { id: dataItem.id });

            if (dataItem.isChecked) {
                dataItem.parentNode().selectedCount++;
                if (!alignment) {
                    vm.rubricRows.push({ id: dataItem.id })
                }

            } else {
                dataItem.parentNode().selectedCount--;
                if (alignment) {
                    vm.rubricRows = _.without(vm.rubricRows, alignment);

                }
            }

            $scope.rubricRows = vm.rubricRows;

            window.event.stopPropagation();
        }
    }
})();


