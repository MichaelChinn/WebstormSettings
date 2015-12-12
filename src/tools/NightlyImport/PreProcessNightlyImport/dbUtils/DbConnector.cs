using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Threading;

namespace DbUtils
{
	/// <summary>
	/// Interface that all objects within the object model support if they
	/// map to tables in the database.  The interface is used for dynamically creating
	/// and loading objects from database queries.
	/// </summary>
	public interface IDbObject
	{
		/// <summary>
		/// Called when dynamically creating objects from database queries. Loads the object
		/// state from the database reader.
		/// </summary>
		/// <param name="oReader">The database reader containing all of the object state to be loaded into the object.</param>
		/// <param name="o">An arbitrary object used to supply context</param>
		void Load(IDataReader oReader, object o);
		long Id { get; }
	};

	/// <summary>
	/// The DbConnector class encapsulates all of the database connection and execution
	/// functionality within the library.
	/// </summary>
	[Serializable]
	public class DbConnector : IDisposable
	{
		/// <summary>
		/// The databae connection string.
		/// </summary>
		private string m_sConnectionString;
		/// <summary>
		/// The database connection.
		/// </summary>
		private SqlConnection m_oConnection;
		/// <summary>
		///  The database command.
		/// </summary>
		private SqlCommand m_oCommand;

		/// <summary>
		/// Creates a DbConnector object and opens a database connection.
		/// </summary>
		/// <param name="sConnectionString">The database connection string.</param>
		public DbConnector(string sConnectionString)
		{
			m_sConnectionString = sConnectionString;
			m_oConnection = new SqlConnection(m_sConnectionString);
			m_oConnection.Open();
		}

		public void Close()
		{		
			if (m_oConnection != null) 
			{
				m_oConnection.Dispose();
				m_oConnection=null;
			}
		}		
	
		public void Dispose()
		{
			Dispose(true);
		
			GC.SuppressFinalize(this);
		}

		protected virtual void Dispose(bool disposing)
		{
			if (disposing) 
			{
				Close();
			}
		}


        public SqlTransaction  BeginTxn()
        {
            return m_oConnection.BeginTransaction();
        }

		/// <summary>
		/// Called by public methods that execute database queries to add
		/// supplied parameters to command before executing.
		/// </summary>
		/// <param name="aParams">An array of parameters to pass to the stored procedure.</param>
		private void AddParameters(SqlParameter[] aParams)
		{
			for (int i=0; i<aParams.Length; ++i)
			{
				m_oCommand.Parameters.Add(aParams[i]);
			}
		}

        private void AddParameters(List<SqlParameter> aParams)
        {
            for (int i = 0; i < aParams.Count; ++i)
            {
                m_oCommand.Parameters.Add(aParams[i]);
            }
        }

		public SqlParameter CreateParameter(string sParameterName, System.Data.SqlDbType SpType, int iparmLength, object oValue, bool IsSpOutput)
		{
			SqlParameter Parameter = new SqlParameter(sParameterName, SpType, iparmLength);
			if (IsSpOutput) 
			{
				Parameter.Direction = ParameterDirection.Output;
			} 
			else 
			{
				if (oValue == null) 
				{
					Parameter.Value = DBNull.Value;
				} 
				else
				{
					Parameter.Value = oValue;
				}
			}	
		
			return Parameter;
		 }

		
		/// <summary>
		/// Creates a database command object. Called by public methods that execute database
		/// queries to create a new command before executing.
		/// </summary>
		/// <param name="sStoredProcName">Name of the stored procedure to execute</param>
		private void CreateCommand(string sStoredProcName)
		{
			m_oCommand = new SqlCommand(sStoredProcName, m_oConnection);
			m_oCommand.CommandType = CommandType.StoredProcedure;
			m_oCommand.CommandTimeout = 1000;
		}	
		private void CreateNonSpCommand(string sSqlQueryString)
		{
			m_oCommand = new SqlCommand(sSqlQueryString, m_oConnection);
			m_oCommand.CommandTimeout = 1000;
		}	

		/// <summary>
		/// Executes a stored procedure that does not return an resultset. This is the internal
		/// method that will be called from public methods that set up the command and
		/// parameters.
		/// </summary>
		/// <returns>The number of records affected by the query.</returns>
        private int ExecuteNonQuery()
        {
            int result = -1;

            try
            {
                int tries = 15;
                while (tries > 0)
                {
                    try
                    {
                        result = m_oCommand.ExecuteNonQuery();
                        tries = 0;
                    }
                    catch (SqlException sqlException)
                    {
                        if (sqlException.Number == 1205) // deadlock
                        {
                            if (tries == 1)             //if exhausted tries, re throw
                                throw new Exception("deadlock retry failed ten times... " + sqlException.Message);

                            // Delay processing to allow retry. 
                            Random r = new Random();
                            int sleepTime = r.Next(100, 400);
                            Thread.Sleep(sleepTime);

                            if (m_oConnection.State == ConnectionState.Closed)
                            {
                                m_oConnection.Open();
                            }
                            tries--;

                        }
                        // exception is not a deadlock
                        else
                        {
                            throw;
                        }
                    }
                }
            }

            catch (Exception e)
            {
#if (DEBUG)
                throw new DbException("Method ExecuteNonQuery failed: stored procedure " + m_oCommand.CommandText, e);
#else
                throw e;
#endif
            }
            finally
            {
                Close();
            }

            return result;
        }

		/// <summary>
		/// Executes a stored procedure that does not return an resultset.
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <returns>The number of records affected by the query.</returns>
		public int ExecuteNonQuery(string sStoredProcName, SqlParameter[] aParams)
		{
			CreateCommand(sStoredProcName);
			AddParameters(aParams);
			return ExecuteNonQuery();
		}

        public int ExecuteNonQuery(string sStoredProcName, List<SqlParameter> aParams)
        {
            CreateCommand(sStoredProcName);
            AddParameters(aParams);
            return ExecuteNonQuery();
        }

		public int ExecuteNonSpNonQuery(string sQueryString)
		{
			CreateNonSpCommand(sQueryString);
			return ExecuteNonQuery();
		}

		/// <summary>
		/// Executes a stored procedure that does not return an resultset.
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <returns>The number of records affected by the query.</returns>
		public int ExecuteNonQuery(string sStoredProcName)
		{
			CreateCommand(sStoredProcName);
			return ExecuteNonQuery();
		}

		/// <summary>
		/// Executes a stored procedure that returns a single, scalar value. This is the internal
		/// method that will be called from public methods that set up the command and
		/// parameters.
		/// </summary>
		/// <returns>The scalar value (must be cast to appropriate type).</returns>
		private object ExecuteScalar()
		{
			object oResult = null;
			
			try
			{	
				oResult = m_oCommand.ExecuteScalar();	
			}
			catch (Exception e)
			{	
#if (DEBUG)
				throw new DbException("Method ExecuteScalar failed: stored procedure " + m_oCommand.CommandText, e);
#else
				throw  e;
#endif		
			}
			finally
			{
				Close();
			}
			
			return oResult;		
		}

		/// <summary>
		/// Executes a stored procedure that returns a single, scalar value.
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <returns>The scalar value (must be cast to appropriate type).</returns>
		public object ExecuteScalar(string sStoredProcName, SqlParameter[] aParams)
		{
			CreateCommand(sStoredProcName);
			AddParameters(aParams);
			return ExecuteScalar();
		}

        public object ExecuteScalar(string sStoredProcName, List<SqlParameter> aParams)
        {
            CreateCommand(sStoredProcName);
            AddParameters(aParams);
            return ExecuteScalar();
        }


		/// <summary>
		/// Executes a stored procedure that returns a single, scalar value.
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <returns>The scalar value (must be cast to appropriate type).</returns>
		public object ExecuteScalar(string sStoredProcName)
		{
			CreateCommand(sStoredProcName);
			return ExecuteScalar();
		}

		/// <summary>
		/// Executes a stored procedure that returns a datareader. This is the internal
		/// method that will be called from public methods that set up the command and
		/// parameters.
		/// </summary>
		/// <returns>The datareader.</returns>
		private SqlDataReader ExecuteDataReader()
		{ 
            SqlDataReader reader = null;
            
            try
            {
                int tries = 15;           
                while (tries > 0)
                {
                    try
                    {
                        reader = m_oCommand.ExecuteReader(CommandBehavior.CloseConnection);
                        tries = 0;
                    }
                    catch (SqlException sqlException)
                    {
                        // It looks like it isn't always an SqlException at the top level. At least in eVAL 
                        // it is an ApplicationException that is returned.
                        // So for now we are checking for the deadlocked text.
                        //if (sqlException.Number==1205)
                        if (sqlException.Message.ToLower().Contains(") was deadlocked on lock"))
                        {   
                            if (tries == 1)             //if exhausted tries, re throw
                                throw new Exception("deadlock retry failed ten times... " + sqlException.Message);

                            // Delay processing to allow retry. 
                            Random r = new Random();
                            int sleepTime = r.Next(100, 400);
                            Thread.Sleep(sleepTime);

                            if (m_oConnection.State == ConnectionState.Closed)
                            {
                                m_oConnection.Open();
                            }
                            tries--;
                            
                        }
                        // exception is not a deadlock
                        else
                        {
                            throw;
                        }
                    }
                }
            }

            catch (Exception e)
            {
#if (DEBUG)
                throw new DbException("Method ExecuteDataReader failed: stored procedure " + m_oCommand.CommandText, e);
#else
				throw  e;
#endif
            }
            return reader;
		}

		/// <summary>
		/// Executes a stored procedure that returns a datareader.
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <returns></returns>
		public SqlDataReader ExecuteDataReader(string sStoredProcName)
		{
			CreateCommand(sStoredProcName);
			return ExecuteDataReader();
		}
		public SqlDataReader ExecuteNonSpDataReader(string sSqlQueryString)
		{
			CreateNonSpCommand(sSqlQueryString);
			return ExecuteDataReader();
		}
		public object ExecuteNonSpScalar(string sSqlQueryString)
		{
			CreateNonSpCommand(sSqlQueryString);
			return ExecuteScalar();
		}
		/// <summary>
		/// Executes a stored procedure that returns a datareader.
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <returns>The datareader.</returns>
		public SqlDataReader ExecuteDataReader(string sStoredProcName, SqlParameter[] aParams)
		{
			CreateCommand(sStoredProcName);
			if (aParams!=null)
				AddParameters(aParams);
			return ExecuteDataReader();
		}
        public SqlDataReader ExecuteDataReader(string sStoredProcName, List<SqlParameter> aParams)
        {
            CreateCommand(sStoredProcName);
            if (aParams != null)
                AddParameters(aParams);
            return ExecuteDataReader();
        }

        public DataTable GetDataTable(string procName, SqlParameter[] aParams)
        {
            try
            {
                CreateCommand(procName);
                AddParameters(aParams);
                SqlDataAdapter adapter = new SqlDataAdapter(m_oCommand);
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table;
            }
            finally
            {
                Close();
            }
        }
        public DataTable GetDataTable(string procName, List<SqlParameter> aParams)
        {
            try
            {
                CreateCommand(procName);
                AddParameters(aParams);
                SqlDataAdapter adapter = new SqlDataAdapter(m_oCommand);
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table;
            }
            finally
            {
                Close();
            }
        }


		public DataSet GetDataSet(string sStoredProcName, SqlParameter[] aParams, string sDataSetName)
		{
            try
            {
                SqlDataAdapter oAdapter = new SqlDataAdapter();
                DataSet oDataSet = new DataSet(sDataSetName);
                CreateCommand(sStoredProcName);
                AddParameters(aParams);
                oAdapter.SelectCommand = m_oCommand;
                oAdapter.Fill(oDataSet);
                return oDataSet;
            }
            finally
            {
                Close();
            }
		}
        public DataTable GetZerothDataTable(string sStoredProcName, SqlParameter[] aParams)
        {
            DataSet ds = GetDataSet(sStoredProcName, aParams, "SomeRandomDataSetName");
            return ds.Tables[0];
        }
		public DataTable RefreshDataTable(DataSet oDataSet, string sStoredProcName, SqlParameter[] aParams, string sTableName)
		{
			SqlDataAdapter oAdapter = new SqlDataAdapter();
			CreateCommand(sStoredProcName);
			AddParameters(aParams);
			oAdapter.SelectCommand = m_oCommand;
			DataTable dt = oDataSet.Tables[sTableName];
			dt.Clear();
			oAdapter.Fill(dt);
			return dt;    
		}

		public DataSet GetNestedDataSet(string sStoredProcName, 
				SqlParameter[] aParams, 
				string sParentTableName, 
				string sChildTableTable,
				string sParentFieldName,
				string sChildFieldName)
		{
			SqlDataAdapter oAdapter = new SqlDataAdapter();
			DataSet oDataSet = new DataSet();
			CreateCommand(sStoredProcName);		//This binds the connection
			AddParameters(aParams);				//Add the parameters to the SP
			oAdapter.SelectCommand = m_oCommand;

			//Set up the name of the child table name
			oAdapter.TableMappings.Add(sParentTableName + "1", sChildTableTable);

			oAdapter.Fill(oDataSet, sParentTableName);

			//Set up the relations
			oDataSet.Relations.Add("Parent_Child", 
				oDataSet.Tables[sParentTableName].Columns[sParentFieldName], 
				oDataSet.Tables[sChildTableTable].Columns[sChildFieldName]);
			oDataSet.Relations[0].Nested = true;

			return oDataSet;    
		}

		/// <summary>
		/// Creates an object from the data contained in the datareader.  The object is instantiated
		/// based on its type and then the Load method is called so that it can populate itself
		/// from the datareader.
		/// </summary>
		/// <param name="reader">The datareader.</param>
		/// <param name="objType">The type of the object to create.</param>
		/// <param name="o">An arbitrary object used to supply context</param>
		/// <returns>Returns the new object.</returns>
		public IDbObject CreateFromReader(IDataReader reader, Type objType, object o)
		{
			IDbObject oDbObject = (IDbObject)Activator.CreateInstance(objType, true);
			oDbObject.Load(reader, o);
			return oDbObject;
		}

		/// <summary>
		/// Creates an object from the data contained in the datareader.  The object is instantiated
		/// based on its type and then the Load method is called so that it can populate itself
		/// from the datareader.
		/// </summary>
		/// <param name="reader">The datareader.</param>
		/// <param name="objToLoad">This is the object that contains all of the data.</param>
		/// <param name="objectContext">An arbitrary object used to supply context</param>
		/// <returns>Returns the updated object.</returns>
		public IDbObject UpdateFromReader(IDataReader reader, IDbObject objectToLoad, object objectContext)
		{
			objectToLoad.Load(reader, objectContext);
			return objectToLoad;
		}








		/// <summary>
		/// Creates an array of objects that represent a set of related objects in the database. 
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <param name="objectType">The type of the object to create.</param>
		/// <returns>An array of object (must be cast to the appropriate type).</returns>
		public object[] GetObjectsOfType(string sStoredProcName, SqlParameter[] aParams, Type objectType)
		{
			return GetObjectsOfType(sStoredProcName, aParams, objectType, null);
		}

		/// <summary>
		/// Creates an array of objects that represent a set of related objects in the database. 
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <param name="objectType">The type of the object to create.</param>
		/// <returns>An array of object (must be cast to the appropriate type).</returns>
		/// <param name="o">An arbitrary object used to supply context</param>
		public object[] GetObjectsOfType(string sStoredProcName, SqlParameter[] aParams, Type objectType, object o)
		{
			IDataReader oReader = null;
			try
			{
				oReader = ExecuteDataReader(sStoredProcName, aParams);
				// Since we can't determine the number of records that are coming in a datareader
				// we have to first store them in an ArrayList and then create a fixed-size
				// array.
				ArrayList tempArray = new ArrayList();
				while (oReader.Read())
				{
					tempArray.Add(CreateFromReader(oReader, objectType, o));
				}
				// Create a fixed-length array of objects of the specified type.
				object[] objects = (object[])Array.CreateInstance(objectType, tempArray.Count);
				// Transfer them into the fixed-size array.
				for (int i=0; i<tempArray.Count; ++i)
				{
					objects[i] = tempArray[i];
				}
				return objects;
			}
			catch (Exception e)
			{
#if (DEBUG)
				throw new DbException("Method GetObjectOfType failed: ", e);
#else
				throw  e;
#endif			
			}
			finally
			{
				if (oReader!=null)
				{
					oReader.Dispose();
					this.Close();
				}
			}
		}

        /// <summary>
        /// Creates a (non-generic) list of objects that represent a set of related objects in the database. 
        /// </summary>
        /// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
        /// <param name="aParams">An array of parameters to pass to stored procedure.</param>
        /// <param name="objectType">The type of the object to create.</param>
        /// <returns>A list of objects (must be cast to the appropriate type).</returns>
        public IList GetListOfType(string sStoredProcName, SqlParameter[] aParams, Type objectType)
        {
            return GetListOfType(sStoredProcName, aParams, objectType, null);
        }
        
        /// <summary>
        /// Creates a (non-generic) list of objects that represent a set of related objects in the database. 
        /// </summary>
        /// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
        /// <param name="aParams">An array of parameters to pass to stored procedure.</param>
        /// <param name="objectType">The type of the object to create.</param>
        /// <returns>A list of objects (must be cast to the appropriate type).</returns>
        public IList GetListOfType(string sStoredProcName, SqlParameter[] aParams, Type objectType, object o)
        {
            string typeName = string.Format("System.Collections.Generic.List`1[[{0}]], mscorlib", objectType.AssemblyQualifiedName);
            IList list = Activator.CreateInstance(Type.GetType(typeName)) as IList;


            IDataReader oReader = null;
            try
            {
                oReader = ExecuteDataReader(sStoredProcName, aParams);
                // Since we can't determine the number of records that are coming in a datareader
                // we have to first store them in an ArrayList and then create a fixed-size
                // array.

                while (oReader.Read())
                {
                    list.Add(CreateFromReader(oReader, objectType, o));
                }

                return list;
            }
            catch (Exception e)
            {
#if (DEBUG)
                throw new DbException("Method GetListOfType failed: ", e);
#else
				throw  e;
#endif
            }
            finally
            {
                if (oReader != null)
                {
                    oReader.Dispose();
                    this.Close();
                }
            }
        }


        public IList GetListOfType(string sStoredProcName, List<SqlParameter>aParams, Type objectType, object o)
        {
            string typeName = string.Format("System.Collections.Generic.List`1[[{0}]], mscorlib", objectType.AssemblyQualifiedName);
            IList list = Activator.CreateInstance(Type.GetType(typeName)) as IList;


            IDataReader oReader = null;
            try
            {
                oReader = ExecuteDataReader(sStoredProcName, aParams);
                
                while (oReader.Read())
                {
                    list.Add(CreateFromReader(oReader, objectType, o));
                }

                return list;
            }
            catch (Exception e)
            {
#if (DEBUG)
                throw new DbException("Method GetListOfType failed: ", e);
#else
				throw  e;
#endif
            }
            finally
            {
                if (oReader != null)
                {
                    oReader.Dispose();
                    this.Close();
                }
            }
        }


		/// <summary>
		/// Creates an object that represent an object in the database. 
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <param name="objectType">The type of the object to create.</param>
		/// <returns>An object (must be cast to the appropriate type).</returns>
		public object GetObjectOfType(string sStoredProcName, SqlParameter[] aParams, Type objectType)
		{
			return GetObjectOfType(sStoredProcName, aParams, objectType, null);
		}

		/// <summary>
		/// Creates an object that represent an object in the database. 
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <param name="objectType">The type of the object to create.</param>
		/// <returns>An object (must be cast to the appropriate type).</returns>
		/// <param name="o">An arbitrary object used to supply context</param>
		public object GetObjectOfType(string sStoredProcName, SqlParameter[] aParams, Type objectType, object o)
		{
			IDataReader oReader = null;
			try
			{
				oReader = ExecuteDataReader(sStoredProcName, aParams);
				if (!oReader.Read())
					return null;

				return CreateFromReader(oReader, objectType, o);
			}
			catch (Exception e)
			{
#if (DEBUG)
				throw new DbException("Method GetObjectsOfType failed", e);
#else
				throw  e;
#endif
			}
			finally
			{
				if (oReader!=null)
				{
					oReader.Dispose();
					this.Close();
				}
			}
		}

		/// <summary>
		/// Updates an object from the database, based upon
		/// </summary>
		/// <param name="sStoredProcName">The name of the stored procedure to execute.</param>
		/// <param name="aParams">An array of parameters to pass to stored procedure.</param>
		/// <param name="objectType">The type of the object to update.</param>
		/// <returns>null.</returns>
		/// <param name="o">Object needing update</param>
		public object UpdateObject(string sStoredProcName, SqlParameter[] aParams, IDbObject objectToUpdate, object objectContext)
		{
			IDataReader oReader = null;
			try
			{
				oReader = ExecuteDataReader(sStoredProcName, aParams);
				oReader.Read();
				if (oReader.FieldCount==0)
					return null;

				return UpdateFromReader(oReader, objectToUpdate, objectContext);
			}
			catch (Exception e)
			{
#if (DEBUG)
				throw new DbException("Method GetObjectsOfType failed", e);
#else
				throw  e;
#endif
			}
			finally
			{
				if (oReader!=null)
				{
					oReader.Dispose();
					this.Close();
				}
			}
		}

		// The key used for generating the encrypted string
		private const string cryptoKey = "PLSSLP";

		// The Initialization Vector for the DES encryption routine
		static private readonly byte[] IV = new byte[8] {240, 3, 45, 29, 0, 76, 173, 59};

		static public string DecryptConnectionString(string connectionString)
		{
			string[] tokens = connectionString.Split(new char[]{';'});
			StringBuilder retVal = new StringBuilder();
			
			for(int i=0;i<tokens.Length;i++)
			{
				string t = tokens[i];
				if(t=="")
					continue;
				if(t.ToLower().IndexOf("pwd")==0)
				{
					string[]pieces = t.Split(new char[]{'='});
					string cipherText = pieces[1];
					if (cipherText == "")
						continue;

					byte[] buffer = Convert.FromBase64String(cipherText);
					TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider();
					MD5CryptoServiceProvider MD5 = new MD5CryptoServiceProvider();
					des.Key = MD5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(cryptoKey));
					des.IV = IV;
					string clearText = Encoding.ASCII.GetString(
						des.CreateDecryptor().TransformFinalBlock(
						buffer,
						0,
						buffer.Length
						)
						);

					t = pieces[0] + "=" + clearText;
				}
				retVal.Append(t + ";");				

			}
			return retVal.ToString();
		}
	}
}
