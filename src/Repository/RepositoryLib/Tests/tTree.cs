using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using RepositoryLib;
using System.IO;
using System.Data.SqlClient;

using NUnit.Framework;

namespace RepositoryLib.Tests
{
	/*Remember to test:
	 *	recycle subtree when contained file has nonzero ref count
	 * */

    [TestFixture]
    public class tTree : TestBase
    {
        [Test]
        public void TreeInit()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            const int u1Id = 1;

            UserRepository u1t = mgr.SetupRepositoryForUser(u1Id);

            long quota = u1t.DiskQuota;
            Assert.AreEqual(250, quota);

        }

        [Test]
        public void FlushUserTreeWithBitstreams()
        {

            //*******************************************
            //set up three identical trees and make sure they're different
            // check to see if flushing tree distubs other user's bitstreams
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            const int u1Id = 1;
            const int u2Id = 2;
            const int u3Id = 3;

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

            SortedList<string, Bitstream> refStreams_u1 = new SortedList<string, Bitstream>();
            SortedList<string, Bitstream> refStreams_u2 = new SortedList<string, Bitstream>();
            SortedList<string, Bitstream> refStreams_u3 = new SortedList<string, Bitstream>();

            PutFirstBitstreamWithMgr(mgr, ref refStreams_u1, u1Id, u1tRootSub, new byte[] { 1, 2, 3 }, ""
                , itemName, "FirstFileName.doc", ".doc", "the first stream in the u1t", 20);
            PutFirstBitstreamWithMgr(mgr, ref refStreams_u2, u2Id, u2tRootSub, new byte[] { 1, 2, 3 }, ""
                , itemName, "FirstFileName.doc", ".doc", "the first stream in the u2t", 20);
            PutFirstBitstreamWithMgr(mgr, ref refStreams_u3, u3Id, u3tRootSub, new byte[] { 1, 2, 3 }, ""
                , itemName, "FirstFileName.doc", ".doc", "the first stream in the u3t", 20);

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

            mgr.FlushUserTree(1);

            //make sure that everything is flushed, including the userContext
            string sqlCmd = "select * from dbo.userRepoContext where ownerId = 1";
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pSqlCmd", sqlCmd)
            };
            SqlDataReader r = mgr.DbConnector.ExecuteDataReader("GetOneOff", aParams);
            Assert.IsFalse(r.Read());


            CheckBitstream(refStreams_u2, bundle_u2.Bitstreams);
            CheckBitstream(refStreams_u3, bundle_u3.Bitstreams);



        }
        [Test]
        public void AddFolderNameCollision()
        {
            /*
             * AddFolder 
             * Add another folder with the same name
             * 
             * Behavior is to just not add another folder, but return like nothing happened
             * */
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository tree = mgr.SetupRepositoryForUser(1);
            tree.Root.AddFolder("A folder name");
            string msg = "";
            try
            {
                tree.Root.AddFolder("A folder name");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.Greater(msg.IndexOf("currently exists"), 0);

        }
        [Test]
        public void BigTest()
        {
            /*
             * test a bunch of stuff:
		 
                 MoveSubtree
                    error conditon: "move to same home";
                    error conditon: "move tree to contained folder";
                    error conditon: "move to self";
                    error conditon: "move tree to different owner tree";
                    move a subtree to the left
                    move a subtree to the right

                GetChildFolderByName
                AddFolder
                    error condition: "name collision with another folder"

                RecycleFolder
                    error condition: "recycle root node"
                    error condition: "recycle recycle node"
			 
                EmptyRecycle 

                RenameFolder
                    error condition: "name taken by sibling"
                    check object name not changed on error
                    check object and db changed on success


             * tree was inspected visually after each move to verify
             * nodes ended up in the right place... then use testText to
             * formulate values expected back.
             * 
             * */

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();
            string msg = null;

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder fifthChild = u1t.Root.AddFolder("37,74");
            RepositoryFolder fourthChild = u1t.Root.AddFolder("29,36");
            RepositoryFolder thirdChild = u1t.Root.AddFolder("19,28");
            RepositoryFolder secondChild = u1t.Root.AddFolder("3,18");
            RepositoryFolder firstChild = u1t.Root.AddFolder("1,2");

            RepositoryFolder thirdGrandChild = fifthChild.AddFolder("62,73");
            RepositoryFolder secondGrandChild = fifthChild.AddFolder("52,61");
            RepositoryFolder firstGrandChild = fifthChild.AddFolder("38,51");

            thirdGrandChild.FindChildFolder("62,73");
            RepositoryFolder ri = thirdGrandChild.AddFolder("63,72");
            ri.AddFolder("70,71");
            ri.AddFolder("68,69");
            ri.AddFolder("66,67");
            ri.AddFolder("64,65");

            secondGrandChild.AddFolder("59,60");
            secondGrandChild.AddFolder("57,58");
            secondGrandChild.AddFolder("55,56");
            secondGrandChild.AddFolder("53,54");

            firstGrandChild.AddFolder("49,50");
            firstGrandChild.AddFolder("47,48");
            ri = firstGrandChild.AddFolder("39,46");

            ri.AddFolder("44,45");
            ri.AddFolder("42,43");
            ri.AddFolder("40,41");

            fourthChild.AddFolder("34,35");
            fourthChild.AddFolder("32,33");
            fourthChild.AddFolder("30,31");

            thirdChild.AddFolder("26,27");
            thirdChild.AddFolder("24,25");
            thirdChild.AddFolder("22,23");
            thirdChild.AddFolder("20,21");

            ri = secondChild.AddFolder("4,17");
            ri = ri.AddFolder("5,16");
            ri = ri.AddFolder("6,15");
            ri = ri.AddFolder("7,14");
            ri = ri.AddFolder("8,13");
            ri = ri.AddFolder("9,12");
            ri = ri.AddFolder("10,11");

            RepositoryFolder[] x1 = new RepositoryFolder[] {
				new RepositoryFolder (60,"root",0,77,1,-1,0)
				,new RepositoryFolder (66,"1,2",1,2,1,60,1)
				,new RepositoryFolder (65,"3,18",3,18,1,60,1)
				,new RepositoryFolder (92,"4,17",4,17,1,65,2)
				,new RepositoryFolder (93,"5,16",5,16,1,92,3)
				,new RepositoryFolder (94,"6,15",6,15,1,93,4)
				,new RepositoryFolder (95,"7,14",7,14,1,94,5)
				,new RepositoryFolder (96,"8,13",8,13,1,95,6)
				,new RepositoryFolder (97,"9,12",9,12,1,96,7)
				,new RepositoryFolder (98,"10,11",10,11,1,97,8)
				,new RepositoryFolder (64,"19,28",19,28,1,60,1)
				,new RepositoryFolder (91,"20,21",20,21,1,64,2)
				,new RepositoryFolder (90,"22,23",22,23,1,64,2)
				,new RepositoryFolder (89,"24,25",24,25,1,64,2)
				,new RepositoryFolder (88,"26,27",26,27,1,64,2)
				,new RepositoryFolder (63,"29,36",29,36,1,60,1)
				,new RepositoryFolder (87,"30,31",30,31,1,63,2)
				,new RepositoryFolder (86,"32,33",32,33,1,63,2)
				,new RepositoryFolder (85,"34,35",34,35,1,63,2)
				,new RepositoryFolder (62,"37,74",37,74,1,60,1)
				,new RepositoryFolder (69,"38,51",38,51,1,62,2)
				,new RepositoryFolder (81,"39,46",39,46,1,69,3)
				,new RepositoryFolder (84,"40,41",40,41,1,81,4)
				,new RepositoryFolder (83,"42,43",42,43,1,81,4)
				,new RepositoryFolder (82,"44,45",44,45,1,81,4)
				,new RepositoryFolder (80,"47,48",47,48,1,69,3)
				,new RepositoryFolder (79,"49,50",49,50,1,69,3)
				,new RepositoryFolder (68,"52,61",52,61,1,62,2)
				,new RepositoryFolder (78,"53,54",53,54,1,68,3)
				,new RepositoryFolder (77,"55,56",55,56,1,68,3)
				,new RepositoryFolder (76,"57,58",57,58,1,68,3)
				,new RepositoryFolder (75,"59,60",59,60,1,68,3)
				,new RepositoryFolder (67,"62,73",62,73,1,62,2)
				,new RepositoryFolder (70,"63,72",63,72,1,67,3)
				,new RepositoryFolder (74,"64,65",64,65,1,70,4)
				,new RepositoryFolder (73,"66,67",66,67,1,70,4)
				,new RepositoryFolder (72,"68,69",68,69,1,70,4)
				,new RepositoryFolder (71,"70,71",70,71,1,70,4)
				,new RepositoryFolder (61,"_Recycle Bin",75,76,1,60,1)
			};

            CheckFolder(x1, u1t.RawFolderTree);

            //set up second identical tree...
            UserRepository u2t = mgr.SetupRepositoryForUser(2);
            fifthChild = u2t.Root.AddFolder("37,74");
            fourthChild = u2t.Root.AddFolder("29,36");
            thirdChild = u2t.Root.AddFolder("19,28");
            secondChild = u2t.Root.AddFolder("3,18");
            firstChild = u2t.Root.AddFolder("1,2");

            thirdGrandChild = fifthChild.AddFolder("62,73");
            secondGrandChild = fifthChild.AddFolder("52,61");
            firstGrandChild = fifthChild.AddFolder("38,51");

            thirdGrandChild.FindChildFolder("62,73");
            ri = thirdGrandChild.AddFolder("63,72");
            ri.AddFolder("70,71");
            ri.AddFolder("68,69");
            ri.AddFolder("66,67");
            ri.AddFolder("64,65");

            secondGrandChild.AddFolder("59,60");
            secondGrandChild.AddFolder("57,58");
            secondGrandChild.AddFolder("55,56");
            secondGrandChild.AddFolder("53,54");

            firstGrandChild.AddFolder("49,50");
            firstGrandChild.AddFolder("47,48");
            ri = firstGrandChild.AddFolder("39,46");

            ri.AddFolder("44,45");
            ri.AddFolder("42,43");
            ri.AddFolder("40,41");

            fourthChild.AddFolder("34,35");
            fourthChild.AddFolder("32,33");
            fourthChild.AddFolder("30,31");

            thirdChild.AddFolder("26,27");
            thirdChild.AddFolder("24,25");
            thirdChild.AddFolder("22,23");
            thirdChild.AddFolder("20,21");

            ri = secondChild.AddFolder("4,17");
            ri = ri.AddFolder("5,16");
            ri = ri.AddFolder("6,15");
            ri = ri.AddFolder("7,14");
            ri = ri.AddFolder("8,13");
            ri = ri.AddFolder("9,12");
            ri = ri.AddFolder("10,11");

            RepositoryFolder[] x2 = new RepositoryFolder[]{
				new RepositoryFolder (40,"root",0,77,2,-1,0)
				,new RepositoryFolder (46,"1,2",1,2,2,40,1)
				,new RepositoryFolder (45,"3,18",3,18,2,40,1)
				,new RepositoryFolder (72,"4,17",4,17,2,45,2)
				,new RepositoryFolder (73,"5,16",5,16,2,72,3)
				,new RepositoryFolder (74,"6,15",6,15,2,73,4)
				,new RepositoryFolder (75,"7,14",7,14,2,74,5)
				,new RepositoryFolder (76,"8,13",8,13,2,75,6)
				,new RepositoryFolder (77,"9,12",9,12,2,76,7)
				,new RepositoryFolder (78,"10,11",10,11,2,77,8)
				,new RepositoryFolder (44,"19,28",19,28,2,40,1)
				,new RepositoryFolder (71,"20,21",20,21,2,44,2)
				,new RepositoryFolder (70,"22,23",22,23,2,44,2)
				,new RepositoryFolder (69,"24,25",24,25,2,44,2)
				,new RepositoryFolder (68,"26,27",26,27,2,44,2)
				,new RepositoryFolder (43,"29,36",29,36,2,40,1)
				,new RepositoryFolder (67,"30,31",30,31,2,43,2)
				,new RepositoryFolder (66,"32,33",32,33,2,43,2)
				,new RepositoryFolder (65,"34,35",34,35,2,43,2)
				,new RepositoryFolder (42,"37,74",37,74,2,40,1)
				,new RepositoryFolder (49,"38,51",38,51,2,42,2)
				,new RepositoryFolder (61,"39,46",39,46,2,49,3)
				,new RepositoryFolder (64,"40,41",40,41,2,61,4)
				,new RepositoryFolder (63,"42,43",42,43,2,61,4)
				,new RepositoryFolder (62,"44,45",44,45,2,61,4)
				,new RepositoryFolder (60,"47,48",47,48,2,49,3)
				,new RepositoryFolder (59,"49,50",49,50,2,49,3)
				,new RepositoryFolder (48,"52,61",52,61,2,42,2)
				,new RepositoryFolder (58,"53,54",53,54,2,48,3)
				,new RepositoryFolder (57,"55,56",55,56,2,48,3)
				,new RepositoryFolder (56,"57,58",57,58,2,48,3)
				,new RepositoryFolder (55,"59,60",59,60,2,48,3)
				,new RepositoryFolder (47,"62,73",62,73,2,42,2)
				,new RepositoryFolder (50,"63,72",63,72,2,47,3)
				,new RepositoryFolder (54,"64,65",64,65,2,50,4)
				,new RepositoryFolder (53,"66,67",66,67,2,50,4)
				,new RepositoryFolder (52,"68,69",68,69,2,50,4)
				,new RepositoryFolder (51,"70,71",70,71,2,50,4)
				,new RepositoryFolder (41,"_Recycle Bin",75,76,2,40,1)
		};
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            msg = "recycle root node";
            try
            {
                u2t.Root.Recycle();
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("cannot recycle the root node") > 1, msg);
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            RepositoryFolder recycle = u2t.Root.FindChildFolder("_Recycle Bin");
            msg = "recycle recycle node";
            try
            {
                recycle.Recycle();
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("cannot recycle the recycle bin node") > 1, msg);
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);


            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            msg = "move tree to different owner tree";
            try
            {
                u1t.Root.Move(firstGrandChild);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("cannot have different owners") > 1, msg);
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            msg = "move to self";
            try
            {
                firstGrandChild.Move(firstGrandChild);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("urce and destination are the same") > 1, msg);
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            msg = "move tree to contained folder";
            try
            {
                fifthChild.Move(firstGrandChild);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("ination contained within subtree") > 1, msg);
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            msg = "move to same home";
            try
            {
                thirdGrandChild.Move(fifthChild);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("om/To folder the same") > 1, msg);
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            RepositoryFolder destFolder = thirdChild.FindChildFolder("24,25");

            //move node to the left
            secondGrandChild.Move(destFolder);
            x2 = new RepositoryFolder[]{
				new RepositoryFolder (40,"root",0,77,2,-1,0)
				,new RepositoryFolder (46,"1,2",1,2,2,40,1)
				,new RepositoryFolder (45,"3,18",3,18,2,40,1)
				,new RepositoryFolder (72,"4,17",4,17,2,45,2)
				,new RepositoryFolder (73,"5,16",5,16,2,72,3)
				,new RepositoryFolder (74,"6,15",6,15,2,73,4)
				,new RepositoryFolder (75,"7,14",7,14,2,74,5)
				,new RepositoryFolder (76,"8,13",8,13,2,75,6)
				,new RepositoryFolder (77,"9,12",9,12,2,76,7)
				,new RepositoryFolder (78,"10,11",10,11,2,77,8)
				,new RepositoryFolder (44,"19,28",19,38,2,40,1)
				,new RepositoryFolder (71,"20,21",20,21,2,44,2)
				,new RepositoryFolder (70,"22,23",22,23,2,44,2)
				,new RepositoryFolder (69,"24,25",24,35,2,44,2)
				,new RepositoryFolder (48,"52,61",25,34,2,69,3)
				,new RepositoryFolder (58,"53,54",26,27,2,48,4)
				,new RepositoryFolder (57,"55,56",28,29,2,48,4)
				,new RepositoryFolder (56,"57,58",30,31,2,48,4)
				,new RepositoryFolder (55,"59,60",32,33,2,48,4)
				,new RepositoryFolder (68,"26,27",36,37,2,44,2)
				,new RepositoryFolder (43,"29,36",39,46,2,40,1)
				,new RepositoryFolder (67,"30,31",40,41,2,43,2)
				,new RepositoryFolder (66,"32,33",42,43,2,43,2)
				,new RepositoryFolder (65,"34,35",44,45,2,43,2)
				,new RepositoryFolder (42,"37,74",47,74,2,40,1)
				,new RepositoryFolder (49,"38,51",48,61,2,42,2)
				,new RepositoryFolder (61,"39,46",49,56,2,49,3)
				,new RepositoryFolder (64,"40,41",50,51,2,61,4)
				,new RepositoryFolder (63,"42,43",52,53,2,61,4)
				,new RepositoryFolder (62,"44,45",54,55,2,61,4)
				,new RepositoryFolder (60,"47,48",57,58,2,49,3)
				,new RepositoryFolder (59,"49,50",59,60,2,49,3)
				,new RepositoryFolder (47,"62,73",62,73,2,42,2)
				,new RepositoryFolder (50,"63,72",63,72,2,47,3)
				,new RepositoryFolder (54,"64,65",64,65,2,50,4)
				,new RepositoryFolder (53,"66,67",66,67,2,50,4)
				,new RepositoryFolder (52,"68,69",68,69,2,50,4)
				,new RepositoryFolder (51,"70,71",70,71,2,50,4)
				,new RepositoryFolder (41,"_Recycle Bin",75,76,2,40,1)
			};
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            //move node to the right
            secondGrandChild.Move(fifthChild);
            x2 = new RepositoryFolder[]{
				new RepositoryFolder (40,"root",0,77,2,-1,0)
				,new RepositoryFolder (46,"1,2",1,2,2,40,1)
				,new RepositoryFolder (45,"3,18",3,18,2,40,1)
				,new RepositoryFolder (72,"4,17",4,17,2,45,2)
				,new RepositoryFolder (73,"5,16",5,16,2,72,3)
				,new RepositoryFolder (74,"6,15",6,15,2,73,4)
				,new RepositoryFolder (75,"7,14",7,14,2,74,5)
				,new RepositoryFolder (76,"8,13",8,13,2,75,6)
				,new RepositoryFolder (77,"9,12",9,12,2,76,7)
				,new RepositoryFolder (78,"10,11",10,11,2,77,8)
				,new RepositoryFolder (44,"19,28",19,28,2,40,1)
				,new RepositoryFolder (71,"20,21",20,21,2,44,2)
				,new RepositoryFolder (70,"22,23",22,23,2,44,2)
				,new RepositoryFolder (69,"24,25",24,25,2,44,2)
				,new RepositoryFolder (68,"26,27",26,27,2,44,2)
				,new RepositoryFolder (43,"29,36",29,36,2,40,1)
				,new RepositoryFolder (67,"30,31",30,31,2,43,2)
				,new RepositoryFolder (66,"32,33",32,33,2,43,2)
				,new RepositoryFolder (65,"34,35",34,35,2,43,2)
				,new RepositoryFolder (42,"37,74",37,74,2,40,1)
				,new RepositoryFolder (49,"38,51",38,51,2,42,2)
				,new RepositoryFolder (61,"39,46",39,46,2,49,3)
				,new RepositoryFolder (64,"40,41",40,41,2,61,4)
				,new RepositoryFolder (63,"42,43",42,43,2,61,4)
				,new RepositoryFolder (62,"44,45",44,45,2,61,4)
				,new RepositoryFolder (60,"47,48",47,48,2,49,3)
				,new RepositoryFolder (59,"49,50",49,50,2,49,3)
				,new RepositoryFolder (47,"62,73",52,63,2,42,2)
				,new RepositoryFolder (50,"63,72",53,62,2,47,3)
				,new RepositoryFolder (54,"64,65",54,55,2,50,4)
				,new RepositoryFolder (53,"66,67",56,57,2,50,4)
				,new RepositoryFolder (52,"68,69",58,59,2,50,4)
				,new RepositoryFolder (51,"70,71",60,61,2,50,4)
				,new RepositoryFolder (48,"52,61",64,73,2,42,2)
				,new RepositoryFolder (58,"53,54",65,66,2,48,3)
				,new RepositoryFolder (57,"55,56",67,68,2,48,3)
				,new RepositoryFolder (56,"57,58",69,70,2,48,3)
				,new RepositoryFolder (55,"59,60",71,72,2,48,3)
				,new RepositoryFolder (41,"_Recycle Bin",75,76,2,40,1)
			};
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            firstGrandChild.Recycle();

            x2 = new RepositoryFolder[]
			{
			new RepositoryFolder (40,"root",0,77,2,-1,0)
			,new RepositoryFolder (46,"1,2",1,2,2,40,1)
			,new RepositoryFolder (45,"3,18",3,18,2,40,1)
			,new RepositoryFolder (72,"4,17",4,17,2,45,2)
			,new RepositoryFolder (73,"5,16",5,16,2,72,3)
			,new RepositoryFolder (74,"6,15",6,15,2,73,4)
			,new RepositoryFolder (75,"7,14",7,14,2,74,5)
			,new RepositoryFolder (76,"8,13",8,13,2,75,6)
			,new RepositoryFolder (77,"9,12",9,12,2,76,7)
			,new RepositoryFolder (78,"10,11",10,11,2,77,8)
			,new RepositoryFolder (44,"19,28",19,28,2,40,1)
			,new RepositoryFolder (71,"20,21",20,21,2,44,2)
			,new RepositoryFolder (70,"22,23",22,23,2,44,2)
			,new RepositoryFolder (69,"24,25",24,25,2,44,2)
			,new RepositoryFolder (68,"26,27",26,27,2,44,2)
			,new RepositoryFolder (43,"29,36",29,36,2,40,1)
			,new RepositoryFolder (67,"30,31",30,31,2,43,2)
			,new RepositoryFolder (66,"32,33",32,33,2,43,2)
			,new RepositoryFolder (65,"34,35",34,35,2,43,2)
			,new RepositoryFolder (42,"37,74",37,60,2,40,1)
			,new RepositoryFolder (47,"62,73",38,49,2,42,2)
			,new RepositoryFolder (50,"63,72",39,48,2,47,3)
			,new RepositoryFolder (54,"64,65",40,41,2,50,4)
			,new RepositoryFolder (53,"66,67",42,43,2,50,4)
			,new RepositoryFolder (52,"68,69",44,45,2,50,4)
			,new RepositoryFolder (51,"70,71",46,47,2,50,4)
			,new RepositoryFolder (48,"52,61",50,59,2,42,2)
			,new RepositoryFolder (58,"53,54",51,52,2,48,3)
			,new RepositoryFolder (57,"55,56",53,54,2,48,3)
			,new RepositoryFolder (56,"57,58",55,56,2,48,3)
			,new RepositoryFolder (55,"59,60",57,58,2,48,3)
			,new RepositoryFolder (41,"_Recycle Bin",61,76,2,40,1)
			,new RepositoryFolder (49,"38,51",62,75,2,41,2)
			,new RepositoryFolder (61,"39,46",63,70,2,49,3)
			,new RepositoryFolder (64,"40,41",64,65,2,61,4)
			,new RepositoryFolder (63,"42,43",66,67,2,61,4)
			,new RepositoryFolder (62,"44,45",68,69,2,61,4)
			,new RepositoryFolder (60,"47,48",71,72,2,49,3)
			,new RepositoryFolder (59,"49,50",73,74,2,49,3)
			};

            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            u2t.EmptyRecycle();

            x2 = new RepositoryFolder[]{
				new RepositoryFolder (40,"root",0,63,2,-1,0)
				,new RepositoryFolder (46,"1,2",1,2,2,40,1)
				,new RepositoryFolder (45,"3,18",3,18,2,40,1)
				,new RepositoryFolder (72,"4,17",4,17,2,45,2)
				,new RepositoryFolder (73,"5,16",5,16,2,72,3)
				,new RepositoryFolder (74,"6,15",6,15,2,73,4)
				,new RepositoryFolder (75,"7,14",7,14,2,74,5)
				,new RepositoryFolder (76,"8,13",8,13,2,75,6)
				,new RepositoryFolder (77,"9,12",9,12,2,76,7)
				,new RepositoryFolder (78,"10,11",10,11,2,77,8)
				,new RepositoryFolder (44,"19,28",19,28,2,40,1)
				,new RepositoryFolder (71,"20,21",20,21,2,44,2)
				,new RepositoryFolder (70,"22,23",22,23,2,44,2)
				,new RepositoryFolder (69,"24,25",24,25,2,44,2)
				,new RepositoryFolder (68,"26,27",26,27,2,44,2)
				,new RepositoryFolder (43,"29,36",29,36,2,40,1)
				,new RepositoryFolder (67,"30,31",30,31,2,43,2)
				,new RepositoryFolder (66,"32,33",32,33,2,43,2)
				,new RepositoryFolder (65,"34,35",34,35,2,43,2)
				,new RepositoryFolder (42,"37,74",37,60,2,40,1)
				,new RepositoryFolder (47,"62,73",38,49,2,42,2)
				,new RepositoryFolder (50,"63,72",39,48,2,47,3)
				,new RepositoryFolder (54,"64,65",40,41,2,50,4)
				,new RepositoryFolder (53,"66,67",42,43,2,50,4)
				,new RepositoryFolder (52,"68,69",44,45,2,50,4)
				,new RepositoryFolder (51,"70,71",46,47,2,50,4)
				,new RepositoryFolder (48,"52,61",50,59,2,42,2)
				,new RepositoryFolder (58,"53,54",51,52,2,48,3)
				,new RepositoryFolder (57,"55,56",53,54,2,48,3)
				,new RepositoryFolder (56,"57,58",55,56,2,48,3)
				,new RepositoryFolder (55,"59,60",57,58,2,48,3)
				,new RepositoryFolder (41,"_Recycle Bin",61,62,2,40,1)
			};

            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            msg = "folder name collision on rename";
            try
            {
                thirdChild.Rename("29,36");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("currently exists") > 1, msg);

            Assert.AreEqual(thirdChild.Name, "19,28", "folder name collision failure");

            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            thirdChild.Rename("howdyDoody");

            RepositoryFolder m3C2 = u2t.Root.FindChildFolder("howdyDoody");

            Assert.AreNotEqual(m3C2, null);
            Assert.AreEqual(thirdChild.Id, m3C2.Id, "ids of third child and newly found 3rd child should be equal");

        }
        [Test]
        public void RecycleTree()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();
            //string msg = null;

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder fifthChild = u1t.Root.AddFolder("37,74");
            RepositoryFolder fourthChild = u1t.Root.AddFolder("29,36");
            RepositoryFolder thirdChild = u1t.Root.AddFolder("19,28");
            RepositoryFolder secondChild = u1t.Root.AddFolder("3,18");
            RepositoryFolder firstChild = u1t.Root.AddFolder("1,2");

            RepositoryFolder thirdGrandChild = fifthChild.AddFolder("62,73");
            RepositoryFolder secondGrandChild = fifthChild.AddFolder("52,61");
            RepositoryFolder firstGrandChild = fifthChild.AddFolder("38,51");

            thirdGrandChild.FindChildFolder("62,73");
            RepositoryFolder ri = thirdGrandChild.AddFolder("63,72");
            ri.AddFolder("70,71");
            ri.AddFolder("68,69");
            ri.AddFolder("66,67");
            ri.AddFolder("64,65");

            secondGrandChild.AddFolder("59,60");
            secondGrandChild.AddFolder("57,58");
            secondGrandChild.AddFolder("55,56");
            secondGrandChild.AddFolder("53,54");

            firstGrandChild.AddFolder("49,50");
            firstGrandChild.AddFolder("47,48");
            ri = firstGrandChild.AddFolder("39,46");

            ri.AddFolder("44,45");
            ri.AddFolder("42,43");
            ri.AddFolder("40,41");

            fourthChild.AddFolder("34,35");
            fourthChild.AddFolder("32,33");
            fourthChild.AddFolder("30,31");

            thirdChild.AddFolder("26,27");
            thirdChild.AddFolder("24,25");
            thirdChild.AddFolder("22,23");
            thirdChild.AddFolder("20,21");

            ri = secondChild.AddFolder("4,17");
            ri = ri.AddFolder("5,16");
            ri = ri.AddFolder("6,15");
            ri = ri.AddFolder("7,14");
            ri = ri.AddFolder("8,13");
            ri = ri.AddFolder("9,12");
            ri = ri.AddFolder("10,11");

            RepositoryFolder[] x1 = new RepositoryFolder[] {
				new RepositoryFolder (60,"root",0,77,1,-1,0)
				,new RepositoryFolder (66,"1,2",1,2,1,60,1)
				,new RepositoryFolder (65,"3,18",3,18,1,60,1)
				,new RepositoryFolder (92,"4,17",4,17,1,65,2)
				,new RepositoryFolder (93,"5,16",5,16,1,92,3)
				,new RepositoryFolder (94,"6,15",6,15,1,93,4)
				,new RepositoryFolder (95,"7,14",7,14,1,94,5)
				,new RepositoryFolder (96,"8,13",8,13,1,95,6)
				,new RepositoryFolder (97,"9,12",9,12,1,96,7)
				,new RepositoryFolder (98,"10,11",10,11,1,97,8)
				,new RepositoryFolder (64,"19,28",19,28,1,60,1)
				,new RepositoryFolder (91,"20,21",20,21,1,64,2)
				,new RepositoryFolder (90,"22,23",22,23,1,64,2)
				,new RepositoryFolder (89,"24,25",24,25,1,64,2)
				,new RepositoryFolder (88,"26,27",26,27,1,64,2)
				,new RepositoryFolder (63,"29,36",29,36,1,60,1)
				,new RepositoryFolder (87,"30,31",30,31,1,63,2)
				,new RepositoryFolder (86,"32,33",32,33,1,63,2)
				,new RepositoryFolder (85,"34,35",34,35,1,63,2)
				,new RepositoryFolder (62,"37,74",37,74,1,60,1)
				,new RepositoryFolder (69,"38,51",38,51,1,62,2)
				,new RepositoryFolder (81,"39,46",39,46,1,69,3)
				,new RepositoryFolder (84,"40,41",40,41,1,81,4)
				,new RepositoryFolder (83,"42,43",42,43,1,81,4)
				,new RepositoryFolder (82,"44,45",44,45,1,81,4)
				,new RepositoryFolder (80,"47,48",47,48,1,69,3)
				,new RepositoryFolder (79,"49,50",49,50,1,69,3)
				,new RepositoryFolder (68,"52,61",52,61,1,62,2)
				,new RepositoryFolder (78,"53,54",53,54,1,68,3)
				,new RepositoryFolder (77,"55,56",55,56,1,68,3)
				,new RepositoryFolder (76,"57,58",57,58,1,68,3)
				,new RepositoryFolder (75,"59,60",59,60,1,68,3)
				,new RepositoryFolder (67,"62,73",62,73,1,62,2)
				,new RepositoryFolder (70,"63,72",63,72,1,67,3)
				,new RepositoryFolder (74,"64,65",64,65,1,70,4)
				,new RepositoryFolder (73,"66,67",66,67,1,70,4)
				,new RepositoryFolder (72,"68,69",68,69,1,70,4)
				,new RepositoryFolder (71,"70,71",70,71,1,70,4)
				,new RepositoryFolder (61,"_Recycle Bin",75,76,1,60,1)
			};

            CheckFolder(x1, u1t.RawFolderTree);

            //set up second identical tree...
            UserRepository u2t = mgr.SetupRepositoryForUser(2);
            fifthChild = u2t.Root.AddFolder("37,74");
            fourthChild = u2t.Root.AddFolder("29,36");
            thirdChild = u2t.Root.AddFolder("19,28");
            secondChild = u2t.Root.AddFolder("3,18");
            firstChild = u2t.Root.AddFolder("1,2");

            thirdGrandChild = fifthChild.AddFolder("62,73");
            secondGrandChild = fifthChild.AddFolder("52,61");
            firstGrandChild = fifthChild.AddFolder("38,51");

            thirdGrandChild.FindChildFolder("62,73");
            ri = thirdGrandChild.AddFolder("63,72");
            ri.AddFolder("70,71");
            ri.AddFolder("68,69");
            ri.AddFolder("66,67");
            ri.AddFolder("64,65");

            secondGrandChild.AddFolder("59,60");
            secondGrandChild.AddFolder("57,58");
            secondGrandChild.AddFolder("55,56");
            secondGrandChild.AddFolder("53,54");

            firstGrandChild.AddFolder("49,50");
            firstGrandChild.AddFolder("47,48");
            ri = firstGrandChild.AddFolder("39,46");

            ri.AddFolder("44,45");
            ri.AddFolder("42,43");
            ri.AddFolder("40,41");

            fourthChild.AddFolder("34,35");
            fourthChild.AddFolder("32,33");
            fourthChild.AddFolder("30,31");

            thirdChild.AddFolder("26,27");
            thirdChild.AddFolder("24,25");
            thirdChild.AddFolder("22,23");
            thirdChild.AddFolder("20,21");

            ri = secondChild.AddFolder("4,17");
            ri = ri.AddFolder("5,16");
            ri = ri.AddFolder("6,15");
            ri = ri.AddFolder("7,14");
            ri = ri.AddFolder("8,13");
            ri = ri.AddFolder("9,12");
            ri = ri.AddFolder("10,11");

            RepositoryFolder[] x2 = new RepositoryFolder[]{
				new RepositoryFolder (40,"root",0,77,2,-1,0)
				,new RepositoryFolder (46,"1,2",1,2,2,40,1)
				,new RepositoryFolder (45,"3,18",3,18,2,40,1)
				,new RepositoryFolder (72,"4,17",4,17,2,45,2)
				,new RepositoryFolder (73,"5,16",5,16,2,72,3)
				,new RepositoryFolder (74,"6,15",6,15,2,73,4)
				,new RepositoryFolder (75,"7,14",7,14,2,74,5)
				,new RepositoryFolder (76,"8,13",8,13,2,75,6)
				,new RepositoryFolder (77,"9,12",9,12,2,76,7)
				,new RepositoryFolder (78,"10,11",10,11,2,77,8)
				,new RepositoryFolder (44,"19,28",19,28,2,40,1)
				,new RepositoryFolder (71,"20,21",20,21,2,44,2)
				,new RepositoryFolder (70,"22,23",22,23,2,44,2)
				,new RepositoryFolder (69,"24,25",24,25,2,44,2)
				,new RepositoryFolder (68,"26,27",26,27,2,44,2)
				,new RepositoryFolder (43,"29,36",29,36,2,40,1)
				,new RepositoryFolder (67,"30,31",30,31,2,43,2)
				,new RepositoryFolder (66,"32,33",32,33,2,43,2)
				,new RepositoryFolder (65,"34,35",34,35,2,43,2)
				,new RepositoryFolder (42,"37,74",37,74,2,40,1)
				,new RepositoryFolder (49,"38,51",38,51,2,42,2)
				,new RepositoryFolder (61,"39,46",39,46,2,49,3)
				,new RepositoryFolder (64,"40,41",40,41,2,61,4)
				,new RepositoryFolder (63,"42,43",42,43,2,61,4)
				,new RepositoryFolder (62,"44,45",44,45,2,61,4)
				,new RepositoryFolder (60,"47,48",47,48,2,49,3)
				,new RepositoryFolder (59,"49,50",49,50,2,49,3)
				,new RepositoryFolder (48,"52,61",52,61,2,42,2)
				,new RepositoryFolder (58,"53,54",53,54,2,48,3)
				,new RepositoryFolder (57,"55,56",55,56,2,48,3)
				,new RepositoryFolder (56,"57,58",57,58,2,48,3)
				,new RepositoryFolder (55,"59,60",59,60,2,48,3)
				,new RepositoryFolder (47,"62,73",62,73,2,42,2)
				,new RepositoryFolder (50,"63,72",63,72,2,47,3)
				,new RepositoryFolder (54,"64,65",64,65,2,50,4)
				,new RepositoryFolder (53,"66,67",66,67,2,50,4)
				,new RepositoryFolder (52,"68,69",68,69,2,50,4)
				,new RepositoryFolder (51,"70,71",70,71,2,50,4)
				,new RepositoryFolder (41,"_Recycle Bin",75,76,2,40,1)
		};
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            secondGrandChild.AddItem("a file here", 2);

            secondGrandChild.Recycle();

            x2 = new RepositoryFolder[] {
			new RepositoryFolder (40,"root",0,77,2,-1,0)
				,new RepositoryFolder (46,"1,2",1,2,2,40,1)
				,new RepositoryFolder (45,"3,18",3,18,2,40,1)
				,new RepositoryFolder (72,"4,17",4,17,2,45,2)
				,new RepositoryFolder (73,"5,16",5,16,2,72,3)
				,new RepositoryFolder (74,"6,15",6,15,2,73,4)
				,new RepositoryFolder (75,"7,14",7,14,2,74,5)
				,new RepositoryFolder (76,"8,13",8,13,2,75,6)
				,new RepositoryFolder (77,"9,12",9,12,2,76,7)
				,new RepositoryFolder (78,"10,11",10,11,2,77,8)
				,new RepositoryFolder (44,"19,28",19,28,2,40,1)
				,new RepositoryFolder (71,"20,21",20,21,2,44,2)
				,new RepositoryFolder (70,"22,23",22,23,2,44,2)
				,new RepositoryFolder (69,"24,25",24,25,2,44,2)
				,new RepositoryFolder (68,"26,27",26,27,2,44,2)
				,new RepositoryFolder (43,"29,36",29,36,2,40,1)
				,new RepositoryFolder (67,"30,31",30,31,2,43,2)
				,new RepositoryFolder (66,"32,33",32,33,2,43,2)
				,new RepositoryFolder (65,"34,35",34,35,2,43,2)
				,new RepositoryFolder (42,"37,74",37,64,2,40,1)
				,new RepositoryFolder (49,"38,51",38,51,2,42,2)
				,new RepositoryFolder (61,"39,46",39,46,2,49,3)
				,new RepositoryFolder (64,"40,41",40,41,2,61,4)
				,new RepositoryFolder (63,"42,43",42,43,2,61,4)
				,new RepositoryFolder (62,"44,45",44,45,2,61,4)
				,new RepositoryFolder (60,"47,48",47,48,2,49,3)
				,new RepositoryFolder (59,"49,50",49,50,2,49,3)
				,new RepositoryFolder (47,"62,73",52,63,2,42,2)
				,new RepositoryFolder (50,"63,72",53,62,2,47,3)
				,new RepositoryFolder (54,"64,65",54,55,2,50,4)
				,new RepositoryFolder (53,"66,67",56,57,2,50,4)
				,new RepositoryFolder (52,"68,69",58,59,2,50,4)
				,new RepositoryFolder (51,"70,71",60,61,2,50,4)
				,new RepositoryFolder (41,"_Recycle Bin",65,76,2,40,1)
				,new RepositoryFolder (48,"52,61",66,75,2,41,2)
				,new RepositoryFolder (58,"53,54",67,68,2,48,3)
				,new RepositoryFolder (57,"55,56",69,70,2,48,3)
				,new RepositoryFolder (56,"57,58",71,72,2,48,3)
				,new RepositoryFolder (55,"59,60",73,74,2,48,3)
			};
            CheckFolder(x1, u1t.RawFolderTree);
            CheckFolder(x2, u2t.RawFolderTree);

            u2t.EmptyRecycle();

            x2 = new RepositoryFolder[] {
				new RepositoryFolder (40,"root",0,67,2,-1,0)
				,new RepositoryFolder (46,"1,2",1,2,2,40,1)
				,new RepositoryFolder (45,"3,18",3,18,2,40,1)
				,new RepositoryFolder (72,"4,17",4,17,2,45,2)
				,new RepositoryFolder (73,"5,16",5,16,2,72,3)
				,new RepositoryFolder (74,"6,15",6,15,2,73,4)
				,new RepositoryFolder (75,"7,14",7,14,2,74,5)
				,new RepositoryFolder (76,"8,13",8,13,2,75,6)
				,new RepositoryFolder (77,"9,12",9,12,2,76,7)
				,new RepositoryFolder (78,"10,11",10,11,2,77,8)
				,new RepositoryFolder (44,"19,28",19,28,2,40,1)
				,new RepositoryFolder (71,"20,21",20,21,2,44,2)
				,new RepositoryFolder (70,"22,23",22,23,2,44,2)
				,new RepositoryFolder (69,"24,25",24,25,2,44,2)
				,new RepositoryFolder (68,"26,27",26,27,2,44,2)
				,new RepositoryFolder (43,"29,36",29,36,2,40,1)
				,new RepositoryFolder (67,"30,31",30,31,2,43,2)
				,new RepositoryFolder (66,"32,33",32,33,2,43,2)
				,new RepositoryFolder (65,"34,35",34,35,2,43,2)
				,new RepositoryFolder (42,"37,74",37,64,2,40,1)
				,new RepositoryFolder (49,"38,51",38,51,2,42,2)
				,new RepositoryFolder (61,"39,46",39,46,2,49,3)
				,new RepositoryFolder (64,"40,41",40,41,2,61,4)
				,new RepositoryFolder (63,"42,43",42,43,2,61,4)
				,new RepositoryFolder (62,"44,45",44,45,2,61,4)
				,new RepositoryFolder (60,"47,48",47,48,2,49,3)
				,new RepositoryFolder (59,"49,50",49,50,2,49,3)
				,new RepositoryFolder (47,"62,73",52,63,2,42,2)
				,new RepositoryFolder (50,"63,72",53,62,2,47,3)
				,new RepositoryFolder (54,"64,65",54,55,2,50,4)
				,new RepositoryFolder (53,"66,67",56,57,2,50,4)
				,new RepositoryFolder (52,"68,69",58,59,2,50,4)
				,new RepositoryFolder (51,"70,71",60,61,2,50,4)
				,new RepositoryFolder (41,"_Recycle Bin",65,66,2,40,1)
			};

            Hashtable h = u1t.SortedFileSiblingsHash;

            Assert.AreEqual(0, h.Count, "looking for nothing in files list");

            RepositoryFolder recycleFolder = mgr.UserRecycleFolder(u1t.Userid);
            //make sure that everything is flushed, including the userContext
            string sqlCmd = "select RepositoryFolderID from RepositoryFolder "
                    + "where FolderName = '_Recycle Bin' and ownerId = " + u1t.Userid.ToString();
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pSqlCmd", sqlCmd)
            };
            long expected = (long)mgr.DbConnector.ExecuteNonSpScalar(sqlCmd);
            Assert.AreEqual(expected, recycleFolder.Id);

            recycleFolder = mgr.UserRecycleFolder(u2t.Userid);
            Assert.AreNotEqual(expected, recycleFolder.Id);

        }
        [Test]
        public void Isolation()
        {
            /*
             * AddFolder - 
             * AddItem - 
             * EmptyRecycle - 
             * FlushUserTree -
             * GetChildFolderByName - 
             * GetChildItemByName -
             * GetItemPathComponents
             * GetRepositoryFolders - 
             * GetUserTree - 
             * RecycleItem -
             * RecycleNode - 
             * moveSubTree (tested above)
             * RenameFolder (tested above) 
             * 
             * */


            /*here, we're just makeing sure that the control tree stays constant
             * throughout operations to the variable tree
             */

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository controlTree = mgr.SetupRepositoryForUser(1);
            RepositoryFolder controlSecondFolder = controlTree.Root.AddFolder("second - 5,6");
            RepositoryFolder controlFirstFolder = controlTree.Root.AddFolder("first - 1,4");
            RepositoryFolder controlFirst_First = controlFirstFolder.AddFolder("first - first - 2,3");

            RepositoryFolder[] controlTreeStandard = new RepositoryFolder[] {
				new RepositoryFolder (60,"root",0, 9, 1, -1, 0)
                ,new RepositoryFolder (66,"first - 1,4",1,4,1,1, 1)
				,new RepositoryFolder (65,"first - first - 2,3", 2,3,1,4,2)
				,new RepositoryFolder (92,"second - 5,6", 5,6,1,1,1)
				,new RepositoryFolder (61,"_Recycle Bin",7,8,1,1,1)
   			};

            CheckFolder(controlTreeStandard, controlTree.RawFolderTree);

            UserRepository variableTree = mgr.SetupRepositoryForUser(2);
            CheckFolder(controlTreeStandard, controlTree.RawFolderTree);

            RepositoryFolder sameName = variableTree.Root.AddFolder("second - 5,6");  //has same name as control tree
            RepositoryFolder diffName = variableTree.Root.AddFolder("a var tree folder");
            RepositoryFolder varSubFolder = sameName.AddFolder("a sub folder in the var tree");
            RepositoryFolder varSubFolder2 = sameName.AddFolder("this folder makes folder count different");

            CheckFolder(controlTreeStandard, controlTree.RawFolderTree);

            long ctlId = controlTree.Root.FindChildFolder("second - 5,6").Id;
            long varId = variableTree.Root.FindChildFolder("second - 5,6").Id;

            Assert.Greater(ctlId, 0);
            Assert.Greater(varId, 0);
            Assert.AreNotEqual(ctlId, varId);

            RepositoryFolder[] varFolders = variableTree.RawFolderTree;
            RepositoryFolder[] ctlFolders = controlTree.RawFolderTree;

            Assert.Greater(varFolders.Length, 0);
            Assert.Greater(ctlFolders.Length, 0);
            Assert.AreNotEqual(varFolders.Length, ctlFolders.Length);

            Hashtable varFoldersHash = variableTree.SortedFolderSiblingsHash;
            Hashtable ctlFoldersHash = controlTree.SortedFolderSiblingsHash;

            Assert.Greater(varFoldersHash.Count, 0);
            Assert.Greater(ctlFoldersHash.Count, 0);
            Assert.AreNotEqual(varFoldersHash.Count, ctlFoldersHash.Count);

            RepositoryItem varItem = sameName.AddItem("This is an item", 2);
            CheckFolder(controlTreeStandard, controlTree.RawFolderTree);
            RepositoryItem[] controlItems = controlTree.Items;
            Assert.AreEqual(0, controlItems.Length);

            RepositoryItem ctlItem = controlSecondFolder.AddItem("This is an item", 1);
            ctlId = controlSecondFolder.FindChildItem("This is an item").Id;
            varId = sameName.FindChildItem("This is an item").Id;

            Assert.AreNotEqual(ctlId, varId);

            varItem.Recycle();
            CheckFolder(controlTreeStandard, controlTree.RawFolderTree);
            controlItems = controlTree.Items;
            Assert.AreEqual(ctlId, controlItems[0].Id);

            varSubFolder.Recycle();
            variableTree.EmptyRecycle();
            CheckFolder(controlTreeStandard, controlTree.RawFolderTree);

            mgr.FlushUserTree(2);
            CheckFolder(controlTreeStandard, controlTree.RawFolderTree);
        }
        [Test]
        public void AddingThingsErrorChecks()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();
            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            string msg = "";

            //add folder with same name results in error
            RepositoryFolder firstChild = u1t.Root.AddFolder("AName");

            try
            {
                RepositoryFolder secondChild = u1t.Root.AddFolder("AName");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.Greater(msg.IndexOf("currently exists"), 0);



            //item with same name as folder should generate error
            RepositoryItem item;
            try
            {
                item = u1t.Root.AddItem("AName", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("older with same name") > 1, msg);

            item = u1t.Root.AddItem("AnItemName", 1);

            //item with same name as another item should generate error
            try
            {
                item = u1t.Root.AddItem("AnItemName", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("with same name") > 1, msg);

            //item with same name as a folder should generate error
            try
            {
                RepositoryFolder folder = u1t.Root.AddFolder("AnItemName");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("with same name") > 1, msg);



            //disallow placing items into recycle bin
            RepositoryFolder recycleFolder = u1t.Root.FindChildFolder("_recycle bin");
            try
            {
                item = recycleFolder.AddItem("a recycledItem", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("may not add a folder to the rec") > 1, msg);

            //disallow placing items into a tree not owned by the tree owner
            try
            {
                item = u1t.Root.AddItem("hisItem", 3);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("not owned by you") > 1, msg);

        }
        private byte[] GetFilecontent(string filePath)
        {

            FileStream stream = new FileStream(
                filePath, FileMode.Open, FileAccess.Read);
            BinaryReader reader = new BinaryReader(stream);

            byte[] content = reader.ReadBytes((int)stream.Length);

            reader.Close();

            stream.Close();

            return content;

        }
        private void PutFileContent(string filePath, byte[] retrievedFile)
        {

            FileStream fs = new FileStream(
                filePath, FileMode.Create, FileAccess.Write);
            BinaryWriter w = new BinaryWriter(fs);

            for (int i = 0; i < retrievedFile.Length; i++)
            {
                w.Write(retrievedFile[i]);
            }
            w.Close();
            fs.Close();
        }
        [Test]
        public void Search()
        {
            /*
             * /
             * |--f11
             *      |--f21
             *      |--f22
             *      
             * |--f12
             *      |--f23
             *          |--f31
             *          |--f32
             *          |--**i231
             *          |--**i232   
             *      |--**i121
             *
             * |--f13
             *      |--f24
             *      |--f25
             *      |--f26
             *      |--**i131
             *      |--**i132
            */


            // put some keywords on things, and search for them

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder f11 = u1t.Root.AddFolder("f11");
            RepositoryFolder f12 = u1t.Root.AddFolder("f12");
            RepositoryFolder f13 = u1t.Root.AddFolder("f13");

            RepositoryFolder f21 = f11.AddFolder("f21");
            RepositoryFolder f22 = f11.AddFolder("f22");
            RepositoryFolder f23 = f12.AddFolder("f23");
            RepositoryFolder f24 = f13.AddFolder("f24");
            RepositoryFolder f25 = f13.AddFolder("f25");
            RepositoryFolder f26 = f13.AddFolder("f26");
            RepositoryFolder f31 = f23.AddFolder("f31");
            RepositoryFolder f32 = f23.AddFolder("f32");

            RepositoryItem i121 = mgr.AddRepoItemWithFirstBitstream(1, f12.Id, new byte[] { 6, 5, 4 }, "foo", "i121", "i121", "bar", "", 3);
            RepositoryItem i131 = mgr.AddRepoItemWithFirstBitstream(1, f13.Id, new byte[] { 1, 2, 3 }, "foo", "i131", "i131", "bar", "", 3);
            RepositoryItem i132 = mgr.AddRepoItemWithFirstBitstream(1, f13.Id, new byte[] { 3, 4, 5 }, "foo", "i132", "i132", "bar", "", 3);
            RepositoryItem i231 = mgr.AddRepoItemWithFirstBitstream(1, f23.Id, new byte[] { 1, 2, 3 }, "foo", "i231", "i231", "bar", "", 3);
            RepositoryItem i232 = mgr.AddRepoItemWithFirstBitstream(1, f23.Id, new byte[] { 3, 4, 5 }, "foo", "i232", "i232", "bar", "", 3);

            i121.Keywords = "one two three four five six seven eight nine ten";
            i131.Keywords = "two four six eight ten twelve fourteen sixteen eighteen";
            i132.Keywords = "one three five seven nine eleven thirteen fifteen seventeen";
            i231.Keywords = "three six nine twelve fifteen eighteen twentyone twentythree";
            i232.Keywords = "one three five seven eleven thirteen seventeen nineteen";

            i121.Save();
            i131.Save();
            i132.Save();
            i231.Save();
            i232.Save();

            RepositoryItem[] foundItems = u1t.Search("eleven");
            Assert.AreEqual(2, foundItems.Length);

            foundItems = u1t.Search("one");
            Assert.AreEqual(3, foundItems.Length);

            foundItems = u1t.Search("nineteen");
            Assert.AreEqual(1, foundItems.Length);               
        }
        [Test]
        public void GetChildren()
        {
            /*
             * /
             * |--f11
             *      |--f21
             *      |--f22
             *      
             * |--f12
             *      |--f23
             *          |--f31
             *          |--f32
             *          |--**i231
             *          |--**i232   
             *      |--**i121
             *
             * |--f13
             *      |--f24
             *      |--f25
             *      |--f26
             *      |--**i131
             *      |--**i132
            */


            // test getting back the names of everything in a folder
            // test getting back all children folders in a folder
            // test getting back all children items in a folder
            // test getting back all descendent items
            // test getting back a correct folder path

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder f11 = u1t.Root.AddFolder("f11");
            RepositoryFolder f12 = u1t.Root.AddFolder("f12");
            RepositoryFolder f13 = u1t.Root.AddFolder("f13");

            RepositoryFolder f21 = f11.AddFolder("f21");
            RepositoryFolder f22 = f11.AddFolder("f22");
            RepositoryFolder f23 = f12.AddFolder("f23");
            RepositoryFolder f24 = f13.AddFolder("f24");
            RepositoryFolder f25 = f13.AddFolder("f25");
            RepositoryFolder f26 = f13.AddFolder("f26");
            RepositoryFolder f31 = f23.AddFolder("f31");
            RepositoryFolder f32 = f23.AddFolder("f32");

            mgr.AddRepoItemWithFirstBitstream(1, f23.Id, new byte[] { 1, 2, 3 }, "foo", "i231", "i231", "bar", "", 3);
            mgr.AddRepoItemWithFirstBitstream(1, f23.Id, new byte[] { 3, 4, 5 }, "foo", "i232", "i232", "bar", "", 3);

            mgr.AddRepoItemWithFirstBitstream(1, f12.Id, new byte[] { 6, 5, 4 }, "foo", "i121", "i121", "bar", "", 3);

            mgr.AddRepoItemWithFirstBitstream(1, f13.Id, new byte[] { 1, 2, 3 }, "foo", "i131", "i131", "bar", "", 3);
            mgr.AddRepoItemWithFirstBitstream(1, f13.Id, new byte[] { 3, 4, 5 }, "foo", "i132", "i132", "bar", "", 3);

            // test getting back the names of everything in a folder
            Hashtable ht = new Hashtable();
            ht.Add("i131", null);
            ht.Add("i132", null);
            ht.Add("f24", null);
            ht.Add("f25", null);
            ht.Add("f26", null);

            List<string> childrenNames = f13.ChildrenNames;
            foreach (string s in childrenNames)
            {
                Assert.IsTrue(ht.ContainsKey(s));
                ht.Remove(s);
            }
            Assert.AreEqual(0, ht.Count);

            //test getting back all children folders in a folder
            ht.Clear();
            ht.Add("f31", null);
            ht.Add("f32", null);
            RepositoryFolder[] childFolders = f23.ChildrenFolders;
            foreach (RepositoryFolder f  in childFolders)
            {
                Assert.IsTrue(ht.ContainsKey(f.Name));
                ht.Remove(f.Name);
            }
            Assert.AreEqual(0, ht.Count);

            //test getting back all children items in a folder
            ht.Clear();
            ht.Add("i231", null);
            ht.Add("i232", null);
            RepositoryItem[] childItems = f23.ChildrenItems;
            foreach (RepositoryItem i in childItems)
            {
                Assert.IsTrue(ht.ContainsKey(i.ItemName));
                ht.Remove(i.ItemName);
            }
            Assert.AreEqual(0, ht.Count);

            //test getting back all descendent items
            ht.Clear();
            ht.Add("i121", null);
            ht.Add("i231", null);
            ht.Add("i232", null);
            childItems = f12.DescendantItems;
            foreach (RepositoryItem i in childItems)
            {
                Assert.IsTrue(ht.ContainsKey(i.ItemName));
                ht.Remove(i.ItemName);
            }
            Assert.AreEqual(0, ht.Count);

            //...the mgr version of the same thing
            ht.Clear();
            ht.Add("i121", null);
            ht.Add("i231", null);
            ht.Add("i232", null);
            childItems = mgr.FolderDescendantItems(f12.Id);
            foreach (RepositoryItem i in childItems)
            {
                Assert.IsTrue(ht.ContainsKey(i.ItemName));
                ht.Remove(i.ItemName);
            }
            Assert.AreEqual(0, ht.Count);

            //...try from the root
            ht.Clear();
            ht.Add("i121", null);
            ht.Add("i131", null);
            ht.Add("i132", null);
            ht.Add("i231", null);
            ht.Add("i232", null);
            childItems = u1t.Root.DescendantItems;
            foreach (RepositoryItem i in childItems)
            {
                Assert.IsTrue(ht.ContainsKey(i.ItemName));
                ht.Remove(i.ItemName);
            }
            Assert.AreEqual(0, ht.Count);

            // test getting back a correct folder path
            Assert.AreEqual("root\\f12\\f23\\f32\\", f32.Path);

        }
        [Test]
        public void DeleteItemFromMgr()
        {
            /*
             * /
             * |--f11
             *      |--f21
             *      |--f22
             *      
             * |--f12
             *      |--f23
             *          |--f31
             *          |--f32
             *          |--**i231
             *          |--**i232   
             *      |--**i121
             *
             * |--f13
             *      |--f24
             *      |--f25
             *      |--f26
             *      |--**i131
             *      |--**i132
            */


            // put some keywords on things, and search for them

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder f11 = u1t.Root.AddFolder("f11");
            RepositoryFolder f12 = u1t.Root.AddFolder("f12");
            RepositoryFolder f13 = u1t.Root.AddFolder("f13");

            RepositoryFolder f21 = f11.AddFolder("f21");
            RepositoryFolder f22 = f11.AddFolder("f22");
            RepositoryFolder f23 = f12.AddFolder("f23");
            RepositoryFolder f24 = f13.AddFolder("f24");
            RepositoryFolder f25 = f13.AddFolder("f25");
            RepositoryFolder f26 = f13.AddFolder("f26");
            RepositoryFolder f31 = f23.AddFolder("f31");
            RepositoryFolder f32 = f23.AddFolder("f32");

            RepositoryItem i121 = mgr.AddRepoItemWithFirstBitstream(1, f12.Id, new byte[] { 6, 5, 4 }, "foo", "i121", "i121", "bar", "", 3);
            RepositoryItem i131 = mgr.AddRepoItemWithFirstBitstream(1, f13.Id, new byte[] { 1, 2, 3 }, "foo", "i131", "i131", "bar", "", 3);
            RepositoryItem i132 = mgr.AddRepoItemWithFirstBitstream(1, f13.Id, new byte[] { 3, 4, 5 }, "foo", "i132", "i132", "bar", "", 3);
            RepositoryItem i231 = mgr.AddRepoItemWithFirstBitstream(1, f23.Id, new byte[] { 1, 2, 3 }, "foo", "i231", "i231", "bar", "", 3);
            RepositoryItem i232 = mgr.AddRepoItemWithFirstBitstream(1, f23.Id, new byte[] { 3, 4, 5 }, "foo", "i232", "i232", "bar", "", 3);

            mgr.DeleteRepositoryItem(i131.Id);
 
            Hashtable ht = new Hashtable();
            ht.Add("i132", null);
            ht.Add("f24", null);
            ht.Add("f25", null);
            ht.Add("f26", null);

 
            List<string> childrenNames = f13.ChildrenNames;
            foreach (string s in childrenNames)
            {
                Assert.IsTrue(ht.ContainsKey(s));
                ht.Remove(s);
            }
            Assert.AreEqual(0, ht.Count);

            i132.SetItemUsed("foo");

            string msg = "";

            try
            {
                mgr.DeleteRepositoryItem(i132.Id);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("immutable") > 1);
        }
    }
}
