Spotify 한국 음악 플랫폼 테마 
========================
### [spicetify-cli](https://github.com/khanhas/spicetify-cli) 기반으로 제작되었습니다.
---

1.1. 스키마 종류
---------------
|Schema|Description
|------|---|
|melon|melon테마 입니다
|flo|추가예정
|genie|추가예정

1.2. 적용방법 ( 예
------------
```shell
cd k-spotify
mv ../k-spotify "$(dirname "$(spicetify -c)")/Themes"
spicetify config current_theme k-spotify
spicetify config color_scheme melon
spicetify apply
```
1.3. 테마 적용사진
---
> melon 테마
![initial](https://media.discordapp.net/attachments/710270749847322716/806337221723947018/unknown.png?width=924&height=489)


