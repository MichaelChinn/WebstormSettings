using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;

using NUnit.Framework;
using DbUtils;

using RepositoryLib;

namespace StateEval.tests.objectModel
{
     [TestFixture]
    class tFrameworkPerformanceLevel : tBase
    {
         [Test]
         public void IDbObject()
         {
             SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston,Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             SEFrameworkPerformanceLevel[] pls = Fixture.SEMgr.GetPerformanceLevelsForFramework(f.Id);
             Assert.AreEqual(pls[0].Id, ((IDbObject)pls[0]).Id);
         }

 

        protected void VerifyPerformanceLevelsShortNamesForFramework(SEFrameworkPerformanceLevel[] pls, string one, string two, string three, string four)
        {
            Assert.AreEqual(one, pls[0].ShortName);
            Assert.AreEqual(two, pls[1].ShortName);
            Assert.AreEqual(three, pls[2].ShortName);
            Assert.AreEqual(four, pls[3].ShortName);
        }

        protected void VerifyPerformanceLevelsFullNamesForFramework(SEFrameworkPerformanceLevel[] pls, string one, string two, string three, string four)
        {
            Assert.AreEqual(one, pls[0].FullName);
            Assert.AreEqual(two, pls[1].FullName);
            Assert.AreEqual(three, pls[2].FullName);
            Assert.AreEqual(four, pls[3].FullName);
        }

        protected void VerifyPerformanceLevelsDescriptionsForFramework(SEFrameworkPerformanceLevel[] pls, string one, string two, string three, string four)
        {
            Assert.AreEqual(one, pls[0].Description);
            Assert.AreEqual(two, pls[1].Description);
            Assert.AreEqual(three, pls[2].Description);
            Assert.AreEqual(four, pls[3].Description);
        }

        protected void VerifyPerformanceLevelsEnumsForFramework(SEFrameworkPerformanceLevel[] pls, SERubricPerformanceLevel pl1, SERubricPerformanceLevel pl2, SERubricPerformanceLevel pl3, SERubricPerformanceLevel pl4)
        {
            Assert.AreEqual(pl1, pls[0].PerformanceLevel);
            Assert.AreEqual(pl2, pls[1].PerformanceLevel);
            Assert.AreEqual(pl3, pls[2].PerformanceLevel);
            Assert.AreEqual(pl4, pls[3].PerformanceLevel);
        }

        [Test]
        public void PerformanceLevels()
        {
            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            SEFrameworkPerformanceLevel[] pls = Fixture.SEMgr.GetPerformanceLevelsForFramework(f.Id);
            foreach (SEFrameworkPerformanceLevel pl in pls)
                Assert.AreEqual(f.Id, pl.FrameworkId);

            VerifyPerformanceLevelsShortNamesForFramework(pls, "UNS", "BAS", "PRO", "DIS");
            VerifyPerformanceLevelsFullNamesForFramework(pls, "Unsatisfactory", "Basic", "Proficient", "Distinguished");
            VerifyPerformanceLevelsDescriptionsForFramework(pls, 
                "Consistently does not meet expected levels of performance",
                "Occasionally meets expected levels of performance",
                "Consistently meets expected levels of performance", 
                "Clearly and consistently exceeds expected levels of performance");

            f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
            pls = Fixture.SEMgr.GetPerformanceLevelsForFramework(f.Id);
            VerifyPerformanceLevelsEnumsForFramework(pls, SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4);
            VerifyPerformanceLevelsShortNamesForFramework(pls, "UNS", "BAS", "PRO", "DIS");
            VerifyPerformanceLevelsFullNamesForFramework(pls, "Unsatisfactory", "Basic", "Proficient", "Distinguished");
            VerifyPerformanceLevelsDescriptionsForFramework(pls,
               "Consistently does not meet expected levels of performance",
                "Occasionally meets expected levels of performance",
                "Consistently meets expected levels of performance",
                "Clearly and consistently exceeds expected levels of performance");
         }
    }
}
