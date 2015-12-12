(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('sePanel', sePanelBarDirective);

    function sePanelBarDirective() {
        return {
            restrict: 'A',
            link: function (scope, elm, attrs) {
                $(elm).find(".panel-heading").bind("click", function () {
                    var collapseElm = $(elm).find(".collapse");
                    if (collapseElm.hasClass("in")) {
                        collapseElm.collapse("hide");
                    } else {
                        collapseElm.collapse("show");
                    }
                    
                });
            }
        }
    }
})();


