using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class ChitietHoadonKhamchuabenh
{
    public int Id { get; set; }

    public int MaHoaDon { get; set; }

    public int MaDichVu { get; set; }

    public decimal DonGia { get; set; }

    public virtual Dichvu MaDichVuNavigation { get; set; } = null!;

    public virtual Hoadon MaHoaDonNavigation { get; set; } = null!;
}
