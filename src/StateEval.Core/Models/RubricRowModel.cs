namespace StateEval.Core.Models
{
    public class RubricRowModel
    {
        public long Id { get; set; }
        public string ShortName { get; set; }
        public string FrameworkNodeShortName { get; set; }
        public string Title { get; set; }
        public string PL1Descriptor { get; set; }
        public string PL2Descriptor { get; set; }
        public string PL3Descriptor { get; set; }
        public string PL4Descriptor { get; set; }
        public bool? IsStudentGrowthAligned { get; set; }
        public bool HasFocus { get; set; }
        public short Sequence { get; set; }
        public string Description { get; set; }
    }
}