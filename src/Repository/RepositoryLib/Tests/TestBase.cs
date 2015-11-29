using System;
using System.Collections.Generic;
using System.Text;
using RepositoryLib;
using NUnit.Framework;
using DbUtils;
using System.Data.SqlClient;


namespace RepositoryLib.Tests
{
    public class TestBase
    {
        protected void FlushTrees()
        {
            RepositoryMgr mgr = new RepositoryMgr(_connectionString);
            mgr.DbConnector.ExecuteNonSpScalar("FlushTrees");
        }
        protected string TestFileDir = @"D:\dev\common\trunk\Repository\RepositoryLib\Tests\Testfiles\";
        protected string _connectionString = "data source=localhost;database=repository;uid=sa;pwd=mumBleFr@tz;Pooling=true;Max Pool Size=2000";

        protected void CheckFolder(RepositoryFolder expected, RepositoryFolder actual, int n)
        {
            Assert.AreEqual(expected.Indentation, actual.Indentation, "... at " + n.ToString() + " indentation");
            Assert.AreEqual(expected.Name, actual.Name, "... at " + n.ToString() + " Name");
            Assert.AreEqual(expected.OwnerId, actual.OwnerId, "... at " + n.ToString() + " OwnerId");
            //Assert.AreEqual(expected.ParentNodeId, actual.ParentNodeId,"... at " + n.ToString() + "ParentNodeId ");
            //Assert.AreEqual(expected.Id, actual.Id,"... at " + n.ToString() + "Id ");
            Assert.AreEqual(expected.LeftOrdinal, actual.LeftOrdinal, "... at " + n.ToString() + " left ord");
            Assert.AreEqual(expected.RightOrdinal, actual.RightOrdinal, "... at " + n.ToString() + "right ord");
        }
        protected void CheckFolder(RepositoryFolder expected, RepositoryFolder actual)
        {
            CheckFolder(expected, actual, -1);
        }
        protected void CheckFolder(RepositoryFolder[] expected, RepositoryFolder[] actual)
        {
            for (int i = 0; i < actual.Length; i++)
                CheckFolder(expected[i], actual[i], i);
        }

        protected void CheckItem(RepositoryItem expected, RepositoryItem actual, int n)
        {
            Assert.AreEqual(expected.ItemName, actual.ItemName, "filename: " + n.ToString());
            Assert.AreEqual(expected.OwnerId, actual.OwnerId, "OwnerId              : " + n.ToString());
            Assert.AreEqual(expected.Description, actual.Description, "Description          : " + n.ToString());
            Assert.AreEqual(expected.Keywords, actual.Keywords, "Keywords             : " + n.ToString());
            Assert.AreEqual(expected.VerifiedByStudent, actual.VerifiedByStudent, "VerifiedByStudent    : " + n.ToString());
            Assert.AreEqual(expected.IsWithdrawn, actual.IsWithdrawn, "VerifiedByStudent    : " + n.ToString());
            Assert.AreEqual(expected.RepositoryFolderId, actual.RepositoryFolderId, "RepositoryFolderId   : " + n.ToString());
        }

        protected void CheckItem(RepositoryItem expected, RepositoryItem actual)
        {
            CheckItem(expected, actual, -1);
        }
        protected void CheckItem(RepositoryItem[] expected, RepositoryItem[] actual)
        {
            for (int i = 0; i < actual.Length; i++)
                CheckItem(expected[i], actual[i], i);
        }

        protected void CheckBitstream(SortedList<string,Bitstream>expected, Bitstream[] actual)
        {
            Assert.AreEqual(expected.Count, actual.Length);
            int i = 0;
            foreach (KeyValuePair<string, Bitstream> kvp in expected)
            {
                CheckBitstream(kvp.Value, actual[i++]);
            }
        }
        protected void CheckBitstream(Bitstream expected, Bitstream actual)
        {
            Assert.AreEqual(expected.BundleId, actual.BundleId, "bitstream bundleId from stream" + actual.Name);
            Assert.AreEqual(expected.Description, actual.Description, "bitstream description from stream" + actual.Name);
            Assert.AreEqual(expected.Extension, actual.Extension, "bitstream Extension from stream" + actual.Name);
            Assert.AreEqual(expected.IsPrimary, actual.IsPrimary, "bitstream IsPrimary from stream" + actual.Name);
            Assert.AreEqual(expected.Name, actual.Name, "bitstream Name from stream" + actual.Name);
            Assert.AreEqual(expected.OwnerId, actual.OwnerId, "bitstream OwnerId from stream" + actual.Name);
            Assert.AreEqual(expected.Size, actual.Size, "bitstream Size from stream" + actual.Name);
        }
        protected void PutFirstBitstreamWithMgr(RepositoryMgr mgr
            , ref SortedList<string, Bitstream> streams
            , long userId
            , RepositoryFolder folder
            , byte[] bitstream
            , string contentType
            , string itemName
            , string fileName
            , string fileExtension
            , string description
            , int size
            )
        {

            mgr.AddRepoItemWithFirstBitstream(
                userId
                , folder.Id
                , bitstream
                , contentType
                , itemName
                , fileName
                , fileExtension
                , description
                , size);

            DbConnector conn = new DbConnector(_connectionString);

            string sqlQuery =
                "select bs.bundleId from bitstream bs "
                + "join bundle b on b.bundleId = bs.bundleID "
                + "join repositoryItem i on i.RepositoryItemId = b.RepositoryItemId "
                + "where bs.Name = '" + fileName.ToString() + "' "
                + "and i.repositoryfolderId = " + folder.Id.ToString() + " "
                + "and i.itemName = '" + itemName.ToString() + "' ";

            long bundleId = (long)conn.ExecuteNonSpScalar(sqlQuery);

            Bitstream stream = new Bitstream(
                bundleId
                , fileName
                , fileExtension
                , description
                , ""
                , size
                , DateTime.Now
                , DateTime.Now
                , userId
                , contentType
                , true);

            streams.Add(stream.Name, stream);

        }

        protected void PutNextBitstreamWithMgr(RepositoryMgr mgr
            , ref SortedList<string, Bitstream> streams
            , long userId
            , RepositoryFolder folder
            , byte[] bitstream
            , string contentType
            , string itemName
            , string fileName
            , string fileExtension
            , string description
            , long size
            , bool isPrimary
        )
        {
            RepositoryItem item = folder.FindChildItem(itemName);

            mgr.AddRepoItemBitstream(
                userId
                , item.Id
                , bitstream
                , contentType
                , fileName
                , fileExtension
                , size
                , description
                , isPrimary
                );

            string sqlQuery =
                "select bs.bundleId from bitstream bs "
                + "join bundle b on b.bundleId = bs.bundleID "
                + "join repositoryItem i on i.RepositoryItemId = b.RepositoryItemId "
                + "where bs.Name = '" + fileName.ToString() + "' "
                + "and i.RepositoryItemId = " + item.Id.ToString();

            DbConnector conn = new DbConnector(_connectionString);

            long bundleId = (long)conn.ExecuteNonSpScalar(sqlQuery);

            Bitstream stream = new Bitstream(
                bundleId
                , fileName
                , fileExtension
                , description
                , fileName+fileExtension
                , size
                , DateTime.Now
                , DateTime.Now
                , userId
                , contentType
                , isPrimary);

            streams.Add(stream.Name, stream);
        }

        void PutFirstUrlThroughRepoMgr(
            RepositoryMgr mgr
            , ref SortedList<string, Bitstream> streams
            , RepositoryFolder folder
            , string itemName
            , string URL
            , string description
            , long ownerId)
        {

            mgr.AddRepoItemWithFirstBitstreamAsURL(ownerId, folder.Id, URL, itemName, description);

            string sqlQuery =
                "select bs.bundleId from bitstream bs "
                + "join bundle b on b.bundleId = bs.bundleID "
                + "join repositoryItem i on i.RepositoryItemId = b.RepositoryItemId "
                + "where bs.URL = '" + URL.ToString() + "' "
                + "and i.repositoryfolderId = " + folder.Id.ToString() + " "
                + "and i.itemName = '" + itemName.ToString() + "' ";
            
            DbConnector conn = new DbConnector(_connectionString);
            long bundleId = (long)conn.ExecuteNonSpScalar(sqlQuery);

            Bitstream stream = new Bitstream(
                bundleId
                , ""
                , ""
                , description
                , URL
                , 0
                , DateTime.Now
                , DateTime.Now
                , ownerId
                , "URL"
                , true);

            streams.Add(stream.Name, stream);
        }

        void PutNextUrlThroughRepoMgr(
            RepositoryMgr mgr
            , ref SortedList<string, Bitstream> streams
            , RepositoryFolder folder
            , string itemName
            , long ownerId
            , string URL
            , string description
            , bool isPrimary
            )
        {
            RepositoryItem item = folder.FindChildItem(itemName);
            mgr.AddRepoItemBitstreamAsURL(ownerId, item.Id, URL, description, isPrimary);

            string sqlQuery =
                "select bs.bundleId from bitstream bs "
                + "join bundle b on b.bundleId = bs.bundleID "
                + "join repositoryItem i on i.RepositoryItemId = b.RepositoryItemId "
                + "where bs.Name = '" + URL.ToString() + "' "
                + "and i.RepositoryItemId = " + item.Id.ToString();

            DbConnector conn = new DbConnector(_connectionString);
            long bundleId = (long)conn.ExecuteNonSpScalar(sqlQuery);


            Bitstream stream = new Bitstream(
                bundleId
                , ""
                , ""
                , description
                , URL
                , 0
                , DateTime.Now
                , DateTime.Now
                , ownerId
                , "URL"
                , false);

            streams.Add(stream.Name, stream);
        }
 
        void PutBitstreamThroughBundle(
            ref SortedList<string, Bitstream> streams
            , Bundle b
            , byte[] data
            , string fileName
            , string extension
            , string contentType
            , string description
            , bool isPrimary
            , long ownerId)
        {
            Bitstream dbBitstream = b.AddBitstream(data, fileName, extension, contentType, description, isPrimary, ownerId);

            Bitstream stream = new Bitstream(
                dbBitstream.BundleId
                , fileName
                , extension
                , description
                , ""
                , data.Length
                , DateTime.Now
                , DateTime.Now
                , ownerId
                , contentType
                , true);

            streams.Add(stream.Name, stream);
        }
       

    }
}
