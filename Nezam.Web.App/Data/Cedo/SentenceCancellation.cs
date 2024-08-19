using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SentenceCancellation
{
    public Guid Id { get; set; }

    public string LetterNumber { get; set; } = null!;

    public DateTime LetterDate { get; set; }

    public string Description { get; set; } = null!;

    public DateTime RegDate { get; set; }

    public virtual Sentence IdNavigation { get; set; } = null!;
}
