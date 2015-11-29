(function() {
   'use strict';

   angular.module('stateeval.artifact')
        .controller('ProfessionalPracticeController', ProfessionalPracticeController);

        ProfessionalPracticeController.$inject = ['artifactService', 'libItem', '$modalInstance'];

        function ProfessionalPracticeController(artifactService, libItem, $modalInstance) {
           var vm = this;
            vm.artifactBox = artifactService.artifactBox;
            vm.item = libItem;
            console.log(vm.item);
            vm.close = function () {
                $modalInstance.dismiss('cancel');
            }
        }
}) ();