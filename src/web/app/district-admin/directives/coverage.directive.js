(function () {
    'use strict';

    angular.module('stateeval.district-admin')
        .directive('coverage', coverageDirective)
        .controller('coverageController', coverageController);

    coverageDirective.$inject = [];
    function coverageDirective() {
        return {
            restrict: 'E',
            scope: {
              chooseSingle: '='
            },
            templateUrl: 'app/district-admin/views/coverage.html',
            controller: 'coverageController as vm',
            bindToController: true


        }
    }

    coverageController.$inject = ['activeUserContextService', 'rubricRowEvaluationService', 'rubricUtils', '$rootScope', '$scope'];
    function coverageController(activeUserContextService, rubricRowEvaluationService, rubricUtils, $rootScope, $scope) {
        var vm = this;
        vm.context = activeUserContextService.context;
        vm.people = [];
        vm.rubricRowEvaluations = [];

        $scope.$watch('vm.chooseSingle', function (newValue) {
            vm.chooseSingle = newValue;
            activate();
        });


        function activate() {

            rubricRowEvaluationService.getRubricRowEvaluationsForPR_TR(vm.context.evaluator)
                .then(function (data) {
                    vm.rubricRowEvaluations = data;
                    load();
                });

            $rootScope.$on('change-framework', function () {
                load();
            });
        }

        function load() {

            var nodeMapper = rubricUtils.getFrameworkMapper(vm.context.framework);
            vm.rowMapper = rubricUtils.getRowMapper(vm.context.framework);

            vm.rubricRowEvaluations.forEach(function (rrEval) {
                rrEval.fnShortName = nodeMapper[rrEval.rubricRowId];
            });

            var evaluations = vm.rubricRowEvaluations;
            var evaluationIdsObj = [];
            evaluations = _.groupBy(evaluations, 'evaluationId');

            vm.allRowsInNode = _.groupBy(vm.context.framework.frameworkNodes, 'shortName');
            for (var fn in vm.allRowsInNode) {
                var fnode = vm.allRowsInNode[fn][0];
                vm.allRowsInNode[fn] = fnode.rrIds;
            }

            var people = [];
            for (var i in vm.context.evaluatees) {
                var evalId = vm.context.evaluatees[i].evalData.id;
                var evalsForTee = evaluations[vm.context.evaluatees[i].evalData.id];
                var rowsInNode = _.groupBy(evalsForTee, 'fnShortName');
                var nodeData = [];

                var done = true;
                for (var fn in vm.allRowsInNode) {
                    var rrIds = _.uniq(_.pluck(rowsInNode[fn], 'rubricRowId'));
                    var whatsLeft = _.difference(vm.allRowsInNode[fn], rrIds);
                    var whatsLeftShortNames = _.map(whatsLeft, function(rrId) { return vm.rowMapper[rrId];}).join(', ');
                    if (whatsLeft.length > 0) {
                        done = false;
                    }
                    nodeData.push({
                        rrIds: rrIds,
                        whatsLeftShortNames: whatsLeftShortNames,
                        done: whatsLeft.length === 0
                    });
                }
                people.push({
                    name: vm.context.evaluatees[i].displayName,
                    id: vm.context.evaluatees[i].id,
                    evaluations: evaluationIdsObj[evalId],
                    rowsInNode: rowsInNode,
                    nodeData: nodeData,
                    done: done
                })
            }
            vm.people = people;
        }
    }
})();
