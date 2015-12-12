using System;
using System.Web.UI.WebControls;
using System.Web;

namespace DbUtils
{
	/// <summary>
	/// Summary description for UiUtils.
	/// </summary>
	public class DbUiUtils
	{
		public DbUiUtils()
		{
		}

		public static bool QueryStringValueExists(string sKey)
		{
			string sVal = HttpContext.Current.Request.QueryString[sKey];
			if (sVal!=null&&sVal!="-1"&&sVal!="")
				return true;
			return false;
		}

		static public bool SelectDropDownItemIfExists(DropDownList list, string sValue)
		{
			ListItem oItem = list.Items.FindByValue(sValue);
			if (oItem!=null)
			{
				oItem.Selected=true;
				return true;
			}
			return false;
		}

		static public DbObject SelectDropDownObjectFromQueryString(DropDownList list, DbObject[] objects, string sKey)
		{
			DbObject oSelectedObject=null;

			if (DbUiUtils.QueryStringValueExists(sKey))
			{
				long nId = Convert.ToInt64(HttpContext.Current.Request.QueryString[sKey]);
				foreach (DbObject obj in objects)
				{
					if (obj.Id==nId)
					{
						oSelectedObject=obj;
						SelectDropDownItemIfExists(list, nId.ToString());
						return oSelectedObject;
					}
				}
			}
			else if (objects.Length>0)
			{
				oSelectedObject=objects[0];
				ListItem oSelectedItem = list.Items[0];
				if (oSelectedItem!=null)
					oSelectedItem.Selected=true;
			}
			return oSelectedObject;
		}

		static public DbObject SelectDropDownObjectFromQueryString(DropDownList list, DbObject[] objects, ListItem oDefaultListItem,  string sKey)
		{
			DbObject oSelectedObject=null;

			if (DbUiUtils.QueryStringValueExists(sKey))
			{
				string sValue = HttpContext.Current.Request.QueryString[sKey];
				if (sValue==oDefaultListItem.Value)
				{
					SelectDropDownItemIfExists(list, sValue);
				}
				else
				{
					long nId = Convert.ToInt64(sValue);
					foreach (DbObject obj in objects)
					{
						if (obj.Id==nId)
						{
							oSelectedObject=obj;
							SelectDropDownItemIfExists(list, sValue);
							return oSelectedObject;
						}
					}
				}
			}
			else if (list.Items.Count>0)
			{
				// select default item
				list.Items[0].Selected=true;
			}
			return oSelectedObject;
		}

		static public void PopulateDropDown(DropDownList list, DbObject[] objects)
		{
			ListItem oItem;
			for (int i=0; i<objects.Length; ++i)
			{
				oItem = new ListItem(objects[i].ToString(), Convert.ToString(objects[i].Id));
				list.Items.Add(oItem);
			}
		}

		static public void PopulateDropDown(DropDownList list, DbObject[] objects, ListItem oDefaultListItem)
		{
			list.Items.Add(oDefaultListItem);
			ListItem oItem;
			for (int i=0; i<objects.Length; ++i)
			{
				oItem = new ListItem(objects[i].ToString(), Convert.ToString(objects[i].Id));
				list.Items.Add(oItem);
			}
		}

		static public object InitializeDropDown(bool bIsPostBack, DropDownList list, DbObject[] objects, string sQueryStringKey)
		{
			if (!bIsPostBack)
			{
				PopulateDropDown(list, objects);
			}
			return SelectDropDownObjectFromQueryString(list, objects, sQueryStringKey);
		}

		static public object InitializeDropDown(bool bIsPostBack, DropDownList list, DbObject[] objects, ListItem oDefaultListItem, string sQueryStringKey)
		{
			if (!bIsPostBack)
			{
				PopulateDropDown(list, objects, oDefaultListItem);
			}
			return SelectDropDownObjectFromQueryString(list, objects, oDefaultListItem, sQueryStringKey);
		}

	}
}
