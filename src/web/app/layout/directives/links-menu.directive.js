(function () {
    'use strict';

    angular.module('stateeval.layout')
        .directive('linksMenu', linksMenuDirective)
        .controller('linksMenuController', linksMenuController);

    linksMenuDirective.$inject = [];
    function linksMenuDirective() {
        return {
            restrict: 'E',
            scope: {},
            replace: true,
            templateUrl: 'app/layout/views/links-menu.directive.html',
            controller: 'linksMenuController as vm',
            bindToController: true
            //priority: 1500
        }
    }

    linksMenuController.$inject = ['$state', 'activeUserContextService', 'workAreaService'];
    function linksMenuController($state, activeUserContextService, workAreaService) {
        var vm = this;
        vm.wa = activeUserContextService.context.workArea();
        vm.context = activeUserContextService.context;
        vm.workAreaService = workAreaService;


        //vm.openModal = function(){
        //    console.log(vm);
        //}

    }
})();
