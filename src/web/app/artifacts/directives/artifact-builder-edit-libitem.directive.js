(function () {
'use strict';

    angular.module('stateeval.artifact')
    .directive('artifactBuilderEditLibItem', artifactBuilderEditLibItem)
        .controller('artifactBuilderEditLibItemController', artifactBuilderEditLibItemController);

    artifactBuilderEditLibItem.$inject = [];
    artifactBuilderEditLibItemController.$inject = ['enums', 'artifactService', '$scope', '$stateParams', '$state'];

    function artifactBuilderEditLibItem() {
        return {
            restrict: 'E',
            scope: {
                artifact: '=',
                item: '=',
                doneFcn: '=',
                cancelFcn: '='
            },
            templateUrl: 'app/artifacts/views/artifact-builder-edit-libitem.directive.html',
            controller: 'artifactBuilderEditLibItemController as vm',
            bindToController: true
        }
    }

    function artifactBuilderEditLibItemController(enums, artifactService, $scope, $stateParams, $state) {
        var vm = this;

        vm.itemTypeToString = artifactService.itemTypeToString;
        vm.enums = enums;
        vm.editItemForm = {};
        vm.fileURL = '';
        vm.webUrl = '';
        vm.profPracticeNotes = '';
        vm.title = '';
        vm.fileUUID = null;
        vm.fileName = '';


        vm.uploadFile = uploadFile;
        vm.submitForm = submitForm;

        activate();

        function activate() {

            $scope.$watch('vm.item', function (newValue, oldValue) {
                vm.item = newValue;
                if (vm.item && vm.item.itemType === enums.ArtifactLibItemType.FILE && vm.item.fileUUID === null) {
                    uploadFile();
                }

                // need to load local copy in case of cancel
                if (vm.item) {
                    vm.title = vm.item.title;
                    switch (vm.item.itemType) {
                        case enums.ArtifactLibItemType.PROFPRACTICE:
                            vm.profPracticeNotes = vm.item.profPracticeNotes;
                            break;
                        case enums.ArtifactLibItemType.WEB:
                            vm.webUrl = vm.item.webUrl;
                            break;
                        case enums.ArtifactLibItemType.FILE:
                            vm.fileName = vm.item.fileName;
                            vm.fileUUID = vm.item.fileUUID;
                            break;
                        default:
                            break;
                    }
                }
            })
        }

        function submitForm(item) {
            if (vm.editItemForm.$valid) {
                item.title = vm.title;
                switch (item.itemType) {
                    case enums.ArtifactLibItemType.PROFPRACTICE:
                        item.profPracticeNotes = vm.profPracticeNotes;
                        break;
                    case enums.ArtifactLibItemType.WEB:
                        item.webUrl = vm.webUrl;
                        break;
                    case enums.ArtifactLibItemType.FILE:
                        vm.item.fileName = vm.fileName;
                        vm.item.fileUUID = vm.fileUUID;
                        break;
                    default:
                        break;
                }
                vm.doneFcn(item);
            }
        }

        function uploadFile() {
            vm.waiting = true;
            uploadcare.openDialog(null, {
                publicKey: '0c18992f124cb62a6940'
            }).done(function (file) {
                file.done(function (fileInfo) {
                    vm.waiting = false;
                    vm.fileUUID = fileInfo.uuid;
                    vm.fileName = fileInfo.name;
                    $scope.$apply();
                })
            }).fail(function () {
                vm.waiting = false;
                $scope.$apply();
            })
        }
    }

}) ();
