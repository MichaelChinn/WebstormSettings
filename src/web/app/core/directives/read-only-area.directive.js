(function() {
    'use strict';
    angular.module('stateeval.core')
        .directive('readOnlyArea', readOnlyAreaDirective)
        .directive('hideWhenReadOnly', hideWhenReadOnlyDirective);

     
    var readOnly = false;

    function readOnlyAreaDirective() {
        return {
            restrict: 'A',
            scope: {
                readOnly: "&"
            },
            link: function(scope, elm, attrs) {
                readOnly = scope.readOnly();

                if (scope.readOnly()) {
                    var selector = "input[type='text'],input[type='date'], input[type='button']";
                    $(elm).find(selector).attr('readOnly', 'readOnly');
                    $(".hide-when-read-only").css('display', 'none');
                }
            }
        }
    }

    function hideWhenReadOnlyDirective() {
        return {
            restrict: 'C',
            link: function(scope, elm, attrs) {
                if (readOnly) {
                    var selector = "input[type='text'],input[type='date'], input[type='button']";
                    $(elm).find(selector).attr('readOnly', 'readOnly');
                    $(".hide-when-read-only").css('display', 'none');
                }
            }
        }
    }
})();