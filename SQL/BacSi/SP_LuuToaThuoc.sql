Use QLBenhVien
GO
CREATE OR ALTER PROCEDURE sp_ThemToaThuoc_MaHoa
    @ma NVARCHAR(100),           
    @BSCert NVARCHAR(100),        
    @maKhamBenh INT,
    @tenThuocList NVARCHAR(MAX),
    @soLuongList NVARCHAR(MAX),
    @lieuDungList NVARCHAR(MAX),
    @ghiChuList NVARCHAR(MAX)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @toaThuocID INT;

    INSERT INTO TOATHUOC (maKhamBenh)
    VALUES (@maKhamBenh);

    SET @toaThuocID = SCOPE_IDENTITY();

    ;WITH CTE_Ten AS (
        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS STT, LTRIM(RTRIM(value)) AS Ten
        FROM STRING_SPLIT(@tenThuocList, ',')
        WHERE LTRIM(RTRIM(value)) <> ''
    ),
    CTE_SL AS (
        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS STT, LTRIM(RTRIM(value)) AS SL
        FROM STRING_SPLIT(@soLuongList, ',')
    ),
    CTE_LD AS (
        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS STT, LTRIM(RTRIM(value)) AS LD
        FROM STRING_SPLIT(@lieuDungList, ',')
    ),
    CTE_GC AS (
        SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS STT, LTRIM(RTRIM(value)) AS GC
        FROM STRING_SPLIT(@ghiChuList, ',')
    )

    SELECT 
        t.Ten,
        TRY_CAST(s.SL AS INT) AS SoLuong,
        l.LD AS LieuDung,
        g.GC AS GhiChu
    INTO #Thuoc
    FROM CTE_Ten t
    JOIN CTE_SL s ON t.STT = s.STT
    JOIN CTE_LD l ON t.STT = l.STT
    JOIN CTE_GC g ON t.STT = g.STT;

    DECLARE @sqlOpen NVARCHAR(MAX), @sqlClose NVARCHAR(MAX);
    SET @sqlOpen = '
    OPEN SYMMETRIC KEY [' + @ma + ']
    DECRYPTION BY CERTIFICATE [' + @BSCert + ']
    WITH PASSWORD = ''Cert_P@$$wOrd'';
    ';
    EXEC (@sqlOpen);

    DECLARE @Ten NVARCHAR(MAX), @SL INT, @LD NVARCHAR(100), @GC NVARCHAR(MAX);

    DECLARE thuoc_cursor CURSOR FOR
    SELECT Ten, SoLuong, LieuDung, GhiChu FROM #Thuoc;

    OPEN thuoc_cursor;
    FETCH NEXT FROM thuoc_cursor INTO @Ten, @SL, @LD, @GC;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO CHITIET_TOATHUOC (maToaThuoc, tenThuoc, soLuong, lieuDung, ghiChu)
        VALUES (
            @toaThuocID,
            EncryptByKey(Key_GUID(@ma), CONVERT(VARBINARY(MAX), @Ten), 1, @ma),
            @SL,
            @LD,
            EncryptByKey(Key_GUID(@ma), CONVERT(VARBINARY(MAX), @GC), 1, @ma)
        );

        FETCH NEXT FROM thuoc_cursor INTO @Ten, @SL, @LD, @GC;
    END

    CLOSE thuoc_cursor;
    DEALLOCATE thuoc_cursor;
    DROP TABLE #Thuoc;

    SET @sqlClose = 'CLOSE SYMMETRIC KEY [' + @ma + ']';
    EXEC (@sqlClose);
END;
GO
	GRANT EXECUTE ON OBJECT::[dbo].sp_ThemToaThuoc_MaHoa TO userBenhVien AS [dbo];
GO


--drop proc sp_ThemToaThuoc_MaHoa


CREATE OR ALTER PROCEDURE sp_XemToaThuocTheoKhamBenh_GiaiMa
    @maKhamBenh INT,
    @ma NVARCHAR(100),      
    @BSCert NVARCHAR(100) 
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sqlOpen NVARCHAR(MAX) = '
        OPEN SYMMETRIC KEY [' + @ma + ']
        DECRYPTION BY CERTIFICATE [' + @BSCert + ']
        WITH PASSWORD = ''Cert_P@$$wOrd'';
    ';
    EXEC (@sqlOpen);

    SELECT 
        ct.maToaThuoc,
        CONVERT(NVARCHAR(MAX), DecryptByKey(ct.tenThuoc, 1, CONVERT(NVARCHAR(100), @ma))) AS tenThuocGiaiMa,
        ct.soLuong,
        ct.lieuDung,
        CONVERT(NVARCHAR(MAX), DecryptByKey(ct.ghiChu, 1, CONVERT(NVARCHAR(100), @ma))) AS ghiChuGiaiMa
    FROM CHITIET_TOATHUOC ct;

    DECLARE @sqlClose NVARCHAR(MAX) = 'CLOSE SYMMETRIC KEY [' + @ma + ']';
    EXEC (@sqlClose);
END;
GO
	GRANT EXECUTE ON OBJECT::sp_XemToaThuocTheoKhamBenh_GiaiMa TO userBenhVien;
Go
--drop proc sp_XemToaThuocTheoKhamBenh_GiaiMa

--Thay ten khoa va ten cert tuong ung
--EXEC sp_XemToaThuocTheoKhamBenh_GiaiMa
--    @maKhamBenh = 2,
--    @ma = 'bb',
--    @BSCert = 'BSCert';

EXEC sp_XemToaThuocTheoKhamBenh_GiaiMa
    @maKhamBenh = 13,
    @ma = 'aaa',
    @BSCert = 'BSCert';
