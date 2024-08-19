
using CedoLib.Utilities.Helper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Velzon.Data.Cedo;
using Velzon.Enums;
using Velzon.Helpers;
using Velzon.Models;

namespace CedoLib.Report
{
    public class BillReportHelper
    {
        public static async Task<BillReportVm> GetDossierInitialBillReportDataAsync(IServiceProvider serviceProvider, int constructionLicenseId)
        {
            var result = new BillReportVm();

            try
            {
                var bills = new List<Bill>();
                var ds = serviceProvider.GetRequiredService<CedoContext>();

                var billList = await ds.Bills
                    .Include(x => x.BillDetails).ThenInclude(x => x.CostType)
                    .Include(x=>x.BillType)
                    .Include(x => x.PaymentReceipts)
                    .Where(x => x.ConstructionLicenseId == constructionLicenseId)
                    .OrderByDescending(x => x.Id)
                    .ToListAsync();

                if (billList.Any())
                {
                    if (billList.Any(x => x.BillTypeId == (int)BillTypes.AdjustingBill))
                    {
                      var adjustingBill = billList.FirstOrDefault(x => x.BillTypeId == (int)BillTypes.AdjustingBill);
                      if (adjustingBill != null)
                      {
                        bills.Add(adjustingBill);
                      }
                    }
                    else
                    {
                        var intialBill = billList.FirstOrDefault(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts);
                        if (intialBill != null)
                            bills.Add(intialBill);
                    }

                    if (billList.Any(x => x.BillTypeId == (int)BillTypes.SupervisionCosts))
                    {
                        var supervisionCostsBill = billList.Where(x => x.BillTypeId == (int)BillTypes.SupervisionCosts || x.BillTypeId == (int)BillTypes.LegalSupervisorVATCost|| x.BillTypeId == (int)BillTypes.ChangeSupervisor).ToList();
                        bills.AddRange(supervisionCostsBill);
                    }

                    if (billList.Any(x => x.BillTypeId == (int)BillTypes.GeoLabBill || x.BillTypeId == (int)BillTypes.ConcreteLab))
                    {
                        var otherBills = billList.Where(x => x.BillTypeId == (int)BillTypes.GeoLabBill || x.BillTypeId == (int)BillTypes.ConcreteLab).ToList();
                        bills.AddRange(otherBills);
                    }

                }
                //=== get construction liecnseInfo
                var cl = await GetConstructionLicenseInfoAsync(serviceProvider,constructionLicenseId);
                if (cl != null)
                {
                    result.DossierNumber = cl.DossierNumber;
                    result.DossierSerial = cl.DossierSerial;
                    result.BuildingGroup = cl.BuildingGroupSetting?.SubGroup.Title;
                    result.Address = cl.Estate.Address;
                    result.LicenseNumber = cl.LicenseNumber;
                    result.DossierType = await GetDossierTypeAsync(serviceProvider, cl);
                    result.OwnerName = $"{cl.MainOwner?.FirstName} {cl.MainOwner?.LastName}";
                    result.OwnerMobile = cl.MainOwner?.Mobile;
                    result.OwnerNationalCode = cl.MainOwner?.NationalCode;
                    result.OwnerPhone = cl.MainOwner?.Phone;
                    result.MunicipalityName = cl.Estate.Municipality.Title;
                    result.RegDate = cl.RegDate.ToString();
                    result.Metraje = (await ConstructionLicenseHelper.GetBuildingAreaAsync(serviceProvider, constructionLicenseId) ?? 0).ToString();
                    result.FloorCount = (await ConstructionLicenseHelper.GetBuildingFloorCountAsync(serviceProvider, constructionLicenseId)).ToString();
                }

                var index = 1;
                if (bills.Any())
                {
                    var intialBill = bills.FirstOrDefault(x => x.BillTypeId == (int)BillTypes.AdjustingBill || x.BillTypeId == (int)BillTypes.OrganizationalCosts);
                    if (intialBill != null)
                    {
                        if (intialBill.BillDetails.Any(x => x.CostTypeId != (int)CostTypes.ReturnAmount))
                        {
                            //var details = intialBill.BillDetails.Where(x => x.CostTypeId != (int)CostTypes.ReturnAmount).OrderBy(x => x.CostType.CostTypeOrder).ToList();
                            var details = intialBill.BillDetails.OrderBy(x => x.CostType.CostTypeOrder).ToList();
                            if (details.Any())
                            {
                                result.IntialBillDetails = new List<BillDetailReportVM>();
                                foreach (var item in details)
                                {
                                    result.IntialBillDetails.Add(new BillDetailReportVM { 
                                        Amount = item.Amount,
                                        Index = index,
                                        Tax = item.Tax,
                                        Title = item.CostType.Title 
                                    });
                                    index++;
                                }
                            }
                        }                        
                    }
                    //==============
                    var supervisorBill = bills.FirstOrDefault(x => x.BillTypeId == (int)BillTypes.SupervisionCosts);
                    if (supervisorBill != null)
                    {
                        if (supervisorBill.BillDetails.Any(x => x.CostTypeId != (int)CostTypes.ReturnAmount))
                        {
                            //var details = supervisorBill.BillDetails.Where(x => x.CostTypeId != (int)CostTypes.ReturnAmount).OrderBy(x => x.CostType.CostTypeOrder).ToList();
                            var details = supervisorBill.BillDetails.OrderBy(x => x.CostType.CostTypeOrder).ToList();
                            if (details.Any())
                            {
                                result.SupervisorBillDetails = new List<BillDetailReportVM>();
                                foreach (var item in details)
                                {
                                    result.SupervisorBillDetails.Add(new BillDetailReportVM
                                    {
                                        Amount = item.Amount,
                                        Index = index,
                                        Tax = item.Tax,
                                        Title = item.CostType.Title +" - " +  item.Bill.BillType.Title
                                    });
                                    index++;
                                }
                            }
                        }

                        var supervisorVatBill = bills.FirstOrDefault(x => x.BillTypeId == (int)BillTypes.LegalSupervisorVATCost);
                        if (supervisorVatBill != null)
                        {
                            //var details = supervisorVatBill.BillDetails.Where(x => x.CostTypeId != (int)CostTypes.ReturnAmount).OrderBy(x => x.CostType.CostTypeOrder).ToList();
                            var details = supervisorVatBill.BillDetails.OrderBy(x => x.CostType.CostTypeOrder).ToList();
                            if (details.Any())
                            {
                                foreach (var item in details)
                                {
                                    result.SupervisorBillDetails?.Add(new BillDetailReportVM
                                    {
                                        Amount = item.Amount,
                                        Index = index,
                                        Tax = item.Tax,
                                        Title = item.CostType.Title +" - " +  item.Bill.BillType.Title
                                    });
                                    index++;
                                }
                            }
                        }
                        
                        var changeSupervisor = bills.FirstOrDefault(x => x.BillTypeId == (int)BillTypes.ChangeSupervisor);
                        if (changeSupervisor != null)
                        {
                          //var details = supervisorVatBill.BillDetails.Where(x => x.CostTypeId != (int)CostTypes.ReturnAmount).OrderBy(x => x.CostType.CostTypeOrder).ToList();
                          var details = changeSupervisor.BillDetails.OrderBy(x => x.CostType.CostTypeOrder).ToList();
                          if (details.Any())
                          {
                            foreach (var item in details)
                            {
                              result.SupervisorBillDetails?.Add(new BillDetailReportVM
                              {
                                Amount = item.Amount,
                                Index = index,
                                Tax = item.Tax,
                                Title = item.CostType.Title +" - " +  item.Bill.BillType.Title
                              });
                              index++;
                            }
                          }
                        }
                    }
                    //========
                    var otherBill = bills.Where(x => x.BillTypeId == (int)BillTypes.GeoLabBill || x.BillTypeId == (int)BillTypes.ConcreteLab).ToList();
                    if (otherBill.Any())
                    {
                        result.OtherBillDetails = new List<BillDetailReportVM>();
                        foreach (var bill in otherBill)
                        {
                            if (bill.BillDetails.Any(x => x.CostTypeId != (int)CostTypes.ReturnAmount))
                            {
                                //var details = bill.BillDetails.Where(x => x.CostTypeId != (int)CostTypes.ReturnAmount).OrderBy(x => x.CostType.CostTypeOrder).ToList();
                                var details = bill.BillDetails.OrderBy(x => x.CostType.CostTypeOrder).ToList();
                                if (details.Any())
                                {
                                    foreach (var item in details)
                                    {
                                        result.OtherBillDetails.Add(new BillDetailReportVM
                                        {
                                            Amount = item.Amount,
                                            Index = index,
                                            Tax = item.Tax,
                                            Title = item.CostType.Title 
                                        });
                                        index++;
                                    }
                                }
                            }
                        }
                    }

                    //=== set payments
                    result.BillPaymentDetails = new List<BillPaymentReportVM>();
                    index = 1;
                    foreach (var bill in bills)
                    {
                        var paymetns = bill.PaymentReceipts.Where(x => x.PaymentStatusId == (int)PaymentStatuses.Verified).ToList();
                        if (bill.BillTypeId == (int)BillTypes.AdjustingBill)
                        {
                            var temp = billList.FirstOrDefault(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts);
                            if (temp != null)
                            {
                                paymetns.AddRange(temp.PaymentReceipts.Where(x => x.PaymentStatusId == (int)PaymentStatuses.Verified).ToList());
                            }
                        }
                        foreach (var item in paymetns)
                        {
                            result.BillPaymentDetails.Add(new BillPaymentReportVM { 
                                Amount = item.Amount,
                                BillPaymentCode = item.BillPaymentCode,
                                Index = index, 
                                RegDate = item.PaymentDate.ToString(),
                                RRN = item.Rrn ?? "پرداخت دستی"
                            });

                            index++;
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                //=== check errors
                Console.WriteLine(ex.Message);
            }

            return result;
        }

        private static async Task<string> GetDossierTypeAsync(IServiceProvider serviceProvider, ConstructionLicense cl)
        {
            var result = cl.DossierType.Title;
            if (cl.ParentId != null)
            {
                var parent = await GetConstructionLicenseInfoAsync(serviceProvider, cl.ParentId.Value);
                if (parent != null)
                    result = $"{result} - {await GetDossierTypeAsync(serviceProvider, parent)}";
            }

            return result;
        }

        private static async Task<ConstructionLicense?> GetConstructionLicenseInfoAsync(IServiceProvider serviceProvider, int constructionLicenseId)
        {
            var clDs = serviceProvider.GetRequiredService<CedoContext>();
            //using var clDs = new ConstructionLicenseDataService();
            var constructionLicense = await clDs.ConstructionLicenses
                .Include(x => x.Owners)
                .Include(x => x.BuildingGroupSetting).ThenInclude(x => x!.SubGroup)
                .Include(x => x.DossierType)
                .Include(x => x.Estate.Municipality.City).AsNoTracking().FirstOrDefaultAsync(x => x.Id == constructionLicenseId);
            return constructionLicense;
        }

        public static async Task<List<DossierBillReportVM>> GetDossierBillReportDataAsync(IServiceProvider serviceProvider, PlanControlReportVm filters)
        {
            var list = new List<DossierBillReportVM>();

            try
            {
              var clDs = serviceProvider.GetRequiredService<CedoContext>();
                var data = await clDs.ConstructionLicenses
                    .Include(x => x.Estate.Municipality.City)
                    .Include(x => x.Bills).ThenInclude(x => x.BillDetails)
                    .Include(x => x.Bills).ThenInclude(x => x.PaymentReceipts)
                    .Where(x =>
                        (filters.StartDate == null || filters.StartDate.Value <= x.RegDate) &&
                        (filters.EndDate == null || filters.EndDate >= x.RegDate) &&
                        x.Bills.Any(b => b.PaymentReceipts.Any(p => p.PaymentStatusId == (int)PaymentStatuses.Verified))
                    )
                    .AsNoTracking().ToListAsync();

                foreach ( var cl in data)
                {
                    list.Add(new DossierBillReportVM { 
                        //Id= index,
                        CityName =  await CityCodeHelper.GetDossierMainCityNameAsync(serviceProvider, cl.Estate?.Municipality?.City),
                        DesignControlAmount = GetBillDetailSumAmount(cl, CostTypes.DesignControl, false),
                        DossierFormalCode = cl.DossierFormalCode,
                        DossierNumber= cl.DossierNumber,
                        ExecutorControlAmount = GetBillDetailSumAmount(cl, CostTypes.ExecutorControl, false),
                        FinalBillAmount = GetBillDetailSumAmount(cl, null, true),
                        FinalMetraje = GetBillMetraje(cl, true),
                        IntialBillAmount = GetBillDetailSumAmount(cl, null, false),
                        IntialMetraje = GetBillMetraje(cl, false),
                        OwnerName = await ConstructionLicenseHelper.GetBuildingMainOwnerNameAsync(serviceProvider, cl.Id),
                        PayBackAmount = GetBillDetailSumAmount(cl, CostTypes.ReturnAmount, false),
                        SupervisionControlAmount = GetBillDetailSumAmount(cl, CostTypes.SupervisionControl, false),
                        SurveyControlAmount = GetBillDetailSumAmount(cl, CostTypes.SurveyControl, false),
                        TechnicalCertificateAmount = GetBillDetailSumAmount(cl, CostTypes.TechnicalCertificate, false),
                        OtherAmount= GetBillDetailSumAmount(cl, CostTypes.GeoTechnic, false),
                        SupervisioningAmount = GetBillDetailSumAmount(cl, CostTypes.Supervisioning, false),
                        SurveySupervisionAmount = GetBillDetailSumAmount(cl, CostTypes.SurveySupervision, false)
                    });
                    //index++;
                }
            }
            catch 
            {
                //=== check for exceptions                
            }
            var index = 1;

            list = list.OrderBy(x => x.CityName).ToList();
            foreach (var item in list)
            {
                item.Id = index;
                index++;
            }

            return list;
        }

        private static string GetBillDetailSumAmount(ConstructionLicense cl, CostTypes? costType, bool isFinalBill)
        {
            var result = "";
            var bills = cl.Bills.Where(x => x.PaymentReceipts.Any(p => p.PaymentStatusId == (int)PaymentStatuses.Verified)).ToList();

            if (costType == CostTypes.DesignControl ||
                costType == CostTypes.ExecutorControl ||
                costType == CostTypes.SupervisionControl ||
                costType == CostTypes.ReturnAmount ||
                costType == CostTypes.TechnicalCertificate ||
                costType == CostTypes.Supervisioning ||
                costType == CostTypes.SurveySupervision ||
                costType == CostTypes.SurveyControl)
            {
                var bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.AdjustingBill);
                if (bill != null && bill.Id > 0)
                    bills.Remove(bills.OrderByDescending(x => x.Id).First(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts));
                    //bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts);

                //if(bill != null)
                //    result = bill.BillDetails.Where(d => d.CostTypeId == (int)costType).Sum(x => x.Amount).ToString("#,#");
                result = bills.Sum(x => x.BillDetails.Where(d => d.CostTypeId == (int)costType).Sum(b => b.Amount)).ToString("#,#");
            }
            else if(costType == CostTypes.GeoTechnic)
            {
                var bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.AdjustingBill);
                if (bill != null && bill.Id > 0)
                    bills.Remove(bills.OrderByDescending(x => x.Id).First(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts));


                //if (bill != null)
                //    result = bill.BillDetails.Where(d => d.CostTypeId == (int)CostTypes.GeoTechnic || d.CostTypeId >= (int)CostTypes.ConcreteLab).Sum(x => x.Amount).ToString("#,#");

                var sum = bills.Sum(x => x.BillDetails.Where(d => d.CostTypeId == (int)CostTypes.GeoTechnic).Sum(b => b.Amount));
                sum += bills.Sum(x => x.BillDetails.Where(d => d.CostTypeId >= (int)CostTypes.ConcreteLab).Sum(b => b.Amount));

                result = sum.ToString("#,#");
            }            
            else if (isFinalBill)
            {
                var bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.AdjustingBill);
                if (bill == null)
                    bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts);

                if (bill != null)
                {
                    result = bill.TotalAmount.ToString("#,#");
                }
            }
            else
            {
                var bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts);

                if (bill != null)
                {
                    result = bill.TotalAmount.ToString("#,#");
                }
            }

            if (string.IsNullOrEmpty(result))
                result = "0";

            return result;
        }

        private static string? GetBillMetraje(ConstructionLicense cl, bool isFinalBill)
        {
            var result = "";
            var bills = cl.Bills.Where(x => x.PaymentReceipts.Any(p => p.PaymentStatusId == (int)PaymentStatuses.Verified)).ToList();

            if (isFinalBill)
            {
                var bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.AdjustingBill);
                if (bill == null)
                    bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts);

                if (bill != null)
                {
                    result = bill.Metraje?.ToString();
                }
            }
            else
            {
                var bill = bills.OrderByDescending(x => x.Id).FirstOrDefault(x => x.BillTypeId == (int)BillTypes.OrganizationalCosts);

                if (bill != null)
                {
                    result = bill.Metraje;
                }
            }
            return result;
        }
    }
}
