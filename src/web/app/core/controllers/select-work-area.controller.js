(function() {
   'use strict';

   angular.module('stateeval.core')
        .controller('selectWorkAreaController', selectWorkAreaController);

        selectWorkAreaController.$inject = ['activeUserContextService'];

        function selectWorkAreaController(activeUserContextService) {
            var vm = this;
            vm.context = activeUserContextService.context;
            var nav = vm.context.navOption;
            vm.year = vm.context.districts[nav['year']];
            vm.district = vm.year.districts[nav['district']];
            vm.school = vm.district.schools[nav['school']];
            vm.role = vm.school.roles[nav['role']];
            vm.workAreaTag = vm.roles.workAreaTag[nav['workAreaTag']]
        }

}) ();