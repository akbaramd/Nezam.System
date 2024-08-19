using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ComplaintReview
{
    public int Id { get; set; }

    public int ComplaintId { get; set; }

    public int ApplicantId { get; set; }

    public string? Respondent { get; set; }

    public string? Description { get; set; }

    public DateTime RegDate { get; set; }

    public int ComplaintReviewTypeId { get; set; }

    public virtual ComplaintMember Applicant { get; set; } = null!;

    public virtual Complaint Complaint { get; set; } = null!;

    public virtual ComplaintReviewType ComplaintReviewType { get; set; } = null!;
}
