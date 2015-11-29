(function () {
    'use strict';

    angular.module('stateeval.layout')
        .controller('frameworkEvidenceViewController', frameworkEvidenceViewController);

    frameworkEvidenceViewController.$inject = ['activeUserContextService', 'evidenceCollectionService', 'evidenceCollection'];

    function frameworkEvidenceViewController(activeUserContextService, evidenceCollectionService, evidenceCollection) {
        var vm = this;
        vm.evidenceCollection = evidenceCollection;

        evidenceCollectionService.state.functionality = false;
        evidenceCollectionService.state.scoreVisible = false;
        evidenceCollectionService.state.scoring = false;
    }
})();