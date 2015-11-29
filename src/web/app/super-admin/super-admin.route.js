/**
 * Created by anne on 6/19/2015.
 */

angular.module('stateeval.super-admin')
    .config(configureRoutes);

function configureRoutes($stateProvider, $urlRouterProvider) {

    $stateProvider

        .state('super-admin-import-errors', {
            url: '/import-errors',
            parent: 'left-navbar',
            views: {
                'content@base': {
                    controller: 'importErrorsController as vm',
                    templateUrl: 'app/super-admin/views/import-errors.html'
                }
            },
            data: {
                title: 'Import Errors',
                displayName: 'Import Errors'
            }
        });

}

