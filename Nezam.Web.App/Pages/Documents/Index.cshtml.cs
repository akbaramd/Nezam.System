using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Nezam.CES.Data;
using System.Linq.Dynamic.Core;
using Microsoft.AspNetCore.Authorization;

namespace Nezam.System.Web.Pages.Documents;

[Authorize(Policy = "SupervisorReports")]
[Authorize(Policy = "Supervisor")]
public class IndexModel : PageModel
{
    private readonly KolahiDbContext _dbContext;

    public IndexModel(KolahiDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public IActionResult OnPostGetDocuments()
    {
        try
        {
            var draw = Request.Form["draw"].FirstOrDefault();
            var start = int.Parse(Request.Form["start"].FirstOrDefault() ?? "0");
            var length = int.Parse(Request.Form["length"].FirstOrDefault() ?? "10");
            var searchValue = Request.Form["search[value]"].FirstOrDefault();

            // Sorting
            var sortColumnIndex = int.Parse(Request.Form["order[0][column]"].FirstOrDefault() ?? "0");
            var sortColumn = Request.Form[$"columns[{sortColumnIndex}][data]"].FirstOrDefault();
            var sortDirection = Request.Form["order[0][dir]"].FirstOrDefault();

            // Base query
            var query = _dbContext.TblEesDocuments.AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(searchValue))
            {
                query = query.Where(d =>
                    d.Title.Contains(searchValue) ||
                    d.TrackingCode.Contains(searchValue));
            }

            // Sorting
            if (!string.IsNullOrEmpty(sortColumn) && !string.IsNullOrEmpty(sortDirection))
            {
                query = query.OrderBy($"{sortColumn} {sortDirection}");
            }

            // Total Records
            var recordsTotal = query.Count();

            // Pagination
            var data = query
                .Skip(start)
                .Take(length)
                .Select(d => new
                {
                    d.Id,
                    d.Title,
                    d.TrackingCode,
                    CreatedAt = (d.CreatedAt.HasValue) ? d.CreatedAt.Value.ToString("yyyy-MM-dd") : null,
                    d.State,
                    d.FilePath,
                    d.Type,
                    d.IsRead // ✅ Include Read Status
                })
                .ToList();

            // Return JSON response for DataTables
            return new JsonResult(new
            {
                draw,
                recordsFiltered = recordsTotal,
                recordsTotal,
                data
            });
        }
        catch (Exception ex)
        {
            return new JsonResult(new { error = ex.Message });
        }
    }

 
    public async Task<IActionResult> OnPostToggleReadStatus([FromBody] ToggleReadStatusRequest request)
    {
        if (request == null || request.DocumentId <= 0)
            return BadRequest(new { success = false, message = "Invalid request" });

        var document = await _dbContext.TblEesDocuments.FindAsync(request.DocumentId);
        if (document == null)
            return NotFound(new { success = false, message = "Document not found" });

        document.IsRead = request.IsRead;
        await _dbContext.SaveChangesAsync();

        return new JsonResult(new { success = true, isRead = document.IsRead });
    }

    public class ToggleReadStatusRequest
    {
        public int DocumentId { get; set; }
        public bool IsRead { get; set; }
    }

    public IActionResult OnGetDownload(int id)
    {
        var document = _dbContext.TblEesDocuments.FirstOrDefault(d => d.Id == id);

        if (document == null || string.IsNullOrEmpty(document.FilePath))
        {
            return NotFound(new { message = "Document not found" });
        }

        var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", document.FilePath);

        if (!global::System.IO.File.Exists(filePath))
        {
            return NotFound(new { message = "File not found on the server" });
        }

        var fileBytes = global::System.IO.File.ReadAllBytes(filePath);
        return File(fileBytes, "application/octet-stream", Path.GetFileName(filePath));
    }
}
