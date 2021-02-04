# Info users
echo 'By using this script, you agree that we can delete/reset/modify theese things that is installed under ~/.spicetify'
echo 'Installed extensions, theme folder, spicetify config file, spicetify installed folder, spicetify folder, and other spicetify related things, spotify configuration'
echo 'If you want to disagree, just simply close this script'
echo ''
echo 'You can download newer version of this script (if you need it) at https://github.com/eungyeole/k-spotify'
echo ''
Start-Sleep -Seconds 1


# ======================================= Functions and preparing starts here ======================================= #


# Set PATH
$sp_theme_dir = "${HOME}\.spicetify\Themes"
$sp_customapps_dir = "${HOME}\.spicetify\CustomApps"
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

# Apply Extenstions Function
Function ApplyAllExtension {
  $AllExtensions = Get-ChildItem -Path "${sp_root_dir}\Extensions"
  Foreach ($ThisExtension in $AllExtensions) {
    spicetify config extensions $ThisExtension
    spicetify apply
  }
}


# ======================================= User Input starts here / Reset Function ======================================= #


# Select Theme to use
echo 'You can reset plugins by writting RESET'
[ValidateSet("default","RESET","melon","flo","vibe")] $ThemeName = Read-Host -Prompt 'Input Theme name to use! default | melon | flo | vibe '

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

# Select Plugins to use
[ValidateSet("y","n")] $lyrics = Read-Host -Prompt 'Do you want to install genius/musixmatch lyrics plugin? y | n '
[ValidateSet("y","n")] $WantLangKorean = Read-Host -Prompt 'Do you want Spotify to be Korean? y | n '

echo ''
echo 'Do you want to check for Spotify Updates automatically?'
echo 'If you turn this on, It might have some problem after Spotify update. = enter TurnOn'
echo 'If you turn this off, You need to manually check for updates using spotify installer. = enter anything'
echo 'Spotify Installer Download : https://www.spotify.com/download'
echo ''
$autoupdate = Read-Host -Prompt 'Recommended answer is n. Which will you choose? TurnOn | enter anything '


echo 'You selected'
echo 'Theme : ' + ${ThemeName}
echo 'Install lyrics : ' + ${lyrics}
echo 'Install Korean : ' + ${WantLangKorean}'
echo 'AutoUpdate : "' + ${autoupdate} + '"       this needs to be "TurnOn" to turn it on, otherwise it will be disabled.'


# ======================================= User Input Ends ======================================= #
# ======================================= Installing spicetify-cli starts here ======================================= #


# Delete Extenstions
if (Test-Path "${sp_root_dir}\Extensions") {
    spicetify restore
    DeleteFile "${sp_root_dir}\Extensions"
    DeleteFile "${sp_root_dir}\config.ini"
    New-Item -Path "${sp_root_dir}\Extensions" -ItemType Directory | Out-Null
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

# Create CustomApps directory if it doesn't already exist
if (-not (Test-Path $sp_theme_dir)) {
  Write-Part "MAKING FOLDER  "; Write-Emphasized $sp_theme_dir
  New-Item -Path $sp_theme_dir -ItemType Directory | Out-Null
  Write-Done
}


# ======================================= Installing spicetify-cli ends here ======================================= #
# ======================================= Start installing extensions and themes ======================================= #


# Theme if not default
if (-not($ThemeName -eq 'default')) {
  # Delete K-spotify theme folder if already exists
  DeleteFile "${HOME}\.spicetify\Themes\k-spotify"

  # Download theme release.
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

  # Apply theme settings
  ApplyAllExtension
  spicetify config inject_css 1 replace_colors 1
  spicetify config current_theme $ThemeName
  spicetify config color_scheme $ThemeName

} else {
  spicetify config inject_css 0 replace_colors 0
}



# If user want lyrics
if ($lyrics -eq 'y') {

  # Get from github
  $lyrics_github = "https://github.com/khanhas/genius-spicetify/archive/master.zip"
  Write-Part "DOWNLOADING    "; Write-Emphasized $lyrics_github
  Invoke-WebRequest -Uri $lyrics_github -UseBasicParsing -OutFile "${sp_customapps_dir}\genius.zip"
  Write-Done

  # Unzip
  Write-Part "EXTRACTING     "; Write-Emphasized "${sp_customapps_dir}\genius.zip"
  Write-Part " into "; Write-Emphasized ${sp_customapps_dir};
  Expand-Archive -Path "${sp_customapps_dir}\genius.zip" -DestinationPath $sp_customapps_dir -Force
  Write-Done
  
  # Delete zip to free up space
  DeleteFile "${sp_customapps_dir}\genius.zip"

  # Change name
  DeleteFile "${sp_customapps_dir}\genius"
  Write-Part "MOVING         "; Write-Emphasized "${sp_customapps_dir}\genius-spicetify-master"
  Write-Part " into "; Write-Emphasized "${sp_customapps_dir}\genius"
  Rename-Item "${sp_customapps_dir}\genius-spicetify-master" "${sp_customapps_dir}\genius"
  Write-Done

  # Save Config
  spicetify config custom_apps genius
}



# If user want Spotify to be Korean
if ($WantLangKorean -eq 'y') {
  Add-Content $sp_prefpath "`nlanguage=""ko"""
}

# If user want Spotify to be updated automatically
if ($autoupdate -eq 'TurnOn') {
  spicetify config disable_upgrade_check 0
  spicetify config check_spicetify_upgrade 1
}



# Apply 
spicetify apply
