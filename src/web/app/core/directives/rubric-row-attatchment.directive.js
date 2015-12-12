(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('rubricRowAttatchment', rubricRowAttatchmentDirective)
        .controller('rubricRowAttatchmentController', rubricRowAttatchmentController);

    rubricRowAttatchmentDirective.$inject = ['$rootScope', '$q', '$http', '$timeout', 'activeUserContextService',
        'observationService', '$stateParams', 'artifactService'];
    rubricRowAttatchmentController.$inject = ['$scope', 'activeUserContextService', 'userPromptService',
        'config', '_', '$rootScope', '$stateParams'];

    function rubricRowAttatchmentDirective($rootScope, $q, $http, $timeout, activeUserContextService,
       observationService, $stateParams, artifactService) {
        return {
            restrict: 'A',
            scope: {
                rubricRow: '='
            },
            //templateUrl: 'app/core/views/rubric-helper.html',
            link: function (scope, elm, attrs) {
                var evalSessionId = $stateParams.evalSessionId;
                if (!evalSessionId) {
                    return;
                }

                var rubricRow = scope.rubricRow;
                var evaluatorId = activeUserContextService.getActiveUser().id;
                var evaluateeId = activeUserContextService.getActiveEvaluatee().id;
                
                var artifactId = parseInt($stateParams.artifactId);

                // todo: handle other-evidence artifact.rubricRowAnnotations

                
                if (evalSessionId != null ) {
                    observationService.getArtifactBundles(evalSessionId).then(function (artifactBundles) {
                        var artifactBundlesEvaluatee = _.where(artifactBundles, {createdByUserId: evaluateeId});
                        var hasEvaluateeArtifact = hasRubricAnArtifact(artifactBundlesEvaluatee);
                        if (hasEvaluateeArtifact) {
                            $(elm).append("<span>T</span>");
                        }

                        var artifactBundlesEvaluator = _.where(artifactBundles, {createdByUserId: evaluatorId});
                        var hasEvaluatorArtifact = hasRubricAnArtifact(artifactBundlesEvaluator);
                        if (hasEvaluatorArtifact) {
                            $(elm).append("<span>E</span>");
                        }
                    });

                    observationService.getRubricRowAnnotations(evalSessionId, rubricRow.id).then(function (annotations) {
                        var evaluatorAnnotations = _.where(annotations, {userID: evaluatorId});
                        var hasEvaluatorAnnotation = evaluatorAnnotations && evaluatorAnnotations.length > 0;
                        if (hasEvaluatorAnnotation) {
                            $(elm).append("<span>I</span>");
                        }

                        var evaluateeAnnotations = _.where(annotations, {userID: evaluateeId});
                        var hasEvaluateeAnnotation = evaluateeAnnotations && evaluateeAnnotations.length > 0;
                        if (hasEvaluateeAnnotation) {
                            $(elm).append("<span>K</span>");
                        }

                    });
                }

                function hasRubricAnArtifact(artifactBundles) {                    
                    if (artifactBundles && artifactBundles.length > 0) {
                        for (var i in artifactBundles) {
                            for (var j in artifactBundles[i].alignedRubricRows) {
                                var alRubric = artifactBundles[i].alignedRubricRows[j];
                                if (alRubric.shortName == rubricRow.shortName) {
                                    return true;
                                }
                            }
                        }
                    }

                    return false;
                };

            },
            controller: 'rubricHelperController as vm'
        }
    }

    function rubricRowAttatchmentController($scope, activeUserContextService, userPromptService, config, _, $rootScope, $stateParams) {
        var vm = this;        
        activate();        

        function activate() {            
        }



    }
})();


