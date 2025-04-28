USE QLBenhVien;
GO

-- Xem danh sách bác sĩ
CREATE PROCEDURE sp_XemBacSi
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        maBacSi,
        maKhoa,
        chuyenMon
    FROM BACSI
    ORDER BY maBacSi;
END;
GO

-- EXEC TEST
EXEC sp_XemBacSi;

-- Thêm danh sách bác sĩ
CREATE PROCEDURE sp_ThemBacSi
    @maBacSi VARCHAR(10),
    @maKhoa VARCHAR(10),
    @chuyenMon VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra maBacSi có tồn tại trong THONGTIN_CANHAN chưa
        IF NOT EXISTS (SELECT 1 FROM THONGTIN_CANHAN WHERE maNhanVien = @maBacSi)
        BEGIN
            THROW 51001, N'Mã bác sĩ (mã nhân viên) không tồn tại trong THONGTIN_CANHAN!', 1;
        END

        -- Kiểm tra maKhoa có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM KHOA WHERE maKhoa = @maKhoa)
        BEGIN
            THROW 51002, N'Mã khoa không tồn tại!', 1;
        END

        -- Kiểm tra trùng khóa chính
        IF EXISTS (SELECT 1 FROM BACSI WHERE maBacSi = @maBacSi)
        BEGIN
            THROW 51003, N'Bác sĩ đã tồn tại!', 1;
        END

        INSERT INTO BACSI (maBacSi, maKhoa, chuyenMon)
        VALUES (@maBacSi, @maKhoa, @chuyenMon);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_ThemBacSi @maBacSi = 'BS01', @maKhoa = 'K01', @chuyenMon = N'Nội khoa';

-- Sửa danh sách bác sĩ
CREATE PROCEDURE sp_SuaBacSi
    @maBacSi VARCHAR(10),
    @maKhoa VARCHAR(10),
    @chuyenMon VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra tồn tại maBacSi
        IF NOT EXISTS (SELECT 1 FROM BACSI WHERE maBacSi = @maBacSi)
        BEGIN
            THROW 51004, N'Mã bác sĩ không tồn tại!', 1;
        END

        -- Kiểm tra tồn tại maKhoa
        IF NOT EXISTS (SELECT 1 FROM KHOA WHERE maKhoa = @maKhoa)
        BEGIN
            THROW 51005, N'Mã khoa không tồn tại!', 1;
        END

        UPDATE BACSI
        SET maKhoa = @maKhoa,
            chuyenMon = @chuyenMon
        WHERE maBacSi = @maBacSi;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_SuaBacSi @maBacSi = 'BS01', @maKhoa = 'K02', @chuyenMon = N'Ngoại khoa';

-- Xóa bác sĩ khỏi danh sách
CREATE OR ALTER PROCEDURE sp_XoaBacSi
    @maBacSi VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra maBacSi tồn tại
        IF NOT EXISTS (SELECT 1 FROM BACSI WHERE maBacSi = @maBacSi)
        BEGIN
            THROW 51006, N'Mã bác sĩ không tồn tại!', 1;
        END

        DELETE FROM BACSI WHERE maBacSi = @maBacSi;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_XoaBacSi @maBacSi = 'BS01';



