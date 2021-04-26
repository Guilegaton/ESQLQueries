CREATE PROCEDURE [dbo].[exec_FindValuesByArray]
	@Dictionary AS XML
AS
BEGIN
	DECLARE @find NVARCHAR(MAX);
	
	SET @find = 'SELECT * FROM Driver';
	DECLARE c CURSOR FOR
	SELECT DISTINCT 
		'ColumnName' = x.v.value('columnname[1]', 'NVARCHAR(MAX)'),
		'ColumnValue' = x.v.value('columnvalue[1]', 'NVARCHAR(MAX)')
	FROM @Dictionary.nodes('/root/pair') x(v)

	DECLARE @columnName NVARCHAR(MAX);
	DECLARE @columnValue NVARCHAR(MAX);

	OPEN c

	IF @@CURSOR_ROWS > 0
	BEGIN
		SET @find = @find + ' WHERE ';

		FETCH NEXT FROM c INTO @columnName, @columnValue

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF	@columnName IS NOT NULL AND
				EXISTS(
					SELECT 1 FROM sys.columns 
			        WHERE [Name] = @columnName AND Object_ID = Object_ID(N'dbo.Driver'))AND
				@columnValue IS NOT NULL
			BEGIN
				SET @columnValue = REPLACE(@columnValue, '''', '''''')
				SET @find = @find + @columnName + ' = ''' + @columnValue + '''';
			END

		    FETCH NEXT FROM c INTO @columnName, @columnValue

			IF @@FETCH_STATUS = 0
			BEGIN
				SET @find = @find + ' AND ';
			END
			ELSE
			BEGIN
				SET @find = @find + ';'
			END
		END
		CLOSE c
		DEALLOCATE c
	END
	
	EXEC (@find)
END
