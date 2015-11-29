using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;
using System.EnterpriseServices;

using NUnit.Framework;
using DbUtils;
using StateEval.Security;
using RepositoryLib;

namespace StateEval.tests.objectModel
{
     [TestFixture]
    class tDistrictAndSchoolConfiguration : tBase
    {     
         [Test]
         public void IDbObject()
         {
             SEDistrictConfiguration dc = Fixture.SEMgr.DistrictConfiguration(PilotDistricts.NorthThurston,SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear);
             Assert.AreEqual(dc.Id, ((IDbObject)dc).Id);

             SESchoolConfiguration sc = Fixture.SEMgr.SchoolConfiguration(PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, Fixture.CurrentSchoolYear);
             Assert.AreEqual(sc.Id, ((IDbObject)sc).Id);
         }

         protected void VerifyDistrictConfigurationLoad(SEDistrictConfiguration dc, SEEvaluationType evalType, SEFrameworkViewType viewType, string districtCode)
         {
             Assert.AreEqual(evalType, dc.EvaluationType);
             Assert.AreEqual(viewType, dc.FrameworkViewType);
             Assert.AreEqual(districtCode, dc.DistrictCode);
             Assert.IsFalse(dc.HasSubmittedToStatePE);
             Assert.IsFalse(dc.HasSubmittedToStateTE);
             Assert.AreEqual(DateTime.MinValue.ToShortDateString(), dc.SubmissionToStateDatePE);
             Assert.AreEqual(DateTime.MinValue.ToShortDateString(), dc.SubmissionToStateDateTE);
         }

         protected void VerifySchoolConfigurationLoad(SESchoolConfiguration sc)
         {
             Assert.AreEqual(false, sc.HasSubmittedToDistrictTE);
             Assert.AreEqual(false, sc.IsPrincipalAssignmentDelegated);
             Assert.AreEqual(DateTime.MinValue.ToShortDateString(), sc.SubmissionToDistrictDateTE);
         }

         [Test]
         public void Load()
         {
             SEDistrictConfiguration dc = Fixture.SEMgr.DistrictConfiguration(PilotDistricts.NorthThurston, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear);
             VerifyDistrictConfigurationLoad(dc, SEEvaluationType.TEACHER_OBSERVATION, SEFrameworkViewType.STATE_FRAMEWORK_DEFAULT, PilotDistricts.NorthThurston);
			 
             dc = Fixture.SEMgr.DistrictConfiguration(PilotDistricts.NorthThurston, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear);
             VerifyDistrictConfigurationLoad(dc, SEEvaluationType.PRINCIPAL_OBSERVATION, SEFrameworkViewType.STATE_FRAMEWORK_ONLY, PilotDistricts.NorthThurston);

             dc = Fixture.SEMgr.DistrictConfiguration(PilotDistricts.Othello, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear);
             VerifyDistrictConfigurationLoad(dc, SEEvaluationType.TEACHER_OBSERVATION, SEFrameworkViewType.STATE_FRAMEWORK_ONLY, PilotDistricts.Othello);

             dc = Fixture.SEMgr.DistrictConfiguration(PilotDistricts.Othello, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear);
             VerifyDistrictConfigurationLoad(dc, SEEvaluationType.PRINCIPAL_OBSERVATION, SEFrameworkViewType.STATE_FRAMEWORK_ONLY, PilotDistricts.Othello);

             SESchoolConfiguration sc = Fixture.SEMgr.SchoolConfiguration(PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, Fixture.CurrentSchoolYear);
             VerifySchoolConfigurationLoad(sc);
          }

         protected void VerifyFinalScoreAggregatesForState(SEEvaluationType evalType, int pl1, int pl2, int pl3, int pl4, int inc)
         {
             FinalScoreAggregatesForState f = new FinalScoreAggregatesForState(Fixture.SEMgr, Fixture.CurrentSchoolYear, evalType);
             Assert.AreEqual(pl1, f.PL1Count);
             Assert.AreEqual(pl2, f.PL2Count);
             Assert.AreEqual(pl3, f.PL3Count);
             Assert.AreEqual(pl4, f.PL4Count);
             Assert.AreEqual(inc, f.INCCount);
         }

         protected void VerifyFinalScoreAggregatesForDistrict(string districtCode, SEEvaluationType evalType, int pl1, int pl2, int pl3, int pl4, int inc)
         {
             FinalScoreAggregatesForDistrict f = new FinalScoreAggregatesForDistrict(Fixture.SEMgr, districtCode, Fixture.CurrentSchoolYear, evalType);
             Assert.AreEqual(pl1, f.PL1Count);
             Assert.AreEqual(pl2, f.PL2Count);
             Assert.AreEqual(pl3, f.PL3Count);
             Assert.AreEqual(pl4, f.PL4Count);
             Assert.AreEqual(inc, f.INCCount);
         }

         protected void VerifyFinalScoreAggregatesForSchool(string schoolCode, int pl1, int pl2, int pl3, int pl4, int incomplete)
         {
             FinalScoreAggregatesForSchool f = new FinalScoreAggregatesForSchool(Fixture.SEMgr, schoolCode, Fixture.CurrentSchoolYear);
             Assert.AreEqual(pl1, f.PL1Count);
             Assert.AreEqual(pl2, f.PL2Count);
             Assert.AreEqual(pl3, f.PL3Count);
             Assert.AreEqual(pl4, f.PL4Count);
			 Assert.AreEqual(incomplete, f.INCCount);
         }

         protected void VerifyFinalScore(long evaluateeId, SERubricPerformanceLevel pl, string districtCode, SEEvaluationType evalType)
         {
             SEEvaluation evalData = SEMgr.Instance.GetEvaluationDataForEvaluatee(evaluateeId, Fixture.CurrentSchoolYear, districtCode);
             Assert.AreEqual(pl, (SERubricPerformanceLevel) Convert.ToInt32(evalData.PerformanceLevel));
         }

         [Test]
         public void ScoreFinalScore()
         {
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
             SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
             SEUser tms = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_TMS);
        
             Fixture.SEMgr.ScoreFinalScore(principal.Id, teacher1.Id, SERubricPerformanceLevel.PL1, Fixture.CurrentSchoolYear, principal.DistrictCode);
             VerifyFinalScore(teacher1.Id, SERubricPerformanceLevel.PL1, teacher1.DistrictCode, SEEvaluationType.TEACHER_OBSERVATION);
             Fixture.SEMgr.SubmitFinalScore(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_NorthThurstonHS, 1, 0, 0, 0, 2);

             Fixture.SEMgr.ScoreFinalScore(principal.Id, teacher2.Id, SERubricPerformanceLevel.PL2, Fixture.CurrentSchoolYear, teacher2.DistrictCode);
             VerifyFinalScore(teacher2.Id, SERubricPerformanceLevel.PL2, teacher2.DistrictCode, SEEvaluationType.TEACHER_OBSERVATION);
             Fixture.SEMgr.SubmitFinalScore(teacher2.Id, Fixture.CurrentSchoolYear, teacher2.DistrictCode);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_NorthThurstonHS, 1, 1, 0, 0, 1);

             Fixture.SEMgr.ScoreFinalScore(principal.Id, tms.Id, SERubricPerformanceLevel.PL3, Fixture.CurrentSchoolYear, principal.DistrictCode);
             VerifyFinalScore(tms.Id, SERubricPerformanceLevel.PL3, principal.DistrictCode, SEEvaluationType.TEACHER_OBSERVATION);
             Fixture.SEMgr.SubmitFinalScore(tms.Id, Fixture.CurrentSchoolYear, tms.DistrictCode);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_NorthThurstonHS, 1, 1, 1, 0, 0);

             Fixture.SEMgr.SubmitEvaluationsToDistrictTE(PilotSchools.NorthThurston_NorthThurstonHS, Fixture.CurrentSchoolYear);
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.TEACHER_OBSERVATION, 1, 1, 1, 0, 3); 
          }

         public int NotSubmittedSchoolCount(string districtCode, string notSubmittedSchoolCode, int notSubmittedCount)
         {
             int count = 0;
             bool found = false;
             SqlDataReader r = Fixture.SEMgr.SchoolsThatHaveNotSubmittedToDistrictTE(districtCode, Fixture.CurrentSchoolYear);
             while (r.Read())
             {
                 if (Convert.ToString(r["SchoolCode"]) == notSubmittedSchoolCode)
                     found = true;
                 count++;
             }
             r.Close();
             Assert.IsTrue(found);
             Assert.AreEqual(notSubmittedCount, count);
             return count;
         }

         public int NotSubmittedDistrictsCount(string notSubmittedDistrictCode, int notSubmittedCount)
         {
             int count = 0;
             bool found = false;
             SqlDataReader r = Fixture.SEMgr.DistrictsThatHaveNotSubmittedToStateTE(Fixture.CurrentSchoolYear);
             while (r.Read())
             {
                 if (Convert.ToString(r["DistrictCode"]) == notSubmittedDistrictCode)
                     found = true;
                 count++;
             }
             r.Close();
             Assert.IsTrue(found);
             Assert.AreEqual(notSubmittedCount, count);
             return count;
         }

         [Test]
         public void Submission_TE()
         {
             List<string> schoolCodes = Fixture.SEMgr.SchoolCodesInDistrict(PilotDistricts.NorthThurston);

             SEDistrictConfiguration dc = Fixture.SEMgr.DistrictConfiguration(PilotDistricts.NorthThurston, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear);

             SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             // NOTE: the total # of INC is dependent on the test districts. it currently includes only North THurston and Othello
             // We should really query the db to find out how many teachers are in the test db

             // None has been submitted to the school, district, or state

             VerifyFinalScoreAggregatesForState(SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 0, 8);
			 VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 0, 4);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_NorthThurstonHS, 0, 0, 0, 0, 2);
             NotSubmittedSchoolCount(PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, schoolCodes.Count);
             NotSubmittedDistrictsCount(PilotDistricts.NorthThurston, 2);

             SEUser[] teachers = Fixture.SEMgr.GetTeachersInSchool(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS);
             foreach (SEUser teacher in teachers)
             {
                 Fixture.SEMgr.ScoreFinalScore(principal.Id, teacher.Id, SERubricPerformanceLevel.PL1, Fixture.CurrentSchoolYear, teacher.DistrictCode);
              }

             // still haven't been submitted, just scored
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 0, 4);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_NorthThurstonHS, 2, 0, 0, 0, 0);
             Assert.IsFalse(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToDistrictTE(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear));
             Assert.IsFalse(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToStateTE(Fixture.CurrentSchoolYear));
             
             foreach (SEUser teacher in teachers)
             {
                 Fixture.SEMgr.SubmitFinalScore(teacher.Id, Fixture.CurrentSchoolYear, teacher.DistrictCode);
             }

             // now they have been submitted to North Thurston
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 0, 4);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_NorthThurstonHS, 2, 0, 0, 0, 0);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_SouthBayES, 0, 0, 0, 0, 2);
             NotSubmittedSchoolCount(PilotDistricts.NorthThurston, PilotSchools.NorthThurston_SouthBayES, schoolCodes.Count);
             NotSubmittedDistrictsCount(PilotDistricts.NorthThurston, 2);

             teachers = Fixture.SEMgr.GetTeachersInSchool(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_SouthBayES);
             foreach (SEUser teacher in teachers)
             {
                 Fixture.SEMgr.ScoreFinalScore(principal.Id, teacher.Id, SERubricPerformanceLevel.PL2, Fixture.CurrentSchoolYear, teacher.DistrictCode);
                 Fixture.SEMgr.SubmitFinalScore(teacher.Id, Fixture.CurrentSchoolYear, teacher.DistrictCode);
             }

             // and Chinook Middle School
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 0, 4);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_NorthThurstonHS, 2, 0, 0, 0, 0);
             VerifyFinalScoreAggregatesForSchool(PilotSchools.NorthThurston_SouthBayES, 0, 2, 0, 0, 0);

             Fixture.SEMgr.SubmitEvaluationsToDistrictTE(PilotSchools.NorthThurston_NorthThurstonHS, Fixture.CurrentSchoolYear);
             Fixture.SEMgr.SubmitEvaluationsToDistrictTE(PilotSchools.NorthThurston_SouthBayES, Fixture.CurrentSchoolYear);

             // Submit North Thurston to state
             Fixture.SEMgr.SubmitEvaluationsToStateTE(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear);
             VerifyFinalScoreAggregatesForState(SEEvaluationType.TEACHER_OBSERVATION, 2, 2, 0, 0, 4);
             NotSubmittedDistrictsCount(PilotDistricts.Othello, 1);

             Assert.IsTrue(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToDistrictTE(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear));
             Assert.IsFalse(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToStateTE(Fixture.CurrentSchoolYear));
  
             // Now submit Othello all the way to state
             schoolCodes = Fixture.SEMgr.SchoolCodesInDistrict(PilotDistricts.Othello);

             foreach (string schoolCode in schoolCodes)
             {
                    teachers = Fixture.SEMgr.GetTeachersInSchool(Fixture.CurrentSchoolYear, PilotDistricts.Othello, schoolCode);
                    foreach (SEUser teacher in teachers)
                    {
                        SEUser e = Fixture.SEMgr.SEUser(teacher.Id);
                        Fixture.SEMgr.ScoreFinalScore(e.Id, teacher.Id, SERubricPerformanceLevel.PL4, Fixture.CurrentSchoolYear, teacher.DistrictCode);
                        Fixture.SEMgr.SubmitFinalScore(teacher.Id, Fixture.CurrentSchoolYear, teacher.DistrictCode);
                    }
                    Fixture.SEMgr.SubmitEvaluationsToDistrictTE(schoolCode, Fixture.CurrentSchoolYear);
             }

             VerifyFinalScoreAggregatesForSchool(PilotSchools.Othello_OthelloHS, 0, 0, 0, 2, 0);
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.Othello, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 4, 0);
             VerifyFinalScoreAggregatesForState(SEEvaluationType.TEACHER_OBSERVATION, 2, 2, 0, 0, 4);

             Fixture.SEMgr.SubmitEvaluationsToStateTE(PilotDistricts.Othello, Fixture.CurrentSchoolYear);
             VerifyFinalScoreAggregatesForState(SEEvaluationType.TEACHER_OBSERVATION, 2, 2, 0, 4, 0);

             Assert.IsTrue(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToDistrictTE(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear));
             Assert.IsTrue(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToDistrictTE(PilotDistricts.Othello, Fixture.CurrentSchoolYear));
             Assert.IsTrue(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToStateTE(Fixture.CurrentSchoolYear));
 
         }

         [Test]
         public void Submission_PE()
         {
             SEDistrictConfiguration dc = Fixture.SEMgr.DistrictConfiguration(PilotDistricts.NorthThurston, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear);

             SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             // NOTE: the total # of INC is dependent on the test districts. it currently includes only North THurston and Othello
 
             // None has been submitted to the school, district, or state
             VerifyFinalScoreAggregatesForState(SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 0, 0, 4);
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 0, 0, 2);
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.Othello, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 0, 0, 2);
             Assert.IsFalse(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToStatePE(Fixture.CurrentSchoolYear));

             Fixture.SEMgr.ScoreFinalScore(de.Id, principal.Id, SERubricPerformanceLevel.PL1, Fixture.CurrentSchoolYear, principal.DistrictCode);

             // still haven't been submitted, just scored
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.PRINCIPAL_OBSERVATION, 1, 0, 0, 0, 1);

             Fixture.SEMgr.SubmitFinalScore(principal.Id, Fixture.CurrentSchoolYear, principal.DistrictCode);

             // now they have been submitted to North Thurston
             VerifyFinalScoreAggregatesForState(SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 0, 0, 4);
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.PRINCIPAL_OBSERVATION, 1, 0, 0, 0, 1);

             SEUser[] principals = Fixture.SEMgr.GetPrincipalsInDistrictBuildings(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston);
             foreach (SEUser p in principals)
             {
                 Fixture.SEMgr.ScoreFinalScore(de.Id, p.Id, SERubricPerformanceLevel.PL2, Fixture.CurrentSchoolYear, p.DistrictCode);
                 Fixture.SEMgr.SubmitFinalScore(p.Id, Fixture.CurrentSchoolYear, p.DistrictCode);
             }
             Fixture.SEMgr.SubmitEvaluationsToStatePE(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear);

             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 2, 0, 0, 0);
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.Othello, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 0, 0, 2);

             principals = Fixture.SEMgr.GetPrincipalsInDistrictBuildings(Fixture.CurrentSchoolYear, PilotDistricts.Othello);
             foreach (SEUser p in principals)
             {
                 Fixture.SEMgr.ScoreFinalScore(de.Id, p.Id, SERubricPerformanceLevel.PL3, Fixture.CurrentSchoolYear, p.DistrictCode);
                 Fixture.SEMgr.SubmitFinalScore(p.Id, Fixture.CurrentSchoolYear, p.DistrictCode);
             }
             Fixture.SEMgr.SubmitEvaluationsToStatePE(PilotDistricts.Othello, Fixture.CurrentSchoolYear);

             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.NorthThurston, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 2, 0, 0, 0);
             VerifyFinalScoreAggregatesForDistrict(PilotDistricts.Othello, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 2, 0, 0);
             VerifyFinalScoreAggregatesForState(SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 2, 2, 0, 0);
             Assert.IsTrue(Fixture.SEMgr.HaveAllEvaluationsBeenSubmittedToStatePE(Fixture.CurrentSchoolYear));
         }
 
    }
}
