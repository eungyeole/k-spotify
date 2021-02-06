$body = [System.Text.Encoding]::UTF8.GetBytes($body);

$headers = @{
            "Content-Type"="text/plain; charset=utf-8";
        };

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/eungyeole/k-spotify/master/scripts/windows-install-powershell-script.ps1' -Method GET -Body $postData -ContentType "text/plain; charset=utf-8"