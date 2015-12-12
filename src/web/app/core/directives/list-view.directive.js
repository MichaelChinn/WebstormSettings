(function () {
'use strict';

    angular.module('stateeval.core')
    .directive('listView', listViewDirective)
    .controller('listViewController', listViewController);

    listViewDirective.$inject = [];
    function listViewDirective() {
        return {
            restrict: 'E',
            scope: {
                options: '='
            },
            template: '<div class="row"><div class="col-sm-12"><div ng-repeat="d in vm.directiveList">{{}}</div></div></div>',
            controller: 'listViewController as vm',
            bindToController: true


        }
    }

    listViewController.$inject = ['utils'];
    function listViewController(utils) {
        var vm = this;
        vm.getSafeHtml = utils.getSafeHtml;
        vm.directive = '<' + vm.options.directive + ' ' + vm.options.options + '></' + vm.options.directive + '>'
    }
}) ();
