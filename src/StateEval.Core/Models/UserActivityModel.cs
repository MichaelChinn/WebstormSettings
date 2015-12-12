using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public partial class UserActivityModel
    {
        public long Id { get; set; }
        public long UserId { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public string Title { get; set; }
        public string Detail { get; set; }
        public Nullable<System.DateTime> CreateDate { get; set; }
        public Nullable<bool> IsViewed { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public string Url { get; set; }
        public string Param { get; set; }
        public Nullable<long> ObjectId { get; set; }
        public string ObjectType { get; set; }
        public string ActivityData { get; set; }
    }
}