Spotify 한국 음악 플랫폼 테마 
========================
1.1. 스키마 종류
---------------
|Schema|Description
|------|---|
|melon|melon테마 입니다

1.2. 적용방법 ( 예
------------
```shell
cd k-spotify
mv ../k-spotify "$(dirname "$(spicetify -c)")/Themes"
spicetify config current_theme k-spotify
spicetify config color_scheme melon
spicetify apply
```


