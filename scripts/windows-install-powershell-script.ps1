# Info users

Function TOS_English {
  Write-Host "By using this script, you agree that we can Delete/Modify everything that is installed at ~/.spicetify folder, modify spotify configuration, and Powershell Configuration"
  Write-Host "If you want to disagree, just simply close this script"
  Write-Host ""
  Write-Host "You can download newer version of this script (if you need it) at https://github.com/eungyeole/k-spotify"
  Write-Host ""
  Start-Sleep -Seconds 1
  do { $AgreeTOS = (Read-Host -Prompt 'Do you agree? [Y]es | [N]o ').ToLower() } while ($AgreeTOS -notin @('y','n'))
}
Function TOS_Korean {
  # Set up UTF-8 (needed for Korean)
  [System.Console]::InputEncoding = [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
  $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
  Write-Host "이 스크립트를 실행함으로서 ~/.spicetify 폴더 아래의 모든 파일, 스포티파이 설정을 수정 또는 삭제할 수 있음을 이해했습니다."
  Write-Host "또한, 방금 전 한국어를 표시하기 위해 파워쉘 설정에서 UTF8을 지원하도록 변경하였습니다."
  Write-Host "미동의시, 이 스크립트를 종료해주세요."
  Write-Host ""
  Write-Host "참고로, 새 버전의 스크립트가 필요하신 경우 https://github.com/eungyeole/k-spotify 에서 받을 수 있습니다."
  Write-Host ""
  Start-Sleep -Seconds 1
  do { $AgreeTOS = (Read-Host -Prompt '동의하시겠습니까? [Y]es | [N]o ').ToLower() } while ($AgreeTOS -notin @('y','n'))

}

# Close if not agreed to TOS
if($AgreeTOS -eq "n") {
  Exit
}

# ======================================= Functions and preparing starts here ======================================= #

# Set up UTF-8 (needed for Korean)
[System.Console]::InputEncoding = [System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
# If this even don't work, I don't have any idea how to fix it

# Enable TLS 1.2 since it is required for connections to GitHub.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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
Write-Host ""
Write-Host "RESET 을 입력해서 spicetify를 초기화할 수 있습니다."
Write-Host "사용하려는 K-테마 이름을 입력해주세요. 다른 테마를 사용하고 싶으시다면 default를 입력하여 모든 설정 완료 후, 직접 수동으로 설치해 주세요."
Write-Host "커뮤니티 테마를 사용하시려면 community 라고 입력해주세요."
Write-Host "커뮤니티 테마 링크 : https://github.com/morpheusthewhite/spicetify-themes"
Write-Host ""
do { $ThemeName = Read-Host -Prompt 'Input Theme name to use! default | community | melon | flo | vibe ' } 
until ("default","community","RESET","melon","flo","vibe" -ccontains $ThemeName)

# Reset Theme
if($ThemeName -eq "RESET"){
  Write-Host "1. Disable CSS (Leave Extension)"
  Write-Host "2. Restore config"
  Write-Host "3. spicetify 설정 파일 삭제 후 재생성 - 추천됨"
  Write-Host "4. Remove spicetify - 삭제 시 사용"
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
    Write-Host "wrong input provided"
    pause
  }
  Exit
}



# Community Theme
if($ThemeName -eq "community") {
  $isCommunityTheme = "true"
  Write-Host "설치를 원하는 커뮤니티 테마의 이름을 정확하게 대소문자 구별하여 입력해주세요. 입력값은 검증되지 않으며, 잘못 입력 시 오류가 발생할 수 있습니다."
  Write-Host "지원하는 커뮤니티 테마의 링크 : https://github.com/morpheusthewhite/spicetify-themes"
  $ThemeName = Read-Host -Prompt 'Enter Theme name to use. '

  Write-Host "설치를 원하는 커뮤니티 테마의 color_scheme 을 입력해주세요. 입력값은 검증되지 않으며, 잘못 입력 시 오류가 발생할 수 있습니다."
  $Theme_color_scheme = Read-Host -Prompt 'Enter color_scheme of the theme to use. '
}


# Korean Settings
Write-Host ""
Write-Host "스포티파이를 한국어로 설정하시려면 이 질문에 y라고 답해 주십시오."
Write-Host "이 설정 질문은 스포티파이가 공식적으로 한국어를 지원하면 없어질 예정입니다."
do { $WantLangKorean = Read-Host -Prompt 'Do you want Spotify to be Korean? y | n ' } while ($WantLangKorean -notin @('y','n'))

# Select Plugins to use
Write-Host ""
Write-Host ""
Write-Host "추천 플러그인을 사용하시려면 이 질문에 y라고 답해 주십시오."
do { $recommendedPlugins = (Read-Host -Prompt 'Do you want to install recommended plugins? [Y]es | [N]o ').ToLower() } while ($recommendedPlugins -notin @('y','n'))

# 추천 플러그인이 Yes일때만
if ($recommendedPlugins -eq 'y') {
  Write-Host ""
  Write-Host ""
  Write-Host "Lyrics plugin provided by khanhas"
  Write-Host "https://github.com/khanhas/genius-spicetify"
  Write-Host ""
  Write-Host "genius와 musixmatch 가사 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $lyrics = (Read-Host -Prompt 'Do you want to install lyrics? [Y]es | [N]o ').ToLower() } while ($lyrics -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#auto-skip-videos"
  Write-Host ""
  Write-Host "재생 불가능한 곡이 있을때 자동으로 다음 곡을 재생하는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $autoSkipVideo = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($autoSkipVideo -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#bookmark"
  Write-Host ""
  Write-Host "북마크 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $bookmark = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($bookmark -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#christian-spotify"
  Write-Host ""
  Write-Host "explicit 노래를 무시하고 넘기는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $autoSkipExplicit = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($autoSkipExplicit -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#dj-mode"
  Write-Host ""
  Write-Host "재생 버튼을 다음 곡 예약 기능으로 바꾸는 넘기는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $djMode = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($djMode -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#full-app-display"
  Write-Host ""
  Write-Host "앨범 커버를 키우고 화면을 가득 채우는 이쁜 배경화면을 설정해주는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  Write-Host "설치 시 이 플러그인 실행버튼은 최상단에 위치하게 됩니다. 더블 클릭을 통해 닫을 수 있습니다."
  do { $fullAppDisplay = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($fullAppDisplay -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#keyboard-shortcut"
  Write-Host ""
  Write-Host "단축키 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  Write-Host "자세한 단축키 정보는 위 링크에 쓰여 있는 설명을 참고해 주세요.(영문)"
  do { $keyboardShortcut = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($keyboardShortcut -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#loopy-loop"
  Write-Host ""
  Write-Host "특정 구간만 반복재생할 수 있게 하는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $loopyLoop = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($loopyLoop -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#new-release"
  Write-Host ""
  Write-Host "원하는 아티스트의 신곡을 볼 수 있게 해주는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $newRelease = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($newRelease -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#queue-all"
  Write-Host ""
  Write-Host "특정 페이지의 모든 곡을 예약할 수 있게 해주는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $queueAll = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($queueAll -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#shuffle"
  Write-Host ""
  Write-Host "(예약곡 및 앨범 등)에서의 재생 순서를 섞을 수 있게 해주는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $shuffleplus = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($shuffleplus -notin @('y','n'))

  Write-Host ""
  Write-Host ""
  Write-Host "plugin provided by spicetify-cli"
  Write-Host "https://github.com/khanhas/spicetify-cli/wiki/Extensions#trash-bin"
  Write-Host ""
  Write-Host "특정 곡/앨범 등을 평생 다시는 안 듣게 해버릴 수 있는 플러그인을 설치하시려면 이 질문에 y라고 답해 주십시오."
  do { $trashbin = (Read-Host -Prompt 'Do you want to install this extension? [Y]es | [N]o ').ToLower() } while ($trashbin -notin @('y','n'))
}



Write-Host ""
Write-Host "스포티파이 앱의 자동 업데이트를 체크하시겠습니까?"
Write-Host "이 설정을 키면 스포티파이 앱 업데이트 후 플러그인과 테마 등이 정상 동작하지 않을 수 있습니다. = TurnOn 이라고 정확히 입력하세요."
Write-Host "이 설정을 끄면 스포티파이 앱의 자동 업데이트를 차단합니다. = 아무거나 입력하세요."
Write-Host "Spotify Installer Download : https://www.spotify.com/download"
Write-Host ""
$autoupdate = Read-Host -Prompt "Recommended answer is NOT to enter TurnOn. Which will you choose? TurnOn | enter anything "


Write-Host "모든 준비가 완료되었습니다."
$i = 5
do {
    Write-Host $i"초 후 설치가 시작됩니다."
    Sleep 1
    $i--
} while ($i -gt 0)

# ======================================= User Input Ends ======================================= #
# ======================================= Installing spicetify-cli starts here ======================================= #


# Delete Extenstions
if (Test-Path "${sp_root_dir}\Extensions") {
  spicetify restore
  DeleteFile "${sp_root_dir}\Extensions"
  DeleteFile "${sp_root_dir}\config.ini"
  New-Item -Path "${sp_root_dir}\Extensions" -ItemType Directory | Out-Null
}

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


# Theme if not default or community
if ( (-not($ThemeName -eq 'default')) -and (-not($isCommunityTheme -eq 'true')) ){
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




# If community Theme selected
} elseif ($isCommunityTheme -eq 'true') {

  # Download theme release.
  $zip_file = "${sp_theme_dir}\spicetify-themes.zip"
  $download_uri = "https://github.com/morpheusthewhite/spicetify-themes/archive/master.zip"
  Write-Part "DOWNLOADING    "; Write-Emphasized $download_uri
  Invoke-WebRequest -Uri $download_uri -UseBasicParsing -OutFile $zip_file
  Write-Done

  # Extract assets from .zip file.
  Write-Part "EXTRACTING     "; Write-Emphasized $zip_file
  Write-Part " into "; Write-Emphasized ${sp_theme_dir};
  Expand-Archive -Path $zip_file -DestinationPath $sp_theme_dir -Force
  Write-Done

  # Extract assets from .zip file.
  Write-Part "EXTRACTING     "; Write-Emphasized $zip_file
  Write-Part " into "; Write-Emphasized ${sp_theme_dir};
  Expand-Archive -Path $zip_file -DestinationPath $sp_theme_dir -Force
  Write-Done

  # copy extension if exists
  if (Test-Path "${sp_theme_dir}\spicetify-themes-master\${ThemeName}\*" -Include *.js) {
    Write-Part "MOVING all Javascript file from "; Write-Emphasized "${sp_theme_dir}\spicetify-themes-master\${ThemeName}"
    Write-Part " into "; Write-Emphasized "${sp_root_dir}\Extensions";
    Copy-Item -Force -Filter *.js "${sp_theme_dir}\spicetify-themes-master\${ThemeName}" "${sp_root_dir}\Extensions"
    Write-Done
  }

  # Delete theme if that already exists which will be installed
  DeleteFile $sp_theme_dir\$ThemeName

  #Move folder
  Write-Part "MOVING         "; Write-Emphasized "${HOME}\.spicetify\Themes\spicetify-themes-master\themes\${ThemeName}"
  Write-Part " into "; Write-Emphasized "${HOME}\.spicetify\Themes";
  Move-Item -Force "${HOME}\.spicetify\Themes\spicetify-themes-master\themes\${ThemeName}" -Destination "${HOME}\.spicetify\Themes"
  Write-Done

  # Remove .zip file.
  DeleteFile $zip_file

  # Remove git folder.
  DeleteFile "${HOME}\.spicetify\Themes\spicetify-themes-master"

  # Apply theme settings
  ApplyAllExtension
  spicetify config inject_css 1 replace_colors 1
  spicetify config current_theme $ThemeName
  spicetify config color_scheme $Theme_color_scheme



# If defualt theme
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





# If user want spicetify-cli provided extensions
if ($autoSkipVideo -eq 'y') {
  spicetify config extensions autoSkipVideo.js
}
if ($bookmark -eq 'y') {
  spicetify config extensions bookmark.js
}
if ($autoSkipExplicit -eq 'y') {
  spicetify config extensions autoSkipExplicit.js
}
if ($djMode -eq 'y') {
  spicetify config extensions djMode.js
}
if ($fullAppDisplay -eq 'y') {
  spicetify config extensions fullAppDisplay.js
}
if ($keyboardShortcut -eq 'y') {
  spicetify config extensions keyboardShortcut.js
}
if ($loopyLoop -eq 'y') {
  spicetify config extensions loopyLoop.js
}
if ($queueAll -eq 'y') {
  spicetify config extensions queueAll.js
}
if ($shuffleplus -eq 'y') {
  spicetify config extensions shuffle+.js
}
if ($trashbin -eq 'y') {
  spicetify config extensions trashbin.js
}



# If user want Spotify to be Korean
if ($WantLangKorean -eq 'y') {
  Add-Content $sp_prefpath "`nlanguage=""ko"""
}

# If user want Spotify to be updated automatically
if ($autoupdate -eq 'TurnOn') {
  spicetify config disable_upgrade_check 0
  spicetify config check_spicetify_upgrade 1
} else {
  spicetify config disable_upgrade_check 1
  spicetify config check_spicetify_upgrade 0
}



# Apply 
spicetify apply
