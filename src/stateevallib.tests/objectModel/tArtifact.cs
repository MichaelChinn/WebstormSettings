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
    class tArtifact : tBase
    {
         protected void VerifyArtifactLoad(SEArtifact artifact, long repoItemId, SESchoolYear schoolYear, SEArtifactType type, string itemName,
                                            string description, long userId, string comments, bool isPublic, string url, string fileName,
                                            string fileExt, string contentType, bool isFile)
         {
             Assert.AreEqual(artifact.Id, artifact.Id);
             Assert.AreEqual(artifact.RepositoryItemId, repoItemId);
             Assert.AreEqual(artifact.SchoolYear, Convert.ToInt16(schoolYear));
             Assert.AreEqual(artifact.ArtifactType, type);
             Assert.AreEqual(artifact.ItemName, itemName);
             Assert.AreEqual(artifact.Description, description);
             Assert.AreEqual(artifact.OwnerId, userId);
             Assert.AreEqual(artifact.Url, url);
             Assert.AreEqual(artifact.FileName, fileName);
             Assert.AreEqual(artifact.FileExt, fileExt);
             Assert.AreEqual(artifact.ContentType, contentType);
             Assert.AreEqual(artifact.IsFile, isFile);
             Assert.AreEqual(artifact.Comments, comments);
             Assert.AreEqual(artifact.IsPublic, isPublic);
         }   

         protected void VerifyUrlArtifactLoad(SEArtifact artifact, long repoItemId, SESchoolYear schoolYear, SEArtifactType type, string itemName,
                                            string description, long userId, string url, string comments, bool isPublic)
         {
             VerifyArtifactLoad(artifact, repoItemId, schoolYear, type, itemName, description, userId, comments, isPublic, url, "", "", "URL", false);
         }

         protected void VerifyFileArtifactLoad(SEArtifact artifact, long repoItemId, SESchoolYear schoolYear, SEArtifactType type, string itemName,
                                   string description, long userId, string fileName, string fileExt, string contentType, string comments, bool isPublic)
         {
             VerifyArtifactLoad(artifact, repoItemId, schoolYear, type, itemName, description, userId, comments, isPublic, "", fileName, fileExt, contentType, true);
         }

         protected void VerifyArtifactSave(SEArtifact artifact, string new_comments, SEArtifactType new_type, bool new_isPublic)
         {
             artifact.Comments = new_comments;
             artifact.ArtifactType = new_type;
             artifact.IsPublic = new_isPublic;
             artifact.Save();

             DateTime initialUpload = artifact.InitialUpload;
             DateTime lastUpload = artifact.LastUpload;
             long bitStreamId = artifact.BitStreamId;

             SEArtifact reloadedArtifact = Fixture.SEMgr.Artifact(artifact.Id);

             Assert.AreEqual(reloadedArtifact.Comments, new_comments);
             Assert.AreEqual(reloadedArtifact.ArtifactType, new_type);
             Assert.AreEqual(reloadedArtifact.IsPublic, new_isPublic);

             Fixture.SEMgr.UpdateArtifact(artifact.Id, !new_isPublic);

             // Comments and ArtifactType should not be modified when UpdateArtifact is called
             reloadedArtifact = Fixture.SEMgr.Artifact(artifact.Id);
             Assert.AreEqual(!new_isPublic, reloadedArtifact.IsPublic);
             Assert.AreEqual(new_comments, reloadedArtifact.Comments);
             Assert.AreEqual(new_type, reloadedArtifact.ArtifactType);
             Assert.AreEqual(lastUpload, reloadedArtifact.LastUpload);
             Assert.AreEqual(initialUpload, reloadedArtifact.InitialUpload);
             Assert.AreEqual(bitStreamId, reloadedArtifact.BitStreamId);
         }

         protected long CreateTestArtifact(SEUser testUser, string itemName, bool isPublic)
         {
             string url = "http://www.google.com";
             string comments = "Google Website";
             SEArtifactType type = SEArtifactType.OTHER;
             
             long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

             RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstreamAsURL(testUser.Id, rootFolderId, url, itemName, "");
             long artifactId = Fixture.SEMgr.InsertArtifact(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, ri, type, comments, false, -1, "", "", "", -1, SEEvaluationType.TEACHER_OBSERVATION, -1);
             SEArtifact a = Fixture.SEMgr.Artifact(artifactId);
 
             if (isPublic)
             {
                 a.IsPublic = true;
                 a.Save();
             }

             return artifactId;
         }

         [Test]
         [Ignore("Doesn't catch exception with distributed transaction setup")]
         public void UniqueItemName()
         {
             SEUser testUser_T1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEArtifact artifact_T1 = Fixture.SEMgr.Artifact(CreateTestArtifact(testUser_T1, "T1", false));

             try
             {
                 SEArtifact artifact_T2 = Fixture.SEMgr.Artifact(CreateTestArtifact(testUser_T1, "T1", false));
             }
             catch (Exception e)
             {
                 // Throws a MTS exception about the distributed transaction
                 Assert.IsTrue(e.Message.Contains("with same name currently "));
             }
         }

         [Test]
         public void DeleteArtifact()
         {
             SEUser testUser_T1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
             SEUser testUser_T2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);

             SEArtifact artifact_T1 = Fixture.SEMgr.Artifact(CreateTestArtifact(testUser_T1, "T1", false));
             SEArtifact artifact_T2 = Fixture.SEMgr.Artifact(CreateTestArtifact(testUser_T2, "T2", false));

             long artifactId_T1 = artifact_T1.Id;

             Assert.AreEqual(2, Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM SEArtifact")));
             Assert.AreEqual(2, Convert.ToInt32(Fixture.RepoMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM RepositoryItem")));

             artifact_T1.Delete(Fixture.RepoMgr);

             Assert.AreEqual(1, Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM SEArtifact")));
             Assert.AreEqual(1, Convert.ToInt32(Fixture.RepoMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM RepositoryItem")));

             Assert.IsNull(Fixture.SEMgr.Artifact(artifactId_T1));
             Assert.IsNotNull(Fixture.SEMgr.Artifact(artifact_T2.Id));

             // Make sure repository item was deleted as well as artifact
             // Try creating a new one with the same name
             try
             {
                 artifactId_T1 = CreateTestArtifact(testUser_T1, "T1", false);
             }
             catch (Exception e)
             {
                 Assert.Fail("Could not create an artifact with the same name after deletion. " + e.Message);
             }

         }

         [Test]
         public void GetArtifactsForUser()
         {
             // For a teacher
             SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
 
             CreateTestArtifact(testUser, "A1", false);
             CreateTestArtifact(testUser, "A2", false);
             CreateTestArtifact(testUser, "A3", true);

             Assert.AreEqual(1, Fixture.SEMgr.ArtifactsOwnedByUser(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, SEViewerType.EVALUATEE).Length);
             Assert.AreEqual(3, Fixture.SEMgr.ArtifactsOwnedByUser(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, SEViewerType.EVALUATEE).Length);

             // For a principal
             testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             CreateTestArtifact(testUser, "A1", false);
             CreateTestArtifact(testUser, "A2", false);
             CreateTestArtifact(testUser, "A3", true);

             Assert.AreEqual(1, Fixture.SEMgr.ArtifactsOwnedByUser(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, SEViewerType.EVALUATEE).Length);
             Assert.AreEqual(3, Fixture.SEMgr.ArtifactsOwnedByUser(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, SEViewerType.EVALUATEE).Length);
         }

        [Test]
        public void CreateUrlArtifact()
        {
            string url = "http://www.google.com";
            string itemName = "Google";
            string comments = "Google Website";
            string comments2 = "Goolde Website 2";
            SEArtifactType type = SEArtifactType.TR_INSTRUCTIONAL_PLANNING;
            SEArtifactType type2 = SEArtifactType.PROF_DEV;

            SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

            RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstreamAsURL(testUser.Id, rootFolderId, url, itemName, "");
            long artifactId = Fixture.SEMgr.InsertArtifact(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, ri, type, comments, false, -1, "", "", "", -1, SEEvaluationType.TEACHER_OBSERVATION, -1);
            SEArtifact artifact = Fixture.SEMgr.Artifact(artifactId);
            VerifyUrlArtifactLoad(artifact, ri.Id, Fixture.CurrentSchoolYear, type, itemName, "", testUser.Id, url, comments, false);

            VerifyArtifactSave(artifact, comments2, type2, true);
        }
        [Test]
         public void IDbObject()
        {
            string itemName = "Test";
            string desc = "Test File";
            string contentType = "text/plain";
            string fileName = "test";
            string fileExt = "txt";
            string comments = "comments";
            SEArtifactType type = SEArtifactType.TR_INSTRUCTIONAL_PLANNING;
 
            SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

            byte[] bytes = new byte[1];
            RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstream(testUser.Id, rootFolderId, bytes, contentType, itemName, fileName, fileExt, desc, bytes.Length);
            long artifactId = Fixture.SEMgr.InsertArtifact(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, ri, type, comments, true, -1, "", "", "", -1, SEEvaluationType.TEACHER_OBSERVATION, -1);

            SEArtifact artifact = Fixture.SEMgr.Artifact(artifactId);
            Assert.AreEqual(artifact.Id, ((IDbObject)artifact).Id);
        }

        protected void TestArtifactTypeInner(SEArtifactType expectedType)
        {
            SEArtifactType actualType = (SEArtifactType)Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("select ArtifactTypeID from SEArtifactType where ArtifactTypeID=" + Convert.ToInt32(expectedType)));
            // It will throw an exception if there isn't a case for it
            try
            {
                SEArtifact.MapArtifactTypeToString(expectedType);
            }
            catch
            {
                Assert.Fail("Missing or incorrect name for case for " + expectedType);
            }
        }

        [Test]
        public void ArtifactTypes()
        {
            List<SEArtifactType> vals = new List<SEArtifactType>((SEArtifactType[])Enum.GetValues(typeof(SEArtifactType)));
            foreach (SEArtifactType  v in vals)
            {
              TestArtifactTypeInner(v);
            }   
 
          Assert.AreEqual(Convert.ToInt32(SEArtifactType.LINKED_TO_VIDEO), Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("select COUNT(*) from SEArtifactType")));
        }

        [Test]
        public void CreateFileArtifact()
        {
            string itemName = "Test";
            string desc = "Test File";
            string contentType = "text/plain";
            string fileName = "test";
            string fileExt = "txt";
            string comments = "comments";
            string comments2 = "Goolde Website 2";
            SEArtifactType type = SEArtifactType.TR_INSTRUCTIONAL_PLANNING;
            SEArtifactType type2 = SEArtifactType.PROF_DEV;

            SEUser testUser = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            long rootFolderId = Fixture.RepoMgr.Repository(testUser.Id).Root.Id;

            byte[] bytes = new byte[1];
            RepositoryItem ri = Fixture.RepoMgr.AddRepoItemWithFirstBitstream(testUser.Id, rootFolderId, bytes, contentType, itemName, fileName, fileExt, desc, bytes.Length);
            long artifactId = Fixture.SEMgr.InsertArtifact(testUser.Id, Fixture.CurrentSchoolYear, testUser.DistrictCode, ri, type, comments, true, -1, "", "", "", -1, SEEvaluationType.TEACHER_OBSERVATION, -1);

            SEArtifact artifact = Fixture.SEMgr.Artifact(artifactId);

            VerifyFileArtifactLoad(artifact, ri.Id, Fixture.CurrentSchoolYear, type, itemName, desc, testUser.Id, fileName, fileExt, contentType, comments, false);

            VerifyArtifactSave(artifact, comments2, type2, true);
        }

        protected void AlignArtifactToRubricRow(SEArtifact artifact, SERubricRow[] rrows, string rrTitleStart)
        {
            SERubricRow rr = Fixture.FindRubricRowTitleStartWith(rrows, rrTitleStart);
            Assert.IsNotNull(rr);
            Fixture.SEMgr.AlignArtifactToRubricRow(artifact.Id, rr.Id);
        }

        protected void VerifyAlignedRubricRowCount(SEFramework framework, SEArtifact artifact, int count)
        {
            SERubricRow[] rrows = Fixture.SEMgr.AlignedRubricRowsForArtifact(framework.Id, artifact.Id);
            Assert.AreEqual(rrows.Length, count);
        }


        [Test]
        public void AlignedRubricRowsFoArtifactsForFrameworkNode()
        {
            SEUser testUser_T1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SEArtifact artifact_T99 = Fixture.SEMgr.Artifact(CreateTestArtifact(testUser_T1, "T99", true));

            SEFrameworkNode c1Node = Fixture.GetFrameworkNodeForDistrict(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE, "C1");
            SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");

            AlignArtifactToRubricRow(artifact_T99, rrows, "2b");
            AlignArtifactToRubricRow(artifact_T99, rrows, "3a");

            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);

            VerifyAlignedRubricRowCount(f, artifact_T99, 2);

            rrows = Fixture.SEMgr.AlignedRubricRowsForArtifactForFrameworkNode(c1Node.Id, artifact_T99.Id);
            Assert.AreEqual(Fixture.FindRubricRowTitleStartWith(rrows, "2b").FrameworkNodeId, c1Node.Id);
            Assert.AreEqual(Fixture.FindRubricRowTitleStartWith(rrows, "3a").FrameworkNodeId, c1Node.Id);

            SEFrameworkNode[] alignedNodes = Fixture.SEMgr.AlignedFrameworkNodesForArtifact(f.Id, artifact_T99.Id);
            Assert.AreEqual(alignedNodes.Length, 1);
            Assert.AreEqual(alignedNodes[0].ShortName, "C1");
        }

        [Test]
        public void AlignedRubricRows()
        {
            SEUser testUser_T1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser testUser_T2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);

            SEArtifact artifact_T1 = Fixture.SEMgr.Artifact(CreateTestArtifact(testUser_T1, "T1", false));
            SEArtifact artifact_T2 = Fixture.SEMgr.Artifact(CreateTestArtifact(testUser_T2, "T2", false));

            SEFrameworkNode c1Node = Fixture.GetFrameworkNodeForDistrict(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE, "C1");
            SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");

            AlignArtifactToRubricRow(artifact_T1, rrows, "2b");
            AlignArtifactToRubricRow(artifact_T1, rrows, "3a");
            AlignArtifactToRubricRow(artifact_T2, rrows, "2b");

            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);

            VerifyAlignedRubricRowCount(f, artifact_T1, 2);
            VerifyAlignedRubricRowCount(f, artifact_T2, 1);

            rrows = Fixture.SEMgr.AlignedRubricRowsForArtifact(f.Id, artifact_T1.Id);
            Assert.AreEqual(Fixture.FindRubricRowTitleStartWith(rrows, "2b").FrameworkNodeId, c1Node.Id);

            SEFrameworkNode[] alignedNodes = Fixture.SEMgr.AlignedFrameworkNodesForArtifact(f.Id, artifact_T1.Id);
            Assert.AreEqual(alignedNodes.Length, 1);
            Assert.AreEqual(alignedNodes[0].ShortName, "C1");

            Assert.AreEqual(1, Fixture.SEMgr.ArtifactsForUserForSummaryScreen(testUser_T1.Id, Fixture.CurrentSchoolYear, testUser_T1.DistrictCode, c1Node.Id).Length);

            SEFramework inF = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
            Assert.IsNotNull(inF);

            // The instructional framework has these aligned under D1 and D2
            alignedNodes = Fixture.SEMgr.AlignedFrameworkNodesForArtifact(inF.Id, artifact_T1.Id);
            Assert.AreEqual(alignedNodes.Length, 2);
            Assert.AreEqual(alignedNodes[0].ShortName, "D2");
            Assert.AreEqual(alignedNodes[1].ShortName, "D3");

            // Make sure a flush only removes ones for the specified artifact
            Fixture.SEMgr.FlushArtifactAlignment(artifact_T1.Id);

            VerifyAlignedRubricRowCount(f, artifact_T1, 0);
            VerifyAlignedRubricRowCount(f, artifact_T2, 1);


            // Make sure we can delete an artifact that has alignments.

            artifact_T2.Delete(Fixture.RepoMgr);
        }
    }
}
