using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using Telerik.Web.UI;
using System.Collections;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;

using RRLib;
using DbUtils;


public class UiUtils
{
    public static SiteSettings SiteSettings
    {
        get
        {
            SiteSettings siteSettings = (SiteSettings)HttpContext.Current.Items["RRSiteSettings"];
            if (siteSettings != null)
            {
                return siteSettings;
            }
            else
            {
                SiteSettings ss = new SiteSettings();
                HttpContext.Current.Items.Add("RRSiteSettings", ss);
                return ss;
            }
        }
    }

    static public TableCell AddCellToRow(TableRow row, string text, string cssClass, int colspan, HorizontalAlign align)
    {
        TableCell c = new TableCell();
        c.CssClass = cssClass;
        c.ColumnSpan = colspan;
        c.HorizontalAlign = align;
        c.VerticalAlign = VerticalAlign.Top;
        c.Text = text;
        row.Cells.Add(c);
        return c;
    }

    static public TableRow AddRowToTable(Table oTable)
    {
        TableRow oRow = new TableRow();
        oTable.Rows.Add(oRow);
        return oRow;
    }
}