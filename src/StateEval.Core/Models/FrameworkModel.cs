using System.Collections.Generic;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class FrameworkModel
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public IEnumerable<FrameworkNodeModel> FrameworkNodes { get; set; }
    }
}