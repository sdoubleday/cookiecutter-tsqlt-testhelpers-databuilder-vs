copy ".\{{cookiecutter.databuilder_name}}.sql" ".\{{cookiecutter.databuilder_name}}.ps1"

powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -File ".\{{cookiecutter.databuilder_name}}.ps1"

rm ".\{{cookiecutter.databuilder_name}}.ps1"
