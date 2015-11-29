/**
 * setupStudentGrowthController - controller
 */
(function () {
    'use strict';

    angular
        .module('stateeval.student-growth-admin')
        .controller('setupStudentGrowthController', setupStudentGrowthController);

    setupStudentGrowthController.$inject = ['enums', 'studentGrowthAdminService', 'rubricUtils',
        'activeUserContextService', 'config', 'utils', '$stateParams'];

    /* @ngInject */
    function setupStudentGrowthController(enums, studentGrowthAdminService, rubricUtils,
          activeUserContextService, config, utils, $stateParams) {
        var vm = this;
        vm.enums = enums;

        vm.submit = submit;
        vm.submitted = false;

        ////////////////////////////

        activate();

        function activate() {
            studentGrowthAdminService.getSettingsHaveBeenSubmitted(vm.evaluationType)
                .then(function(data) {
                    vm.submitted = data;
                })
        }

        function submit() {
            studentGrowthAdminService.submitSettings(vm.evaluationType).then(function() {
                vm.submitted = true;
            })
        }
    }

})();