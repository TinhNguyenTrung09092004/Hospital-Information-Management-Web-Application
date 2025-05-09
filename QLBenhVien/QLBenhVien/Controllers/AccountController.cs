using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using QLBenhVien.Entities;
using QLBenhVien.Models;
using QLBenhVien.Services;
using System.Security.Claims;

namespace QLBenhVien.Controllers
{
    public class AccountController : Controller
    {
        private readonly KeyVaultService _keyVault;

        public AccountController(KeyVaultService keyVault)
        {
            _keyVault = keyVault;
        }

        [AllowAnonymous]
        [HttpGet]
        public IActionResult Login() => View();

        [AllowAnonymous]
        [HttpPost]
        public async Task<IActionResult> Login(AccountLogin model)
        {
            if (!ModelState.IsValid)
                return View(model);

            // 🔐 Lấy thông tin kết nối từ Azure Key Vault cho database ACCOUNT
            string server = await _keyVault.GetSecretAsync("serverName");
            string accountDb = await _keyVault.GetSecretAsync("databaseAccount");
            string accUser = await _keyVault.GetSecretAsync("loginUser");
            string accPass = await _keyVault.GetSecretAsync("loginPass");

            string accountConnStr = $"Server={server};Database={accountDb};User ID={accUser};Password={accPass};TrustServerCertificate=True;";
            using var accountContext = QlbenhVienAccountContextFactory.Create(accountConnStr);

            // Gọi stored procedure để kiểm tra đăng nhập
            var usernameParam = new SqlParameter("@username", model.Username);
            var passwordParam = new SqlParameter("@password", model.Password);

            var result = await accountContext.AccountInfos
                .FromSqlRaw("EXEC sp_Login_CheckAccount @username, @password", usernameParam, passwordParam)
                .ToListAsync();

            if (!result.Any(r => r.Username != null))
            {
                ModelState.AddModelError("", "Sai tên đăng nhập hoặc mật khẩu.");
                return View(model);
            }

            var account = result[0];

            // 🔐 Tạo kết nối tới database dữ liệu chính dựa vào quyền (Bác sĩ hoặc QLNS)
            string dataDb = await _keyVault.GetSecretAsync("databaseData");
            string dbUserKey = account.TypeID == "1" ? "DbUser-BS" : "DbUser-QLNS";
            string dbPassKey = account.TypeID == "1" ? "DbPass-BS" : "DbPass-QLNS";
            string dbUser = await _keyVault.GetSecretAsync(dbUserKey);
            string dbPass = await _keyVault.GetSecretAsync(dbPassKey);

            string dataConnStr = $"Server={server};Database={dataDb};User ID={dbUser};Password={dbPass};TrustServerCertificate=True;";
            using var dataContext = QlbenhVienContextFactory.Create(dataConnStr);

            // Tạo thông tin đăng nhập (claims)
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, account.Username ?? ""),
                new Claim("TypeID", account.TypeID ?? ""),
                //new Claim("PermissionID", account.PermissionID?.ToString() ?? ""),
                new Claim("DBUser", dbUser),
                new Claim("DBPass", dbPass),
                new Claim("DBName", dataDb),
                new Claim("Server", server)
            };
            foreach (var permission in result)
            {
                if (permission.PermissionID.HasValue)
                {
                    claims.Add(new Claim("PermissionID", permission.PermissionID.Value.ToString()));
                }
            }
            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);

            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);
            return RedirectToAction("Index", "Home");
        }

        [AllowAnonymous]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login", "Account");
        }
    }
}
