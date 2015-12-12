(function () {
'use strict';

    angular.module('stateeval.core')
    .directive('showAlignment', showAlignmentDirective)
    .controller('showAlignmentController', showAlignmentController);

    showAlignmentController.$inject = ['activeUserContextService', '$rootScope'];

    function showAlignmentDirective() {
        return {
            restrict: 'E',
            scope: {
                rubricRows: '=',
                rubricRowAnnotations: '='
            },
            templateUrl: 'app/core/views/show-alignment.directive.html',
            controller: 'showAlignmentController as vm',
            bindToController: true
        }
    }

    function showAlignmentController(activeUserContextService, $rootScope) {
        var vm = this;
        // from directive
        // vm.rubricRows
        vm.click = function click() {
            console.log(activeUserContextService);
        };

        vm.frameworkNodeIsAligned = frameworkNodeIsAligned;
        vm.rubricRowIsAligned = rubricRowIsAligned;
        vm.annotation = annotation;

        activate();

        function activate() {
            vm.framework = activeUserContextService.getActiveFramework();
        }

        $rootScope.$on('change-framework', function () {
            vm.activeUserContext = activeUserContextService.activeUserContext;
        });

        function annotation(rubricRow) {
            var annotation = _.findWhere(vm.rubricRowAnnotations, {rubricRowID: rubricRow.id});
            if (annotation !== undefined) {
                return annotation.annotation;
            }
            return '';
        }

        function findRubricRow(id) {
            return _.findWhere(vm.rubricRows, {'id': id});
        }

        function rubricRowIsAligned(rubricRow) {
            return findRubricRow(rubricRow.id);
        }

        function frameworkNodeIsAligned(fn) {
            var aligned = false;
            for (var i=0; i<fn.rubricRows.length; ++i) {
                var exists  = findRubricRow(fn.rubricRows[i].id);
                if (exists) {
                    aligned = true;
                    break;
                }
            }
            return aligned;
        }
    }
}) ();
