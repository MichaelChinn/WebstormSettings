using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text;
using System.Collections;
using System.Collections.Generic;

using DbUtils;

namespace RepositoryLib
{
	public class RepositoryItem : RepositoryDbObject, IDbObject, IComparable<RepositoryItem>
	{
        string _itemName;
        long _ownerId;
        string _description;
        string _keywords;
        bool _verifiedByStudent;
        long _repositoryFolderId;
        bool _isWithdrawn;
        long _size;

		private string ScrubKeywords(string phrase)
		{
			StringBuilder sb = new StringBuilder();
			ArrayList list = new ArrayList();
			Hashtable hash = new Hashtable();

			string[] parts = phrase.Split(new char[] { ' ' });

			//get rid of duplicate keywords
			foreach (string word in parts)
			{
				if (!hash.ContainsKey(word))
					hash.Add(word, null);
			}
			//alphabetize
			foreach (string word in hash.Keys)
			{
				list.Add(word);
				list.Sort();
			}

			//update object
			foreach (string word in list)
			{
				sb.Append(" " + word);
			}
			return sb.ToString() + " ";
		}

		public RepositoryItem() { }

        public RepositoryItem(
                string itemName
                , long ownerID
                , string description
                , string keywords
                , bool verifiedByStudent
                , long repositoryFolderId
                , bool withdrawnFlag)
        {
            //this constructor for nunit to ease comparisons
            //note that it doesn't do anything with immutable or used
            _itemName = itemName;
            _ownerId = ownerID;
            _description = description;
            _keywords = keywords;
            _verifiedByStudent = verifiedByStudent;
            _repositoryFolderId = repositoryFolderId;
            _isWithdrawn = withdrawnFlag;
        }

		public int CompareTo(RepositoryItem other)
		{
			return _itemName.CompareTo(other.ItemName);
		}
            
		void IDbObject.Load(IDataReader reader, object o)
		{
			Init(o);
            m_nId = GetLongProperty(reader, "RepositoryItemId", -1);
            _itemName = GetStringProperty(reader, "ItemName", "");
            _ownerId = GetLongProperty(reader, "OwnerID", -1);
            _description = GetStringProperty(reader, "ItemDescription", "");
            _keywords = GetStringProperty(reader, "Keywords", "");
            _verifiedByStudent = GetBooleanProperty(reader, "VerifiedByStudent", false);
            _repositoryFolderId = GetLongProperty(reader, "RepositoryFolderId", -1);
            _isWithdrawn = GetBooleanProperty(reader, "WithdrawnFlag", false);
            _size = GetLongProperty(reader, "Size", 0);
        }

		public string ItemName { get { return _itemName; } set { _itemName = value; } }
		public long OwnerId { get { return _ownerId; } }
		public string Description { get { return _description; } set { _description = value; } }
		public string Keywords { get { return _keywords; } set { _keywords = ScrubKeywords(value); } }
		public bool VerifiedByStudent { get { return _verifiedByStudent; } set { _verifiedByStudent = value; } }
		public long RepositoryFolderId { get { return _repositoryFolderId; } set { _repositoryFolderId = value; } }
        public bool IsWithdrawn { get { return _isWithdrawn; } set { _isWithdrawn = value; } }
        public long Size { get { return _size; } }
        public bool IsImmutable
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                };
                return (bool)DbConnector.ExecuteScalar("GetIsItemImmutable", aParams);
            }
        }
        public bool IsUsed
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                };
                return (bool)DbConnector.ExecuteScalar("GetIsItemUsed", aParams);
            }
        }
        public void SetItemImmutable(string appString)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                    ,new SqlParameter("@pIsImmutable", true)
                    ,new SqlParameter("@pApplicationString", appString)
                };
            DbConnector.ExecuteNonQuery("SetUnsetItemImmutable", aParams);
        }
        public void UnSetItemImmutable(string appString)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                    ,new SqlParameter("@pIsImmutable", false)
                    ,new SqlParameter("@pApplicationString", appString)
                };
            DbConnector.ExecuteNonQuery("SetUnsetItemImmutable", aParams);
        }
        public void SetItemUsed(string appString)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                    ,new SqlParameter("@pIsUsed", true)
                    ,new SqlParameter("@pApplicationString", appString)
                };
            DbConnector.ExecuteNonQuery("SetUnsetItemUsed", aParams);
        }
        public void UnSetItemUsed(string appString)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                    ,new SqlParameter("@pIsUsed", false)
                    ,new SqlParameter("@pApplicationString", appString)
                };
            DbConnector.ExecuteNonQuery("SetUnsetItemUsed", aParams);
        }

        public string ItemPath
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[] {
				new SqlParameter ("@pItemId", m_nId)
				};

                SqlDataReader r = DbConnector.ExecuteDataReader("GetItemPathComponents", aParams);
                StringBuilder components = new StringBuilder();
                try
                {
                    while (r.Read())
                    {
                        components.Append(r["FolderName"] + "\\");
                    }
                }
                finally
                {
                    r.Close();
                }

                return components.ToString();
            }
        }
        public List<string> ItemPathList
        {
            get
            {
                List<string> components = new List<string>();

                SqlParameter[] aParams = new SqlParameter[] {
				new SqlParameter ("@pItemId", m_nId)
				};

                SqlDataReader r = DbConnector.ExecuteDataReader("GetItemPathComponents", aParams);
                try
                {
                    while (r.Read())
                    {
                        components.Add((string)r["FolderName"]);
                    }
                }
                finally
                {
                    r.Close();
                }
                return components;
            }
        }
        public void Move(long folderId)
		{
            RepositoryMgr.MoveRepositoryItem(m_nId, folderId);
		}
		public void Move(RepositoryFolder folder)
		{
			this.Move(folder.Id);
		}
        
        public void Save()
		{
			SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pItemId", m_nId)
                    ,new SqlParameter("@pItemName", _itemName)
					,new SqlParameter("@pDescription", _description)
					,new SqlParameter("@pKeywords", _keywords)
					,new SqlParameter("@pVerifiedByStudent", _verifiedByStudent)
					,new SqlParameter("@pWithdrawnFlag", _isWithdrawn)
				};
			DbConnector.ExecuteNonQuery("UpdateRepositoryItem", aParams);
		}

        public void Recycle()
        {
            RepositoryMgr.RecycleRepositoryItem(Id);
        }

        public Bundle Bundle
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                };
                return (Bundle)DbConnector.GetObjectOfType("GetBundleForItem", aParams, typeof(Bundle), this.Context);
            }
        }
        public long RefCount
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pItemId", m_nId)
                };
                return (long)DbConnector.ExecuteScalar("GetItemRefCount", aParams);
            }
        }
      

	}
}
