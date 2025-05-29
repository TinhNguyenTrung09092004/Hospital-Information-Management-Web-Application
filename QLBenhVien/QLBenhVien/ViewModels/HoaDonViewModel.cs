using QLBenhVien.Models;

namespace QLBenhVien.ViewModels
{
    public class HoaDonViewModel
    {
        public HoaDon HoaDon { get; set; } = new();
        public List<ChiTietHoaDonGiaiMa> ChiTietHoaDon { get; set; } = new();
        public decimal TotalAmount => ChiTietHoaDon.Sum(x => x.DonGia ?? 0);
    }
}
