using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

using NUnit.Framework;
using DbUtils;

using RepositoryLib;

namespace StateEval.tests.objectModel
{
     [TestFixture]
    class tResource : tBase
    {
         protected void VerifyResourceLoad(SEResource resource, long repoItemId, string districtCode, string schoolCode, string itemName,
                                            string description, long userId, string comments, string url, string fileName,
                                            string fileExt, string contentType, bool isFile)
         {
             Assert.AreEqual(resource.Id, resource.Id);
             Assert.AreEqual(resource.RepositoryItemId, repoItemId);
             Assert.AreEqual(resource.DistrictCode, districtCode);
             Assert.AreEqual(resource.SchoolCode, schoolCode);
             Assert.AreEqual(resource.ItemName, itemName);
             Assert.AreEqual(resource.Description, description);
             Assert.AreEqual(resource.OwnerId, userId);
             Assert.AreEqual(resource.Url, url);
             Assert.AreEqual(resource.FileName, fileName);
             Assert.AreEqual(resource.FileExt, fileExt);
             Assert.AreEqual(resource.ContentType, contentType);
             Assert.AreEqual(resource.IsFile, isFile);
             Assert.AreEqual(resource.Comments, comments);
         }   

         protected void VerifyUrlresourceLoad(SEResource resource, long repoItemId, string districtCode, string schoolCode, string itemName,
                                            string description, long userId, string url, string comments)
         {
             VerifyResourceLoad(resource, repoItemId, districtCode, schoolCode, itemName, description, userId, comments, url, "", "", "URL", false);
         }

         protected void VerifyFileResourceLoad(SEResource resource, long repoItemId, string districtCode, string schoolCode,  string itemName,
                                   string description, long userId, string fileName, string fileExt, string contentType, string comments, bool isPublic)
         {
             VerifyResourceLoad(resource, repoItemId, districtCode, schoolCode, itemName, description, userId, comments, "", fileName, fileExt, contentType, true);
         }

         protected void VerifyResourceSave(SEResource resource, string new_comments)
         {
             resource.Comments = new_comments;
             resource.Save();

             SEResource reloadedresource = Fixture.SEMgr.Resource(resource.Id);
             long bitStreamId = resource.BitStreamId;
             DateTime initialUpload = resource.InitialUpload;
             DateTime lastUpload = resource.LastUpload;
 
             Assert.AreEqual(reloadedresource.Comments, new_comments);
   
             // Comments should not be modified when Updateresource is called
             reloadedresource = Fixture.SEMgr.Resource(resource.Id);
             Assert.AreEqual(reloadedresource.Comments, new_comments);
             Assert.AreEqual(lastUpload, resource.LastUpload);
             Assert.AreEqual(initialUpload, resource.InitialUpload);
             Assert.AreEqual(bitStreamId, resource.BitStreamId);
         }

         protected long CreateTestResource(SEUser testUser, string districtCode, string schoolCode, string itemName)
         {
             string url = "http://www.google.com";
             string comments = "Google Website";
              
             long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

             RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstreamAsURL(testUser.Id, rootFolderId, url, itemName, "");
             long resourceId = Fixture.SEMgr.InsertResource(Fixture.CurrentSchoolYear, testUser, districtCode, schoolCode, ri, SEResourceType.GENERAL, comments, false);
   
             return resourceId;
         }

         [Test]
         [Ignore("Doesn't catch exception with distributed transaction setup")]
         public void UniqueItemName()
         {
             SEUser testUser_NorthThurstonDistrictUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUser);

             SEResource resource_T1 = Fixture.SEMgr.Resource(CreateTestResource(testUser_NorthThurstonDistrictUser, PilotDistricts.NorthThurston, "", "T1"));

             try
             {
                 SEResource resource_T2 = Fixture.SEMgr.Resource(CreateTestResource(testUser_NorthThurstonDistrictUser, PilotDistricts.NorthThurston, "", "T1"));
             }
             catch (Exception e)
             {
                // Throws a MTS exception about the distributed transaction
                 Assert.IsTrue(e.Message.Contains("with same name currently "));
             }
         }

         public int GetRowCountFromTable(DbConnector connector, string query)
         {
             SqlDataReader r = connector.ExecuteNonSpDataReader(query);
             r.Read();
             return Convert.ToInt32(r["Count"]);
         }

         [Test]
         public void DeleteResource()
         {
             SEUser testUser_NorthThurstonDistrictUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUser);
             SEUser testUser_OthelloDistrictUser = Fixture.SEMgr.SEUser(Fixture.OthelloDistrictUser);

             SEResource resource_T1 = Fixture.SEMgr.Resource(CreateTestResource(testUser_NorthThurstonDistrictUser, PilotDistricts.NorthThurston, "", "T1"));
             SEResource resource_T2 = Fixture.SEMgr.Resource(CreateTestResource(testUser_OthelloDistrictUser, PilotDistricts.NorthThurston, "", "T2"));

             long resourceId_T1 = resource_T1.Id;

             var resourceCountQuery = Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM SEResource"));
             var repoCountQuery = Convert.ToInt32(Fixture.RepoMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM RepositoryItem"));

             Assert.AreEqual(2, Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM SEResource")));
             Assert.AreEqual(2, Convert.ToInt32(Fixture.RepoMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM RepositoryItem")));
             resource_T1.Delete(Fixture.RepoMgr);

             Assert.AreEqual(1, Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM SEResource")));
             Assert.AreEqual(1, Convert.ToInt32(Fixture.RepoMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM RepositoryItem")));

             Assert.IsNull(Fixture.SEMgr.Resource(resourceId_T1));
             Assert.IsNotNull(Fixture.SEMgr.Resource(resource_T2.Id));

             // Make sure repository item was deleted as well as resource
             // Try creating a new one with the same name
             try
             {
                 resourceId_T1 = CreateTestResource(testUser_NorthThurstonDistrictUser, PilotDistricts.NorthThurston, "",  "T1");
             }
             catch (Exception e)
             {
                 Assert.Fail("Could not create an resource with the same name after deletion. " + e.Message);
             }

         }

         [Test]
         public void GetResources()
         {
             SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUser);
 
             CreateTestResource(testUser, PilotDistricts.NorthThurston, "", "D1");
             CreateTestResource(testUser, PilotDistricts.NorthThurston, "", "D2");

             CreateTestResource(testUser, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, "S1");

             Assert.AreEqual(2, Fixture.SEMgr.DistrictResources(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston).Length);
             Assert.AreEqual(1, Fixture.SEMgr.SchoolResources(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS).Length);
         }

         [Test]
         public void IDbObject()
         {
             string url = "http://www.google.com";
             string itemName;
             string comments = "Google Website";

             SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUser);
             long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

             itemName = "Test District";
             RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstreamAsURL(testUser.Id, rootFolderId, url, itemName, "");
             long resourceId = Fixture.SEMgr.InsertResource(Fixture.CurrentSchoolYear, testUser, PilotDistricts.NorthThurston, "", ri, SEResourceType.GENERAL, comments, false);
             SEResource resource = Fixture.SEMgr.Resource(resourceId);

             Assert.AreEqual(resource.Id, ((IDbObject)resource).Id);
         }

        [Test]
        public void CreateUrlResource()
        {
            string url = "http://www.google.com";
            string itemName;
            string comments = "Google Website";
            string comments2 = "Goolde Website 2";

            SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUser);
            long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

            // Create a district resource
            itemName = "Test District";
            RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstreamAsURL(testUser.Id, rootFolderId, url, itemName, "");
            long resourceId = Fixture.SEMgr.InsertResource(Fixture.CurrentSchoolYear, testUser, PilotDistricts.NorthThurston, "", ri, SEResourceType.GENERAL, comments, false);
            SEResource resource = Fixture.SEMgr.Resource(resourceId);
            VerifyUrlresourceLoad(resource, ri.Id, PilotDistricts.NorthThurston, "", itemName, "", testUser.Id, url, comments);

            VerifyResourceSave(resource, comments2);

            // Create a school resource
            itemName = "Test School";
            ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstreamAsURL(testUser.Id, rootFolderId, url, itemName, "");
            resourceId = Fixture.SEMgr.InsertResource(Fixture.CurrentSchoolYear, testUser, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, ri, SEResourceType.GENERAL, comments, false);
            resource = Fixture.SEMgr.Resource(resourceId);
            VerifyUrlresourceLoad(resource, ri.Id, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, itemName, "", testUser.Id, url, comments);
        }

        [Test]
        public void CreateFileResource()
        {
            string itemName;
            string desc = "Test File";
            string contentType = "text/plain";
            string fileName = "test";
            string fileExt = "txt";
            string comments = "comments";
            string comments2 = "Goolde Website 2";

            SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUser);
            long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

            // Create a district resource

            itemName = "TestDistrict";
            byte[] bytes = new byte[1];
            RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstream(testUser.Id, rootFolderId, bytes, contentType, itemName, fileName, fileExt, desc, bytes.Length);
            long resourceId = Fixture.SEMgr.InsertResource(Fixture.CurrentSchoolYear, testUser, PilotDistricts.NorthThurston, "",  ri, SEResourceType.GENERAL, comments, true);

            SEResource resource = Fixture.SEMgr.Resource(resourceId);

            VerifyFileResourceLoad(resource, ri.Id, PilotDistricts.NorthThurston, "", itemName, desc, testUser.Id, fileName, fileExt, contentType, comments, false);

            VerifyResourceSave(resource, comments2);

            // Create a school resource

            itemName = "TestSchool";
            ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstream(testUser.Id, rootFolderId, bytes, contentType, itemName, fileName, fileExt, desc, bytes.Length);
            resourceId = Fixture.SEMgr.InsertResource(Fixture.CurrentSchoolYear, testUser, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, ri, SEResourceType.GENERAL, comments, true);

            resource = Fixture.SEMgr.Resource(resourceId);

            VerifyFileResourceLoad(resource, ri.Id, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, itemName, desc, testUser.Id, fileName, fileExt, contentType, comments, false);

        }

        protected void TestResourceTypeInner(SEResourceType expectedType, string name)
        {
            SEResourceType actualType = (SEResourceType)Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("select ResourceTypeID from SEResourceType where name='" + name + "'"));
            Assert.AreEqual(expectedType, actualType);

            // It will throw an exception if there isn't a case for it
            try
            {
                SEResource.MapResourceTypeToString(expectedType);
            }
            catch
            {
                Assert.Fail("Missing case for " + expectedType);
            }
        }

        [Test]
        public void ResourceTypes()
        {
            TestResourceTypeInner(SEResourceType.GENERAL, "General");
            TestResourceTypeInner(SEResourceType.GOAL, "Goal");
            TestResourceTypeInner(SEResourceType.PRE_CONFERENCE, "Pre-Conference");
            TestResourceTypeInner(SEResourceType.POST_CONFERENCE, "Post-Conference");
            Assert.AreEqual(Convert.ToInt32(SEResourceType.POST_CONFERENCE), Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("select COUNT(*) from SEResourceType")));
        }

    }
}
