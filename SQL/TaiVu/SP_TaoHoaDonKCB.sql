CREATE OR ALTER PROCEDURE sp_TaoHoaDonKCB
    @maKhamBenh INT,
    @nhanVienThu VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @maHoaDon INT;

    INSERT INTO HOADON (loaiHoaDon, maKhamBenh, thanhToan, nhanVienThu)
    VALUES ('1', @maKhamBenh, '0', @nhanVienThu);

    SET @maHoaDon = SCOPE_IDENTITY();

    -- Them chi tiet kham chua nam trong hoa don
    INSERT INTO CHITIET_HOADON_KHAMCHUABENH (maHoaDon, donGia, maChiTietKham)
    SELECT 
        @maHoaDon,
        (
            SELECT TOP 1 donGia
            FROM DONGIA_DICHVU
            WHERE maDichVu = ck.maDichVu
            ORDER BY ABS(DATEDIFF(DAY, ngayApDung, GETDATE()))
        ),
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
--select * from CHITIET_KHAMBENH
--select * from KHAMBENH
--select * from HOADON
--select * from CHITIET_HOADON_KHAMCHUABENH
--drop proc sp_TaoHoaDonKCB