powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -File ".\{{cookiecutter.databuilder_name}}.ps1"

del ".\{{cookiecutter.databuilder_name}}.ps1"
