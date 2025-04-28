USE QLBenhVien;
GO

CREATE VIEW View_HoaDonThuoc
AS
SELECT 
    hd.maHoaDon,
    hd.ngayLap,
    hd.tongTien,
    hd.thanhToan,
    bn.hoTen AS tenBenhNhan,
    t.tenThuoc,
    ctht.donGia,
    ctht.soLuong,
    ctht.donViTinh,
    nv.hoTen AS tenNhanVienThu
FROM HOADON hd
JOIN KHAMBENH kb ON hd.maKhamBenh = kb.maKhamBenh
JOIN BENHNHAN bn ON kb.maBenhNhan = bn.maBenhNhan
JOIN CHITIET_HOADON_THUOC ctht ON hd.maHoaDon = ctht.maHoaDon
JOIN THUOC t ON ctht.maThuoc = t.maThuoc
JOIN NHANVIEN n ON hd.nhanVienThu = n.maNhanVien
JOIN THONGTIN_CANHAN nv ON n.maNhanVien = nv.maNhanVien;
GO

SELECT * FROM View_HoaDonThuoc;
GO

CREATE VIEW View_HoaDonKCB
AS
SELECT 
    hd.maHoaDon,
    hd.ngayLap,
    hd.tongTien,
    hd.thanhToan,
    bn.hoTen AS tenBenhNhan,
    dv.tenDichVu,
    cthk.donGia,
    nv.hoTen AS tenNhanVienThu
FROM HOADON hd
JOIN KHAMBENH kb ON hd.maKhamBenh = kb.maKhamBenh
JOIN BENHNHAN bn ON kb.maBenhNhan = bn.maBenhNhan
JOIN CHITIET_HOADON_KHAMCHUABENH cthk ON hd.maHoaDon = cthk.maHoaDon
JOIN DICHVU dv ON cthk.maDichVu = dv.maDichVu
JOIN NHANVIEN n ON hd.nhanVienThu = n.maNhanVien
JOIN THONGTIN_CANHAN nv ON n.maNhanVien = nv.maNhanVien;
GO

SELECT * FROM View_HoaDonKCB;
GO

CREATE VIEW View_ChamCong
AS
SELECT 
    cc.maChamCong,
    cc.ngayChamCong,
    cc.gioVao,
    cc.gioRa,
    cc.ghiChu,
    ttc.hoTen AS tenNhanVien,
    pb.tenPhongBan
FROM CHAMCONG cc
JOIN THONGTIN_CANHAN ttc ON cc.maNhanVien = ttc.maNhanVien
LEFT JOIN NHANVIEN nv ON cc.maNhanVien = nv.maNhanVien
LEFT JOIN PHONGBAN pb ON nv.maPhongBan = pb.maPhongBan;
GO

SELECT * FROM View_ChamCong;
GO

CREATE VIEW View_Luong
AS
SELECT 
    ttc.maNhanVien,
    ttc.hoTen,
    CONVERT(DECIMAL(15,2), CAST(ttc.luongCoBan AS BIGINT)) AS luongCoBan,
    CONVERT(DECIMAL(15,2), CAST(ttc.phuCap AS BIGINT)) AS phuCap,
    (CONVERT(DECIMAL(15,2), CAST(ttc.luongCoBan AS BIGINT)) + 
     CONVERT(DECIMAL(15,2), CAST(ttc.phuCap AS BIGINT))) AS tongLuong
FROM THONGTIN_CANHAN ttc;
GO

SELECT * FROM View_Luong;
GO

CREATE VIEW View_BacSi
AS
SELECT 
    bs.maBacSi,
    ttc.hoTen,
    ttc.ngaySinh,
    ttc.diaChi,
    ttc.soDienThoai,
    ttc.email,
    k.tenKhoa,
    bs.chuyenMon
FROM BACSI bs
JOIN THONGTIN_CANHAN ttc ON bs.maBacSi = ttc.maNhanVien
JOIN KHOA k ON bs.maKhoa = k.maKhoa;
GO

SELECT * FROM View_BacSi;
GO

CREATE VIEW View_NhanVien
AS
SELECT 
    nv.maNhanVien,
    ttc.hoTen,
    ttc.ngaySinh,
    ttc.diaChi,
    ttc.soDienThoai,
    ttc.email,
    pb.tenPhongBan,
    nv.chucVu
FROM NHANVIEN nv
JOIN THONGTIN_CANHAN ttc ON nv.maNhanVien = ttc.maNhanVien
JOIN PHONGBAN pb ON nv.maPhongBan = pb.maPhongBan;
GO

SELECT * FROM View_NhanVien;
GO