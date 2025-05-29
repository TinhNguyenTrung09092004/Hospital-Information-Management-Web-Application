using Microsoft.AspNetCore.Mvc;
using QLBenhVien.Entities;
using QLBenhVien.Services;
using Microsoft.EntityFrameworkCore;
using QLBenhVien.Models;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Authorization;
using X.PagedList.Extensions;
using System.Data;
using QLBenhVien.ViewModels;
namespace QLBenhVien.Controllers
{
    [Authorize]
    public class TaiVuController : Controller
    {
        private readonly DynamicConnectionProvider _connProvider;
        private readonly KeyVaultService _keyVaultService;
        public TaiVuController(
            DynamicConnectionProvider connProvider,
            KeyVaultService keyVaultService)
        {
            _connProvider = connProvider;
            _keyVaultService = keyVaultService;
        }

        public async Task<IActionResult> Index(int? page)
        {
            var connStr = await _connProvider.GetDataConnectionStringAsync();
            using var context = QlbenhVienContextFactory.Create(connStr);

            var allRecords = await context.ViewTaiVus
                .FromSqlRaw("EXEC sp_viewTaiVu")
                .ToListAsync();

            int pageSize = 5;
            int pageNumber = page ?? 1;

            var pagedList = allRecords.ToPagedList(pageNumber, pageSize);
            return View(pagedList);
        }

        // Controller sửa lại
        // Controller sửa lại
        [HttpPost]
        public async Task<IActionResult> ThanhToan(int maKhamBenh)
        {
            var connStr = await _connProvider.GetDataConnectionStringAsync();
            var maNhanVien = User.Claims.FirstOrDefault(c => c.Type == "MaNhanVien")?.Value;
            var certName = await _keyVaultService.GetSecretAsync("CertQLTV");

            using (var conn = new SqlConnection(connStr))
            {
                await conn.OpenAsync();

                using (var cmd = new SqlCommand("sp_TaoHoaDonKCB", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@maKhamBenh", maKhamBenh);
                    cmd.Parameters.AddWithValue("@nhanVienThu", maNhanVien);
                    cmd.Parameters.AddWithValue("@certName", certName);
                    await cmd.ExecuteNonQueryAsync();
                }
            }

            using var context = QlbenhVienContextFactory.Create(connStr);

            // Kiểm tra hóa đơn mới được tạo
            var hoaDonCreated = await context.Hoadons
                .Where(h => h.MaKhamBenh == maKhamBenh && h.ThanhToan == "0")
                .OrderByDescending(h => h.MaHoaDon)
                .FirstOrDefaultAsync();

            if (hoaDonCreated == null)
            {
                TempData["ErrorMessage"] = "Không tạo được hóa đơn. Kiểm tra dữ liệu hoặc mã khám bệnh.";
                return RedirectToAction("Index");
            }

            var chiTietHoaDon = await context.Database
         .SqlQuery<ChiTietHoaDonGiaiMa>($"EXEC sp_XemChiTietHoaDonTheoKhamBenh @maKhamBenh={maKhamBenh}, @certName={certName}")
         .ToListAsync();

          

            if (!chiTietHoaDon.Any())
            {
                TempData["ErrorMessage"] = "Không có chi tiết hóa đơn nào.";
                return RedirectToAction("Index");
            }

            var model = new HoaDonViewModel
            {
                HoaDon = new HoaDon
                {
                    MaHoaDon = hoaDonCreated.MaHoaDon 
                },
                ChiTietHoaDon = chiTietHoaDon
            };
           


            return View("ThanhToan", model);
        }
        [HttpPost]
        public async Task<IActionResult> XacNhanThanhToan(HoaDonViewModel model)
        {
            Console.WriteLine("----- [XacNhanThanhToan] -----");
            Console.WriteLine($"MaHoaDon: {model.HoaDon.MaHoaDon}");
            Console.WriteLine($"SoTienNhan: {model.HoaDon.SoTienNhan}");
            Console.WriteLine($"SoTienThoi: {model.HoaDon.SoTienThoi}");

            var connStr = await _connProvider.GetDataConnectionStringAsync();

            try
            {
                using var conn = new SqlConnection(connStr);
                await conn.OpenAsync();

                using var cmd = new SqlCommand("sp_CapNhatThanhToanHoaDon", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@maHoaDon", model.HoaDon.MaHoaDon);
                cmd.Parameters.AddWithValue("@soTienNhan", model.HoaDon.SoTienNhan);
                cmd.Parameters.AddWithValue("@soTienThoi", model.HoaDon.SoTienThoi);

                await cmd.ExecuteNonQueryAsync();
                TempData["Success_ThanhToanHDKCB"] = "Thanh toán thành công.";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Lỗi: " + ex.Message;
            }

            return RedirectToAction("Index");
        }



    }
}
