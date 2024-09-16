@echo off
:: Verifica se o script está sendo executado como administrador
net session >nul 2>&1
if %errorLevel% == 0 (
    echo O script já está sendo executado como administrador.
) else (
    echo Solicitando privilégios de administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0' -Verb RunAs"
    exit
)

:menu
cls
echo ==========================================
echo          Menu de Ferramentas
echo ==========================================
echo 1 - Ferramenta Manutencao Windows
echo 2 - Ferramenta Controle Defender
echo 3 - Ferramenta Ativacao Windows/Office
echo 4 - Instalar WinRAR
echo 5 - Instalar AnyDesk
echo 6 - Limpeza de Disco
echo 7 - Atualizacoes do Windows
echo 8 - Backup do Sistema
echo 9 - Desfragmentacao do Disco
echo 10 - Ferramentas Internet Download Manager
echo 11 - Sair
echo ==========================================
echo Feito por Ricardo Christovão
echo Visite: https://christovao.com.br/redes
echo ==========================================
set /p choice="Escolha uma opcao: "


if %choice%==1 goto manutencao
if %choice%==2 goto controle_defender
if %choice%==3 goto ativacao
if %choice%==4 goto instalar_winrar
if %choice%==5 goto instalar_anydesk
if %choice%==6 goto limpeza_disco
if %choice%==7 goto atualizacoes_windows
if %choice%==8 goto backup_sistema
if %choice%==9 goto desfragmentacao_disco
if %choice%==10 goto ferramenta_idm
if %choice%==11 exit

:manutencao
cls
echo Executando sfc /scannow...
sfc /scannow

echo Executando DISM /online /cleanup-image /scanhealth...
dism /online /cleanup-image /scanhealth

echo Executando DISM /online /cleanup-image /restorehealth...
dism /online /cleanup-image /restorehealth

echo Todos os comandos foram executados.
pause
goto menu

:controle_defender
cls
echo ==========================================
echo          Controle do Windows Defender
echo ==========================================
echo 1 - Ativar Defender
echo 2 - Desativar Defender
echo 3 - Restaurar Defender
echo ==========================================
set /p defender_choice="Escolha uma opcao: "

if %defender_choice%==1 (
    echo Ativando o Windows Defender...
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
) else if %defender_choice%==2 (
    echo Desativando o Windows Defender...
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
) else if %defender_choice%==3 (
    echo Restaurando o Windows Defender...
    powershell -Command "Start-MpWDOScan"
)

pause
goto menu

:ativacao
cls
echo Executando script de ativacao...
powershell -Command "irm https://get.activated.win | iex"
pause
goto menu

:instalar_winrar
cls
echo Verificando arquitetura do sistema...
set ARCHITECTURE=x86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set ARCHITECTURE=x64

echo Baixando WinRAR para %ARCHITECTURE%...
if "%ARCHITECTURE%"=="x64" (
    powershell -Command "Invoke-WebRequest -Uri 'https://www.rarlab.com/rar/winrar-x64-611br.exe' -OutFile 'winrar.exe'"
) else (
    powershell -Command "Invoke-WebRequest -Uri 'https://www.rarlab.com/rar/wrar611br.exe' -OutFile 'winrar.exe'"
)

echo Instalando WinRAR...
start /wait winrar.exe /S

echo WinRAR instalado com sucesso.
del winrar.exe
pause
goto menu

:instalar_anydesk
cls
echo Baixando AnyDesk...
powershell -Command "Invoke-WebRequest -Uri 'https://download.anydesk.com/AnyDesk.exe' -OutFile 'AnyDesk.exe'"

echo Instalando AnyDesk...
start /wait AnyDesk.exe /S

echo AnyDesk instalado com sucesso.
del AnyDesk.exe
pause
goto menu

:limpeza_disco
cls
echo Executando Limpeza de Disco...
cleanmgr /sagerun:1
pause
goto menu

:atualizacoes_windows
cls
echo Verificando atualizacoes do Windows...
powershell -Command "try { Import-Module PSWindowsUpdate } catch { exit 1 }"
if %errorlevel% neq 0 (
    echo A execucao de scripts do PowerShell esta desabilitada.
    echo Deseja habilitar a execucao de scripts? (S/N)
    set /p enable_scripts="Escolha: "
    if /i "%enable_scripts%"=="S" (
        powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
        echo Politica de execucao alterada para RemoteSigned.
    ) else (
        echo Execucao de scripts nao habilitada. Saindo...
        pause
        exit
    )
)
powershell -Command "Get-WindowsUpdate -Install -AcceptAll -AutoReboot"
pause
goto menu

:backup_sistema
cls
echo Criando backup do sistema...
wbadmin start backup -backupTarget:D: -include:C: -allCritical -quiet
pause
goto menu

:desfragmentacao_disco
cls
echo Desfragmentando o disco...
defrag C: /O
pause
goto menu

:ferramenta_idm
cls
echo Executando script de ativacao...
powershell -Command "irm https://massgrave.dev/ias | iex"
pause
goto menu
