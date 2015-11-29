using System;
using System.Collections.Generic;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text;

using DbUtils;

namespace RepositoryLib
{
    public class UserRepository : RepositoryDbObject, IDbObject
    {
        long _ownerId;
        RepositoryFolder _rootNode;
        long _diskUsage;
        long _diskQuota;
        long _maxFileSize;
        public UserRepository()
        {
        }

        public UserRepository(long ownerId, RepositoryMgr mgr)
        {
            this.m_oContext = mgr;
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", ownerId)
			};
            _rootNode = (RepositoryFolder)DbConnector.GetObjectOfType("StartTree", aParams, typeof(RepositoryFolder), this.RepositoryMgr);
            _ownerId = ownerId;
            m_nId = _rootNode.Id;
        }

        void IDbObject.Load(IDataReader reader, object o)
        {

            Init(o);
            m_nId = (long)reader["RepositoryFolderId"];
            _ownerId = (long)reader["OwnerID"];
            _maxFileSize = (long)reader["MaxFileSize"];
            _diskUsage = (long)reader["DiskUsage"];
            _diskQuota = (long)reader["DiskQuota"];
        }
        //long IDbObject.Id { get { return m_nId; } }

        public long Userid { get { return _ownerId; } }

        public void EmptyRecycle()
        {
            RepositoryMgr.EmptyRecycleBin(_ownerId);
        }
        public RepositoryFolder Root
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
			    {
				    new SqlParameter("@pUserID", _ownerId)
    				
			    };
                return (RepositoryFolder)DbConnector.GetObjectOfType("GetRootForUserTree", aParams, typeof(RepositoryFolder), this.RepositoryMgr);
            }
        }
        public long DiskUsage
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
			    {
				    new SqlParameter("@pUserID", _ownerId)
    				
			    };
                return (long)DbConnector.ExecuteScalar("GetDiskUsageForUser", aParams);
            }
        }
        public long DiskQuota { get { return _diskQuota; } }
        public long MaxFileSize { get { return _maxFileSize; } }
        public RepositoryFolder[] RawFolderTree
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pOwnerId", _ownerId)
				};

                return (RepositoryFolder[])DbConnector.GetObjectsOfType("GetUserTree", aParams, typeof(RepositoryFolder), this.m_oContext);
            }
        }

        public void Flush()
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pOwnerId", _ownerId)
			};

            DbConnector.ExecuteScalar("FlushUserTree", aParams);

        }
        public RepositoryItem[] Items
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pOwnerId", _ownerId)
				};
                return (RepositoryItem[])DbConnector.GetObjectsOfType("GetRepositoryItems", aParams, typeof(RepositoryItem), this.m_oContext);
            }
        }
        public Hashtable SortedFileSiblingsHash
        {
            get
            {
                RepositoryItem[] items = Items;

                Hashtable siblingGroups = new Hashtable();
                List<RepositoryItem> siblingGroup = null;

                long lastContainer = 0;
                foreach (RepositoryItem item in items)
                {
                    if (item.RepositoryFolderId != lastContainer)
                    {
                        siblingGroup = new List<RepositoryItem>();
                        siblingGroups.Add(item.RepositoryFolderId, siblingGroup);
                    }
                    siblingGroup.Add(item);
                }

                foreach (object key in siblingGroups.Keys)
                {
                    List<RepositoryItem> itemsList = (List<RepositoryItem>)siblingGroups[key];
                    itemsList.Sort();
                }
                return siblingGroups;
            }
        }
        public Hashtable SortedFolderSiblingsHash
        {
            get
            {
                Hashtable siblingGroups = new Hashtable();
                List<RepositoryFolder> siblingGroup = null;

                SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pOwnerId", _ownerId)
				};
                RepositoryFolder[] folders = (RepositoryFolder[])DbConnector.GetObjectsOfType("GetRepositoryFolders", aParams, typeof(RepositoryFolder), this.m_oContext);

                long lastContainer = 0;
                for (int i = 1; i < folders.Length; i++)
                {
                    RepositoryFolder folder = folders[i];

                    if (folder.Id != lastContainer)
                    {
                        siblingGroup = new List<RepositoryFolder>();
                        siblingGroups.Add(folder.Id, siblingGroup);
                    }
                    siblingGroup.Add(folder);
                }

                foreach (object key in siblingGroups.Keys)
                {
                    List<RepositoryFolder> foldersList = (List<RepositoryFolder>)siblingGroups[key];
                    foldersList.Sort();
                }
                return siblingGroups;
            }
        }
        public RepositoryItem[] UsedItems
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pOwnerId", _ownerId)
				};
                return (RepositoryItem[])DbConnector.GetObjectsOfType("GetUsedRepositoryItems", aParams, typeof(RepositoryItem), this.m_oContext);
            }
        }
        public RepositoryItem[] Search(string searchString)
        {
            if (searchString == "")
                return new RepositoryItem[0];

            searchString.Replace("'", " ");
            string[] parts = searchString.Split(new char[] { ' ' });
            StringBuilder sb = new StringBuilder();
            foreach (string part in parts)
            {
                sb.Append("and keywords like '% " + part + " %' ");
            }
            string searchClause = sb.ToString().Substring(4);
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pOwnerId", _ownerId)
					,new SqlParameter("@pSearchClause", searchClause)
				};

            return (RepositoryItem[])DbConnector.GetObjectsOfType("SearchUserRepository", aParams, typeof(RepositoryItem), this.RepositoryMgr);
        }
    }
		
	
}
