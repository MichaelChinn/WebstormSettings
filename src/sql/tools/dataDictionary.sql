select a.name [Table],b.name [Attribute],c.name [DataType],b.isnullable [Allow Nulls?],CASE WHEN 
d.name is null THEN 0 ELSE 1 END [PKey?],
CASE WHEN e.parent_object_id is null THEN 0 ELSE 1 END [FKey?],CASE WHEN e.parent_object_id 
is null THEN '-' ELSE g.name  END [Ref Table],
CASE WHEN h.value is null THEN '-' ELSE h.value END [Description]
from sysobjects as a
join syscolumns as b on a.id = b.id
join systypes as c on b.xtype = c.xtype 
left join (SELECT  so.id,sc.colid,sc.name 
      FROM    syscolumns sc
      JOIN sysobjects so ON so.id = sc.id
      JOIN sysindexkeys si ON so.id = si.id 
                    and sc.colid = si.colid
      WHERE si.indid = 1) d on a.id = d.id and b.colid = d.colid
left join sys.foreign_key_columns as e on a.id = e.parent_object_id and b.colid = e.parent_column_id    
left join sys.objects as g on e.referenced_object_id = g.object_id  
left join sys.extended_properties as h on a.id = h.major_id and b.colid = h.minor_id
where a.type = 'U' 
  AND a.name != 'UpdateLog'
  AND a.name NOT LIKE '%aspnet%'
  AND a.name != 'AppRole'
  AND a.name != 'DebugTrace'
  AND a.Name !='EDSError'
  AND a.Name !='eDsroles'
  AND a.Name !='EDSStaging'
  AND a.Name !='eDsUsers'
  AND a.Name !='ELMAH_Error'
  AND a.Name !='EvaluationMap'
  AND a.Name !='LocationRoleClaim'
order by a.name

SELECT * FROM emaildeliverytype
SELECT * FROM messagetype
SELECT * FROM seanchortype
SELECT * FROM seartifacttype
SELECT * FROM dbo.SEEvalAssignmentRequestStatusType
SELECT * FROM dbo.SEEvalAssignmentRequestType
SELECT * FROM dbo.SEEvalSessionLockState
SELECT * FROM dbo.SEEvaluateePlanType
SELECT * FROM dbo.SEEvaluationRoleType
SELECT * FROM dbo.SEEvaluationScoreType
SELECT * FROM dbo.SEEvaluationType
SELECT * FROM dbo.SEFrameworkType
SELECT * FROM dbo.SEFrameworkViewType
SELECT * FROM dbo.SEReportPrintOptionType
SELECT * FROM dbo.SEReportType
SELECT * FROM dbo.SEResourceType
SELECT * FROM dbo.SEFrameworkPerformanceLevel
