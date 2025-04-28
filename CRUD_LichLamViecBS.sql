USE QLBenhVien;
GO

-- Xem danh sách lịch làm việc
CREATE PROCEDURE sp_XemLichLamViec
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        maLich,
        maBacSi,
        maPhongKham,
        ngayTruc,
        gioBatDau,
        gioKetThuc,
        ghiChu
    FROM LICH_LAMVIEC
    ORDER BY ngayTruc, gioBatDau;
END;
GO

EXEC sp_XemLichLamViec;

-- Thêm lịch làm việc
CREATE PROCEDURE sp_ThemLichLamViec
    @maBacSi VARCHAR(10),
    @maPhongKham VARCHAR(10),
    @ngayTruc DATE,
    @gioBatDau TIME,
    @gioKetThuc TIME,
    @ghiChu NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra mã bác sĩ có tồn tại
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE maNhanVien = @maBacSi)
        BEGIN
            THROW 52001, N'Mã bác sĩ không tồn tại trong NHANVIEN!', 1;
        END

        -- Kiểm tra mã phòng khám có tồn tại
        IF NOT EXISTS (SELECT 1 FROM PHONGKHAM WHERE maPhongKham = @maPhongKham)
        BEGIN
            THROW 52002, N'Mã phòng khám không tồn tại!', 1;
        END

        INSERT INTO LICH_LAMVIEC (maBacSi, maPhongKham, ngayTruc, gioBatDau, gioKetThuc, ghiChu)
        VALUES (@maBacSi, @maPhongKham, @ngayTruc, @gioBatDau, @gioKetThuc, @ghiChu);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

EXEC sp_ThemLichLamViec 
    @maBacSi = 'BS02', 
    @maPhongKham = 'PK01', 
    @ngayTruc = '2025-05-05',
    @gioBatDau = '08:00', 
    @gioKetThuc = '12:00', 
    @ghiChu = N'Ca sáng';


-- Sửa lịch làm việc
CREATE PROCEDURE sp_SuaLichLamViec
    @maLich INT,
    @maBacSi VARCHAR(10),
    @maPhongKham VARCHAR(10),
    @ngayTruc DATE,
    @gioBatDau TIME,
    @gioKetThuc TIME,
    @ghiChu NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra maLich có tồn tại
        IF NOT EXISTS (SELECT 1 FROM LICH_LAMVIEC WHERE maLich = @maLich)
        BEGIN
            THROW 52003, N'Mã lịch làm việc không tồn tại!', 1;
        END

        -- Kiểm tra mã bác sĩ tồn tại
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE maNhanVien = @maBacSi)
        BEGIN
            THROW 52004, N'Mã bác sĩ không tồn tại trong NHANVIEN!', 1;
        END

        -- Kiểm tra mã phòng khám tồn tại
        IF NOT EXISTS (SELECT 1 FROM PHONGKHAM WHERE maPhongKham = @maPhongKham)
        BEGIN
            THROW 52005, N'Mã phòng khám không tồn tại!', 1;
        END

        UPDATE LICH_LAMVIEC
        SET 
            maBacSi = @maBacSi,
            maPhongKham = @maPhongKham,
            ngayTruc = @ngayTruc,
            gioBatDau = @gioBatDau,
            gioKetThuc = @gioKetThuc,
            ghiChu = @ghiChu
        WHERE maLich = @maLich;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

EXEC sp_SuaLichLamViec 
    @maLich = 1,
    @maBacSi = 'BS03', 
    @maPhongKham = 'PK02', 
    @ngayTruc = '2025-05-06',
    @gioBatDau = '13:00', 
    @gioKetThuc = '17:00', 
    @ghiChu = N'Ca chiều';


-- Xóa lịch làm việc
CREATE PROCEDURE sp_XoaLichLamViec
    @maLich INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra maLich tồn tại
        IF NOT EXISTS (SELECT 1 FROM LICH_LAMVIEC WHERE maLich = @maLich)
        BEGIN
            THROW 52006, N'Mã lịch làm việc không tồn tại!', 1;
        END

        DELETE FROM LICH_LAMVIEC WHERE maLich = @maLich;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

EXEC sp_XoaLichLamViec @maLich = 1;