using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEval.Core.Services;

namespace StateEval.Core.Test
{
    [TestClass]
    public class EvalSessionServiceTest
    {
        EvalSessionService evalSessionService = new EvalSessionService();

        [TestMethod]
        public void GetEvalSessionByIdTest()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var evalSessionModel = TestHelper.CreateEvalSessionModel("S1", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId, SEEvaluationTypeEnum.TEACHER);
                var evalSessionId = evalSessionService.SaveEvalSession(evalSessionModel);
                evalSessionModel = null;
                Assert.IsTrue(evalSessionId > 0);

                evalSessionModel = evalSessionService.GetEvalSessionById(evalSessionId);
                Assert.IsNotNull(evalSessionModel);
                Assert.AreEqual(evalSessionModel.EvaluatorId, DefaultPrincipal.UserId);
                Assert.AreEqual(evalSessionModel.EvaluateeId, DefaultTeacher.UserId);
                transaction.Dispose();
            }
        }

        [TestMethod]
        public void GetEvalSessions()
        {
            using (TransactionScope transaction = new TransactionScope())
            {

                var evalSessionModel = TestHelper.CreateEvalSessionModel("S1", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId,
                    SEEvaluationTypeEnum.TEACHER);
                evalSessionService.SaveEvalSession(evalSessionModel);

                var evalSessions = evalSessionService.GetEvalSessions(new EvalSessionRequestModel
                {
                    EvaluationId = (int)evalSessionModel.EvaluationId,
                    DistrictCode = evalSessionModel.DistrictCode,
                    EvaluateeId = (int)(evalSessionModel.EvaluateeId ?? 0),
                    EvaluationType = evalSessionModel.EvaluationType,
                    EvaluatorId = (int)(evalSessionModel.EvaluatorId ?? 0),
                    SchoolCode = evalSessionModel.SchoolCode,
                    SchoolYear = evalSessionModel.SchoolYear
                });

                Assert.IsNotNull(evalSessions);
                Assert.IsTrue(evalSessions.Count > 0);
            }
        }

        [TestMethod]
        public void SaveEvalSessionTest()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var evalSessionModel = TestHelper.CreateEvalSessionModel("S1", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId,
                    SEEvaluationTypeEnum.TEACHER);
                var evalSessionId = evalSessionService.SaveEvalSession(evalSessionModel);
                evalSessionModel = null;
                Assert.IsTrue(evalSessionId > 0);
                evalSessionModel = evalSessionService.GetEvalSessionById(evalSessionId);
                Assert.IsNotNull(evalSessionModel);
                transaction.Dispose();
            }
        }

        [TestMethod]
        public void UpdateEvalSessinNotes()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var evalSessionModel = TestHelper.CreateEvalSessionModel("S1", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId,
                    SEEvaluationTypeEnum.TEACHER);
                evalSessionModel.ObserveNotes = "Test";
                evalSessionModel.Id = evalSessionService.SaveEvalSession(evalSessionModel);
                evalSessionModel.ObserveNotes = "Test1";
                evalSessionService.UpdateEvalSessinNotes(evalSessionModel);
                long evalSessionId = evalSessionModel.Id;

                evalSessionModel = null;
                evalSessionModel = evalSessionService.GetEvalSessionById(evalSessionId);
                Assert.IsNotNull(evalSessionModel);
                Assert.AreEqual(evalSessionModel.ObserveNotes, "Test1");
            }
        }

        [TestMethod]
        public void SaveRubricRowFocusesTest()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var evalSessionModel = TestHelper.CreateEvalSessionModel("S3", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId,
                    SEEvaluationTypeEnum.TEACHER);
                var evalSessionId = evalSessionService.SaveEvalSession(evalSessionModel);
                evalSessionModel.Id = evalSessionId;

                evalSessionModel.RubricRows = new List<RubricRowModel>
                {
                    new RubricRowModel
                    {
                        Id = 1
                    }
                };

                evalSessionService.SaveRubricRowFocuses(evalSessionModel);

                var evalSessionDb =
                    evalSessionService.EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionModel.Id);

                Assert.IsNotNull(evalSessionDb);
                Assert.AreEqual(evalSessionDb.SERubricRows.Count, 1);

                evalSessionModel.RubricRows = new List<RubricRowModel>
                {
                    new RubricRowModel
                    {
                        Id = 2
                    }
                };

                evalSessionService.SaveRubricRowFocuses(evalSessionModel);

                evalSessionDb =
                    evalSessionService.EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionModel.Id);

                Assert.IsNotNull(evalSessionDb);
                Assert.AreEqual(evalSessionDb.SERubricRows.Count, 1);
            };
        }
    }
}
