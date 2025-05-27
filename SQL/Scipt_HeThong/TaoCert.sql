 use QLBenhVien
 go
 
 --Tao Cert Bac Si ma hoa bang password 
 CREATE CERTIFICATE BSCert
 ENCRYPTION BY PASSWORD ='Cert_P@$$wOrd'
 WITH SUBJECT = 'CertificateforBACSI'
 GRANT CONTROL ON CERTIFICATE::BSCert TO userBenhVien;

 -- MASTER KEY
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKeyStrongPassword@123';

-- Cert ma hoa/giai ma cho QLTV
CREATE CERTIFICATE CertQLTV
WITH SUBJECT = 'CertQLTV';
