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

    public virtual DbSet<DanhsachBenhnhan> DanhsachBenhnhans { get; set; }

    public virtual DbSet<Dichvu> Dichvus { get; set; }

    public virtual DbSet<DongiaDichvu> DongiaDichvus { get; set; }

    public virtual DbSet<DongiaThuoc> DongiaThuocs { get; set; }

    public virtual DbSet<Hoadon> Hoadons { get; set; }

    public virtual DbSet<Khambenh> Khambenhs { get; set; }

    public virtual DbSet<Khoa> Khoas { get; set; }

    public virtual DbSet<LichLamviec> LichLamviecs { get; set; }

    public virtual DbSet<Nhanvien> Nhanviens { get; set; }

    public virtual DbSet<Permission> Permissions { get; set; }

    public virtual DbSet<Phongban> Phongbans { get; set; }

    public virtual DbSet<Phongkham> Phongkhams { get; set; }

    public virtual DbSet<ThongtinCanhan> ThongtinCanhans { get; set; }

    public virtual DbSet<Thuoc> Thuocs { get; set; }

    public virtual DbSet<Toathuoc> Toathuocs { get; set; }

    public virtual DbSet<ViewBenhNhanTrongNgay> ViewBenhNhanTrongNgays { get; set; }

    public virtual DbSet<ViewChiTietHoaDonTaiVu> ViewChiTietHoaDonTaiVus { get; set; }

    public virtual DbSet<ViewDieuPhoi> ViewDieuPhois { get; set; }

    public virtual DbSet<ViewDonGiaDichVu> ViewDonGiaDichVus { get; set; }

    public virtual DbSet<ViewKhoa> ViewKhoas { get; set; }

    public virtual DbSet<ViewPhongKhamDp> ViewPhongKhamDps { get; set; }

    public virtual DbSet<ViewTaiVu> ViewTaiVus { get; set; }

    public virtual DbSet<ViewThongTinNhanVien> ViewThongTinNhanViens { get; set; }

    public virtual DbSet<ViewXetNghiemB> ViewXetNghiemBs { get; set; }
    public virtual DbSet<DonGiaDichVuGiaiMa> DonGiaDichVuGiaiMas { get; set; }
    public DbSet<MaNhanVien> MaNhanViens { get; set; } = null!;

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=.; Database=QLBenhVien; Integrated Security=True; TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<MaNhanVien>().HasNoKey();
        modelBuilder.Entity<DonGiaDichVuGiaiMa>().HasNoKey();
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.Username).HasName("PK__ACCOUNT__F3DBC57338CFC3BD");

            entity.ToTable("ACCOUNT");

            entity.Property(e => e.Username)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("username");
            entity.Property(e => e.CreatedDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("createdDate");
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maNhanVien");
            entity.Property(e => e.PasswordHash).HasColumnName("passwordHash");
            entity.Property(e => e.TypeId)
                .HasMaxLength(2)
                .IsUnicode(false)
                .HasColumnName("typeID");

            entity.HasMany(d => d.Permissions).WithMany(p => p.Usernames)
                .UsingEntity<Dictionary<string, object>>(
                    "AccountPermission",
                    r => r.HasOne<Permission>().WithMany()
                        .HasForeignKey("PermissionId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__ACCOUNT_P__permi__1332DBDC"),
                    l => l.HasOne<Account>().WithMany()
                        .HasForeignKey("Username")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__ACCOUNT_P__usern__123EB7A3"),
                    j =>
                    {
                        j.HasKey("Username", "PermissionId").HasName("PK__ACCOUNT___2E59D664DA99B7E9");
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
            entity.HasKey(e => e.MaBacSi).HasName("PK__BACSI__F48AA2377D32B5DA");

            entity.ToTable("BACSI");

            entity.Property(e => e.MaBacSi)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBacSi");
            entity.Property(e => e.ChuyenMon)
                .HasMaxLength(50)
                .HasColumnName("chuyenMon");
            entity.Property(e => e.HasKey)
                .HasMaxLength(1)
                .IsUnicode(false)
                .HasDefaultValue("0")
                .HasColumnName("hasKey");
            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");

            entity.HasOne(d => d.MaBacSiNavigation).WithOne(p => p.Bacsi)
                .HasForeignKey<Bacsi>(d => d.MaBacSi)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__BACSI__maBacSi__4CA06362");

            entity.HasOne(d => d.MaKhoaNavigation).WithMany(p => p.Bacsis)
                .HasForeignKey(d => d.MaKhoa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__BACSI__maKhoa__4BAC3F29");
        });

        modelBuilder.Entity<Benhnhan>(entity =>
        {
            entity.HasKey(e => e.MaBenhNhan).HasName("PK__BENHNHAN__E623122ABB5E9649");

            entity.ToTable("BENHNHAN");

            entity.Property(e => e.MaBenhNhan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBenhNhan");
            entity.Property(e => e.CanNang).HasColumnName("canNang");
            entity.Property(e => e.ChieuCao).HasColumnName("chieuCao");
            entity.Property(e => e.DiaChi)
                .HasMaxLength(255)
                .HasColumnName("diaChi");
            entity.Property(e => e.GioiTinh)
                .HasMaxLength(3)
                .IsUnicode(false)
                .HasColumnName("gioiTinh");
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
            entity.HasKey(e => e.MaChamCong).HasName("PK__CHAMCONG__6851BA2215E9C7AA");

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
                .HasConstraintName("FK__CHAMCONG__maNhan__4F7CD00D");
        });

        modelBuilder.Entity<ChitietHoadonKhamchuabenh>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC271D379C51");

            entity.ToTable("CHITIET_HOADON_KHAMCHUABENH");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia).HasColumnName("donGia");
            entity.Property(e => e.MaChiTietKham).HasColumnName("maChiTietKham");
            entity.Property(e => e.MaHoaDon).HasColumnName("maHoaDon");

            entity.HasOne(d => d.MaChiTietKhamNavigation).WithMany(p => p.ChitietHoadonKhamchuabenhs)
                .HasForeignKey(d => d.MaChiTietKham)
                .HasConstraintName("FK__CHITIET_H__maChi__09A971A2");

            entity.HasOne(d => d.MaHoaDonNavigation).WithMany(p => p.ChitietHoadonKhamchuabenhs)
                .HasForeignKey(d => d.MaHoaDon)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_H__maHoa__08B54D69");
        });

        modelBuilder.Entity<ChitietHoadonThuoc>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC274921100A");

            entity.ToTable("CHITIET_HOADON_THUOC");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia).HasColumnName("donGia");
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
                .HasConstraintName("FK__CHITIET_H__soLuo__04E4BC85");

            entity.HasOne(d => d.MaThuocNavigation).WithMany(p => p.ChitietHoadonThuocs)
                .HasForeignKey(d => d.MaThuoc)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_H__maThu__05D8E0BE");
        });

        modelBuilder.Entity<ChitietKhambenh>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC2788EB2B8A");

            entity.ToTable("CHITIET_KHAMBENH");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.GhiChuBacSiKham).HasColumnName("ghiChuBacSiKham");
            entity.Property(e => e.MaBacSiKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBacSiKham");
            entity.Property(e => e.MaBacSiYeuCau)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBacSiYeuCau");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");
            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.ThoiGianKham)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("thoiGianKham");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(1)
                .IsUnicode(false)
                .HasDefaultValue("0");

            entity.HasOne(d => d.MaBacSiKhamNavigation).WithMany(p => p.ChitietKhambenhMaBacSiKhamNavigations)
                .HasForeignKey(d => d.MaBacSiKham)
                .HasConstraintName("FK__CHITIET_K__maBac__6477ECF3");

            entity.HasOne(d => d.MaBacSiYeuCauNavigation).WithMany(p => p.ChitietKhambenhMaBacSiYeuCauNavigations)
                .HasForeignKey(d => d.MaBacSiYeuCau)
                .HasConstraintName("FK__CHITIET_K__maBac__6383C8BA");

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.ChitietKhambenhs)
                .HasForeignKey(d => d.MaDichVu)
                .HasConstraintName("FK__CHITIET_K__maDic__5FB337D6");

            entity.HasOne(d => d.MaKhamBenhNavigation).WithMany(p => p.ChitietKhambenhs)
                .HasForeignKey(d => d.MaKhamBenh)
                .HasConstraintName("FK__CHITIET_K__maKha__5EBF139D");

            entity.HasOne(d => d.MaKhoaNavigation).WithMany(p => p.ChitietKhambenhs)
                .HasForeignKey(d => d.MaKhoa)
                .HasConstraintName("FK__CHITIET_K__Trang__628FA481");

            entity.HasOne(d => d.MaPhongKhamNavigation).WithMany(p => p.ChitietKhambenhs)
                .HasForeignKey(d => d.MaPhongKham)
                .HasConstraintName("FK__CHITIET_K__maPho__656C112C");
        });

        modelBuilder.Entity<ChitietToathuoc>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__CHITIET___3214EC2734D58815");

            entity.ToTable("CHITIET_TOATHUOC");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.GhiChu).HasColumnName("ghiChu");
            entity.Property(e => e.LieuDung)
                .HasMaxLength(100)
                .HasColumnName("lieuDung");
            entity.Property(e => e.MaToaThuoc).HasColumnName("maToaThuoc");
            entity.Property(e => e.SoLuong).HasColumnName("soLuong");
            entity.Property(e => e.TenThuoc).HasColumnName("tenThuoc");

            entity.HasOne(d => d.MaToaThuocNavigation).WithMany(p => p.ChitietToathuocs)
                .HasForeignKey(d => d.MaToaThuoc)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CHITIET_T__maToa__74AE54BC");
        });

        modelBuilder.Entity<DanhsachBenhnhan>(entity =>
        {
            entity.HasKey(e => new { e.MaBenhNhan, e.MaPhongKham, e.NgayKham }).HasName("PK__DANHSACH__CA58DE5260A26C8C");

            entity.ToTable("DANHSACH_BENHNHAN");

            entity.Property(e => e.MaBenhNhan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBenhNhan");
            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.NgayKham)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("ngayKham");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.TinhTrang)
                .HasMaxLength(1)
                .IsUnicode(false)
                .HasDefaultValue("0")
                .HasColumnName("tinhTrang");

            entity.HasOne(d => d.MaBenhNhanNavigation).WithMany(p => p.DanhsachBenhnhans)
                .HasForeignKey(d => d.MaBenhNhan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DANHSACH___maBen__7B5B524B");

            entity.HasOne(d => d.MaKhamBenhNavigation).WithMany(p => p.DanhsachBenhnhans)
                .HasForeignKey(d => d.MaKhamBenh)
                .HasConstraintName("FK__DANHSACH___maKha__7A672E12");

            entity.HasOne(d => d.MaPhongKhamNavigation).WithMany(p => p.DanhsachBenhnhans)
                .HasForeignKey(d => d.MaPhongKham)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DANHSACH___maPho__797309D9");
        });

        modelBuilder.Entity<Dichvu>(entity =>
        {
            entity.HasKey(e => e.MaDichVu).HasName("PK__DICHVU__80F48B09BB90A48E");

            entity.ToTable("DICHVU");

            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.TenDichVu)
                .HasMaxLength(100)
                .HasColumnName("tenDichVu");
            entity.Property(e => e.TypeId)
                .HasMaxLength(2)
                .IsUnicode(false)
                .HasColumnName("typeID");
        });

        modelBuilder.Entity<DongiaDichvu>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__DONGIA_D__3214EC271BB724BD");

            entity.ToTable("DONGIA_DICHVU");

            entity.HasIndex(e => new { e.MaDichVu, e.NgayApDung }, "UQ__DONGIA_D__FFA8CB38CD41E8CC").IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia).HasColumnName("donGia");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.NgayApDung).HasColumnName("ngayApDung");

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.DongiaDichvus)
                .HasForeignKey(d => d.MaDichVu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__DONGIA_DI__maDic__403A8C7D");
        });

        modelBuilder.Entity<DongiaThuoc>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__DONGIA_T__3214EC27C0762EAB");

            entity.ToTable("DONGIA_THUOC");

            entity.HasIndex(e => new { e.MaThuoc, e.NgayApDung }, "UQ__DONGIA_T__560C3A51A73BE74D").IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DonGia).HasColumnName("donGia");
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
            entity.HasKey(e => e.MaHoaDon).HasName("PK__HOADON__026B4D9AEA52F345");

            entity.ToTable("HOADON");

            entity.Property(e => e.MaHoaDon).HasColumnName("maHoaDon");
            entity.Property(e => e.LoaiHoaDon)
                .HasMaxLength(2)
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
            entity.Property(e => e.SoTienNhan)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("soTienNhan");
            entity.Property(e => e.SoTienThoi)
                .HasColumnType("decimal(15, 2)")
                .HasColumnName("soTienThoi");
            entity.Property(e => e.ThanhToan)
                .HasMaxLength(1)
                .IsUnicode(false)
                .HasDefaultValue("0")
                .HasColumnName("thanhToan");

            entity.HasOne(d => d.MaKhamBenhNavigation).WithMany(p => p.Hoadons)
                .HasForeignKey(d => d.MaKhamBenh)
                .HasConstraintName("FK__HOADON__maKhamBe__00200768");

            entity.HasOne(d => d.NhanVienThuNavigation).WithMany(p => p.Hoadons)
                .HasForeignKey(d => d.NhanVienThu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HOADON__nhanVien__01142BA1");
        });

        modelBuilder.Entity<Khambenh>(entity =>
        {
            entity.HasKey(e => e.MaKhamBenh).HasName("PK__KHAMBENH__D347EDADF5907628");

            entity.ToTable("KHAMBENH");

            entity.HasIndex(e => new { e.MaBenhNhan, e.NgayKham }, "UQ__KHAMBENH__435EA95F241C379C").IsUnique();

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
            entity.Property(e => e.NgayKham)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime")
                .HasColumnName("ngayKham");
            entity.Property(e => e.NgayTaiKham)
                .HasColumnType("datetime")
                .HasColumnName("ngayTaiKham");
            entity.Property(e => e.TrieuChung).HasColumnName("trieuChung");

            entity.HasOne(d => d.MaBacSiNavigation).WithMany(p => p.Khambenhs)
                .HasForeignKey(d => d.MaBacSi)
                .HasConstraintName("FK__KHAMBENH__maBacS__5BE2A6F2");

            entity.HasOne(d => d.MaBenhNhanNavigation).WithMany(p => p.Khambenhs)
                .HasForeignKey(d => d.MaBenhNhan)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KHAMBENH__maBenh__5AEE82B9");
        });

        modelBuilder.Entity<Khoa>(entity =>
        {
            entity.HasKey(e => e.MaKhoa).HasName("PK__KHOA__C79B8C22B7C9324E");

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
            entity.HasKey(e => e.MaLich).HasName("PK__LICH_LAM__F0B8217B1D75F900");

            entity.ToTable("LICH_LAMVIEC");

            entity.Property(e => e.MaLich).HasColumnName("maLich");
            entity.Property(e => e.GhiChu).HasColumnName("ghiChu");
            entity.Property(e => e.GioBatDau).HasColumnName("gioBatDau");
            entity.Property(e => e.GioKetThuc).HasColumnName("gioKetThuc");
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maNhanVien");
            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.NgayLam).HasColumnName("ngayLam");

            entity.HasOne(d => d.MaNhanVienNavigation).WithMany(p => p.LichLamviecs)
                .HasForeignKey(d => d.MaNhanVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LICH_LAMV__maNha__52593CB8");

            entity.HasOne(d => d.MaPhongKhamNavigation).WithMany(p => p.LichLamviecs)
                .HasForeignKey(d => d.MaPhongKham)
                .HasConstraintName("FK__LICH_LAMV__maPho__534D60F1");
        });

        modelBuilder.Entity<Nhanvien>(entity =>
        {
            entity.HasKey(e => e.MaNhanVien).HasName("PK__NHANVIEN__BDDEF20D959D0D7C");

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
                .HasConstraintName("FK__NHANVIEN__maNhan__47DBAE45");

            entity.HasOne(d => d.MaPhongBanNavigation).WithMany(p => p.Nhanviens)
                .HasForeignKey(d => d.MaPhongBan)
                .HasConstraintName("FK__NHANVIEN__maPhon__46E78A0C");
        });

        modelBuilder.Entity<Permission>(entity =>
        {
            entity.HasKey(e => e.PermissionId).HasName("PK__PERMISSI__D821317CB9EC98BE");

            entity.ToTable("PERMISSION");

            entity.HasIndex(e => e.PermissionName, "UQ__PERMISSI__70661EFCBAD43B33").IsUnique();

            entity.Property(e => e.PermissionId).HasColumnName("permissionID");
            entity.Property(e => e.PermissionName)
                .HasMaxLength(100)
                .HasColumnName("permissionName");
        });

        modelBuilder.Entity<Phongban>(entity =>
        {
            entity.HasKey(e => e.MaPhongBan).HasName("PK__PHONGBAN__3A946B0859D5B090");

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
            entity.HasKey(e => e.MaPhongKham).HasName("PK__PHONGKHA__62C17CF717EBB111");

            entity.ToTable("PHONGKHAM");

            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");
            entity.Property(e => e.TenPhongKham)
                .HasMaxLength(100)
                .HasColumnName("tenPhongKham");

            entity.HasOne(d => d.MaDichVuNavigation).WithMany(p => p.Phongkhams)
                .HasForeignKey(d => d.MaDichVu)
                .HasConstraintName("FK__PHONGKHAM__maDic__440B1D61");

            entity.HasOne(d => d.MaKhoaNavigation).WithMany(p => p.Phongkhams)
                .HasForeignKey(d => d.MaKhoa)
                .HasConstraintName("FK__PHONGKHAM__maKho__4316F928");
        });

        modelBuilder.Entity<ThongtinCanhan>(entity =>
        {
            entity.HasKey(e => e.MaNhanVien).HasName("PK__THONGTIN__BDDEF20DAE09C4BB");

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
            entity.HasKey(e => e.MaThuoc).HasName("PK__THUOC__29507A6083065248");

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
        });

        modelBuilder.Entity<Toathuoc>(entity =>
        {
            entity.HasKey(e => e.MaToaThuoc).HasName("PK__TOATHUOC__571828C705DB9F4E");

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
                .HasConstraintName("FK__TOATHUOC__maKham__70DDC3D8");
        });

        modelBuilder.Entity<ViewBenhNhanTrongNgay>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("viewBenhNhanTrongNgay");

            entity.Property(e => e.CanNang).HasColumnName("canNang");
            entity.Property(e => e.ChieuCao).HasColumnName("chieuCao");
            entity.Property(e => e.GioiTinh)
                .HasMaxLength(3)
                .IsUnicode(false)
                .HasColumnName("gioiTinh");
            entity.Property(e => e.HoTen)
                .HasMaxLength(100)
                .HasColumnName("hoTen");
            entity.Property(e => e.MaBenhNhan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBenhNhan");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.NamSinh).HasColumnName("namSinh");
            entity.Property(e => e.Stt).HasColumnName("STT");
            entity.Property(e => e.TinhTrang)
                .HasMaxLength(1)
                .IsUnicode(false)
                .HasColumnName("tinhTrang");
        });

        modelBuilder.Entity<ViewChiTietHoaDonTaiVu>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("view_ChiTietHoaDonTaiVu");

            entity.Property(e => e.DonGia).HasColumnName("donGia");
            entity.Property(e => e.MaChiTietKham).HasColumnName("maChiTietKham");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaHoaDon).HasColumnName("maHoaDon");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.NgayLap)
                .HasColumnType("datetime")
                .HasColumnName("ngayLap");
            entity.Property(e => e.TenBenhNhan)
                .HasMaxLength(100)
                .HasColumnName("tenBenhNhan");
            entity.Property(e => e.TenDichVu)
                .HasMaxLength(100)
                .HasColumnName("tenDichVu");
        });

        modelBuilder.Entity<ViewDieuPhoi>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("viewDieuPhoi");

            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");
            entity.Property(e => e.Stt).HasColumnName("STT");
            entity.Property(e => e.TenBacSi)
                .HasMaxLength(100)
                .HasColumnName("tenBacSi");
            entity.Property(e => e.TenBenhNhan)
                .HasMaxLength(100)
                .HasColumnName("tenBenhNhan");
            entity.Property(e => e.TenDichVu)
                .HasMaxLength(100)
                .HasColumnName("tenDichVu");
            entity.Property(e => e.TenKhoa)
                .HasMaxLength(100)
                .HasColumnName("tenKhoa");
        });

        modelBuilder.Entity<ViewDonGiaDichVu>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("viewDonGiaDichVu");

            entity.Property(e => e.DonGia).HasColumnName("donGia");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.NgayApDung).HasColumnName("ngayApDung");
            entity.Property(e => e.TenDichVu)
                .HasMaxLength(100)
                .HasColumnName("tenDichVu");
        });

        modelBuilder.Entity<ViewKhoa>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("viewKhoa");

            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");
            entity.Property(e => e.TenKhoa)
                .HasMaxLength(100)
                .HasColumnName("tenKhoa");
        });

        modelBuilder.Entity<ViewPhongKhamDp>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("viewPhongKhamDP");

            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaKhoa)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maKhoa");
            entity.Property(e => e.MaPhongKham)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maPhongKham");
            entity.Property(e => e.TenPhongKham)
                .HasMaxLength(100)
                .HasColumnName("tenPhongKham");
        });

        modelBuilder.Entity<ViewTaiVu>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("viewTaiVu");

            entity.Property(e => e.HoTenBenhNhan)
                .HasMaxLength(100)
                .HasColumnName("hoTenBenhNhan");
            entity.Property(e => e.MaBenhNhan)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maBenhNhan");
            entity.Property(e => e.MaChiTietKham).HasColumnName("maChiTietKham");
            entity.Property(e => e.MaDichVu).HasColumnName("maDichVu");
            entity.Property(e => e.MaKhamBenh).HasColumnName("maKhamBenh");
            entity.Property(e => e.Stt).HasColumnName("STT");
            entity.Property(e => e.TenDichVu).HasMaxLength(100);
        });

        modelBuilder.Entity<ViewThongTinNhanVien>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("viewThongTinNhanVien");

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
            entity.Property(e => e.MaNhanVien)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("maNhanVien");
            entity.Property(e => e.NgaySinh).HasColumnName("ngaySinh");
            entity.Property(e => e.PhuCap).HasColumnName("phuCap");
            entity.Property(e => e.SoDienThoai)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("soDienThoai");
        });

        modelBuilder.Entity<ViewXetNghiemB>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("ViewXetNghiemBS");

            entity.Property(e => e.MaDichVu)
                .ValueGeneratedOnAdd()
                .HasColumnName("maDichVu");
            entity.Property(e => e.TenDichVu)
                .HasMaxLength(100)
                .HasColumnName("tenDichVu");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
