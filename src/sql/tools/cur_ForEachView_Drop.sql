
DECLARE cur_ForEachView CURSOR
READ_ONLY
FOR 
SELECT Name
  FROM dbo.sysobjects
 WHERE OBJECTPROPERTY(id, N'IsView') = 1        -- it is a view.
   AND OBJECTPROPERTY(id, N'IsMSShipped') = 0   -- it is not a system supplied procedure.
   AND [Name] NOT LIKE '%aspnet_%'

DECLARE @name      SYSNAME
DECLARE @SQL_Text  NVARCHAR(4000)

OPEN cur_ForEachView

FETCH NEXT FROM cur_ForEachView INTO @name
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN

      SELECT @SQL_Text = 'DROP VIEW [' + @Name + ']'
      EXEC(@SQL_Text)

	END
	FETCH NEXT FROM cur_ForEachView INTO @name
END

CLOSE cur_ForEachView
DEALLOCATE cur_ForEachView
GO
