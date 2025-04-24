using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class ChitietToathuoc
{
    public int Id { get; set; }

    public int MaToaThuoc { get; set; }

    public string MaThuoc { get; set; } = null!;

    public int SoLuong { get; set; }

    public string? LieuDung { get; set; }

    public string? GhiChu { get; set; }

    public virtual Thuoc MaThuocNavigation { get; set; } = null!;

    public virtual Toathuoc MaToaThuocNavigation { get; set; } = null!;
}
