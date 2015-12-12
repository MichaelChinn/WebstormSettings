DELETE dbo.SESchoolYearDistrictConfig WHERE SchoolYearDistrictConfigID=353

DELETE SEUserPrompt 
  where DistrictCode='32363' 
    and SchoolYear=2014
    and EvaluationTypeID=1
    
EXEC dbo.FlushFramework @pDistrictCode = '32363', -- varchar(10)
    @pEvalType = '1', -- varchar(20)
    @pSchoolYear = 2014, -- int
    @pDebug = 0 -- smallint

SELECT * FROM dbo.SESchoolYearDistrictConfig WHERE districtcode = '32363'
