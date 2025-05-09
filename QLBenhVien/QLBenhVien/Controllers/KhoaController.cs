using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using QLBenhVien.Entities;
using QLBenhVien.Services;
using X.PagedList;
using Microsoft.AspNetCore.Authorization;
using X.PagedList.Extensions;

namespace QLBenhVien.Controllers
{
    [Authorize]
    public class KhoaController : Controller
    {
        public async Task<IActionResult> Index(int? page)
        {
            var dbUser = User.FindFirst("DBUser")?.Value;
            var dbPass = User.FindFirst("DBPass")?.Value;
            var dbName = User.FindFirst("DBName")?.Value;
            var server = User.FindFirst("Server")?.Value;

            if (string.IsNullOrEmpty(dbUser) || string.IsNullOrEmpty(dbPass) ||
                string.IsNullOrEmpty(dbName) || string.IsNullOrEmpty(server))
            {
                return Unauthorized();
            }

            var connectionString = $"Server={server};Database={dbName};User ID={dbUser};Password={dbPass};TrustServerCertificate=True;";
            using var context = QlbenhVienContextFactory.Create(connectionString);

            var allKhoas = await context.Khoas
                .FromSqlRaw("EXEC sp_XemKhoa")
                .ToListAsync();

            int pageSize = 10;
            int pageNumber = page ?? 1;

            var pagedList = allKhoas.ToPagedList(pageNumber, pageSize);

            return View(pagedList);
        }
    }
}
