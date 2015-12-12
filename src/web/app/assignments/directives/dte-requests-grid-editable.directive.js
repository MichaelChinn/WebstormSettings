(function () {
    'use strict';
    angular.module('stateeval.assignments')
        .directive('dteRequestsGridEditable', dteRequestsGridEditable)
        .controller('dteRequestsGridEditableController', dteRequestsGridEditableController);

    dteRequestsGridEditable.$inject = [];
    dteRequestsGridEditableController.$inject = [];

    function dteRequestsGridEditable() {
        return {
            restrict: 'E',
            scope: {
                assignmentsModel: '='
            },
            templateUrl: 'app/assignments/views/dte-requests-grid-editable-directive.html',
            controller: 'dteRequestsGridEditableController as vm',
            bindToController: true
        }
    }

    function dteRequestsGridEditableController() {
        var vm = this;

        ///////////////////////////////

        activate();

        function activate() {
        }
    }
})();


