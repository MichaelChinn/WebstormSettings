angular.module('stateeval.configuration')
    .config(configureRoutes);

configureRoutes.$inject = ['$stateProvider'];

function configureRoutes($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('configuration', {
            url: '/configuration',
            parent: 'eval-base',
            abstract: true
        })
        .state('emailrecipient', {
            url: '/emailrecipient',
            parent: 'configuration',
            views: {
                'content@base': {
                    templateUrl: 'app/configuration/views/email-recipient.html',
                    controller: 'emailRecipientController as vm'
                }
            },
            data: {
                title: 'Email Recipient',
                displayName: 'Email Recipient'
            }
        });
}

