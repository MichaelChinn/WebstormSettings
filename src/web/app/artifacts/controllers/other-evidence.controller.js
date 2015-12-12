(function () {
    'use strict';

    angular.module('stateeval.artifact')
        .controller('otherEvidenceController', otherEvidenceController);

    otherEvidenceController.$inject = ['enums', 'evidenceCollectionService',
        'activeUserContextService', 'utils', '$scope', 'evidenceCollection'];

    function otherEvidenceController(enums, evidenceCollectionService,
         activeUserContextService, utils, $scope, evidenceCollection) {
        var vm = this;
        vm.enums = enums;
        evidenceCollectionService.state.view = 'node';
        vm.evidenceCollection = evidenceCollection;

        //functionality restraints

        //All scoring is disabled and invisible
        //(mouseUp)/(rrEval create) is only available for assignedEvaluator during non-locked periods
        evidenceCollectionService.state.functionality = activeUserContextService.context.isAssignedEvaluator();
        //todo or false when year is locked
        evidenceCollectionService.state.scoring = false;
        evidenceCollectionService.state.scoringVisible = false;
    }
})();


