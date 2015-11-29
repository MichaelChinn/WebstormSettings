(function() {
   'use strict';

   angular.module('stateeval.artifact')
        .controller('artifactInfoController', artifactInfoController);

        artifactInfoController.$inject = ['artifactService'];

        function artifactInfoController(artifactService) {
           var vm = this;
        }
}) ();