(function() {
    angular.module('stateeval.core')
        .directive('evidenceItemSummary', evidenceItemSummaryDirective)
        .controller('evidenceItemSummaryController', evidenceItemSummaryController);

    evidenceItemSummaryDirective.$inject = [];

    function evidenceItemSummaryDirective() {

        return {
            bindToController: true,
            restrict: 'E',
            scope: {
                evidence: '='
            },
            templateUrl: 'app/core/views/evidence-item-summary.directive.html',
            controller: 'evidenceItemSummaryController as vm'

        }
    }

    evidenceItemSummaryController.$inject = ['utils'];

    function evidenceItemSummaryController(utils) {
        var vm = this;

        vm.getSafeHtml = utils.getSafeHtml;

    }
})();


