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
    public class StudentGrowthGoalBundleServiceTest
    {
        // Create a bundle, and make sure it persisted in db.
        [TestMethod]
        public void CreateStudentGrowthGoalBundle()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var goalBundleService = new StudentGrowthGoalBundleService();
                StudentGrowthGoalBundleModel bundleModel = TestHelper.CreateStudentGrowthGoalBundle("B1");
                bundleModel = goalBundleService.GetStudentGrowthGoalBundleById(bundleModel.Id);
                Assert.IsNotNull(bundleModel);

                transaction.Dispose();
            }
        }

        // Check to make sure each of the scalar properties are getting persisted
        [TestMethod]
        public void CreateGoalBundle_SetGetScalarProperties()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                // properties that can't be checked for equal value, 
                // such as dates, or 
                // read-only, such as LinkedToObservationTitle
                // require initialization with other objects, such as collections and objectID properties.

                List<string> ignoreList = new List<string>(){"CreationDateTime", "Goals"};

                var goalBundleService = new StudentGrowthGoalBundleService();

                StudentGrowthGoalBundleModel bundleModel = TestHelper.CreateStudentGrowthGoalBundleModel();

                // Makes sure all the basic properties have been set and have the same value when retrieved.
                StudentGrowthGoalBundleModel bundle1 = TestHelper.CreateStudentGrowthGoalBundle(bundleModel);
                StudentGrowthGoalBundleModel bundle2 = goalBundleService.GetStudentGrowthGoalBundleById(bundle1.Id);

                TestHelper.ComparePropertyValues(bundle1, bundle2, ignoreList);
                // Update the basic properties and make sure they come back with the changed values after update.
                bundle2.EvaluationId = 2;
                bundle2.Title = "title2";
                bundle2.WfState = (short)SEWfStateEnum.GOAL_BUNDLE_IN_STEP1;
                bundle2.Comments = "comments2";
                bundle2.Course = "course";
                bundle2.Grade = "grade";
                goalBundleService.UpdateStudentGrowthGoalBundle(bundle2);
                StudentGrowthGoalBundleModel bundle3 = goalBundleService.GetStudentGrowthGoalBundleById(bundle2.Id);

                TestHelper.ComparePropertyValues(bundle2, bundle3, ignoreList);
            }
        }

        // Create a goal bundle and an embedded goal. make sure the embedded goal is created.
        [TestMethod]
        public void StudentGrowthGoalBundle_AddedGoalShouldBePersisted()
        {
            FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);

            using (TransactionScope transaction = new TransactionScope())
            {
                StudentGrowthGoalBundleModel goalBundle = TestHelper.CreateStudentGrowthGoalBundleModelWithC3Goal("G1", framework);

                var goalBundleService = new StudentGrowthGoalBundleService();
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);
                Assert.AreEqual(1, goalBundle.Goals.Count);
                transaction.Dispose();
            }
        }

        // Create a bundle, add a goal and then save. Change the goal property and then update
        // through the bundle and verify that the goal property change persisted.

        [TestMethod]
        public void UpdateGoalProperty_GoalBundleUpdate()
        {
            FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);

            using (TransactionScope transaction = new TransactionScope())
            {
                StudentGrowthGoalBundleModel goalBundle = TestHelper.CreateStudentGrowthGoalBundleModelWithC3Goal("G1", framework);

                var goalBundleService = new StudentGrowthGoalBundleService();
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);
                Assert.AreEqual(1, goalBundle.Goals.Count);

                string newVal = "New Statement";
                StudentGrowthGoalModel goal = goalBundle.Goals[0];
                goal.GoalStatement = newVal;

                goalBundleService.UpdateStudentGrowthGoalBundle(goalBundle);
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);
                Assert.AreEqual(newVal, goalBundle.Goals[0].GoalStatement);

                transaction.Dispose();
            }
        }

        // Creata a bundle, add prompts, update: this will result in FormPromptResponse records being persisted.
        // Each FormPromptResponse record has the FormPromptID in it.
        // When the goal.Prompts property is retrieved again, it will contain FormPrompts with the Response in it

        // Retrieve the bundle and verify that the correct form prompts are loaded
        [TestMethod]
        public void UpdateBundle_GoalPrompts()
        {
            FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);

            using (TransactionScope transaction = new TransactionScope())
            {
                StudentGrowthGoalBundleModel goalBundle = TestHelper.CreateStudentGrowthGoalBundleModelWithC3Goal("G1", framework);

                var goalBundleService = new StudentGrowthGoalBundleService();
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);


                var formPromptService = new StudentGrowthFormPromptService();

                List<StudentGrowthFormPromptModel> prompts = formPromptService.GetFormPrompts(DefaultTeacher.UserId, 
                                                                                 Convert.ToInt16(SEEvaluationTypeEnum.TEACHER),
                                                                                 DefaultTeacher.DistrictCode,
                                                                                 TestHelper.DEFAULT_SCHOOLYEAR)
                                                                .Where(x => x.FrameworkNodeShortName == "C3").ToList();

                long promptCountBefore = prompts.Count;
                long promptIdBefore = prompts[0].Id;

                StudentGrowthGoalModel goal = goalBundle.Goals[0];
                goal.Prompts = prompts;
                goalBundleService.UpdateStudentGrowthGoalBundle(goalBundle);

                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);

                goal = goalBundle.Goals[0];
                Assert.AreEqual(promptCountBefore, goal.Prompts.Count);
                Assert.IsNotNull(goal.Prompts.Find(x => x.Id == promptIdBefore));
            }
        }

        // Creata a bundle, add prompts, update: this will result in FormPromptResponse records being persisted.
        // Each FormPromptResponse record has the FormPromptID in it.
        // When the goal.Prompts property is retrieved again, it will contain FormPrompts with the Response in it

        // Respond to a prompt, update, then retrieve and verify the response was persisted
        [TestMethod]
        public void UpdateBundle_GoalPromptResponse()
        {
            FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);

            using (TransactionScope transaction = new TransactionScope())
            {
                StudentGrowthGoalBundleModel goalBundle = TestHelper.CreateStudentGrowthGoalBundleModelWithC3Goal("G1", framework);

                var goalBundleService = new StudentGrowthGoalBundleService();
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);


                var formPromptService = new StudentGrowthFormPromptService();

                List<StudentGrowthFormPromptModel> prompts = formPromptService.GetFormPrompts(DefaultTeacher.UserId,
                                                                                 Convert.ToInt16(SEEvaluationTypeEnum.TEACHER),
                                                                                 DefaultTeacher.DistrictCode,
                                                                                 TestHelper.DEFAULT_SCHOOLYEAR)
                                                                .Where(x => x.FrameworkNodeShortName == "C3").ToList();

                StudentGrowthGoalModel goal = goalBundle.Goals[0];
                goal.Prompts = prompts;
                goalBundleService.UpdateStudentGrowthGoalBundle(goalBundle);

                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);

                string testResponse = "Test Response";

                goal = goalBundle.Goals[0];
                goal.Prompts[0].Response = testResponse;
                goalBundleService.UpdateStudentGrowthGoalBundle(goalBundle);

                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);
                Assert.IsNotNull(goalBundle.Goals[0].Prompts.FirstOrDefault(y => y.Response == testResponse));
            }
        }

        // Create a bundle, delete it (no goals)
        [TestMethod]
        public void DeleteBundle_StandAlone()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var goalBundleService = new StudentGrowthGoalBundleService();
                StudentGrowthGoalBundleModel bundleModel = TestHelper.CreateStudentGrowthGoalBundle("B1");
                bundleModel = goalBundleService.GetStudentGrowthGoalBundleById(bundleModel.Id);
                Assert.IsNotNull(bundleModel);

                goalBundleService.DeleteStudentGrowthGoalBundle(bundleModel.Id);

                transaction.Dispose();
            }
        }

        // Delete a bundle with embedded goals
        [TestMethod]
        public void DeleteBundleWithGoalsAndPrompts()
        {
            FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);

            using (TransactionScope transaction = new TransactionScope())
            {
                StudentGrowthGoalBundleModel goalBundle = TestHelper.CreateStudentGrowthGoalBundleModelWithC3Goal("G1", framework);

                var goalBundleService = new StudentGrowthGoalBundleService();
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);


                var formPromptService = new StudentGrowthFormPromptService();

                List<StudentGrowthFormPromptModel> prompts = formPromptService.GetFormPrompts(DefaultTeacher.UserId,
                                                                                 Convert.ToInt16(SEEvaluationTypeEnum.TEACHER),
                                                                                 DefaultTeacher.DistrictCode,
                                                                                 TestHelper.DEFAULT_SCHOOLYEAR)
                                                                .Where(x => x.FrameworkNodeShortName == "C3").ToList();

                StudentGrowthGoalModel goal = goalBundle.Goals[0];
                goal.Prompts = prompts;
                goalBundleService.UpdateStudentGrowthGoalBundle(goalBundle);

                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);

                string testResponse = "Test Response";

                goal = goalBundle.Goals[0];
                goal.Prompts[0].Response = testResponse;
                goalBundleService.UpdateStudentGrowthGoalBundle(goalBundle);

                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);
                Assert.IsNotNull(goal.Prompts.Any(y => y.Response == testResponse));

                goalBundleService.DeleteStudentGrowthGoalBundle(goalBundle.Id);
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);
                Assert.IsNull(goalBundle);

                StateEvalEntities evalEntities = new StateEvalEntities();
                Assert.AreEqual(0, evalEntities.SEFormPromptResponses.ToList().Count());
                Assert.AreEqual(0, evalEntities.SEStudentGrowthGoals.ToList().Count());
                Assert.AreEqual(0, evalEntities.SEStudentGrowthGoalBundles.ToList().Count());

                transaction.Dispose();
            }
        }


    }
}
