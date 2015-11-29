using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using StateEval;
using EDSIntegrationLib;
using NUnit.Framework;

namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tLocalityRoleContainer
    {
        /*
         * as passed from eds, the role string looks like...
         * 
         *  NameOfSchoolOrDistrict;SchoolOrDistrictCode;role1;role2;role....
         *  
         * as in... 
         * 
         *      Peninsula High School;2681;CSSchoolAdvisorR;CSSchoolAdvisorW
         *      
         * in addition to the above, the LRC is capable of understanding multiple role strings smushed together, separated by '|'
         * 
         */
        [Test]
        public void Basics()
        {
            LocalityRoleContainer lrc = new LocalityRoleContainer("Peninsula High School;2681;CSSchoolAdvisorR;CSSchoolAdvisorW");

            Assert.IsFalse(lrc.IsSchool("XXXX"));
            Assert.IsTrue(lrc.LooksLikeSchool("XXXX"));
            Assert.IsFalse(lrc.LooksLikeSchool("XXXXX"));
            Assert.AreEqual(lrc.DistrictCodeFor("XXXX"), lrc.BogusDistrict);

            Assert.IsTrue(lrc.IsSchool("2681"));
            Assert.AreEqual(lrc.DistrictCodeFor("2681"), "27401");

            Assert.AreEqual("Peninsula High School;2681;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.ToString());
            Assert.AreEqual("Peninsula High School;2681;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.RolesAtString("2681"));
            Assert.AreEqual("Peninsula High School", lrc.OrgNameOf("2681"));
            Assert.AreEqual(1, lrc.Localities.Count);

            Assert.AreEqual(2, lrc.htRolesAt("2681").Count);
            Assert.IsTrue(lrc.htRolesAt("2681").ContainsKey("CSSchoolAdvisorR"));
            Assert.IsTrue(lrc.htRolesAt("2681").ContainsKey("CSSchoolAdvisorW"));

            Assert.AreEqual(2, lrc.RolesAtList("2681").Count);
            Assert.AreEqual(lrc.RolesAtList("2681")[0], "CSSchoolAdvisorR");
            Assert.AreEqual(lrc.RolesAtList("2681")[1], "CSSchoolAdvisorW");





            lrc = new LocalityRoleContainer("Peninsula High School;2681;CSSchoolAdvisorR;CSSchoolAdvisorW"
                    + "|West Seattle High School;2234;CSSchoolPrincipal;CSSchoolAdvisorM;CSSchoolAdvisorR;CSSchoolAdvisorW");

            Assert.AreEqual("Peninsula High School;2681;CSSchoolAdvisorR;CSSchoolAdvisorW"
                    + "|West Seattle High School;2234;CSSchoolPrincipal;CSSchoolAdvisorM;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.ToString());

            Assert.AreEqual(2, lrc.Localities.Count);


            Assert.AreEqual("Peninsula High School;2681;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.RolesAtString("2681"));
            Assert.AreEqual("Peninsula High School", lrc.OrgNameOf("2681"));

            Assert.AreEqual(2, lrc.htRolesAt("2681").Count);
            Assert.IsTrue(lrc.htRolesAt("2681").ContainsKey("CSSchoolAdvisorR"));
            Assert.IsTrue(lrc.htRolesAt("2681").ContainsKey("CSSchoolAdvisorW"));

            Assert.AreEqual(2, lrc.RolesAtList("2681").Count);
            Assert.AreEqual(lrc.RolesAtList("2681")[0], "CSSchoolAdvisorR");
            Assert.AreEqual(lrc.RolesAtList("2681")[1], "CSSchoolAdvisorW");


            Assert.AreEqual("West Seattle High School;2234;CSSchoolPrincipal;CSSchoolAdvisorM;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.RolesAtString("2234"));
            Assert.AreEqual("West Seattle High School", lrc.OrgNameOf("2234"));
            Assert.AreEqual(2, lrc.Localities.Count);

            Assert.AreEqual(4, lrc.htRolesAt("2234").Count);
            Assert.IsTrue(lrc.htRolesAt("2234").ContainsKey("CSSchoolPrincipal"));
            Assert.IsTrue(lrc.htRolesAt("2234").ContainsKey("CSSchoolAdvisorM"));
            Assert.IsTrue(lrc.htRolesAt("2234").ContainsKey("CSSchoolAdvisorR"));
            Assert.IsTrue(lrc.htRolesAt("2234").ContainsKey("CSSchoolAdvisorW"));

            Assert.AreEqual(4, lrc.RolesAtList("2234").Count);
            Assert.AreEqual(lrc.RolesAtList("2234")[0], "CSSchoolPrincipal");
            Assert.AreEqual(lrc.RolesAtList("2234")[1], "CSSchoolAdvisorM");
            Assert.AreEqual(lrc.RolesAtList("2234")[2], "CSSchoolAdvisorR");
            Assert.AreEqual(lrc.RolesAtList("2234")[3], "CSSchoolAdvisorW");

        }
    }
}
