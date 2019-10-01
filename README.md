# cookiecutter-tsqlt-testhelpers-databuilder-vs
Cookiecutter template for data builder to populate test data for tSQLt tests in a Visual Studio database project

Inspired by [https://datacentricity.net/2011/11/30/unit-testing-databases-adapting-the-test-data-builder-pattern-for-t-sql/](https://datacentricity.net/2011/11/30/unit-testing-databases-adapting-the-test-data-builder-pattern-for-t-sql/)

## Implementation Note

Uses a hook to run a powershell script that lives IN the .sql file, which gets a column list from your local dev database, and then overwrites the sql file.
