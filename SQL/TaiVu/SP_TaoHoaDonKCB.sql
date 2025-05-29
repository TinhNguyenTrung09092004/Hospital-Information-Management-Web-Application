Use QLBenhVien
go
CREATE OR ALTER PROCEDURE sp_TaoHoaDonKCB
    @maKhamBenh INT,
    @nhanVienThu VARCHAR(10),
    @certName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @maHoaDon INT;

    IF EXISTS (SELECT 1 FROM HOADON WHERE maKhamBenh = @maKhamBenh AND thanhToan = '1')
        RETURN;

    SELECT TOP 1 @maHoaDon = maHoaDon
    FROM HOADON
    WHERE maKhamBenh = @maKhamBenh AND thanhToan = '0';

    IF @maHoaDon IS NULL
    BEGIN
        INSERT INTO HOADON (loaiHoaDon, maKhamBenh, thanhToan, nhanVienThu)
        VALUES ('1', @maKhamBenh, '0', @nhanVienThu);

        SET @maHoaDon = SCOPE_IDENTITY();
    END

    INSERT INTO CHITIET_HOADON_KHAMCHUABENH (maHoaDon, donGia, maChiTietKham)
    SELECT 
        @maHoaDon,
        (
            SELECT TOP 1
                dg.donGia 
            FROM DONGIA_DICHVU dg
            WHERE dg.maDichVu = ck.maDichVu
            ORDER BY ABS(DATEDIFF(DAY, dg.ngayApDung, GETDATE()))
        ) AS donGia,
        ck.ID
    FROM CHITIET_KHAMBENH ck
    WHERE ck.maKhamBenh = @maKhamBenh
      AND NOT EXISTS (
          SELECT 1
          FROM CHITIET_HOADON_KHAMCHUABENH ct
          WHERE ct.maChiTietKham = ck.ID
      );
END
GO

GRANT EXECUTE
    ON OBJECT::[dbo].sp_TaoHoaDonKCB TO userBenhVien
    AS [dbo];
GO

--drop proc sp_TaoHoaDonKCB
