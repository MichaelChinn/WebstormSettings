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
    public class tRepoMgrConvenienceFunctions : TestBase
    {
        RepositoryMgr _mgr = null;

        [Test]
        public void tRepoItemsAndUrlBitstreams()
        {
            RepositoryMgr mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = mgr.SetupRepositoryForUser(1);
            RepositoryFolder root = u1t.Root;

            mgr.AddRepoItemWithFirstBitstreamAsURL(1, root.Id, "http://www.yahoo.com", "UrlItemAndBitstreamName", "this is the description for Yahoo Bitstream");

            RepositoryItem[] items = u1t.Root.ChildrenItems;

            Assert.AreEqual(items.Length, 1);

            RepositoryItem item = items[0];
            Assert.AreEqual(item.ItemName, "UrlItemAndBitstreamName");
            Assert.AreEqual(item.Description, "this is the description for Yahoo Bitstream");
            Assert.AreEqual(item.OwnerId, 1);

            Bundle b = item.Bundle;
            Bitstream[] streams = b.Bitstreams;
            Assert.AreEqual(streams.Length, 1);

            VerifyBitsBitstream("", "this is the description for Yahoo Bitstream", streams[0], new byte[] { }, true, true, "http://www.yahoo.com");

            /***/

            mgr.AddRepoItemBitstreamAsURL(1, item.Id, "http://www.google.com", "the description for the google url", true);

            streams = b.Bitstreams;
            Assert.AreEqual(streams.Length, 2);
            VerifyBitsBitstream("", "the description for the google url", streams[0], new byte[] { }, true, true, "http://www.google.com");
            VerifyBitsBitstream("", "this is the description for Yahoo Bitstream", streams[1], new byte[] { }, false, true, "http://www.yahoo.com");

            /***/

            mgr.AddRepoItemBitstreamAsURL(1, item.Id, "http://www.budweiser.com", "the king of beers", false);

            streams = b.Bitstreams;
            Assert.AreEqual(streams.Length, 3);
            VerifyBitsBitstream("", "the king of beers", streams[0], new byte[] { }, false, true, "http://www.budweiser.com");
            VerifyBitsBitstream("", "the description for the google url", streams[1], new byte[] { }, true, true, "http://www.google.com");
            VerifyBitsBitstream("", "this is the description for Yahoo Bitstream", streams[2], new byte[] { }, false, true, "http://www.yahoo.com");

            /***/

            Bitstream stream = mgr.GetPrimaryBitstreamForRepositoryItem(item.Id);
            VerifyBitsBitstream("", "the description for the google url", stream, new byte[] { }, true, true, "http://www.google.com");

          

        }

        [Test]
        public void tRepoItemsAndBitstreams()
        {
            /*
             * start an item and and verify
             * add another bitstream, set as primary and verify both
             * add a third, set as primary and verify all
             * add a fourth, *don't* set as primary, and verify all
             * delete a bitstream from the item, and verify first three
             * 
             * **what happens when you delete a primary bitstream?
             */

            _mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = _mgr.SetupRepositoryForUser(1);
            RepositoryFolder root = u1t.Root;

            string contentType = _mgr.ContentTypeOf(".xls");

            byte[] data = new byte[] { 5, 6, 7 };
            _mgr.AddRepoItemWithFirstBitstream(1, root.Id, data, contentType, "flooble_itemName", "flooble_filename.xls", ".xls", "this is the description for flooble", 3);

            RepositoryItem[] items = u1t.Root.ChildrenItems;

            Assert.AreEqual(items.Length, 1);

            RepositoryItem item = items[0];
            Assert.AreEqual(item.ItemName, "flooble_itemName");
            Assert.AreEqual(item.Description, "this is the description for flooble");
            Assert.AreEqual(item.OwnerId, 1);

            Bundle b = item.Bundle;
            Bitstream[] streams = b.Bitstreams;
            Assert.AreEqual(streams.Length, 1);

            VerifyBitsBitstream("flooble_filename.xls", "this is the description for flooble", streams[0], data, true);
            

            /***/
            contentType = _mgr.ContentTypeOf(".doc");
            byte[] data2 = new byte[] { 9, 14, 44, 2, 24, 6 };
            _mgr.AddRepoItemBitstream(1, item.Id, data2, contentType, "Flibble_filename.doc", ".doc", data.Length, "the second bitstream for the item", true);

            streams = b.Bitstreams;
            Assert.AreEqual(2, streams.Length);

            VerifyBitsBitstream("Flibble_filename.doc", "the second bitstream for the item", streams[0], data2, true);
            VerifyBitsBitstream("flooble_filename.xls", "this is the description for flooble", streams[1], data, false);

            /***/
            contentType = _mgr.ContentTypeOf(".png");
            byte[] data3 = new byte[] { 9, 14, 44, 2, 24, 6, 55, 99 };
            _mgr.AddRepoItemBitstream(1, item.Id, data3, contentType, "Feeble_filename.png", ".png", data.Length, "the third bitstream for the item", true);

            streams = b.Bitstreams;
            Assert.AreEqual(3, streams.Length);

            VerifyBitsBitstream("Feeble_filename.png", "the third bitstream for the item", streams[0], data3, true);
            VerifyBitsBitstream("Flibble_filename.doc", "the second bitstream for the item", streams[1], data2, false);
            VerifyBitsBitstream("flooble_filename.xls", "this is the description for flooble", streams[2], data, false);


            /***/
            contentType = _mgr.ContentTypeOf(".hta");
            byte[] data4 = new byte[] { 1,2,3,4,5,6,7,8,9 };
            _mgr.AddRepoItemBitstream(1, item.Id, data4, contentType, "Fnoskl_filename.hta", ".hta", data.Length, "the fourth, not primary bitstream for the item", false);

            streams = b.Bitstreams;
            Assert.AreEqual(4, streams.Length);

            VerifyBitsBitstream("Feeble_filename.png", "the third bitstream for the item", streams[0], data3, true);
            VerifyBitsBitstream("Flibble_filename.doc", "the second bitstream for the item", streams[1], data2, false);
            VerifyBitsBitstream("flooble_filename.xls", "this is the description for flooble", streams[2], data, false);
            VerifyBitsBitstream("Fnoskl_filename.hta", "the fourth, not primary bitstream for the item", streams[3], data4, false);
    
            /***/
            //get a the primary bitstream from repomgr...
            Bitstream stream = _mgr.GetPrimaryBitstreamForRepositoryItem(item.Id);
            VerifyBitsBitstream("Feeble_filename.png", "the third bitstream for the item", stream, data3, true);

            /***/
            //get a the of an item by name...
            stream = _mgr.GetBitstreamForItemByName(item.Id, "Fnoskl_filename");
            VerifyBitsBitstream("Fnoskl_filename.hta", "the fourth, not primary bitstream for the item", streams[3], data4, false);
            

            /***/
            //delete a bitstream
            _mgr.DeleteBitstream(streams[1].Id);
            streams = b.Bitstreams;
            Assert.AreEqual(3, streams.Length);

            VerifyBitsBitstream("Feeble_filename.png", "the third bitstream for the item", streams[0], data3, true);
            VerifyBitsBitstream("flooble_filename.xls", "this is the description for flooble", streams[1], data, false);
            VerifyBitsBitstream("Fnoskl_filename.hta", "the fourth, not primary bitstream for the item", streams[2], data4, false);
            
            /***/
            //delete a primary bitstream
            _mgr.DeleteBitstream(streams[0].Id);
            streams = b.Bitstreams;
            Assert.AreEqual(2, streams.Length);

            VerifyBitsBitstream("flooble_filename.xls", "this is the description for flooble", streams[0], data, false);
            VerifyBitsBitstream("Fnoskl_filename.hta", "the fourth, not primary bitstream for the item", streams[1], data4, false);
        }
        public void catchall()
        {
            //add bitstreams with error conditions
            //what happens 
        }
        [Test]
        public void tReplaceSingleItemBitstream()
        {
            //make an item with bitstream
            //replace it with something different
            _mgr = new RepositoryMgr(this._connectionString);
            this.FlushTrees();

            UserRepository u1t = _mgr.SetupRepositoryForUser(1);
            RepositoryFolder root = u1t.Root;

            string contentType = _mgr.ContentTypeOf(".xls");

            byte[] data = new byte[] { 5, 6, 7 };
            _mgr.AddRepoItemWithFirstBitstream(1, root.Id, data, contentType, "flooble_itemName", "flooble_filename.xls", ".xls", "this is the description for flooble", 3);

            RepositoryItem[] items = u1t.Root.ChildrenItems;

            Assert.AreEqual(1, items.Length);
            Bundle bundle = items[0].Bundle;

            Assert.AreEqual("flooble_itemName", items[0].ItemName);
            VerifyBitsBitstream("flooble_filename.xls", "this is the description for flooble", bundle.Bitstreams[0], data, true);


            byte[] data1 = new byte[]{1,3,5,7,9,11,33,15};
            _mgr.ReplaceRepoItem(1, items[0].Id, data1, "", _mgr.ContentTypeOf(".doc"), "a replacement item name", "replaceFile.doc", ".doc", "my replacement bitstream description");
            items = u1t.Root.ChildrenItems;

            Assert.AreEqual("a replacement item name", items[0].ItemName);
            bundle = items[0].Bundle;


            VerifyBitsBitstream("replaceFile.doc", "my replacement bitstream description", bundle.Bitstreams[0], data1, true);


        }
        void VerifyBitsBitstream(string name, string description, Bitstream stream, byte[] data, bool isPrimary, bool isUrl=false, string URL="")
        {

            string ext = isUrl?"":name.Substring(name.LastIndexOf('.'));
            string contentType = isUrl?"URL":_mgr.ContentTypeOf(ext);

            Assert.AreEqual(stream.Name, name);
            Assert.AreEqual(stream.ContentType, contentType);
            Assert.AreEqual(stream.Extension, ext);
            Assert.AreEqual(stream.Description, description);
            Assert.AreEqual(stream.IsPrimary, isPrimary);
            Assert.AreEqual(URL, stream.URL);

            if (!isUrl)            
            {
                byte[] returnedData = new byte[] { };
                stream.GetData(out returnedData);

                Assert.AreEqual(data.Length, returnedData.Length);

                for (int i = 0; i < data.Length; i++)
                    Assert.AreEqual(data[i], returnedData[i]);
            }
        }

    }
}
