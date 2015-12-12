(function () {
    'use strict';

    angular
        .module('stateeval.layout')
        .controller('evaluateeDashboardController', evaluateeDashboardController);

    evaluateeDashboardController.$inject = ['activeUserContextService', 'utils', '$rootScope', '$sce',
        'artifactService', 'rubricUtils', 'rubricRowEvaluationService', 'enums', 'artifacts', '$state', '$scope'];

    /* @ngInject */
    function evaluateeDashboardController(activeUserContextService, utils, $rootScope, $sce,
                                          artifactService, rubricUtils, rubricRowEvaluationService, enums,
                                          artifacts, $state, $scope) {
        var vm = this;

        console.log(artifacts);
        vm.buttonGroup = {
            'Notifications': 'evaluatee-notifications',
            'Recently Worked On': 'evaluatee-recently-worked-on',
            'General Info': 'evaluatee-general-info',
            'Framework Evidence View': 'evaluatee-framework-evidence-view'
        };
        vm.keys = Object.keys(vm.buttonGroup);


        vm.evaluatee = null;
        vm.evaluateeTitle = '';
        vm.planType = '';
        vm.focus = '';
        vm.position = '';
        vm.district = 'TODO';
        vm.schools = 'TODO';
        vm.evaluator = '';
        vm.framework = null;
        vm.rubricFilter = '1a';

        vm.evalSessions = [];
        vm.artifacts = [];
        vm.rubricRowEvaluations = [];
        vm.rubricRowEvaluationsByRubricRow = [];
        vm.fnComplete = [];
        vm.html = '<p> Hello World </p>';

        vm.evaluateePlanType = evaluateePlanType;
        vm.evaluateeFocus = evaluateeFocus;
        vm.rrEvalObjectTitle = rrEvalObjectTitle;
        vm.rrEvalObjectType = rrEvalObjectType;
        vm.getSafeHtml = utils.getSafeHtml;
        vm.getFrameworkTree = getFrameworkTree;
        vm.showFrameworkNode = showFrameworkNode;
        vm.showRubricRow = showRubricRow;
        vm.mapPerformanceLevelToString = rubricUtils.mapPerformanceLevelToShortDisplayString;
        vm.getArtifactAlignmentString = getArtifactAlignmentString;
        vm.getRubricDescriptors = getRubricDescriptors;
        vm.rubricRowEvaluations = [];
        vm.rubricDescriptors = null;
        vm.descriptorText = null;
        vm.currentTab = null;

        vm.evaluatorDisplayName = activeUserContextService.getEvaluatorDisplayName;

        ////////////////////////////


        $rootScope.$on('change-framework', function () {
            vm.framework = activeUserContextService.getActiveFramework();
        });

        activate();

        function activate() {
            vm.evaluateeTitle = activeUserContextService.getEvaluateeTermUpperCase();
            vm.framework = activeUserContextService.getActiveFramework();
            vm.evaluatee = activeUserContextService.context.evaluatee;
            if (vm.evaluatee.evalData.planType === 2) {
                //todo plan type fix!?
                vm.focus = evaluateeFocus();
            }
            vm.planType = evaluateePlanType();
            vm.position = activeUserContextService.getRolesDisplayStringForActiveUser();

            var request = artifactService.newArtifactBundleRequest(enums.WfState.ARTIFACT_SUBMITTED,
                activeUserContextService.user.id);

            artifactService.getArtifactBundlesForEvaluation(request).then(function (artifacts) {
                vm.artifacts = artifacts;
                vm.artifacts.forEach(function (artifact) {
                    Array.prototype.push.apply(vm.rubricRowEvaluations, artifact.rubricRowEvaluations);
                    vm.rubricRowEvaluationsByRubricRow = _.groupBy(vm.rubricRowEvaluations, 'rubricRowId');
                    setFnComplete();
                    setRubricDescriptorText();
                });
            });

            $scope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams) {
                vm.currentTab = toState.data.selectedTab;
            });

            /*        rubricRowEvaluationService.getRubricRowEvaluationsForEvaluation(vm.evaluatee.evalData.id)
             .then(function(rubricRowEvaluations) {
             vm.rubricRowEvaluations = rubricRowEvaluations;
             vm.rubricRowEvaluationsByRubricRow = _.groupBy(vm.rubricRowEvaluations, 'rubricRowId');
             });*/
        }


        function getRubricDescriptors(rr) {
            var rubricRowEvals = vm.rubricRowEvaluationsByRubricRow[rr.id];

            for (var i = 0; i < 4; ++i) {
                var performanceLevel = i + 1;
                rubricDescriptors[i].descriptorText =
                    rubricUtils.generateHighlightedRubricDescriptorTextFromEvaluations(
                        performanceLevel,
                        rubricUtils.getRubricDescriptorText(rr, performanceLevel),
                        rubricRowEvals);
            }

            return rubricDescriptors;
        }

        function descriptorText(rr, performanceLevel) {
            var rubricRowEvals = vm.rubricRowEvaluationsByRubricRow[rr.id];

            return rubricUtils.generateHighlightedRubricDescriptorTextFromEvaluations(
                performanceLevel,
                rubricUtils.getRubricDescriptorText(rr, performanceLevel),
                rubricRowEvals);
        }

        function getArtifactAlignmentString(fn, artifact) {
            var alignmentString = '';
            fn.rubricRows.forEach(function (rr) {
                var match = _.findWhere(artifact.alignedRubricRows, {id: rr.id});
                if (match) {
                    if (alignmentString != '') {
                        alignmentString += ', ';
                    }
                    var rrEval = _.findWhere(artifact.rubricRowEvaluations, {rubricRowId: rr.id});
                    // todo: check workstate for being done
                    if (rrEval != undefined) {
                        alignmentString += '<span class="badge badge-default">' + match.shortName + '</span>';
                    }
                    else {
                        alignmentString += match.shortName;
                    }
                }
            });

            return utils.getSafeHtml(alignmentString);
        }

        function setRubricDescriptorText() {
            vm.descriptorText = [];
            var framework = activeUserContextService.getActiveFramework();
            framework.frameworkNodes.forEach(function (fn) {
                fn.rubricRows.forEach(function (rr) {

                    var rubricRowEvals = vm.rubricRowEvaluationsByRubricRow[rr.id];

                    vm.descriptorText[rr.id] = [];
                    for (var i = 0; i < 4; ++i) {
                        var performanceLevel = i + 1;
                        vm.descriptorText[rr.id][performanceLevel] =
                            rubricUtils.generateHighlightedRubricDescriptorTextFromEvaluations(
                                performanceLevel,
                                rubricUtils.getRubricDescriptorText(rr, performanceLevel),
                                rubricRowEvals);
                    }
                });
            });
        }

        function setFnComplete() {
            var framework = activeUserContextService.getActiveFramework();
            framework.frameworkNodes.forEach(function (fn) {
                var fnComplete = true;
                fn.rubricRows.forEach(function (rr) {
                    var rrComplete = false;
                    vm.artifacts.forEach(function (artifact) {
                        var rrEval = _.findWhere(artifact.rubricRowEvaluations, {rubricRowId: rr.id});
                        if (rrEval != undefined) {
                            rrComplete = true;
                        }
                    });
                    if (!rrComplete) {
                        fnComplete = false;
                    }
                });
                vm.fnComplete[fn.id] = fnComplete;
            });
        }

        function showFrameworkNode(fn) {
            var list = _.where(fn.rubricRows, {'shortName': vm.rubricFilter});
            return vm.rubricFilter == fn.shortName || list.length > 0 || vm.rubricFilter == 'All';
        }

        function showRubricRow(rr) {

            var fn = rubricUtils.getFrameworkNodeForRubricRowId(activeUserContextService.getActiveFramework().frameworkNodes, rr.id);
            if (fn === null) {
                var x = 1;
            }
            return vm.rubricFilter == rr.shortName || vm.rubricFilter == fn.shortName || vm.rubricFilter == 'All';
        }

        function getFrameworkTree() {
            return rubricUtils.getFrameworkTree(activeUserContextService.getActiveFramework());
        }

        function rrEvalObjectType(rrEval) {
            return utils.mapLinkedItemTypeToFullString(rrEval.linkedItemType);
        }

        function rrEvalObjectTitle(rrEval) {
            var artifact = _.findWhere(vm.artifacts, {id: rrEval.linkedArtifactBundleId});
            return artifact.title;
        }

        function evaluateePlanType(evaluatee) {
            return utils.mapEvaluationPlanTypeForUserToString(vm.evaluatee);
        }

        function evaluateeFocus() {
            var str = utils.mapEvaluationFocusForUserToString(activeUserContextService, vm.evaluatee);
            if (str == 'NOT SET') {
                return '<span class="label label-warning"> NOT SET</span>';
            }
            else {
                return str;
            }
        }

    }

})();