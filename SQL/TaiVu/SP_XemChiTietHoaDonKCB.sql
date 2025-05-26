Use QLBenhVien
Go
CREATE OR ALTER PROCEDURE sp_XemChiTietHoaDonTheoKhamBenh
    @maKhamBenh INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ChiTietHoaDonTaiVu
    WHERE maKhamBenh = @maKhamBenh;
END;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].sp_XemChiTietHoaDonTheoKhamBenh TO userBenhVien
    AS [dbo];
GO
--drop proc sp_XemChiTietHoaDonTheoKhamBenh