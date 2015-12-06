angular
    .module('stateeval.training-protocols')
    .controller('trainingProtocolController', trainingProtocolController);

 trainingProtocolController.$inject = [''];

/* @ngInject */
function trainingProtocolController () {
    /* jshint validthis: true */
    var vm = this;

    vm.activate = activate;

    activate();

    ////////////////

    function activate() {
    }


}