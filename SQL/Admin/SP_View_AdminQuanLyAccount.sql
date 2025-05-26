use QLBenhVien_ACCOUNT
go

CREATE OR ALTER VIEW viewTaiKhoan AS
SELECT 
    username,
    maNhanVien,
    typeID,
    createdDate,
    hasKey
FROM ACCOUNT;
GO
	GRANT SELECT ON OBJECT::viewTaiKhoan TO userAccountBenhVien;
GO
--drop view viewTaiKhoan

CREATE OR ALTER PROCEDURE sp_CheckKeyAccount
AS
BEGIN
   select * from viewTaiKhoan 
   WHERE hasKey = '0' and typeID = '1';
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].sp_CheckKeyAccount TO userAccountBenhVien
    AS [dbo];
GO

--drop proc sp_CheckKeyAccount

CREATE OR ALTER PROCEDURE sp_ViewTaiKhoan
AS
BEGIN
   select * from viewTaiKhoan  
   where typeID <> '0'
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].sp_ViewTaiKhoan TO userAccountBenhVien
    AS [dbo];
GO
drop proc sp_ViewTaiKhoan

use QLBenhVien
CREATE OR ALTER VIEW viewThongTinNhanVien AS
SELECT
    maNhanVien,
    hoTen,
    ngaySinh,
    diaChi,
    soDienThoai,
    email,
    luongCoBan,
    phuCap
FROM THONGTIN_CANHAN;
GO
	GRANT SELECT ON OBJECT::viewThongTinNhanVien TO userBenhVien;
GO
--drop view viewThongTinNhanVien

CREATE OR ALTER PROCEDURE sp_LayMaNV
AS
BEGIN
   select maNhanVien from viewThongTinNhanVien  
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].sp_LayMaNV TO userBenhVien
    AS [dbo];
GO


use QLBenhVien_ACCOUNT
CREATE OR ALTER PROCEDURE sp_ThemTaiKhoanNV
    @username VARCHAR(50),
    @passwordHash VARBINARY(MAX),
    @maNhanVien VARCHAR(10),
    @typeID VARCHAR(10)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM ACCOUNT WHERE username = @username)
    BEGIN
        RAISERROR(N'Ten dang nhap da ton tai.', 16, 1)
        RETURN;
    END

    INSERT INTO ACCOUNT (username, passwordHash, maNhanVien, typeID)
    VALUES (@username, @passwordHash, @maNhanVien, @typeID);
END
GO

GRANT EXECUTE ON OBJECT::sp_ThemTaiKhoanNV TO userAccountBenhVien;
GO

--drop proc sp_ThemTaiKhoanNV

CREATE OR ALTER VIEW viewQuyen AS
SELECT
	permissionID,
    permissionName 
FROM PERMISSION;
GO
	GRANT SELECT ON OBJECT::viewQuyen TO userAccountBenhVien;
GO
--drop view viewQuyen

CREATE OR ALTER PROCEDURE sp_LayQuyen
AS
BEGIN
   select * from viewQuyen
   where permissionID <> '1'
END
GO
GRANT EXECUTE ON OBJECT::sp_LayQuyen TO userAccountBenhVien;
GO
--drop proc sp_LayQuyen

CREATE OR ALTER VIEW viewQuyenTK AS
SELECT 
    a.username,
    p.permissionID,
    p.permissionName
FROM ACCOUNT a
LEFT JOIN ACCOUNT_PERMISSION ap ON a.username = ap.username
LEFT JOIN PERMISSION p ON ap.permissionID = p.permissionID;
GO
	GRANT SELECT ON OBJECT::viewQuyenTK TO userAccountBenhVien;
GO

--drop view viewQuyenTK

CREATE OR ALTER PROCEDURE sp_LayQuyenTK
AS
BEGIN
   select * from viewQuyenTK
END
GO

GRANT EXECUTE ON OBJECT::sp_LayQuyenTK TO userAccountBenhVien;
GO
--drop proc sp_LayQuyenTK


CREATE OR ALTER PROCEDURE sp_GanQuyen
    @username VARCHAR(50),
    @permissionId INT
AS
BEGIN

    INSERT INTO ACCOUNT_PERMISSION (username, permissionID)
    VALUES (@username, @permissionId);
END
GO
	GRANT EXECUTE ON OBJECT::sp_GanQuyen TO userAccountBenhVien;
Go

--drop proc sp_GanQuyen

CREATE OR ALTER PROCEDURE sp_XoaQuyen
    @username VARCHAR(50),
    @permissionId INT
AS
BEGIN
    DELETE FROM ACCOUNT_PERMISSION
    WHERE username = @username AND permissionID = @permissionId;
END
GO
	GRANT EXECUTE ON OBJECT::sp_XoaQuyen TO userAccountBenhVien;
GO

--drop proc sp_XoaQuyen


CREATE OR ALTER PROCEDURE sp_CapNhatKeyTaiKhoan
    @username VARCHAR(50),
    @keyValue NVARCHAR(100),  
    @BSCert NVARCHAR(100)    
WITH EXECUTE AS OWNER
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = @keyValue)
        BEGIN
            DECLARE @sqlCreateKey NVARCHAR(MAX);
            SET @sqlCreateKey = '
            CREATE SYMMETRIC KEY [' + @keyValue + '] 
            WITH ALGORITHM = AES_192 
            ENCRYPTION BY CERTIFICATE [' + @BSCert + '];';
            EXEC (@sqlCreateKey);

            DECLARE @sqlGrant NVARCHAR(MAX);
            SET @sqlGrant = '
            GRANT CONTROL ON SYMMETRIC KEY::[' + @keyValue + '] TO userBenhVien;';
            EXEC (@sqlGrant);
        END

        UPDATE ACCOUNT
        SET hasKey = '1'
        WHERE username = @username;
    END TRY
    BEGIN CATCH
        DECLARE @errMsg NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50001, @errMsg, 1;
    END CATCH
END
GO
	GRANT EXECUTE ON OBJECT::sp_CapNhatKeyTaiKhoan TO userAccountBenhVien;
GO

--drop proc sp_CapNhatKeyTaiKhoan