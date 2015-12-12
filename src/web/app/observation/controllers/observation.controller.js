(function () {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('observationController', observationController);

    observationController.$inject = ['$q', 'logger', '$stateParams', '$state', 'config', 'enums',
        'evalSessionService', '$filter', 'observationService', 'userActivityService', 'rubricUtils',
        'activeUserContextService', 'artifactService', 'evidenceCollectionService', 'evidenceCollection', '$scope'];

    /* @ngInject */
    function observationController($q, logger, $stateParams, $state, config, enums,
         evalSessionService, $filter, observationService, userActivityService, rubricUtils,
         activeUserContextService, artifactService, evidenceCollectionService, evidenceCollection, $scope) {
        var vm = this;
        vm.inProgressBundles = [];
        vm.observationView = 1;
        vm.gotoPreConference = gotoPreConference;
        vm.gotoPostConference = gotoPostConference;
        vm.showNoteSection = showNoteSection;
        vm.editArtifact = editArtifact;
        vm.evaluateNotes = evaluateNotes;
        vm.selectedTab = 'observation';
        vm.enums = enums;

        vm.evidenceCollection = evidenceCollection;
        vm.rubricRowClicked = observationView2;
        vm.frameworkNodeClicked = observationView2;
        //todo needs to change observation view to activate switch

        vm.evalSession = {};
        vm.selectedFramework = null;
        vm.selectedFrameworkId = 0;
        vm.evalSessionId = parseInt($stateParams.evalSessionId);        
        vm.saveObservation = saveObservation;
        vm.artifactBundles = [];

        vm.isEvaluator = activeUserContextService.context.isEvaluator();
        vm.isObservationReadOnly = !vm.isEvaluator;


        //functionality restraints
        evidenceCollectionService.state.functionality = evidenceCollection.observation.evaluatorId === activeUserContextService.user.id;
        evidenceCollectionService.state.scoring = evidenceCollection.observation.evaluatorId === activeUserContextService.user.id;
        evidenceCollectionService.state.scoringVisible =  evidenceCollection.observation.evaluateeId !== activeUserContextService.user.id;
        //if evaluatee is evaluating(mouseUp-ing) no scores/scoresBTN visible




        ////////////////////////////

        var evaluatorId = activeUserContextService.getActiveUser().id;
        var evaluateeId = activeUserContextService.context.evaluatee.id;
        activate();

        //is observation owner



        function activate() {

            vm.selectedFrameworkId = 1;
            if (vm.evalSessionId > 0) {
                evalSessionService.getEvalSessionById(vm.evalSessionId).then(function (evalSession) {
                    vm.evalSession = evalSession;
                    evidenceCollectionService.state.readOnly = vm.evalSession.evaluatorId !==
                        activeUserContextService.user.id;

                    //if (vm.evalSession.observeStartTime) {
                    //    vm.evalSession.observeStartTime = new Date(vm.evalSession.observeStartTime);
                    //}
                });

                observationService.getArtifactBundles(vm.evalSessionId).then(function (artifactBundles) {
                    vm.artifactBundlesEvaluatee = _.where(artifactBundles, {createdByUserId: evaluateeId});
                    vm.artifactBundlesEvaluator = _.where(artifactBundles, { createdByUserId: evaluatorId });
                });

            } else {
                vm.evalSession = observationService.getNewObservation();
                evidenceCollectionService.state.readOnly = vm.evalSession.evaluatorId !==
                    activeUserContextService.user.id;

            }
        }
        
        function saveObservation() {
            evalSessionService.saveEvalSession(vm.evalSession).then(function (result) {
                vm.evalSession.id = result.id;
                userActivityService.saveObservationActivity(vm.evalSession);
                logger.info("Successfully Saved");
                $state.go("observations");
            });
        }

        function gotoPreConference() {
            $state.go("preconference", { evalSessionId: vm.evalSessionId });
        }

        function gotoPostConference() {
            $state.go("postconference", { evalSessionId: vm.evalSessionId });
        }

        function observationView2() {
            vm.observationView = 2
        }

        function showNoteSection() {
            vm.observationView = 1;
        }

        function editArtifact() {
            $state.go('item-list-builder');
        }

        function evaluateNotes() {
            vm.observationView = 3;
        }

        vm.sharedWithTeacherWindow = {};
        vm.openSharedWithTeacherWindow = openSharedWithTeacherWindow;

        function openSharedWithTeacherWindow() {
            var dlgOptions = {
                width: 620,
                height: 480,
                visible: false,
                actions: [

                    "Maximize",
                    "Close"
                ]
            };

            vm.sharedWithTeacherWindow.setOptions(dlgOptions);
            vm.sharedWithTeacherWindow.saveNewPreConferencePrompt = function saveNewPreConferencePrompt() {
                vm.sharedWithTeacherWindow.close();
            }

            vm.sharedWithTeacherWindow.center();
            vm.sharedWithTeacherWindow.open();
        };

        vm.shareWithTeacher = shareWithTeacher;
        function shareWithTeacher() {
            vm.evalSession.isSharedWithEvaluatee = true;
            vm.saveObservation();
        }


        vm.stopShareWithTeacherWindow = {};
        vm.stopShareWithTeacherWindow = stopShareWithTeacherWindow;

        function stopShareWithTeacherWindow() {
            var dlgOptions = {
                width: 620,
                height: 4800,
                visible: false,
                actions: [

                    "Maximize",
                    "Close"
                ]
            };

            vm.stopShareWithTeacherWindow.setOptions(dlgOptions);
            vm.stopShareWithTeacherWindow.saveNewPreConferencePrompt = function saveNewPreConferencePrompt() {
                vm.stopShareWithTeacherWindow.close();
            }

            vm.stopShareWithTeacherWindow.center();
            vm.stopShareWithTeacherWindow.open();
        };

        vm.stopShareWithTeacher = stopShareWithTeacher;

        function stopShareWithTeacher() {
            vm.evalSession.isSharedWithEvaluatee = false;
            vm.saveObservation();
        }
    }


})();