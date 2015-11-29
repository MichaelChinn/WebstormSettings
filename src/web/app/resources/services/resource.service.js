(function () {
    'use strict';

    angular.module('stateeval.resource')
        .factory('resourceService', resourceService);

    resourceService.$inject = ['$http', 'config', 'enums', 'activeUserContextService', '$q', '_'];

    function resourceService($http, config, enums, activeUserContextService, $q, _) {
        var resourceBox = {
            localResource: null,
            schoolResources: [],
            districtResources: []
        };
        var activeUser = {
            schoolCode: undefined,
            districtCode: undefined,
            typeOfUser: undefined,
            id: undefined
        };

        var url = config.apiUrl + 'resources/';
        return {
            activate: activate,
            resourceBox: resourceBox,
            activeUser: activeUser,
            newResource: newResource,
            getResourceBySchool: getResourceBySchool,
            getResourceByDistrict: getResourceByDistrict,
            getResourceById: getResourceById,
            getResourceForDistrictAdmin: getResourceByDistrict,
            saveResource: saveResource,
            deleteResource: deleteResource

        };

        function activate() {
            //var user = activeUserContextService.getActiveUser();
            //activeUser.schoolCode = activeUserContextService.getActiveSchoolCode();
            //activeUser.districtCode = activeUserContextService.getActiveDistrictCode();
            //activeUser.typeOfUser = activeUserContextService.getActiveWorkArea().tag;
            //if(activeUser.typeOfUser !== 'SA' && activeUser.typeOfUser !== 'DA') {
            //    activeUser.typeOfUser = 'V';
            //}
            //activeUser.id = user.id;
            activeUser.typeOfUser =
            activeUser.schoolCode = '34003';
            activeUser.districtCode = '3010';
            activeUser.typeOfUser = 'SA';
            activeUser.id = 0;
            return rebuildResourceLists();
        }

        function rebuildResourceLists() {
             return $q.all([
                getResourceBySchool(activeUser.schoolCode)
                    .then(function (data) {
                        resourceBox.schoolResources = data;
                    }),
                getResourceForDistrictAdmin(activeUser.districtCode)
                    .then(function (data) {
                        resourceBox.districtResources  = data;
                    })
            ]);
        }

        function newResource() {

            //TODO REMEMBER CANNOT SAVE WITHOUT RESOURCE OR ITEM TYPE BAD
            var resource = {
                itemType: 1,
                fileUUID: '',
                webUrl: '',
                id: -1,
                schoolCode: activeUser.schoolCode,
                districtCode: activeUser.districtCode,
                title: '',
                comments: '',
                fileName: '',
                resourceType: 1,
                createdByUserId: activeUser.id,
                creationDateTime: new Date(),
                alignedRubricRows: []
            };
            return resource;
        }

        function getResourceForDistrictAdmin(districtCode) {
            return $http.get(url + 'districtOnly/' + districtCode)
                .then(function (response) {
                    return response.data;
                });
        }

        function getResourceBySchool(schoolCode) {
            return $http.get(url + 'school/' + schoolCode)
                .then(function (response) {
                    return response.data;
                });

        }

        function getResourceByDistrict(districtCode) {
            return $http.get(url + 'district/' + districtCode)
                .then(function (response) {
                    return response.data;
                });

        }

        function getResourceById(id) {
            return $http.get(url + id)
                .then(function (response) {
                    return response.data;
                });

        }

        function deleteResource(resource) {
            console.log('deleting', resource);
            return $http.delete(url + 'delete/' + resource.id)
                .then(function (response) {
                    rebuildResourceLists();
                });
        }

        function saveResource(resource) {
            console.log('saving resource: ', resource);
            function find(r) {
                return r.id === resource.id;
            }

            var promise = null;
            if (_.find(resourceBox.editableResources, find) ||
                _.find(resourceBox.viewableResources, find)) {
                promise = saveOldResource(resource);
            } else {
                promise = saveNewResource(resource)
            }
            return promise.then(function () {
                rebuildResourceLists();
                console.log('Rebuilding the lists');
            });
        }

        function saveOldResource(resource) {
            return $http.put(url + 'save', resource);
        }

        function saveNewResource(resource) {
            return $http.post(url + 'new', resource);
        }
    }
})();