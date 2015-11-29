using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;

using DbUtils;
namespace RepositoryLib
{
    public class Bundle : RepositoryDbObject, IDbObject
    {
		long _primaryBitstreamId;
		long _itemId;


		public Bundle() { }
        public Bundle(
            long primaryBitstreamId
            , long itemId
            )
        {
            m_nId = -1;
            _primaryBitstreamId = primaryBitstreamId;
            _itemId = itemId;
        }

		void IDbObject.Load(IDataReader reader, object o)
		{
			Init(o);
			m_nId = (long)reader["BundleId"];
			_primaryBitstreamId = GetLongProperty(reader, "PrimaryBitstreamId", -1);
			_itemId = GetLongProperty(reader, "RepositoryItemId",-1);
		}
        public long PrimaryBitstreamId { get { return _primaryBitstreamId; } set { _primaryBitstreamId = value; } }
        public long RepositoryItemId { get { return _itemId; } set { _itemId=value; } }
        [Obsolete]
        public Bitstream AddBitstreamAsURL(string URL, string name, string description, long ownerId)
        {
            return AddBitstreamAsURL(URL,  description, false, ownerId);
        }
        [Obsolete]
        public Bitstream AddBitstreamAsURL(string URL, string name, string description, bool isPrimary, long ownerId)
        {
            if (URL.Length == 0)
            {
                throw new Exception("When specifying content as 'URL', must provide one");
            }
            return AddBitstreamAsURL(URL, description, isPrimary, ownerId);

        }
        public Bitstream AddBitstreamAsURL(string URL, string description, long ownerId)
        {
            if (URL.Length == 0)
            {
                throw new Exception("When specifying content as 'URL', must provide one");
            }
            return AddBitstreamAsURL(URL, description, false, ownerId);

        }
        public Bitstream AddBitstreamAsURL(string URL, string description, bool IsPrimary, long ownerId)
        {
            if (URL.Length == 0)
            {
                throw new Exception("When specifying content as 'URL', must provide one");
            }
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pRepositoryItemId", _itemId)
                ,new SqlParameter("@pContentType", "URL")
                ,new SqlParameter("@pUrl", URL)
                ,new SqlParameter("@pName", "")
                ,new SqlParameter("@pExt", "")
                ,new SqlParameter("@pDescription", description)
                ,new SqlParameter("@pSize", 0)
                ,new SqlParameter("@pIsPrimaryBitstream", IsPrimary)
                ,new SqlParameter("@pOwnerId", ownerId)
            };
            return (Bitstream)DbConnector.GetObjectOfType("AddBitstreamToRepositoryItem", aParams, typeof(Bitstream), this.Context);
        }

        public Bitstream AddBitstream(byte[] data, string name, string extension,string contentType, string description, bool isPrimary, long ownerId)
        {
            return AddBitstream(data, name, extension, contentType, data.Length, description, isPrimary, "", ownerId);
        }
        public Bitstream AddBitstream(byte[] data, string name, string extension, string contentType, long size, string description, bool IsPrimary, string oldRepoPath, long ownerId)
        {
            if (contentType == "URL")
                throw (new Exception("'URL' is not a valid content type when adding a bitstream"));
           
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pRepositoryItemId", _itemId)
                ,new SqlParameter("@pContentType", contentType)
                ,new SqlParameter("@pBitstream", data)
                ,new SqlParameter("@pName", name)
                ,new SqlParameter("@pExt", extension)
                ,new SqlParameter("@pDescription", description)
                ,new SqlParameter("@pSize", size)
                ,new SqlParameter("@pIsPrimaryBitstream", IsPrimary)
                ,new SqlParameter("@pOwnerId", ownerId)
                ,new SqlParameter("@pOldRepoPath", oldRepoPath)  //for the migration only
            };
            return (Bitstream)DbConnector.GetObjectOfType("AddBitstreamToRepositoryItem", aParams, typeof(Bitstream), this.Context);
        }
        public Bitstream[] Bitstreams
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pBundleId", m_nId)
                };
                return (Bitstream[])DbConnector.GetObjectsOfType("GetBitstreamsForBundle", aParams,typeof(Bitstream),this.Context);

            }
        }
    }
}
