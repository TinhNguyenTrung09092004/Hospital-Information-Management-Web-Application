USE QLBenhVien;
GO

-- Stored Procedure: Xem danh sách đơn giá thuốc
CREATE PROCEDURE sp_XemDonGiaThuoc
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        dg.ID,
        t.tenThuoc,
        dg.donGia,
        dg.ngayApDung
    FROM DONGIA_THUOC dg
    JOIN THUOC t ON dg.maThuoc = t.maThuoc
    ORDER BY dg.ngayApDung DESC;
END;
GO

EXEC sp_XemDonGiaThuoc;
GO

-- Stored Procedure: Thêm đơn giá thuốc
CREATE PROCEDURE sp_ThemDonGiaThuoc
    @maThuoc VARCHAR(10),
    @donGia DECIMAL(15,2),
    @ngayApDung DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM THUOC WHERE maThuoc = @maThuoc)
        BEGIN
            THROW 50001, N'Mã thuốc không tồn tại!', 1;
            RETURN;
        END

        IF @donGia <= 0
        BEGIN
            THROW 50002, N'Đơn giá phải lớn hơn 0!', 1;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM DONGIA_THUOC WHERE maThuoc = @maThuoc AND ngayApDung = @ngayApDung)
        BEGIN
            THROW 50003, N'Ngày áp dụng đã tồn tại cho thuốc này!', 1;
            RETURN;
        END

        INSERT INTO DONGIA_THUOC (maThuoc, donGia, ngayApDung)
        VALUES (@maThuoc, @donGia, @ngayApDung);

        SELECT 'Thêm đơn giá thuốc thành công!' AS KetQua;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS KetQua,
            ERROR_NUMBER() AS ErrorNumber;
    END CATCH
END;
GO

-- Thêm thành công
EXEC sp_ThemDonGiaThuoc @maThuoc = 'T001', @donGia = 2500, @ngayApDung = '2025-05-01';
-- Thêm thất bại (mã thuốc không tồn tại)
EXEC sp_ThemDonGiaThuoc @maThuoc = 'T999', @donGia = 2500, @ngayApDung = '2025-05-01';
-- Thêm thất bại (đơn giá không hợp lệ)
EXEC sp_ThemDonGiaThuoc @maThuoc = 'T001', @donGia = -1000, @ngayApDung = '2025-05-01';
-- Thêm thất bại (ngày áp dụng trùng)
EXEC sp_ThemDonGiaThuoc @maThuoc = 'T001', @donGia = 2500, @ngayApDung = '2025-01-01';
GO

-- Stored Procedure: Xóa đơn giá thuốc
CREATE PROCEDURE sp_XoaDonGiaThuoc
    @ID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM DONGIA_THUOC WHERE ID = @ID)
        BEGIN
            THROW 50004, N'ID đơn giá thuốc không tồn tại!', 1;
            RETURN;
        END

        DELETE FROM DONGIA_THUOC WHERE ID = @ID;

        SELECT 'Xóa đơn giá thuốc thành công!' AS KetQua;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS KetQua,
            ERROR_NUMBER() AS ErrorNumber;
    END CATCH
END;
GO

-- Xóa thành công 
EXEC sp_XoaDonGiaThuoc @ID = 1;
-- Xóa thất bại (ID không tồn tại)
EXEC sp_XoaDonGiaThuoc @ID = 999;
GO

-- Stored Procedure: Sửa đơn giá thuốc
CREATE PROCEDURE sp_SuaDonGiaThuoc
    @ID INT,
    @maThuoc VARCHAR(10),
    @donGia DECIMAL(15,2),
    @ngayApDung DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM DONGIA_THUOC WHERE ID = @ID)
        BEGIN
            THROW 50005, N'ID đơn giá thuốc không tồn tại!', 1;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM THUOC WHERE maThuoc = @maThuoc)
        BEGIN
            THROW 50006, N'Mã thuốc không tồn tại!', 1;
            RETURN;
        END

        IF @donGia <= 0
        BEGIN
            THROW 50007, N'Đơn giá phải lớn hơn 0!', 1;
            RETURN;
        END

        -- Kiểm tra ngày áp dụng không trùng (ngoại trừ chính record đang sửa)
        IF EXISTS (SELECT 1 FROM DONGIA_THUOC 
                  WHERE maThuoc = @maThuoc 
                  AND ngayApDung = @ngayApDung 
                  AND ID != @ID)
        BEGIN
            THROW 50008, N'Ngày áp dụng đã tồn tại cho thuốc này!', 1;
            RETURN;
        END

        UPDATE DONGIA_THUOC
        SET 
            maThuoc = @maThuoc,
            donGia = @donGia,
            ngayApDung = @ngayApDung
        WHERE ID = @ID;

        SELECT 'Sửa đơn giá thuốc thành công!' AS KetQua;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_MESSAGE() AS KetQua,
            ERROR_NUMBER() AS ErrorNumber;
    END CATCH
END;
GO

-- Sửa thành công 
EXEC sp_SuaDonGiaThuoc @ID = 2, @maThuoc = 'T001', @donGia = 3000, @ngayApDung = '2025-06-01';
-- Sửa thất bại (ID không tồn tại)
EXEC sp_SuaDonGiaThuoc @ID = 999, @maThuoc = 'T001', @donGia = 3000, @ngayApDung = '2025-06-01';
-- Sửa thất bại (mã thuốc không tồn tại)
EXEC sp_SuaDonGiaThuoc @ID = 2, @maThuoc = 'T999', @donGia = 3000, @ngayApDung = '2025-06-01';
-- Sửa thất bại (đơn giá không hợp lệ)
EXEC sp_SuaDonGiaThuoc @ID = 2, @maThuoc = 'T001', @donGia = -1000, @ngayApDung = '2025-06-01';
GO