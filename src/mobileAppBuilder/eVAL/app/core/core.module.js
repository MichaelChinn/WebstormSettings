/**
 * Created by anne on 6/19/2015.
 */
(function () {
    'use strict';

    angular
        .module('stateeval.core', [
            'blocks.exception',
            'blocks.logger',
            'ui.router',                    // Routing                                                                        
            'LocalStorageModule',
            'ngCookies',
            'toastr',
            'lodash'
        ]);
})();

