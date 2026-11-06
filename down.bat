@echo off
chcp 65001 >nul
echo [1/2] Dang tu dong xuat database vao database/init/01-techstation.sql...
cmd /c "docker exec opencart_db mariadb-dump -u root -prootpassword techstation > ./database/init/01-techstation.sql"
if %errorlevel% equ 0 (
    echo -> Da chot du lieu thanh cong!
) else (
    echo -> Canh bao: Co loi khi xuat du lieu!
)

echo [2/2] Dang tat Docker Compose...
docker compose down %*
