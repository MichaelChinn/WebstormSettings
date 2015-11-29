using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections.Generic;
using System.Text;

using DbUtils;

namespace RepositoryLib
{
	public class RepositoryFolder : RepositoryDbObject, IDbObject
	{
		string _folderName;
		long _ownerId;
		long _parentNodeid;
		int _indentation;
		long _leftOrdinal;
		long _rightOrdinal;

		public RepositoryFolder() { }
		public RepositoryFolder(
				 long folderId
				, string folderName
				, long leftOrdinal
				, long rightOrdinal
				, long ownerId
				, long parentNodeId
				, int indentation)
				
		{
			m_nId = folderId;
			_folderName = folderName;
			_ownerId = ownerId;
			_leftOrdinal = leftOrdinal;
			_rightOrdinal = rightOrdinal;
			_parentNodeid = parentNodeId;
			_indentation = indentation;
		}

		void IDbObject.Load(IDataReader reader, object o)
		{

			Init(o);
			m_nId = (long)reader["RepositoryFolderId"];
			_folderName = (string)reader["FolderName"];
			_ownerId = (long)reader["OwnerID"];
			_parentNodeid = GetLongProperty(reader, "ParentNodeId",-1);
			_indentation = (int)reader["Indentation"];
			_leftOrdinal = (long)reader["LeftOrdinal"];
			_rightOrdinal = (long)reader["rightOrdinal"];
		}
		//long IDbObject.Id { get { return m_nId; } }

		public int Indentation { get { return _indentation; } }

		public string Name { get { return _folderName; } }
		public long OwnerId { get { return _ownerId; } }
		public long ParentNodeId { get { return _parentNodeid; } }
		public long LeftOrdinal { get { return _leftOrdinal; } }
		public long RightOrdinal { get { return _rightOrdinal; } }

		public void Recycle()
		{
            RepositoryMgr.RecycleFolder(Id);
		}
		public RepositoryItem AddItem(string name, long userId)
		{
			SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pParentNodeId", m_nId)
				,new SqlParameter("@pUserId", userId)
				,new SqlParameter("@pItemName", name)
			};
			return (RepositoryItem)DbConnector.GetObjectOfType("AddItem", aParams, typeof(RepositoryItem), this.Context);
		}
		public RepositoryFolder AddFolder(string name)
		{
			SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pParentNodeId", m_nId)
				,new SqlParameter("@pName", name)
			};
			return (RepositoryFolder)DbConnector.GetObjectOfType("AddFolder", aParams, typeof(RepositoryFolder), this.Context);
		}

		public RepositoryFolder Rename(string name)
		{
			SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pFolderId", m_nId)		
				,new SqlParameter("@pNewName", name)
	
			};
			RepositoryFolder f = (RepositoryFolder)DbConnector.GetObjectOfType("RenameFolder", aParams, typeof(RepositoryFolder), this.Context);
			_folderName = name;
			return f;
		}
		public RepositoryItem FindChildItem(string name)
		{
			SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pParentNodeId", m_nId)
				,new SqlParameter("@pName", name)
			};
			return (RepositoryItem)DbConnector.GetObjectOfType("GetChildItemByName", aParams, typeof(RepositoryItem), this.Context);
		}
		public RepositoryFolder FindChildFolder(string name)
		{
			SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pParentNodeId", m_nId)
				,new SqlParameter("@pName", name)
			};
			return (RepositoryFolder)DbConnector.GetObjectOfType("GetChildFolderByName", aParams, typeof(RepositoryFolder), this.Context);
		}
		public void Move(RepositoryFolder destNode)
		{
            RepositoryMgr.MoveFolder(m_nId, destNode.Id);

		}
        public List<string> ChildrenNames
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pParentNodeId", m_nId)
                };

                SqlDataReader r = DbConnector.ExecuteDataReader("GetChildrenNames", aParams);
                List<string> retVal = new List<string>();

                try
                {
                    while (r.Read())
                    {
                        retVal.Add(GetStringProperty(r, "Name", ""));
                    }
                }
                finally
                {
                    r.Close();
                }
                return retVal;
            }
        }
        public RepositoryFolder[] ChildrenFolders
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
			    {
				    new SqlParameter("@pParentNodeId", m_nId)
			    };
                return (RepositoryFolder[])DbConnector.GetObjectsOfType("GetChildrenFolders", aParams, typeof(RepositoryFolder), this.Context);
            }
        }
        public RepositoryItem[] DescendantItems
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
			    {
				    new SqlParameter("@pParentNodeId", m_nId)
			    };
                return (RepositoryItem[])DbConnector.GetObjectsOfType("GetDescendentItems", aParams, typeof(RepositoryItem), this.Context);
            }
        }
        public RepositoryItem[] ChildrenItems
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
			    {
				    new SqlParameter("@pParentNodeId", m_nId)
			    };
                return (RepositoryItem[])DbConnector.GetObjectsOfType("GetChildrenItems", aParams, typeof(RepositoryItem), this.Context);
            }
        }
        public string Path
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pFolderId", this.Id) };
                SqlDataReader r = DbConnector.ExecuteDataReader("GetFolderPath", aParams);
                StringBuilder sb = new StringBuilder();
                try
                {
                    while (r.Read())
                    {
                        sb.Append(GetStringProperty(r, "FolderName", "") + "\\");

                    }
                }
                finally
                {
                    r.Close();
                }
                return sb.ToString();

            }
        }
        public RepositoryItem[] UsedItems
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
			    {
                    new SqlParameter("@pOwnerId", -1)
				    ,new SqlParameter("@pFolderId", this.Id)
			    };
                return (RepositoryItem[])DbConnector.GetObjectsOfType("GetUsedRepositoryItems", aParams, typeof(RepositoryItem), Context);

            }
        }

        public void Delete()
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pFolderId", m_nId)
			};
            DbConnector.ExecuteNonQuery("DeleteRepositoryFolder", aParams);
        }
    
    }
}
