(function() {
   'use strict';

   angular.module('stateeval.layout')
        .controller('notificationsController', notificationsController);

        notificationsController.$inject = [];

        function notificationsController() {
            var vm = this;
            vm.notifications;

            activate();

            function activate() {

            }

        }
}) ();