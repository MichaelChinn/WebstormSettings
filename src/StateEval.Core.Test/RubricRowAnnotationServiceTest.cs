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
    public class RubricRowAnnotationServiceTest
    {
        // Create one, and make sure it persisted in db.
        [TestMethod]
        public void SaveRubricRowAnnotation()
        {
            var rubricRowModel = new RubricRowAnnotationModel
            {
                EvalSessionID = 1,
                RubricRowID = 1,
                UserID = 245,
                Annotation = "Test",
            };
        }

        // Create and then delete     
    }
}
