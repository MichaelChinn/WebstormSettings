(function () {
    'use strict';

    angular.module('stateeval.core')
        .controller('genericDashboardController', genericDashboardController);

    genericDashboardController.$inject = ['activeUserContextService', 'workAreaService'];

    function genericDashboardController(activeUserContextService, workAreaService) {
        var vm = this;
        //console.log('generic dash');
        vm.user = activeUserContextService.user;
        var context = activeUserContextService.context;
        var opt = context.navOption;
        var district = context.districts[opt.district];
        var school = district.schools[opt.school];
        var role = school.roles[opt.role];

        //workAreaService[c.districts[opt.district].schools[opt.school].roles[opt.role].workAreaTags[opt.workAreaTag]]
        //    .initializeWorkArea(activeUserContextService, district, school, role);
        context.workArea().initializeWorkArea(activeUserContextService, district, school, role);
    }
})();