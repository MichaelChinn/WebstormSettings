(function () {
'use strict';

    angular.module('stateeval.core')
    .directive('nodeTitle', nodeTitleDirective)

    nodeTitleDirective.$inject = [];
    function nodeTitleDirective() {
        return {
            restrict: 'E',
            scope: {
                node: '='
            },
            templateUrl: 'app/core/views/node-title.directive.html'
        }
    }

}) ();
