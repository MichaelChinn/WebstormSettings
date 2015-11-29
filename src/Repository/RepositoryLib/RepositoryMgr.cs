using System;
using System.Collections.Generic;
using System.Text;
using DbUtils;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Configuration;

namespace RepositoryLib
{
	// Efoliolite gets Session State related run-time errors if this class is not marked as Serializable.  
	// if this is a problem for other apps using this library, we can delete and I'll just try to maintain this one change in my 
	// copy of code.
    [Serializable()]
    public class RepositoryMgr
    {

		static private RepositoryMgr _instance = null;

		public static RepositoryMgr Instance
		{
			get
			{
				if (_instance == null)
				{
					_instance = new RepositoryMgr(ConfigurationManager.ConnectionStrings["RepoDbConnection"].ConnectionString);
				}
				return _instance;
			}
		}

        string _connectionString;
        public static string AppMgrKey = "MGR:RepositoryMgr";

        public RepositoryMgr(string connectionString)
        {
            _connectionString = connectionString;
        }

        public RepositoryMgr()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["RepoDbConnection"].ConnectionString;
        }

        public void EmptyRecycleBin(long ownerId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", ownerId)
			};

            DbConnector.ExecuteScalar("EmptyRecycle", aParams);
        }

        //special code just for efoliolite version of repository
        public void EmptyEfolioLiteRecycleBin(long ownerId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", ownerId)
                ,new SqlParameter("@pCheckEfolioLitePortfolio", 1)
			};

            DbConnector.ExecuteScalar("EmptyRecycle", aParams);
        }

        //special code just for coestudent version of repository
        public void EmptyCOEStudentRecycleBin(long ownerId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", ownerId)
                ,new SqlParameter("@pCheckCOEStudentPortfolio", 1)
			};

            DbConnector.ExecuteScalar("EmptyRecycle", aParams);
        }

        public DbConnector DbConnector { get { return new DbConnector(_connectionString); } }
        public string ConnectionString { get { return _connectionString; } }

        public RepositoryMgr(string connectionString, bool isCString) { _connectionString = connectionString; }

        public UserRepository SetupRepositoryForUser(long ownerId)
        {
            //I know this is a bit screwy, but it turns out that it's handy to
            //do it this way so that trees can be initialized through the test harness.
            //It doesn't happen so often that users initialize new trees, so I think the
            //performance his would be minor.

            new UserRepository(ownerId, this);
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pOwnerid", ownerId)
            };
            return (UserRepository) DbConnector.GetObjectOfType("GetRepositoryForUser", aParams, typeof(UserRepository), this);

        }
        public bool UserHasRepository(long ownerId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", ownerId)
			};
            UserRepository r = (UserRepository)DbConnector.GetObjectOfType("GetRepositoryForUser", aParams, typeof(UserRepository), this);

            return r == null ? false : true;
        }

        public UserRepository Repository(long ownerId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", ownerId)
			};
            UserRepository r = (UserRepository)DbConnector.GetObjectOfType("GetRepositoryForUser", aParams, typeof(UserRepository), this);

            if (r == null)
                r = SetupRepositoryForUser(ownerId);

            return r;
        }

        public void FlushUserTree(long ownerId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", ownerId)
			};
            DbConnector.ExecuteNonQuery("FlushUserTree", aParams);
        }

        public void DeleteBitstream(long bitstreamId)
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pBitstreamId", bitstreamId)
            };
            DbConnector.ExecuteNonQuery("DeleteBitstream", aParams);
        }

        public void AddRepoItemBitstream(
                long userId, long repositoryItemId, byte[] bitstream
                , string contentType, string filename, string extension, long size, string description, bool isPrimary)
        {
            if (contentType == "URL")
                throw (new Exception("'URL' is not a valid content type when adding a bitstream"));

            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pRepositoryItemId", repositoryItemId)
                ,new SqlParameter("@pContentType", contentType)
                ,new SqlParameter("@pBitstream", bitstream)
                ,new SqlParameter("@pName", filename)
                ,new SqlParameter("@pExt", extension)
                ,new SqlParameter("@pDescription", description)
                ,new SqlParameter("@pSize", size)
                ,new SqlParameter("@pIsPrimaryBitstream", isPrimary)
                ,new SqlParameter("@pOwnerId", userId)
            };
            DbConnector.ExecuteNonQuery("AddBitstreamToRepositoryItem", aParams);
        }

        public void AddRepoItemBitstreamAsURL(
        long userId, long repositoryItemId, string url, string description, bool isPrimary)
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pRepositoryItemId", repositoryItemId)
                ,new SqlParameter("@pContentType", "URL")
                ,new SqlParameter("@pName", "")
                ,new SqlParameter("@pExt", "")
                ,new SqlParameter("@pUrl", url)
                ,new SqlParameter("@pDescription", description)
                ,new SqlParameter("@pSize", 0)
                ,new SqlParameter("@pIsPrimaryBitstream", isPrimary)
                ,new SqlParameter("@pOwnerId", userId)
            };
            DbConnector.ExecuteNonQuery("AddBitstreamToRepositoryItem", aParams);
        }

        public RepositoryItem AddRepoItemWithFirstBitstream(
            long userId, long folderId, byte[] bitstream
            , string contentType, string itemName, string fileName
            , string fileExtension, string description, int size)
        {
            if (contentType == "URL")
                throw (new Exception("'URL' is not a valid content type when adding a bitstream"));

            SqlParameter[] aParams = new SqlParameter[]
			{
                 new SqlParameter("@pUserID", userId)
				,new SqlParameter("@pParentNodeID", folderId)
				,new SqlParameter("@pBitstream", bitstream)
                ,new SqlParameter("@pContentType", contentType)
                ,new SqlParameter("@pItemName", itemName)
                ,new SqlParameter("@pFileName", fileName)
                ,new SqlParameter("@pFileExt", fileExtension)
                ,new SqlParameter("@pDescription", description)
                ,new SqlParameter("@pSize", size)
			};
            return (RepositoryItem)DbConnector.GetObjectOfType("AddRepositoryItemWithSingleFile", aParams,typeof(RepositoryItem), this);
        }

        public RepositoryItem AddRepoItemWithFirstBitstreamAsURL(
            long userId, long folderId, string URLString
            , string itemName, string description)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
                 new SqlParameter("@pUserID", userId)
				,new SqlParameter("@pParentNodeID", folderId)
				,new SqlParameter("@pURL", URLString)
                ,new SqlParameter("@pFileName", "")
                ,new SqlParameter("@pItemName", itemName)
                ,new SqlParameter("@pFileExt", "")
                ,new SqlParameter("@pDescription", description)
                ,new SqlParameter("@pSize", 0)
                ,new SqlParameter("@pContentType", "URL")
			};
            return (RepositoryItem)DbConnector.GetObjectOfType("AddRepositoryItemWithSingleFile", aParams, typeof(RepositoryItem), this);
        }


        public RepositoryItem ReplaceRepoItem(long userId, long repoItemId, byte[] bitstream, string url
            , string contentType, string itemName, string fileName, string fileExtension, string description)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
                 new SqlParameter("@pUserID", userId)
				,new SqlParameter("@pItemId", repoItemId)
				,new SqlParameter("@pBitstream", bitstream)
                ,new SqlParameter("@pContentType", contentType)
                ,new SqlParameter("@pItemName", itemName)
                ,new SqlParameter("@pFileName", fileName)
                ,new SqlParameter("@pFileExt", fileExtension)
                ,new SqlParameter("@pDescription", description)
                ,new SqlParameter("@pUrl", url)
   
			};
            return (RepositoryItem)DbConnector.GetObjectOfType("ReplaceSingleBitstreamRepoItem", aParams, typeof(RepositoryItem), this);

        }

        public Bitstream GetPrimaryBitstreamForRepositoryItem(long repositoryItemId)
        {
            SqlParameter[] aParams = new SqlParameter[] 
                {
                    new SqlParameter("@pRepositoryItemId", repositoryItemId)
                };
            return (Bitstream)DbConnector.GetObjectOfType("GetPrimaryBitstreamForRepositoryItem", aParams, typeof(Bitstream), this);
        }

        public Bitstream Bitstream(long bitstreamId)
        {
            SqlParameter[] aParams = new SqlParameter[] 
                {
                    new SqlParameter("@pBitstreamId", bitstreamId)
                };
            return (Bitstream)DbConnector.GetObjectOfType("GetBitstreamById", aParams, typeof(Bitstream), this);
        }

        public void MoveFolder(long srcFolderId, long destFolderId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pSubTreeRoot", srcFolderId)
				,new SqlParameter("@pDestFolder", destFolderId)
			};
            DbConnector.ExecuteScalar("MoveSubTree", aParams);
        }

        public void MoveRepositoryItem(long itemId, long folderId)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pItemId", itemId)
					,new SqlParameter("@pDestFolderId", folderId)
				};

            DbConnector.ExecuteScalar("MoveItem", aParams);
        }
        public void MoveBitstreamItem(long bitstreamId, long repositoryItemId, bool makePrimary)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pBitstreamId", bitstreamId)
					,new SqlParameter("@pDestRepositoryItemId", repositoryItemId)
                    ,new SqlParameter("@pMakePrimary", makePrimary)
				};

            DbConnector.ExecuteScalar("MoveBitStreamItem", aParams);
        }
        public void MoveBitstreamItem(long bitstreamId, long bundleID, long repositoryItemId)
        {
            MoveBitstreamItem(bitstreamId, repositoryItemId, false);
        }

        public void RenameFolder(long folderId, string name)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pFolderId", folderId)		
				,new SqlParameter("@pNewName", name)
	
			};
            DbConnector.ExecuteNonQuery("RenameFolder", aParams);
        }

        public void RenameRepositoryItem(long itemId, string name)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pItemId", itemId)		
				,new SqlParameter("@pNewName", name)
	
			};
            DbConnector.ExecuteNonQuery("RenameRepositoryItem", aParams);
        }

        [Obsolete("RenameBitstream is deprecated, use 'SaveMetaData' on bitstream object.")]
        public void RenameBitstream(long bitstreamId, string name, string extension)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pBitstreamId", bitstreamId)		
				,new SqlParameter("@pNewName", name)
				,new SqlParameter("@pNewExtension", extension)
				
			};
            DbConnector.ExecuteNonQuery("RenameBitstream", aParams);
        }

        public void RecycleFolder(long folderId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pFolderId", folderId)
			};
            DbConnector.ExecuteScalar("RecycleFolder", aParams);
        }

        public void RecycleRepositoryItem(long itemId)
        {
            SqlParameter[] p = new SqlParameter[]
            {
                new SqlParameter("@pItemId", itemId)
            };
            DbConnector.ExecuteNonQuery("RecycleItem", p);

        }

        public RepositoryFolder AddFolder(long folderId, string name)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pParentNodeId", folderId)
				,new SqlParameter("@pName", name)
			};
            return (RepositoryFolder)DbConnector.GetObjectOfType("AddFolder", aParams, typeof(RepositoryFolder), this);
        }
        public RepositoryFolder GetFolderById(long folderId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pFolderId", folderId)
			};
            return (RepositoryFolder)DbConnector.GetObjectOfType("GetFolderNode", aParams, typeof(RepositoryFolder), this);
        }

        public RepositoryItem RepositoryItem(long repositoryItemId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pRepositoryItemID", repositoryItemId)
			};
            return (RepositoryItem)DbConnector.GetObjectOfType("GetRepositoryItemById", aParams, typeof(RepositoryItem), this);
        }
        public void DeleteRepositoryItem(long itemId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pItemId", itemId)
			};
            DbConnector.ExecuteNonQuery("DeleteRepositoryItem", aParams);
        }
        public void DeleteRepositoryItem(RepositoryItem item)
        {
            DeleteRepositoryItem(item.Id);
        }

        public Bitstream GetBitstreamForItemByName(long repositoryItemId, string bitstreamName)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pBitstreamName", bitstreamName)
                    ,new SqlParameter("@pItemId", repositoryItemId)
                };
            return (Bitstream)DbConnector.GetObjectOfType("GetBitstreamForItemByName", aParams, typeof(Bitstream), this);
        }

        public RepositoryFolder UserRecycleFolder(long ownerId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			    {
				    new SqlParameter("@pUserId", ownerId)
			    };
            return (RepositoryFolder)DbConnector.GetObjectOfType("GetRecycleFolderForUserTree", aParams, typeof(RepositoryFolder), this);
        }
        public RepositoryItem[] FolderDescendantItems(long folderId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			    {
				    new SqlParameter("@pParentNodeId", folderId)
			    };
            return (RepositoryItem[])DbConnector.GetObjectsOfType("GetDescendentItems", aParams, typeof(RepositoryItem), this);
        }
        public bool IsItemUsed(long itemId)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", itemId)
                };
            return (bool)DbConnector.ExecuteScalar("GetIsItemUsed", aParams);
        }

        public string ContentTypeOf(string extension)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pExtension", extension)
                };
            return (string)DbConnector.ExecuteScalar("GetExtensionContentType", aParams);
        }
    }
}
