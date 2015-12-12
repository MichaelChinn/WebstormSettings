(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('rubricCoder', rubricCoderDirective);

    rubricCoderDirective.$inject = ['$rootScope', '$q', '$http', '$timeout', 'evalSessionService',
        'observationService', 'activeUserContextService', 'artifactService', 'enums'];

    function rubricCoderDirective($rootScope, $q, $http, $timeout, evalSessionService,
          observationService, activeUserContextService, artifactService, enums) {
        return {
            restrict: 'A',
            scope: {
                evalSession: '=',
                artifactBundle: '='
            },
            link: function (scope, elm, attrs) {
                var noteProperty = attrs.noteProperty;
                var timer;
                var framework;

                framework = activeUserContextService.getActiveFramework();
                reRender();

                $rootScope.$on('change-framework', function () {
                    framework = activeUserContextService.getActiveFramework();
                    if (framework != null) {
                        reRender();
                    }
                });

                function reRender() {
                    if (!framework || !framework.name) {
                        return false;
                    }


                    for (var i in framework.frameworkNodes) {
                        var frameworkNode = framework.frameworkNodes[i];
                        if (frameworkNode.shortName) {
                            var nodeDiv = $("<div class='custom-group btn-group'><div class='btn btn-default btn-sm btn-small framework_node_toolbar framework_node'>" + frameworkNode.shortName + "</div>");
                            for (var j in frameworkNode.rubricRows) {
                                var rubricRow = frameworkNode.rubricRows[j];
                                if (rubricRow.shortName) {
                                    var btn = $("<div class='btn btn-default btn-sm btn-small rubric_toolbar rubric_" + rubricRow.shortName + "'>" + rubricRow.shortName + "</div>");
                                    btn[0].rubric = rubricRow;
                                    btn[0].rubric.frameworkNodeShortName = frameworkNode.shortName;
                                    btn.bind("click", buttonClicked);
                                    nodeDiv.append(btn);
                                }
                            }

                            $(elm).append(nodeDiv);
                        }
                    }

                    function buttonClicked() {
                        var startNode = $("<span class='editor-selected'><span class='node-desc'>" + this.rubric.shortName + "</span></span>");
                        var endNode = $("<span class='node-desc-end'>" + this.rubric.shortName + "</span>");
                        var className = "selected_area" + this.rubric.shortName;
                        var wrapperSpan = document.createElement("span");                        
                        wrapperSpan.className = className + " editor-selected";
                        var responseId = parseInt(attrs.codeId);

                        var msg = "";
                        if (window.getSelection) {
                            var sel = window.getSelection();
                            if ($(".code-area-" + attrs.codeId).find($(sel.baseNode)).length > 0) {
                                if (sel.rangeCount) {
                                    var range = sel.getRangeAt(0).cloneRange();
                                    range.surroundContents(wrapperSpan);
                                    sel.removeAllRanges();
                                    sel.addRange(range);
                                    msg = wrapperSpan.textContent;


                                    if (msg) {
                                        if (scope.evalSession) {
                                            observationService.saveRubricRowAnnotation(scope.evalSession, this.rubric, msg, enums.RubricRowAnnotationType.PRE_CONF_QUESTION);
                                        }
                                        else {
                                            // todo: get the entire text to save
                                            //var codeArea = $(elm).find(".code-area-" + attrs.codeId);
                                           // artifactService.saveRubricRowAnnotation(scope.artifactBundle, this.rubric, codeArea, enums.RubricRowAnnotationType.ARTIFACT_ALIGNMENT)
                                         }
                                    } else {
                                        wrapperSpan.remove();
                                    }
                                }
                            }

                            if (msg) {
                                startNode.insertBefore($("." + className));
                                endNode.insertAfter($("." + className));
                                $("." + className).removeClass(className);
                                var codeArea = $(".code-area-" + attrs.codeId);
                                var codedResponse = $(codeArea).html();                                
                                observationService.updateUserPromptResponse(responseId, codedResponse);
                            }
                        }
                    }

               }
            }
        }
    }
})();


