USE QLBenhVien_ACCOUNT;
GO

CREATE OR ALTER PROCEDURE sp_DoiMatKhau
    @username VARCHAR(10),
    @currentPasswordHash VARBINARY(MAX),
    @newPasswordHash VARBINARY(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM ACCOUNT 
        WHERE username = @username AND passwordHash = @currentPasswordHash
    )
    BEGIN
        RAISERROR('Tài khoản không tồn tại hoặc mật khẩu hiện tại không đúng.', 16, 1);
        RETURN;
    END

    UPDATE ACCOUNT
    SET passwordHash = @newPasswordHash
    WHERE username = @username;
END;
GO
	GRANT EXECUTE ON OBJECT::[dbo].sp_DoiMatKhau TO userAccountBenhVien;
GO
--drop proc sp_DoiMatKhau