USE master;
GO
SELECT 
    name AS TriggerName, 
    OBJECT_NAME(parent_id) AS TableName, 
    OBJECT_DEFINITION(object_id) AS TriggerDefinition
FROM sys.triggers
WHERE OBJECT_DEFINITION(object_id) LIKE '%SymmetricKeyQLTV%';
DROP TRIGGER tr_PaymentAudit;


IF EXISTS (SELECT 1 FROM sys.server_audits WHERE name = 'Hospital_Audit')
BEGIN
    ALTER SERVER AUDIT Hospital_Audit WITH (STATE = OFF);
    DROP SERVER AUDIT Hospital_Audit;
END
GO

CREATE SERVER AUDIT Hospital_Audit
    TO FILE (
        FILEPATH = 'D:\Audit\',
        MAXSIZE = 100 MB,
        MAX_ROLLOVER_FILES = 10,
        RESERVE_DISK_SPACE = OFF
    )
    WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
GO

ALTER SERVER AUDIT Hospital_Audit WITH (STATE = ON);
GO

USE QLBenhVien_ACCOUNT;
GO

IF EXISTS (SELECT 1 FROM sys.database_audit_specifications WHERE name = 'Account_Audit_Spec')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION Account_Audit_Spec WITH (STATE = OFF);
    DROP DATABASE AUDIT SPECIFICATION Account_Audit_Spec;
END
GO

CREATE DATABASE AUDIT SPECIFICATION Account_Audit_Spec
FOR SERVER AUDIT Hospital_Audit
    ADD (EXECUTE ON sp_ThemTaiKhoanNV BY public),
    ADD (EXECUTE ON sp_GanQuyen BY public),
    ADD (EXECUTE ON sp_XoaQuyen BY public),
    ADD (EXECUTE ON sp_Login_CheckAccount BY public)
WITH (STATE = ON);
GO

IF OBJECT_ID('sp_XoaTaiKhoan') IS NOT NULL
    DROP PROCEDURE sp_XoaTaiKhoan;
GO

CREATE PROCEDURE sp_XoaTaiKhoan
    @username VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM ACCOUNT WHERE username = @username)
        RAISERROR(N'Tài khoản không tồn tại.', 16, 1);
    ELSE
    BEGIN
        DELETE FROM ACCOUNT_PERMISSION WHERE username = @username;
        DELETE FROM ACCOUNT WHERE username = @username;
    END
END;
GO

GRANT EXECUTE ON sp_XoaTaiKhoan TO userAccountBenhVien;
GO

ALTER DATABASE AUDIT SPECIFICATION Account_Audit_Spec
WITH (STATE = OFF);
GO

ALTER DATABASE AUDIT SPECIFICATION Account_Audit_Spec
FOR SERVER AUDIT Hospital_Audit
    ADD (EXECUTE ON OBJECT::sp_XoaTaiKhoan BY PUBLIC);
GO

ALTER DATABASE AUDIT SPECIFICATION Account_Audit_Spec
WITH (STATE = ON);
GO

USE QLBenhVien;
GO

IF EXISTS (SELECT 1 FROM sys.database_audit_specifications WHERE name = 'Hospital_Audit_Spec')
BEGIN
    ALTER DATABASE AUDIT SPECIFICATION Hospital_Audit_Spec WITH (STATE = OFF);
    DROP DATABASE AUDIT SPECIFICATION Hospital_Audit_Spec;
END
GO

CREATE DATABASE AUDIT SPECIFICATION Hospital_Audit_Spec
FOR SERVER AUDIT Hospital_Audit
    ADD (EXECUTE ON OBJECT::dbo.sp_ThucHienTaoKey BY public)
WITH (STATE = ON);
GO

USE QLBenhVien_ACCOUNT;
GO

IF OBJECT_ID('view_LoginOutsideHours') IS NOT NULL
    DROP VIEW view_LoginOutsideHours;
GO

CREATE VIEW view_LoginOutsideHours
AS
SELECT 
    a.event_time,
    DATEADD(HOUR, 7, a.event_time) AS vietnam_time,
    a.server_principal_name,
    a.database_name,
    a.schema_name,
    a.object_name,
    a.statement,
    a.additional_information,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="username"]/@Value)[1]', 'NVARCHAR(50)') AS username_param,
    a.succeeded,
    a.client_ip,
    a.host_name,
    a.application_name,
    a.session_id,
    a.server_instance_name,
    a.action_id,
    a.database_principal_name,
    a.session_server_principal_name,
    a.file_name,
    a.audit_file_offset,
    a.sequence_number,
    a.connection_id,
    a.class_type,
    a.target_server_principal_name,
    a.target_database_principal_name,
    a.permission_bitmask,
    a.is_column_permission,
    a.audit_schema_version,
    a.transaction_id
FROM fn_get_audit_file('D:\Audit\*.sqlaudit', DEFAULT, DEFAULT) a
WHERE a.object_name = 'sp_Login_CheckAccount'
    AND (DATEPART(HOUR, DATEADD(HOUR, 7, a.event_time)) < 7 
         OR DATEPART(HOUR, DATEADD(HOUR, 7, a.event_time)) >= 16);
GO

IF OBJECT_ID('view_CapNhatKeyTaiKhoan') IS NOT NULL
    DROP VIEW view_CapNhatKeyTaiKhoan;
GO

CREATE VIEW view_CapNhatKeyTaiKhoan
AS
SELECT 
    a.event_time,
    DATEADD(HOUR, 7, a.event_time) AS vietnam_time,
    a.server_principal_name AS executor_login,
    a.database_principal_name AS executor_user,
    a.database_name,
    a.schema_name,
    a.object_name,
    a.statement,
    a.additional_information,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="username"]/@Value)[1]', 'NVARCHAR(50)') AS target_username,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="new_password"]/@Value)[1]', 'NVARCHAR(50)') AS new_password_param,
    a.succeeded,
    CASE WHEN a.succeeded = 1 THEN N'Thành công' ELSE N'Thất bại' END AS status_text,
    a.client_ip,
    a.host_name,
    a.application_name,
    a.session_id,
    a.connection_id,
    a.sequence_number,
    a.action_id,
    a.class_type,
    a.server_instance_name,
    a.file_name,
    a.audit_file_offset,
    a.transaction_id,
    a.session_server_principal_name,
    a.target_server_principal_name,
    a.target_database_principal_name,
    a.permission_bitmask,
    a.is_column_permission,
    a.audit_schema_version
FROM fn_get_audit_file('D:\Audit\*.sqlaudit', DEFAULT, DEFAULT) a
WHERE a.object_name = 'sp_ThucHienTaoKey'
    AND a.database_name = 'QLBenhVien'
    AND a.schema_name = 'dbo';
GO

IF OBJECT_ID('view_XoaQuyen') IS NOT NULL
    DROP VIEW view_XoaQuyen;
GO

CREATE VIEW view_XoaQuyen
AS
SELECT 
    a.event_time,
    DATEADD(HOUR, 7, a.event_time) AS vietnam_time,
    a.server_principal_name AS executor_login,
    a.database_principal_name AS executor_user,
    a.database_name,
    a.schema_name,
    a.object_name,
    a.statement,
    a.additional_information,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="username"]/@Value)[1]', 'NVARCHAR(50)') AS target_username,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="permission_id"]/@Value)[1]', 'NVARCHAR(50)') AS permission_id,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="role_name"]/@Value)[1]', 'NVARCHAR(50)') AS role_name,
    a.succeeded,
    CASE WHEN a.succeeded = 1 THEN N'Thành công' ELSE N'Thất bại' END AS status_text,
    a.client_ip,
    a.host_name,
    a.application_name,
    a.session_id,
    a.connection_id,
    a.sequence_number,
    a.action_id,
    a.class_type,
    a.server_instance_name,
    a.file_name,
    a.audit_file_offset,
    a.transaction_id,
    a.session_server_principal_name,
    a.target_server_principal_name,
    a.target_database_principal_name,
    a.permission_bitmask,
    a.is_column_permission,
    a.audit_schema_version
FROM fn_get_audit_file('D:\Audit\*.sqlaudit', DEFAULT, DEFAULT) a
WHERE a.object_name = 'sp_XoaQuyen';
GO

IF OBJECT_ID('view_GanQuyen') IS NOT NULL
    DROP VIEW view_GanQuyen;
GO

CREATE VIEW view_GanQuyen
AS
SELECT 
    a.event_time,
    DATEADD(HOUR, 7, a.event_time) AS vietnam_time,
    a.server_principal_name AS executor_login,
    a.database_principal_name AS executor_user,
    a.database_name,
    a.schema_name,
    a.object_name,
    a.statement,
    a.additional_information,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="username"]/@Value)[1]', 'NVARCHAR(50)') AS target_username,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="permission_id"]/@Value)[1]', 'NVARCHAR(50)') AS permission_id,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="role_name"]/@Value)[1]', 'NVARCHAR(50)') AS role_name,
    a.succeeded,
    CASE WHEN a.succeeded = 1 THEN N'Thành công' ELSE N'Thất bại' END AS status_text,
    a.client_ip,
    a.host_name,
    a.application_name,
    a.session_id,
    a.connection_id,
    a.sequence_number,
    a.action_id,
    a.class_type,
    a.server_instance_name,
    a.file_name,
    a.audit_file_offset,
    a.transaction_id,
    a.session_server_principal_name,
    a.target_server_principal_name,
    a.target_database_principal_name,
    a.permission_bitmask,
    a.is_column_permission,
    a.audit_schema_version
FROM fn_get_audit_file('D:\Audit\*.sqlaudit', DEFAULT, DEFAULT) a
WHERE a.object_name = 'sp_GanQuyen';
GO

IF OBJECT_ID('view_XoaTaiKhoan') IS NOT NULL
    DROP VIEW view_XoaTaiKhoan;
GO

CREATE VIEW view_XoaTaiKhoan
AS
SELECT 
    a.event_time,
    DATEADD(HOUR, 7, a.event_time) AS vietnam_time,
    a.server_principal_name AS executor_login,
    a.database_principal_name AS executor_user,
    a.database_name,
    a.schema_name,
    a.object_name,
    a.statement,
    a.additional_information,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="username"]/@Value)[1]', 'NVARCHAR(50)') AS target_username,
    a.succeeded,
    CASE WHEN a.succeeded = 1 THEN N'Thành công' ELSE N'Thất bại' END AS status_text,
    a.client_ip,
    a.host_name,
    a.application_name,
    a.session_id,
    a.connection_id,
    a.sequence_number,
    a.action_id,
    a.class_type,
    a.server_instance_name,
    a.file_name,
    a.audit_file_offset,
    a.transaction_id,
    a.session_server_principal_name,
    a.target_server_principal_name,
    a.target_database_principal_name,
    a.permission_bitmask,
    a.is_column_permission,
    a.audit_schema_version
FROM fn_get_audit_file('D:\Audit\*.sqlaudit', DEFAULT, DEFAULT) a
WHERE a.object_name = 'sp_XoaTaiKhoan';
GO

IF OBJECT_ID('view_ThemTaiKhoanNV') IS NOT NULL
    DROP VIEW view_ThemTaiKhoanNV;
GO

CREATE VIEW view_ThemTaiKhoanNV
AS
SELECT 
    a.event_time,
    DATEADD(HOUR, 7, a.event_time) AS vietnam_time,
    a.server_principal_name AS executor_login,
    a.database_principal_name AS executor_user,
    a.database_name,
    a.schema_name,
    a.object_name,
    a.statement,
    a.additional_information,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="username"]/@Value)[1]', 'NVARCHAR(50)') AS new_username,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="password"]/@Value)[1]', 'NVARCHAR(50)') AS password_param,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="hoten"]/@Value)[1]', 'NVARCHAR(100)') AS hoten,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="email"]/@Value)[1]', 'NVARCHAR(100)') AS email,
    CAST(a.additional_information AS XML).value('(/TsqlCommand/CommandText/Parameters/Parameter[@Name="sdt"]/@Value)[1]', 'NVARCHAR(20)') AS sdt,
    a.succeeded,
    CASE WHEN a.succeeded = 1 THEN N'Thành công' ELSE N'Thất bại' END AS status_text,
    a.client_ip,
    a.host_name,
    a.application_name,
    a.session_id,
    a.connection_id,
    a.sequence_number,
    a.action_id,
    a.class_type,
    a.server_instance_name,
    a.file_name,
    a.audit_file_offset,
    a.transaction_id,
    a.session_server_principal_name,
    a.target_server_principal_name,
    a.target_database_principal_name,
    a.permission_bitmask,
    a.is_column_permission,
    a.audit_schema_version
FROM fn_get_audit_file('D:\Audit\*.sqlaudit', DEFAULT, DEFAULT) a
WHERE a.object_name = 'sp_ThemTaiKhoanNV';
GO

GRANT SELECT ON view_LoginOutsideHours TO userAccountBenhVien;
GRANT SELECT ON view_CapNhatKeyTaiKhoan TO userAccountBenhVien;
GRANT SELECT ON view_XoaQuyen TO userAccountBenhVien;
GRANT SELECT ON view_GanQuyen TO userAccountBenhVien;
GRANT SELECT ON view_XoaTaiKhoan TO userAccountBenhVien;
GRANT SELECT ON view_ThemTaiKhoanNV TO userAccountBenhVien;
GO

USE QLBenhVien;
GO

IF OBJECT_ID('dbo.PaymentAuditLog', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.PaymentAuditLog;
END;
GO

CREATE TABLE PaymentAuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaHoaDon INT,
    SoTienNhan DECIMAL(15,2),
    TongTien DECIMAL(15,2),
    Difference DECIMAL(15,2),
    EventType NVARCHAR(50),
    EventTime DATETIME DEFAULT GETDATE(),
    UserName NVARCHAR(128),
    MaKhamBenh INT,
    MaBenhNhan VARCHAR(10),
    TenBenhNhan NVARCHAR(100),
    DichVu NVARCHAR(MAX),
    nhanVienThu VARCHAR(10),
    FOREIGN KEY (MaHoaDon) REFERENCES HOADON(maHoaDon)
);
GO

CREATE OR ALTER TRIGGER tr_PaymentAudit
ON HOADON
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    OPEN SYMMETRIC KEY SymmetricKeyQLTV
    DECRYPTION BY CERTIFICATE CertQLTV;

    DECLARE @AuditRecords TABLE (
        MaHoaDon INT,
        SoTienNhan DECIMAL(15,2),
        MaKhamBenh INT,
        nhanVienThu VARCHAR(10)
    );

    INSERT INTO @AuditRecords (MaHoaDon, SoTienNhan, MaKhamBenh, nhanVienThu)
    SELECT maHoaDon, soTienNhan, maKhamBenh, nhanVienThu
    FROM inserted
    WHERE soTienNhan IS NOT NULL;

    DECLARE @MaHoaDon INT, @SoTienNhan DECIMAL(15,2), @MaKhamBenh INT, @nhanVienThu VARCHAR(10);
    DECLARE @TongTien DECIMAL(15,2), @DichVu NVARCHAR(MAX);
    
    DECLARE audit_cursor CURSOR FOR
    SELECT MaHoaDon, SoTienNhan, MaKhamBenh, nhanVienThu
    FROM @AuditRecords;

    OPEN audit_cursor;
    FETCH NEXT FROM audit_cursor INTO @MaHoaDon, @SoTienNhan, @MaKhamBenh, @nhanVienThu;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @TongTien = SUM(CAST(CONVERT(NVARCHAR(MAX), DECRYPTBYCERT(CERT_ID('CertQLTV'), c.donGia)) AS DECIMAL(15,2))),
               @DichVu = STRING_AGG(dv.tenDichVu, ', ')
        FROM CHITIET_HOADON_KHAMCHUABENH c
        JOIN CHITIET_KHAMBENH ck ON c.maChiTietKham = ck.ID
        JOIN DICHVU dv ON ck.maDichVu = dv.maDichVu
        WHERE c.maHoaDon = @MaHoaDon;

        IF (@SoTienNhan - @TongTien > 1000000 OR @TongTien > 5000000)
        BEGIN
            INSERT INTO PaymentAuditLog (
                MaHoaDon, SoTienNhan, TongTien, Difference, EventType, UserName,
                MaKhamBenh, MaBenhNhan, TenBenhNhan, DichVu, nhanVienThu
            )
            SELECT 
                @MaHoaDon,
                @SoTienNhan,
                @TongTien,
                @SoTienNhan - @TongTien,
                CASE 
                    WHEN @SoTienNhan - @TongTien > 1000000 THEN 'LargeDifference'
                    WHEN @TongTien > 5000000 THEN 'LargeTotal'
                END,
                SUSER_SNAME(),
                @MaKhamBenh,
                bn.maBenhNhan,
                bn.hoTen,
                @DichVu,
                @nhanVienThu
            FROM KHAMBENH kb
            JOIN BENHNHAN bn ON kb.maBenhNhan = bn.maBenhNhan
            WHERE kb.maKhamBenh = @MaKhamBenh;
        END

        FETCH NEXT FROM audit_cursor INTO @MaHoaDon, @SoTienNhan, @MaKhamBenh, @nhanVienThu;
    END;

    CLOSE audit_cursor;
    DEALLOCATE audit_cursor;

    CLOSE SYMMETRIC KEY SymmetricKeyQLTV;
END;
GO



DECLARE @ProcedureName nvarchar(128);
DECLARE @Definition nvarchar(max);
DECLARE @NewDefinition nvarchar(max);
DECLARE @SQL nvarchar(max);

DECLARE proc_cursor CURSOR FOR
SELECT 
    p.name,
    m.definition
FROM sys.procedures p
LEFT JOIN sys.sql_modules m ON p.object_id = m.object_id
WHERE m.definition IS NOT NULL; 

OPEN proc_cursor;
FETCH NEXT FROM proc_cursor INTO @ProcedureName, @Definition;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Definition IS NOT NULL
    BEGIN
        BEGIN TRY
            DECLARE @AsPosition int = CHARINDEX('AS', @Definition);
            IF @AsPosition > 0
            BEGIN
                SET @NewDefinition = STUFF(@Definition, @AsPosition, 0, ' WITH ENCRYPTION ');
            END
            ELSE
            BEGIN
                SET @NewDefinition = REPLACE(@Definition, 
                                            'CREATE PROCEDURE ' + QUOTENAME(@ProcedureName), 
                                            'CREATE PROCEDURE ' + QUOTENAME(@ProcedureName) + ' WITH ENCRYPTION');
            END

            SET @SQL = 'DROP PROCEDURE ' + QUOTENAME(@ProcedureName);
            EXEC sp_executesql @SQL;

            EXEC sp_executesql @NewDefinition;

            IF OBJECTPROPERTY(OBJECT_ID(@ProcedureName), 'IsEncrypted') = 1
            BEGIN
                PRINT 'Encrypted stored procedure: ' + @ProcedureName;
            END
            ELSE
            BEGIN
                PRINT 'Failed to encrypt: ' + @ProcedureName;
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error processing ' + @ProcedureName + ': ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Skipping ' + @ProcedureName + ': Definition not available or already encrypted.';
    END

    FETCH NEXT FROM proc_cursor INTO @ProcedureName, @Definition;
END;

CLOSE proc_cursor;
DEALLOCATE proc_cursor;
GO

SELECT o.name, m.definition
FROM sys.sql_modules m
INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE o.type IN ('P', 'FN', 'IF', 'TF', 'V', 'TR') 
GO

DECLARE @ViewName nvarchar(128);
DECLARE @Definition nvarchar(max);
DECLARE @NewDefinition nvarchar(max);
DECLARE @SQL nvarchar(max);

DECLARE view_cursor CURSOR FOR
SELECT 
    v.name,
    m.definition
FROM sys.views v
LEFT JOIN sys.sql_modules m ON v.object_id = m.object_id
WHERE m.definition IS NOT NULL; 

OPEN view_cursor;
FETCH NEXT FROM view_cursor INTO @ViewName, @Definition;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @Definition IS NOT NULL
    BEGIN
        BEGIN TRY
            DECLARE @AsPosition int = CHARINDEX('AS', @Definition);
            IF @AsPosition > 0
            BEGIN
                SET @NewDefinition = STUFF(@Definition, @AsPosition, 0, ' WITH ENCRYPTION ');
            END
            ELSE
            BEGIN
                SET @NewDefinition = REPLACE(@Definition, 
                                            'CREATE VIEW ' + QUOTENAME(@ViewName), 
                                            'CREATE VIEW ' + QUOTENAME(@ViewName) + ' WITH ENCRYPTION');
            END

            SET @SQL = 'DROP VIEW ' + QUOTENAME(@ViewName);
            EXEC sp_executesql @SQL;

            EXEC sp_executesql @NewDefinition;

            IF OBJECTPROPERTY(OBJECT_ID(@ViewName), 'IsEncrypted') = 1
            BEGIN
                PRINT 'Encrypted view: ' + @ViewName;
            END
            ELSE
            BEGIN
                PRINT 'Failed to encrypt: ' + @ViewName;
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error processing ' + @ViewName + ': ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Skipping ' + @ViewName + ': Definition not available or already encrypted.';
    END

    FETCH NEXT FROM view_cursor INTO @ViewName, @Definition;
END;

CLOSE view_cursor;
DEALLOCATE view_cursor;
GO

SELECT o.name, m.definition
FROM sys.sql_modules m
INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE o.type = 'V' 
AND m.definition IS NULL;
GO
