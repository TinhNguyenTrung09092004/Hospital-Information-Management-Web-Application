using System;
using System.Collections.Generic;

namespace QLBenhVien.Entities;

public partial class ViewThemTaiKhoanNv
{
    public DateTime EventTime { get; set; }

    public DateTime? VietnamTime { get; set; }

    public string? ExecutorLogin { get; set; }

    public string? ExecutorUser { get; set; }

    public string? DatabaseName { get; set; }

    public string? SchemaName { get; set; }

    public string? ObjectName { get; set; }

    public string? Statement { get; set; }

    public string? AdditionalInformation { get; set; }

    public string? NewUsername { get; set; }

    public string? PasswordParam { get; set; }

    public string? Hoten { get; set; }

    public string? Email { get; set; }

    public string? Sdt { get; set; }

    public bool Succeeded { get; set; }

    public string StatusText { get; set; } = null!;

    public string? ClientIp { get; set; }

    public string? HostName { get; set; }

    public string? ApplicationName { get; set; }

    public short SessionId { get; set; }

    public Guid? ConnectionId { get; set; }

    public int SequenceNumber { get; set; }

    public string? ActionId { get; set; }

    public string? ClassType { get; set; }

    public string? ServerInstanceName { get; set; }

    public string FileName { get; set; } = null!;

    public long AuditFileOffset { get; set; }

    public long TransactionId { get; set; }

    public string? SessionServerPrincipalName { get; set; }

    public string? TargetServerPrincipalName { get; set; }

    public string? TargetDatabasePrincipalName { get; set; }

    public byte[] PermissionBitmask { get; set; } = null!;

    public bool IsColumnPermission { get; set; }

    public int AuditSchemaVersion { get; set; }
}
