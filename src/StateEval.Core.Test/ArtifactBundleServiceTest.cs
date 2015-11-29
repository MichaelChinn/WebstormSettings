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
    public class ArtifactBundleServiceTest
    {
        // Create a lib item, and make sure it persisted in db.
        [TestMethod]
        public void CreateLibItem()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactLibItemService = new ArtifactLibItemService();

                ArtifactLibItemModel libItemModel = TestHelper.CreateArtifactLibItem("L1");
                libItemModel = artifactLibItemService.GetArtifactLibItemById(libItemModel.Id);
                Assert.IsNotNull(libItemModel);

                transaction.Dispose();
            }
        }

        // Create a lib item then delete
        [TestMethod]
        public void DeleteLibItem()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactLibItemService = new ArtifactLibItemService();

                ArtifactLibItemModel libItemModel = TestHelper.CreateArtifactLibItem("L1");
                libItemModel = artifactLibItemService.GetArtifactLibItemById(libItemModel.Id);
                Assert.IsNotNull(libItemModel);

                artifactLibItemService.DeleteArtifactLibItem(libItemModel.Id);
                libItemModel = artifactLibItemService.GetArtifactLibItemById(libItemModel.Id);
                Assert.IsNull(libItemModel);

                StateEvalEntities evalEntities = new StateEvalEntities();
                Assert.AreEqual(0, evalEntities.SEArtifactLibItems.ToList().Count());

                transaction.Dispose();
            }
        }


        // Create a bundle, and make sure it persisted in db.
        [TestMethod]
        public void CreateArtifactBundle()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1");
                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);
                Assert.IsNotNull(bundleModel);

                transaction.Dispose();
            }
        }

        // Check to make sure each of the scalar properties are getting persisted
        [TestMethod]
        public void CreateArtifactBundle_SetGetScalarProperties()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                // properties that can't be checked for equal value, 
                // such as dates, or 
                // read-only, such as LinkedToObservationTitle
                // require initialization with other objects, such as collections and objectID properties.

                List<string> ignoreList = new List<string>(){"CreationDateTime", "SubmitDateTime", "RejectDateTime", "LinkedToObservationTitle", "LastModifiedDateTime", "CreatedByDisplayName",
                                        "LinkedToStudentGrowthGoalTitle", "AlignedRubricRows", "LibItems", "RubricRowEvaluations", "RubricRowAnnotations", "EvalSessionId", "StudentGrowthGoalId"};       

                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel artifactBundleModel = new ArtifactBundleModel
                {
                    EvaluationId = 1,
                    CreatedByUserId = 1,
                    Title = "title",
                    WfState = (long)SEWfStateEnum.ARTIFACT,
                    ArtifactType = (short)SEArtifactTypeEnum.STANDARD,
                    Context = "Context",
                    AlignedRubricRows = new List<RubricRowModel>(),
                };

                // Makes sure all the basic properties have been set and have the same value when retrieved.
                ArtifactBundleModel artifactBundleModel1 = TestHelper.CreateArtifactBundle(artifactBundleModel);
                ArtifactBundleModel artifactBundleModel2 = artifactBundleService.GetArtifactBundleById(artifactBundleModel1.Id);

                TestHelper.ComparePropertyValues(artifactBundleModel1, artifactBundleModel2, ignoreList);
                // Update the basic properties and make sure they come back with the changed values after update.
                artifactBundleModel2.EvaluationId = 2;
                artifactBundleModel2.CreatedByUserId = 2;
                artifactBundleModel2.Title = "title2";
                artifactBundleModel2.WfState = (long)SEWfStateEnum.ARTIFACT_REJECTED;
                artifactBundleModel2.ArtifactType = (short)SEArtifactTypeEnum.OBSERVATION;
                artifactBundleModel2.Context = "context2";
                artifactBundleService.UpdateArtifactBundle(artifactBundleModel2);
                ArtifactBundleModel artifactBundleModel3 = artifactBundleService.GetArtifactBundleById(artifactBundleModel2.Id);

                TestHelper.ComparePropertyValues(artifactBundleModel2, artifactBundleModel3, ignoreList);     
            }
        }

        // Check defaults for object and collection properties
        [TestMethod]
        public void CreateArtifactBundleTest_GetNoRelations()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel artifactBundleModel1 = TestHelper.CreateArtifactBundle("A1");
                ArtifactBundleModel  artifactBundleModel2 = artifactBundleService.GetArtifactBundleById(artifactBundleModel1.Id);
                Assert.IsNotNull(artifactBundleModel2);
                Assert.AreEqual(0, artifactBundleModel2.AlignedRubricRows.Count);
                Assert.AreEqual(0, artifactBundleModel2.LibItems.Count);
            //    Assert.IsNull(artifactBundleModel2.EvalSessionId);
             //   Assert.IsNull(artifactBundleModel2.StudentGrowthGoalBundleId);
            }
        }

        // Make sure that an aligned rubric row does not get inserted as a new record
        [TestMethod]
        public void UpdateArtifactBundle_AlignedRubricRowsDoNotCreateNewRecord()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                List<RubricRowModel> rubricRows = new List<RubricRowModel>();
                FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
                FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

                RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1");
                bundleModel.AlignedRubricRows.Add(rr1a);
                artifactBundleService.UpdateArtifactBundle(bundleModel);

                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                RubricRowModel A1_rr1a = bundleModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1a");

                Assert.AreEqual(rr1a.Id, A1_rr1a.Id, "aligned rubric row should not have added new row to db");
                transaction.Dispose();
            }
        }

        // Make sure that a lib item that is created and then used by an artifact does
        // not create a new record.
        [TestMethod]
        public void UpdateArtifactBundle_SharedLibItemsDoNotCreateNewRecord()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var artifactLibItemService = new ArtifactLibItemService();

                List<ArtifactLibItemModel> libItems = new List<ArtifactLibItemModel>();

                ArtifactLibItemModel libItemModel1 = TestHelper.CreateArtifactLibItem("L1");
                long libItemId = libItemModel1.Id;

                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1");
                bundleModel.LibItems.Add(libItemModel1);
                artifactBundleService.UpdateArtifactBundle(bundleModel);

                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                Assert.AreEqual(1, bundleModel.LibItems.Count);
                ArtifactLibItemModel A1_li = bundleModel.LibItems.FirstOrDefault(x => x.Title == "L1");
                
                Assert.AreEqual(libItemId, bundleModel.LibItems[0].Id, "added libItem should not have added new row to db");
                transaction.Dispose();
            }
        }

        // Make sure a lib item added to artifact before creation persists
        [TestMethod]
        public void CreateArtifactBundleWithNewLibItem_DuringCreate()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundleModel("A1");
                ArtifactLibItemModel libItemModel = TestHelper.CreateArtifactLibItemModel("L1");
                bundleModel.LibItems.Add(libItemModel);
                bundleModel = TestHelper.CreateArtifactBundle(bundleModel);
        
                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                Assert.AreEqual(1, bundleModel.LibItems.Count);
                Assert.IsNotNull(bundleModel.LibItems.FirstOrDefault(x => x.Title == "L1"));

                transaction.Dispose();
            }
        }

        // Make sure a new artifact that relates to an existing lib item persists relationship
        // and doesn't create a new lib item record
        [TestMethod]
        public void CreateArtifactBundleWithNewLibItem_DuringUpdate()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                // Create bundle first, then add libitem and then udpate

                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1");
                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                ArtifactLibItemModel libItemModel1 = TestHelper.CreateArtifactLibItemModel("L1");
                bundleModel.LibItems.Add(libItemModel1);
                artifactBundleService.UpdateArtifactBundle(bundleModel);
                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                Assert.AreEqual(1, bundleModel.LibItems.Count);
                Assert.IsNotNull(bundleModel.LibItems.FirstOrDefault(x => x.Title == "L1"));

                transaction.Dispose();
            }
        }

        // Create a lib item, update its title and save it and check if new title persisted.
        [TestMethod]
        public void UpdateLibItemProperty_StandAlone()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactLibItemService = new ArtifactLibItemService();

                // Create the lib item with title L1
                ArtifactLibItemModel libItemModel = TestHelper.CreateArtifactLibItem("L1");
                libItemModel = artifactLibItemService.GetArtifactLibItemById(libItemModel.Id);
                Assert.AreEqual("L1", libItemModel.Title);

                // Change the title and update it
                // Retrieve it and verify it has been updated

                libItemModel.Title = "L2";
                artifactLibItemService.UpdateArtifactLibItem(libItemModel);
                libItemModel = artifactLibItemService.GetArtifactLibItemById(libItemModel.Id);
                Assert.AreEqual("L2", libItemModel.Title);

                transaction.Dispose();
            }
        }

        // Create a lib item. change the title and relate it to an artifact before it is created.
        // Make sure the changed title persists when artifact is created.
        [TestMethod]
        public void UpdateLibItemProperty_ArtifactBundleUpdate()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var artifactLibItemService = new ArtifactLibItemService();

                // Create the lib item with title L1
                ArtifactLibItemModel libItemModel = TestHelper.CreateArtifactLibItem("L1");
                libItemModel = artifactLibItemService.GetArtifactLibItemById(libItemModel.Id);
                Assert.AreEqual("L1", libItemModel.Title);

                // Change the title and link it with an artifact bundle
                // Title should be updated as well as linkage
                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1");
                bundleModel.LibItems.Add(libItemModel);
                libItemModel.Title = "L2";
                artifactBundleService.UpdateArtifactBundle(bundleModel);

                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);
                Assert.AreEqual(1, bundleModel.LibItems.Count);
                Assert.AreEqual("L2", bundleModel.LibItems[0].Title);

                // Need new context to avoid getting cached version
                artifactLibItemService = new ArtifactLibItemService();
                libItemModel = artifactLibItemService.GetArtifactLibItemById(libItemModel.Id);
                Assert.AreEqual("L2", libItemModel.Title);

                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);
                Assert.AreEqual(1, bundleModel.LibItems.Count);

                transaction.Dispose();
            }
        }

        // Create a studentgrowthgoalbundle with an embedded goal then create a link to it
        // from an artifact. make sure the relationship doesn't create a new goal
        [TestMethod]
        public void UpdateArtifactBundle_LinkToGoalDoesNotCreateNewRecord()
        {
            FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);

            using (TransactionScope transaction = new TransactionScope())
            {
                List<ArtifactLibItemModel> libItems = new List<ArtifactLibItemModel>();

                StudentGrowthGoalBundleModel goalBundle = TestHelper.CreateStudentGrowthGoalBundleModelWithC3Goal("G1", framework);
                Assert.AreEqual(1, goalBundle.Goals.Count);

                var goalBundleService = new StudentGrowthGoalBundleService();
                goalBundle = goalBundleService.GetStudentGrowthGoalBundleById(goalBundle.Id);
                StudentGrowthGoalModel goalModel = goalBundle.Goals[0];

                ArtifactBundleModel artifactBundleModel1 = TestHelper.CreateArtifactBundle("A1");
              //  artifactBundleModel1.StudentGrowthGoalBundleId = goalModel.Id;

                var artifactBundleService = new ArtifactBundleService();
                artifactBundleService.UpdateArtifactBundle(artifactBundleModel1);

           //     Assert.AreEqual(goalBundle.Goals[0].Id, artifactBundleModel1.StudentGrowthGoalBundleId, "LinkedToGoalBundle should not have added new row to db");
                transaction.Dispose();
            }
        }

        // Create an artifact and then add/remove the aligned rubric rows with updates
        // after each change verifying that the expected list is persisted after each update
        [TestMethod]
        public void UpdateArtifactBundle_ChangeRubricRowAlignment()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                List<RubricRowModel> rubricRows = new List<RubricRowModel>();
                FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
                FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");
                
                RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");
                RubricRowModel rr1b = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1b");
                RubricRowModel rr1c = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1c");


                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                artifactBundleModel.AlignedRubricRows.Add(rr1a);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsTrue(artifactBundleModel.AlignedRubricRows.Count == 1);
                Assert.IsNotNull(artifactBundleModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1a"));


                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                artifactBundleModel.AlignedRubricRows.Clear();
                artifactBundleModel.AlignedRubricRows.Add(rr1b);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsTrue(artifactBundleModel.AlignedRubricRows.Count == 1);
                Assert.IsNotNull(artifactBundleModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1b"));


                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                artifactBundleModel.AlignedRubricRows.Add(rr1a);
                artifactBundleModel.AlignedRubricRows.Add(rr1c);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsTrue(artifactBundleModel.AlignedRubricRows.Count == 3);
                Assert.IsNotNull(artifactBundleModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1a"));
                Assert.IsNotNull(artifactBundleModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1b"));
                Assert.IsNotNull(artifactBundleModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1c"));


                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                artifactBundleModel.AlignedRubricRows.Clear();
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsTrue(artifactBundleModel.AlignedRubricRows.Count == 0);

                transaction.Dispose();
            }

        }

        // Create an artifact and then add/remove lib items with updates after
        // each change verifying that the expiected list is persisted after each update.
        [TestMethod]
        public void UpdateArtifactBundle_ChangeLibItems()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                ArtifactLibItemModel li1 = TestHelper.CreateArtifactLibItemModel("L1");
                ArtifactLibItemModel li2 = TestHelper.CreateArtifactLibItemModel("L2");
                ArtifactLibItemModel li3 = TestHelper.CreateArtifactLibItemModel("L3");

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                artifactBundleModel.LibItems.Add(li1);
                artifactBundleModel.LibItems.Add(li2);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsNotNull(artifactBundleModel);
                Assert.IsTrue(artifactBundleModel.LibItems.Count == 2);
                Assert.IsNotNull(artifactBundleModel.LibItems.FirstOrDefault(x => x.Title == "L1"));
                Assert.IsNotNull(artifactBundleModel.LibItems.FirstOrDefault(x => x.Title == "L2"));

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                artifactBundleModel.LibItems.Clear();
                artifactBundleModel.LibItems.Add(li2);
                artifactBundleModel.LibItems.Add(li3);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsTrue(artifactBundleModel.LibItems.Count == 2);
                Assert.IsNotNull(artifactBundleModel.LibItems.FirstOrDefault(x => x.Title == "L2"));
                Assert.IsNotNull(artifactBundleModel.LibItems.FirstOrDefault(x => x.Title == "L3"));


                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                artifactBundleModel.LibItems.Clear();
                artifactBundleModel.LibItems.Add(li1);
                artifactBundleModel.LibItems.Add(li2);
                artifactBundleModel.LibItems.Add(li3);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsTrue(artifactBundleModel.LibItems.Count == 3);
                Assert.IsNotNull(artifactBundleModel.LibItems.FirstOrDefault(x => x.Title == "L1"));
                Assert.IsNotNull(artifactBundleModel.LibItems.FirstOrDefault(x => x.Title == "L2"));
                Assert.IsNotNull(artifactBundleModel.LibItems.FirstOrDefault(x => x.Title == "L3"));

                transaction.Dispose();
            }

        }

        // Create an artifact and then add multiple rubric row evaluations through an update and
        // make sure the artifact can be deleted.
        [TestMethod]
        public void DeleteArtifactBundleWithRubricRowEvaluations()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                List<RubricRowModel> rubricRows = new List<RubricRowModel>();
                FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
                FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

                RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                RubricRowEvaluationModel rrEvalModel = TestHelper.CreateRubricRowEvaluation(artifactBundleModel, rr1a.Id);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);

                artifactBandleService = new ArtifactBundleService();
                artifactBandleService.DeleteArtifactBundle(artifactBundleModel.Id);

                Assert.IsNull(artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id));

                transaction.Dispose();
            }
        }

        // Create an artifact and then add multiple rubric row annotations through an update and
        // make sure the artifact can be deleted.
        [TestMethod]
        public void DeleteArtifactBundleWithRubricRowAnnotations()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                List<RubricRowModel> rubricRows = new List<RubricRowModel>();
                FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
                FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

                RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                RubricRowAnnotationModel annotationModel = TestHelper.CreateRubricRowAnnotation(artifactBundleModel.Id, rr1a.Id, "Test");
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);

                artifactBandleService = new ArtifactBundleService();
                artifactBandleService.DeleteArtifactBundle(artifactBundleModel.Id);

                Assert.IsNull(artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id));

                transaction.Dispose();
            }
        }

        // Create an artifact and then add multiple rubric rows through an update and
        // make sure the artifact can be deleted.
        [TestMethod]
        public void DeleteArtifactBundleWithRubricRows()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                List<RubricRowModel> rubricRows = new List<RubricRowModel>();
                FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
                FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

                RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");
                RubricRowModel rr1b = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1b");
                RubricRowModel rr1c = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1c");

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                artifactBundleModel.AlignedRubricRows.Add(rr1a);
                artifactBundleModel.AlignedRubricRows.Add(rr1b);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);

                artifactBandleService = new ArtifactBundleService();
                artifactBandleService.DeleteArtifactBundle(artifactBundleModel.Id);

                Assert.IsNull(artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id));

                transaction.Dispose();
            }
        }

        // Create an artifact and then add multiple lib items through an udpate and
        // make sure the artifact can be deleted.
        [TestMethod]
        public void DeleteArtifactBundleWithLibItems()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                ArtifactLibItemModel li1 = TestHelper.CreateArtifactLibItemModel("L1");
                ArtifactLibItemModel li2 = TestHelper.CreateArtifactLibItemModel("L2");

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                artifactBundleModel.LibItems.Add(li1);
                artifactBundleModel.LibItems.Add(li2);
                artifactBandleService.UpdateArtifactBundle(artifactBundleModel);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);

                artifactBandleService = new ArtifactBundleService();
                artifactBandleService.DeleteArtifactBundle(artifactBundleModel.Id);

                Assert.IsNull(artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id));

                transaction.Dispose();
            }
        }

        // Reject an artifact bundle
        [TestMethod]
        public void RejectArtifactBundle()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                artifactBundleModel = artifactBundleService.GetArtifactBundleById(artifactBundleModel.Id);
                Assert.IsNotNull(artifactBundleModel);

                List<CommunicationModel> communications = new List<CommunicationModel>();
                communications.Add( new CommunicationModel {
                    Message = "PR Message",
                    CreatedByUserId = DefaultPrincipal.UserId,
                });

                ArtifactBundleRejectionModel rejectionModel = new ArtifactBundleRejectionModel
                {
                    CreatedByUserId = DefaultPrincipal.UserId,
                    ArtifactBundleId = artifactBundleModel.Id,
                    RejectionType = Convert.ToInt16(SEArtifactBundleRejectionTypeEnum.NON_ESSENTIAL),
                    Communications = communications
                };

                rejectionModel = artifactBundleService.RejectArtifactBundle(rejectionModel);
                
                Assert.IsNotNull(rejectionModel);
                Assert.AreEqual(1, rejectionModel.Communications.Count);
                Assert.AreEqual("PR Message", rejectionModel.Communications[0].Message);
                Assert.AreEqual(DefaultPrincipal.UserId, rejectionModel.Communications[0].CreatedByUserId);

                rejectionModel.Communications.Add(new CommunicationModel {
                    Message = "TR Message",
                    CreatedByUserId = DefaultTeacher.UserId,
                });

    
                artifactBundleService.UpdateArtifactBundleRejection(rejectionModel);

                rejectionModel = artifactBundleService.GetArtifactBundleRejectionById(rejectionModel.Id);
                Assert.AreEqual(2, rejectionModel.Communications.Count);
                Assert.AreEqual("TR Message", rejectionModel.Communications[1].Message);
                Assert.AreEqual(DefaultTeacher.UserId, rejectionModel.Communications[1].CreatedByUserId);
            }
        }


    }
}
