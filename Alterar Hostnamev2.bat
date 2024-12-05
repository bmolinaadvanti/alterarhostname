@echo off
:: Verifica se ja esta rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando privilegios de administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

:: Verifica novamente se ja está rodando como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Nao foi possivel obter privilegios de administrador.
    pause
    exit /b
)

:: Solicita o novo hostname
set /p newhostname=Digite o novo hostname (NB OU DSK (notebook ou desktop) + 3 letras do cliente (que de para identificar que e o cliente) + Patrimonio caso tenha ou 001...002...003 caso nao tenha patrimonio): 

:: Altera o hostname usando PowerShell
powershell -Command "Rename-Computer -NewName '%newhostname%' -Force -PassThru"
if %errorlevel% neq 0 (
    echo Erro ao alterar o hostname. Verifique o nome fornecido ou permissoes do sistema.
    pause
    exit /b
)

:: Informa sobre a alteração
echo O hostname foi alterado para "%newhostname%". O sistema sera reiniciado em 10 segundos para aplicar as alterações de Hostname - By Bruno Molina.
timeout /t 10 >nul

:: Reinicia o sistema
shutdown /r /t 10
