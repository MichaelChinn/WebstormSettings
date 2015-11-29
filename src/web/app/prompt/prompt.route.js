                                 angular.module('stateeval.prompt')
    .config(configureRoutes);

function configureRoutes($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('prompt-home', {
            url: '/prompt-home',
            abstract: true,
            parent: 'left-navbar'
        })
        .state('promptbank', {
            url: '/prompt-bank/:evaluationtype',
            parent: 'prompt-home',
            views: {
                'content@base': {
                    templateUrl: 'app/prompt/views/prompt-bank.html',
                    controller: 'promptBankController as vm'
                }
            },
            data: {
                title: 'Prompt Bank',
                displayName: '{{displayName}}'
            },
            resolve: {
                displayName: function($stateParams, enums) {
                    var evalType = parseInt($stateParams.evaluationtype);
                    return (evalType===enums.EvaluationType.PRINCIPAL)?"Principal Prompt Bank":"Teacher Prompt Bank";
                }
            }
        })
        .state('editprompt', {
            url: '/edit-prompt/:userpromptid?evaluationtype&prompttype',
            parent: 'prompt-home',
            views: {
                'content@base': {
                    templateUrl: 'app/prompt/views/edit-prompt.html',
                    controller: 'editPromptController as vm'
                }
            },
            data: {
                title: 'Edit Prompt',
                displayName: 'Edit Prompt'
            }
        });
}

