copy ".\dir_{{cookiecutter.delimiter}}\{{cookiecutter.databuilder_name}}.sql" ".\dir_{{cookiecutter.delimiter}}\{{cookiecutter.databuilder_name}}.ps1"

powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -File ".\dir_{{cookiecutter.delimiter}}\{{cookiecutter.databuilder_name}}.ps1"
