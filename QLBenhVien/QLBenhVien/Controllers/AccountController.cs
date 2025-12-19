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
using System.Data;
using System.Text;

namespace QLBenhVien.Controllers
{
    public class AccountController : Controller
    {
        private readonly DynamicConnectionProvider _connProvider;

        public AccountController(DynamicConnectionProvider connProvider)
        {
            _connProvider = connProvider;
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

            // Connect QLBenhVien_ACCOUNT
            string accountConnStr = await _connProvider.GetAccountConnectionStringAsync();
            using var accountContext = QlbenhVienAccountContextFactory.Create(accountConnStr);

            // Hash
            using var sha256 = System.Security.Cryptography.SHA256.Create();
            var passwordBytes = System.Text.Encoding.UTF8.GetBytes(model.Password);
            var passwordHash = sha256.ComputeHash(passwordBytes);

            var usernameParam = new SqlParameter("@username", model.Username);
            var passwordHashParam = new SqlParameter("@passwordHash", SqlDbType.VarBinary, -1)
            {
                Value = passwordHash
            };

            var result = await accountContext.AccountInfos
                .FromSqlRaw("EXEC sp_Login_CheckAccount @username, @passwordHash", usernameParam, passwordHashParam)
                .ToListAsync();

            if (!result.Any(r => r.Username != null))
            {
                ModelState.AddModelError("", "Sai tên đăng nhập hoặc mật khẩu.");
                ViewBag.InvalidLogin = true;
                return View(model);
            }

            var account = result[0];

            string dataConnStr = await _connProvider.GetDataConnectionStringAsync();

            //if (account.TypeID == "1" || account.TypeID == "2" || account.TypeID == "3" || account.TypeID == "5"
            //    || account.TypeID == "4")
            //{
            //    using (var connection = new SqlConnection(dataConnStr))
            //    using (var command = new SqlCommand("sp_KiemTraLichLamViec", connection))
            //    {
            //        command.CommandType = CommandType.StoredProcedure;
            //        command.Parameters.AddWithValue("@maNhanVien", account.MaNhanVien ?? "");

            //        await connection.OpenAsync();

            //        using (var reader = await command.ExecuteReaderAsync())
            //        {
            //            bool hasValidSchedule = false;
            //            TimeSpan now = DateTime.Now.TimeOfDay;

            //            while (await reader.ReadAsync())
            //            {
            //                TimeSpan gioBatDau = reader.GetTimeSpan(reader.GetOrdinal("gioBatDau"));
            //                TimeSpan gioKetThuc = reader.GetTimeSpan(reader.GetOrdinal("gioKetThuc"));

            //                if (now >= gioBatDau && now <= gioKetThuc)
            //                {
            //                    hasValidSchedule = true;
            //                    break;
            //                }
            //            }

            //            if (!hasValidSchedule)
            //            {
            //                TempData["NoSchedule"] = "Không có lịch làm việc hôm nay hoặc đã ngoài giờ.";
            //                return RedirectToAction("Login");
            //            }
            //        }
            //    }
            //}

            string? maPhongKham = null;
            if (account.TypeID == "1")
            {
                using (var connection = new SqlConnection(dataConnStr))
                using (var command = new SqlCommand("sp_LayPhongKham", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@maNhanVien", account.MaNhanVien ?? "");
                    command.Parameters.AddWithValue("@ngayLam", DateTime.Today);

                    var outputParam = new SqlParameter("@maPhongKham", SqlDbType.VarChar, 10)
                    {
                        Direction = ParameterDirection.Output
                    };
                    command.Parameters.Add(outputParam);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();

                    maPhongKham = outputParam.Value?.ToString();
                }
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, account.Username ?? ""),
                new Claim("TypeID", account.TypeID ?? ""),
                new Claim("MaNhanVien", account.MaNhanVien ?? "")
            };


            if (!string.IsNullOrEmpty(maPhongKham))
                claims.Add(new Claim("MaPhongKham", maPhongKham));

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


        [Authorize]
        [HttpGet]
        public IActionResult ChangePassword()
        {
            return View();
        }

        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword(ChangePassword model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var username = User.Identity?.Name ?? "";
            if (string.IsNullOrEmpty(username))
            {
                ModelState.AddModelError("", "Không tìm thấy thông tin người dùng.");
                return View(model);
            }

            var connStr = await _connProvider.GetAccountConnectionStringAsync();
            using var connection = new SqlConnection(connStr);
            await connection.OpenAsync();

            using var sha256 = System.Security.Cryptography.SHA256.Create();

            var currentPasswordBytes = System.Text.Encoding.UTF8.GetBytes(model.CurrentPassword);
            var currentPasswordHash = sha256.ComputeHash(currentPasswordBytes);

            var newPasswordBytes = System.Text.Encoding.UTF8.GetBytes(model.NewPassword);
            var newPasswordHash = sha256.ComputeHash(newPasswordBytes);

            using var command = new SqlCommand("sp_DoiMatKhau", connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            command.Parameters.AddWithValue("@username", username);
            command.Parameters.Add("@currentPasswordHash", SqlDbType.VarBinary, -1).Value = currentPasswordHash;
            command.Parameters.Add("@newPasswordHash", SqlDbType.VarBinary, -1).Value = newPasswordHash;

            try
            {
                await command.ExecuteNonQueryAsync();
                TempData["SuccessMessage"] = "Đổi mật khẩu thành công.";
                return RedirectToAction("ChangePassword");
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("", "Lỗi khi đổi mật khẩu: " + ex.Message);
                return View(model);
            }
        }



        [AllowAnonymous]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login", "Account");
        }
    }
}
