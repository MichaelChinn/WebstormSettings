
  
  DROP TABLE #Data
SELECT * FROM #Data

CREATE TABLE #Data(
	District VARCHAR(200),
	FrameworkType VARCHAR(200), 
	Framework VARCHAR(200), 
	FrameworkID BIGINT,
	PL1 VARCHAR(20) NULL, 
	PL2 VARCHAR(20) NULL, 
	PL3 VARCHAR(20) NULL, 
	PL4 VARCHAR(20)NULL
	)
INSERT INTO #Data(District, Framework, FrameworkType, FrameworkID)
SELECT ds.districtSchoolName, f.Name, ft.Name, f.FrameworkID
  FROM dbo.SEFramework f
  JOIN dbo.SeFrameworkType ft ON f.FrameworkTypeID=ft.FrameworkTypeID
  JOIN dbo.SEDistrictSchool ds ON f.DistrictCode=ds.DistrictCode WHERE ds.isSchool=0

 UPDATE #Data
    SET PL1=fpl.ShortName
    FROM dbo.SEFrameworkPerformanceLevel fpl 
    WHERE fpl.FrameworkID=#Data.FrameworkID
      AND fpl.PerformanceLevelID=1

   UPDATE #Data
    SET PL2=fpl.ShortName
    FROM dbo.SEFrameworkPerformanceLevel fpl 
    WHERE fpl.FrameworkID=#Data.FrameworkID
      AND fpl.PerformanceLevelID=2
      
       UPDATE #Data
    SET PL3=fpl.ShortName
    FROM dbo.SEFrameworkPerformanceLevel fpl 
    WHERE fpl.FrameworkID=#Data.FrameworkID
      AND fpl.PerformanceLevelID=3
      
       UPDATE #Data
    SET PL4=fpl.ShortName
    FROM dbo.SEFrameworkPerformanceLevel fpl 
    WHERE fpl.FrameworkID=#Data.FrameworkID
      AND fpl.PerformanceLevelID=4
      
