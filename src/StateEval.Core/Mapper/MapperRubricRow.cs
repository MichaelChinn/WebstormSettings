using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SERubricRow MaptoSERubricRow(
            this RubricRowModel source, SERubricRow target = null)
        {
            target = target ?? new SERubricRow();

            target.RubricRowID = source.Id;
            target.ShortName = source.ShortName;
            target.Title = source.Title;
            target.Description = source.Description;
            target.IsStudentGrowthAligned = source.IsStudentGrowthAligned;
            target.PL1Descriptor = source.PL1Descriptor;
            target.PL2Descriptor = source.PL2Descriptor;
            target.PL3Descriptor = source.PL3Descriptor;
            target.PL4Descriptor = source.PL4Descriptor;

            return target;
        }

        public static RubricRowModel MaptoRubricRowModel(
            this SERubricRow source, short sequence, RubricRowModel target = null)
        {
            target = target ?? new RubricRowModel();

            target.Id = source.RubricRowID;
            target.ShortName = source.ShortName;
            target.Title = source.Title;
            target.Sequence = sequence;
            target.Description = source.Description;
            target.IsStudentGrowthAligned = source.IsStudentGrowthAligned;
            target.PL1Descriptor = source.PL1Descriptor;
            target.PL2Descriptor = source.PL2Descriptor;
            target.PL3Descriptor = source.PL3Descriptor;
            target.PL4Descriptor = source.PL4Descriptor;

            return target;
        }
    }
}