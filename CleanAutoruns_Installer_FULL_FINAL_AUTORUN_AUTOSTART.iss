
[Setup]
AppName=CleanAutoruns
AppVersion=1.0
DefaultDirName={pf}\CleanAutoruns
DefaultGroupName=CleanAutoruns
OutputDir={userdesktop}
OutputBaseFilename=CleanAutoruns_Setup
SetupIconFile=C:\Users\User\OneDrive\Desktop\final_icon.ico
WizardImageFile=C:\Users\User\OneDrive\Desktop\logo.bmp
LicenseFile=C:\Users\User\OneDrive\Desktop\license_professional.txt
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
DefaultLanguage=ru
ShowLanguageDialog=yes
ShowWelcomePage=yes

[Languages]
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "uk"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Files]
Source: "C:\Users\User\OneDrive\Desktop\CleanAutoruns_GUI.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\CleanAutoruns"; Filename: "{app}\CleanAutoruns_GUI.exe"
Name: "{commondesktop}\CleanAutoruns"; Filename: "{app}\CleanAutoruns_GUI.exe"

[Run]
Filename: "{app}\CleanAutoruns_GUI.exe"; Description: "Запустить CleanAutoruns"; Flags: nowait postinstall skipifsilent shellexec

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "CleanAutoruns"; ValueData: "{app}\CleanAutoruns_GUI.exe"; Flags: uninsdeletevalue

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Messages]
WelcomeLabel1=Этот мастер поможет установить программу CleanAutoruns на ваш компьютер.
WelcomeLabel2=Рекомендуется закрыть все прочие приложения перед началом установки.
SetupFinishedLabel1=Установка программы CleanAutoruns успешно завершена.
SetupFinishedLabel2=Нажмите "Готово" для выхода из мастера установки.
