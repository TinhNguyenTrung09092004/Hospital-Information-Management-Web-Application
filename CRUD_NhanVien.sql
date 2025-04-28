USE QLBenhVien;
GO

--Xem danh sách nhân viên
CREATE PROCEDURE sp_XemNhanVien
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        maNhanVien,
        maPhongBan,
        chucVu
    FROM NHANVIEN
    ORDER BY maNhanVien;
END;
GO

-- EXEC TEST
EXEC sp_XemNhanVien;

-- Thêm danh sách nhân viên
CREATE PROCEDURE sp_ThemNhanVien
    @maNhanVien VARCHAR(10),
    @maPhongBan VARCHAR(10),
    @chucVu VARCHAR(2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra mã nhân viên có tồn tại trong THONGTIN_CANHAN không
        IF NOT EXISTS (SELECT 1 FROM THONGTIN_CANHAN WHERE maNhanVien = @maNhanVien)
        BEGIN
            THROW 54001, N'Mã nhân viên chưa tồn tại trong bảng THONGTIN_CANHAN!', 1;
        END

        -- Kiểm tra trùng khóa chính
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE maNhanVien = @maNhanVien)
        BEGIN
            THROW 54002, N'Nhân viên này đã tồn tại trong bảng NHANVIEN!', 1;
        END

        -- Kiểm tra mã phòng ban (nếu có)
        IF @maPhongBan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE maPhongBan = @maPhongBan)
        BEGIN
            THROW 54003, N'Mã phòng ban không tồn tại!', 1;
        END

        INSERT INTO NHANVIEN (maNhanVien, maPhongBan, chucVu)
        VALUES (@maNhanVien, @maPhongBan, @chucVu);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_ThemNhanVien @maNhanVien = 'NV02', @maPhongBan = 'PB01', @chucVu = 'BS';

-- Sửa danh sách nhân viên
CREATE PROCEDURE sp_SuaNhanVien
    @maNhanVien VARCHAR(10),
    @maPhongBan VARCHAR(10),
    @chucVu VARCHAR(2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE maNhanVien = @maNhanVien)
        BEGIN
            THROW 54004, N'Nhân viên không tồn tại trong bảng NHANVIEN!', 1;
        END

        IF @maPhongBan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE maPhongBan = @maPhongBan)
        BEGIN
            THROW 54005, N'Mã phòng ban không tồn tại!', 1;
        END

        UPDATE NHANVIEN
        SET maPhongBan = @maPhongBan,
            chucVu = @chucVu
        WHERE maNhanVien = @maNhanVien;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_SuaNhanVien @maNhanVien = 'NV02', @maPhongBan = 'PB02', @chucVu = 'TP';

-- Xóa nhân viên khỏi danh sách
CREATE PROCEDURE sp_XoaNhanVien
    @maNhanVien VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE maNhanVien = @maNhanVien)
        BEGIN
            THROW 54006, N'Nhân viên không tồn tại trong bảng NHANVIEN!', 1;
        END

        DELETE FROM NHANVIEN WHERE maNhanVien = @maNhanVien;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_XoaNhanVien @maNhanVien = 'NV02';


