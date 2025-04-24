using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class Dichvu
{
    public int MaDichVu { get; set; }

    public string TenDichVu { get; set; } = null!;

    public virtual ICollection<ChitietHoadonKhamchuabenh> ChitietHoadonKhamchuabenhs { get; set; } = new List<ChitietHoadonKhamchuabenh>();

    public virtual ICollection<ChitietKhambenh> ChitietKhambenhs { get; set; } = new List<ChitietKhambenh>();

    public virtual ICollection<DongiaDichvu> DongiaDichvus { get; set; } = new List<DongiaDichvu>();
}
