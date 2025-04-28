USE QLBenhVien;
GO

--Xem danh sách phòng ban
CREATE PROCEDURE sp_XemPhongBan
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        maPhongBan,
        tenPhongBan
    FROM PHONGBAN
    ORDER BY maPhongBan;
END;
GO

-- EXEC TEST
EXEC sp_XemPhongBan;

--Thêm danh sách phòng ban
CREATE PROCEDURE sp_ThemPhongBan
    @maPhongBan VARCHAR(10),
    @tenPhongBan NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra mã phòng ban đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE maPhongBan = @maPhongBan)
        BEGIN
            THROW 50001, N'Mã phòng ban đã tồn tại!', 1;
        END

        INSERT INTO PHONGBAN (maPhongBan, tenPhongBan)
        VALUES (@maPhongBan, @tenPhongBan);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_ThemPhongBan @maPhongBan = 'PB02', @tenPhongBan = N'Phòng Công Nghệ Thông Tin';

--Chỉnh sửa danh sách phòng ban
CREATE PROCEDURE sp_SuaPhongBan
    @maPhongBan VARCHAR(10),
    @tenPhongBan NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra mã phòng ban có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE maPhongBan = @maPhongBan)
        BEGIN
            THROW 50002, N'Mã phòng ban không tồn tại!', 1;
        END

        UPDATE PHONGBAN
        SET tenPhongBan = @tenPhongBan
        WHERE maPhongBan = @maPhongBan;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_SuaPhongBan @maPhongBan = 'PB02', @tenPhongBan = N'Phòng IT - Cập nhật';

--Xóa danh sách phòng ban
CREATE PROCEDURE sp_XoaPhongBan
    @maPhongBan VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Kiểm tra mã phòng ban có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE maPhongBan = @maPhongBan)
        BEGIN
            THROW 50003, N'Mã phòng ban không tồn tại!', 1;
        END

        DELETE FROM PHONGBAN
        WHERE maPhongBan = @maPhongBan;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- EXEC TEST
EXEC sp_XoaPhongBan @maPhongBan = 'PB02';

