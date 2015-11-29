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
        public const long UserId = 39;
        public const string DistrictCode = DistrictCodes.NorthThurston;
    }

    public static class DefaultTeacher
    {
        public const long UserId = 26;
        public const string DistrictCode = DistrictCodes.NorthThurston;
        public const string SchoolCode = SchoolCodes.NorthThurston_NorthThurstonHighSchool;
    }

    public static class DefaultPrincipal
    {
        public const long UserId = 24;
        public const string DistrictCode = DistrictCodes.NorthThurston;
        public const string SchoolCode = SchoolCodes.NorthThurston_NorthThurstonHighSchool;
    }

    class TestHelper
    {
        public static short DEFAULT_SCHOOLYEAR = Convert.ToInt16(SESchoolYearEnum.SY_2016);
        public static string DEFAULT_SCHOOLCODE = SchoolCodes.NorthThurston_NorthThurstonHighSchool;
        public static string DEFAULT_DISTRICTCODE = DistrictCodes.NorthThurston;
        public static int DEFAULT_USER_PRINCIPAL_ID = 24;

        #region RubricRowAnnotation

        public static RubricRowAnnotationModel CreateRubricRowAnnotation(long bundleId, long rrid, string annotation)
        {
            return new RubricRowAnnotationModel
            {
                RubricRowID = rrid,
                ArtifactBundleID = bundleId,
                Annotation = annotation,
                UserID = DefaultPrincipal.UserId
            };
        }
        #endregion

        #region RubricRowEvaluation

        public static RubricRowEvaluationModel CreateRubricRowEvaluation(long rrId)
        {
            ArtifactBundleModel artifactModel = TestHelper.CreateArtifactBundle("A1");
            RubricRowEvaluationModel rrModel = TestHelper.CreateRubricRowEvaluationModel(artifactModel, rrId);
            return TestHelper.CreateRubricRowEvaluation(rrModel);
        }

        public static RubricRowEvaluationModel CreateRubricRowEvaluationModel(ArtifactBundleModel artifactBundleModel, long rubricRowId)
        {
            return new RubricRowEvaluationModel
            {
                RubricRowId = rubricRowId,
                EvaluationId = 1,
                LinkedArtifactBundleId = artifactBundleModel.Id,
                LinkedItemType = Convert.ToInt16(SELinkedItemTypeEnum.ARTIFACT),
                CreatedByUserId = DefaultPrincipal.UserId,
                WfState = SEWfStateEnum.RUBRICROWEVAL_IN_PROGRESS,
                PerformanceLevel = Convert.ToInt16(SERubricPerformanceLevelEnum.PL1)
            };
        }

        public static RubricRowEvaluationModel CreateRubricRowEvaluation(ArtifactBundleModel artifactBundleModel, long rubricRowId)
        {
            var rubricRowEvaluationService = new RubricRowEvaluationService();

            RubricRowEvaluationModel rrModel = CreateRubricRowEvaluationModel(artifactBundleModel, rubricRowId);

            var val = rubricRowEvaluationService.CreateRubricRowEvaluation(rrModel);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            rrModel.Id = id;
            return rrModel;
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
                EvaluationId = 1,
                CreatedByUserId = 1,
                Title = title,
                CreationDateTime = DateTime.Now,
                WfState = (long)SEWfStateEnum.ARTIFACT,
                ArtifactType = (short)SEArtifactTypeEnum.STANDARD,
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

        public static ArtifactLibItemModel CreateArtifactLibItemModel(string title)
        {
            return new ArtifactLibItemModel
            {
                EvaluationId = 1,
                CreatedByUserId = 1,
                Title = title,
                CreationDateTime = DateTime.Now,
                ItemType = Convert.ToInt16(SEArtifactLibItemType.FILE),
            };
        }

        public static ArtifactLibItemModel CreateArtifactLibItem(ArtifactLibItemModel artifactLibItemModel)
        {
            var artifactLibItemService = new ArtifactLibItemService();

            var val = artifactLibItemService.CreateArtifactLibItem(artifactLibItemModel);
            PropertyInfo p = val.GetType().GetProperty("Id");
            int id = Convert.ToInt32(p.GetValue(val));
            artifactLibItemModel.Id = id;
            return artifactLibItemModel;
        }

        public static ArtifactLibItemModel CreateArtifactLibItem(string title)
        {
            ArtifactLibItemModel model = CreateArtifactLibItemModel(title);
            return CreateArtifactLibItem(model);
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
                EvaluationId = 1,
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
                EvaluationId = 1,
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
                EvaluationId = 1,
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
