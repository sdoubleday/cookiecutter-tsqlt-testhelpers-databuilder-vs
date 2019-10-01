#https://www.sqlshack.com/connecting-powershell-to-sql-server/

$sqlConn = New-Object System.Data.SqlClient.SqlConnection
$sqlConn.ConnectionString = “Server=(localdb)\ProjectsV13;Integrated Security=true;Initial Catalog=Database1”
$sqlConn.Open()


$sqlcmd = New-Object System.Data.SqlClient.SqlCommand
$sqlcmd.Connection = $sqlConn
$query = @“
SELECT 'CREATE PROCEDURE [{{cookiecutter.Data_builder_schema}}].[DataBuilder_{{cookiecutter.schema}}_{{cookiecutter.object}}]'
UNION ALL
SELECT
CASE WHEN Ordinal_Position = 1 THEN ' ' ELSE ',' END +
'@'+REPLACE(column_name,' ','_')+' ' + 
        data_type + case data_type
            when 'sql_variant' then ''
            when 'text' then ''
            when 'ntext' then ''
            when 'xml' then ''
            when 'decimal' then '(' + cast(numeric_precision as varchar) + ', ' + cast(numeric_scale as varchar) + ')'
            else coalesce('('+case when character_maximum_length = -1 then 'MAX' else cast(character_maximum_length as varchar) end +')','') end
			+ ' = NULL'
			AS ParameterDeclaration
 FROM Information_Schema.COLUMNS
	   WHERE TABLE_NAME LIKE 'bobbobob'
	   AND TABLE_SCHEMA LIKE 'dbo'
UNION ALL
SELECT DISTINCT 'AS INSERT INTO [{{cookiecutter.schema}}].[{{cookiecutter.object}}]('
UNION ALL
SELECT CASE WHEN Ordinal_Position = 1 THEN ' ' ELSE ',' END +
'['+column_name+']' AS InsertIntoList 
 FROM Information_Schema.COLUMNS
	   WHERE TABLE_NAME LIKE 'bobbobob'
	   AND TABLE_SCHEMA LIKE 'dbo'
UNION ALL
SELECT ') SELECT'
UNION ALL
SELECT
CASE WHEN Ordinal_Position = 1 THEN ' ' ELSE ',' END +
'@'+REPLACE(column_name,' ','_')
AS SelectClause
       FROM Information_Schema.COLUMNS
	   WHERE TABLE_NAME LIKE 'bobbobob'
	   AND TABLE_SCHEMA LIKE 'dbo'
UNION ALL
SELECT 'RETURN 0'
UNION ALL
SELECT ''
"@

$sqlcmd.CommandText = $query

$adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd

$data = New-Object System.Data.DataSet
$adp.Fill($data) | Out-Null

$data.Tables[0]
