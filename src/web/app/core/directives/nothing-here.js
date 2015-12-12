/**
 * Created by anne on 9/2/2015.
 */
(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('nothingHere', nothingHereDirective);

    function nothingHereDirective() {
        return {
            restrict: 'E',
            scope: {
                title: '=',
                description: '=',
                icon: '='
            },
            templateUrl: 'app/core/views/nothing-here.html'
        }
    }

    })();


