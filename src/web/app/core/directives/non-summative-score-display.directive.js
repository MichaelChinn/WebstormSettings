(function () {
'use strict';

    angular.module('stateeval.core')
    .directive('nonSummativeScoreDisplay', nonSummativeScoreDisplayDirective);

    nonSummativeScoreDisplayDirective.$inject = [];
    function nonSummativeScoreDisplayDirective() {
        return {
            restrict: 'E',
            templateUrl: 'app/core/views/non-summative-score-display.directive.html'
        }
    }
}) ();
