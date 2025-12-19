USE QLBenhVien_ACCOUNT;
GO
SELECT * FROM QLBenhVien_ACCOUNT.dbo.view_LoginOutsideHours ORDER BY event_time DESC;
SELECT * FROM QLBenhVien_ACCOUNT.dbo.view_CapNhatKeyTaiKhoan ORDER BY event_time DESC;
SELECT * FROM QLBenhVien_ACCOUNT.dbo.view_XoaQuyen ORDER BY event_time DESC;
SELECT * FROM QLBenhVien_ACCOUNT.dbo.view_GanQuyen ORDER BY event_time DESC;
SELECT * FROM QLBenhVien_ACCOUNT.dbo.view_XoaTaiKhoan ORDER BY event_time DESC;
SELECT * FROM QLBenhVien_ACCOUNT.dbo.view_ThemTaiKhoanNV ORDER BY event_time DESC;
GO

USE QLBenhVien;
GO

SELECT * FROM PaymentAuditLog;
