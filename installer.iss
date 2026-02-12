[Setup]
AppName="AndroidDebugTools"
AppVersion=1.0.0
DefaultDirName ={pf}\AndroidDebugTools
DefaultGroupName=Android Debug Tools
OutputBaseFilename=AndroidDebugTools_Setup
Compression=lzma
SolidCompression=yes


[Files]
Source: "dist\AndroidDebugTools.exe"; DestDir: "{app}"

Source: "src\commands.json"; DestDir: "{app}"
Source: "src\shell\*"; DestDir: "{app}\shell"; Flags:recursesubdirs
Source: "src\bin\*"; DestDir: "{app}\bin"; Flags:recursesubdirs
Source: "src\tools\*"; DestDir: "{app}\tools"; Flags:recursesubdirs

[Icons]
Name: "{group}\Android Debug Tools"; Filename: "{app}\AndroidDebugTools.exe"
Name: "{commondesktop}\Android Debug Tools"; Filename: "{app}\AndroidDebugTools.exe"

[Run]
Filename: "{app}\AndroidDebugTools.exe"; Flags: nowait postinstall
