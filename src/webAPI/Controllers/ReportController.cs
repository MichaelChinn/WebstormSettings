using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Models.Report;
using StateEval.Core.Services;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class ReportController : BaseApiController
    {
        private readonly ReportService reportService = new ReportService();

        [Route("api/reports/summativereport")]
        [HttpGet]
        public SummativeReportModel GetSummativeReport()
        {
            return reportService.GetSummativeReport();
        }
    }
}