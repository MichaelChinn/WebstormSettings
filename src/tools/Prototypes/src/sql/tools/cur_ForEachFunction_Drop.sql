
DECLARE cur_ForEachFunction CURSOR
READ_ONLY
FOR 
SELECT Name
  FROM dbo.sysobjects
 WHERE (OBJECTPROPERTY(id, N'IsTableFunction') = 1   OR OBJECTPROPERTY(id, N'IsScalarFunction') = 1)
   AND OBJECTPROPERTY(id, N'IsMSShipped') = 0   -- it is not a system supplied procedure.
   AND [Name] NOT LIKE '%aspnet_%'

DECLARE @name      SYSNAME
DECLARE @SQL_Text  NVARCHAR(4000)

OPEN cur_ForEachFunction

FETCH NEXT FROM cur_ForEachFunction INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN

      SELECT @SQL_Text = 'DROP FUNCTION [' + @Name + ']'
      EXEC(@SQL_Text)

	END
	FETCH NEXT FROM cur_ForEachFunction INTO @name
END

CLOSE cur_ForEachFunction
DEALLOCATE cur_ForEachFunction
GO
