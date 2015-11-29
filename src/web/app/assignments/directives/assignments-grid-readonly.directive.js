(function () {
    'use strict';
    angular.module('stateeval.assignments')
        .directive('assignmentsGridReadOnly', assignmentsGridReadOnly)
        .controller('assignmentsGridReadOnlyController', assignmentsGridReadOnlyController);

    assignmentsGridReadOnly.$inject = [];
    assignmentsGridReadOnlyController.$inject = [];

    function assignmentsGridReadOnly() {
        return {
            restrict: 'E',
            scope: {
                assignmentsModel: '='
            },
            templateUrl: 'app/assignments/views/assignments-grid-read-only-directive.html',
            controller: 'assignmentsGridReadOnlyController as vm',
            bindToController: true
        }
    }

    function assignmentsGridReadOnlyController() {
        var vm = this;

        ///////////////////////////////

        activate();

        function activate() {
        }
    }
})();


