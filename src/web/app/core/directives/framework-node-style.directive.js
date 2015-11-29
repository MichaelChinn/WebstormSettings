(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('frameworkNodeStyle', frameworkNodeStyleDirective)
        .controller('frameworkNodeController', frameworkNodeStyleController);

    frameworkNodeStyleDirective.$inject = ['$rootScope', '$q', '$http', '$timeout', 'observationService', '$stateParams', 'rubricRowEvaluationService', 'enums'];
    frameworkNodeStyleController.$inject = ['$scope', 'activeUserContextService', 'userPromptService',
        'config', '_', '$rootScope', '$stateParams'];

    function frameworkNodeStyleDirective($rootScope, $q, $http, $timeout, observationService, $stateParams, rubricRowEvaluationService, enums) {
        return {
            restrict: 'A',
            scope: {
                frameworkNode: '='
            },
            //templateUrl: 'app/core/views/rubric-helper.html',
            link: function (scope, elm, attrs) {                
                var evalSessionId = $stateParams.evalSessionId;
                if (!evalSessionId) {
                    return;
                }

                observationService.getObservation(evalSessionId).then(function(evalSession) {
                    if(evalSession && evalSession.rubricRows && evalSession.rubricRows.length>0) {
                        var isRubricAligned = checkRubricAligned(evalSession, scope.frameworkNode);

                        if (isRubricAligned) {
                            $(elm).find(".node-name").css('background-color', '  #2f4050', '!important');
                        }
                    }
                });

                rubricRowEvaluationService.getRubricRowEvaluationsForEvalSession(evalSessionId).then(function(evaluations) {
                    if (checkForEvaluation(evaluations)) {
                        $(elm).find(".node-name").css('background-color', 'green', '!important');
                    }
                });
                
                function checkForEvaluation(evaluations) {
                    if (evaluations && evaluations.length > 0) {
                        for (var i in evaluations) {
                            var evaluation = evaluations[i];
                            if (evaluation.wfState == enums.WfState.RREVAL_DONE) {
                                for (var j in scope.frameworkNode.rubricRows) {
                                    var rubric = scope.frameworkNode.rubricRows[j];
                                    if (rubric.id == evaluation.rubricRowId) {
                                        return true;
                                    }
                                }
                            }
                        }

                        return false;
                        
                    }
                }

                function checkRubricAligned(evalSession, frameworkNode) {
                    if (evalSession.rubricRows && evalSession.rubricRows.length > 0 && frameworkNode.rubricRows && frameworkNode.rubricRows.length > 0) {

                        for(var i in frameworkNode.rubricRows) {
                            var fnRubricRow = frameworkNode.rubricRows[i];
                            if (fnRubricRow) {
                                for (var j in evalSession.rubricRows) {
                                    var eRubricRow = evalSession.rubricRows[j];
                                    if (eRubricRow.shortName == fnRubricRow.shortName) {
                                        return true;
                                    }
                                }
                            }
                        }
                    }

                    return false;
                }

                //observationService.getArtifactBundles(evalSessionId).then(function (artifactBundles) {
                //    var artifactBundlesEvaluatee = _.where(artifactBundles, { createdByUserId: evaluateeId });
                //    var artifactBundlesEvaluator = _.where(artifactBundles, { createdByUserId: evaluatorId });

                //});                
            },
            controller: 'rubricHelperController as vm'
        }
    }

    function frameworkNodeStyleController($scope, activeUserContextService, userPromptService, config, _, $rootScope, $stateParams) {
        var vm = this;        
        activate();        

        function activate() {            
        }



    }
})();


