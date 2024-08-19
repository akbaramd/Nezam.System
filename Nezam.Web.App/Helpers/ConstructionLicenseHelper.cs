using Microsoft.EntityFrameworkCore;
using Velzon.Data.Cedo;
using Velzon.Enums;

namespace Velzon.Helpers;

public class ConstructionLicenseHelper
{
    //=== دریافت نام مالک اصلی ساختمان
        public static async Task<string?> GetBuildingMainOwnerNameAsync(IServiceProvider serviceProvider, int? constructionLicenseId)
        {
            try
            {
                var ds = serviceProvider.GetRequiredService<CedoContext>();
                var model = await ds.ConstructionLicenses
                    .Include(x => x.Owners)
                    .Include(x => x.DossierType)
                    .FirstOrDefaultAsync(x => constructionLicenseId != null && x.Id == constructionLicenseId.Value);

                if (model != null && model.Owners.Any())
                {
                    var owners = model.Owners.Where(x => !x.IsCahnged).OrderByDescending(x => x.Id).ToList();

                    if (owners.Any(x => x.IsMainPossessor && !x.IsAgent))
                    {
                        if (string.IsNullOrEmpty(model.DossierNumber))
                            return $"{owners?.FirstOrDefault(x => x.IsMainPossessor)?.NationalCode} - {owners?.FirstOrDefault(x => x.IsMainPossessor)?.FirstName} {owners?.FirstOrDefault(x => x.IsMainPossessor)?.LastName} - {model.DossierType.Title}";

                        return $"{owners?.FirstOrDefault(x => x.IsMainPossessor)?.NationalCode} - {owners?.FirstOrDefault(x => x.IsMainPossessor)?.FirstName} {owners?.FirstOrDefault(x => x.IsMainPossessor)?.LastName} - {model.DossierNumber} - {model.DossierType.Title}";

                    }
                    else if (owners.Any(x => x.IsMainOwner && !x.IsAgent))
                    {
                        if (string.IsNullOrEmpty(model.DossierNumber))
                            return $"{owners?.FirstOrDefault(x => x.IsMainOwner)?.NationalCode} - {owners?.FirstOrDefault(x => x.IsMainOwner)?.FirstName} {owners?.FirstOrDefault(x => x.IsMainOwner)?.LastName} - {model.DossierType.Title}";

                        return $"{owners?.FirstOrDefault(x => x.IsMainOwner)?.NationalCode} - {owners?.FirstOrDefault(x => x.IsMainOwner)?.FirstName} {owners?.FirstOrDefault(x => x.IsMainOwner)?.LastName} - {model.DossierNumber} - {model.DossierType.Title}";

                    }

                    if (string.IsNullOrEmpty(model.DossierNumber))
                        return $"{owners?.FirstOrDefault(x => x.IsMainOwner)?.NationalCode} - {owners?.FirstOrDefault(x => x.IsMainOwner)?.FirstName} {owners?.FirstOrDefault(x => x.IsMainOwner)?.LastName} - {model.DossierType.Title}";

                    return $"{owners?.FirstOrDefault(x => x.IsMainOwner)?.NationalCode} - {owners?.FirstOrDefault(x => x.IsMainOwner)?.FirstName} {owners?.FirstOrDefault(x => x.IsMainOwner)?.LastName} - {model.DossierNumber} - {model.DossierType.Title}";

                }

                return "";
            }
            catch
            {
                return null;
            }
        }
        
        //=== دریافت کل متراژ ساختمان
        public static async Task<float?> GetBuildingAreaAsync(IServiceProvider serviceProvider, int? constructionLicenseId)
        {
            try
            {
              var ds = serviceProvider.GetRequiredService<CedoContext>();
                var model = await ds.ConstructionLicenses
                    .Include(x => x.Floors).ThenInclude(x => x.BuildingUnits)
                    .FirstOrDefaultAsync(x => constructionLicenseId != null && x.Id == constructionLicenseId.Value);

                if (model != null)
                {
                    double? result = null;
                    if (model.Floors.Any())
                    {
                      if (model.Floors.Any(x => x.FloorRegisterStepId == (int)FloorRegisterSteps.FinalRegistration))
                            result = model.Floors.Where(x => x.FloorRegisterStepId == (int)FloorRegisterSteps.FinalRegistration).Sum(x => x.BuildingUnits?.Sum(y => y.Area));
                        else
                            result = model.Floors.Where(x => x.FloorRegisterStepId == (int)FloorRegisterSteps.InitialRegistration).Sum(x => x.BuildingUnits?.Sum(y => y.Area));

                      if (result != null)
                      {
                        return (float)Math.Round(result.Value, 2, MidpointRounding.AwayFromZero);
                      }
                    }

                    return null;
                }

                return 0;
            }
            catch (Exception)
            {
                return null;
            }
        }

        //=== دریافت کل متراژ ساختمان
        public static async Task<float?> GetBuildingAreaAsync(IServiceProvider serviceProvider, int? constructionLicenseId, int floorRegisterStepId)
        {
            try
            {
                var ds = serviceProvider.GetRequiredService<CedoContext>();
                var model = await ds.ConstructionLicenses
                    .Include(x => x.Floors).ThenInclude(x => x.BuildingUnits)
                    .FirstOrDefaultAsync(x => constructionLicenseId != null && x.Id == constructionLicenseId.Value);

                if (model != null)
                {
                    double? result = null;
                    if (model.Floors.Any())
                    {
                      result = model.Floors.Where(x => x.FloorRegisterStepId == floorRegisterStepId).Sum(x => x.BuildingUnits?.Sum(y => y.Area));

                      if (result != null)
                      {
                        return (float)Math.Round(result.Value, 2, MidpointRounding.AwayFromZero);
                      }
                    }

                    return null;
                }

                return 0;
            }
            catch (Exception)
            {
                return null;
            }
        }
        
        public static async Task<int> GetBuildingFloorCountAsync(IServiceProvider serviceProvider, int? constructionLicenseId)
        {
          try
          {
            if (!constructionLicenseId.HasValue)
              return 0;

            var ds = serviceProvider.GetRequiredService<CedoContext>();
            var model = await ds.ConstructionLicenses.Include(x => x.Floors).ThenInclude(x => x.BuildingUnits)
              .FirstOrDefaultAsync(x => x.Id == constructionLicenseId);

            return await CalculateBuildingFloorCountAsync(model?.Floors.OrderBy(x => x.Id).ToList());
          }
          catch
          {
            return 0;
          }
        }

        //=== دریافت تعداد طبقات ساختمان
        public static async Task<int> GetBuildingFloorCountAsync(IServiceProvider serviceProvider, int? constructionLicenseId, int floorRegisterStepId)
        {
          try
          {
            if (!constructionLicenseId.HasValue)
              return 0;

            var ds = serviceProvider.GetRequiredService<CedoContext>();;
            var model = await ds.ConstructionLicenses.Include(x => x.Floors).ThenInclude(x => x.BuildingUnits)
              .FirstOrDefaultAsync(x => x.Id == constructionLicenseId);

            return await CalculateBuildingFloorCountAsync(model?.Floors.OrderBy(x => x.Id).ToList(), floorRegisterStepId);
          }
          catch
          {
            return 0;
          }
        }
        
        
        //=== محاسبه تعداد طبقات ساختمان
        public static Task<int> CalculateBuildingFloorCountAsync(List<Floor>? floors)
        {
            try
            {
                if (floors == null)
                    return Task.FromResult(0);

                //=== check final floors
                if (floors.Any(x => x.FloorRegisterStepId == (int)FloorRegisterSteps.FinalRegistration))
                    floors = floors.Where(x => x.FloorRegisterStepId == (int)FloorRegisterSteps.FinalRegistration).ToList();
                else
                    floors = floors.Where(x => x.FloorRegisterStepId == (int)FloorRegisterSteps.InitialRegistration).ToList();
                var count = 0;
                var buildingGroupDetectorCount = floors.Count(x => x.FloorTypeId == (int)FloorTypes.Floor ||
                                                                    x.FloorTypeId == (int)FloorTypes.Basement ||
                                                                    x.FloorTypeId == (int)FloorTypes.GroundFloor);
                for (int i = 0; i < floors.Count(); i++)
                {
                    if (floors[i].FloorTypeId == (int)FloorTypes.Basement)
                    {
                        if (i < floors.Count - 1)
                        {
                            var nextFloor = floors[i + 1];
                            var nextArea = nextFloor.BuildingUnits.Sum(x => x.Area);
                            var area = floors[i].BuildingUnits.Sum(x => x.Area);

                            //=== محدودیت 27 متر طی درخواست کتبی سازمان اعمال شده است
                            //=== این محدودیت 27 متر برای ساختمان های گروه الف اعمال نمی شود
                            var maxNextFloorArea = Math.Max((nextArea * 0.25), 27);
                            //if (((area > (nextArea * 0.25)) && (buildingGroupDetectorCount > 2) && (area > 27)) || ((area > 27) && (buildingGroupDetectorCount > 2)))
                            if ((area > maxNextFloorArea) && (buildingGroupDetectorCount > 2))
                            {
                                //if(area > 27)
                                count++;
                            }
                            else if (area > (nextArea * 0.25) && (buildingGroupDetectorCount <= 2))
                                count++;
                        }
                    }
                    else if (floors[i].FloorTypeId == (int)FloorTypes.Attics ||
                        floors[i].FloorTypeId == (int)FloorTypes.HalfFloor ||
                        floors[i].FloorTypeId == (int)FloorTypes.Loft)
                    {
                        if (i > 0)
                        {
                            var preFloor = floors[i - 1];
                            var preArea = preFloor.BuildingUnits.Sum(x => x.Area);
                            var area = floors[i].BuildingUnits.Sum(x => x.Area);

                            //=== برای نیم طبقه ها قانون 33 درصد بررسی می شود
                            if (floors[i].FloorTypeId == (int)FloorTypes.HalfFloor)
                            {
                                if (area > (preArea * 0.33))
                                    count++;
                            }
                            else
                            {
                                //=== محدودیت 27 متر طی درخواست کتبی سازمان اعمال شده است
                                //=== این محدودیت 27 متر برای ساختمان های گروه الف اعمال نمی شود
                                var maxPreFloorArea = Math.Max((preArea * 0.25), 27);
                                if ((area > maxPreFloorArea) && (buildingGroupDetectorCount > 2))
                                {
                                    //if(area > 27)
                                    count++;
                                }
                                else if (area > (preArea * 0.25) && (buildingGroupDetectorCount <= 2))
                                    count++;
                            }

                        }
                    }
                    else
                    {
                        count++;
                    }
                }
                return Task.FromResult(count);
            }
            catch
            {
                return Task.FromResult(0);
            }
        }

        //=== محاسبه تعداد طبقات ساختمان
        public static Task<int> CalculateBuildingFloorCountAsync(List<Floor>? floors, int floorRegisterStepId)
        {
            try
            {
                if (floors == null)
                    return Task.FromResult(0);

                //=== check final floors
                floors = floors.Where(x => x.FloorRegisterStepId == floorRegisterStepId).ToList();

                var count = 0;
                var buildingGroupDetectorCount = floors.Count(x => x.FloorTypeId == (int)FloorTypes.Floor ||
                                                                    x.FloorTypeId == (int)FloorTypes.GroundFloor);
                for (int i = 0; i < floors.Count(); i++)
                {
                    if (floors[i].FloorTypeId == (int)FloorTypes.Basement)
                    {
                        if (i < floors.Count - 1)
                        {
                            var nextFloor = floors[i + 1];
                            var nextArea = nextFloor.BuildingUnits.Sum(x => x.Area);
                            var area = floors[i].BuildingUnits.Sum(x => x.Area);

                            //=== محدودیت 27 متر طی درخواست کتبی سازمان اعمال شده است
                            //=== این محدودیت 27 متر برای ساختمان های گروه الف اعمال نمی شود
                            var maxNextFloorArea = Math.Max((nextArea * 0.25), 27);
                            //if (((area > (nextArea * 0.25)) && (buildingGroupDetectorCount > 2) && (area > 27)) || ((area > 27) && (buildingGroupDetectorCount > 2)))
                            if ((area > maxNextFloorArea) && (buildingGroupDetectorCount > 2))
                            {
                                //if(area > 27)
                                count++;
                            }
                            else if (area > (nextArea * 0.25) && (buildingGroupDetectorCount <= 2))
                                count++;
                        }
                    }
                    else if (floors[i].FloorTypeId == (int)FloorTypes.Attics ||
                        floors[i].FloorTypeId == (int)FloorTypes.HalfFloor ||
                        floors[i].FloorTypeId == (int)FloorTypes.Loft)
                    {
                        if (i > 0)
                        {
                            var preFloor = floors[i - 1];
                            var preArea = preFloor.BuildingUnits.Sum(x => x.Area);
                            var area = floors[i].BuildingUnits.Sum(x => x.Area);

                            //=== برای نیم طبقه ها قانون 33 درصد بررسی می شود
                            if (floors[i].FloorTypeId == (int)FloorTypes.HalfFloor)
                            {
                                if (area > (preArea * 0.33))
                                    count++;
                            }
                            else
                            {
                                //=== محدودیت 27 متر طی درخواست کتبی سازمان اعمال شده است
                                //=== این محدودیت 27 متر برای ساختمان های گروه الف اعمال نمی شود
                                var maxPreFloorArea = Math.Max((preArea * 0.25), 27);
                                if ((area > maxPreFloorArea) && (buildingGroupDetectorCount > 2))
                                {
                                    //if(area > 27)
                                    count++;
                                }
                                else if (area > (preArea * 0.25) && (buildingGroupDetectorCount <= 2))
                                    count++;
                            }

                        }
                    }
                    else
                    {
                        count++;
                    }
                }
                return Task.FromResult(count);
            }
            catch
            {
                return Task.FromResult(0);
            }
        }

}
