(function () {
    'use strict';

    angular.module('stateeval.core')
        .directive('showRubricRowEvaluations', showRubricRowEvaluations)
        .controller('showRubricRowEvaluationsController', showRubricRowEvaluationsController);

    showRubricRowEvaluationsController.$inject = ['$state', 'activeUserContextService','enums',
        'rubricUtils', 'utils', '_', '$scope'];

    function showRubricRowEvaluations() {
        return {
            restrict: 'E',
            scope: {
                rubricRowEvaluations: '='
            },
            replace: true,
            templateUrl: 'app/core/views/show-rubricrow-evaluations.directive.html',
            controller: 'showRubricRowEvaluationsController as vm',
            bindToController: true
        }
    }
    function showRubricRowEvaluationsController($state, activeUserContextService, enums,
            rubricUtils, utils, _, $scope) {
        var vm = this;
        vm.enums = enums;

        //ROW EVIDENCES OBJECT
        //usedRows = {
        //    rowID:82:,
        //    rowID:84: {
        //        evaluations: [],
        //        performanceLevels: {
        //            BASIC:,
        //            DISTINGUISHED:,
        //            PROFICIENT:,
        //            UNSATISFACTORY: {
        //                mergeHtml:,
        //                evaluations:,
        //                descriptor:
        //            }
        //        }
        //    }
        //}

        vm.context = activeUserContextService.context;
        var usedRows = {};
        var allRows = {};
        vm.frameworkNodes;
        vm.filter = 'Scored Rows';

        vm.change = change;
        vm.getSafeHtml = utils.getSafeHtml;
        vm.enums = enums;

      /*  vm.options2 = {
            start: [30, 90],
            connect: true,
            step: 1,
            range: {
                min: 0,
                max: 100
            }
        };

        vm.eventHandlers = {
            update: function(values, handle, unencoded) {},
            slide: function(values, handle, unencoded) {

                console.log(vm.options2);
                var performanceLevels = vm.usedRows[19];
                for (var p in enums.PerformanceLevels) {
                    var performanceLevel = performanceLevels[enums.PerformanceLevels[p]];
                    var rubricRowEvaluations = performanceLevel['evaluations'];
                    performanceLevel['mergeHtml'] = rubricUtils.mergeEvidenceToHtml(performanceLevel['descriptor'], rubricRowEvaluations);
                }

            },
            set: function(values, handle, unencoded) {},
            change: function(values, handle, unencoded) {}
        }*/

        activate();

        function activate() {
            loadData();

            $scope.$watch('vm.rubricRowEvaluations', function (newValue, oldValue) {
                vm.rubricRowEvaluations = newValue;
                loadData();
            });

        }

        function loadData() {
            var context = activeUserContextService.context;
            var evaluationsById = _.groupBy(vm.rubricRowEvaluations, 'rubricRowId');
            var evaluationsByLinkItemType = _.groupBy(vm.rubricRowEvaluations, 'linkedItemType');
            var artifactEvaluationsById = _.groupBy(evaluationsByLinkItemType[enums.LinkedItemType.ARTIFACT], 'rubricRowId');
            var observationEvaluationsById = _.groupBy(evaluationsByLinkItemType[enums.LinkedItemType.OBSERVATION], 'rubricRowId');
            var sgGoalsEvaluationsById = _.groupBy(evaluationsByLinkItemType[enums.LinkedItemType.STUDENT_GROWTH_GOAL], 'rubricRowId');
            usedRows = {};
            allRows = {};

            var i, o, p;
            for (i in context.framework.frameworkNodes) {//Creates flat list of Rubric Rows
                var rowObject = _.groupBy(context.framework.frameworkNodes[i].rubricRows, 'id');
                for (o in rowObject) {
                    var evalsForRow = evaluationsById[o];
                    usedRows[o] = rowObject[o][0];
                    allRows[o] = rowObject[o][0];
                    var evaluationsByPLByRow = _.groupBy(evaluationsById[o], 'performanceLevel');

                    usedRows[o].evaluations = {};
                    var artifactEvaluations = artifactEvaluationsById[o];
                    artifactEvaluations = _.sortBy(artifactEvaluations, 'linkedArtifactBundleId');
                    if (artifactEvaluations.length>0) {
                        usedRows[o].evaluations['Artifacts'] = artifactEvaluations;
                    }

                    var observationEvaluations = observationEvaluationsById[o];
                    observationEvaluations = _.sortBy(observationEvaluations, 'linkedObservationId');
                    if (observationEvaluations.length>0) {
                        usedRows[o].evaluations['Observations'] = observationEvaluations;
                    }

                    var sgGoalsEvaluations = sgGoalsEvaluationsById[o];
                    sgGoalsEvaluations = _.sortBy(sgGoalsEvaluations, 'linkedStudentGrowthGoalBundleId');
                    if (sgGoalsEvaluations.length>0) {
                        usedRows[o].evaluations['Student Growth Goals'] = sgGoalsEvaluations;
                    }

                    usedRows[o].performanceLevels = {};
                    for (p in enums.PerformanceLevels) {
                        var performanceLevel = {};
                        performanceLevel['evaluations'] = evaluationsByPLByRow[((p - 1) + 2)];
                        performanceLevel['descriptor'] = usedRows[o][enums.PLAccessor[enums.PerformanceLevels[p]]];
                        performanceLevel['mergeHtml'] = rubricUtils.mergeEvidenceToHtml(performanceLevel['descriptor'], performanceLevel['evaluations']);
                        usedRows[o].performanceLevels[enums.PerformanceLevels[p]] = performanceLevel;
                    }

                    if (!evalsForRow) {
                        delete usedRows[o];
                    }
                }
            }

            vm.listOfRowIds = Object.keys(usedRows);
            vm.rowCount = vm.listOfRowIds.length;
            var frameworkNodes = _.groupBy(context.framework.frameworkNodes, 'shortName');
            for(var i in frameworkNodes){
                frameworkNodes[i] = frameworkNodes[i][0];
                var rows = _.groupBy(frameworkNodes[i].rubricRows, 'id');
                for(var j in rows) {
                    rows[j] = rows[j][0];
                }
                frameworkNodes[i].rowsById = rows;
            }

            vm.allRows = allRows;
            vm.usedRows = usedRows;
            vm.evaluationsById = evaluationsById;
            vm.context = context;
            vm.frameworkNodes = frameworkNodes;
        }


        function change() {
            var rows;
            if (vm.filter === 'Scored Rows') {
               rows = usedRows;
            } else if (vm.filter === 'All') {
                rows = allRows;
            } else if (vm.frameworkNodes[vm.filter]) {
               rows = vm.frameworkNodes[vm.filter].rowsById;
            } else {
                rows = {};
                rows[vm.filter] = allRows[vm.filter]
            }
            vm.listOfRowIds = Object.keys(rows);
        }

    }
})();