# TechStation - OpenCart 4 Docker Environment

Dự án triển khai mã nguồn **OpenCart 4 (TechStation)** chạy trên nền tảng **Docker & Docker Compose**, được tối ưu hóa cấu trúc thư mục, quản lý biến môi trường qua `.env` và hỗ trợ MariaDB + phpMyAdmin.

---

## 1. Cấu trúc thư mục dự án

```text
OpenCart_docker/
├── .env.example                  # Template biến môi trường mẫu
├── .env                          # Biến môi trường cục bộ (không commit lên Git)
├── .gitignore                    # Cấu hình bỏ qua file tạm, cache, logs, .env
├── .dockerignore                 # Tối ưu dung lượng và tốc độ build Docker
├── docker-compose.yml            # Điều phối các containers (App, DB, phpMyAdmin)
├── README.md                     # Tài liệu hướng dẫn dự án
│
├── database/                     # Chứa tài nguyên cơ sở dữ liệu
│   └── init/
│       └── 01-techstation.sql    # File SQL khởi tạo dữ liệu ban đầu
│
├── docker/                       # Cấu hình môi trường Docker
│   └── php/
│       ├── Dockerfile            # Image PHP 8.2 Apache + extensions OpenCart
│       ├── docker-entrypoint.sh  # Script cấp quyền www-data tự động
│       └── php.ini               # Cấu hình PHP (upload limit, memory, opcache)
│
├── storage/                      # Thư mục lưu trữ ngoài web root của OpenCart
│   ├── cache/                    # Template cache
│   ├── logs/                     # File log hệ thống
│   ├── session/                  # Phiên người dùng
│   └── upload/                   # File tải lên từ hệ thống
│
└── TechStation/                  # Web root (DocumentRoot) chứa source code OpenCart
    ├── QTV/                      # Thư mục quản trị Admin (mặc định)
    │   └── config.php            # Cấu hình Admin (hỗ trợ đọc từ .env)
    ├── catalog/                  # Giao diện người dùng (Storefront)
    ├── extension/                # Modules & Extensions
    ├── image/                    # Hình ảnh sản phẩm, banner
    ├── system/                   # Core system của OpenCart
    └── config.php                # Cấu hình Storefront (hỗ trợ đọc từ .env)
```

---

## 2. Yêu cầu hệ thống

- Đã cài đặt **Docker Desktop** (hoặc Docker Engine + Docker Compose v2).
- Khuyến nghị sử dụng **WSL2** trên Windows để đạt hiệu năng file I/O tốt nhất.

---

## 3. Hướng dẫn khởi chạy nhanh

### Bước 1: Thiết lập biến môi trường
Nếu chưa có file `.env`, tạo từ template `.env.example`:

```bash
# Trên PowerShell / CMD:
Copy-Item .env.example .env

# Hoặc trên Linux / Git Bash / macOS:
cp .env.example .env
```

### Bước 2: Khởi chạy các container bằng Docker Compose

```bash
docker compose up -d --build
```

---

## 4. Thông tin truy cập dịch vụ

| Dịch vụ | Địa chỉ truy cập | Thông tin đăng nhập |
| :--- | :--- | :--- |
| **Website OpenCart (Storefront)** | [http://localhost:8081](http://localhost:8081) | Khách truy cập trực tiếp |
| **Trang Quản trị (Admin)** | [http://localhost:8081/QTV/](http://localhost:8081/QTV/) | **Username:** `QTV` |
| **phpMyAdmin** | [http://localhost:8082](http://localhost:8082) | **Server:** `db`<br>**User:** `root`<br>**Password:** `rootpassword` |
| **Cổng kết nối MySQL ngoài host** | `localhost:3307` | **Database:** `techstation` |

---

## 5. Cấu hình biến môi trường (`.env`)

Mọi thông số về cổng mạng, thông tin DB, URL đều có thể tùy biến dễ dàng trong `.env`:

```ini
# Cổng truy cập từ máy host
APP_PORT=8081
PMA_PORT=8082
DB_PORT_EXTERNAL=3307

# Thông tin Database nội bộ
DB_HOST=db
DB_PORT=3306
DB_NAME=techstation
DB_ROOT_PASSWORD=rootpassword
DB_USER=root
DB_PASSWORD=rootpassword
DB_PREFIX=oc_

# URLs
HTTP_SERVER=http://localhost:8081/
HTTP_ADMIN=http://localhost:8081/QTV/
```

> **Lưu ý:** Khi đổi `APP_PORT` (ví dụ thành `8080`), hãy nhớ cập nhật lại `HTTP_SERVER` và `HTTP_ADMIN` trong `.env` tương ứng: `http://localhost:8080/`.

---

## 6. Các lệnh thao tác thường dùng

- **Xem trạng thái các container:**
  ```bash
  docker compose ps
  ```

- **Xem logs thời gian thực:**
  ```bash
  docker compose logs -f opencart
  ```

- **Dừng các container:**
  ```bash
  docker compose down
  ```

- **Build lại container khi sửa Dockerfile hoặc php.ini:**
  ```bash
  docker compose up -d --build --force-recreate
  ```

- **Vào bên trong container ứng dụng OpenCart:**
  ```bash
  docker compose exec opencart bash
  ```

- **Sao lưu (Backup) Database ra file SQL:**
  ```bash
  docker compose exec db mariadb-dump -u root -prootpassword techstation > database/backup_$(date +%Y%m%d_%H%M%S).sql
  ```

---

## 7. Khắc phục sự cố thường gặp (Troubleshooting)

1. **Xung đột cổng mạng (`Port already allocated`):**
   - Đổi `APP_PORT`, `PMA_PORT` hoặc `DB_PORT_EXTERNAL` trong file `.env` thành cổng khác chưa sử dụng (ví dụ: `8085`, `8086`, `3308`).
   - Chạy lại `docker compose up -d`.

2. **Lỗi quyền ghi cache hoặc hình ảnh:**
   - Script `docker-entrypoint.sh` đã tự động phân quyền `www-data:www-data` mỗi khi container khởi động.
   - Nếu cần reset thủ công:
     ```bash
     docker compose exec opencart chown -R www-data:www-data /var/www/storage /var/www/html/image
     ```
