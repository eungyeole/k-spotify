# Select Theme to use
[ValidateSet("melon","flo","vibe")] $ThemeName = Read-Host -Prompt 'Input Theme name to use! melon | flo '

# Get spicetify-cli
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" | Invoke-Expression
spicetify
spicetify backup apply enable-devtool

# Set PATH
$sp_dir = "${HOME}\.spicetify\Themes"
$sp_root_dir = "${HOME}\.spicetify"

# Create Theme directory if it doesn't already exist
if (-not (Test-Path $sp_dir)) {
  Write-Part "MAKING FOLDER  "; Write-Emphasized $sp_dir
  New-Item -Path $sp_dir -ItemType Directory | Out-Null
  Write-Done
}

# Delete files from K-theme
if (Test-Path $sp_dir\melon) {
  Write-Part "REMOVING       "; Write-Emphasized $sp_dir\melon
  Remove-Item $sp_dir\melon -recurse 
  Write-Done
}
if (Test-Path $sp_dir\flo) {
  Write-Part "REMOVING       "; Write-Emphasized $sp_dir\flo
  Remove-Item $sp_dir\flo -recurse 
  Write-Done
}
if (Test-Path $sp_dir\vibe) {
    Write-Part "REMOVING       "; Write-Emphasized $sp_dir\vibe
    Remove-Item $sp_dir\vibe -recurse 
    Write-Done
  }  

# Delete K-spotify theme folder if already exists
$th_old_dir = "${HOME}\.spicetify\Themes\k-spotify"
if (Test-Path $th_old_dir) {
  Write-Part "REMOVING       "; Write-Emphasized $th_old_dir
  Remove-Item -recurse -Path $th_old_dir
  Write-Done
}

# Download release.
$zip_file = "${sp_dir}\K-spotify-master.zip"
$download_uri = "https://github.com/eungyeole/k-spotify/archive/master.zip"
Write-Part "DOWNLOADING    "; Write-Emphasized $download_uri
Invoke-WebRequest -Uri $download_uri -UseBasicParsing -OutFile $zip_file
Write-Done

# Extract assets from .zip file.
Write-Part "EXTRACTING     "; Write-Emphasized $zip_file
Write-Part " into "; Write-Emphasized ${sp_dir};
# Using -Force to overwrite spicetify.exe and assets if it already exists
Expand-Archive -Path $zip_file -DestinationPath $sp_dir -Force
Write-Done

# Delete unused files
Write-Part "REMOVING       "; Write-Emphasized $sp_dir\k-spotify-master\.DS_Store
Remove-Item $sp_dir\k-spotify-master\.DS_Store -recurse 
Write-Done
Write-Part "REMOVING       "; Write-Emphasized $sp_dir\k-spotify-master\README.md
Remove-Item $sp_dir\k-spotify-master\README.md -recurse 
Write-Done
Write-Part "REMOVING       "; Write-Emphasized $sp_dir\k-spotify-master\scripts
Remove-Item $sp_dir\k-spotify-master\scripts -recurse
Write-Done

#Move folder
Move-Item -Force "${HOME}\.spicetify\Themes\k-spotify-master\*" -Destination "${HOME}\.spicetify\Themes"

# Remove .zip file.
Write-Part "REMOVING       "; Write-Emphasized $zip_file
Remove-Item -Path $zip_file -recurse 
Write-Done

# Remove git folder.
$git_folder = "${HOME}\.spicetify\Themes\k-spotify-master"
Write-Part "REMOVING       "; Write-Emphasized $git_folder
Remove-Item $git_folder -recurse 
Write-Done

# Move items for melon
Move-Item -Force "${sp_dir}\melon\dribbblish.js" "${sp_root_dir}\Extensions"

Write-Done "`n spicetify-cli and K-Theme is now installed."

spicetify config extensions dribbblish.js
spicetify config current_theme $ThemeName
spicetify config color_scheme $ThemeName
spicetify apply

Write-Done "K-Theme : ${ThemeName} is now applied."
