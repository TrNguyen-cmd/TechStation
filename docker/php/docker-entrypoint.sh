#!/bin/bash
set -e

# Đảm bảo các thư mục runtime tồn tại
mkdir -p /var/www/storage/cache/template \
         /var/www/storage/download \
         /var/www/storage/logs \
         /var/www/storage/session \
         /var/www/storage/upload \
         /var/www/html/image/cache

# Cấp quyền ghi cho các thư mục chính (tránh đệ quy -R trên 5,000+ files để khởi động tức thì)
chmod 777 /var/www/storage /var/www/storage/* /var/www/html/image/cache 2>/dev/null || true

exec "$@"
