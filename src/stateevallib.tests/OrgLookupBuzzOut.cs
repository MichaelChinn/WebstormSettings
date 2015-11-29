using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using StateEval;
using System.Xml;
using System.Xml.Schema;


using EDSIntegrationLib.OSPIEntityLookupService;

using NUnit.Framework;
using EDSIntegrationLib;


namespace StateEval.tests
{
    class OrgLookupBuzzOut
    {
        //[Test]
        public void ServiceFindsSchoolCode()
        {
            

            string districtName = null;
            string districtCode = null;
            string schoolName = null;
            DistrictSchoolEntityLookup.GetInfoForSchoolCode("3142", ref districtCode, ref districtName, ref schoolName);


            Assert.AreEqual("Benge School District", districtName);
        }
    }
}
