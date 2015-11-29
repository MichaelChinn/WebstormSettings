define(['jquery'],
    function ($) {

 
        var reportError = function (req, status, error) {
            var msg = 'An unexpected error occurred.';
            navigator.notification.alert(msg, null, 'Notification');
        },

        getWithNoParam = function (getFcn) {
            return $.Deferred(function (def) {
                getFcn(
                        {
                            success: function (data) {
                                def.resolve(data);
                             },
                            error: function (req, status, error) {
                                def.reject();
                                reportError(req, status, error);
                            }
                        });
            }).promise();
        },

        getWithOneParam = function (getFcn, param) {
            return $.Deferred(function (def) {
                getFcn(
                        {
                            success: function (data) {
                                 def.resolve(data);
                             },
                            error: function (req, status, error) {
                                def.reject();
                                reportError(req, status, error);
                            }
                        }, param);
            }).promise();
        },
        getWithTwoParams = function (getFcn, param1, param2) {
            return $.Deferred(function (def) {
                getFcn(
                {
                    success: function (data) {
                        def.resolve(data);
                    },
                    error: function (req, status, error) {
                        def.reject();
                        reportError(req, status, error);
                    }
                }, param1, param2);
            }).promise();
        },
        getWithThreeParams = function (getFcn, param1, param2, param3) {
            return $.Deferred(function (def) {
                getFcn(
                        {
                            success: function (data) {
                                def.resolve(data);
                            },
                            error: function (req, status, error) {
                                def.reject();
                                reportError(req, status, error);
                            }
                        }, param1, param2, param3);
            }).promise();
        },
         getWithFourParams = function (getFcn, param1, param2, param3, param4) {
             return $.Deferred(function (def) {
                 getFcn(
                        {
                            success: function (data) {
                                def.resolve(data);
                            },
                            error: function (req, status, error) {
                                def.reject();
                                reportError(req, status, error);
                            }
                        }, param1, param2, param3, param4);
             }).promise();
         },
         getWithFiveParams = function (getFcn, param1, param2, param3, param4, param5) {
             return $.Deferred(function (def) {
                 getFcn(
                        {
                            success: function (data) {
                                def.resolve(data);
                            },
                            error: function (req, status, error) {
                                def.reject();
                                reportError(req, status, error);
                            }
                        }, param1, param2, param3, param4, param5);
             }).promise();
         },
         getWithSixParams = function (getFcn, param1, param2, param3, param4, param5, param6) {
             return $.Deferred(function (def) {
                 getFcn(
                        {
                            success: function (data) {
                                def.resolve(data);
                            },
                            error: function (req, status, error) {
                                def.reject();
                                reportError(req, status, error);
                            }
                        }, param1, param2, param3, param4, param5, param6);
             }).promise();
         }
        return {
            getWithNoParam: getWithNoParam,
            getWithOneParam: getWithOneParam,
            getWithTwoParams: getWithTwoParams,
            getWithThreeParams: getWithThreeParams,
            getWithFourParams: getWithFourParams,
            getWithFiveParams: getWithFiveParams,
            getWithSixParams: getWithSixParams

        };
    });

