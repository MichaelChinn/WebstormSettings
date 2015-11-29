
(function () {
    'use strict';

    angular
        .module('stateeval.layout')
        .controller('userOrientationSetupModalController', userOrientationSetupModalController);

    userOrientationSetupModalController.$inject = ['$modalInstance', 'enums', 'activeUserContextService', 'workAreaService'];

    /* @ngInject */
    function userOrientationSetupModalController($modalInstance, enums, activeUserContextService, workAreaService) {
        var vm = this;

        vm.context = activeUserContextService.context;

        vm.save = save;
        vm.cancel = cancel;
        vm.change = change;
        vm.lengths= {};
        vm.order = [];
        for(var i in enums.Order) {
            if (i < 3) {
                vm.order.push(enums.Order[i]);
            }
        }
        console.log(vm.order);
        vm.displayNames = ['Year', 'District', 'School'];


        /////////////////////////////////

        activate();

        function activate() {
            change(vm.context.orientationOptions, vm.context.orientation.schoolYear, 0);

        }





        function change(arr, spot, index) {
            var currentProperty = enums.Order[index];
            var nextProperty = enums.Order[index + 1];
            vm[currentProperty] = arr;
            vm.lengths[currentProperty] = Object.keys(arr).length;
            if(!vm[currentProperty][spot]) {
                console.log('previous field not found', spot, 'changing to', Object.keys(vm[current])[0]);
                spot = Object.keys(vm[current])[0];
            }
            vm.context.navOptions[currentProperty] = spot.toString();
            var nextSpot = vm.context.orientation[nextProperty];
            if (nextProperty) {
                change(vm[currentProperty][spot], nextSpot, index + 1);
            }
        }


        function save() {
            var tag = activeUserContextService.context.navOptions.workAreaTag;
            workAreaService[tag].initializeWorkArea(activeUserContextService);
            $modalInstance.close({});
        }

        function cancel() {
            $modalInstance.dismiss('cancel');
        }
    }

})();

