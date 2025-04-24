using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class Account
{
    public string Username { get; set; } = null!;

    public byte[]? PasswordHash { get; set; }

    public string? UserId { get; set; }

    public DateTime? CreatedDate { get; set; }

    public virtual ICollection<Logging> Loggings { get; set; } = new List<Logging>();

    public virtual ThongtinCanhan? User { get; set; }

    public virtual ICollection<Permission> Permissions { get; set; } = new List<Permission>();
}
