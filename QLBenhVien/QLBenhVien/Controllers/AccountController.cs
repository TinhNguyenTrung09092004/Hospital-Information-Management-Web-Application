using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using QLBenhVien.Models;
using QLBenhVien.Entities;
using Microsoft.AspNetCore.Authorization;

public class AccountController : Controller
{
    private readonly QlbenhVienContext _context;

    public AccountController(QlbenhVienContext context)
    {
        _context = context;
    }
    [AllowAnonymous]
    [HttpGet]
    public IActionResult Login()
    {
        return View();
    }
    [AllowAnonymous]
    [HttpPost]
    public async Task<IActionResult> Login(AccountLogin model)
    {
        if (!ModelState.IsValid)
            return View(model);

        var usernameParam = new SqlParameter("@username", model.Username);
        var passwordParam = new SqlParameter("@password", model.Password);

        var result = await _context.AccountInfos
            .FromSqlRaw("EXEC sp_Login_CheckAccount @username, @password", usernameParam, passwordParam)
            .ToListAsync();

        if (result.Any(r => r.Username != null))
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, result[0].Username ?? ""),
                new Claim("UserID", result[0].UserID ?? "")
            };

            foreach (var item in result)
            {
                if (item.PermissionID.HasValue)
                {
                    claims.Add(new Claim("PermissionID", item.PermissionID.Value.ToString()));
                }
            }

            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);

            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

            return RedirectToAction("Index", "Home");
        }

        ModelState.AddModelError("", "Sai tên đăng nhập hoặc mật khẩu.");
        return View(model);
    }

    [AllowAnonymous]
    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        return RedirectToAction("Login", "Account");
    }
}
