/**
 * rejectArtifactModalController - controller
 */
(function () {
    'use strict';

    angular
        .module('stateeval.artifact')
        .controller('rejectArtifactModalController', rejectArtifactModalController);

    rejectArtifactModalController.$inject = ['$modalInstance', 'enums'];

    /* @ngInject */
    function rejectArtifactModalController($modalInstance, enums) {
        var vm = this;
        vm.reject = reject;
        vm.cancel = cancel;

        vm.rejectionType = enums.ArtifactBundleRejectionType.NON_ESSENTIAL.toString();
        vm.comments = '';

        function reject() {
            $modalInstance.close({rejectionType: parseInt(vm.rejectionType), message: vm.comments});
        }

        function cancel() {
            $modalInstance.dismiss('cancel');
        }
    }

})();
