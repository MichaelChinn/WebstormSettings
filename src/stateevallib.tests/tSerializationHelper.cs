using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NUnit.Framework;

using StateEval.Evaluation;
using StateEval.DataModels;
using StateEval.Contracts;
using StateEval;

namespace StateEval.tests
{
	[TestFixture]
	public class tSerializationHelper
	{
		string SCHOOLNAME_NorthThurstonHS = "North Thurston High School";

        protected void VerifyTestUser(SEUser target, CoreSEUser u)
        {
            Assert.Greater(target.Id, 0, "Target ID is zero");
            Assert.IsNotNull(target.DisplayName, "DisplayName empty");
            Assert.AreEqual(u.SEUserID, target.Id, "Source ID and target ID do not match");
            Assert.AreEqual(SCHOOLNAME_NorthThurstonHS, target.School.Trim(), "School name missing");
        }

		[Test]
		public void TestListMappingCoreSEUserToSEUser()
		{
			CoreSEUser u = GetTestUser();

			List<CoreSEUser> list = new List<CoreSEUser>();
			list.Add(u);

			List<SEUser> foo = SerializationHelper.MapEntityToUser(list);

			SEUser target = foo[0];
            VerifyTestUser(target, u);
			}

		[Test]
		public void TestObjectMappingCoreSEUserToSEUser()
		{
			CoreSEUser u = GetTestUser();

			SEUser target = SerializationHelper.MapEntityToUser(u);
            VerifyTestUser(target, u);
		}

		CoreSEUser GetTestUser()
		{
			CoreSEUser u = new CoreSEUser
			{
				SEUserID = 1,
                SchoolCode = PilotSchools.NorthThurston_NorthThurstonHS,
				DistrictCode = PilotDistricts.NorthThurston,
				FirstName = "jIM",
				LastName = "Bob"
			};
			return u;
		}
		UserContract GetTestUserContract()
		{
			UserContract u = new UserContract
			{
				Id = 1,
                SchoolCode = PilotSchools.NorthThurston_NorthThurstonHS,
                DistrictCode = PilotDistricts.NorthThurston,
                FirstName = "jIM",
                LastName = "Bob"
            };
			return u;
		}


		[Test]
		public void TestMappingUserContractToCoreSEUser()
		{
			CoreSEUser u = GetTestUser();
			UserContract testData = GetTestUserContract();

			UserContract target = SerializationHelper.MapToUserContract(u);
			Assert.Greater(target.Id, 0, "Target ID is zero");
			Assert.IsNotNull(target.DisplayName, "DisplayName empty");
			Assert.AreEqual(u.SEUserID, target.Id, "Source ID and target ID do not match");
            Assert.AreEqual(SCHOOLNAME_NorthThurstonHS, target.School.Trim(), "School name missing");
		}
	}
}
