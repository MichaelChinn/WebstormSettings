/**
 * Created by anne on 11/9/2015.
 */
(function() {
    'use strict';

    angular.module('stateeval.layout')
        .controller('evaluateeCoverageController', evaluateeCoverageController);

    evaluateeCoverageController.$inject = ['evaluationService'];

    function evaluateeCoverageController(evaluationService) {
        var vm = this;

        vm.items = null;

        activate();

        function activate() {
            evaluationService.getAllEvaluationsFORNOW()
                .then(function (items) {
                    vm.items = items;
                });
        }
    }
}) ();
