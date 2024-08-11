using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.IO;
using FastReport;
using FastReport.Export.PdfSimple;

namespace Velzon.Controllers
{
  public class HomeController : Controller
  {
    public IActionResult Index()
    {
      return View();
    }

    public IActionResult GenerateReport()
    {
      // Create a new report instance
      var report = new Report();

     
      // Load the report file
      report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "Untitled.frx"));

      var data = new List<MyDataModel>
      {
        new MyDataModel { Id = 1, Name = "John Doe" },
        new MyDataModel { Id = 2, Name = "Jane Smith" }
      };

      // Convert the list to a DataTable
      var dataTable = new DataTable();
      dataTable.Columns.Add("Id", typeof(int));
      dataTable.Columns.Add("Name", typeof(string));
    
      foreach (var item in data)
      {
        dataTable.Rows.Add(item.Id, item.Name);
      }
      // Register the DataTable as a data source for the report
      report.RegisterData(dataTable, "MyDataSource");

      var r = report.GetDataSource("MyDataSource");

      r.Enabled = true;

      report.SetParameterValue("StartAt",DateTime.Now);
      report.SetParameterValue("EndAt",DateTime.Now);
      
      // Enable the data source
      // Prepare the report
      report.Prepare();

      // Export the report to PDF
      var stream = new MemoryStream();
      var pdfExport = new PDFSimpleExport();
      report.Export(pdfExport, stream);

      // Set the stream position to the beginning before returning the file
      stream.Position = 0;

      // Return the PDF file
      return File(stream, "application/pdf", "report.pdf");
    }
  }
}
public class MyDataModel
{
  public int Id { get; set; }
  public string Name { get; set; } = string.Empty;
}