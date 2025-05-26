Use QLBenhVien
Go
CREATE OR ALTER PROCEDURE sp_ThemChiTietKhamBenh
    @maKhamBenh INT,
    @maBSYeuCau VARCHAR(10),
    @maDichVu INT,
    @ghiChu NVARCHAR(MAX),
    @ma NVARCHAR(100) 
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM KHAMBENH WHERE maKhamBenh = @maKhamBenh)
    BEGIN
        RAISERROR(N'Ma kham benh khong ton tai', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM DICHVU WHERE maDichVu = @maDichVu)
    BEGIN
        RAISERROR(N'Ma dich vu khong co', 16, 1);
        RETURN;
    END

    DECLARE @sql NVARCHAR(MAX);
    SET @sql = '
    OPEN SYMMETRIC KEY [' + @ma + '] 
    DECRYPTION BY CERTIFICATE BSCert 
    WITH PASSWORD = ''Cert_P@$$wOrd'';

    INSERT INTO CHITIET_KHAMBENH (
        maKhamBenh,
        maBacSiYeuCau,
        maDichVu,
        ghiChuBacSiKham
    )
    VALUES (
        @maKhamBenh,
        @maBSYeuCau,
        @maDichVu,
        EncryptByKey(Key_GUID(''' + @ma + '''), CONVERT(VARBINARY(MAX), @ghiChu), 1, ''' + @ma + ''')
    );

    CLOSE SYMMETRIC KEY [' + @ma + '];
    ';

    EXEC sp_executesql @sql,
        N'@maKhamBenh INT, @maBSYeuCau VARCHAR(10), @maDichVu INT, @ghiChu NVARCHAR(MAX)',
        @maKhamBenh = @maKhamBenh,
        @maBSYeuCau = @maBSYeuCau,
        @maDichVu = @maDichVu,
        @ghiChu = @ghiChu;

	UPDATE DANHSACH_BENHNHAN
    SET tinhTrang = '3'
    WHERE maKhamBenh = @maKhamBenh;
END
GO
	GRANT EXECUTE ON OBJECT::[dbo].sp_ThemChiTietKhamBenh TO userBenhVien AS [dbo];
GO
--drop proc sp_ThemChiTietKhamBenh

