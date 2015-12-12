(function () {
    'use strict';

    angular.module('stateeval.district-admin')
        .directive('coverageSingle', coverageSingleDirective)
        .controller('coverageSingleController', coverageSingleController);

    coverageSingleDirective.$inject = [];
    function coverageSingleDirective() {
        return {
            restrict: 'E',
            scope: {
                evaluatee: '='
            },
            templateUrl: 'app/district-admin/views/coverage-single.html',
            controller: 'coverageSingleController as vm',
            bindToController: true


        }
    }

    coverageSingleController.$inject = ['activeUserContextService', 'rubricRowEvaluationService', 'rubricUtils',
        'enums', '$scope', '$q', 'evaluationService', '$rootScope', 'evidenceCollectionService'];

    function coverageSingleController(activeUserContextService, rubricRowEvaluationsService, rubricUtils,
          enums, $scope, $q, evaluationService, $rootScope, evidenceCollectionService) {

        var vm = this;

        vm.context = null;
        vm.rowMapper = null;
        vm.nodeNumbers = null;
        vm.linkedItemTypeMapper = null;

        activate();

        function activate() {

            $rootScope.$on('change-framework', function () {
                load();
            });

            load();
        }

        function load() {
            return evidenceCollectionService.getEvidenceCollection("SUMMATIVE", enums.EvidenceCollectionType.SUMMATIVE)
                .then(function (evidenceCollection) {
                    vm.evidenceCollection = evidenceCollection;

                    // evidenceCollection.associatedCollections['observations'] = array of observations
                    // evidenceCollection.associatedCollections['studentGrowthGoalBundles'] = array of bundles
                    // evidenceCollection.associatedCollections[linkedItemType][linkedItemId]: object

                    for (var frameworkNode in activeUserContextService.getActiveFramework().frameworkNodes) {
                        var node = evidenceCollection.getNode(frameworkNode.shortName);
                        for (var row in node.rows) {

                        }
                    }

                })
        }

        function loadOld() {
            vm.context = activeUserContextService.context;
            var nodeMapper = rubricUtils.getFrameworkMapper(vm.context.framework);
            vm.rowMapper = rubricUtils.getRowMapper(vm.context.framework);
            vm.nodeNumbers = rubricUtils.getNodeNumbers(vm.context.framework);
            vm.itemTypeMapper = enums.itemTypeMapper;
            var sources, evaluationsByType;
            evaluationService.getAllEvaluationsFORNOW()
                .then(function (list) {
                    sources = list;
                    return rubricRowEvaluationsService.getRubricRowEvaluationsForEvaluation();
                })
                .then(function (data) {
                    evaluationsByType = _.groupBy(data, 'linkedItemType');
                })
                .then(function () {
                    console.log(sources, evaluationsByType);
                    for (var i in sources) {
                        sources[i].nodes = [];
                        var currentEvals = evaluationsByType[sources[i].linkedItemType];
                        var evaluatedByRowId = [];
                        for (var j in currentEvals) {
                            //todo needs a different more generic field thant linkedArtifactBundleId
                            if (currentEvals[j].linkedArtifactBundleId === sources[i].id) {
                                evaluatedByRowId[currentEvals[j].rubricRowId] = currentEvals[j];
                            }
                        }
                        for (var j in sources[i].alignedRubricRows) {
                            if (sources[i].nodes[nodeMapper[sources[i].alignedRubricRows[j].id]]) {
                                sources[i].nodes[nodeMapper[sources[i].alignedRubricRows[j].id]].push(sources[i].alignedRubricRows[j]);
                            } else {
                                sources[i].nodes[nodeMapper[sources[i].alignedRubricRows[j].id]] = [sources[i].alignedRubricRows[j]];
                            }
                        }
                        sources[i].evaluated = evaluatedByRowId;
                    }
                    console.log(sources);
                    vm.sources = sources;

                    var filledNodes = [];
                    var list = [];
                    for(var i in vm.context.framework.frameworkNodes){
                        for(var j in vm.context.framework.frameworkNodes[i].rubricRows) {
                            list[vm.context.framework.frameworkNodes[i].rubricRows[j].id] = false;
                        }
                        filledNodes[vm.context.framework.frameworkNodes[i].shortName] = true;
                    }
                    for(var k in evaluationsByType) {
                        for (var l in evaluationsByType[k]){
                            list[evaluationsByType[k][l].rubricRowId] = true;
                        }
                    }
                    for(var i in list){
                        if(list[i] === false) {
                            filledNodes[nodeMapper[i]] = false;
                        }
                    }
                    vm.filledNodes = filledNodes;
                });
        }
    }
})();
