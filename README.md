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
|genie|추가예정

1.2. 적용방법 ( 예
------------
### 1.2.1 mac 설치
```shell
cd k-spotify
mv ./melon/dribbblish.js "$(dirname "$(spicetify -c)")/Extensions"
mv ./melon "$(dirname "$(spicetify -c)")/Themes"
spicetify config current_theme melon
spicetify config color_scheme melon
spicetify apply
```
### 1.2.2 windows 자동화 설치 | 제작 : [SJang1](https://github.com/SJang1)

```shell
Invoke-WebRequest -UseBasicParsing "https://gist.githubusercontent.com/SJang1/b2f48fbf4c58fa112a57da8b1f18f45b/raw/K-Spicetify-Win.ps1" | Invoke-Expression
```
1.3. 테마 적용사진
---
> melon 테마
![initial](https://media.discordapp.net/attachments/710270749847322716/806337221723947018/unknown.png?width=924&height=489)

>flo 테마
![initial](https://media.discordapp.net/attachments/710270749847322716/806396243043418152/unknown.png?width=948&height=490)


