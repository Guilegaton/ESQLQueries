CREATE PROCEDURE exec_FindValues
	@columnName NVARCHAR(MAX) = NULL,
	@columnValue NVARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @find NVARCHAR(MAX);
	
	SET @find = 'SELECT * FROM Driver';
	
	IF	@columnName IS NOT NULL AND
		EXISTS(
			SELECT 1 FROM sys.columns 
	        WHERE [Name] = @columnName AND Object_ID = Object_ID(N'dbo.Driver'))AND
		@columnValue IS NOT NULL
	BEGIN
		SET @columnValue = REPLACE(@columnValue, '''', '''''')
		SET @find = @find + ' WHERE ' + @columnName + ' = ''' + @columnValue + ''';';
	END
	
	EXEC (@find)

END

CREATE PROCEDURE spexecute_FindValues
	@columnName NVARCHAR(MAX) = NULL,
	@columnValue NVARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @find NVARCHAR(MAX);
	
	SET @find = 'SELECT * FROM Driver';
	
	IF	@columnName IS NOT NULL AND
		EXISTS(
			SELECT 1 FROM sys.columns 
	        WHERE [Name] = @columnName AND Object_ID = Object_ID(N'dbo.Driver'))AND
		@columnValue IS NOT NULL
	BEGIN
		SET @find = @find + ' WHERE ' + @columnName + ' = @value;';
		EXECUTE sp_executesql   
	          @find,  
	          N'@value NVARCHAR(MAX)',  
	          @value = @columnValue;
	END
	ELSE
	BEGIN
		EXECUTE sp_executesql   
	          N'SELECT * FROM Driver';
	END

END

