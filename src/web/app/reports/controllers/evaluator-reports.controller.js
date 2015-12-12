/**
 * Created by anne on 9/14/2015.
 */
(function() {
    'use strict';

    angular
        .module('stateeval.reports')
        .controller('evaluatorReportsController', evaluatorReportsController);

    evaluatorReportsController.$inject = [];

    /* @ngInject */
    function evaluatorReportsController() {
        var vm = this;
        vm.reports = [];
        ////////////////////////////

        activate();

        function activate() {
            vm.reports = [];
            vm.reports.push({
                    title: "Principal Summative Report (Export to CSV option)",
                    url: '#/report-home/reports/summaive-report'
                },
                {
                    title: "Principal Summative Score Report",
                    url: '#/report-home/reports/summaive-report'
                },
                {
                    title: "Principal Score Alignment"
                },
                {
                    title: "Principal Student Growth Goal Form Report"
                },
                {
                    title: "Principal Professional Development Goal Form Report"
                },
                {
                    title: 'Extract All'
                },
                {
                    title: 'District Summative Score Report'
                },
                {
                    title: 'District EOY Principal Report - Excel'
                },
                {
                    title: 'District EOY Teacher Report - Excel'
                }
            );
        }
    }

})();
