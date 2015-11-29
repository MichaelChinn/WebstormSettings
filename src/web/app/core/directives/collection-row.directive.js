(function () {
'use strict';

    angular.module('stateeval.core')
    .directive('collectionRow', collectionRowDirective);

    collectionRowDirective.$inject = [];
    function collectionRowDirective() {
        return {
            restrict: 'E',
            templateUrl: 'app/core/views/collection-row.directive.html'
        }
    }

}) ();
