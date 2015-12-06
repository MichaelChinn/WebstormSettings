angular
    .module('stateeval.training-protocols')
    .controller('trainingProtocolListController', trainingProtocolListController);

trainingProtocolListController.$inject = ['trainingProtocolService', 'utils', '_'];

/* @ngInject */
function trainingProtocolListController(trainingProtocolService, utils, _) {
    /* jshint validthis: true */
    var vm = this;
    vm.getSafeHtml = utils.getSafeHtml;

    vm.protocols = [];
    vm.labelGroups = [];
    vm.selectedLabels = [];
    vm.titleSearch = '';
    vm.searchResults = [];

    vm.criteria = [];
    vm.practice = [];
    vm.subjects = [];
    vm.gradeLevels = [];
    vm.providedBy = [];

    vm.activate = activate;
    vm.search = search;

    activate();

    ////////////////

    function activate() {

        trainingProtocolService.getTrainingProtocols()
        .then(function(protocols) {
            vm.protocols = protocols;
            vm.searchResults = vm.protocols;
            loadCriteriaAlignment();
            loadHighLeveragePracticesAlignment();
            return trainingProtocolService.getTrainingProtocolLabelGroups();
        }).then(function(labelGroups) {
            vm.labelGroups = labelGroups;
            loadSubjects();
            loadProvidedBy();
            loadGradeLevels();
            })
    }

    function search()
    {
        vm.searchResults = [];
        if (vm.selectedLabels.length === 0 && vm.titleSearch==="") {
            vm.searchResults = vm.protocols;
        }
        else {
            vm.protocols.forEach(function (protocol) {
                var added = false;
                protocol.labels.forEach(function (label) {
                    if (_.find(vm.selectedLabels, {id: label.id})) {
                        added = true;
                        if (!_.find(vm.searchResults, {id: protocol.id}))
                        {
                            vm.searchResults.push(protocol);
                        }
                    }
                });
                if (!added && vm.titleSearch !== "") {
                    if (protocol.title.toUpperCase().indexOf(vm.titleSearch.toUpperCase())>=0) {
                        vm.searchResults.push(protocol);
                    }
                }
            })
        }
    }

    function loadProvidedBy() {
        vm.protocols.forEach(function(protocol) {
            var providedBy = "";
            var groupId = _.find(vm.labelGroups, {name: 'ProvidedBy'}).id;
            for (var i=0; i<protocol.labels.length; ++i) {

                if (protocol.labels[i].groupId == groupId) {
                    providedBy = protocol.labels[i].name;
                    break;
                }
            }
            vm.providedBy[protocol.id] = providedBy;
        })
    }

    function loadGradeLevels() {
        vm.protocols.forEach(function(protocol) {
            var gradeLevel = "";
            var groupId = _.find(vm.labelGroups, {name: 'Grade Level'}).id;
            for (var i=0; i<protocol.labels.length; ++i) {

                if (protocol.labels[i].groupId == groupId) {
                    if (gradeLevel.length > 0) {
                        gradeLevel += ", ";
                    }

                    gradeLevel+= protocol.labels[i].name;
                }
            }
            vm.gradeLevels[protocol.id] = gradeLevel;
        })
    }

    function loadSubjects() {
        vm.protocols.forEach(function(protocol) {
            var subjects = "";
            var groupId = _.find(vm.labelGroups, {name: 'Subject Area'}).id;
            for (var i=0; i<protocol.labels.length; ++i) {

                if (protocol.labels[i].groupId == groupId) {
                    if (subjects.length > 0) {
                        subjects += ", ";
                    }

                    subjects+= protocol.labels[i].name;
                }
            }
            vm.subjects[protocol.id] = subjects;
        })
    }

    function loadCriteriaAlignment() {
        vm.protocols.forEach(function(protocol) {
            var alignment = "";
            for (var i=0; i<protocol.alignedCriteria.length; ++i) {
                if (i>0) {
                    alignment+= ", ";
                }
                var criteria = protocol.alignedCriteria[i];
                alignment+= (criteria.shortName);
             }
            vm.criteria[protocol.id] = alignment;
        })
    }

    function loadHighLeveragePracticesAlignment() {
        vm.protocols.forEach(function(protocol) {
            var alignment = "";
            for (var i=0; i<protocol.alignedHighLeveragePractices.length; ++i) {
                if (i>0) {
                    alignment+= ", ";
                }
                var practice = protocol.alignedHighLeveragePractices[i];
                alignment+= (practice.shortName);
           }
            vm.practice[protocol.id] = alignment;
        })
    }
}
