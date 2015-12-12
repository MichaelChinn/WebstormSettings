
/**
 * Created by anne on 9/14/2015.
 */
(function() {
    'use strict';

    angular
        .module('stateeval.reports')
        .controller('summativeReportController', summativeReportController);

    summativeReportController.$inject = ['$http', '$q', 'logger', '$stateParams', '$state', 'config', 'enums', 'reportService', '$filter', 'activeUserContextService'];

    /* @ngInject */
    function summativeReportController($http, $q, logger, $stateParams, $state, config, enums, reportService, $filter, activeUserContextService) {
        var vm = this;
        vm.gridData = [];
        ////////////////////////////

        activate();

        function activate() {
            reportService.getSummativeRport().then(function (summativeReport) {                
                vm.gridData = summativeReport.items;
                dataSource.read();
            });
        }

        var dataSource = new kendo.data.DataSource({
            transport: {
                read: function(e) {
                    e.success(vm.gridData);
                    //e.error("XHR response", "status code", "error message");
                }
            }
        });

        vm.summativeReportGridOptions =
        {
            dataSource: dataSource,
            toolbar: ["pdf"],
            pdf:
            {
                fileName: "Summative Report.pdf",
                subject: "Summative Report",
                title:"Summative Report"
            },
            sortable: true,
            pageable: false,
            columns: [
                {
                    field: "name",
                    title: "Name",
                    width: "280px",                  
                },
                {
                    field: "evalType",
                    title: "Eval Type",
                    width: "100px"
                },
                {
                    field: "submitted",
                    title: "Submitted?",
                    width: "100px"
                },
                {
                    field: "criteria",
                    title: "Criteria",
                    width: "100px"
                },
                {
                    field: "growth",
                    title: "Growth",
                    width: "100px"
                },
                {
                    field: "final",
                    title: "Final",
                    width: "100px"
                },
                {
                    field: "c1",
                    title: "C1",
                    width: "100px"
                },
                {
                    field: "c2",
                    title: "C2",
                    width: "100px"
                },
                {
                    field: "c3",
                    title: "C3",
                    width: "100px"
                },
                {
                    field: "c4",
                    title: "C4",
                    width: "100px"
                },
                {
                    field: "c5",
                    title: "C5",
                    width: "100px"
                },
                {
                    field: "c6",
                    title: "C6",
                    width: "100px"
                },
                {
                    field: "c7",
                    title: "C7",
                    width: "100px"
                },
                {
                    field: "c8",
                    title: "C8",
                    width: "100px"
                },
                {
                    field: "self",
                    title: "Self",
                    width: "100px"
                },
                {
                    field: "evidence",
                    title: "Evidence",
                    width: "100px"
                }
            ]
        };
    }
})();