using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class Dieuphoi
{
    public int SoThuTu { get; set; }

    public string? MaPhongBan { get; set; }

    public string? MaBenhNhan { get; set; }

    public string? TinhTrang { get; set; }

    public virtual Benhnhan? MaBenhNhanNavigation { get; set; }

    public virtual Phongban? MaPhongBanNavigation { get; set; }
}
