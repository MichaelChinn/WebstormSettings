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
using StateEval.Core.RequestModel;
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Test
{
    [TestClass]
    public class ArtifactBundleServiceTest
    {
        // Create a bundle, and make sure it persisted in db.
        [TestMethod]
        public void CreateArtifactBundle()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);

                artifactBundleService = new ArtifactBundleService();
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
                // shortname, title are set in create, so we can't test them here

                List<string> ignoreList = new List<string>(){"CreationDateTime", "SubmitDateTime", "RejectDateTime", "CreatedByDisplayName",
                                        "AlignedRubricRows", "LibItems", "LinkedObservations", "LinkedStudentGrowthGoalBundles",
                                        "ShortName", "Title"};       

                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel artifactBundleModel = new ArtifactBundleModel
                {
                    EvaluationId = 1,
                    CreatedByUserId = 1,
                    Title = "title",
                    WfState = (long)SEWfStateEnum.ARTIFACT,
                    RejectionType = (short)SEArtifactBundleRejectionTypeEnum.NON_ESSENTIAL,
                    Evidence = "evidence",
                    AlignedRubricRows = new List<RubricRowModel>(),
                };

                // Makes sure all the basic properties have been set and have the same value when retrieved.
                ArtifactBundleModel artifactBundleModel1 = TestHelper.CreateArtifactBundle(artifactBundleModel);
                ArtifactBundleModel artifactBundleModel2 = artifactBundleService.GetArtifactBundleById(artifactBundleModel1.Id);

                TestHelper.ComparePropertyValues(artifactBundleModel1, artifactBundleModel2, ignoreList);
                // Update the basic properties and make sure they come back with the changed values after update.
                artifactBundleModel2.EvaluationId = 2;
                artifactBundleModel2.CreatedByUserId = 2;
                artifactBundleModel2.WfState = (long)SEWfStateEnum.ARTIFACT_REJECTED;
                artifactBundleModel2.RejectionType = (short)SEArtifactBundleRejectionTypeEnum.REQUEST_REFINEMENT;
                artifactBundleModel2.Evidence = "evidence2";
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

                ArtifactBundleModel artifactBundleModel1 = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
                ArtifactBundleModel  artifactBundleModel2 = artifactBundleService.GetArtifactBundleById(artifactBundleModel1.Id);
                Assert.IsNotNull(artifactBundleModel2);
                Assert.AreEqual(0, artifactBundleModel2.AlignedRubricRows.Count);
                Assert.AreEqual(0, artifactBundleModel2.LibItems.Count);
                Assert.AreEqual(0, artifactBundleModel2.LinkedObservations.Count);
                Assert.AreEqual(0, artifactBundleModel2.LinkedStudentGrowthGoalBundles.Count);
            }
        }

        // Make sure that an aligned rubric row does not get inserted as a new record
        [TestMethod]
        public void UpdateArtifactBundle_AlignedRubricRowsDoNotCreateNewRecord()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                RubricRowModel rr1a = TestHelper.GetDanielsonInstructionalRubricRow(SEEvaluationTypeEnum.TEACHER, "D1", "1a");

                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
                bundleModel.AlignedRubricRows.Add(rr1a);
                artifactBundleService.UpdateArtifactBundle(bundleModel);

                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                RubricRowModel A1_rr1a = bundleModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1a");

                Assert.AreEqual(rr1a.Id, A1_rr1a.Id, "aligned rubric row should not have added new row to db");
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

                ArtifactBundleModel bundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                ArtifactLibItemModel libItemModel1 = TestHelper.CreateArtifactLibItemModel("L1");
                bundleModel.LibItems.Add(libItemModel1);
                artifactBundleService.UpdateArtifactBundle(bundleModel);

                artifactBundleService = new ArtifactBundleService();
                bundleModel = artifactBundleService.GetArtifactBundleById(bundleModel.Id);

                Assert.AreEqual(1, bundleModel.LibItems.Count);
                Assert.IsNotNull(bundleModel.LibItems.FirstOrDefault(x => x.Title == "L1"));

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


                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
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

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
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

        // Create an artifact, add multiple rubric row evaluations that have artifact as aligned evidence,
        // make sure the artifact cannot be deleted.
        [TestMethod]
        public void DeleteArtifactBundleUseAsAlignedEvidence()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                RubricRowModel rr1a = TestHelper.GetDanielsonInstructionalRubricRow(SEEvaluationTypeEnum.TEACHER, "D1", "1a");

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundleAlignedToRubricRow("A1", rr1a);

                List<AvailableEvidenceModel> availableEvidence = TestHelper.GetAvailableEvidenceForEvaluation();
                Assert.AreEqual(1, availableEvidence.Count);
                Assert.AreEqual(rr1a.Id, availableEvidence[0].RubricRowId);

                RubricRowEvaluationModel rrEvalModel = TestHelper.CreateRubricRowEvaluationModel(availableEvidence[0], rr1a.Id);
                RubricRowEvaluationService rrEvalService = new RubricRowEvaluationService();
                rrEvalService.CreateRubricRowEvaluation(rrEvalModel);

                rrEvalService = new RubricRowEvaluationService();
                List<RubricRowEvaluationModel> rrEvals = rrEvalService.GetRubricRowEvaluationsForEvaluation(DefaultTeacher.EvaluationId);
                Assert.AreEqual(1, rrEvals.Count);

                artifactBundleModel = artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id);

                artifactBandleService = new ArtifactBundleService();
                try
                {
                    artifactBandleService.DeleteArtifactBundle(artifactBundleModel.Id);
                }
                catch (Exception e)
                {
                    Assert.AreEqual("This artifact is in use as evidence and cannot be deleted.", e.Message);
                }

                Assert.IsNotNull(artifactBandleService.GetArtifactBundleById(artifactBundleModel.Id));

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

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
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

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
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

        // Create an artifact and then attach it to an observation and a goal.
        // It should be able to be deleted as long as there are no alignedevidences using it
        [TestMethod]
        public void DeleteLinkedArtifactBundle()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBandleService = new ArtifactBundleService();
                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);

                var goalModel = TestHelper.CreateStudentGrowthGoalBundle("G1", DefaultTeacher.EvaluationId);
                var evalSessionModel = TestHelper.CreateEvalSession("S1", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId,
                                                SEEvaluationTypeEnum.TEACHER);

                artifactBundleModel.LinkedObservations.Add(evalSessionModel);
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

                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
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

        // Create an artifact and make sure it isn't available to anyone but the teacher when it is in private workstate
        [TestMethod]
        public void ArtifactBundleRequestPrivate()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel artifactBundleModelT1 = TestHelper.CreateArtifactBundle("A1T1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);

                Assert.AreEqual((long)SEWfStateEnum.ARTIFACT, artifactBundleModelT1.WfState);

                // teacher can see her own when it's private
                ArtifactBundleRequestModel request = new ArtifactBundleRequestModel();
                request.EvaluationId = DefaultTeacher.EvaluationId;
                request.CurrentUserId = DefaultTeacher.UserId;
                List<ArtifactBundleModel> bundles = artifactBundleService.GetArtifactBundlesForEvaluation(request);
                Assert.AreEqual(1, bundles.Count);
                Assert.AreEqual(DefaultTeacher.EvaluationId, bundles[0].EvaluationId);

                // Principal can't see it because it hasn't been submitted yet
                request.EvaluationId = DefaultTeacher.EvaluationId;
                request.CurrentUserId = DefaultPrincipal.UserId;
                bundles = artifactBundleService.GetArtifactBundlesForEvaluation(request);
                Assert.AreEqual(0, bundles.Count);

                // It's now submitted so principal can see it
                artifactBundleModelT1.WfState = (long)SEWfStateEnum.ARTIFACT_SUBMITTED;
                artifactBundleService.UpdateArtifactBundle(artifactBundleModelT1);
                bundles = artifactBundleService.GetArtifactBundlesForEvaluation(request);
                Assert.AreEqual(1, bundles.Count);
            }
        }

        // Create two artifacts in different evaluations and make sure the request only gets from the user's evaluation
        [TestMethod]
        public void ArtifactBundleRequestEvaluationId()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel artifactBundleModelT1 = TestHelper.CreateArtifactBundle("A1T1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
                ArtifactBundleModel artifactBundleModelT2 = TestHelper.CreateArtifactBundle("A1T2", DefaultTeacher2.EvaluationId, DefaultTeacher2.UserId);

                ArtifactBundleRequestModel request = new ArtifactBundleRequestModel();
                request.EvaluationId = DefaultTeacher.EvaluationId;
                request.CurrentUserId = DefaultTeacher.UserId;
                List<ArtifactBundleModel> bundles = artifactBundleService.GetArtifactBundlesForEvaluation(request);
                Assert.AreEqual(1, bundles.Count);
                Assert.AreEqual(DefaultTeacher.EvaluationId, bundles[0].EvaluationId);

            }
        }

        [TestMethod]
        public void ArtifactBundleRequestWfState()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                ArtifactBundleModel artifactBundleModel1 = TestHelper.CreateArtifactBundle("A1T1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
                ArtifactBundleModel artifactBundleModel2 = TestHelper.CreateArtifactBundle("A2T1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId);

                artifactBundleModel1.WfState = (long)SEWfStateEnum.ARTIFACT_SUBMITTED;
                artifactBundleService.UpdateArtifactBundle(artifactBundleModel1);

                ArtifactBundleRequestModel request = new ArtifactBundleRequestModel();
                request.EvaluationId = DefaultTeacher.EvaluationId;
                request.CurrentUserId = DefaultTeacher.UserId;
                request.WfState = (long)SEWfStateEnum.ARTIFACT_SUBMITTED;
                List<ArtifactBundleModel> bundles = artifactBundleService.GetArtifactBundlesForEvaluation(request);
                Assert.AreEqual(1, bundles.Count);
                Assert.AreEqual((long)SEWfStateEnum.ARTIFACT_SUBMITTED, bundles[0].WfState);

            }
        }

        // Make sure attachable objects are from the same evaluation
        [TestMethod]
        public void ArtifactBundleAttachableObjects()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();

                var goalModel = TestHelper.CreateStudentGrowthGoalBundle("G1", DefaultTeacher.EvaluationId);
                var evalSessionModel = TestHelper.CreateEvalSession("S1", DefaultTeacher.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher.UserId,
                                                SEEvaluationTypeEnum.TEACHER);

                goalModel = TestHelper.CreateStudentGrowthGoalBundle("G2", DefaultTeacher2.EvaluationId);
                evalSessionModel = TestHelper.CreateEvalSession("S2", DefaultTeacher2.EvaluationId, DefaultPrincipal.UserId, DefaultTeacher2.UserId,
                                                SEEvaluationTypeEnum.TEACHER);

                List<EvalSessionModel> observations = artifactBundleService.GetAttachableObservationsForEvaluation(DefaultTeacher.EvaluationId).ToList();
                Assert.AreEqual(1, observations.Count);
                Assert.AreEqual("S1", observations[0].Title);

                // Can't attach until it has been shared
                List<StudentGrowthGoalBundleModel> goalBundles = artifactBundleService.GetAttachableStudentGrowthGoalBundlesForEvaluation(DefaultTeacher.EvaluationId).ToList();
                Assert.AreEqual(0, goalBundles.Count);

                StudentGrowthGoalBundleService goalBundleService = new StudentGrowthGoalBundleService();
                goalModel.WfState = (short)SEWfStateEnum.GOAL_BUNDLE_PROCESS_SUBMITTED;
                goalBundleService.UpdateStudentGrowthGoalBundle(goalModel);

                artifactBundleService = new ArtifactBundleService();
                goalBundles = artifactBundleService.GetAttachableStudentGrowthGoalBundlesForEvaluation(DefaultTeacher2.EvaluationId).ToList();
                Assert.AreEqual(1, goalBundles.Count);
                Assert.AreEqual("G2", goalBundles[0].Title);

            }
        }
    }
}
