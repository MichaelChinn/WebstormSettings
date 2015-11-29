using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using RepositoryLib;
using System.IO;

using NUnit.Framework;

namespace RepositoryLib.Tests
{
    [TestFixture]
    public class TestItem : TestBase
    {
        [Test]
        public void BaseProperties()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryItem item = u1t.Root.AddItem("firstItem", 1);
            item.Description = "This is an item";
            item.Keywords = "bravo echo alpha";
            item.VerifiedByStudent = true;
            item.IsWithdrawn = true;
            item.Save();

            item = u1t.Root.FindChildItem("firstItem");
            Assert.AreEqual(1, item.OwnerId);
            Assert.AreEqual("This is an item", item.Description);
            Assert.AreEqual(" alpha bravo echo ", item.Keywords);
            Assert.AreEqual(true, item.VerifiedByStudent);
            Assert.AreEqual(true, item.IsWithdrawn);
            Assert.AreEqual(false, item.IsImmutable);

            item.VerifiedByStudent = false;
            item.IsWithdrawn = false;
            item.Save();

            item = u1t.Root.FindChildItem("firstItem");
            Assert.AreEqual(1, item.OwnerId);
            Assert.AreEqual("This is an item", item.Description);
            Assert.AreEqual(" alpha bravo echo ", item.Keywords);
            Assert.AreEqual(false, item.VerifiedByStudent);
            Assert.AreEqual(false, item.IsWithdrawn);

            item.SetItemImmutable("AppOne");
            item = u1t.Root.FindChildItem("firstItem");
            Assert.AreEqual(true, item.IsImmutable);


            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 1 }, "foogls", "mmm", "fff", ".doc", "fff", 332);
            item = u1t.Root.FindChildItem("mmm");
            Assert.IsFalse(item.IsImmutable);
        }
        [Test]
        public void ItemUpdate()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);

            RepositoryFolder f = u1t.Root.AddFolder("maFolder");
            f = f.AddFolder("bFolder");
            f = f.AddFolder("cFolder");
            RepositoryFolder Container = f.AddFolder("dFolder");
            Container.AddItem("TheFileAtBottom", 1);

            RepositoryItem Item = Container.FindChildItem("TheFileAtBottom");

            string keywords = "the rain in spain falls mainly";
            string description = "the quick brown fox";
            bool IsVerified = true;

            Item.Keywords = keywords;
            Item.Description = description;
            Item.VerifiedByStudent = IsVerified;

            Item.Save();

            RepositoryItem newlyGotten = Container.FindChildItem("TheFileAtBottom");

            keywords = " falls in mainly rain spain the ";  //what keywords look like after scrubbing
            Assert.AreEqual(newlyGotten.Keywords.IndexOf(keywords), 0, "keywords wrong... ", newlyGotten.Keywords);
            Assert.AreEqual(newlyGotten.Description.IndexOf(description), 0, "Description wrong... ", newlyGotten.Description);
            Assert.AreEqual(IsVerified, Item.VerifiedByStudent, "isVerified wrong... ", newlyGotten.VerifiedByStudent);

            //more tests when item is set immutable below
        }
        [Test]
        public void ItemPath()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            UserRepository u2t = mgr.SetupRepositoryForUser(2);

            RepositoryFolder f = u1t.Root.AddFolder("maFolder");
            f = f.AddFolder("bFolder");
            f = f.AddFolder("cFolder");
            RepositoryFolder Container = f.AddFolder("dFolder");
            Container.AddItem("TheFileAtBottom", 1);

            u1t.Root.AddFolder("saFolder");
            u1t.Root.AddFolder("sbFolder");
            u1t.Root.AddFolder("scFolder");
            u1t.Root.AddFolder("faFolder");

            f = u2t.Root.AddFolder("_2aFolder");
            f = u2t.Root.AddFolder("_2bFolder");
            f = u2t.Root.AddFolder("_2cFolder");
            f = u2t.Root.AddFolder("_2dFolder");
            f = u2t.Root.AddFolder("_2eFolder");
            f = u2t.Root.AddFolder("_2fFolder");
            f = u2t.Root.AddFolder("_2gFolder");
            f = u2t.Root.AddFolder("_2hFolder");
            f = u2t.Root.AddFolder("_2iFolder");
            f = u2t.Root.AddFolder("_2jFolder");
            f = u2t.Root.AddFolder("_2kFolder");
            f = u2t.Root.AddFolder("_2lFolder");
            f = u2t.Root.AddFolder("_2mFolder");
            f = u2t.Root.AddFolder("_2nFolder");
            f = u2t.Root.AddFolder("_2oFolder");
            f = u2t.Root.AddFolder("_2Folder");
            f = u2t.Root.AddFolder("_2pFolder");
            f = u2t.Root.AddFolder("_2qFolder");
            f = u2t.Root.AddFolder("_2rFolder");

            RepositoryItem Item = Container.FindChildItem("TheFileAtBottom");
            string retval = Item.ItemPath;
            Assert.AreEqual(Item.ItemPath.IndexOf("root\\maFolder\\bFolder\\cFolder\\dFolder\\"), 0, "folder path of the item... actual path: " + Item.ItemPath);

            List<string> components = Item.ItemPathList;
            Assert.AreEqual(components[0], "root");
            Assert.AreEqual(components[1], "maFolder");
            Assert.AreEqual(components[2], "bFolder");
            Assert.AreEqual(components[3], "cFolder");
            Assert.AreEqual(components[4], "dFolder");
        }
        [Test]
        public void GeneralOps()
        {
            // verify bundles present
            // msg = "Add Item to somebody else's tree";
            // msg = "Add Item with name collision";
            // msg = "Add Item to recycle bin";
            // find child Item
            // move Item to sub folder
            // move Item collision check

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();
            string msg = null;

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            UserRepository u2t = mgr.SetupRepositoryForUser(2);

            RepositoryFolder r1 = u1t.Root;
            RepositoryFolder r2 = u2t.Root;

            RepositoryItem item = r2.AddItem("ItemOne", 2);
            Bundle b = item.Bundle;
            Assert.AreEqual(b.RepositoryItemId, item.Id);

            item = r2.AddItem("ItemTwo", 2);
            b = item.Bundle;
            Assert.AreEqual(b.RepositoryItemId, item.Id);

            item = r2.AddItem("ItemThr", 2);
            b = item.Bundle;
            Assert.AreEqual(b.RepositoryItemId, item.Id);

            item = r2.AddItem("ItemFou", 2);
            b = item.Bundle;
            Assert.AreEqual(b.RepositoryItemId, item.Id);

            item = r2.AddItem("ItemFiv", 2);
            b = item.Bundle;
            Assert.AreEqual(b.RepositoryItemId, item.Id);


            //verify bundles present


            RepositoryFolder recycle1 = u1t.Root.FindChildFolder("_Recycle Bin");

            msg = "Add Item to somebody else's tree";
            try
            {
                r1.AddItem("FirstItem", 2);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("not owned by you") > 1, msg);

            RepositoryItem firstItem = r1.AddItem("FirstItem", 1);

            msg = "Add Item with name collision";
            try
            {
                r1.AddItem("FirstItem", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("name currently exists") > 1, msg);


            msg = "Add Item to recycle bin";
            try
            {
                recycle1.AddItem("FirstItem", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("folder to the recycle bin") > 1, msg);

            RepositoryItem[] x1 = new RepositoryItem[] {
                new RepositoryItem("FirstItem",1, "","", false, u1t.Id, false)
            };

            RepositoryItem[] x2 = new RepositoryItem[] {
                new RepositoryItem("ItemFiv",2, "","", false, u2t.Id, false),
                new RepositoryItem("ItemFou",2, "","", false, u2t.Id, false),
                new RepositoryItem("ItemOne",2, "","", false, u2t.Id, false),
                new RepositoryItem("ItemThr",2, "","", false, u2t.Id, false),
                new RepositoryItem("ItemTwo",2, "","", false, u2t.Id, false)
			};

            CheckItem(x1, u1t.Items);
            CheckItem(x2, u2t.Items);

            // move item to subfolder test
            RepositoryFolder subFolder1 = r1.AddFolder("SubFolder1");
            item = r1.FindChildItem("FirstItem");

            item.Move(subFolder1.Id);

            RepositoryItem nullItem = r1.FindChildItem("FirstItem");
            Assert.AreEqual(nullItem, null, "tried to get back a bogus Item");
            RepositoryItem movedItem = subFolder1.FindChildItem("firstItem");
            Assert.AreEqual("FirstItem", movedItem.ItemName, "should be the name of Item back");

            // move Item name collision test
            RepositoryItem ItemWithSameName = r1.AddItem("FirstItem", 1);
            msg = "move Item name collision check";
            try
            {
                movedItem.Move(r1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("name currently exists in destination ") > 1, msg);

            x1 = new RepositoryItem[]{
                new RepositoryItem("FirstItem", 1,"","",false,r1.Id,false)
                 ,new RepositoryItem("FirstItem", 1,"","",false,subFolder1.Id,false)
              
            };
            CheckItem(x1, u1t.Items);
            CheckItem(x2, u2t.Items);

            // recycle Item test
            ItemWithSameName.Recycle();
            movedItem.Move(r1);

            ItemWithSameName = recycle1.FindChildItem("FirstItem");
            Assert.AreNotEqual(null, ItemWithSameName, "this first Item should be in recycle bin");

            RepositoryItem reMovedItem = r1.FindChildItem("FirstItem");
            Assert.AreNotEqual(null, ItemWithSameName, "should have first Item in folder as well");

            movedItem = subFolder1.FindChildItem("firstItem");
            Assert.AreEqual(null, movedItem, "should have no Item coming from subfolder");

            x1 = new RepositoryItem[]{
				new RepositoryItem("FirstItem", 1, "","",false,r1.Id, false)
                ,new RepositoryItem("FirstItem", 1, "","",false,recycle1.Id, false)
            };
            CheckItem(x1, u1t.Items);
            CheckItem(x2, u2t.Items);

            u1t.EmptyRecycle();
            x1 = new RepositoryItem[]{
				new RepositoryItem("FirstItem", 1, "","",false,r1.Id, false)
			};
            CheckItem(x1, u1t.Items);
            CheckItem(x2, u2t.Items);

            //append a couple of bitstreams
            b = u1t.Items[0].Bundle;
            byte[] b1 = new byte[] { 0x01, 0x02, 0x22, 0x24 };
            b.AddBitstream(b1, "First bitstream", "doc", "application/octet", "the first one I'm makeing", false, 1);
            byte[] b2 = new byte[] { 0xa0, 0x0a, 0x55 };
            b.AddBitstream(b2, "Second Bitstream", "xls", "binary format", "the primary bitstream", true, 1);

            Bitstream[] streams = b.Bitstreams;
            Assert.AreEqual(2, streams.Length);
            Assert.AreEqual("First bitstream", streams[0].Name);
            Assert.AreEqual("Second Bitstream", streams[1].Name);
            Assert.AreEqual(1, streams[0].OwnerId);
            Assert.AreEqual(1, streams[1].OwnerId);

        }
        [Test]
        public void ItemFolderNameCollisions()
        {
            //item with same name as existing sib folder
            //item with same name as existing sib item
            //folder with same name as existing sib item

            //note that in the case of a folder with same name as existing sib folder,
            // no error condition results; expected behavior is that the folder returned
            // from the method is the same folder as the first folder

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder root = u1t.Root;
            string msg = "";

            root.AddFolder("FirstName");

            //item with existing folder name
            try
            {
                root.AddItem("FirstName", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("currently exists in destination") > 1, msg);

            root.AddItem("SecondName", 1);

            //item with same name as existing sib item
            try
            {
                root.AddItem("SecondName", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("currently exists in destination") > 1, msg);


            //folder with same name as existing sib item
            try
            {
                root.AddFolder("SecondName");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("currently exists in destination") > 1, msg);

        }
        [Test]
        public void MgrFunctionTests()
        {
            //check renaming an item to a sibling item's name
            //check renaming an item which has been made immutable
            //check adding item with one file, whose name is already taken by another item

            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder root = u1t.Root;

            //check renaming an item to a sibling item's name
            RepositoryItem anItem = root.AddItem("FirstItem", 1);
            RepositoryItem anotherItem = root.AddItem("anotherItem", 1);
            string msg = "";
            try
            {
                mgr.RenameRepositoryItem(anotherItem.Id, "FirstItem");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("currently exists in dest") > 1, msg);

            //check renaming an item which has been made immutable
            anItem.SetItemImmutable("AppOne");

            try
            {
                mgr.RenameRepositoryItem(anItem.Id, "my new name should fail");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("immutable") > 1);

            //check adding item with one file, whose name is already taken by another item
            byte[] b = new byte[] { 1, 2, 3 };
            mgr.AddRepoItemWithFirstBitstream(1, root.Id, b, "", "foo", "AFileName", ".pxx", "moon juice", 3);
            try
            {
                mgr.AddRepoItemWithFirstBitstream(1, root.Id, b, "", "foo", "AFileName", ".pxx", "moon juice", 3);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("same name currently exists in destination") > 1, msg);


        }
        [Test]
        public void Immutability()
        {
            /**************************************************
            //check unchangeable base item properties when set immutable; item update

            //check adding file-bitstreams through mgr when item set immutable
            //check adding url-bitstreams through mgr when item set immutable
            //check adding file-bitstreams through bundle when item set immutable
            //check adding url-bitstreams through bundle when item set immutable
            //check removing bitstreams when item set immutable
            //check disallow empty recycle of item set immutable
            //check flush user tree when item set immutable
            //disallow item rename when immutable

            //check move bitstream when dest item immutable
            //check move bitstream when source item immutable
            //check immutability counts with differing appstrings
            //check update bundle when item immutable
             * ***********************************************/

            //check unchangeable base item properties when set immutable; item update
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();
            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder Container = u1t.Root.AddFolder("dFolder");
            Container.AddItem("TheFileAtBottom", 1);

            RepositoryItem item = Container.FindChildItem("TheFileAtBottom");

            string keywords = "the rain in spain falls mainly";
            string description = "the quick brown fox";
            bool IsVerified = true;

            item.Keywords = keywords;
            item.Description = description;
            item.VerifiedByStudent = IsVerified;

            item.Save();

            RepositoryItem newlyGotten = Container.FindChildItem("TheFileAtBottom");

            keywords = " falls in mainly rain spain the ";  //what keywords look like after scrubbing
            Assert.AreEqual(newlyGotten.Keywords.IndexOf(keywords), 0, "keywords wrong... ", newlyGotten.Keywords);
            Assert.AreEqual(newlyGotten.Description.IndexOf(description), 0, "Description wrong... ", newlyGotten.Description);
            Assert.AreEqual(IsVerified, item.VerifiedByStudent, "isVerified wrong... ", newlyGotten.VerifiedByStudent);

            //check unchangeable base item properties when set immutable
            item.SetItemImmutable("AppOne");

            item.Keywords = "oogla boogla boogla";
            item.Description = "hello there america";
            item.VerifiedByStudent = !IsVerified;

            string msg = "";
            try
            {
                item.Save();
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            newlyGotten = Container.FindChildItem("TheFileAtBottom");
            Assert.AreEqual(newlyGotten.Keywords.IndexOf(keywords), 0, "keywords wrong... ", newlyGotten.Keywords);
            Assert.AreEqual(newlyGotten.Description.IndexOf(description), 0, "Description wrong... ", newlyGotten.Description);
            Assert.AreEqual(IsVerified, newlyGotten.VerifiedByStudent, "isVerified wrong... ", newlyGotten.VerifiedByStudent);
            Assert.AreEqual(true, newlyGotten.IsImmutable);


            //check adding file-bitstreams through mgr when item set immutable  
            mgr.AddRepoItemWithFirstBitstream(1, u1t.Root.Id, new byte[] { 23, 44, 10 }
                , "foolsf", "unChangeable", "firstFile.doc", ".doc", "a first bitstream", 3);

            item = u1t.Root.FindChildItem("unChangeable");
            item.SetItemImmutable("AppOne");

            msg = "";
            try
            {
                mgr.AddRepoItemBitstream(1, item.Id, new byte[] { 23, 44, 10 }
                    , "foogle", "another bitstream.doc", ".doc", 3, "another", true); ;
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);
            //check renaming bitstream when item marked immutable

            item = u1t.Root.FindChildItem("unChangeable");
            Bundle bundleFirst = item.Bundle;
            Bitstream bitstreamFirst = bundleFirst.Bitstreams[0];
            
            msg = "";
            try
            {
                bitstreamFirst.Name = "theFirstNewName.flsh";
                bitstreamFirst.SaveMeta();
            }
            catch (Exception e)
            {
                msg = e.Message;
            }
            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            //check adding url-bitstreams through mgr when item set immutable
            msg = "";
            try
            {
                mgr.AddRepoItemBitstreamAsURL(1, item.Id, "www.foogle.ccc", "anUrl", true);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            Bundle bundle = item.Bundle;

            //check adding file-bitstreams through bundle when item set immutable
            msg = "";
            try
            {
                bundle.AddBitstream(new byte[] { 1, 2, 3 }, "bundleAdded", ".doc", "fosfs", "a bundle Added Bitstream", true, 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            //check adding url-bitstreams through bundle when item set immutable
            msg = "";
            try
            {
                bundle.AddBitstreamAsURL("Www.fesf.com", "a bundle added url", 1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            Bitstream bitstream = bundle.Bitstreams[0];

            //check removing bitstreams when item set immutable
            msg = "";
            try
            {
                mgr.DeleteBitstream(bitstream.Id);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            //check disallow empty recycle of item set immutable
            mgr.RecycleRepositoryItem(item.Id);
            msg = "";
            try
            {
                mgr.EmptyRecycleBin(1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            //check flush user tree when item set immutable
            msg = "";
            try
            {
                mgr.FlushUserTree(1);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);

            //disallow item rename when immutable
            msg = "";
            try
            {
                mgr.RenameRepositoryItem(item.Id, "A New Name");
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);
        }
        [Test]
        public void MoreImmutable()
        {
            /*************************************************
            //check move bitstream when dest item immutable
            //check move bitstream when source item immutable
            //check immutability counts with differing appstrings
             * ***********************************************/

            //check immutability counts with single appstring
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();
            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder Container = u1t.Root.AddFolder("dFolder");
            Container.AddItem("TheFileAtBottom", 1);

            RepositoryItem item = Container.FindChildItem("TheFileAtBottom");

            Assert.IsFalse(item.IsImmutable);

            for (int i = 0; i < 5; i++)
                item.SetItemImmutable("appOne");

            for (int i = 0; i < 5; i++)
            {
                Assert.IsTrue(item.IsImmutable);
                item.UnSetItemImmutable("appOne");
            }

            Assert.IsFalse(item.IsImmutable);

            item.UnSetItemImmutable("appOne");
            Assert.IsFalse(item.IsImmutable);

            //check you can unset as many times as you like, but one set makes immutable
            for (int i = 0; i < 20; i++)
                item.UnSetItemImmutable("appOne");
            Assert.IsFalse(item.IsImmutable);

            item.SetItemImmutable("appOne");

            Assert.IsTrue(item.IsImmutable);
            item.UnSetItemImmutable("appOne");
            Assert.IsFalse(item.IsImmutable);

            //play with counts and multiple app strings
            item.SetItemImmutable("appOne");
            item.SetItemImmutable("appTwo");
            Assert.IsTrue(item.IsImmutable);
            item.UnSetItemImmutable("appOne");
            Assert.IsTrue(item.IsImmutable);
            item.UnSetItemImmutable("appTwo");
            Assert.IsFalse(item.IsImmutable);


            //check move bitstream when source item immutable
            mgr.AddRepoItemWithFirstBitstream(1, Container.Id, new byte[] { 45 }, "foogls", "nextItem", "fff", ".doc", "fff", 332);
            RepositoryItem nextItem = Container.FindChildItem("nextItem");
            Bitstream stream = nextItem.Bundle.Bitstreams[0];
            nextItem.SetItemImmutable("appOne");

            string msg = "";
            try
            {
                mgr.MoveBitstreamItem(stream.Id, item.Id, false);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);
            Assert.IsTrue(msg.IndexOf("ource") > 0);

            //check move bitstream when dest item immutable
            nextItem.UnSetItemImmutable("appOne");
            item.SetItemImmutable("appOne");
            msg = "";
            try
            {
                mgr.MoveBitstreamItem(stream.Id, item.Id, false);
            }
            catch (Exception e)
            {
                msg = e.Message;
            }

            Assert.IsTrue(msg.IndexOf("immutable") > 0);
            Assert.IsTrue(msg.IndexOf("estination") > 0);

            //unset item immutable for this app and check to see if you can remove the item
            item.UnSetItemImmutable("appOne");
            RepositoryFolder recycleBin = u1t.Root.FindChildFolder("_Recycle Bin");
            item.Move(recycleBin.Id);
            u1t.EmptyRecycle();

        }
        [Test]
        public void RefCounts()
        {
            //check flushUserTree when item is marked used
            //check empty recycle when item is marked used
            //play with used counts and app strings


            //check ref counts with single appstring
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();
            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder Container = u1t.Root.AddFolder("dFolder");
            Container.AddItem("TheFileAtBottom", 1);

            RepositoryItem item = Container.FindChildItem("TheFileAtBottom");

            Assert.IsFalse(item.IsUsed);

            item.SetItemUsed("appOne");
            Assert.IsTrue(item.IsUsed);
            Assert.IsTrue(mgr.IsItemUsed(item.Id));

            item.UnSetItemUsed("appOne");
            Assert.IsFalse(item.IsUsed);

            for (int i = 0; i < 5; i++)
                item.SetItemUsed("appOne");

            for (int i = 0; i < 5; i++)
            {
                Assert.IsTrue(item.IsUsed);
                item.UnSetItemUsed("appOne");
            }

            Assert.IsFalse(item.IsUsed);

            item.UnSetItemUsed("appOne");
            Assert.IsFalse(item.IsUsed);

            //check you can unset as many times as you like, but one set makes used
            for (int i = 0; i < 20; i++)
                item.UnSetItemUsed("appOne");
            Assert.IsFalse(item.IsUsed);

            item.SetItemUsed("appOne");

            Assert.IsTrue(item.IsUsed);
            item.UnSetItemUsed("appOne");
            Assert.IsFalse(item.IsUsed);

            //play with counts and multiple app strings
            item.SetItemUsed("appOne");
            item.SetItemUsed("appTwo");
            Assert.IsTrue(item.IsUsed);
            item.UnSetItemUsed("appOne");
            Assert.IsTrue(item.IsUsed);
            item.UnSetItemUsed("appTwo");
            Assert.IsFalse(item.IsUsed);

            //now see if you can actually remove it...
            RepositoryFolder recycleBin = u1t.Root.FindChildFolder("_Recycle Bin");
            item.Move(recycleBin.Id);
            u1t.EmptyRecycle();
        }

        [Test]
        public void MoreRefCounts()
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


            // set stuff used and make sure you get the right things back

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

            Hashtable ht = new Hashtable();
            ht.Add("i121", null);
            ht.Add("i231", null);

            i121.SetItemUsed("appOne");
            i231.SetItemUsed("appTwo");

            RepositoryItem[] foundItems = u1t.UsedItems;
            Assert.AreEqual(2, foundItems.Length);

            foreach (RepositoryItem i in foundItems)
            {
                Assert.IsTrue(ht.ContainsKey(i.ItemName));
                ht.Remove(i.ItemName);
            }
            Assert.AreEqual(0, ht.Count);

            foundItems = u1t.Root.UsedItems;
            Assert.AreEqual(2, foundItems.Length);

            foundItems = f12.UsedItems;
            Assert.AreEqual(2, foundItems.Length);

            foundItems = f23.UsedItems;
            Assert.AreEqual(1, foundItems.Length);

        }
    }
}
