using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class Logging
{
    public string MaThaoTac { get; set; } = null!;

    public string MaTaiKhoan { get; set; } = null!;

    public string? Bang { get; set; }

    public string? HanhDong { get; set; }

    public string? ChiTiet { get; set; }

    public DateTime? ThoiGian { get; set; }

    public virtual Account MaTaiKhoanNavigation { get; set; } = null!;
}
