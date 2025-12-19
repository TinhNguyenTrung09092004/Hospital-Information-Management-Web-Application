USE QLBenhVien_ACCOUNT;
GO
CREATE TABLE Audit_Login_Log (
    auditID INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50),
    typeID VARCHAR(2),
    maNhanVien VARCHAR(10),
    loginTime DATETIME DEFAULT GETDATE()
);
GO

CREATE OR ALTER PROCEDURE sp_Login_CheckAccount
    @username VARCHAR(50),
    @passwordHash VARBINARY(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM ACCOUNT
        WHERE username = @username AND passwordHash = @passwordHash
    )
    BEGIN
        DECLARE @typeID VARCHAR(2);
        DECLARE @maNhanVien VARCHAR(10);

        SELECT @typeID = typeID, @maNhanVien = maNhanVien
        FROM ACCOUNT
        WHERE username = @username;

        IF @typeID IN ('0', '4', '5')
        BEGIN
            INSERT INTO Audit_Login_Log (username, typeID, maNhanVien, loginTime)
            VALUES (@username, @typeID, @maNhanVien, GETDATE());
        END

        SELECT 
            A.username,
            A.typeID,
            A.maNhanVien,
            P.permissionID
        FROM ACCOUNT A
        LEFT JOIN ACCOUNT_PERMISSION AP ON A.username = AP.username
        LEFT JOIN PERMISSION P ON AP.permissionID = P.permissionID
        WHERE A.username = @username AND A.passwordHash = @passwordHash;
    END
    ELSE
    BEGIN
        SELECT 
            NULL AS username, 
            NULL AS typeID, 
            NULL AS maNhanVien,
            NULL AS permissionID;
    END
END;
GO

GRANT EXECUTE ON OBJECT::sp_Login_CheckAccount TO userAccountBenhVien;
GO
--drop proc sp_Login_CheckAccount

--USE QLBenhVien_ACCOUNT;
--GO
--select * from Audit_Login_Log
