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

        public static List<AvailableEvidenceModel> GetAvailableEvidenceForEvaluation()
        {
            EvidenceCollectionRequestModel request = new EvidenceCollectionRequestModel();
            request.CollectionType = SEEvidenceCollectionTypeEnum.OTHER_EVIDENCE;
            request.EvaluationId = DefaultTeacher.EvaluationId;

            EvidenceCollectionService service = new EvidenceCollectionService();
            return service.GetAvailableEvidencesForEvaluation(request);
        }
        #endregion

        #region RubricRowEvaluation

        public static RubricRowEvaluationModel CreateRubricRowEvaluationModel(AvailableEvidenceModel availableEvidence, long rubricRowId)
        {
            RubricRowEvaluationModel rrEvalModel = new RubricRowEvaluationModel
            {
                Id = 0,
                RubricRowId = rubricRowId,
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

            rrEvalModel.AlignedEvidences.Add(alignedEvidence);

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
        public static ArtifactBundleModel CreateArtifactBundleModel(string title)
        {
            return new ArtifactBundleModel
            {
                EvaluationId = DefaultTeacher.EvaluationId,
                CreatedByUserId = 1,
                Title = title,
                ShortName = title,
                CreationDateTime = DateTime.Now,
                WfState = (long)SEWfStateEnum.ARTIFACT,
                LibItems = new List<ArtifactLibItemModel>(),
                AlignedRubricRows = new List<RubricRowModel>()
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

        public static ArtifactBundleModel CreateArtifactBundle(string title)
        {
            ArtifactBundleModel model = CreateArtifactBundleModel(title);
            return CreateArtifactBundle(model);
        }

        public static ArtifactBundleModel CreateArtifactBundleAlignedToRubricRow(string title, RubricRowModel rubricRow)
        {
            ArtifactBundleService service = new ArtifactBundleService();
            ArtifactBundleModel artifactBundleModel = CreateArtifactBundle(title);
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
        public static StudentGrowthGoalBundleModel CreateStudentGrowthGoalBundleModelWithC3Goal(string title, FrameworkModel framework)
        {
            StudentGrowthGoalBundleModel bundleModel = CreateStudentGrowthGoalBundleModel();

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
            bundleModel.Id = id;
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
      
        public static StudentGrowthGoalBundleModel CreateStudentGrowthGoalBundle(string title)
        {
            StudentGrowthGoalBundleModel bundleModel = CreateStudentGrowthGoalBundleModel();

            return CreateStudentGrowthGoalBundle(bundleModel);
        }

        public static StudentGrowthGoalBundleModel CreateStudentGrowthGoalBundleModel()
        {
            return new StudentGrowthGoalBundleModel
            {
                EvaluationId = DefaultTeacher.EvaluationId,
                Title = "",
                WfState = 1,
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

        #region EvalSession

        public static EvalSessionModel CreateEvalSessionModel(long evaluatorId, long evaluateeId, SEEvaluationTypeEnum evaluationType)
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
                Title = "Title",
                EvaluationId = 23,
                WfState = (short)SEWfStateEnum.OBS_IN_PROGRESS_TOR
            };

            return evalSessionModel;
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
