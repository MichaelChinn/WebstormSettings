(function () {
    'use strict';
    angular.module('stateeval.artifact')
        .directive('artifactAlignment', artifactAlignmentDirective)
        .controller('artifactAlignmentController', artifactAlignmentController);

    artifactAlignmentDirective.$inject = ['$rootScope', '$q', '$http', '$timeout'];
    artifactAlignmentController.$inject = ['$scope', 'activeUserContextService', 'frameworkService',
        'config', '_', '$rootScope', 'artifactService'];
    function artifactAlignmentDirective($rootScope, $q, $http, $timeout) {
        return {
            restrict: 'E',
            scope: {
                artifact: '='
            },
            templateUrl: 'app/artifacts/views/artifact-alignment.directive.html',
            controller: 'artifactAlignmentController as vm',
            bindToController: true
        }
    }

    function artifactAlignmentController($scope, activeUserContextService, frameworkService, config, _,
                 $rootScope, artifactService) {
        var vm = this;

        vm.toggleEditMode = toggleEditMode;
        vm.clear = clear;
        vm.frameworkNodeIsAligned = frameworkNodeIsAligned;
        vm.rubricRowIsAligned = rubricRowIsAligned;
        vm.editMode=true;
        vm.editModeBtnText = 'Done';
        vm.framework = activeUserContextService.getActiveFramework();
        vm.rows = [];
        vm.linkToObservation = linkToObservation;
        vm.linktoStudentGrowthGoalBundele = linkToStudentGrowthGoalBundle;

        $scope.$watchCollection('vm.artifact.linkedObservations', function(newValue, oldValue) {

        });

        activate();

        function activate() {
        }

        function clear() {
            vm.rows = [];
        }

        function linkToObservation(observation) {
            artifactService.linkArtifactToObservation(vm.artifact, observation).then(function() {
                observation.linked = true;
            });
        }

        function linkToStudentGrowthGoalBundle(goalBundle) {
            artifactService.linkArtifactToStudentGrowthGoalBundle(vm.artifact, goalBundle).then(function() {
                goalBundle.linked = true;
            });
        }

        function toggleEditMode() {
            vm.editMode=!vm.editMode;
            vm.editModeBtnText = vm.editMode?"Done":"Edit";
            if (vm.editMode) {
            }
        }

        function frameworkNodeIsAligned(fn) {
            if (vm.rows.length===0) {
                return false;
            }
            var aligned = false;
            for (var i=0; i<fn.rubricRows.length; ++i) {
                var exists  = _.find(vm.rows, {id: fn.rubricRows[i].id});
                if (exists) {
                    aligned = true;
                    break;
                }
            }
            return aligned;
        }

        function rubricRowIsAligned(rr) {
            return vm.rows.length===0?false: _.findWhere(vm.rows, {id: rr.id});
        }
    }
})();


