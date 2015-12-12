/**
 * Created by anne on 10/27/2015.
 */
(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('convertToNumber', convertToNumber);

    function convertToNumber() {
        return {
            require: 'ngModel',
            link: function (scope, element, attrs, ngModel) {
                ngModel.$parsers.push(function(val) {
                    return parseInt(val, 10);
                });
                ngModel.$formatters.push(function (val) {
                    return '' + val;
                });
            }
        };
    }

})();

