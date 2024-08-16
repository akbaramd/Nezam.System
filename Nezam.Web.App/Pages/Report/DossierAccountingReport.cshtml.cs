using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Globalization;
using Dapper;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Velzon.Controllers;
using Velzon.Models;

namespace Velzon.Pages.Report
{
    [Authorize]
    public class DossierAccountingReport : PageModel
    {
        private readonly string _connectionString =
            "Data Source=192.168.200.7\\SQL2019;Initial Catalog=CEDOWA-RT-V2;Persist Security Info=True;User ID=sa;Password=vhdSAM@15114;MultipleActiveResultSets=True;App=EntityFramework;TrustServerCertificate=True";

        [BindProperty] public DossierAccountingFilterModel FilterModel { get; set; } = default!;

        public WebReport WebReport { get; set; } = default!;

     
        public void OnGet()
        {
          
        }

        public IActionResult OnPostGenerateReport()
        {
          // Fetch data from the database and populate models
          var tblChangeData = FetchTblChangeData();  // Method to fetch TblChangeModel data
          var dtbl1Data = FetchDtbl1Data();          // Method to fetch Dtbl1Model data
          var reportParameters = FetchParameters();          // Method to fetch Dtbl1Model data

          // Set up parameters
         

          // Load and configure the report
          WebReport = new WebReport();
          WebReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "Untitled.frx"));

          // Register data sources
          WebReport.Report.RegisterData(tblChangeData, "tbl_change");
          WebReport.Report.RegisterData(dtbl1Data, "dtbl1");

          // Set parameters in the report
          foreach (var prop in reportParameters.GetType().GetProperties())
          {
            WebReport.Report.SetParameterValue(prop.Name, prop.GetValue(reportParameters));
          }

          return Page();
        }

        private ReportParameters FetchParameters()
        {
          
          return new ReportParameters() { };
        }


        private List<TblChangeModel> FetchTblChangeData()
        {
          using (var connection = new SqlConnection(_connectionString))
          {
            connection.Open();
            var query = "SELECT * FROM tbl_change"; // Modify with actual query
            return connection.Query<TblChangeModel>(query).ToList();
          }
        }

        private List<Dtbl1Model> FetchDtbl1Data()
        {
          using (var connection = new SqlConnection(_connectionString))
          {
            connection.Open();
            var query = "SELECT * FROM dtbl1"; // Modify with actual query
            return connection.Query<Dtbl1Model>(query).ToList();
          }
        }
    }
    

}
public class TblChangeModel
{
  public int SabtNo { get; set; }
  public long OzviyatNo { get; set; }
  public int GoroohCod { get; set; }
  public double TedadCod { get; set; }
  public string Name { get; set; } = string.Empty;
  public string Fname { get; set; } = string.Empty;
  public string Title { get; set; } = string.Empty;
  public double Nezarat { get; set; }
  public double Tarrahi { get; set; }
  public string DaftarFanniNo { get; set; } = string.Empty;
  public int TafavotMetraj { get; set; }
  public int Sal { get; set; }
  public string SabtDate { get; set; } = string.Empty;
  public string Malekname { get; set; } = string.Empty;
  public string Malekfname { get; set; } = string.Empty;
  public string DastoorNo { get; set; } = string.Empty;
  public string DastoorDate { get; set; } = string.Empty;
  public string PelakNo { get; set; } = string.Empty;
  public double Metraj { get; set; }
  public string DaftarNo { get; set; } = string.Empty;
  public string Mantageh { get; set; } = string.Empty;
  public string Gorooh { get; set; } = string.Empty;
  public string Change { get; set; } = string.Empty;
  public int MetrajGabl { get; set; }
  public int Sal1 { get; set; }
  public int Expr1 { get; set; }
  public string Comment { get; set; } = string.Empty;
  public double NTedad { get; set; }
  public double Tkoll { get; set; }
  public double TTedad { get; set; }
  public string EngFullName { get; set; } = string.Empty;
  public string EngMob { get; set; } = string.Empty;
  public string MalekFullName { get; set; } = string.Empty;
  public int PnezaratCod { get; set; }
  public int PtarrahiCod { get; set; }
}

public class Dtbl1Model
{
  public byte[] ArmSazman { get; set; } = default!;
}

public class ReportParameters
{
    public string MaliatRate { get; set; } = string.Empty;
    public string KarbarName { get; set; } = string.Empty;
    public string Comments { get; set; } = string.Empty;
    public string SahmNezarat { get; set; } = string.Empty;
    public string SahmTarrahi { get; set; } = string.Empty;
    public string SahmMojri { get; set; } = string.Empty;
    public string SahmMechanicKhak { get; set; } = string.Empty;
    public string SumSahm1 { get; set; } = string.Empty;
    public string SahmShanasname { get; set; } = string.Empty;
    public string SahmNezaratEng { get; set; } = string.Empty;
    public string SahmNagshebardar { get; set; } = string.Empty;
    public string SumSahm2 { get; set; } = string.Empty;
    public string MaliyatAfzoodehShenasname { get; set; } = string.Empty;
    public string SumMaliyatAfzoodeh { get; set; } = string.Empty;
    public string TedadTabage { get; set; } = string.Empty;
    public string TedadSagf { get; set; } = string.Empty;
    public string Trackcode { get; set; } = string.Empty;
    public string MaliyatAfzoodehSahmNezarat { get; set; } = string.Empty;
    public string MaliyatAfzoodehSahmTarrahi { get; set; } = string.Empty;
    public string MaliyatAfzoodehSahmMojri { get; set; } = string.Empty;
    public string PardakhtSaderat { get; set; } = string.Empty;
    public string PardakhtTejarat { get; set; } = string.Empty;
    public string BedehiSaderat { get; set; } = string.Empty;
    public string BedehiTejarat { get; set; } = string.Empty;
    public string KolSaderat { get; set; } = string.Empty;
    public string KolTejarat { get; set; } = string.Empty;
    public string SumCol1 { get; set; } = string.Empty;
    public string SumCol2 { get; set; } = string.Empty;
    public string MalekMobNo { get; set; } = string.Empty;
    public string MalekAddress { get; set; } = string.Empty;
    public string MalekMellicode { get; set; } = string.Empty;
    public string MaliyatArzeshRate { get; set; } = string.Empty;
    public string AvarezArzeshRate { get; set; } = string.Empty;
    public string AvarezAfzoodehShenasname { get; set; } = string.Empty;
    public string AvarezAfzoodehSahmNezarat { get; set; } = string.Empty;
    public string AvarezAfzoodehSahmTarrahi { get; set; } = string.Empty;
    public string AvarezAfzoodehSahmMojri { get; set; } = string.Empty;
    public string SahmSandogHemayati { get; set; } = string.Empty;
    public string ShahrdariName { get; set; } = string.Empty;
    public string BankSazman { get; set; } = string.Empty;
    public string BankErjaa { get; set; } = string.Empty;
    public string VariziBankSazman { get; set; } = string.Empty;
    public string VariziBankErjaa { get; set; } = string.Empty;
    public string BankSazmanMotamarkez { get; set; } = string.Empty;
    public string SumSahmDaftar { get; set; } = string.Empty;
    public string VariziBankSazmanOstan { get; set; } = string.Empty;
    public string KolTejaratOstan { get; set; } = string.Empty;
    public string BedehiTejaratOstan { get; set; } = string.Empty;
    public string PardakhtTejaratOstan { get; set; } = string.Empty;
    public string Dprint { get; set; } = string.Empty;
    public string AvarezAfzoodehNagshebardar { get; set; } = string.Empty;
    public string SahmNagshebardarSazman { get; set; } = string.Empty;
    public string MaliyatAfzoodehNagshebardar { get; set; } = string.Empty;
    public string SumMaliyat { get; set; } = string.Empty;
    public string SumAvarez { get; set; } = string.Empty;
    public string SumMablagTaavizNaghshe { get; set; } = string.Empty;
    public string MaliyatSumMablagTaavizNaghshe { get; set; } = string.Empty;
    public string AvarezSumMablagTaavizNaghshe { get; set; } = string.Empty;
    public string SahmGeoNazer { get; set; } = string.Empty;
    public string MaliyatMechanicKhak { get; set; } = string.Empty;
    public string AvarezMechanicKhak { get; set; } = string.Empty;
    public string DossierNumber { get; set; } = string.Empty;
    public string SumKhak { get; set; } = string.Empty;
    public string ControlTarrahLabel { get; set; } = string.Empty;
}

public class DossierAccountingFilterModel
{
  [Required(ErrorMessage = "شماره پرونده را وارد کنید")]
  public string DossierNumber { get; set; } = default!;

}