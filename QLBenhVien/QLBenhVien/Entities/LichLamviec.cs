using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class LichLamviec
{
    public int MaLich { get; set; }

    public string MaBacSi { get; set; } = null!;

    public string MaPhongKham { get; set; } = null!;

    public DateOnly NgayTruc { get; set; }

    public TimeOnly? GioBatDau { get; set; }

    public TimeOnly? GioKetThuc { get; set; }

    public string? GhiChu { get; set; }

    public virtual Nhanvien MaBacSiNavigation { get; set; } = null!;

    public virtual Phongkham MaPhongKhamNavigation { get; set; } = null!;
}
