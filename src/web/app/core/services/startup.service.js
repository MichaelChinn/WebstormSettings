(function () {

    angular
        .module('stateeval.core')
        .factory('startupService', startupService);

    startupService.$inject = ['activeUserContextService', 'workAreaService', 'enums', 'localStorageService', '$q', 'evidenceCollectionService'];

    function startupService(activeUserContextService, workAreaService, enums, localStorageService, $q, evidenceCollectionService) {

        var Context = function () {};
        Context.prototype = {
            workArea: function () {
                return workAreaService[this.orientation.workAreaTag];
            },
            isEvaluating: function () {
                return this.workArea().isEvaluatorWorkArea() && (this.evaluatee);
            },
            isEvaluator: function () {
                return this.workArea().isEvaluatorWorkArea();
            },
            isEvaluatee: function () {
                return this.evaluatee && (this.evaluatee.id === activeUserContextService.user.id);
            },
            isAssignedEvaluator: function () {
                return this.evaluatee.evalData.evaluatorId === activeUserContextService.user.id;
            }
        };
        var User = function () {};

        var loginUserData = {};
        var order = enums.Order;
        var context = new Context();
        var user = new User();



        var service = {
            setupContext: setupContext,
            setUser: setUser,
            load: load
        };
        return service;


        //loads user into application from login screen
        function setUser(userTemp) {
            if (userTemp) {
                loginUserData = userTemp;
            } else {
                console.log('Received No User');
            }
        }

        //Builds ORIENTATION_OPTIONS object and sets default workArea on the context and user objects and puts them on AUCS
        function setupContext() {
            if (!loginUserData) {
                console.log('No login or cached information.');
                $state.go('login');
                return $q.when();
            }
            function changeEvaluationTypesToWorkAreaTags(locationRoles) {
                for(var i in locationRoles) {
                    locationRoles[i].workAreaTag = workAreaService.getSingleTagOfRole(locationRoles[i].roleName, locationRoles[i].evaluationType);
                    delete locationRoles[i].evaluationType;
                }
            }
            function createOrientation(index, ungrouped) {
                if(!order[index]) {
                    return ungrouped[0];
                }
                var grouped = _.groupBy(ungrouped, order[index]);
                for(var i in grouped) {
                    grouped[i] = createOrientation(index+1, grouped[i]);
                }
                return grouped;
            }
            function defaultNavOption(index,  current, obj) {
                obj[order[index]] = Object.keys(current)[0];
                if (order[index + 1]) {
                    defaultNavOption(index + 1, current[obj[order[index]]], obj);
                }
                return obj
            }

            changeEvaluationTypesToWorkAreaTags(loginUserData.userOrientations);
            context.orientationOptions = createOrientation(0, loginUserData.userOrientations);
            var dNO = defaultNavOption(0, context.orientationOptions, {});
            var y = _.uniq(_.pluck(loginUserData.userOrientations, 'schoolYear')).length;
            var d = _.uniq(_.pluck(loginUserData.userOrientations, 'districtName')).length;
            var s = _.uniq(_.pluck(loginUserData.userOrientations, 'schoolName')).length;
            context.showOptions = !(y === 1 && d === 1 && s === 1);

            //NavOption is the only thing that remembers the users state, using navOption to traverse through
            // orientation will find you how the user is oriented
            //to find current execute context.navOption = opt;
            context.additionalWorkAreas = ['RS', 'VL'];
            context.orientation = activeUserContextService.getOrientationWithNav(0, context.orientationOptions, dNO);
            context.navOptions = dNO;
            context.frameworkContexts = [];
            user.id = loginUserData.id;
            user.firstName = loginUserData.firstName;
            user.lastName = loginUserData.lastName;
            user.displayName = loginUserData.displayName;
            user.evalData = loginUserData.evalData;
            activeUserContextService.user = user;
            activeUserContextService.context = context;
            //activeUserContextService.user = new User();
            //activeUserContextService.context = new Context();
            //
            //for(var i in user) {
            //    activeUserContextService['user'][i] = user[i];
            //}
            //for(var j in context) {
            //    activeUserContextService['context'][j] = context[j];
            //}
            activeUserContextService.save();
            return context.workArea().initializeWorkArea(activeUserContextService, true)
                .then(function () {
                    //evidenceCollectionService.startupFrameworks(context);
                });
        }

        function load() {
            var contextTemp = localStorageService.get('context');
            if(!contextTemp) {
                console.log('No cached data');
                $state.go('login');
            } else {
                var userTemp = localStorageService.get('user');
                for (var i in contextTemp) {
                   context[i] = contextTemp[i];
                }
                for (var i in userTemp) {
                    user[i] = userTemp[i];
                }
                activeUserContextService.user = user;
                activeUserContextService.context = context;

            }
            return $q.when();

        }
    }
}) ();