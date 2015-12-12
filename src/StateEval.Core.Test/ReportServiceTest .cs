using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Services;

namespace StateEval.Core.Test
{
    [TestClass]
    public class ReportServiceTest
    {
        ReportService reportService = new ReportService();
        

        [TestMethod]
        public void GetSummativeReportTest()
        {
            using (TransactionScope transactionScope = new TransactionScope())
            {
                var summativeReport = reportService.GetSummativeReport();

            }
        }
    }
}
