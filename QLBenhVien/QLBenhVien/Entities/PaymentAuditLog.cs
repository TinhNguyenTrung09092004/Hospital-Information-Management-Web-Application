using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class PaymentAuditLog
{
    public int LogId { get; set; }

    public int? MaHoaDon { get; set; }

    public decimal? SoTienNhan { get; set; }

    public decimal? TongTien { get; set; }

    public decimal? Difference { get; set; }

    public string? EventType { get; set; }

    public DateTime? EventTime { get; set; }

    public string? UserName { get; set; }

    public int? MaKhamBenh { get; set; }

    public string? MaBenhNhan { get; set; }

    public string? TenBenhNhan { get; set; }

    public string? DichVu { get; set; }

    public string? NhanVienThu { get; set; }

    public virtual Hoadon? MaHoaDonNavigation { get; set; }
}
