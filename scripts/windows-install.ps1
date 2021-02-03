# Select Theme to use
[ValidateSet("RESET","melon","flo","vibe")] $ThemeName = Read-Host -Prompt 'Input Theme name to use! RESET | melon | flo | vibe '

# Reset Theme
if($ThemeName -eq "RESET"){
   spicetify config inject_css 0 replace_colors 0
   spicetify apply
   Write-Done "Resetted theme"
   Exit
}

# Get spicetify-cli
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression
spicetify
spicetify backup apply enable-devtool

# Set PATH
$sp_theme_dir = "${HOME}\.spicetify\Themes"
$sp_root_dir = "${HOME}\.spicetify"

# Delete Function
Function DeleteFile ([string] $FileDIR) {
  if (Test-Path $FileDIR) {
      Write-Part "REMOVING       "; Write-Emphasized $FileDIR
      Remove-Item $FileDIR -recurse 
      Write-Done
  }
}

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
# Using -Force to overwrite spicetify.exe and assets if it already exists
Expand-Archive -Path $zip_file -DestinationPath $sp_theme_dir -Force
Write-Done

# Move needed Extensions
Move-Item -Force "${sp_theme_dir}\k-spotify-master\extensions\*" "${sp_root_dir}\Extensions"

# Delete unused files/folders for themes
DeleteFile $sp_theme_dir\k-spotify-master\.DS_Store
DeleteFile $sp_theme_dir\k-spotify-master\README.md
DeleteFile $sp_theme_dir\k-spotify-master\scripts
DeleteFile $sp_theme_dir\k-spotify-master\extensions

# Delete folder and files that already exists
$AllFilesGit = Get-ChildItem -Path "$sp_theme_dir\k-spotify-master"
Foreach ($ThisFilesGit in $AllFilesGit) {
  DeleteFile $sp_theme_dir\$ThisFilesGit
}

#Move folder
Move-Item -Force "${HOME}\.spicetify\Themes\k-spotify-master\*" -Destination "${HOME}\.spicetify\Themes"

# Remove .zip file.
DeleteFile $zip_file

# Remove git folder.
DeleteFile "${HOME}\.spicetify\Themes\k-spotify-master"


# Apply Extenstions
$AllExtensions = Get-ChildItem -Path "${sp_root_dir}\Extensions" -recurse
Foreach ($ThisExtension in $AllExtensions) {
  spicetify config extensions $ThisExtension
}

# Apply Theme Settings
spicetify config inject_css 1 replace_colors 1
spicetify config current_theme $ThemeName
spicetify config color_scheme $ThemeName
spicetify apply

Write-Done "K-Theme : ${ThemeName} is now applied."