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
    public class StudentGrowthProcessSettingsServiceTest
    {
        // Create a setting, and make sure it persisted in db.
        [TestMethod]
        public void CreateStudentGrowthProcessSettings()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var service = new StudentGrowthProcessSettingService();
                StudentGrowthProcessSettingsModel settingsModel = TestHelper.CreateStudentGrowthProcessSettingsModel("C3");
                settingsModel = TestHelper.CreateStudentGrowthProcessSettings(settingsModel);
                Assert.IsNotNull(settingsModel);

                transaction.Dispose();
            }
        }

        // Get the settings for the district, in this case there are not yet any overrides so there should
        // just be one per student growth frameworknode and all supplied by the district
        [TestMethod]
        public void GetDistrictProcessSettings()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var service = new StudentGrowthProcessSettingService();

                List<StudentGrowthProcessSettingsModel> settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                Assert.AreEqual(3, settings.Count);

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C6" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == ""));

                Assert.IsNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == DistrictCodes.NorthThurston));
                Assert.IsNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C6" && x.DistrictCode == DistrictCodes.NorthThurston));
                Assert.IsNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == DistrictCodes.NorthThurston));

                settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultPrincipalEval();
                Assert.AreEqual(3, settings.Count);

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C5" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == ""));

                Assert.IsNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == DistrictCodes.NorthThurston));
                Assert.IsNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C5" && x.DistrictCode == DistrictCodes.NorthThurston));
                Assert.IsNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == DistrictCodes.NorthThurston));

                transaction.Dispose();
            }
        }

        // Override the default settings and create new ones for district, then remove them so just the default
        // settings are returned again.

        [TestMethod]
        public void AddRemoveProcessSettings()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var service = new StudentGrowthProcessSettingService();

                StudentGrowthProcessSettingsModel settingsModelC3 = TestHelper.CreateStudentGrowthProcessSettingsModel("C3");
                settingsModelC3 = TestHelper.CreateStudentGrowthProcessSettings(settingsModelC3);
                Assert.IsNotNull(settingsModelC3);

                StudentGrowthProcessSettingsModel settingsModelC6 = TestHelper.CreateStudentGrowthProcessSettingsModel("C6");
                settingsModelC6 = TestHelper.CreateStudentGrowthProcessSettings(settingsModelC6);
                Assert.IsNotNull(settingsModelC6);

                StudentGrowthProcessSettingsModel settingsModelC8 = TestHelper.CreateStudentGrowthProcessSettingsModel("C8");
                settingsModelC8 = TestHelper.CreateStudentGrowthProcessSettings(settingsModelC8);
                Assert.IsNotNull(settingsModelC8);

                List<StudentGrowthProcessSettingsModel> settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                Assert.AreEqual(6, settings.Count);

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C6" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == ""));

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == DistrictCodes.NorthThurston));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C6" && x.DistrictCode == DistrictCodes.NorthThurston));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == DistrictCodes.NorthThurston));

                service.DeleteProcessSetting(settingsModelC3.Id);
                service.DeleteProcessSetting(settingsModelC6.Id);
                service.DeleteProcessSetting(settingsModelC8.Id);

                settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                Assert.AreEqual(3, settings.Count);

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C6" && x.DistrictCode == ""));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == ""));

                transaction.Dispose();
            }
        }

        // Override the default settings and create new ones for district, then remove them so just the default
        // settings are returned again.

        [TestMethod]
        public void ProcessSettingsPrompts_Default()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var service = new StudentGrowthProcessSettingService();

                List<StudentGrowthProcessSettingsModel> settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" && x.DistrictCode == ""  && x.Prompts.ToList().Count == 9));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C6" && x.DistrictCode == "" && x.Prompts.ToList().Count == 9));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == "" && x.Prompts.ToList().Count == 8));
 
                transaction.Dispose();
            }
        }

        [TestMethod]
        public void ProcessSettingsPrompts_Override()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var processService = new StudentGrowthProcessSettingService();

                List<StudentGrowthProcessSettingsModel> settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                StudentGrowthProcessSettingsModel settingsModelC3 = TestHelper.CreateStudentGrowthProcessSettingsModel("C3");
                settingsModelC3 = TestHelper.CreateStudentGrowthProcessSettings(settingsModelC3);
                Assert.IsNotNull(settingsModelC3);

                Assert.IsNotNull(settingsModelC3.Prompts.ToList().Count == 0);

                string testPrompt = "Test Prompt";
                var formPromptServive = new StudentGrowthFormPromptService();
                StudentGrowthFormPromptModel promptModel = TestHelper.CreateFormPromptForDefaultTeacherEval(testPrompt);

                settingsModelC3.Prompts.Add(promptModel);
                processService.UpdateProcessSetting(settingsModelC3);

                settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3" 
                                                            && x.DistrictCode == DistrictCodes.NorthThurston 
                                                            && x.Prompts.ToList().Count == 1 
                                                            && x.Prompts.ToList()[0].Prompt == testPrompt));

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C6" && x.DistrictCode == "" && x.Prompts.ToList().Count == 9));
                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C8" && x.DistrictCode == "" && x.Prompts.ToList().Count == 8));


                transaction.Dispose();
            }
        }

        [TestMethod]
        public void ProcessSettingsPrompts_RelationshipSettings()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var processService = new StudentGrowthProcessSettingService();

                List<StudentGrowthProcessSettingsModel> settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                StudentGrowthProcessSettingsModel settingsModelC3 = TestHelper.CreateStudentGrowthProcessSettingsModel("C3");
                settingsModelC3 = TestHelper.CreateStudentGrowthProcessSettings(settingsModelC3);
                Assert.IsNotNull(settingsModelC3);

                Assert.IsNotNull(settingsModelC3.Prompts.ToList().Count == 0);

                string testPrompt = "Test Prompt";
                var formPromptServive = new StudentGrowthFormPromptService();
                StudentGrowthFormPromptModel promptModel = TestHelper.CreateFormPromptForDefaultTeacherEval(testPrompt);

                promptModel.Required = false;
                promptModel.Sequence = 1;
                settingsModelC3.Prompts.Add(promptModel);
                processService.UpdateProcessSetting(settingsModelC3);

                settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3"
                                                            && x.DistrictCode == DistrictCodes.NorthThurston
                                                            && x.Prompts.ToList()[0].Required == false
                                                            && x.Prompts.ToList()[0].Sequence == 1));

                settingsModelC3 = settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3"
                                                            && x.DistrictCode == DistrictCodes.NorthThurston);
                settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();
                promptModel = settingsModelC3.Prompts[0];
                promptModel.Required = true;
                promptModel.Sequence = 10;

                processService.UpdateProcessSetting(settingsModelC3);

                settings = TestHelper.GetStudentGrowthProcessSettingsForDefaultTeacherEval();

                Assert.IsNotNull(settings.FirstOrDefault(x => x.FrameworkNodeShortName == "C3"
                                                            && x.DistrictCode == DistrictCodes.NorthThurston
                                                            && x.Prompts.ToList()[0].Required == true
                                                            && x.Prompts.ToList()[0].Sequence == 10));

                transaction.Dispose();
            }
        }
 
    }
}
