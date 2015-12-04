var evalMobileApp = angular.module('evalMobile', ['ionic', 'ui.router']);

evalMobileApp.config(function ($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/app/home');

    $stateProvider.state('app', {
            url: '/app',
            templateUrl: 'app/layout/layout.html',
            abstract: true
        })
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

})