using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class Khambenh
{
    public int MaKhamBenh { get; set; }

    public string MaBenhNhan { get; set; } = null!;

    public string MaBacSi { get; set; } = null!;

    public string? MaPhongKham { get; set; }

    public DateTime NgayKham { get; set; }

    public byte[]? TrieuChung { get; set; }

    public byte[]? ChanDoanCuoiCung { get; set; }

    public virtual ICollection<ChitietKhambenh> ChitietKhambenhs { get; set; } = new List<ChitietKhambenh>();

    public virtual ICollection<Hoadon> Hoadons { get; set; } = new List<Hoadon>();

    public virtual Bacsi MaBacSiNavigation { get; set; } = null!;

    public virtual Benhnhan MaBenhNhanNavigation { get; set; } = null!;

    public virtual Phongkham? MaPhongKhamNavigation { get; set; }

    public virtual ICollection<Toathuoc> Toathuocs { get; set; } = new List<Toathuoc>();
}
