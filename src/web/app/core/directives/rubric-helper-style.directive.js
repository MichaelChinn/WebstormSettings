(function () {
    'use strict';
    angular.module('stateeval.core')
        .directive('rubricHelperStyle', rubricHelperStyleDirective)
        .controller('rubricHelperStyleController', rubricHelperStyleController);

    rubricHelperStyleDirective.$inject = ['$rootScope', '$q', '$http', '$timeout'];
    rubricHelperStyleController.$inject = ['$scope', 'activeUserContextService', 'userPromptService',
        'config', '_', '$rootScope', '$stateParams'];

    function rubricHelperStyleDirective($rootScope, $q, $http, $timeout) {
        return {
            restrict: 'E',
            scope: {
                userPrompts: '='
            },
            //templateUrl: 'app/core/views/rubric-helper.html',
            link: function (scope, elm, attrs) {
                scope.$watch('framework', function (newValue, oldValue) {

                });
            },
            controller: 'rubricHelperController as vm'
        }
    }

    function rubricHelperStyleController($scope, activeUserContextService, userPromptService, config, _, $rootScope, $stateParams) {
        var vm = this;        
        activate();        

        function activate() {            
        }



    }
})();


