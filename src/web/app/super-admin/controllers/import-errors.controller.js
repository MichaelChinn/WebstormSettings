(function () {
    'use strict';

    angular
        .module('stateeval.super-admin')
        .controller('importErrorsController', importErrorsController);

    importErrorsController.$inject = ['superAdminService'];

    /* @ngInject */
    function importErrorsController(superAdminService) {
        var vm = this;

       vm.importErrors = [
           {
               LastName:'ARandomstring'
               ,FirstName:'ARandomstring'
               ,Email:'ARandomstring'
               ,OSPILegacyCode:'ARandomstring'
               ,DistrictCode:'ARandomstring'
               ,SchoolCode:'ARandomstring'
               ,LocationName:'ARandomstring'
               ,RawRoleString:'ARandomstring'
               ,ErrorMsg:'ARandomstring'
           }      ];

        /////////////////////////

        //activate();

        function activate() {

            superAdminService.getImportErrorRecords().then(function(importErrors) {
                vm.importErrors = importErrors;
            })
        }
    }

})();
