(function () {
    'use strict';

    angular.module('stateeval.summative-eval')
        .controller('summativeEvalController', summativeEvalController);

    summativeEvalController.$inject = ['evidenceCollection', 'activeUserContextService', 'evidenceCollectionService', 'config',
    'enums', '$scope'];

    function summativeEvalController(evidenceCollection, activeUserContextService, evidenceCollectionService, config, enums,
    $scope) {
        var vm = this;
        activeUserContextService.setActiveFramework(activeUserContextService.context.frameworkContext.stateFramework);
        console.log($scope);
        vm.enums = enums;
        vm.evidenceCollection = evidenceCollection;
        vm.evidenceCollectionService = evidenceCollectionService;
        vm.toggle = [];
        vm.summerNoteOptions = config.summernoteDefaultOptions;
        vm.EvidenceTypeKeys = Object.keys(vm.enums.EvidenceCollectionType);

        var name = activeUserContextService.context.framework.name;
        vm.node = evidenceCollection.tree[name][evidenceCollection.tree[name].nodes[0]];
        vm.row = vm.node[vm.node.rows[0]];


        evidenceCollectionService.state.view = 'node';
        evidenceCollectionService.state.functionality = false;
        evidenceCollectionService.state.scoring = true;
        evidenceCollectionService.state.scoringVisible = true;
        //todo create autosave on editor


    }
})();


