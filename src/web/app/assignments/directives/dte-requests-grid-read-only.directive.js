(function () {
    'use strict';
    angular.module('stateeval.assignments')
        .directive('dteRequestsGridReadOnly', dteRequestsGridReadOnly)
        .controller('dteRequestsGridReadOnlyController', dteRequestsGridReadOnlyController);

    dteRequestsGridReadOnly.$inject = [];
    dteRequestsGridReadOnlyController.$inject = ['utils', 'assignmentsService'];

    function dteRequestsGridReadOnly() {
        return {
            restrict: 'E',
            scope: {
                assignmentsModel: '='
            },
            templateUrl: 'app/assignments/views/dte-requests-grid-read-only-directive.html',
            controller: 'dteRequestsGridReadOnlyController as vm',
            bindToController: true
        }
    }

    function dteRequestsGridReadOnlyController(utils, assignmentsService) {
        var vm = this;

        ///////////////////////////////

        activate();

        function activate() {
        }
    }
})();


