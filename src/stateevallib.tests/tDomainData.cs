using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NUnit.Framework;

using StateEval;

namespace StateEval.tests
{
	[TestFixture]
	public class tDomainData
	{	
		[Test]
		public void TestSchoolName()
		{
			String target = DomainData.SchoolName(PilotSchools.NorthThurston_NorthThurstonHS).Trim();
			Assert.AreEqual("North Thurston High School", target);
		}
		[Test]
		public void TestDistrictName()
		{
			String target = DomainData.DistrictName(PilotDistricts.NorthThurston);
            Assert.AreEqual("North Thurston Public Schools", target);
		}
	}
}
