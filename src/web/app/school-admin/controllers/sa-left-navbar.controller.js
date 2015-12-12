
(function() {
    angular
        .module('stateeval.core')
        .controller('saLeftNavBarController', saLeftNavBarController);

    saLeftNavBarController.$inject = ['$rootScope', '$state', 'activeUserContextService'];

    /* @ngInject */

    function saLeftNavBarController($rootScope, $state, activeUserContextService) {
        var vm = this;

        activate();

        function activate() {
        }
    }
})();

