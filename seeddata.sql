USE QLBenhVien;
GO

-- Thêm dữ liệu vào bảng THONGTIN_CANHAN
INSERT INTO THONGTIN_CANHAN (maNhanVien, hoTen, ngaySinh, diaChi, soDienThoai, email, luongCoBan, phuCap)
VALUES 
    ('NV001', N'Nguyễn Văn An', '1985-03-15', N'123 Đường Láng, Hà Nội', '0987654321', 'an.nguyen@example.com', 
     CONVERT(VARBINARY(MAX), 15000000), CONVERT(VARBINARY(MAX), 2000000)),
    ('NV002', N'Trần Thị Bình', '1990-07-22', N'456 Lê Lợi, TP.HCM', '0912345678', 'binh.tran@example.com', 
     CONVERT(VARBINARY(MAX), 18000000), CONVERT(VARBINARY(MAX), 2500000)),
    ('NV003', N'Phạm Minh Châu', '1988-11-10', N'789 Trần Hưng Đạo, Đà Nẵng', '0935123456', 'chau.pham@example.com', 
     CONVERT(VARBINARY(MAX), 20000000), CONVERT(VARBINARY(MAX), 3000000));

-- Cập nhật userID trong bảng ACCOUNT
UPDATE ACCOUNT
SET userID = 'NV001'
WHERE username = 'bs1';

UPDATE ACCOUNT
SET userID = 'NV002'
WHERE username = 'bs2';

-- Thêm dữ liệu vào bảng PHONGBAN
INSERT INTO PHONGBAN (maPhongBan, tenPhongBan)
VALUES 
    ('PB001', N'Phòng Hành Chính'),
    ('PB002', N'Phòng Kế Toán'),
    ('PB003', N'Phòng Nhân Sự');

-- Thêm dữ liệu vào bảng KHOA
INSERT INTO KHOA (maKhoa, tenKhoa)
VALUES 
    ('K001', N'Khoa Nội'),
    ('K002', N'Khoa Ngoại'),
    ('K003', N'Khoa Nhi');

-- Thêm dữ liệu vào bảng PHONGKHAM
INSERT INTO PHONGKHAM (maPhongKham, tenPhongKham, maKhoa)
VALUES 
    ('PK001', N'Phòng Khám Nội 1', 'K001'),
    ('PK002', N'Phòng Khám Ngoại 1', 'K002'),
    ('PK003', N'Phòng Khám Nhi 1', 'K003');

-- Thêm dữ liệu vào bảng NHANVIEN
INSERT INTO NHANVIEN (maNhanVien, maPhongBan, chucVu)
VALUES 
    ('NV001', 'PB001', 'QL'),
    ('NV002', 'PB002', 'NV'),
    ('NV003', 'PB003', 'TP');

-- Thêm dữ liệu vào bảng BACSI
INSERT INTO BACSI (maBacSi, maKhoa, chuyenMon)
VALUES 
    ('NV001', 'K001', 'Nội tổng quát'),
    ('NV002', 'K002', 'Ngoại tổng quát');

-- Thêm dữ liệu vào bảng CHAMCONG
INSERT INTO CHAMCONG (maNhanVien, ngayChamCong, gioVao, gioRa, ghiChu)
VALUES 
    ('NV001', '2025-04-27', '08:00:00', '17:00:00', N'Đúng giờ'),
    ('NV002', '2025-04-27', '08:30:00', '17:30:00', N'Đi muộn 30 phút'),
    ('NV003', '2025-04-27', '07:45:00', '16:45:00', N'Về sớm 15 phút');

-- Thêm dữ liệu vào bảng LICH_LAMVIEC
INSERT INTO LICH_LAMVIEC (maBacSi, maPhongKham, ngayTruc, gioBatDau, gioKetThuc, ghiChu)
VALUES 
    ('NV001', 'PK001', '2025-04-28', '08:00:00', '12:00:00', N'Ca sáng'),
    ('NV002', 'PK002', '2025-04-28', '13:00:00', '17:00:00', N'Ca chiều');

-- Thêm dữ liệu vào bảng BENHNHAN
INSERT INTO BENHNHAN (maBenhNhan, hoTen, namSinh, diaChi, soDienThoai)
VALUES 
    ('BN001', N'Lê Văn Hùng', 1995, N'321 Nguyễn Huệ, Hà Nội', '0971234567'),
    ('BN002', N'Nguyễn Thị Mai', 1980, N'654 Phạm Văn Đồng, TP.HCM', '0989876543');

-- Thêm dữ liệu vào bảng DICHVU
INSERT INTO DICHVU (tenDichVu)
VALUES 
    (N'Khám tổng quát'),
    (N'Xét nghiệm máu'),
    (N'Chụp X-quang');

-- Thêm dữ liệu vào bảng DONGIA_DICHVU
INSERT INTO DONGIA_DICHVU (maDichVu, donGia, ngayApDung)
VALUES 
    (1, 200000, '2025-01-01'),
    (2, 300000, '2025-01-01'),
    (3, 500000, '2025-01-01');

-- Thêm dữ liệu vào bảng KHAMBENH
INSERT INTO KHAMBENH (maBenhNhan, maBacSi, maPhongKham, ngayKham, trieuChung, chanDoanCuoiCung)
VALUES 
    ('BN001', 'NV001', 'PK001', '2025-04-27 10:00:00', 
     CONVERT(VARBINARY(MAX), N'Sốt, đau họng'), 
     CONVERT(VARBINARY(MAX), N'Viêm họng cấp')),
    ('BN002', 'NV002', 'PK002', '2025-04-27 14:00:00', 
     CONVERT(VARBINARY(MAX), N'Đau bụng'), 
     CONVERT(VARBINARY(MAX), N'Viêm dạ dày'));

-- Thêm dữ liệu vào bảng CHITIET_KHAMBENH
INSERT INTO CHITIET_KHAMBENH (maKhamBenh, maDichVu, TrangThai)
VALUES 
    (1, 1, N'ĐÃ_THỰC_HIỆN'),
    (1, 2, N'ĐÃ_THỰC_HIỆN'),
    (2, 1, N'ĐÃ_THỰC_HIỆN');

-- Thêm dữ liệu vào bảng THUOC
INSERT INTO THUOC (maThuoc, tenThuoc, donViTinh, thongTin, soLuongTon)
VALUES 
    ('T001', N'Paracetamol', N'Viên', N'Giảm đau, hạ sốt', 1000),
    ('T002', N'Amoxicillin', N'Viên', N'Kháng sinh', 500);

-- Thêm dữ liệu vào bảng DONGIA_THUOC
INSERT INTO DONGIA_THUOC (maThuoc, donGia, ngayApDung)
VALUES 
    ('T001', 2000, '2025-01-01'),
    ('T002', 5000, '2025-01-01');

-- Thêm dữ liệu vào bảng TOATHUOC
INSERT INTO TOATHUOC (maKhamBenh)
VALUES 
    (1),
    (2);

-- Thêm dữ liệu vào bảng CHITIET_TOATHUOC
INSERT INTO CHITIET_TOATHUOC (maToaThuoc, maThuoc, soLuong, lieuDung)
VALUES 
    (1, 'T001', 10, N'2 viên/ngày'),
    (1, 'T002', 14, N'1 viên/ngày'),
    (2, 'T001', 5, N'1 viên/ngày');

-- Thêm dữ liệu vào bảng HOADON
INSERT INTO HOADON (tongTien, loaiHoaDon, maKhamBenh, nhanVienThu)
VALUES 
    (700000, 'KHAMBENH', 1, 'NV003'),
    (200000, 'KHAMBENH', 2, 'NV003');

-- Thêm dữ liệu vào bảng CHITIET_HOADON_THUOC
INSERT INTO CHITIET_HOADON_THUOC (maHoaDon, maThuoc, donGia, donViTinh, soLuong)
VALUES 
    (1, 'T001', 2000, N'Viên', 10),
    (1, 'T002', 5000, N'Viên', 14);

-- Thêm dữ liệu vào bảng CHITIET_HOADON_KHAMCHUABENH
INSERT INTO CHITIET_HOADON_KHAMCHUABENH (maHoaDon, maDichVu, donGia)
VALUES 
    (1, 1, 200000),
    (1, 2, 300000),
    (2, 1, 200000);

-- Thêm dữ liệu vào bảng LOGGING
INSERT INTO LOGGING (maThaoTac, maTaiKhoan, bang, hanhDong, chiTiet)
VALUES 
    ('LG001', 'bs1', 'KHAMBENH', 'INSERT', N'Thêm mới phiếu khám bệnh cho bệnh nhân BN001'),
    ('LG002', 'bs2', 'TOATHUOC', 'INSERT', N'Thêm mới toa thuốc cho bệnh nhân BN002');