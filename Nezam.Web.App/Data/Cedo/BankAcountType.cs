using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class BankAcountType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<MemberBankAcount> MemberBankAcounts { get; set; } = new List<MemberBankAcount>();
}
