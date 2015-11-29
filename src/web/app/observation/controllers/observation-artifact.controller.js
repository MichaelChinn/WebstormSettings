(function () {
    'use strict';

    angular
        .module('stateeval.observation')
        .controller('observationArtifactController', observationArtifactController);

    observationArtifactController.$inject = ['observationService', '$stateParams'];

    /* @ngInject */
    function observationArtifactController(observationService, $stateParams) {
        var vm = this;

        vm.evalSessionId = parseInt($stateParams.evalSessionId);
        vm.artifactBundles = [];

        ////////////////////////////
        
        function activate() {
            observationService.getArtifactBundles(vm.evalSessionId).then(function (artifactBundles) {
                vm.artifactBundles = artifactBundles;
            });
        }

        activate();
    }

})();