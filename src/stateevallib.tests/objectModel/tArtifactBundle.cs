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
using StateEval;

namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tArtifactBundle 
    {
        SEArtifactBundle CreateTestArtifactBundle()
        {
            SEUser tr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(tr_nt.Id, Fixture.CurrentSchoolYear, tr_nt.DistrictCode);

            SEArtifactBundle b = SEArtifactBundle.Create(e.Id, "Comments", "Title");
            b.Save();
            return b;
        }

        [Test]
        public void CreateArtifactBundle()
        {
            SEArtifactBundle b = CreateTestArtifactBundle();
            SEArtifactBundle b2 = SEArtifactBundle.Get(b.Id);
            Assert.AreEqual(b2.Comments, b.Comments);
            Assert.AreEqual(b2.Title, b.Title);
            Assert.AreEqual(b2.Reflection, b.Reflection);
            Assert.AreEqual(b2.WfState, b.WfState);
            Assert.AreEqual(b2.LibItemIdList, b.LibItemIdList);
            Assert.AreEqual(b2.AlignmentRRIdList, b.AlignmentRRIdList);            
        }

        [Test]
        public void UpdateArtifactBundle()
        {
            SEArtifactBundle b = CreateTestArtifactBundle();
            b.Comments = "Comments2";
            b.Title = "Title2";
            b.Reflection = "Reflection2";
            b.AlignmentRRIdList = "1;2;3";

            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactLibItem i2 = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            b.AddLibItem(i);
            b.AddLibItem(i2);

            b.LibItemIdList = i.Id.ToString() + ";" + i2.Id.ToString();
            b.WfState = SEWfState.PRIVATE_EVIDENCE;
            b.Save();

            SEArtifactBundle b2 = SEArtifactBundle.Get(b.Id);
            Assert.AreEqual(b2.Comments, b.Comments);
            Assert.AreEqual(b2.Title, b.Title);
            Assert.AreEqual(b2.Reflection, b.Reflection);
            Assert.AreEqual(b2.LibItemIdList, b.LibItemIdList);
            Assert.AreEqual(b2.AlignmentRRIdList, b.AlignmentRRIdList);
            Assert.AreEqual(b2.WfState, b.WfState);            
        }

        [Test]
        public void CreateArtifactBundles()
        {
            SEArtifactBundle b = CreateTestArtifactBundle();
            SEArtifactBundle b2 = CreateTestArtifactBundle();
        
            List<SEArtifactBundle> bundles = SEArtifactBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.ARTIFACT);
            Assert.AreEqual(2, bundles.Count);
        }

        SEArtifactLibItem CreateTestArtifactLibItem(SEArtifactLibItemType type)
        {
            SEUser tr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(tr_nt.Id, Fixture.CurrentSchoolYear, tr_nt.DistrictCode);

            SEArtifactLibItem i = SEArtifactLibItem.Create(e.Id, "Comments", "Title");
            switch (type)
            {
                case SEArtifactLibItemType.WEB:
                    SetWebItemType(i, "http://www.google.com");
                    break;
                case SEArtifactLibItemType.FILE:
                    SetFileItemType(i, Guid.NewGuid());
                    break;
                case SEArtifactLibItemType.PROF_PRACTICE:
                    SetProfPracticeItemType(i, "ProfPractice");
                    break;
            }

            i.Save();
            return i;
        }

        void SetWebItemType(SEArtifactLibItem item, string webUrl)
        {
            item.ItemType = SEArtifactLibItemType.WEB;
            item.WebUrl = webUrl;

        }

        void SetFileItemType(SEArtifactLibItem item, Guid guid)
        {
            item.ItemType = SEArtifactLibItemType.FILE;
            item.FileUUID = guid;
        }

        void SetProfPracticeItemType(SEArtifactLibItem item, string notes)
        {
            item.ItemType = SEArtifactLibItemType.PROF_PRACTICE;
            item.ProfPracticeNotes = notes;
        }

        [Test]
        public void CreateArtifactWebLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);

            SEArtifactLibItem i2 = SEArtifactLibItem.Get(i.Id);
            Assert.AreEqual(i2.Comments, i.Comments);
            Assert.AreEqual(i2.Title, i.Title);
            Assert.AreEqual(i2.ItemType, i.ItemType);
            Assert.AreEqual(i2.WebUrl, i.WebUrl);
        }

        [Test]
        public void CreateArtifactFileUUIDLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.FILE);

            SEArtifactLibItem i2 = SEArtifactLibItem.Get(i.Id);
            Assert.AreEqual(i2.Comments, i.Comments);
            Assert.AreEqual(i2.Title, i.Title);
            Assert.AreEqual(i2.ItemType, i.ItemType);
            Assert.AreEqual(i2.FileUUID, i.FileUUID);
        }


        [Test]
        public void CreateArtifactProfPracticeLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.PROF_PRACTICE);

            SEArtifactLibItem i2 = SEArtifactLibItem.Get(i.Id);
            Assert.AreEqual(i2.Comments, i.Comments);
            Assert.AreEqual(i2.Title, i.Title);
            Assert.AreEqual(i2.ItemType, i.ItemType);
            Assert.AreEqual(i2.ProfPracticeNotes, i.ProfPracticeNotes);
        }


        [Test]
        public void CreateArtifactBundleWithNotSharedLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactLibItem i2 = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactBundle b = CreateTestArtifactBundle();
            Assert.AreEqual(0, b.LibItems.Count);

            b.AddLibItem(i);
            Assert.AreEqual(1, b.LibItems.Count);

            b.RemoveLibItem(i);

            b.AddLibItem(i);
            b.AddLibItem(i2);
            Assert.AreEqual(2, b.LibItems.Count);
            b.RemoveLibItem(i);
            Assert.AreEqual(1, b.LibItems.Count);
            b.RemoveLibItem(i2);
            Assert.AreEqual(0, b.LibItems.Count);

        }

        [Test]
        public void CreateArtifactBundleWithSharedLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactLibItem i2 = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactBundle b = CreateTestArtifactBundle();
            SEArtifactBundle b2 = CreateTestArtifactBundle();

            b.AddLibItem(i);
            Assert.AreEqual(1, b.LibItems.Count);

            b2.AddLibItem(i);
            Assert.AreEqual(1, b2.LibItems.Count);

            // make sure it is only removed from one
            b.RemoveLibItem(i);
            Assert.AreEqual(0, b.LibItems.Count);
            Assert.AreEqual(1, b2.LibItems.Count);

        }

        [Test]
        public void DeleteSharedLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactBundle b = CreateTestArtifactBundle();
            SEArtifactBundle b2 = CreateTestArtifactBundle();

            b.AddLibItem(i);
            b2.AddLibItem(i);

            try
            {
                i.Delete();
            }
            catch (Exception e)
            {
                Assert.IsTrue(e.Message.Contains("cannot be deleted") || e.Message.Contains("DTC"));
            }

        }

        [Test]
        public void DeleteBundleWithSharedLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactBundle b = CreateTestArtifactBundle();
            SEArtifactBundle b2 = CreateTestArtifactBundle();

            long id = b.Id;
            b.AddLibItem(i);
            b2.AddLibItem(i);
            b.Delete();

            Assert.IsNull(SEArtifactBundle.Get(id));
            Assert.IsNotNull(SEArtifactLibItem.Get(i.Id));
        }


        [Test]
        public void DeleteBundleWithNotSharedLibItem()
        {
            SEArtifactLibItem i = CreateTestArtifactLibItem(SEArtifactLibItemType.WEB);
            SEArtifactBundle b = CreateTestArtifactBundle();

            long id = b.Id;
            b.AddLibItem(i);
            b.Delete();

            Assert.IsNull(SEArtifactBundle.Get(id));
            Assert.IsNull(SEArtifactLibItem.Get(i.Id));
        }

        void GetArtifactBundlesByWfStateInner(SEArtifactBundle b, int artifactCount, int privateCount, int publicCount) 
        {
            Assert.AreEqual(artifactCount, SEArtifactBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.ARTIFACT).Count);
            Assert.AreEqual(privateCount, SEArtifactBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.PRIVATE_EVIDENCE).Count);
            Assert.AreEqual(publicCount, SEArtifactBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.PUBLIC_EVIDENCE).Count);
        }

        [Test]
        public void GetArtifactBundlesByWfState()
        {
            SEArtifactBundle b = CreateTestArtifactBundle();

            GetArtifactBundlesByWfStateInner(b, 1, 0, 0);

            b = SEArtifactBundle.Get(b.Id);
            Assert.AreEqual(SEWfState.ARTIFACT, b.WfState);
            b.WfState = SEWfState.PRIVATE_EVIDENCE;
            b.Save();

            GetArtifactBundlesByWfStateInner(b, 0, 1, 0);

            b = SEArtifactBundle.Get(b.Id);
            Assert.AreEqual(SEWfState.PRIVATE_EVIDENCE, b.WfState);
            b.WfState = SEWfState.PUBLIC_EVIDENCE;
            b.Save();

            GetArtifactBundlesByWfStateInner(b, 0, 0, 1);

            b = SEArtifactBundle.Get(b.Id);
            Assert.AreEqual(SEWfState.PUBLIC_EVIDENCE, b.WfState);
        }
    }
}
