using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
 
using DbUtils;

namespace RepositoryLib
{
    public class Bitstream : RepositoryDbObject, IDbObject
    {
        //long _bitstreamFormatId;
        long _bundleId;
        string _name;
        string _extension;
        string _description;
        long _size;
        DateTime _initialUpload;
        DateTime _lastUpload;
        long _repositoryItemId;
        string _contentType;
        long _ownerId;
        string _url;
        bool _isPrimary;

        public Bitstream() { }
        public Bitstream(
            long bundleId
            , string name
            , string ext
            , string description
            , string url
            , long size
            , DateTime initialUpload
            , DateTime lastUpload
            , long OwnerId
            , string ContentType
            , bool isPrimary
            )
        {   //this constructor for testing purposes only
            _bundleId = bundleId;
            _name = name;
            _extension = ext;
            _description = description;
            _size = size;
            _initialUpload = initialUpload;
            _lastUpload = lastUpload;
            _ownerId = OwnerId;
            _url = url;
            _contentType = ContentType;
            _isPrimary = isPrimary;
        }

        void IDbObject.Load(IDataReader reader, object o)
        {
            Init(o);
            m_nId = (long)reader["BitstreamId"];
            _contentType = GetStringProperty(reader, "ContentType", "");
            _url = GetStringProperty(reader, "URL", "");
            _bundleId = GetLongProperty(reader, "bundleId", -1);
            _name = GetStringProperty(reader, "name", "");
            _extension = GetStringProperty(reader, "ext", "");
            _description = GetStringProperty(reader, "description", "");
            _size = GetLongProperty(reader, "size", -1);
            _initialUpload = (DateTime)reader["initialUpload"];
            _lastUpload = (DateTime)reader["lastUpload"];
            _repositoryItemId = GetLongProperty(reader, "repositoryItemId", -1);
            _ownerId = GetLongProperty(reader,"ownerId", -1);
            _isPrimary = GetBooleanProperty(reader, "IsPrimaryBitstream", false);
        }

        public bool IsPrimary{get{return _isPrimary;}}
        public long BundleId {get { return _bundleId; }  }
        public string URL { get { return _url; } }
        public string Name 
        {
            get { return _name; }
            set
            {
                _name = value;
                if (ContentType != "URL")
                {
                    //got to check the name, and reset the extension as well
                    //in the sproc, will set the content type by the passed in extension
                    int i = _name.LastIndexOf('.');

                    if (i < 0)
                        _extension = "";
                    else
                        _extension = _name.Substring(i);
                }  
            }
        }
        public string Extension{get { return _extension; } }
        public string ContentType { get { return _contentType; }}
        public string Description { get { return _description; } }
        public long Size { get { return _size; }}
        public DateTime InitialUpload { get { return _initialUpload; } }
        public DateTime LastUpload { get { return _lastUpload; } }
        public long RepositoryItemId { get { return _repositoryItemId; } }
        public long OwnerId {get{return _ownerId;}}
        public void GetData(out byte[] data)
        {
            SqlParameter[] aParams = new SqlParameter[] 
                {
                    new SqlParameter("@pBitstreamId", m_nId)
                };
            object o = DbConnector.ExecuteScalar("GetBitstreamData", aParams);
            if (o == DBNull.Value)
                data = new byte[] { };
            else
                data = (byte[])o;
        }
        public void UpdateDateTimesForMigration(DateTime lastUpload, DateTime initialUpload)
        {
            /* special method, just for the migration */
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pBitStreamId", m_nId)
	            ,new SqlParameter("@pLastUpload", lastUpload)
	            ,new SqlParameter("@pInitialUpload", initialUpload)        
            };
            DbConnector.ExecuteNonQuery("UpdateBitstreamDateTimes", aParams);
        }
        public void PutData(byte[] data)
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pBitStreamId", m_nId)
	            ,new SqlParameter("@pBitstream", data)
	            ,new SqlParameter("@pSize", data.Length)        
            };
            DbConnector.ExecuteNonQuery("PutBitstreamData", aParams);
        }
        public void SaveMeta()
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pBitStreamId", m_nId)
	            ,new SqlParameter("@pIsPrimary", IsPrimary)
	           // ,new SqlParameter("@pS3Guid", S3Guid)
                ,new SqlParameter("@pURL", URL)
	            ,new SqlParameter("@pName", Name)
                ,new SqlParameter("@pExt", Extension)
	            ,new SqlParameter("@pDescription", Description)
                ,new SqlParameter("@pSize", Size)
                ,new SqlParameter("@pContentType", ContentType)
	            ,new SqlParameter("@pInitialUpload", InitialUpload)
            };
            DbConnector.ExecuteNonQuery("UpdateBitstreamMetaData", aParams);
        }
    }
}