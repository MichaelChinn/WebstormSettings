using System.Collections.Generic;

namespace StateEval.Core.Models
{
    public class FrameworkNodeModel
    {
        public long Id { get; set; }
        public string ShortName { get; set; }
        public string Title { get; set; }
        public short Sequence { get; set; }
        public IEnumerable<RubricRowModel> RubricRows { get; set; }
    }
}