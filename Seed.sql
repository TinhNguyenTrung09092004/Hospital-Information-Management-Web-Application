USE QLBenhVien;
GO

INSERT INTO PERMISSION (permissionName) VALUES 
    (N'Modify_PhongBan'),                -- 1: Quản lý phòng ban
    (N'Modify_Khoa'),                    -- 2: Quản lý khoa
    (N'Modify_BacSi'),                   -- 3: Quản lý bác sĩ
    (N'Modify_NhanVien'),                -- 4: Quản lý nhân viên
    (N'Modify_LichLamViec'),             -- 5: Quản lý lịch làm việc
    (N'View_ChamCong'),                  -- 6: Xem chấm công
    (N'View_Luong'),                     -- 7: Xem lương
    (N'Modify_DonGia'),                  -- 8: Quản lý đơn giá dịch vụ/thuốc
    (N'View_All'),                       -- 9: Xem tất cả thông tin (quản lý chuyên môn)
    (N'Modify_BenhNhan'),                -- 10: Quản lý bệnh nhân
    (N'Modify_KhamBenh'),                -- 11: Quản lý khám bệnh
    (N'View_ToaThuoc'),                  -- 12: Xem toa thuốc (nhân viên bán thuốc)
    (N'Modify_HoaDon');                  -- 13: Quản lý hóa đơn (phòng tài vụ)

INSERT INTO THONGTIN_CANHAN (maNhanVien, hoTen, ngaySinh, diaChi, soDienThoai, email, luongCoBan, phuCap)
VALUES 
    ('NV001', N'Nguyễn Văn An', '1985-03-15', N'123 Đường Láng, Hà Nội', '0987654321', 'an.nguyen@example.com', 
     CONVERT(VARBINARY(MAX), 15000000), CONVERT(VARBINARY(MAX), 2000000)), -- Quản lý nhân sự
    ('NV002', N'Trần Thị Bình', '1990-07-22', N'456 Lê Lợi, TP.HCM', '0912345678', 'binh.tran@example.com', 
     CONVERT(VARBINARY(MAX), 18000000), CONVERT(VARBINARY(MAX), 2500000)), -- Bác sĩ
    ('NV003', N'Phạm Minh Châu', '1988-11-10', N'789 Trần Hưng Đạo, Đà Nẵng', '0935123456', 'chau.pham@example.com', 
     CONVERT(VARBINARY(MAX), 20000000), CONVERT(VARBINARY(MAX), 3000000)), -- Nhân viên tài vụ
    ('NV004', N'Lê Văn Đức', '1987-05-20', N'101 Nguyễn Trãi, Hà Nội', '0971234567', 'duc.le@example.com', 
     CONVERT(VARBINARY(MAX), 12000000), CONVERT(VARBINARY(MAX), 1500000)), -- Nhân viên tiếp tân
    ('NV005', N'Nguyễn Thị Hoa', '1992-09-15', N'202 Phạm Văn Đồng, TP.HCM', '0989876543', 'hoa.nguyen@example.com', 
     CONVERT(VARBINARY(MAX), 10000000), CONVERT(VARBINARY(MAX), 1000000)), -- Nhân viên bán thuốc
    ('NV006', N'Hoàng Văn Nam', '1983-12-01', N'303 Trần Phú, Đà Nẵng', '0961234567', 'nam.hoang@example.com', 
     CONVERT(VARBINARY(MAX), 22000000), CONVERT(VARBINARY(MAX), 3500000)); -- Quản lý chuyên môn

INSERT INTO ACCOUNT (username, passwordHash, userID) VALUES 
    ('qlns1', HASHBYTES('SHA2_256', '123'), 'NV001'), -- Quản lý nhân sự
    ('bs1', HASHBYTES('SHA2_256', '123'), 'NV002'),   -- Bác sĩ
    ('taivu1', HASHBYTES('SHA2_256', '123'), 'NV003'), -- Nhân viên tài vụ
    ('tieptan1', HASHBYTES('SHA2_256', '123'), 'NV004'), -- Nhân viên tiếp tân
    ('banthuoc1', HASHBYTES('SHA2_256', '123'), 'NV005'), -- Nhân viên bán thuốc
    ('qlcm1', HASHBYTES('SHA2_256', '123'), 'NV006'); -- Quản lý chuyên môn

INSERT INTO ACCOUNT_PERMISSION (username, permissionID) VALUES 
    ('qlns1', 1), ('qlns1', 2), ('qlns1', 3), ('qlns1', 4), ('qlns1', 5), ('qlns1', 6), ('qlns1', 7), -- Quản lý nhân sự
    ('bs1', 11), -- Bác sĩ chỉ sửa thông tin khám bệnh
    ('taivu1', 8), ('taivu1', 13), -- Nhân viên tài vụ quản lý đơn giá và hóa đơn
    ('tieptan1', 10), -- Nhân viên tiếp tân quản lý bệnh nhân
    ('banthuoc1', 12), -- Nhân viên bán thuốc xem toa thuốc
    ('qlcm1', 9); -- Quản lý chuyên môn xem tất cả

INSERT INTO PHONGBAN (maPhongBan, tenPhongBan)
VALUES 
    ('PB001', N'Phòng Hành Chính'),
    ('PB002', N'Phòng Tài Vụ'),
    ('PB003', N'Phòng Nhân Sự'),
    ('PB004', N'Phòng Bán Thuốc'),
    ('PB005', N'Phòng Tiếp Tân');

INSERT INTO KHOA (maKhoa, tenKhoa)
VALUES 
    ('K001', N'Khoa Nội'),
    ('K002', N'Khoa Ngoại'),
    ('K003', N'Khoa Nhi');

INSERT INTO PHONGKHAM (maPhongKham, tenPhongKham, maKhoa)
VALUES 
    ('PK001', N'Phòng Khám Nội 1', 'K001'),
    ('PK002', N'Phòng Khám Ngoại 1', 'K002'),
    ('PK003', N'Phòng Khám Nhi 1', 'K003');

INSERT INTO NHANVIEN (maNhanVien, maPhongBan, chucVu)
VALUES 
    ('NV001', 'PB003', 'QL'), -- Quản lý nhân sự
    ('NV002', NULL, 'BS'), -- Bác sĩ
    ('NV003', 'PB002', 'NV'), -- Nhân viên tài vụ
    ('NV004', 'PB005', 'NV'), -- Nhân viên tiếp tân
    ('NV005', 'PB004', 'NV'), -- Nhân viên bán thuốc
    ('NV006', 'PB001', 'QL'); -- Quản lý chuyên môn

INSERT INTO BACSI (maBacSi, maKhoa, chuyenMon)
VALUES 
    ('NV002', 'K001', N'Nội tổng quát');

INSERT INTO CHAMCONG (maNhanVien, ngayChamCong, gioVao, gioRa, ghiChu)
VALUES 
    ('NV001', '2025-04-27', '08:00:00', '17:00:00', N'Đúng giờ'),
    ('NV002', '2025-04-27', '08:30:00', '17:30:00', N'Đi muộn 30 phút'),
    ('NV003', '2025-04-27', '07:45:00', '16:45:00', N'Về sớm 15 phút'),
    ('NV004', '2025-04-27', '08:00:00', '17:00:00', N'Đúng giờ'),
    ('NV005', '2025-04-27', '08:00:00', '17:00:00', N'Đúng giờ'),
    ('NV006', '2025-04-27', '08:00:00', '17:00:00', N'Đúng giờ');

INSERT INTO LICH_LAMVIEC (maBacSi, maPhongKham, ngayTruc, gioBatDau, gioKetThuc, ghiChu)
VALUES 
    ('NV002', 'PK001', '2025-04-28', '08:00:00', '12:00:00', N'Ca sáng');

INSERT INTO BENHNHAN (maBenhNhan, hoTen, namSinh, diaChi, soDienThoai)
VALUES 
    ('BN001', N'Lê Văn Hùng', 1995, N'321 Nguyễn Huệ, Hà Nội', '0971234567'),
    ('BN002', N'Nguyễn Thị Mai', 1980, N'654 Phạm Văn Đồng, TP.HCM', '0989876543');

INSERT INTO DICHVU (tenDichVu)
VALUES 
    (N'Khám tổng quát'),
    (N'Xét nghiệm máu'),
    (N'Chụp X-quang');

INSERT INTO DONGIA_DICHVU (maDichVu, donGia, ngayApDung)
VALUES 
    (1, 200000, '2025-01-01'),
    (2, 300000, '2025-01-01'),
    (3, 500000, '2025-01-01');

INSERT INTO KHAMBENH (maBenhNhan, maBacSi, maPhongKham, ngayKham, trieuChung, chanDoanCuoiCung)
VALUES 
    ('BN001', 'NV002', 'PK001', '2025-04-27 10:00:00', 
     CONVERT(VARBINARY(MAX), N'Sốt, đau họng'), 
     CONVERT(VARBINARY(MAX), N'Viêm họng cấp')),
    ('BN002', 'NV002', 'PK002', '2025-04-27 14:00:00', 
     CONVERT(VARBINARY(MAX), N'Đau bụng'), 
     CONVERT(VARBINARY(MAX), N'Viêm dạ dày'));

INSERT INTO CHITIET_KHAMBENH (maKhamBenh, maDichVu, TrangThai)
VALUES 
    (1, 1, N'ĐÃ_THỰC_HIỆN'),
    (1, 2, N'ĐÃ_THỰC_HIỆN'),
    (2, 1, N'ĐÃ_THỰC_HIỆN');

INSERT INTO THUOC (maThuoc, tenThuoc, donViTinh, thongTin, soLuongTon)
VALUES 
    ('T001', N'Paracetamol', N'Viên', N'Giảm đau, hạ sốt', 1000),
    ('T002', N'Amoxicillin', N'Viên', N'Kháng sinh', 500);

INSERT INTO DONGIA_THUOC (maThuoc, donGia, ngayApDung)
VALUES 
    ('T001', 2000, '2025-01-01'),
    ('T002', 5000, '2025-01-01');

INSERT INTO TOATHUOC (maKhamBenh)
VALUES 
    (1),
    (2);

INSERT INTO CHITIET_TOATHUOC (maToaThuoc, maThuoc, soLuong, lieuDung)
VALUES 
    (1, 'T001', 10, N'2 viên/ngày'),
    (1, 'T002', 14, N'1 viên/ngày'),
    (2, 'T001', 5, N'1 viên/ngày');

INSERT INTO HOADON (tongTien, loaiHoaDon, maKhamBenh, nhanVienThu)
VALUES 
    (700000, 'KHAMBENH', 1, 'NV003'),
    (200000, 'KHAMBENH', 2, 'NV003');

INSERT INTO CHITIET_HOADON_THUOC (maHoaDon, maThuoc, donGia, donViTinh, soLuong)
VALUES 
    (1, 'T001', 2000, N'Viên', 10),
    (1, 'T002', 5000, N'Viên', 14);

INSERT INTO CHITIET_HOADON_KHAMCHUABENH (maHoaDon, maDichVu, donGia)
VALUES 
    (1, 1, 200000),
    (1, 2, 300000),
    (2, 1, 200000);

INSERT INTO LOGGING (maThaoTac, maTaiKhoan, bang, hanhDong, chiTiet)
VALUES 
    ('LG001', 'bs1', 'KHAMBENH', 'INSERT', N'Thêm mới phiếu khám bệnh cho bệnh nhân BN001'),
    ('LG002', 'bs1', 'TOATHUOC', 'INSERT', N'Thêm mới toa thuốc cho bệnh nhân BN002'),
    ('LG003', 'taivu1', 'HOADON', 'INSERT', N'Thêm mới hóa đơn cho bệnh nhân BN001'),
    ('LG004', 'tieptan1', 'BENHNHAN', 'INSERT', N'Thêm mới bệnh nhân BN002');
GO

CREATE PROCEDURE sp_Login_CheckAccount
    @username VARCHAR(50),
    @password NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @hashedPassword VARBINARY(MAX) = HASHBYTES('SHA2_256', @password);

    -- Kiểm tra tài khoản
    IF EXISTS (
        SELECT 1
        FROM ACCOUNT
        WHERE username = @username AND passwordHash = @hashedPassword
    )
    BEGIN
        SELECT 
            A.username,
            A.userID,
            P.permissionID,
            P.permissionName
        FROM ACCOUNT A
        LEFT JOIN ACCOUNT_PERMISSION AP ON A.username = AP.username
        LEFT JOIN PERMISSION P ON AP.permissionID = P.permissionID
        WHERE A.username = @username;
    END
    ELSE
    BEGIN
        -- Nếu không đúng, trả về rỗng
        SELECT NULL AS username, NULL AS userID, NULL AS permissionID, NULL AS permissionName;
    END
END