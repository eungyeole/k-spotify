Spotify 한국 음악 플랫폼 테마 
========================
### [spicetify-cli](https://github.com/khanhas/spicetify-cli) 기반으로 제작되었습니다.
---

1.1. 테마 종류
---------------
|Schema|Description
|------|---|
|melon|melon테마 입니다.
|flo|flo테마 입니다.
|vibe|Beta

1.2. 적용방법 ( 예
------------
### 1.2.1 mac 설치
```shell
cd k-spotify
mv ./extensions/dribbblish.js "$(dirname "$(spicetify -c)")/Extensions"
mv ./melon "$(dirname "$(spicetify -c)")/Themes"
spicetify config current_theme melon
spicetify config color_scheme melon
spicetify apply
```
### 1.2.2 windows 자동화 설치
Windows Powershell에서 아래 명령어 실행  
Windows Powershell 실행 방법 : Windows 버튼에 마우스 우클릭 - Windows Powershell 클릭
```powershell
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/eungyeole/k-spotify/master/scripts/windows-install.ps1" | Invoke-Expression
```
1.3. 테마 적용사진
---
> melon 테마
![initial](https://media.discordapp.net/attachments/710270749847322716/806337221723947018/unknown.png?width=924&height=489)

>flo 테마
![initial](https://media.discordapp.net/attachments/710270749847322716/806396243043418152/unknown.png?width=948&height=490)


