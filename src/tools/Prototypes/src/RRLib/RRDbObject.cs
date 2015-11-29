using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DbUtils;

namespace RRLib
{
    public  class RRDbObject: DbObject
    {
        public RRDbObject()
		{
		}

        public RRMgr RRMgr
		{
            get { return ((RRMgr)m_oContext); }
		}

		public DbConnector DbConnector
		{
			get
			{
                return RRMgr.DbConnector;
			}
		}
    }
}
