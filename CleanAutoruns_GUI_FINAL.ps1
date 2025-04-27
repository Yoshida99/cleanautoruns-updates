
# === Проверка обновлений через GitHub ===
Add-Type -AssemblyName System.Windows.Forms

function Compare-Version($v1, $v2) {
    [Version]$ver1 = $v1
    [Version]$ver2 = $v2
    return $ver1.CompareTo($ver2)
}

$LocalVersion = "1.0.0"  # Укажи текущую версию своей программы
$VersionURL = "https://raw.githubusercontent.com/Yoshida99/cleanautoruns-updates/main/version.txt"
$SetupURL = "https://raw.githubusercontent.com/Yoshida99/cleanautoruns-updates/main/CleanAutoruns_Setup.exe"
$TempPath = "$env:TEMP\CleanAutoruns_Setup.exe"

try {
    $RemoteVersion = Invoke-RestMethod -Uri $VersionURL -UseBasicParsing

    if (Compare-Version $RemoteVersion $LocalVersion -gt 0) {
        $result = [System.Windows.Forms.MessageBox]::Show(
            "Доступна новая версия $RemoteVersion.`nХотите скачать и установить обновление?",
            "Обновление доступно",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Invoke-WebRequest -Uri $SetupURL -OutFile $TempPath
            Start-Process $TempPath
            exit
        }
    }
} catch {
    # Ошибку не показываем, если нет интернета
}

# === Основная логика CleanAutoruns ===

function Show-MessageBox($message, $title, $buttons = [System.Windows.Forms.MessageBoxButtons]::OK, $icon = [System.Windows.Forms.MessageBoxIcon]::Information) {
    [System.Windows.Forms.MessageBox]::Show($message, $title, $buttons, $icon)
}

function Check-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Backup-Autoruns {
    $backupPath = "$env:USERPROFILE\Desktop\autorun_backup_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').reg"
    $exportPaths = @(
        "HKCU\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
    )
    foreach ($regPath in $exportPaths) {
        if (Test-Path "Registry::$regPath") {
            reg export "$regPath" "$backupPath" /y | Out-Null
        }
    }
    Show-MessageBox "Резервная копия сохранена на рабочий стол:`n$backupPath" "Резервная копия создана"
}

function Clean-Autoruns {
    $paths = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Get-ItemProperty -Path $path | ForEach-Object {
                $_.PSObject.Properties | ForEach-Object {
                    $name = $_.Name
                    $value = $_.Value

                    if ($value -is [string]) {
                        $filePath = $value -replace '"', ''
                        $filePath = $filePath.Split(' ')[0]

                        if (!(Test-Path $filePath)) {
                            $result = Show-MessageBox "Найдена битая запись:`nИмя: $name`nПуть: $filePath`n`nУдалить эту запись?" "Битая запись" ([System.Windows.Forms.MessageBoxButtons]::YesNo) ([System.Windows.Forms.MessageBoxIcon]::Warning)
                            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                                Remove-ItemProperty -Path $path -Name $name
                                Show-MessageBox "Удалено: $name" "Удаление записи"
                            }
                        }
                    }
                }
            }
        }
    }
}

# Основной запуск
if (-not (Check-AdminRights)) {
    Show-MessageBox "Требуются права администратора для корректной работы программы! Пожалуйста, перезапустите с правами администратора." "Ошибка прав" ([System.Windows.Forms.MessageBoxButtons]::OK) ([System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

if ((Show-MessageBox "Создать резервную копию автозагрузки перед очисткой?" "Резервная копия" ([System.Windows.Forms.MessageBoxButtons]::YesNo) ([System.Windows.Forms.MessageBoxIcon]::Question)) -eq [System.Windows.Forms.DialogResult]::Yes) {
    Backup-Autoruns
}

Clean-Autoruns
Show-MessageBox "Очистка автозагрузки завершена!" "Готово"
