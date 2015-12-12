(function () {
'use strict';

    angular.module('stateeval.core')
    .directive('rowTitle', rowTitleDirective);

    rowTitleDirective.$inject = [];
    function rowTitleDirective() {
        return {
            restrict: 'E',
            scope: {
                row: '='
            },
            templateUrl: 'app/core/views/row-title.directive.html'


        }
    }
}) ();
