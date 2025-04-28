USE QLBenhVien;
GO

-- Stored Procedure: Xem danh sách đơn giá dịch vụ
CREATE PROCEDURE sp_XemDonGiaDichVu
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        dg.ID,
        dv.tenDichVu,
        dg.donGia,
        dg.ngayApDung
    FROM DONGIA_DICHVU dg
    JOIN DICHVU dv ON dg.maDichVu = dv.maDichVu
    ORDER BY dg.ngayApDung DESC;
END;
GO

EXEC sp_XemDonGiaDichVu;
GO

-- Stored Procedure: Thêm đơn giá dịch vụ
CREATE PROCEDURE sp_ThemDonGiaDichVu
    @maDichVu INT,
    @donGia DECIMAL(15,2),
    @ngayApDung DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM DICHVU WHERE maDichVu = @maDichVu)
        BEGIN
            THROW 50001, N'Mã dịch vụ không tồn tại!', 1;
            RETURN;
        END

        IF @donGia <= 0
        BEGIN
            THROW 50002, N'Đơn giá phải lớn hơn 0!', 1;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM DONGIA_DICHVU WHERE maDichVu = @maDichVu AND ngayApDung = @ngayApDung)
        BEGIN
            THROW 50003, N'Ngày áp dụng đã tồn tại cho dịch vụ này!', 1;
            RETURN;
        END

        INSERT INTO DONGIA_DICHVU (maDichVu, donGia, ngayApDung)
        VALUES (@maDichVu, @donGia, @ngayApDung);

        SELECT 'Thêm đơn giá dịch vụ thành công!' AS KetQua;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS KetQua,
            ERROR_NUMBER() AS ErrorNumber;
    END CATCH
END;
GO

-- Thêm thành công
EXEC sp_ThemDonGiaDichVu @maDichVu = 1, @donGia = 250000, @ngayApDung = '2025-05-01';
-- Thêm thất bại (mã dịch vụ không tồn tại)
EXEC sp_ThemDonGiaDichVu @maDichVu = 999, @donGia = 250000, @ngayApDung = '2025-05-01';
-- Thêm thất bại (đơn giá không hợp lệ)
EXEC sp_ThemDonGiaDichVu @maDichVu = 1, @donGia = -1000, @ngayApDung = '2025-05-01';
-- Thêm thất bại (ngày áp dụng trùng)
EXEC sp_ThemDonGiaDichVu @maDichVu = 1, @donGia = 250000, @ngayApDung = '2025-01-01';
GO

-- Stored Procedure: Xóa đơn giá dịch vụ
CREATE PROCEDURE sp_XoaDonGiaDichVu
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM DONGIA_DICHVU WHERE ID = @ID)
        BEGIN
            THROW 50004, N'ID đơn giá dịch vụ không tồn tại!', 1;
            RETURN;
        END

        DELETE FROM DONGIA_DICHVU WHERE ID = @ID;

        SELECT 'Xóa đơn giá dịch vụ thành công!' AS KetQua;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS KetQua,
            ERROR_NUMBER() AS ErrorNumber;
    END CATCH
END;
GO

-- Xóa thành công
EXEC sp_XoaDonGiaDichVu @ID = 1;
-- Xóa thất bại (ID không tồn tại)
EXEC sp_XoaDonGiaDichVu @ID = 999;
GO

-- Stored Procedure: Sửa đơn giá dịch vụ
CREATE PROCEDURE sp_SuaDonGiaDichVu
    @ID INT,
    @maDichVu INT,
    @donGia DECIMAL(15,2),
    @ngayApDung DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM DONGIA_DICHVU WHERE ID = @ID)
        BEGIN
            THROW 50005, N'ID đơn giá dịch vụ không tồn tại!', 1;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM DICHVU WHERE maDichVu = @maDichVu)
        BEGIN
            THROW 50006, N'Mã dịch vụ không tồn tại!', 1;
            RETURN;
        END

        IF @donGia <= 0
        BEGIN
            THROW 50007, N'Đơn giá phải lớn hơn 0!', 1;
            RETURN;
        END

        -- Kiểm tra ngày áp dụng không trùng (ngoại trừ chính record đang sửa)
        IF EXISTS (SELECT 1 FROM DONGIA_DICHVU 
                  WHERE maDichVu = @maDichVu 
                  AND ngayApDung = @ngayApDung 
                  AND ID != @ID)
        BEGIN
            THROW 50008, N'Ngày áp dụng đã tồn tại cho dịch vụ này!', 1;
            RETURN;
        END

        UPDATE DONGIA_DICHVU
        SET 
            maDichVu = @maDichVu,
            donGia = @donGia,
            ngayApDung = @ngayApDung
        WHERE ID = @ID;

        SELECT 'Sửa đơn giá dịch vụ thành công!' AS KetQua;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS KetQua,
            ERROR_NUMBER() AS ErrorNumber;
    END CATCH
END;
GO

-- Sửa thành công 
EXEC sp_SuaDonGiaDichVu @ID = 2, @maDichVu = 1, @donGia = 300000, @ngayApDung = '2025-06-01';
-- Sửa thất bại (ID không tồn tại)
EXEC sp_SuaDonGiaDichVu @ID = 999, @maDichVu = 1, @donGia = 300000, @ngayApDung = '2025-06-01';
-- Sửa thất bại (mã dịch vụ không tồn tại)
EXEC sp_SuaDonGiaDichVu @ID = 2, @maDichVu = 999, @donGia = 300000, @ngayApDung = '2025-06-01';
-- Sửa thất bại (đơn giá không hợp lệ)
EXEC sp_SuaDonGiaDichVu @ID = 2, @maDichVu = 1, @donGia = -1000, @ngayApDung = '2025-06-01';
GO