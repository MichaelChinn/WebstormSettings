var evalMobileApp = angular.module('evalMobile', ['ionic', 'ui.router']);

evalMobileApp.config(function ($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');

    $stateProvider.state('home', {
        url: '/',
        templateUrl:'app/home/home.html'
    });
})