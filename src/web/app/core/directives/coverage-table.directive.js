/**
 * Created by anne on 11/8/2015.
 */

(function () {
    'use strict';

    angular.module('stateeval.core')
        .directive('coverageTable', coverageTable)
        .controller('coverageTableController', coverageTableController);

    coverageTableController.$inject = ['activeUserContextService', 'rubricUtils', 'enums', 'utils',
        'config', '_', '$rootScope', '$scope', '$state'];


    function coverageTable() {
        return {
            restrict: 'E',
            scope: {
                items: '='
            },
            templateUrl: 'app/core/views/coverage-table.directive.html',
            controller: 'coverageTableController as vm',
            bindToController: true
        }
    }

    function coverageTableController(activeUserContextService, rubricUtils, enums, utils,
          config, _, $rootScope, $scope, $state) {

        var vm = this;

        var context = activeUserContextService.context;

        vm.enums = enums;
        vm.rowMapper = null;
        vm.isEvaluatee = false;
        vm.nodes = [];

        vm.viewItem = viewItem;

        ////////////////////////////////

        activate();

        function activate() {
            vm.isEvaluatee = activeUserContextService.user.id === activeUserContextService.context.evaluatee.id;

            $scope.$watch('vm.items', function (newValue, oldValue) {
                vm.items = newValue;
                if (vm.items) {
                    load();
                }
            });

            $rootScope.$on('change-framework', function () {
                load();
            });
        }

        function load() {

            var framework = activeUserContextService.context.framework;
            vm.rowMapper = rubricUtils.getRowMapper(framework);
            var nodeMapper = rubricUtils.getFrameworkMapper(framework);

            vm.nodes = [];

            framework.frameworkNodes.forEach(function(fn) {
                var node = {
                    id: fn.id,
                    shortName: fn.shortName,
                    allRowsString: '',
                    done: true
                };
                vm.nodes.push(node);
                node.rows = [];
                fn.rubricRows.forEach(function(rr) {
                    var row = {
                        id: rr.id,
                        shortName: rr.shortName,
                        done: false
                    };

                    node.rows.push(row);
                });
                node.allRowsString = _.pluck(node.rows, 'shortName').join(', ');

            });

            vm.items.forEach(function(item) {
                item.nodes = [];

                framework.frameworkNodes.forEach(function(fn) {
                    var node = {
                        id: fn.id,
                        shortName: fn.shortName
                    };
                    item.nodes.push(node);
                    node.rows = [];

                    item.alignedRubricRows.forEach(function(rr) {
                        if (nodeMapper[rr.id] === node.shortName) {

                            var row = {
                                id: rr.id,
                                shortName: rr.shortName,
                                isEvaluated: _.find(item.rubricRowEvaluations, {rubricRowId: rr.id})!==undefined
                            };

                            if (row.isEvaluated) {
                                _.find(_.find(vm.nodes, {id: node.id}).rows, {id: rr.id}).done = true;
                            }

                            node.rows.push(row);
                        }
                    })
                });
            });

            vm.nodes.forEach(function(node) {
                node.rows.forEach(function(row) {
                    if (!row.done) {
                        node.done = false;
                    }
                })
            });
        }

        function viewItem(item) {
          /* todo: how to tell different objects apart
           if (itemIsAnArtifact(item)) {
                $state.go('submitted-artifact-summary', {artifactId: item.id});
            }
            */
        }
    }
}) ();

