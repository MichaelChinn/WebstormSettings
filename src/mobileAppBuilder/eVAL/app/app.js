(function () {
    var evalMobileApp = angular.module('stateeval.mobile', ['ionic', 'ui.router', 'stateeval.core',
        'stateeval.mobile.login', 'stateeval.mobile.home', 'stateeval.mobile.artifact', 'stateeval.mobile.observation']);

    evalMobileApp.config(function ($stateProvider, $urlRouterProvider) {

        $urlRouterProvider.otherwise('/app/login');

        $stateProvider.state('app', {
            url: '/app',
            templateUrl: 'app/layout/layout.html',
            abstract: true
        })
            .state('login',
                {
                    url: "/login",
                    parent: 'app',
                    views:
                    {
                        menuContent:
                             {
                                 templateUrl: 'app/login/login.html',
                                 controller: 'loginController',
                                 controllerAs: 'vm'
                             }
                    },

                }
            )
            .state('home',
            {
                url: "/home",
                parent: 'app',
                views:
                {
                    menuContent:
                    {
                        templateUrl: 'app/home/home.html'
                    }
                }

            });

    });

})();