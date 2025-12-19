# Protector_BMCSDL - Hệ Thống Quản Lý Bệnh Viện (Hospital Management System)

## Giới thiệu (Introduction)
Hệ thống quản lý bệnh viện với các chức năng: quản lý bệnh nhân, khám bệnh, tài vụ, và điều phối. Ứng dụng ASP.NET Core MVC với SQL Server, tích hợp Azure Key Vault để bảo mật thông tin nhạy cảm.

Hospital Management System with features for patient management, medical examination, finance, and coordination. Built with ASP.NET Core MVC and SQL Server, integrated with Azure Key Vault for secure credential management.

## Yêu cầu hệ thống (System Requirements)
- .NET 8.0 SDK
- SQL Server 2019 or later
- Visual Studio 2022 or VS Code
- Azure CLI
- Azure account with Key Vault access

## Hướng dẫn cài đặt (Installation Guide)

### 1. Cài đặt Azure CLI (Install Azure CLI)
Tải và cài đặt Azure CLI từ:
https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows

### 2. Tạo tài khoản Azure (Create Azure Account)
Tạo tài khoản Microsoft Azure nếu chưa có.

### 3. Chờ được cấp quyền truy cập Key Vault (Wait for Key Vault Access)
Liên hệ quản trị viên để được thêm vào Azure Key Vault.

### 4. Đăng nhập Azure CLI (Login to Azure CLI)
Mở CMD và chạy:
```bash
az login
```
Đăng nhập vào tài khoản Azure đã tạo ở bước 2.

### 5. Thêm Azure CLI vào biến môi trường (Add Azure CLI to Environment Variables)
1. Chạy `az --version` trong CMD
2. Copy đường dẫn hiển thị
3. Tìm "Edit the system environment variables" trên máy
4. Chọn Advanced → Environment Variables → System Variables
5. Chọn Path → Edit → New
6. Dán đường dẫn vào → OK
7. Restart máy

### 6. Cài đặt cơ sở dữ liệu (Database Setup)

#### Bước 1: Tạo Database và Account Database
```sql
-- Chạy file để tạo database chính
SQL\database\QUANLIBENHVIEN.sql

-- Chạy file để tạo account database
SQL\database\CREATE_DATABASE_ACCOUNT.sql
```

#### Bước 2: Import dữ liệu mẫu (Optional)
```sql
-- Dữ liệu mẫu cho Account
SQL\DataMau\AccountQLBenhVien.sql

-- Dữ liệu mẫu cho Database chính
SQL\DataMau\QLBenhVien.sql
```

#### Bước 3: Cài đặt Security và Audit
```sql
-- Tạo Certificate
SQL\Scipt_HeThong\TaoCert.sql

-- Tạo User và phân quyền
SQL\Scipt_HeThong\USER_SQL.sql

-- Cài đặt Audit
SQL\Audit\Audit.sql

-- Backup và Restore procedures
SQL\Audit\Backup.sql
SQL\Audit\Restore.sql
```

#### Bước 4: Cài đặt Stored Procedures và Views theo từng module

**Module Admin:**
```sql
SQL\Admin\SP_TaoKeyTK.sql
SQL\Admin\SP_View_AdminQuanLyAccount.sql
```

**Module Bác Sĩ (Doctor):**
```sql
SQL\BacSi\*.sql
```

**Module Điều Phối (Coordinator):**
```sql
SQL\DieuPhoi\*.sql
```

**Module Tài Vụ (Cashier):**
```sql
SQL\TaiVu\*.sql
```

**Module Quản Lý Tài Vụ (Finance Manager):**
```sql
SQL\QLTaiVu\*.sql
```

**Scripts Hệ Thống:**
```sql
SQL\Scipt_HeThong\sp_DangNhap.sql
SQL\Scipt_HeThong\SP_DoiMatKhau.sql
SQL\Scipt_HeThong\SP_CheckLich_LayMaPhongKham.sql
```

### 7. Cấu hình ứng dụng (Application Configuration)

1. Mở solution trong Visual Studio:
   ```
   QLBenhVien\QLBenhVien.sln
   ```

2. Cấu hình connection string trong `appsettings.json` (nếu cần)

3. Build solution:
   ```bash
   dotnet build
   ```

4. Chạy ứng dụng:
   ```bash
   dotnet run --project QLBenhVien\QLBenhVien\QLBenhVien.csproj
   ```

## Cấu trúc dự án (Project Structure)

```
Protector_BMCSDL/
├── SQL/                          # SQL Scripts
│   ├── database/                 # Database creation scripts
│   ├── DataMau/                  # Sample data
│   ├── Admin/                    # Admin module scripts
│   ├── BacSi/                    # Doctor module scripts
│   ├── DieuPhoi/                 # Coordinator module scripts
│   ├── TaiVu/                    # Cashier module scripts
│   ├── QLTaiVu/                  # Finance Manager module scripts
│   ├── Scipt_HeThong/            # System scripts
│   └── Audit/                    # Audit and security scripts
└── QLBenhVien/                   # ASP.NET Core MVC Application
    └── QLBenhVien/
        ├── Controllers/          # MVC Controllers
        ├── Models/               # View Models
        ├── Entities/             # Entity Framework entities
        ├── Services/             # Business logic and services
        └── ViewModels/           # View-specific models
```

## Các chức năng chính (Main Features)

### 1. Quản lý tài khoản (Account Management)
- Tạo, xóa, cập nhật tài khoản nhân viên
- Phân quyền truy cập
- Quản lý thông tin cá nhân

### 2. Module Điều Phối (Coordinator Module)
- Đăng ký bệnh nhân mới
- Phân phòng khám cho bệnh nhân
- Xem danh sách phòng khám theo khoa và dịch vụ

### 3. Module Bác Sĩ (Doctor Module)
- Xem danh sách bệnh nhân trong ngày
- Khám bệnh và lưu kết quả
- Kê đơn thuốc
- Chỉ định xét nghiệm

### 4. Module Tài Vụ (Cashier Module)
- Tạo hóa đơn khám chữa bệnh
- Thanh toán hóa đơn
- Xem chi tiết hóa đơn

### 5. Module Quản Lý Tài Vụ (Finance Manager Module)
- Quản lý đơn giá dịch vụ
- Thêm, xóa, cập nhật giá dịch vụ
- Xem lịch sử thay đổi giá

### 6. Bảo mật (Security Features)
- Mã hóa dữ liệu nhạy cảm (lương, đơn giá)
- Audit logging cho các thao tác quan trọng
- Azure Key Vault integration
- Certificate-based authentication

## Tài khoản mẫu (Sample Accounts)
Sau khi import dữ liệu mẫu, có thể sử dụng các tài khoản sau để đăng nhập:

(Xem file `SQL\DataMau\AccountQLBenhVien.sql` để biết chi tiết các tài khoản)

## Xử lý sự cố (Troubleshooting)

### Lỗi kết nối Azure Key Vault
- Đảm bảo đã chạy `az login` và đăng nhập thành công
- Kiểm tra quyền truy cập Key Vault
- Restart ứng dụng sau khi đăng nhập Azure CLI

### Lỗi kết nối SQL Server
- Kiểm tra SQL Server đã được khởi động
- Xác nhận connection string trong `appsettings.json`
- Kiểm tra user có quyền truy cập database

### Lỗi mã hóa/giải mã dữ liệu
- Đảm bảo đã chạy script `TaoCert.sql`
- Kiểm tra certificate còn hiệu lực
- Verify Key Vault credentials

## Đóng góp (Contributing)
Vui lòng tạo issue hoặc pull request nếu phát hiện lỗi hoặc muốn đóng góp cải tiến.

## Giấy phép (License)
