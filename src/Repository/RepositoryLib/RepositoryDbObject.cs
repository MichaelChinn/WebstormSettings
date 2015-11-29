using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections;

using DbUtils;


namespace RepositoryLib
{

	/// <summary>
	/// Summary description for RepositoryDbObject.
	/// </summary>
	public class RepositoryDbObject : DbObject
	{
		public RepositoryDbObject()
		{
		}

		public RepositoryMgr RepositoryMgr
		{
			get { return ((RepositoryMgr)m_oContext); }
		}

		public DbConnector DbConnector
		{
			get
			{
				return RepositoryMgr.DbConnector;
			}
		}
	}
}
