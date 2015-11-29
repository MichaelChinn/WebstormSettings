(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('summerNoteNew', SummerNoteDirective);

    SummerNoteDirective.$inject = ['$rootScope', '$q', '$http', '$timeout', 'evalSessionService', 'observationService', 'activeUserContextService', 'enums'];

    function SummerNoteDirective($rootScope, $q, $http, $timeout, evalSessionService, observationService, activeUserContextService, enums) {
        return {
            restrict: 'A',
            scope: {
                //framework: '=',
                evalSession: '='
            },
            link: function (scope, elm, attrs) {
                var noteProperty = attrs.noteProperty;
                var timer;
                var framework;

                var summernote = $(elm).summernote({
                    height: 200,
                    onKeyup: function (e) {
                        saveNote();
                    }
                });

                if (scope.evalSession) {
                    summernote.code(scope.evalSession[noteProperty]);
                }

                function saveNote() {
                    $timeout.cancel(timer);
                    timer = $timeout(function () {
                        scope.evalSession[noteProperty] = $(elm).code();
                        if (scope.evalSession.id) {
                            evalSessionService.saveObserveNotes(scope.evalSession.id, $(elm).code(), noteProperty);
                        }

                    }, 1000);
                }

                framework = activeUserContextService.getActiveFramework();
                reRender();

                $rootScope.$on('change-framework', function () {
                    framework = activeUserContextService.getActiveFramework();
                    if (framework != null) {
                        reRender();
                    }
                });

                scope.$watch('evalSession', function (newValue, oldValue) {
                    if (scope.evalSession) {
                        summernote.code(scope.evalSession[noteProperty]);
                    }
                });

                function reRender() {
                    var finder = $(elm).next(".note-editor").find(".note-toolbar");
                    finder.find(".custom-group").remove();
                    if (!framework || !framework.name) {
                        return false;
                    }

                    if (finder.length > 0) {
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

                                $(finder).append(nodeDiv);
                            }
                        }
                    }

                    function buttonClicked() {
                        var startNode = $("<span class='editor-selected'><span class='node-desc'>" + this.rubric.shortName + "</span></span>");
                        var endNode = $("<span class='node-desc-end'>" + this.rubric.shortName + "</span>");
                        var className = "selected_area" + this.rubric.shortName;
                        var wrapperSpan = document.createElement("span");
                        wrapperSpan.className = className + " editor-selected";

                        var msg = "";
                        if (window.getSelection) {
                            var sel = window.getSelection();
                            if ($(elm).next(".note-editor").find($(sel.baseNode)).length > 0) {
                                if (sel.rangeCount) {
                                    var range = sel.getRangeAt(0).cloneRange();
                                    range.surroundContents(wrapperSpan);
                                    sel.removeAllRanges();
                                    sel.addRange(range);
                                    msg = wrapperSpan.textContent;
                                    if (msg) {
                                        if (noteProperty == 'observeNotes') {
                                            observationService.saveRubricRowAnnotation(scope.evalSession, this.rubric, msg, enums.RubricRowAnnotationType.OBSERVATION_NOTES);
                                        } else {
                                            observationService.saveRubricRowAnnotation(scope.evalSession, this.rubric, msg, enums.RubricRowAnnotationType.PRE_CONF_MEETING);
                                        }
                                    } else {
                                        wrapperSpan.remove();
                                    }

                                    saveNote();
                                }
                            }
                        }

                        if (msg) {
                            startNode.insertBefore($("." + className));
                            endNode.insertAfter($("." + className));
                            $("." + className).removeClass(className);
                        }

                        //var range = window.getSelection().getRangeAt(0);
                        //var content = range.extractContents();
                        //if (content.textContent) {
                        //    var msg = content.textContent;
                        //    var html = $("<span class='editor-selected'><span class='node-desc'>" + this.rubric.shortName + "</span></span>");
                        //    html.append($(content));
                        //    html.append($("<span class='node-desc-end'>" + this.rubric.shortName + "</span>"));
                        //    $(elm).summernote('pasteHTML', html);
                        //saveNote();
                        //    observationService.saveRubricRowAnnotation(scope.evalSession, this.rubric, msg);
                        //}
                    }
                }
            }
        }
    }
})();


