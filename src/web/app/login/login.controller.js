
(function() {

    angular
        .module('stateeval.login')
        .controller('loginController', loginController);

    loginController.$inject = ['$location', 'authenticationService', 'startupService', '$state', 'activeUserContextService'];

    /* @ngInject */
    function loginController($location, authenticationService, startupService, $state, activeUserContextService) {

        var vm = this;
        vm.login = login;
        vm.password = '';
        vm.username = 'North Thurston High School PR1';

        activate();

        function activate() {
            authenticationService.clearCredentials();
            activeUserContextService.clear();
        }

        function login() {
            authenticationService.login(vm.username, vm.password)
                .then(function (user) {
                    if (user.userOrientations.length === 0) {
                        $state.go('no-frameworks', {}, {});
                    }
                    else {
                        console.log(vm.username + ' logging in: ', user);
                        authenticationService.setCredentials(vm.username, vm.password);
                        startupService.setUser(user);
                        startupService.setupContext();
                    }
                })
        }

    }
})();
