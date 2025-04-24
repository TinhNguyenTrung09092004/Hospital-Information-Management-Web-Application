using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class Phongkham
{
    public string MaPhongKham { get; set; } = null!;

    public string? TenPhongKham { get; set; }

    public string? MaKhoa { get; set; }

    public virtual ICollection<Khambenh> Khambenhs { get; set; } = new List<Khambenh>();

    public virtual ICollection<LichLamviec> LichLamviecs { get; set; } = new List<LichLamviec>();

    public virtual Khoa? MaKhoaNavigation { get; set; }
}
