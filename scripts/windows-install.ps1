# Info users
echo 'By using this script, you agree that we can delete/reset/modify theese things that is installed under ~/.spicetify'
echo 'Installed extensions, theme folder, spicetify config file, spicetify installed folder, spicetify folder, and other spicetify related things, spotify configuration'
echo 'If you want to disagree, just simply close this script'
echo ''
echo 'You can download newer version of this script (if you need it) at https://github.com/eungyeole/k-spotify'
echo ''
Start-Sleep -Seconds 1

# Select Theme to use
[ValidateSet("RESET","melon","flo","vibe")] $ThemeName = Read-Host -Prompt 'Input Theme name to use! RESET | melon | flo | vibe '

# Set PATH
$sp_theme_dir = "${HOME}\.spicetify\Themes"
$sp_root_dir = "${HOME}\.spicetify"
$sp_appdatapath = [Environment]::GetFolderPath([Environment+SpecialFolder]::ApplicationData) + "\Spotify"
$sp_prefpath = $sp_appdatapath + "\prefs"

# Alert user if spotify is not installed from spotify.com
if (-not (Test-Path $sp_appdatapath)) {
  Write-Host $sp_appdatapath
  [System.Windows.MessageBox]::Show('Install Spotify from https://www.spotify.com/download and run this again.')
  Exit
}

# Alert user if spotify pref is not generated
if (-not (Test-Path $sp_prefpath)) {
  Write-Host $sp_prefpath
  [System.Windows.MessageBox]::Show('Open Spotify, login, and run this again.')
  Exit
}

# Delete Function
Function DeleteFile ([string] $FileDIR) {
  if (Test-Path $FileDIR) {
      Write-Part "REMOVING       "; Write-Emphasized $FileDIR
      Remove-Item $FileDIR -recurse 
      Write-Done
  }
}

# Reset Theme
if($ThemeName -eq "RESET"){
  echo '1. Disable CSS (Leave Extension)'
  echo '2. Restore config'
  echo '3. Reset spicetify config file - Recommended'
  echo '4. Remove spicetify'
  [ValidateSet('1','2','3','4')] $ResetHow = Read-Host -Prompt 'How would you like to reset? 1 | 2 | 3 | 4 Enter Number '
  if($ResetHow -eq '1'){
    spicetify config inject_css 0 replace_colors 0
    spicetify apply
    Write-Done "Disabled CSS"
  } elseif($ResetHow -eq '2'){
    spicetify restore
    Write-Done "Restored"
  } elseif($ResetHow -eq '3'){
    spicetify restore
    DeleteFile "${sp_root_dir}\config.ini"
    spicetify
    Write-Done "Resetted Config"
  } elseif($ResetHow -eq '4'){
    spicetify restore
    DeleteFile $sp_root_dir
    Write-Done "Deleted"
  } else {
    echo 'wrong input provided'
    pause
  }
  Exit
}

# Delete Extenstions
if (Test-Path "${sp_root_dir}\Extensions") {
    spicetify restore
}

# Enable TLS 1.2 since it is required for connections to GitHub.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Get spicetify-cli
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression
spicetify
spicetify backup apply enable-devtool

# Create Theme directory if it doesn't already exist
if (-not (Test-Path $sp_theme_dir)) {
  Write-Part "MAKING FOLDER  "; Write-Emphasized $sp_theme_dir
  New-Item -Path $sp_theme_dir -ItemType Directory | Out-Null
  Write-Done
}

# Delete K-spotify theme folder if already exists
DeleteFile "${HOME}\.spicetify\Themes\k-spotify"

# Download release.
$zip_file = "${sp_theme_dir}\K-spotify-master.zip"
$download_uri = "https://github.com/eungyeole/k-spotify/archive/master.zip"
Write-Part "DOWNLOADING    "; Write-Emphasized $download_uri
Invoke-WebRequest -Uri $download_uri -UseBasicParsing -OutFile $zip_file
Write-Done

# Extract assets from .zip file.
Write-Part "EXTRACTING     "; Write-Emphasized $zip_file
Write-Part " into "; Write-Emphasized ${sp_theme_dir};
Expand-Archive -Path $zip_file -DestinationPath $sp_theme_dir -Force
Write-Done

# Move needed Extensions
if (Test-Path "${sp_theme_dir}\k-spotify-master\extensions\${ThemeName}") {
    Write-Part "MOVING         "; Write-Emphasized "${sp_theme_dir}\k-spotify-master\extensions\${ThemeName}"
    Write-Part " into "; Write-Emphasized "${sp_root_dir}\Extensions";
    Move-Item -Force "${sp_theme_dir}\k-spotify-master\extensions\${ThemeName}\*" "${sp_root_dir}\Extensions"
    Write-Done
}

# Delete theme if that already exists which will be installed
DeleteFile $sp_theme_dir\$ThemeName

#Move folder
Write-Part "MOVING         "; Write-Emphasized "${HOME}\.spicetify\Themes\k-spotify-master\themes\${ThemeName}"
Write-Part " into "; Write-Emphasized "${HOME}\.spicetify\Themes";
Move-Item -Force "${HOME}\.spicetify\Themes\k-spotify-master\themes\${ThemeName}" -Destination "${HOME}\.spicetify\Themes"
Write-Done

# Remove .zip file.
DeleteFile $zip_file

# Remove git folder.
DeleteFile "${HOME}\.spicetify\Themes\k-spotify-master"

# Apply Extenstions
$AllExtensions = Get-ChildItem -Path "${sp_root_dir}\Extensions"
Foreach ($ThisExtension in $AllExtensions) {
  spicetify config extensions $ThisExtension
}

# Apply Theme Settings
spicetify config inject_css 1 replace_colors 1
spicetify config current_theme $ThemeName
spicetify config color_scheme $ThemeName
spicetify apply

Write-Done "K-Theme : ${ThemeName} is now applied."