USE master;
GO

-- Sao lưu QLBenhVien
DECLARE @BackupPathQLBenhVien NVARCHAR(500) = N'D:\Backup_QLBenhVien\QLBenhVien_' + 
    CONVERT(NVARCHAR(20), GETDATE(), 112) + N'_' + 
    REPLACE(CONVERT(NVARCHAR(5), GETDATE(), 108), ':', '') + N'.bak';

BACKUP DATABASE QLBenhVien
TO DISK = @BackupPathQLBenhVien
WITH 
    INIT,
    NAME = N'QLBenhVien-Full Backup',
    STATS = 10,
    COMPRESSION;
GO

-- Sao lưu QLBenhVien_ACCOUNT
DECLARE @BackupPathQLBenhVienAccount NVARCHAR(500) = N'D:\Backup_QLBenhVien\QLBenhVien_ACCOUNT_' + 
    CONVERT(NVARCHAR(20), GETDATE(), 112) + N'_' + 
    REPLACE(CONVERT(NVARCHAR(5), GETDATE(), 108), ':', '') + N'.bak';

BACKUP DATABASE QLBenhVien_ACCOUNT
TO DISK = @BackupPathQLBenhVienAccount
WITH 
    INIT,
    NAME = N'QLBenhVien_ACCOUNT-Full Backup',
    STATS = 10,
    COMPRESSION;
GO
