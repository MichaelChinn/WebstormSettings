
(function () {
    'use strict';

    angular
        .module('stateeval.layout')
        .controller('impersonateSettingsModalController', impersonateSettingsModalController);

    impersonateSettingsModalController.$inject = ['$modalInstance', 'enums', 'userService', 'locationService',
        'activeUserContextService'];

    /* @ngInject */
    function impersonateSettingsModalController($modalInstance, enums, userService, locationService,
        activeUserContextService) {
        var vm = this;

        vm.showPR = false;
        vm.showDTE = false;

        vm.option = 'PR';
        vm.schools = [];
        vm.evaluators = [];
        vm.evaluator = null;
        vm.schoolCode = null;

        vm.save = save;
        vm.cancel = cancel;
        vm.changeOption = changeOption;
        vm.changeSchool = changeSchool;

        /////////////////////////////////

        activate();

        function activate() {
           var workAreaTag = activeUserContextService.context.orientation.workAreaTag;

            var isDA = (workAreaTag === 'DA');
            var isDV = (workAreaTag === 'DV');
            var isDE = (workAreaTag === 'DE');

            if (isDA || isDV || isDE) {
                vm.showPR = true;
            }

            if (isDA || isDV) {
                vm.showDTE = true;
            }
            //always showing PR_TR
            //showOnImpersonateRoles - PR_PR, DTE, PR_TR
            loadSchools();
        }

        function loadSchools() {
            if (vm.option != 'DTE') {
                locationService.getSchoolsInDistrict(activeUserContextService.getActiveDistrictCode())
                    .then(function(schools) {
                        vm.schools = schools;
                        if (vm.schools.length>0) {
                            vm.schoolCode = vm.schools[0].schoolCode;
                            loadEvaluators();
                        }
                    })
            }
        }

        function loadEvaluators() {

            if (vm.option === 'PR') {
                userService.getUsersInRoleAtSchool(activeUserContextService.getActiveDistrictCode(),
                        vm.schoolCode,
                        enums.Roles.SESchoolPrincipal)
                    .then(function(principals) {
                        vm.evaluators = principals;
                        if (vm.evaluators.length>0) {
                            vm.evaluator = vm.evaluators[0];
                        }
                    })
            }
            else if (vm.option === "DTE") {
                userService.getUsersInRoleAtDistrict(activeUserContextService.getActiveDistrictCode(), enums.Roles.SEDistrictWideTeacherEvaluator)
                    .then(function(dtes) {
                        vm.evaluators = dtes;
                        if (vm.evaluators.length>0) {
                            vm.evaluator = vm.evaluators[0];
                        }
                    })
            }

        }

        function changeOption() {
            loadSchools();
            loadEvaluators();
        }

        function changeSchool() {
            loadEvaluators();
        }

        function save() {
            $modalInstance.close({impersonatedUser: vm.evaluator});
        }

        function cancel() {
            $modalInstance.dismiss('cancel');
        }
    }

})();

