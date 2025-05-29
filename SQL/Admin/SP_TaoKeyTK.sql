USE QLBenhVien;
GO

CREATE OR ALTER PROCEDURE sp_CheckKeyAccount
AS
BEGIN
   select * from BacSi 
   WHERE hasKey = '0'
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].sp_CheckKeyAccount TO userBenhVien
    AS [dbo];
GO
drop proc sp_CheckKeyAccount

CREATE OR ALTER PROCEDURE sp_ThucHienTaoKey
    @keyValue NVARCHAR(100),  
    @BSCert NVARCHAR(100),
	@maBS  VARCHAR(10)
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
			
			 UPDATE BACSI
			SET hasKey = '1'
			WHERE maBacSi = @maBS;
        END
    END TRY
    BEGIN CATCH
        DECLARE @errMsg NVARCHAR(4000) = ERROR_MESSAGE();
        THROW 50001, @errMsg, 1;
    END CATCH
END
GO
	GRANT EXECUTE ON OBJECT::sp_ThucHienTaoKey TO userBenhVien;
GO

--drop proc sp_ThucHienTaoKey
