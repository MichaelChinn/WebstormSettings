
(function () {
    'use strict';

    angular
        .module('stateeval.assignments')
        .controller('assignmentsController', assignmentsController);

    assignmentsController.$inject = ['assignmentsModel'];

    /* @ngInject */
    function assignmentsController(assignmentsModel) {

        var vm = this;

        vm.assignmentsModel = assignmentsModel.model;

        ////////////////////////////

        activate();

        function activate() {
        }
    }

})();
