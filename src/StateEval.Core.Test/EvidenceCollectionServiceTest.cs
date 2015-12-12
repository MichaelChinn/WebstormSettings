using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Test
{
    [TestClass]
    public class EvidenceCollectionServiceTest
    {
        // Create a bundle, and make sure it persisted in db.
        [TestMethod]
        public void CreateObservationEvidenceCollection()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
               
                var service = new EvidenceCollectionService();
                EvidenceCollectionModel model = TestHelper.CreateObservationEvidenceCollection();
                model = service.GetEvidenceCollectionById(model.Id);
                Assert.IsNotNull(model);

                transaction.Dispose();
            }
        }

        // Create a bundle, and make sure it persisted in db.
        [TestMethod]
        public void CreateStudentGrowthGoalBundleEvidenceCollection()
        {
            using (TransactionScope transaction = new TransactionScope())
            {

                var service = new EvidenceCollectionService();
                EvidenceCollectionModel model = TestHelper.CreateSGGoalBundleEvidenceCollection();
                model = service.GetEvidenceCollectionById(model.Id);
                Assert.IsNotNull(model);

                transaction.Dispose();
            }
        }
    }
}
