using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class Benhnhan
{
    public string MaBenhNhan { get; set; } = null!;

    public string HoTen { get; set; } = null!;

    public int? NamSinh { get; set; }

    public string? DiaChi { get; set; }

    public string? SoDienThoai { get; set; }

    public DateTime? NgayTao { get; set; }

    public virtual Dieuphoi? Dieuphoi { get; set; }

    public virtual ICollection<Khambenh> Khambenhs { get; set; } = new List<Khambenh>();

    public virtual ThongtinPhongkham? ThongtinPhongkham { get; set; }
}
