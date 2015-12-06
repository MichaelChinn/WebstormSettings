
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

        vm.norththurston_usernames  = [
            "North Thurston High School AD",
            "North Thurston High School PRH",
            "North Thurston High School PR1",
            "North Thurston High School PR2",
            "North Thurston High School T1",
            "North Thurston High School T2",
            "North Thurston High School TMS",
            "North Thurston High School PMS",
            "North Thurston Public Schools DA",
            "North Thurston Public Schools DV",
            "North Thurston Public Schools DE1",
            "North Thurston Public Schools DE2",
            "North Thurston Public Schools DTE1",
            "North Thurston Public Schools DTE2",
            "North Thurston Public Schools DRM"
        ];

        vm.conway_usernames  = [
            "Conway School AD",
            "Conway School PRH",
            "Conway School PR1",
            "Conway School PR2",
            "Conway School T1",
            "Conway School T2",
            "Conway School TMS",
            "Conway School PMS",
            "Conway School District DA",
            "Conway School District DV",
            "Conway School District DE1",
            "Conway School District DE2",
            "Conway School District DTE1",
            "Conway School District DTE2",
            "Conway School District DRM"
        ];

        vm.chehalis_usernames  = [
            "Chehalis Middle School AD",
            "Chehalis Middle School PRH",
            "Chehalis Middle School PR1",
            "Chehalis Middle School PR2",
            "Chehalis Middle School T1",
            "Chehalis Middle School T2",
            "Chehalis Middle School TMS",
            "Chehalis Middle School PMS",
            "Chehalis School District DA",
            "Chehalis School District DV",
            "Chehalis School District DE1",
            "Chehalis School District DE2",
            "Chehalis School District DTE1",
            "Chehalis School District DTE2",
            "Chehalis School District DRM"
        ];

        vm.multi_usernames  = [
            "3010_AD_2754_AD",
            "3010_AD_2754_PR1",
            "3010_AD_2754_PRH",
            "3010_AD_2754_T",
            "3010_AD_3010_PR1",
            "3010_AD_3010_PRH",
            "3010_AD_3010_T",
            "3010_PR1_2754_AD",
            "3010_PR1_2754_PR1",
            "3010_PR1_2754_PRH",
            "3010_PR1_2754_T",
            "3010_PR1_3010_AD",
            "3010_PR1_3010_PRH",
            "3010_PR1_3010_T",
            "3010_PRH_2754_AD",
            "3010_PRH_2754_PR1",
            "3010_PRH_2754_PRH",
            "3010_PRH_2754_T",
            "3010_PRH_3010_AD",
            "3010_PRH_3010_PR1",
            "3010_PRH_3010_T",
            "3010_T_2754_AD",
            "3010_T_2754_PR1",
            "3010_T_2754_PRH",
            "3010_T_2754_T",
            "3010_T_3010_AD",
            "3010_T_3010_PR1",
            "3010_T_3010_PRH",
            "34003_DA_01147_DA",
            "34003_DA_01147_DAM",
            "34003_DA_01147_DE",
            "34003_DA_01147_DTE",
            "34003_DA_01147_DV",
            "34003_DA_2754_AD",
            "34003_DA_2754_PR1",
            "34003_DA_2754_PRH",
            "34003_DA_2754_T",
            "34003_DA_3010_AD",
            "34003_DA_3010_PR1",
            "34003_DA_3010_PRH",
            "34003_DA_3010_T",
            "34003_DA_34003_DAM",
            "34003_DA_34003_DE",
            "34003_DA_34003_DTE",
            "34003_DA_34003_DV",
            "34003_DAM_01147_DA",
            "34003_DAM_01147_DAM",
            "34003_DAM_01147_DE",
            "34003_DAM_01147_DTE",
            "34003_DAM_01147_DV",
            "34003_DAM_2754_AD",
            "34003_DAM_2754_PR1",
            "34003_DAM_2754_PRH",
            "34003_DAM_2754_T",
            "34003_DAM_3010_AD",
            "34003_DAM_3010_PR1",
            "34003_DAM_3010_PRH",
            "34003_DAM_3010_T",
            "34003_DAM_34003_DA",
            "34003_DAM_34003_DE",
            "34003_DAM_34003_DTE",
            "34003_DAM_34003_DV",
            "34003_DE_01147_DA",
            "34003_DE_01147_DAM",
            "34003_DE_01147_DE",
            "34003_DE_01147_DTE",
            "34003_DE_01147_DV",
            "34003_DE_2754_AD",
            "34003_DE_2754_PR1",
            "34003_DE_2754_PRH",
            "34003_DE_2754_T",
            "34003_DE_3010_AD",
            "34003_DE_3010_PR1",
            "34003_DE_3010_PRH",
            "34003_DE_3010_T",
            "34003_DE_34003_DA",
            "34003_DE_34003_DAM",
            "34003_DE_34003_DTE",
            "34003_DE_34003_DV",
            "34003_DTE_01147_DA",
            "34003_DTE_01147_DAM",
            "34003_DTE_01147_DE",
            "34003_DTE_01147_DTE",
            "34003_DTE_01147_DV",
            "34003_DTE_2754_AD",
            "34003_DTE_2754_PR1",
            "34003_DTE_2754_PRH",
            "34003_DTE_2754_T",
            "34003_DTE_3010_AD",
            "34003_DTE_3010_PR1",
            "34003_DTE_3010_PRH",
            "34003_DTE_3010_T",
            "34003_DTE_34003_DA",
            "34003_DTE_34003_DAM",
            "34003_DTE_34003_DE",
            "34003_DTE_34003_DV",
            "34003_DV_01147_DA",
            "34003_DV_01147_DAM",
            "34003_DV_01147_DE",
            "34003_DV_01147_DTE",
            "34003_DV_01147_DV",
            "34003_DV_2754_AD",
            "34003_DV_2754_PR1",
            "34003_DV_2754_PRH",
            "34003_DV_2754_T",
            "34003_DV_3010_AD",
            "34003_DV_3010_PR1",
            "34003_DV_3010_PRH",
            "34003_DV_3010_T",
            "34003_DV_34003_DA",
            "34003_DV_34003_DAM",
            "34003_DV_34003_DE",
            "34003_DV_34003_DTE"
        ];

        vm.district = 'ntps';
        vm.username = 'North Thurston High School PR1';

        vm.changeDistrict = changeDistrict;

        activate();

        function activate() {
            authenticationService.clearCredentials();
            activeUserContextService.clear();
        }

        function changeDistrict() {
            if (vm.district === 'ntps') {
                vm.username = 'North Thurston High School PR1';
            }
            else if (vm.district === 'conway') {
                vm.username = 'Conway School PR1';
            }
            else if (vm.district === 'chehalis') {
                vm.username = 'Chehalis Middle School PR1';
            }
            else if (vm.district === 'multi') {
                vm.username = '3010_AD_2754_AD'
            }
        }

        function login() {
            authenticationService.login(vm.username, vm.password)
                .then(function(user) {
                    if (user.userOrientations.length === 0) {
                        $state.go('no-frameworks', {}, {});
                    } else {
                        console.log(vm.username + ' logging in: ', user);
                        authenticationService.setCredentials(vm.username, vm.password);
                        startupService.setUser(user);
                        startupService.setupContext();
                    }
                });
        }

    }
})();
