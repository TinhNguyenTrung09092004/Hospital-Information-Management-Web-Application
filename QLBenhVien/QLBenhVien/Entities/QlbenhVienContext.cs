using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using QLBenhVien.Models;

namespace QLBenhVien.Entities;

public partial class QlbenhVienContext : DbContext
{
    public QlbenhVienContext()
    {
    }

    public QlbenhVienContext(DbContextOptions<QlbenhVienContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Account> Accounts { get; set; }

    public virtual DbSet<Bacsi> Bacsis { get; set; }

    public virtual DbSet<Benhnhan> Benhnhans { get; set; }

    public virtual DbSet<Chamcong> Chamcongs { get; set; }

    public virtual DbSet<ChitietHoadonKhamchuabenh> ChitietHoadonKhamchuabenhs { get; set; }

    public virtual DbSet<ChitietHoadonThuoc> ChitietHoadonThuocs { get; set; }

    public virtual DbSet<ChitietKhambenh> ChitietKhambenhs { get; set; }

    public virtual DbSet<ChitietToathuoc> ChitietToathuocs { get; set; }

    public virtual DbSet<Dichvu> Dichvus { get; set; }

    public virtual DbSet<DongiaDichvu> DongiaDichvus { get; set; }

    public virtual DbSet<DongiaThuoc> DongiaThuocs { get; set; }

    public virtual DbSet<Hoadon> Hoadons { get; set; }

    public virtual DbSet<Khambenh> Khambenhs { get; set; }

    public virtual DbSet<Khoa> Khoas { get; set; }

    public virtual DbSet<LichLamviec> LichLamviecs { get; set; }

    public virtual DbSet<Logging> Loggings { get; set; }

    public virtual DbSet<Nhanvien> Nhanviens { get; set; }

    public virtual DbSet<Permission> Permissions { get; set; }

    public virtual DbSet<Phongban> Phongbans { get; set; }

    public virtual DbSet<Phongkham> Phongkhams { get; set; }

    public virtual DbSet<ThongtinCanhan> ThongtinCanhans { get; set; }

    public virtual DbSet<Thuoc> Thuocs { get; set; }

    public virtual DbSet<Toathuoc> Toathuocs { get; set; }

    public virtual DbSet<AccountInfo> AccountInfos { get; set; }

    //    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    //#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
    //        => optionsBuilder.UseSqlServer("Server=.;Database=QLBenhVien;Integrated Security=True; TrustServerCertificate=Yes");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.Username).HasName("PK__ACCOUNT__F3DBC57354A94BCD");

            entity.ToTable("ACCOUNT");

            entity.Property(e => e.Username)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("username");
            entity.Property(e => e.CreatedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("createdDate");
            entity.Property(e => e.PasswordHash).HasColumnName("passwordHash");
            entity.Property(e => e.UserId)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("userID");

            entity.HasOne(d => d.User).WithMany(p => p.Accounts)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK__ACCOUNT__userID__3F115E1A");

            entity.HasMany(d => d.Permissions).WithMany(p => p.Usernames)
                .UsingEntity<Dictionary<string, object>>(
                    "AccountPermission",
                    r => r.HasOne<Permission>().WithMany()
                        .HasForeignKey("PermissionId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__ACCOUNT_P__permi__42E1EEFE"),
                    l => l.HasOne<Account>().WithMany()
                        .HasForeignKey("Username")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__ACCOUNT_P__usern__41EDCAC5"),
                    j =>
                    {
                        j.HasKey("Username", "PermissionId").HasName("PK__ACCOUNT___2E59D664FF201E9D");
                        j.ToTable("ACCOUNT_PERMISSION");
                        j.IndexerProperty<string>("Username")
                            .HasMaxLength(10)
                            .IsUnicode(false)
                            .HasColumnName("username");
                        j.IndexerProperty<int>("PermissionId").HasColumnName("permissionID");
                    });
        });

        modelBuilder.Entity<Bacsi>(entity =>
        {
            entity.HasKey(e => e.MaBacSi).HasName("PK__BACSI__F48AA2379C1A4ADF");

            entity.ToTable("BACSI");

            entity.Property(e => e.MaBacSi)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBacSi");
            entity.Property(e => e.ChuyenMon)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("chuyenMon");
            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");

            entity.HasOne(d => d.MaBacSiNavigation).WithOne(p => p.Bacsi)
                .HasForeignKey<Bacsi>(d => d.MaBacSi)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__BACSI__maBacSi__5070F446");

            entity.HasOne(d => d.MaKhoaNavigation).WithMany(p => p.Bacsis)
                .HasForeignKey(d => d.MaKhoa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__BACSI__maKhoa__4F7CD00D");
        });

        modelBuilder.Entity<Benhnhan>(entity =>
        {
            entity.HasKey(e => e.MaBenhNhan).HasName("PK__BENHNHAN__E623122AFB440BD9");

            entity.ToTable("BENHNHAN");

            entity.Property(e => e.MaBenhNhan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBenhNhan");
            entity.Property(e => e.DiaChi)
                .HasMaxLength(255)
                .HasColumnName("diaChi");
            entity.Property(e => e.HoTen)
                .HasMaxLength(100)
                .HasColumnName("hoTen");
            entity.Property(e => e.NamSinh).HasColumnName("namSinh");
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("ngayTao");
            entity.Property(e => e.SoDienThoai)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("soDienThoai");
        });

        modelBuilder.Entity<Chamcong>(entity =>
        {
            entity.HasKey(e => e.MaChamCong).HasName("PK__CHAMCONG__6851BA22305EF9C9");

            entity.ToTable("CHAMCONG");

            entity.Property(e => e.MaChamCong).HasColumnName("maChamCong");
            entity.Property(e => e.GhiChu).HasColumnName("ghiChu");
            entity.Property(e => e.GioRa).HasColumnName("gioRa");
            entity.Property(e => e.GioVao).HasColumnName("gioVao");
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maNhanVien");
            entity.Property(e => e.NgayChamCong).HasColumnName("ngayChamCong");

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.Chamcongs)
                .HasForeignKey(d => d.MaNhanVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHAMCONG__maNhan__534D60F1");
        });

        modelBuilder.Entity<ChitietHoadonKhamchuabenh>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC27D3039C08");

            entity.ToTable("CHITIET_HOADON_KHAMCHUABENH");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("donGia");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaHoaDon).HasColumnName("maHoaDon");

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.ChitietHoadonKhamchuabenhs)
                .HasForeignKey(d => d.MaDichVu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_H__maDic__17036CC0");

            entity.HasOne(d => d.MaHoaDonNavigation).WithMany(p => p.ChitietHoadonKhamchuabenhs)
                .HasForeignKey(d => d.MaHoaDon)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_H__maHoa__160F4887");
        });

        modelBuilder.Entity<ChitietHoadonThuoc>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC277558DD5A");

            entity.ToTable("CHITIET_HOADON_THUOC");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("donGia");
            entity.Property(e => e.DonViTinh)
                .HasMaxLength(20)
                .HasColumnName("donViTinh");
            entity.Property(e => e.MaHoaDon).HasColumnName("maHoaDon");
            entity.Property(e => e.MaThuoc)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maThuoc");
            entity.Property(e => e.SoLuong).HasColumnName("soLuong");

            entity.HasOne(d => d.MaHoaDonNavigation).WithMany(p => p.ChitietHoadonThuocs)
                .HasForeignKey(d => d.MaHoaDon)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_H__soLuo__123EB7A3");

            entity.HasOne(d => d.MaThuocNavigation).WithMany(p => p.ChitietHoadonThuocs)
                .HasForeignKey(d => d.MaThuoc)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_H__maThu__1332DBDC");
        });

        modelBuilder.Entity<ChitietKhambenh>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC27F12773ED");

            entity.ToTable("CHITIET_KHAMBENH");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.ThoiGianKham)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("thoiGianKham");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("ChUA_THUC_HIEN");

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.ChitietKhambenhs)
                .HasForeignKey(d => d.MaDichVu)
                .HasConstraintName("FK__CHITIET_K__maDic__7D439ABD");

            entity.HasOne(d => d.MaKhamBenhNavigation).WithMany(p => p.ChitietKhambenhs)
                .HasForeignKey(d => d.MaKhamBenh)
                .HasConstraintName("FK__CHITIET_K__maKha__7C4F7684");
        });

        modelBuilder.Entity<ChitietToathuoc>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC27F6D6A75C");

            entity.ToTable("CHITIET_TOATHUOC");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.GhiChu).HasColumnName("ghiChu");
            entity.Property(e => e.LieuDung)
                .HasMaxLength(100)
                .HasColumnName("lieuDung");
            entity.Property(e => e.MaThuoc)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maThuoc");
            entity.Property(e => e.MaToaThuoc).HasColumnName("maToaThuoc");
            entity.Property(e => e.SoLuong).HasColumnName("soLuong");

            entity.HasOne(d => d.MaThuocNavigation).WithMany(p => p.ChitietToathuocs)
                .HasForeignKey(d => d.MaThuoc)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_T__maThu__797309D9");

            entity.HasOne(d => d.MaToaThuocNavigation).WithMany(p => p.ChitietToathuocs)
                .HasForeignKey(d => d.MaToaThuoc)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_T__maToa__787EE5A0");
        });

        modelBuilder.Entity<Dichvu>(entity =>
        {
            entity.HasKey(e => e.MaDichVu).HasName("PK__DICHVU__80F48B0963609D7E");

            entity.ToTable("DICHVU");

            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.TenDichVu)
                .HasMaxLength(100)
                .HasColumnName("tenDichVu");
        });

        modelBuilder.Entity<DongiaDichvu>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__DONGIA_D__3214EC27096817D8");

            entity.ToTable("DONGIA_DICHVU");

            entity.HasIndex(e => new { e.MaDichVu, e.NgayApDung }, "UQ__DONGIA_D__FFA8CB3895946F8F").IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("donGia");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.NgayApDung).HasColumnName("ngayApDung");

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.DongiaDichvus)
                .HasForeignKey(d => d.MaDichVu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DONGIA_DI__maDic__656C112C");
        });

        modelBuilder.Entity<DongiaThuoc>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__DONGIA_T__3214EC275AEFA127");

            entity.ToTable("DONGIA_THUOC");

            entity.HasIndex(e => new { e.MaThuoc, e.NgayApDung }, "UQ__DONGIA_T__560C3A519EEB9281").IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("donGia");
            entity.Property(e => e.MaThuoc)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maThuoc");
            entity.Property(e => e.NgayApDung).HasColumnName("ngayApDung");

            entity.HasOne(d => d.MaThuocNavigation).WithMany(p => p.DongiaThuocs)
                .HasForeignKey(d => d.MaThuoc)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DONGIA_TH__maThu__6D0D32F4");
        });

        modelBuilder.Entity<Hoadon>(entity =>
        {
            entity.HasKey(e => e.MaHoaDon).HasName("PK__HOADON__026B4D9A560069AD");

            entity.ToTable("HOADON");

            entity.Property(e => e.MaHoaDon).HasColumnName("maHoaDon");
            entity.Property(e => e.LoaiHoaDon)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("loaiHoaDon");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.NgayLap)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("ngayLap");
            entity.Property(e => e.NhanVienThu)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("nhanVienThu");
            entity.Property(e => e.ThanhToan)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasDefaultValue("CHUA_THANH_TOAN")
                .HasColumnName("thanhToan");
            entity.Property(e => e.TongTien)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("tongTien");

            entity.HasOne(d => d.MaKhamBenhNavigation).WithMany(p => p.Hoadons)
                .HasForeignKey(d => d.MaKhamBenh)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HOADON__maKhamBe__0D7A0286");

            entity.HasOne(d => d.NhanVienThuNavigation).WithMany(p => p.Hoadons)
                .HasForeignKey(d => d.NhanVienThu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HOADON__nhanVien__0E6E26BF");
        });

        modelBuilder.Entity<Khambenh>(entity =>
        {
            entity.HasKey(e => e.MaKhamBenh).HasName("PK__KHAMBENH__D347EDADC19BE223");

            entity.ToTable("KHAMBENH");

            entity.HasIndex(e => new { e.MaBenhNhan, e.NgayKham }, "UQ__KHAMBENH__435EA95F7B02BC65").IsUnique();

            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.ChanDoanCuoiCung).HasColumnName("chanDoanCuoiCung");
            entity.Property(e => e.MaBacSi)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBacSi");
            entity.Property(e => e.MaBenhNhan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBenhNhan");
            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.NgayKham)
                .HasColumnType("datetime")
                .HasColumnName("ngayKham");
            entity.Property(e => e.TrieuChung).HasColumnName("trieuChung");

            entity.HasOne(d => d.MaBacSiNavigation).WithMany(p => p.Khambenhs)
                .HasForeignKey(d => d.MaBacSi)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KHAMBENH__maBacS__5EBF139D");

            entity.HasOne(d => d.MaBenhNhanNavigation).WithMany(p => p.Khambenhs)
                .HasForeignKey(d => d.MaBenhNhan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KHAMBENH__maBenh__5DCAEF64");

            entity.HasOne(d => d.MaPhongKhamNavigation).WithMany(p => p.Khambenhs)
                .HasForeignKey(d => d.MaPhongKham)
                .HasConstraintName("FK__KHAMBENH__maPhon__5FB337D6");
        });

        modelBuilder.Entity<Khoa>(entity =>
        {
            entity.HasKey(e => e.MaKhoa).HasName("PK__KHOA__C79B8C2251DB5804");

            entity.ToTable("KHOA");

            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");
            entity.Property(e => e.TenKhoa)
                .HasMaxLength(100)
                .HasColumnName("tenKhoa");
        });

        modelBuilder.Entity<LichLamviec>(entity =>
        {
            entity.HasKey(e => e.MaLich).HasName("PK__LICH_LAM__F0B8217B8947D1C6");

            entity.ToTable("LICH_LAMVIEC");

            entity.Property(e => e.MaLich).HasColumnName("maLich");
            entity.Property(e => e.GhiChu).HasColumnName("ghiChu");
            entity.Property(e => e.GioBatDau).HasColumnName("gioBatDau");
            entity.Property(e => e.GioKetThuc).HasColumnName("gioKetThuc");
            entity.Property(e => e.MaBacSi)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBacSi");
            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.NgayTruc).HasColumnName("ngayTruc");

            entity.HasOne(d => d.MaBacSiNavigation).WithMany(p => p.LichLamviecs)
                .HasForeignKey(d => d.MaBacSi)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LICH_LAMV__maBac__5629CD9C");

            entity.HasOne(d => d.MaPhongKhamNavigation).WithMany(p => p.LichLamviecs)
                .HasForeignKey(d => d.MaPhongKham)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LICH_LAMV__maPho__571DF1D5");
        });

        modelBuilder.Entity<Logging>(entity =>
        {
            entity.HasKey(e => e.MaThaoTac).HasName("PK__LOGGING__65F019B65513E6A8");

            entity.ToTable("LOGGING");

            entity.Property(e => e.MaThaoTac)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maThaoTac");
            entity.Property(e => e.Bang)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("bang");
            entity.Property(e => e.ChiTiet).HasColumnName("chiTiet");
            entity.Property(e => e.HanhDong)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("hanhDong");
            entity.Property(e => e.MaTaiKhoan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maTaiKhoan");
            entity.Property(e => e.ThoiGian)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("thoiGian");

            entity.HasOne(d => d.MaTaiKhoanNavigation).WithMany(p => p.Loggings)
                .HasForeignKey(d => d.MaTaiKhoan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LOGGING__maTaiKh__46B27FE2");
        });

        modelBuilder.Entity<Nhanvien>(entity =>
        {
            entity.HasKey(e => e.MaNhanVien).HasName("PK__NHANVIEN__BDDEF20D985ADD1A");

            entity.ToTable("NHANVIEN");

            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maNhanVien");
            entity.Property(e => e.ChucVu)
                .HasMaxLength(2)
                .IsUnicode(false)
                .HasColumnName("chucVu");
            entity.Property(e => e.MaPhongBan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongBan");

            entity.HasOne(d => d.MaNhanVienNavigation).WithOne(p => p.Nhanvien)
                .HasForeignKey<Nhanvien>(d => d.MaNhanVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__NHANVIEN__maNhan__4CA06362");

            entity.HasOne(d => d.MaPhongBanNavigation).WithMany(p => p.Nhanviens)
                .HasForeignKey(d => d.MaPhongBan)
                .HasConstraintName("FK__NHANVIEN__maPhon__4BAC3F29");
        });

        modelBuilder.Entity<Permission>(entity =>
        {
            entity.HasKey(e => e.PermissionId).HasName("PK__PERMISSI__D821317C0AA40ACE");

            entity.ToTable("PERMISSION");

            entity.HasIndex(e => e.PermissionName, "UQ__PERMISSI__70661EFC43667E63").IsUnique();

            entity.Property(e => e.PermissionId).HasColumnName("permissionID");
            entity.Property(e => e.PermissionName)
                .HasMaxLength(100)
                .HasColumnName("permissionName");
        });

        modelBuilder.Entity<Phongban>(entity =>
        {
            entity.HasKey(e => e.MaPhongBan).HasName("PK__PHONGBAN__3A946B08EE18610A");

            entity.ToTable("PHONGBAN");

            entity.Property(e => e.MaPhongBan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongBan");
            entity.Property(e => e.TenPhongBan)
                .HasMaxLength(100)
                .HasColumnName("tenPhongBan");
        });

        modelBuilder.Entity<Phongkham>(entity =>
        {
            entity.HasKey(e => e.MaPhongKham).HasName("PK__PHONGKHA__62C17CF71DB610CE");

            entity.ToTable("PHONGKHAM");

            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");
            entity.Property(e => e.TenPhongKham)
                .HasMaxLength(100)
                .HasColumnName("tenPhongKham");

            entity.HasOne(d => d.MaKhoaNavigation).WithMany(p => p.Phongkhams)
                .HasForeignKey(d => d.MaKhoa)
                .HasConstraintName("FK__PHONGKHAM__maKho__48CFD27E");
        });

        modelBuilder.Entity<ThongtinCanhan>(entity =>
        {
            entity.HasKey(e => e.MaNhanVien).HasName("PK__THONGTIN__BDDEF20D6D9AFCA6");

            entity.ToTable("THONGTIN_CANHAN");

            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maNhanVien");
            entity.Property(e => e.DiaChi)
                .HasMaxLength(255)
                .HasColumnName("diaChi");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false)
                .HasColumnName("email");
            entity.Property(e => e.HoTen)
                .HasMaxLength(100)
                .HasColumnName("hoTen");
            entity.Property(e => e.LuongCoBan).HasColumnName("luongCoBan");
            entity.Property(e => e.NgaySinh).HasColumnName("ngaySinh");
            entity.Property(e => e.PhuCap).HasColumnName("phuCap");
            entity.Property(e => e.SoDienThoai)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("soDienThoai");
        });

        modelBuilder.Entity<Thuoc>(entity =>
        {
            entity.HasKey(e => e.MaThuoc).HasName("PK__THUOC__29507A60375A4FCD");

            entity.ToTable("THUOC");

            entity.Property(e => e.MaThuoc)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maThuoc");
            entity.Property(e => e.DonViTinh)
                .HasMaxLength(20)
                .HasColumnName("donViTinh");
            entity.Property(e => e.NgayCapNhat)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("ngayCapNhat");
            entity.Property(e => e.SoLuongTon).HasColumnName("soLuongTon");
            entity.Property(e => e.TenThuoc)
                .HasMaxLength(100)
                .HasColumnName("tenThuoc");
            entity.Property(e => e.ThongTin).HasColumnName("thongTin");
        });

        modelBuilder.Entity<Toathuoc>(entity =>
        {
            entity.HasKey(e => e.MaToaThuoc).HasName("PK__TOATHUOC__571828C74257650F");

            entity.ToTable("TOATHUOC");

            entity.Property(e => e.MaToaThuoc).HasColumnName("maToaThuoc");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.NgayKe)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("ngayKe");

            entity.HasOne(d => d.MaKhamBenhNavigation).WithMany(p => p.Toathuocs)
                .HasForeignKey(d => d.MaKhamBenh)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TOATHUOC__maKham__74AE54BC");
        });

        modelBuilder.Entity<AccountInfo>().HasNoKey();
        modelBuilder.Entity<AccountInfo>().ToView(null);
        OnModelCreatingPartial(modelBuilder);

    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
