(function () {
    'use strict';

    angular.module('stateeval.core')
        .controller('leftNavbarController', leftNavbarController);

    leftNavbarController.$inject = ['activeUserContextService', 'workAreaService', '$state', '$modal', 'enums', 'utils'];

    function leftNavbarController(activeUserContextService, workAreaService, $state, $modal, enums, utils) {
        var vm = this;
        vm.evalLogo = 'images/eval_logo.jpg';
        vm.user = activeUserContextService.user;
        vm.context = activeUserContextService.context;
        vm.user.profPic = 'lib/inspinia/img/profile_small.jpg';
        vm.workAreaService = workAreaService;
        vm.location = '';

        vm.openOptionsModal = openOptionsModal;

        //vm.schoolYear = vm.context.orientationOptions;

        //vm.evaluatee = null;
        var wa = vm.context.workArea();
        vm.child = 0;
        vm.parent = 0;

        vm.clickLink = clickLink;
        vm.clickSubLink = clickSubLink;
        vm.changeEvaluatee = changeEvaluatee;
        vm.initWorkArea = initWorkArea;
        var n = vm.context.navOptions;
        vm.workAreaTags = vm.context.orientationOptions[n.schoolYear][n.districtName][n.schoolName];
        vm.orientation = vm.context.orientation;
        //vm.workAreaTag = vm.context.orientation.workAreaTag;
        vm.tagsLength = Object.keys(vm.workAreaTags).length + vm.context.additionalWorkAreas.length;

        ////////////////////////////////

        activate();

        function activate() {
            try {
                for (var i in wa.navbar) {
                    var state = utils.stripParameters(wa.navbar[i].state);
                    if ($state.current.name === state) {
                        vm.parent = i;
                    }
                    for (var j in wa.navbar[i].subLinks) {
                        state = utils.stripParameters(wa.navbar[i].subLinks[j].state);
                        if ($state.current.name === state) {
                            vm.parent = i;
                            vm.child = j;
                        }
                    }
                }
            } catch (e) {
                console.log('No data field on state - needs title equal to navlink.title\t', e);
            }

            vm.parent = Number(vm.parent);
            vm.child = Number(vm.child);

            //vm.evaluatee = vm.context.evaluatee;

            vm.location = vm.context.orientation.schoolCode != '' ? vm.context.orientation.schoolName : vm.context.orientation.districtName;
            //if there is no school code location = dName

            vm.role = utils.mapRoleNameToFriendlyName(vm.context.orientation.roleName);
        }

        function clickLink(index, link) {
            if (!link.subLinks) {
                vm.parent = index;
            }
        }

        function clickSubLink(index, parentIndex) {
            vm.parent = parentIndex;
            vm.child = index;
        }

        function changeEvaluatee() {
            console.log('changed evaluatee');
            //vm.context.evaluatee = vm.evaluatee;
            activeUserContextService.save();
            // todo: context.evaluatee is null after switch pages
            var link = activeUserContextService.context.workArea().navbar[0];
            $state.go(link.state, {}, {reload: true});
            //Sets the currently evaluated to an evaluatee from users list of evaluatees
        }

        function openOptionsModal() {
            vm.modalInstance = $modal.open({
                animation: false,
                templateUrl: 'app/layout/views/user-orientation-setup-modal.html',
                controller: 'userOrientationSetupModalController as vm',
                size: 'lg',
                windowClass: 'optionsModal'
            });

            vm.modalInstance.result.then(function yearLocationModal(result) {
                console.log('Close Modal');
            });
        }

        function initWorkArea() {
            var orientation = true;
            for(var i in vm.context.additionalWorkAreas) {
                if(vm.context.navOptions.workAreaTag === vm.context.additionalWorkAreas[i]) {
                    orientation = false;
                }
            }
            workAreaService[vm.context.navOptions.workAreaTag].initializeWorkArea(activeUserContextService, orientation);
        }
    }
})();