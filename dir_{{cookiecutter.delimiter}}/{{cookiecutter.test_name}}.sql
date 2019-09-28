﻿CREATE PROCEDURE [{{cookiecutter.test_schema_name}}].[{{cookiecutter.test_name}}]
AS
BEGIN
	--ASSEMBLE
	IF OBJECT_ID('[{{cookiecutter.test_schema_name}}].ACTUAL') IS NOT NULL DROP TABLE [{{cookiecutter.test_schema_name}}].ACTUAL;
	IF OBJECT_ID('[{{cookiecutter.test_schema_name}}].EXPECTED') IS NOT NULL DROP TABLE [{{cookiecutter.test_schema_name}}].EXPECTED;

	/*Do you need to fake tables and insert rows?
	EXECUTE tSQLt.FakeTable @TableName = '[{{cookiecutter.schema_under_test}}].TableName';
	*/
	/*Do you need to spyprocedure?
	EXECUTE tSQLt.SpyProcedure @ProcedureName = '[{{cookiecutter.schema_under_test}}].ProcedureName'
	--,@CommandToExecute = 'SELECT 1'
	SELECT _id_, MyParameterName1, MyParameterName2 FROM [{{cookiecutter.schema_under_test}}].ProcedureName_SpyProcedureLog
	SELECT COUNT(1) FROM [{{cookiecutter.schema_under_test}}].ProcedureName_SpyProcedureLog
	*/

	--ACT
	SELECT 
	/*Relevant Column List Here*/
	INTO [{{cookiecutter.test_schema_name}}].ACTUAL
	FROM [{{cookiecutter.schema_under_test}}].[{{cookiecutter.object_under_test}}];

	--ASSERT
	CREATE TABLE [{{cookiecutter.test_schema_name}}].EXPECTED (
		/*Relevant Column Definitions Here*/
	);
	INSERT INTO [{{cookiecutter.test_schema_name}}].EXPECTED (
		/*Relevant Column List Here*/
	) VALUES (
		/*Relevant Values Here*/
	);

	EXECUTE [tSQLt].AssertEqualsTable @Expected = '[{{cookiecutter.test_schema_name}}].EXPECTED', @Actual = '[{{cookiecutter.test_schema_name}}].ACTUAL';

END

/****
Script generated by cookiecutter, for completion by user.
https://github.com/sdoubleday/cookiecutter-tsqlt-class-vs
This test compares the contents of EXPECTED and ACTUAL.
****/
/****
Suggestion: Verify the object being selected from in the
Act section. It defaults to your object under test.
****/