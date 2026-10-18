$ErrorActionPreference = 'Stop'
$dest = Join-Path $env:LOCALAPPDATA 'BratGenerator'
New-Item -ItemType Directory -Force $dest | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'index.html') $dest -Force
Copy-Item (Join-Path $PSScriptRoot 'brat.ico') $dest -Force
$url = ([System.Uri](Join-Path $dest 'index.html')).AbsoluteUri
$cands = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe")
$browser = $cands | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { Write-Host 'Could not find Microsoft Edge or Google Chrome.'; exit 1 }
$sh = New-Object -ComObject WScript.Shell
foreach ($folder in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
  $l = $sh.CreateShortcut((Join-Path $folder 'Brat Generator.lnk'))
  $l.TargetPath = $browser
  $l.Arguments = "--app=$url --window-size=620,960"
  $l.IconLocation = (Join-Path $dest 'brat.ico')
  $l.Save()
}
Write-Host 'Installed! A "Brat Generator" shortcut is on your Desktop and in the Start menu.'
Start-Process $browser -ArgumentList "--app=$url", "--window-size=620,960"
