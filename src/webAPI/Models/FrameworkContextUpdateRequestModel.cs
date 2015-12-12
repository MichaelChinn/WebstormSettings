using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StateEval.Core.Constants;

namespace webAPI.Models
{
    public class FrameworkContextUpdateRequestModel
    {
        public long FrameworkContextId { get; set; }
        public SEFrameworkViewTypeEnum FrameworkViewType { get; set; }
        public bool IsActive { get; set; }
    }
}