(function () {
    'use strict';

    angular.module('stateeval.core')
        .directive('scoreButtonGroup', scoreButtonGroupDirective)
        .controller('scoreButtonGroupController', scoreButtonGroupController);

    scoreButtonGroupDirective.$inject = [];
    function scoreButtonGroupDirective() {
        return {
            restrict: 'E',
            templateUrl: 'app/core/views/score-button-group.directive.html',
            controller: 'scoreButtonGroupController'
        }
    }

    scoreButtonGroupController.$inject = ['$scope', 'enums', 'evidenceCollectionService'];
    function scoreButtonGroupController($scope, enums, evidenceCollectionService) {
        $scope.scoreItem  =  evidenceCollectionService.state.scoring ? directiveScore : function () {};
        function directiveScore(level) {
            $scope.vm.score.performanceLevel = ($scope.vm.score.performanceLevel === level ? null : level);
            return $scope.vm.root.scoreItem($scope.vm.score);
        }

    }
})();
