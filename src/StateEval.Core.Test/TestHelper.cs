using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEval.Core.Services;
using System.Reflection;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.RequestModel;

namespace StateEval.Core.Test
{
    public static class DistrictCodes
    {
        public const string NorthThurston = "34003";
        public const string Othello = "01147";
    }

    public static class SchoolCodes
    {
        public const string NorthThurston_NorthThurstonHighSchool = "3010";
        public const string NorthThurston_SouthBayElementary = "2754";
    }

    public static class DefaultDTE
    {
        public const long UserId = 169;
        public const string DistrictCode = DistrictCodes.NorthThurston;
    }

    public static class DefaultTeacher
    {
        public const long UserId = 92;
        public const long EvaluationId = 51;
        public const string DistrictCode = DistrictCodes.NorthThurston;
        public const string SchoolCode = SchoolCodes.NorthThurston_NorthThurstonHighSchool;
    }

    public static class DefaultTeacher2
    {
        public const long UserId = 109;
        public const long EvaluationId = 68;
        public const string DistrictCode = DistrictCodes.NorthThurston;
        public const string SchoolCode = SchoolCodes.NorthThurston_NorthThurstonHighSchool;
    }

    public static class DefaultPrincipal
    {
        public const long UserId = 58;
        public const long EvaluationId = 17;
        public const string DistrictCode = DistrictCodes.NorthThurston;
        public const string SchoolCode = SchoolCodes.NorthThurston_NorthThurstonHighSchool;
    }

    class TestHelper
    {
        public static short DEFAULT_SCHOOLYEAR = Convert.ToInt16(SESchoolYearEnum.SY_2016);
        public static string DEFAULT_SCHOOLCODE = SchoolCodes.NorthThurston_NorthThurstonHighSchool;
        public static string DEFAULT_DISTRICTCODE = DistrictCodes.NorthThurston;

        #region EvidenceCollection

        public static List<AvailableEvidenceModel> GetAvailableEvidenceForEvaluation(SEEvidenceCollectionTypeEnum collectionType, long collectionObjectId)
        {
            EvidenceCollectionRequestModel request = new EvidenceCollectionRequestModel();
            request.CollectionType = collectionType;
            request.CollectionObjectId = collectionObjectId;
            request.EvaluationId = DefaultTeacher.EvaluationId;

            EvidenceCollectionService service = new EvidenceCollectionService();
            return service.GetAvailableEvidencesForEvaluation(request);
        }
        #endregion

        #region RubricRowEvaluation

        public static RubricRowEvaluationModel CreateRubricRowEvaluationWithAlignedArtifact()
        {
            RubricRowModel rr1a = TestHelper.GetDanielsonInstructionalRubricRow(SEEvaluationTypeEnum.TEACHER, "D1", "1a");
            var artifactBandleService = new ArtifactBundleService();

            ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundleAlignedToRubricRow("A1", rr1a);

            List<AvailableEvidenceModel> availableEvidences = TestHelper.GetAvailableEvidenceForEvaluation(SEEvidenceCollectionTypeEnum.OTHER_EVIDENCE, 0);
            Assert.AreEqual(1, availableEvidences.Count);
            Assert.AreEqual(rr1a.Id, availableEvidences[0].RubricRowId);
            AvailableEvidenceModel availableEvidence = availableEvidences[0];

            RubricRowEvaluationModel rrEvalModel = new RubricRowEvaluationModel
            {
                Id = 0,
                RubricRowId = rr1a.Id,
                EvaluationId = DefaultTeacher.EvaluationId,
                RubricStatement = "Statement",
                EvidenceCollectionType = SEEvidenceCollectionTypeEnum.OTHER_EVIDENCE,
                LinkedItemType = Convert.ToInt16(SELinkedItemTypeEnum.ARTIFACT),
                CreatedByUserId = DefaultPrincipal.UserId,
                PerformanceLevel = Convert.ToInt16(SERubricPerformanceLevelEnum.PL1),
                AlignedEvidences = new List<AlignedEvidenceModel>()
            };

            AlignedEvidenceModel alignedEvidence = new AlignedEvidenceModel();
            alignedEvidence.EvidenceType = SEEvidenceTypeEnum.ARTIFACT;
            alignedEvidence.RubricRowEvaluationId = 0;
            alignedEvidence.AvailableEvidenceId = availableEvidence.Id;
            alignedEvidence.Data = availableEvidence;
            alignedEvidence.AvailableEvidenceObjectId = Convert.ToInt64(availableEvidence.ArtifactBundleId);

            RubricRowEvaluationService rrEvalService = new RubricRowEvaluationService();

            rrEvalModel.AlignedEvidences.Add(alignedEvidence);
            object val = rrEvalService.CreateRubricRowEvaluation(rrEvalModel);
            rrEvalService = new RubricRowEvaluationService();
            List<RubricRowEvaluationModel> rrEvals = rrEvalService.GetRubricRowEvaluationsForEvaluation(DefaultTeacher.EvaluationId);
            Assert.AreEqual(1, rrEvals.Count);

            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            rrEvalModel.Id = id;         
            return rrEvalModel;
        }

        public static RubricRowEvaluationModel CreateRubricRowEvaluationWithAlignedStudentGrowthGoal()
        {
            var studentGrowthGoalBundleService = new StudentGrowthGoalBundleService();

            FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);
            RubricRowModel rr3_1 = TestHelper.GetDanielsonStateRubricRow(SEEvaluationTypeEnum.TEACHER, "C3", "SG 3.1");
            RubricRowModel rr3_2 = TestHelper.GetDanielsonStateRubricRow(SEEvaluationTypeEnum.TEACHER, "C3", "SG 3.2");
            StudentGrowthGoalBundleModel goalBundle = TestHelper.CreateStudentGrowthGoalBundleModelWithC3Goal("G1");

            List<AvailableEvidenceModel> availableEvidences = TestHelper.GetAvailableEvidenceForEvaluation(SEEvidenceCollectionTypeEnum.STUDENT_GROWTH_GOALS, goalBundle.Id);
            Assert.AreEqual(2, availableEvidences.Count);
            Assert.AreEqual(rr3_1.Id, availableEvidences[0].RubricRowId);
            Assert.AreEqual(rr3_2.Id, availableEvidences[1].RubricRowId);
            AvailableEvidenceModel availableEvidence = availableEvidences[0];

            RubricRowEvaluationModel rrEvalModel = new RubricRowEvaluationModel
            {
                Id = 0,
                RubricRowId = rr3_1.Id,
                EvaluationId = DefaultTeacher.EvaluationId,
                RubricStatement = "Statement",
                EvidenceCollectionType = SEEvidenceCollectionTypeEnum.STUDENT_GROWTH_GOALS,
                LinkedItemType = Convert.ToInt16(SELinkedItemTypeEnum.STUDENT_GROWTH_GOAL),
                LinkedStudentGrowthGoalBundleId = goalBundle.Id,
                CreatedByUserId = DefaultPrincipal.UserId,
                PerformanceLevel = Convert.ToInt16(SERubricPerformanceLevelEnum.PL1),
                AlignedEvidences = new List<AlignedEvidenceModel>()
            };

            AlignedEvidenceModel alignedEvidence = new AlignedEvidenceModel();
            alignedEvidence.EvidenceType = SEEvidenceTypeEnum.STUDENT_GROWTH_GOAL;
            alignedEvidence.RubricRowEvaluationId = 0;
            alignedEvidence.AvailableEvidenceId = availableEvidence.Id;
            alignedEvidence.Data = availableEvidence;
            alignedEvidence.AvailableEvidenceObjectId = Convert.ToInt64(goalBundle.Goals[0].Id);

            RubricRowEvaluationService rrEvalService = new RubricRowEvaluationService();

            rrEvalModel.AlignedEvidences.Add(alignedEvidence);
            object val = rrEvalService.CreateRubricRowEvaluation(rrEvalModel);
            rrEvalService = new RubricRowEvaluationService();
            List<RubricRowEvaluationModel> rrEvals = rrEvalService.GetRubricRowEvaluationsForEvaluation(DefaultTeacher.EvaluationId);
            Assert.AreEqual(1, rrEvals.Count);

            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            rrEvalModel.Id = id;
            return rrEvalModel;
        }

        public static RubricRowEvaluationModel CreateRubricRowEvaluation(RubricRowEvaluationModel rrModel)
        {
            var rubricRowEvaluationService = new RubricRowEvaluationService();

            var val = rubricRowEvaluationService.CreateRubricRowEvaluation(rrModel);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            rrModel.Id = id;
            return rrModel;
        }

        #endregion

        #region General

        public static void ComparePropertyValues(object fromModel, object fromDb, List<string> skipNames)
        {
            PropertyInfo[] propInfos = fromDb.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo pi in propInfos)
            {
                if (skipNames.FirstOrDefault(x => x == pi.Name) != null)
                    continue;

                var dbProp = fromDb.GetType().GetProperty(pi.Name);
                var dbVal = dbProp.GetValue(fromDb, null);

                var modelProp = fromModel.GetType().GetProperty(pi.Name);
                var modelVal = modelProp.GetValue(fromModel, null);

                Assert.AreEqual(modelVal, dbVal, "property name: " + pi.Name + " values differ");
            }
        }

        #endregion

        #region Rubrics

        public static FrameworkModel GetStateFramework(SEEvaluationTypeEnum evalType)
        {
            var frameworkService = new FrameworkService();
            return frameworkService.GetFrameworkContext(
                            (SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                            TestHelper.DEFAULT_DISTRICTCODE,
                            (SEEvaluationTypeEnum)Convert.ToInt16(evalType)).StateFramework;
        }

        public static FrameworkModel GetInstructionalFramework(SEEvaluationTypeEnum evalType)
        {
            var frameworkService = new FrameworkService();
            return frameworkService.GetFrameworkContext(
                            (SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                            TestHelper.DEFAULT_DISTRICTCODE,
                            (SEEvaluationTypeEnum)Convert.ToInt16(evalType)).InstructionalFramework;
        }

        public static RubricRowModel GetDanielsonInstructionalRubricRow(SEEvaluationTypeEnum evalType, string fnShortName, string rrShortName)
        {
            FrameworkModel framework = TestHelper.GetInstructionalFramework(evalType);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == fnShortName);

            return frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == rrShortName);
        }

        public static RubricRowModel GetDanielsonStateRubricRow(SEEvaluationTypeEnum evalType, string fnShortName, string rrShortName)
        {
            FrameworkModel framework = TestHelper.GetStateFramework(evalType);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == fnShortName);

            return frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == rrShortName);
        }

        public static RubricRowModel CreateRubricRowModel(long id, string title)
        {
            return new RubricRowModel
            {
                Id = id,
                Title = title,
                Description = "Description A",
                PL1Descriptor = "A1",
                PL2Descriptor = "A2",
                PL3Descriptor = "A3",
                PL4Descriptor = "A4",
            };
        }
        #endregion

        #region Artifacts
        public static ArtifactBundleModel CreateArtifactBundleModel(string title, long evaluationId, long createdByUserId)
        {
            return new ArtifactBundleModel
            {
                EvaluationId = evaluationId,
                CreatedByUserId = createdByUserId,
                Title = title,
                ShortName = title,
                CreationDateTime = DateTime.Now,
                WfState = (long)SEWfStateEnum.ARTIFACT,
                LibItems = new List<ArtifactLibItemModel>(),
                AlignedRubricRows = new List<RubricRowModel>(),
                LinkedObservations = new List<EvalSessionModel>(),
                LinkedStudentGrowthGoalBundles = new List<StudentGrowthGoalBundleModel>()
            };
        }

        public static ArtifactBundleModel CreateArtifactBundle(ArtifactBundleModel artifactBundleModel)
        {
            var artifactBundleService = new ArtifactBundleService();

            var val = artifactBundleService.CreateArtifactBundle(artifactBundleModel);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            artifactBundleModel.Id = id;
            return artifactBundleModel;
        }

        public static ArtifactBundleModel CreateArtifactBundle(string title, long evaluationId, long createdByUserId)
        {
            ArtifactBundleModel model = CreateArtifactBundleModel(title, evaluationId, createdByUserId);
            return CreateArtifactBundle(model);
        }

        public static ArtifactBundleModel CreateArtifactBundleAlignedToRubricRow(string title, RubricRowModel rubricRow)
        {
            ArtifactBundleService service = new ArtifactBundleService();
            ArtifactBundleModel artifactBundleModel = CreateArtifactBundle(title, DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
            artifactBundleModel.AlignedRubricRows.Add(rubricRow);
            service.UpdateArtifactBundle(artifactBundleModel);
            return service.GetArtifactBundleById(artifactBundleModel.Id);
        }

        public static ArtifactLibItemModel CreateArtifactLibItemModel(string title)
        {
            return new ArtifactLibItemModel
            {
                EvaluationId = DefaultTeacher.EvaluationId,
                CreatedByUserId = DefaultTeacher.UserId,
                Title = title,
                CreationDateTime = DateTime.Now,
                ItemType = Convert.ToInt16(SEArtifactLibItemType.FILE),
            };
        }

        public static List<ArtifactBundleModel> GetArtifactBundlesForEvaluation(long evaluationId, long currentUserId) 
        {
            ArtifactBundleService artifactBundleService = new ArtifactBundleService();
            ArtifactBundleRequestModel request = new ArtifactBundleRequestModel();
            request.EvaluationId = DefaultTeacher.EvaluationId;
            request.CurrentUserId = DefaultTeacher.UserId;
            return artifactBundleService.GetArtifactBundlesForEvaluation(request);
        }
        #endregion

        #region FormPrompts

        public static StudentGrowthFormPromptModel CreateFormPromptModel(string districtCode, short schoolYear, 
                                                            SEEvaluationTypeEnum evalType, string prompt)
        {
            return new StudentGrowthFormPromptModel
            {
                DistrictCode = districtCode,
                SchoolYear = Convert.ToInt16(schoolYear),
                EvaluationType = Convert.ToInt16(evalType),
                Prompt = prompt
            };
        }

        /*
        public static StudentGrowthFormPromptModel CreateFormPrompt(string districtCode, short schoolYear,
                                                            SEEvaluationTypeEnum evalType, string prompt)
        {
            var service = new StudentGrowthFormPromptService();

            StudentGrowthFormPromptModel model = CreateFormPromptModel(districtCode, schoolYear, evalType, prompt);

            var val = service.CreateFormPrompt(model);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            model.Id = id;
            return model;
        }
        */

        #endregion

        #region StudentGrowth
/*
        public static StudentGrowthFormPromptModel CreateFormPromptForDefaultTeacherEval(string prompt)
        {
            return TestHelper.CreateFormPrompt(DistrictCodes.NorthThurston,
                                                        TestHelper.DEFAULT_SCHOOLYEAR,
                                                        SEEvaluationTypeEnum.TEACHER,
                                                        prompt);         
        }

        public static StudentGrowthFormPromptModel CreateFormPromptForDefaultPrincipalEval(string prompt)
        {
            return TestHelper.CreateFormPrompt(DistrictCodes.NorthThurston,
                                                        TestHelper.DEFAULT_SCHOOLYEAR,
                                                        SEEvaluationTypeEnum.PRINCIPAL,
                                                        prompt);
        }

        public static List<StudentGrowthProcessSettingsModel> GetStudentGrowthProcessSettingsForDefaultTeacherEval()
        {
                var processService = new StudentGrowthProcessSettingService();

            return processService.GetStudentGrowthProcessSettings(Convert.ToInt16(SEEvaluationTypeEnum.TEACHER),
                                DistrictCodes.NorthThurston,
                                TestHelper.DEFAULT_SCHOOLYEAR).ToList();
        }

        public static List<StudentGrowthProcessSettingsModel> GetStudentGrowthProcessSettingsForDefaultPrincipalEval()
        {
            var processService = new StudentGrowthProcessSettingService();

            return processService.GetStudentGrowthProcessSettings(Convert.ToInt16(SEEvaluationTypeEnum.PRINCIPAL),
                                DistrictCodes.NorthThurston,
                                TestHelper.DEFAULT_SCHOOLYEAR).ToList();
        }

        public static StudentGrowthProcessSettingsModel CreateStudentGrowthProcessSettingsModel(string frameworkShortName)
        {
            return new StudentGrowthProcessSettingsModel
            {
                DistrictCode = DEFAULT_DISTRICTCODE,
                EvaluationType = Convert.ToInt16(SEEvaluationTypeEnum.TEACHER),
                SchoolYear = DEFAULT_SCHOOLYEAR,
                FrameworkNodeShortName = frameworkShortName,
                Prompts = new List<StudentGrowthFormPromptModel>()
            };
        }

        public static StudentGrowthProcessSettingsModel CreateStudentGrowthProcessSettings(StudentGrowthProcessSettingsModel model)
        {
            var service = new StudentGrowthProcessSettingService();

            var val = service.CreateProcessSetting(model);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            model.Id = id;
            return model;
        }
        */
        public static StudentGrowthGoalBundleModel CreateStudentGrowthGoalBundleModelWithC3Goal(string title)
        {
            StudentGrowthGoalBundleModel bundleModel = CreateStudentGrowthGoalBundleModel(title, DefaultTeacher.EvaluationId);

            FrameworkModel framework = GetStateFramework(SEEvaluationTypeEnum.TEACHER);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "C3");
            RubricRowModel rrSG31 = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "SG 3.1");
            RubricRowModel rrSG32 = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "SG 3.2");

            List<StudentGrowthGoalModel> goals = new List<StudentGrowthGoalModel>();
            goals.Add(TestHelper.CreateStudentGrowthGoalModel(frameworkNode.Id, rrSG31.Id, rrSG32.Id));
            bundleModel.Goals = goals;

            var studentGrowthGoalBundleService = new StudentGrowthGoalBundleService();

            var val = studentGrowthGoalBundleService.CreateStudentGrowthGoalBundle(bundleModel);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            bundleModel = studentGrowthGoalBundleService.GetStudentGrowthGoalBundleById(id);
            return bundleModel;
        }

        public static StudentGrowthGoalBundleModel CreateStudentGrowthGoalBundle(StudentGrowthGoalBundleModel model)
        {
            var studentGrowthGoalBundleService = new StudentGrowthGoalBundleService();

            var val = studentGrowthGoalBundleService.CreateStudentGrowthGoalBundle(model);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            model.Id = id;
            return model;
        }
      
        public static StudentGrowthGoalBundleModel CreateStudentGrowthGoalBundle(string title, long evaluationId)
        {
            StudentGrowthGoalBundleModel bundleModel = CreateStudentGrowthGoalBundleModel(title, evaluationId);

            return CreateStudentGrowthGoalBundle(bundleModel);
        }

        public static StudentGrowthGoalBundleModel CreateStudentGrowthGoalBundleModel(string title, long evaluationId)
        {
            return new StudentGrowthGoalBundleModel
            {
                EvaluationId = evaluationId,
                Title = title,
                ShortName = "shortName",
                WfState = (short)SEWfStateEnum.GOAL_BUNDLE_IN_PROGRESS,
                EvalWfState = (short)SEWfStateEnum.GOAL_BUNDLE_NOT_SCORED,
                Comments = "",
                Course = "",
                Grade = "",
                CreationDateTime = DateTime.Now,
                Goals = new List<StudentGrowthGoalModel>()
            };
        }

        public static StudentGrowthGoalModel CreateStudentGrowthGoalModel()
        {
            return new StudentGrowthGoalModel
            {
                EvaluationId = DefaultTeacher.EvaluationId,
                FrameworkNodeId = 1,
                ProcessRubricRowId = 1,
                ResultsRubricRowId = 1,
                GoalStatement = "",
                GoalTargets = "",
                EvidenceAll = "",
                EvidenceMost = "",
                IsActive = false,
                Prompts = new List<StudentGrowthFormPromptModel>()
            };
        }

        public static StudentGrowthGoalModel CreateStudentGrowthGoalModel(long frameworkNodeId, long processRubricRowId, long resultsRubricRowId)
        {
            return new StudentGrowthGoalModel
            {
                EvaluationId = DefaultTeacher.EvaluationId,
                FrameworkNodeId = frameworkNodeId,
                ProcessRubricRowId = processRubricRowId,
                ResultsRubricRowId = resultsRubricRowId,
                GoalStatement = "",
                GoalTargets = "",
                EvidenceAll = "",
                EvidenceMost = "",
                IsActive = false,
                Prompts = new List<StudentGrowthFormPromptModel>()
            };
        }

        #endregion

        #region SelfAssessment

        public static SelfAssessmentModel CreateSelfAssessment(string title, long evaluationId, long evaluateeId, SEEvaluationTypeEnum evaluationType)
        {
            var model = new SelfAssessmentModel
            {
                EvaluationId = evaluationId,
                EvaluateeId = evaluateeId,
                Focused = false,
                Title = title,
                ShortName = "ShortName",
                IsSharedWithEvaluator = false,
                PerformanceLevel = (short)SERubricPerformanceLevelEnum.UNDEFINED,
                IncludeInFinalReport = false
            };

            SelfAssessmentService service = new SelfAssessmentService();

            var val = service.CreateSelfAssessment(model);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            model.Id = id;
            return model;
        }

        #endregion

        #region EvalSession

        public static EvalSessionModel CreateEvalSessionModel(string title, long evaluationId, long evaluatorId, long evaluateeId, SEEvaluationTypeEnum evaluationType)
        {
            var evalSessionModel = new EvalSessionModel
            {
                DistrictCode = DistrictCodes.NorthThurston,
                EvaluateeId = evaluateeId,
                EvaluatorId = evaluatorId,
                SchoolCode = DEFAULT_SCHOOLCODE,
                Focused = false,
                ObserveStartTime = DateTime.Now,
                EvaluationScoreTypeID = 2,
                EvaluatorNotes = "Note",
                SchoolYear = (SESchoolYearEnum) DEFAULT_SCHOOLYEAR,
                EvaluationType = evaluationType,
                Title = title, 
                ShortName = "ShortName",
                EvaluationId = evaluationId,
                WfState = (short)SEWfStateEnum.OBS_IN_PROGRESS_TOR
            };

            return evalSessionModel;
        }

        public static EvalSessionModel CreateEvalSession(string title, long evaluationId, long evaluatorId, long evaluateeId, SEEvaluationTypeEnum evalType)
        {
            EvalSessionModel model = CreateEvalSessionModel(title, evaluationId, evaluatorId, evaluateeId, evalType);
            var evalSessionService = new EvalSessionService();
            var evalSessionId = evalSessionService.SaveEvalSession(model);

            evalSessionService = new EvalSessionService();
            return evalSessionService.GetEvalSessionById(evalSessionId);
        }

        #endregion

        #region Evaluation

        public static EvaluationModel GetEvaluationForDefaultTeacher()
        {
            var evaluationService = new EvaluationService();

            return evaluationService.GetEvaluation(DefaultTeacher.UserId,
                                    DefaultTeacher.DistrictCode,
                                    TestHelper.DEFAULT_SCHOOLYEAR,
                                    (short)SEEvaluationTypeEnum.TEACHER);
        }
        #endregion

    }
}
