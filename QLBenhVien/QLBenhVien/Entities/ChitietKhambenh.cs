using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class ChitietKhambenh
{
    public int Id { get; set; }

    public int? MaKhamBenh { get; set; }

    public int? MaDichVu { get; set; }

    public DateTime? ThoiGianKham { get; set; }

    public string? TrangThai { get; set; }

    public virtual Dichvu? MaDichVuNavigation { get; set; }

    public virtual Khambenh? MaKhamBenhNavigation { get; set; }
}
