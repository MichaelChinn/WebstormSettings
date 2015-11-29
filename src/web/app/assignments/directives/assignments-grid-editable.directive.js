(function () {
    'use strict';
    angular.module('stateeval.assignments')
        .directive('assignmentsGridEditable', assignmentsGridEditable)
        .controller('assignmentsGridEditableController', assignmentsGridEditableController);

    assignmentsGridEditable.$inject = [];
    assignmentsGridEditableController.$inject = ['enums'];

    function assignmentsGridEditable() {
        return {
            restrict: 'E',
            scope: {
                assignmentsModel: '='
            },
            templateUrl: 'app/assignments/views/assignments-grid-editable-directive.html',
            controller: 'assignmentsGridEditableController as vm',
            bindToController: true
        }
    }

    function assignmentsGridEditableController(enums) {
        var vm = this;

        vm.enums = enums;

        ///////////////////////////////

        activate();

        function activate() {
        }
    }
})();


