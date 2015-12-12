(function() {
   'use strict';

   angular.module('stateeval.layout')
        .controller('recentlyWorkedOnController', recentlyWorkedOnController);

        recentlyWorkedOnController.$inject = [];

        function recentlyWorkedOnController() {
           var vm = this;
            vm.recentItems = [];

        }
}) ();