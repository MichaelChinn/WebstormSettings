select 
'alter table dbo.' + table_name 
+ ' alter column ' + column_name + ' varchar(max) '
+ case when is_nullable='no' then 'NOT' else '' end
+ ' NULL'
from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE='text'


select 'update dbo.' + table_name + ' set ' + column_name + '=' + column_Name
from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE='text'


alter table SEFinalScore alter column EvaluateeNotes varchar(max)  NULL
update SEFinalScore set EvaluatorNotes=EvaluatorNotes
