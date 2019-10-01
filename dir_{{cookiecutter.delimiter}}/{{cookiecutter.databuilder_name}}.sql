#https://www.sqlshack.com/connecting-powershell-to-sql-server/

$sqlConn = New-Object System.Data.SqlClient.SqlConnection;
$sqlConn.ConnectionString = “Server={{cookiecutter.server_to_query_column_list}};Integrated Security=true;Initial Catalog={{cookiecutter.database_to_query_column_list}}”;
$sqlConn.Open();


$sqlcmd = New-Object System.Data.SqlClient.SqlCommand;
$sqlcmd.Connection = $sqlConn
$query = @“
SELECT 'CREATE PROCEDURE [{{cookiecutter.schema_test_helper}}].[{{cookiecutter.databuilder_name}}]'
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
	   WHERE TABLE_NAME LIKE '{{cookiecutter.object_to_populate}}'
	   AND TABLE_SCHEMA LIKE '{{cookiecutter.schema_of_object}}'
UNION ALL
SELECT DISTINCT 'AS INSERT INTO [{{cookiecutter.schema_of_object}}].[{{cookiecutter.object_to_populate}}]('
UNION ALL
SELECT CASE WHEN Ordinal_Position = 1 THEN ' ' ELSE ',' END +
'['+column_name+']' AS InsertIntoList 
 FROM Information_Schema.COLUMNS
	   WHERE TABLE_NAME LIKE '{{cookiecutter.object_to_populate}}'
	   AND TABLE_SCHEMA LIKE '{{cookiecutter.schema_of_object}}'
UNION ALL
SELECT ') SELECT'
UNION ALL
SELECT
CASE WHEN Ordinal_Position = 1 THEN ' ' ELSE ',' END +
'@'+REPLACE(column_name,' ','_')
AS SelectClause
       FROM Information_Schema.COLUMNS
	   WHERE TABLE_NAME LIKE '{{cookiecutter.object_to_populate}}'
	   AND TABLE_SCHEMA LIKE '{{cookiecutter.schema_of_object}}'
UNION ALL
SELECT 'RETURN 0'
UNION ALL
SELECT ''
"@;

$sqlcmd.CommandText = $query;

$adp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd;

$data = New-Object System.Data.DataSet;
$adp.Fill($data) | Out-Null;

#Because we are rebels! Or, really because Visula Studio is expecting this filepath to exist and be a sql script.
New-Item -ItemType File -Force $PSCommandPath;

$data.Tables[0] | Add-Content -Path $PSCommandPath -Encoding UTF8;
