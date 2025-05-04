USE QLBenhVien;
GO

--View_ChamCong
CREATE VIEW View_ChamCong
AS
SELECT 
    nv.maNhanVien,
    nv.maPhongBan,
    cc.ngayChamCong,
    cc.gioVao,
    cc.gioRa,
    cc.ghiChu
FROM CHAMCONG cc
INNER JOIN NHANVIEN nv ON cc.maNhanVien = nv.maNhanVien;
GO

-- TEST
SELECT * FROM View_ChamCong;
GO

--View_Luong
CREATE VIEW View_Luong
AS
SELECT 
    tt.maNhanVien,
    tt.hoTen,
    CONVERT(VARCHAR(MAX), tt.luongCoBan) AS luongCoBan,
    CONVERT(VARCHAR(MAX), tt.phuCap) AS phuCap
FROM THONGTIN_CANHAN tt;
GO

-- TEST
SELECT * FROM View_Luong;
GO