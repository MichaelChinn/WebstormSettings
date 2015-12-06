/**
 * Created by anne on 12/5/2015.
 */
(function() {
 'use strict';

    angular
        .module('stateeval.self-assessment')
        .controller('selfAssessmentController', selfAssessmentController);

    selfAssessmentController.$inject = ['activeUserContextService', '$stateParams', 'selfAssessmentService',
        'evidenceCollection', 'evidenceCollectionService'];

    /* @ngInject */
    function selfAssessmentController(activeUserContextService, $stateParams, selfAssessmentService,
          evidenceCollection, evidenceCollectionService) {
        /* jshint validthis: true */
        var vm = this;

        vm.activate = activate;
        vm.assessment = null;
        vm.evidenceCollection = evidenceCollection;

        activate();

        ////////////////

        function activate() {

            selfAssessmentService.getSelfAssessmentById(parseInt($stateParams.id)).then(function(assessment) {
                vm.assessment = assessment;

                //functionality restraints
                evidenceCollectionService.state.functionality = evidenceCollection.selfAssessment.evaluateeId === activeUserContextService.user.id;
                evidenceCollectionService.state.scoring = evidenceCollection.selfAssessment.evaluateeId === activeUserContextService.user.id;
                evidenceCollectionService.state.scoringVisible =  true

                evidenceCollectionService.state.readOnly = vm.assessment.evaluateeId !==
                    activeUserContextService.user.id;

            });
        }
    }
})();
