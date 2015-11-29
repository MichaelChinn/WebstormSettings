using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace StateEval
{
    public class Utils
    {

      
        public static string CreateSessionKeyFromInt(int  key, SESchoolYear schoolYear)
        {
            return (Convert.ToInt32(schoolYear) - 1).ToString() + "-" + Convert.ToInt32(schoolYear).ToString() + "." + key.ToString();
        }
    }
}
