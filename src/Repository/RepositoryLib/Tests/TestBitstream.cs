using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using RepositoryLib;
using System.IO;

using NUnit.Framework;
using DbUtils;


namespace RepositoryLib.Tests
{
    [TestFixture]
    public class TestBitstream : TestBase
    {
   
        [Test]
        public void TestBinaryPersist()
        {
            /*
             * read a file from test dir
             * put into repo
             * get back from repo
             * verify out==in
             * 
             */
            
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder root = u1t.Root;
            RepositoryItem item = root.AddItem("FirstItem", 1);
            Bundle bundle = item.Bundle;

            //read the test file
            string TestFileName = "BlueBombers";
            string extension = "xls";

            byte[] bIn;
            ReadStream(this.TestFileDir + "\\" + TestFileName + "." + extension, out bIn);
            bundle.AddBitstream(bIn, TestFileName, "xls", "application/octet", "aTestFile", true, 1);

            //now read it back...
            Bitstream theStream = bundle.Bitstreams[0];
            byte[] bReturn;
            theStream.GetData(out bReturn);

            Assert.AreEqual(theStream.ContentType, "application/octet");

            Assert.AreEqual(bIn.Length, bReturn.Length);

            for (int i = 0; i < bIn.Length; i++)
            {
                Assert.AreEqual(bIn[i], bReturn[i]);
            }

            WriteStream(this.TestFileDir + "\\_returned_" + TestFileName + "." + extension, bReturn);

            //test update with another file type...
            TestFileName = "ECMS Memorandum";
            extension = "doc";
            ReadStream(this.TestFileDir + "\\" + TestFileName + "." + extension, out bIn);
            theStream.PutData(bIn);

            theStream.GetData(out bReturn);
            Assert.AreEqual(bIn.Length, bReturn.Length);

            for (int i = 0; i < bIn.Length; i++)
            {
                Assert.AreEqual(bIn[i], bReturn[i]);
            }
            WriteStream(this.TestFileDir + "_returned_" + TestFileName + "." + extension, bReturn);

            //check that changing the name of the stream changes the extension as well
            theStream.Name = "foo.png";
            theStream.SaveMeta();

            theStream = bundle.Bitstreams[0];
            Assert.AreEqual(theStream.Extension, ".png");

            theStream.PutData(new byte[] { 5, 6, 7 });
            theStream = bundle.Bitstreams[0];

            byte[] returnData = new byte[3];
            theStream.GetData(out returnData);
            Assert.AreEqual(returnData[0], 5);
            Assert.AreEqual(returnData[1], 6);
            Assert.AreEqual(returnData[2], 7);
        }
 
        [Test]
        public void InOutToFileSystem()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder root = u1t.Root;
            RepositoryItem item = root.AddItem("FirstItem", 1);
            Bundle bundle = item.Bundle;

            //read the test file
            string TestFileName = "Picture5";
            string extension = "jpg";

            byte[] b;
            ReadStream(this.TestFileDir + "\\" + TestFileName + "." + extension, out b);
            bundle.AddBitstream(b, TestFileName, extension, "image/jpeg", "JPEG Test File", true, 1);

            //now read it back...
            Bitstream theStream = bundle.Bitstreams[0];
            byte[] bReturn;
            theStream.GetData(out bReturn);

            Assert.AreEqual(theStream.ContentType, "image/jpeg");

            Assert.AreEqual(b.Length, bReturn.Length);

            WriteStream(this.TestFileDir + "\\_returned_" + TestFileName + "." + extension, bReturn);
        }
        
        [Test]
        public void Add_Remove_Isolation()
        {
            //*******************************************
            // - set up three identical trees and make sure they're different
            //      user repo mgr to put first and next bitstreams
            // - Add a bitstream to the first tree, and do nothing to the others
            //      the name insures that it comes last amidst the group of bitstreams returned
            // - remove bitstream[1] and bitstream[2] from the first tree, and do nothing to the others
            // - Add a bitstream that has the same name as one already there 
            //      use the bundle to add the stream this time
            // - Replace a primary bitstream and make sure old one isn't anymore
            // - Recycle the folder and make sure that, even after all the 
            //      above the other bitstreams are okay

            //*******************************************
            //set up three identical trees and make sure they're different
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            const int u1Id=1;
            const int u2Id=2;
            const int u3Id=3;

            UserRepository u1t = mgr.SetupRepositoryForUser(u1Id);
            UserRepository u2t = mgr.SetupRepositoryForUser(u2Id);
            UserRepository u3t = mgr.SetupRepositoryForUser(u3Id);

            RepositoryFolder u1tRoot = u1t.Root;
            RepositoryFolder u1tRootSub = u1tRoot.AddFolder("a folder");
            RepositoryFolder u2tRoot = u2t.Root;
            RepositoryFolder u2tRootSub = u2tRoot.AddFolder("a folder");
            RepositoryFolder u3tRoot = u3t.Root;
            RepositoryFolder u3tRootSub = u3tRoot.AddFolder("a folder");

            string itemName = "A Generic Item name";

            SortedList<string, Bitstream> refStreams_u1 = new SortedList<string,Bitstream>();
            SortedList<string, Bitstream> refStreams_u2 = new SortedList<string,Bitstream>();
            SortedList<string, Bitstream> refStreams_u3 = new SortedList<string,Bitstream>();

            PutFirstBitstreamWithMgr(mgr, ref refStreams_u1, u1Id, u1tRootSub, new byte[]{1,2,3}, ""
                ,itemName, "FirstFileName.doc", ".doc", "the first stream in the u1t", 20);
            PutFirstBitstreamWithMgr(mgr, ref refStreams_u2, u2Id, u2tRootSub, new byte[]{1,2,3}, ""
                ,itemName, "FirstFileName.doc", ".doc", "the first stream in the u2t", 20);
            PutFirstBitstreamWithMgr(mgr, ref refStreams_u3, u3Id, u3tRootSub, new byte[]{1,2,3}, ""
                ,itemName, "FirstFileName.doc", ".doc", "the first stream in the u3t", 20);

            PutNextBitstreamWithMgr(mgr, ref refStreams_u1, u1Id, u1tRootSub, new byte[] { 1, 3, 5 },
                "", itemName, "SecondFileName.doc", ".doc", "the second stream in u1t", 11, false);
            PutNextBitstreamWithMgr(mgr, ref refStreams_u2, u2Id, u2tRootSub, new byte[] { 1, 3, 5 },
                "", itemName, "SecondFileName.doc", ".doc", "the second stream in u2t", 11, false);
            PutNextBitstreamWithMgr(mgr, ref refStreams_u3, u3Id, u3tRootSub, new byte[] { 1, 3, 5 },
                "", itemName, "SecondFileName.doc", ".doc", "the second stream in u3t", 11, false);

            PutNextBitstreamWithMgr(mgr, ref refStreams_u1, u1Id, u1tRootSub, new byte[] { 1, 3, 5 },
                "", itemName, "ThirdFileName.doc", ".doc", "the Third stream in u1t", 12, false);
            PutNextBitstreamWithMgr(mgr, ref refStreams_u2, u2Id, u2tRootSub, new byte[] { 1, 3, 5 },
                "", itemName, "ThirdFileName.doc", ".doc", "the Third stream in u2t", 12, false);
            PutNextBitstreamWithMgr(mgr, ref refStreams_u3, u3Id, u3tRootSub, new byte[] { 1, 3, 5 },
                "", itemName, "ThirdFileName.doc", ".doc", "the Third stream in u3t", 12, false);
  
            RepositoryItem item_u1 = u1tRootSub.FindChildItem(itemName);
            RepositoryItem item_u2 = u2tRootSub.FindChildItem(itemName);
            RepositoryItem item_u3 = u3tRootSub.FindChildItem(itemName);
            Bundle bundle_u1 = item_u1.Bundle;
            Bundle bundle_u2 = item_u2.Bundle;
            Bundle bundle_u3 = item_u3.Bundle;

            Assert.AreNotEqual(item_u1.Id, item_u2.Id);
            Assert.AreNotEqual(item_u1.Id, item_u3.Id);
            Assert.AreNotEqual(item_u2.Id, item_u3.Id);
            Assert.AreNotEqual(bundle_u1.Id, bundle_u2.Id);
            Assert.AreNotEqual(bundle_u1.Id, bundle_u3.Id);
            Assert.AreNotEqual(bundle_u2.Id, bundle_u3.Id);

            CheckBitstream(refStreams_u1, bundle_u1.Bitstreams);
            CheckBitstream(refStreams_u2, bundle_u2.Bitstreams);
            CheckBitstream(refStreams_u3, bundle_u3.Bitstreams);

            Assert.AreEqual(u1t.DiskUsage, 43);
            Assert.AreEqual(u2t.DiskUsage, 43);
            Assert.AreEqual(u3t.DiskUsage, 43);

            Bitstream u1tStream2 = bundle_u1.Bitstreams[2];
            Bitstream u2tStream2 = bundle_u2.Bitstreams[2];
            Bitstream u3tStream2 = bundle_u3.Bitstreams[2];

            Assert.AreNotEqual(u1tStream2, u2tStream2); 
            Assert.AreNotEqual(u1tStream2, u3tStream2);
            Assert.AreNotEqual(u2tStream2, u3tStream2);

            Assert.AreEqual(u1tStream2.BundleId, bundle_u1.Id);
            Assert.AreEqual(u2tStream2.BundleId, bundle_u2.Id);
            Assert.AreEqual(u3tStream2.BundleId, bundle_u3.Id);

            //***********************************************************************
            //Add a bitstream to the first tree, and do nothing to the others
            // the name insures that it comes last amidst the group of bitstreams returned
            PutNextBitstreamWithMgr(mgr, ref refStreams_u1, u1Id, u1tRootSub, new byte[] { 3, 10, 15 },
                "docfile.pdf", itemName, "zzz_A file unique.xls", ".xls", "zzz_something uniq to u1", 33, false);

            Assert.AreEqual(bundle_u1.Bitstreams.Length, 4);
            Assert.AreEqual(bundle_u2.Bitstreams.Length, 3);
            Assert.AreEqual(bundle_u3.Bitstreams.Length, 3);

            Assert.AreEqual(u1t.DiskUsage, 76);
            Assert.AreEqual(u2t.DiskUsage, 43);
            Assert.AreEqual(u3t.DiskUsage, 43);

            //***********************************************************************
            //remove bitstream[1] and bitstream[2] from the first tree, and do nothing to the others
            //.[1] + [2] size =23; don't use [0] because I don't want to check primary bitstream yet
            Bitstream b = bundle_u1.Bitstreams[1];

            mgr.DeleteBitstream(bundle_u1.Bitstreams[1].Id);
            mgr.DeleteBitstream(bundle_u1.Bitstreams[1].Id);    //bistreams[] regenerated at every call

            Assert.AreEqual(bundle_u1.Bitstreams.Length, 2);
            Assert.AreEqual(bundle_u2.Bitstreams.Length, 3);
            Assert.AreEqual(bundle_u3.Bitstreams.Length, 3);

            Assert.AreEqual(u1t.DiskUsage, 53);
            Assert.AreEqual(u2t.DiskUsage, 43);
            Assert.AreEqual(u3t.DiskUsage, 43);

            //***********************************************************************
            //Add a bitstream that has the same name as one already there 
            //..check that du is correct
            //..check that item is added, not replaced
            bundle_u1.AddBitstream(new byte[] { 11, 13, 1 }, "zz_A File unique.xls", ".xls", "foogle", "extra files", false, 1);
            bundle_u1.AddBitstream(new byte[] { 11, 13, 1, 2, 10 }, "zz_A File unique.xls", ".xls", "foogle", "extra files", false, 1);
            bundle_u1.AddBitstream(new byte[] { 11, 13 }, "zz_A File unique.xls", ".xls", "foogle", "extra files", false, 1);

            Assert.AreEqual(bundle_u1.Bitstreams.Length, 5);
            Assert.AreEqual(u1t.DiskUsage, 63);

            //***********************************************************************
            //Replace a primary bitstream and make sure old one isn't anymore

            //cleverly set the name to 'AAA... so that it shows up first, so that
            //if there is another bitstream set as primary, it will come later, and show
            //up as a different index.

            bundle_u1.AddBitstream(new byte[] { 11, 13, 1, 1,1,1 }, "AAA new primary bitstream", ".xls", "foogle", "extra files", true, 1);

            Bitstream[] streams = bundle_u1.Bitstreams;
            Assert.AreEqual(streams.Length, 6);
            Assert.AreEqual(u1t.DiskUsage, 69);

            int pri = -1;
            int i = 0;
            for (i = 0; i < streams.Length; i++)
            {
                Bitstream s = streams[i];
                if (s.IsPrimary)
                    pri = i;
            }

            Assert.AreEqual(pri, 0);
            
            //***********************************************************************
            //Recycle the folder and make sure that, even after all the 
            // above the other bitstreams are okay

            u1tRootSub.Recycle();
            mgr.EmptyRecycleBin(u1Id);

            u2tRootSub = u2tRoot.FindChildFolder("a Folder");
            item_u2 = u2tRootSub.FindChildItem(itemName);
            bundle_u2 = item_u2.Bundle;
            CheckBitstream(refStreams_u2, bundle_u2.Bitstreams);

            u3tRootSub = u3tRoot.FindChildFolder("a Folder");
            item_u3 = u3tRootSub.FindChildItem(itemName);
            bundle_u3 = item_u3.Bundle;
            CheckBitstream(refStreams_u3, bundle_u3.Bitstreams);
        }        
        
        [Test]
        public void UrlProcessing()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder u1tRoot = u1t.Root;
            RepositoryFolder u1tRootSub = u1tRoot.AddFolder("a folder");

            //single item add url and expect url back
            mgr.AddRepoItemWithFirstBitstreamAsURL(1, u1tRoot.Id, "http://moo.car.bomb", "itemName",  "desc");
            RepositoryItem item = u1t.Items[0];
            Bundle bundle = item.Bundle;
            Bitstream stream = bundle.Bitstreams[0];
            Assert.AreEqual(stream.URL, "http://moo.car.bomb");
            Assert.AreEqual(stream.ContentType, "URL");
            Assert.AreEqual(stream.Size, 0);
            Assert.AreEqual("", stream.Name);

            byte[] data = new byte[256];
            stream.GetData(out data);
            Assert.AreEqual(data.Length, 0);
            Assert.AreEqual(bundle.PrimaryBitstreamId, stream.Id);

            //add through bundle and expect url back
            stream = bundle.AddBitstreamAsURL("http://foo.bar.com", "url description", true, 1);
            Assert.AreEqual(stream.URL, "http://foo.bar.com");
            Assert.AreEqual(stream.ContentType, "URL");
            Assert.AreEqual(stream.Size, 0);
            Assert.AreEqual("", stream.Name);

            string message = "";       
            //single item add data when type is url
            try
            {
                mgr.AddRepoItemWithFirstBitstream(1, u1tRootSub.Id, new byte[] { 1, 2, 3 }
                    , "URL", "u1's first stream", "TheFile.ext", ".ext", "foogle", 3);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.IndexOf("valid") > 0);

            //add data through bundle and specify url
            try
            {
                bundle.AddBitstream(new byte[] { 1, 2, 3 }, "name", "ext", "URL", "description", false, 1);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.IndexOf("valid") > 0);

            Assert.AreEqual(0, u1t.DiskUsage);
        }

        private void WriteStream(string path, byte[] b)
        {
            System.IO.FileStream fs = new System.IO.FileStream(
                path
                , System.IO.FileMode.Create
                , System.IO.FileAccess.Write);

            fs.Write(b, 0, b.Length);
            fs.Close();
        }

        private void ReadStream(string path, out byte[] b)
        {
            System.IO.FileStream fs = new System.IO.FileStream
                        (path
                        , System.IO.FileMode.Open
                        , System.IO.FileAccess.Read);

            b = new byte[fs.Length];
            fs.Read(b, 0, b.Length);
            fs.Close();
        }

        [Test]
        public void MoveBitstream()
        {
            /*
             // make a simple move
             // disallow moves into different user's tree
             // get error for bogus destination item ID
             // get error for bogus bitstream ID
             // move primary bitstream with another bitstream in source bundle; verify another primary is set
             // move primary bitstream with no other bitstream in source bundle
             // move non-primary bitstream and check source primary 
             // move bitstream with intent of making it destination primary
             // move bitstream and leave destination primary alone             
             */

            // make a simple move
            // move primary bitstream with no other bitstream in source bundle

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 1 }, "firstTitle", "xxx", "fff", ".doc", "firstFile", 332);
            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 1 }, "secondTitle", "yyy", "fff", ".xls", "secondFile", 332);

            RepositoryItem itemOne = u1t.Root.FindChildItem("xxx");
            RepositoryItem itemTwo = u1t.Root.FindChildItem("yyy");

            Bitstream streamFromOne = itemOne.Bundle.Bitstreams[0]; 
            Bitstream streamFromTwo = itemTwo.Bundle.Bitstreams[0];
            mgr.MoveBitstreamItem(streamFromOne.Id, itemTwo.Id, false);

            Assert.AreEqual(0, itemOne.Bundle.Bitstreams.Length);
            Assert.AreEqual(2, itemTwo.Bundle.Bitstreams.Length);
            Assert.AreEqual(streamFromTwo.Id, itemTwo.Bundle.PrimaryBitstreamId);
            Assert.AreEqual(-1, itemOne.Bundle.PrimaryBitstreamId);

            streamFromOne = mgr.Bitstream(streamFromOne.Id);
            streamFromTwo = mgr.Bitstream(streamFromTwo.Id);
            Assert.IsFalse(streamFromOne.IsPrimary);
            Assert.IsTrue(streamFromTwo.IsPrimary);

            // move primary bitstream with another bitstream in source bundle; verify another primary is set
            // move bitstream and leave destination primary alone             
            this.FlushTrees();

            u1t = mgr.SetupRepositoryForUser(1);
            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 1 }, "_aaa_fileName", "xxx", "_aaa_fileName", ".doc", "_aaa_fileName", 332);
            itemOne = u1t.Root.FindChildItem("xxx");
            itemOne.Bundle.AddBitstream(new byte[] { 3, 4, 5 }, "_bbb_fileName", ".xls", "application/excel", "_bbb_fileName", false, 1);
            itemOne.Bundle.AddBitstream(new byte[] { 3, 4, 5 }, "_ccc_fileName", ".xls", "application/excel", "_ccc_fileName", false, 1);
            itemOne.Bundle.AddBitstream(new byte[] { 3, 4, 5 }, "_ddd_fileName", ".xls", "application/excel", "_ddd_fileName", false, 1);
            itemOne.Bundle.AddBitstream(new byte[] { 3, 4, 5 }, "_eee_fileName", ".xls", "application/excel", "_eee_fileName", false, 1);
            itemOne.Bundle.AddBitstream(new byte[] { 3, 4, 5 }, "_fff_fileName", ".xls", "application/excel", "_fff_fileName", false, 1);


            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 1 }, "_zzz_fileName", "yyy", "_zzz_fileName", ".xls", "_zzz_filename", 332);
            itemTwo = u1t.Root.FindChildItem("yyy");

            streamFromOne = mgr.Bitstream(itemOne.Bundle.PrimaryBitstreamId);
            streamFromTwo = itemTwo.Bundle.Bitstreams[0];
            mgr.MoveBitstreamItem(streamFromOne.Id, itemTwo.Id, false);

            Assert.AreEqual(streamFromTwo.Id, itemTwo.Bundle.PrimaryBitstreamId);
            Assert.AreNotEqual(-1, itemOne.Bundle.PrimaryBitstreamId);
            Assert.AreNotEqual(streamFromOne.Id, itemOne.Bundle.PrimaryBitstreamId);

            streamFromOne = mgr.Bitstream(streamFromOne.Id);
            streamFromTwo = mgr.Bitstream(streamFromTwo.Id);
            Assert.IsFalse(streamFromOne.IsPrimary);
            Assert.IsTrue(streamFromTwo.IsPrimary);

            Assert.AreEqual(5, itemOne.Bundle.Bitstreams.Length);
            Assert.AreEqual(2, itemTwo.Bundle.Bitstreams.Length);
            Assert.AreEqual("_bbb_fileName", itemOne.Bundle.Bitstreams[0].Name);
            Assert.AreEqual("_ccc_fileName", itemOne.Bundle.Bitstreams[1].Name);
            Assert.AreEqual("_ddd_fileName", itemOne.Bundle.Bitstreams[2].Name);
            Assert.AreEqual("_eee_fileName", itemOne.Bundle.Bitstreams[3].Name);
            Assert.AreEqual("_fff_fileName", itemOne.Bundle.Bitstreams[4].Name);

            Assert.AreEqual("_aaa_fileName", itemTwo.Bundle.Bitstreams[0].Name);
            Assert.AreEqual("_zzz_fileName", itemTwo.Bundle.Bitstreams[1].Name);



            // move non-primary bitstream and check source primary 
            Bitstream nonPrimary = itemOne.Bundle.Bitstreams[1];
            long firstPrimaryId = itemOne.Bundle.PrimaryBitstreamId;

            mgr.MoveBitstreamItem(nonPrimary.Id, itemTwo.Id, false);

            Assert.AreEqual(4, itemOne.Bundle.Bitstreams.Length);
            Assert.AreEqual(3, itemTwo.Bundle.Bitstreams.Length);
            Assert.AreEqual("_bbb_fileName", itemOne.Bundle.Bitstreams[0].Name);
            Assert.AreEqual("_ddd_fileName", itemOne.Bundle.Bitstreams[1].Name);
            Assert.AreEqual("_eee_fileName", itemOne.Bundle.Bitstreams[2].Name);
            Assert.AreEqual("_fff_fileName", itemOne.Bundle.Bitstreams[3].Name);

            Assert.AreEqual("_aaa_fileName", itemTwo.Bundle.Bitstreams[0].Name);
            Assert.AreEqual("_ccc_fileName", itemTwo.Bundle.Bitstreams[1].Name);
            Assert.AreEqual("_zzz_fileName", itemTwo.Bundle.Bitstreams[2].Name);

            Assert.AreEqual(firstPrimaryId, itemOne.Bundle.PrimaryBitstreamId);
            Assert.AreNotEqual(nonPrimary.Id, itemTwo.Bundle.PrimaryBitstreamId);


            // move bitstream with intent of making it destination primary
            streamFromOne = itemOne.Bundle.Bitstreams[0];
            mgr.MoveBitstreamItem(streamFromOne.Id, itemTwo.Id, true);
            Assert.AreEqual(3, itemOne.Bundle.Bitstreams.Length);
            Assert.AreEqual(4, itemTwo.Bundle.Bitstreams.Length);
            Assert.AreEqual("_ddd_fileName", itemOne.Bundle.Bitstreams[0].Name);
            Assert.AreEqual("_eee_fileName", itemOne.Bundle.Bitstreams[1].Name);
            Assert.AreEqual("_fff_fileName", itemOne.Bundle.Bitstreams[2].Name);

            Assert.AreEqual("_aaa_fileName", itemTwo.Bundle.Bitstreams[0].Name);
            Assert.AreEqual("_bbb_fileName", itemTwo.Bundle.Bitstreams[1].Name);
            Assert.AreEqual("_ccc_fileName", itemTwo.Bundle.Bitstreams[2].Name);
            Assert.AreEqual("_zzz_fileName", itemTwo.Bundle.Bitstreams[3].Name);

            Assert.AreEqual(streamFromOne.Id, itemTwo.Bundle.PrimaryBitstreamId);


            // disallow moves into different user's tree
            UserRepository u2t = mgr.SetupRepositoryForUser(2);
            mgr.AddRepoItemWithFirstBitstream(2, u2t.Root.Id, new byte[] { 4, 4, 4 }, "forsm", "user2 item", "foomm", ".xxx", "another test item", 47);

            string msg = "";
            try
            {
                mgr.MoveBitstreamItem(streamFromOne.Id, u2t.Root.Id, false);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("not owned by") > 0);

            // get error for bogus destination item ID
            msg = "";
            try
            {
                mgr.MoveBitstreamItem(streamFromOne.Id, 22444, false);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("destination repositoryItem")>0);

            // get error for bogus bitstream ID
            UserRepository u3t = mgr.SetupRepositoryForUser(3);
            mgr.AddRepoItemWithFirstBitstream(3, u3t.Root.Id, new byte[] { 4, 4, 4 }, "forsm", "user2 item", "foomm", ".xxx", "another test item", 47);

            msg = "";
            try
            {
                mgr.MoveBitstreamItem(34242, u3t.Root.Id, false);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("bitstream requested") > 0);


        }

        [Test]
        public void RenameBitstream()
        {
            /*
             // rename bitstream, check isolation
             // check extension changes when bitstream name changes
             // disallow name collisions with bitstreams
             // disallow renaming an url
             */

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 1 }, "application/msword", "firstItem", "bs1", ".doc", "firstFiledesc", 332);
            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 1 }, "application/vnd.ms-excel", "secondItem", "bs2", ".xls", "secondFiledesc", 332);

            RepositoryItem itemFirst = u1t.Root.FindChildItem("firstItem");
            Bundle bundleFirst = itemFirst.Bundle;
            Bitstream bitstreamFirst = bundleFirst.Bitstreams[0];
            bitstreamFirst.Name = "theFirstNewName.spl";
            bitstreamFirst.SaveMeta();
            bitstreamFirst = bundleFirst.Bitstreams[0];
            Assert.AreEqual("theFirstNewName.spl", bitstreamFirst.Name);
            //expect the extension to be changed
            Assert.AreEqual(".spl", bitstreamFirst.Extension);

            RepositoryItem itemSecond = u1t.Root.FindChildItem("secondItem");
            Bundle bundleSecond = itemSecond.Bundle;
            Bitstream bitstreamSecond = bundleSecond.Bitstreams[0];
            bitstreamSecond.Name = "theSecondNewName.spl";
            bitstreamSecond.SaveMeta();
            bitstreamSecond = bundleSecond.Bitstreams[0];
            Assert.AreEqual("theSecondNewName.spl", bitstreamSecond.Name);

            //just for grins, check isolation
            itemFirst = u1t.Root.FindChildItem("firstItem");
            bundleFirst = itemFirst.Bundle;
            bitstreamFirst = bundleFirst.Bitstreams[0];
            Assert.AreEqual("theFirstNewName.spl", bitstreamFirst.Name);



            Bitstream bitstreamThird = bundleSecond.AddBitstream(new byte[] { 1 }, "anotherName.spl", ".spl", "unknown", "description", false, 1);

            string msg = "foo";
            try
            {
                bitstreamThird.Name= "theSecondNewName.spl";
                bitstreamThird.SaveMeta();
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.GreaterOrEqual(msg.IndexOf("collision"), 0);

            Bitstream bitstreamFourth = bundleSecond.AddBitstreamAsURL("www.ddd.fff.rrr", "a description", 1);
            
            try
            {
                bitstreamFourth.Name = "Another Name";
                bitstreamFourth.SaveMeta();
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.GreaterOrEqual(msg.IndexOf("bitstream is url"), 0);


            bitstreamFirst = bundleFirst.Bitstreams[0];
            


            bitstreamFirst.Name = "flooble.xls";
            bitstreamFirst.SaveMeta();
            bitstreamFirst = bundleFirst.Bitstreams[0];
            Assert.AreEqual("flooble.xls", bitstreamFirst.Name);
            Assert.AreEqual(".xls", bitstreamFirst.Extension);
        }
    }
}
