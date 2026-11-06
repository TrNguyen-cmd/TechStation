param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ArgsList
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Continue"

# Kiem tra xem container MariaDB co dang chay khong
$dbRunning = docker ps -q --filter "name=opencart_db" --filter "status=running"

if ($dbRunning) {
    Write-Host "[1/2] Dang tu dong xuat database vao database/init/01-techstation.sql..." -ForegroundColor Cyan
    cmd /c "docker exec opencart_db mariadb-dump -u root -prootpassword techstation > ./database/init/01-techstation.sql"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "-> Da chot du lieu thanh cong!" -ForegroundColor Green
    } else {
        Write-Host "-> Canh bao: Khong the xuat du lieu, kiem tra lai container!" -ForegroundColor Yellow
    }
} else {
    Write-Host "[1/2] Container opencart_db khong chay, bo qua buoc xuat du lieu." -ForegroundColor DarkGray
}

Write-Host "[2/2] Dang tat Docker Compose..." -ForegroundColor Cyan
docker compose down @ArgsList
