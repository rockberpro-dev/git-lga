$ErrorActionPreference = "Stop"

$ConfigHome = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { "$HOME\.config" }
$ConfigDir = "$ConfigHome\git-lga"

$GitconfigUrl = "https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga.gitconfig"
$InstallPath = "$ConfigDir\git-lga.gitconfig"

$HelpUrl = "https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga-help.sh"
$HelpPath = "$ConfigDir\git-lga-help.sh"

$Ps1Url = "https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga.ps1"
$Ps1Path = "$ConfigDir\git-lga.ps1"

# Remove files from older versions, which installed directly into ~
$OldPs1Path = "$HOME\.git-lga.ps1"
Remove-Item "$HOME\.git-lga.gitconfig", "$HOME\.git-lga-help.sh", $OldPs1Path -Force -ErrorAction SilentlyContinue
git config --global --unset-all include.path '\.git-lga\.gitconfig$' 2>$null
if ((Test-Path $PROFILE) -and (Select-String -Path $PROFILE -SimpleMatch $OldPs1Path -Quiet)) {
    $profileLines = @(Get-Content $PROFILE | Where-Object { -not $_.Contains($OldPs1Path) })
    Set-Content -Path $PROFILE -Value $profileLines
}

New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null

Invoke-WebRequest -Uri $GitconfigUrl -OutFile $InstallPath -UseBasicParsing

$includes = git config --global --get-all include.path 2>$null
if ($includes -notcontains $InstallPath) {
    git config --global --add include.path $InstallPath
}

Invoke-WebRequest -Uri $HelpUrl -OutFile $HelpPath -UseBasicParsing

Invoke-WebRequest -Uri $Ps1Url -OutFile $Ps1Path -UseBasicParsing

if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$sourceLine = ". `"$Ps1Path`""
if (!(Select-String -Path $PROFILE -SimpleMatch $Ps1Path -Quiet)) {
    Add-Content -Path $PROFILE -Value $sourceLine
}

Write-Host "git-lga installed: $InstallPath"
Write-Host "git-lga help installed: $HelpPath"
Write-Host "git-lga ps1 installed: $Ps1Path"
