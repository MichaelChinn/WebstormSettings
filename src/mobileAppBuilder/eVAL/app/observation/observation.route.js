angular.module('stateeval.mobile.observation')
    .config(configureRoutes);

configureRoutes.$inject = ['$stateProvider'];

function configureRoutes($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('select-evaluatee', {
            url: '/select-evaluatee',
            parent: 'app',
            views:
                    {
                        menuContent:
                             {
                                 templateUrl: 'app/observation/views/select-evaluatee.html',
                                 controller: 'observationController',
                                 controllerAs: 'vm'
                             }
                    },
        });

}

