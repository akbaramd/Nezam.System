
using Microsoft.EntityFrameworkCore;
using Velzon.Data.Cedo;

namespace CedoLib.Utilities.Helper
{
    public class CityCodeHelper
    {
        public static async Task<int?> GetSateliteMainCityIdAsync(IServiceProvider serviceProvider, City? city)
        {
            int? result = null;

            try
            {
                if (city != null)
                {
                    if (city.IsSatellite)
                    {
                        var ds = serviceProvider.GetRequiredService<CedoContext>();
                        var agency = await ds.CedoAgencyCities
                            .AsNoTracking()
                            .FirstOrDefaultAsync(x => x.CityId == city.Id);

                        if (agency != null)
                        {
                            var list = await ds.CedoAgencyCities
                                .AsNoTracking()
                                .Where(x => x.AgencyId == agency.AgencyId && !x.City.IsSatellite).OrderBy(x => x.Id).ToListAsync();
                            var mainCity = list.FirstOrDefault();

                            if (mainCity != null)
                            {
                                result = mainCity.CityId;
                            }
                        }
                    }
                    else
                    {
                        result = city.Id;
                    }
                }
            }
            catch (Exception)
            {
                result = null;
            }

            return result;
        }

        public static async Task<int?> GetSateliteMainCitySyncCodeAsync(IServiceProvider serviceProvider, City? city)
        {
            int? result = null;

            try
            {
                if (city != null)
                {
                    if (city.IsSatellite)
                    {
                      var ds = serviceProvider.GetRequiredService<CedoContext>();
                        var agency = await ds.CedoAgencyCities.FirstOrDefaultAsync(x => x.CityId == city.Id);

                        if (agency != null)
                        {
                            var list = await ds.CedoAgencyCities.Include(x => x.City).Where(x => x.AgencyId == agency.AgencyId && !x.City.IsSatellite).OrderBy(x => x.Id).ToListAsync();
                            var mainCity = list.FirstOrDefault();

                            if (mainCity != null)
                            {
                                result = mainCity.City.SyncCode;
                            }
                        }
                    }
                    else
                    {
                        result = city.SyncCode;
                    }
                }
            }
            catch (Exception)
            {
                result = null;
            }

            return result;
        }

        public static async Task<int> GetSateliteMainMunicipalityIdAsync(IServiceProvider serviceProvider, Municipality municipality)
        {
            var result = municipality?.Id ?? 0;

            if (municipality != null && municipality.City != null)
            {
                if (municipality.City.IsSatellite)
                {
                  var ds = serviceProvider.GetRequiredService<CedoContext>();
                    var agency = await ds.CedoAgencyCities.FirstOrDefaultAsync(x => x.CityId == municipality.CityId);

                    if (agency != null)
                    {
                        var list = await ds.CedoAgencyCities.Include(x => x.City.Municipalities).Where(x => x.AgencyId == agency.AgencyId && !x.City.IsSatellite).OrderBy(x => x.Id).ToListAsync();
                        var mainCity = list.FirstOrDefault();

                        if (mainCity != null)
                        {
                            result = mainCity.City?.Municipalities?.FirstOrDefault()?.Id ?? 0;
                        }
                    }
                }
            }

            return result;
        }

        public static async Task<City?> GetCityAsync(IServiceProvider serviceProvider, int cityId)
        {
          var ds = serviceProvider.GetRequiredService<CedoContext>();
            return await ds.Cities.FirstOrDefaultAsync(x => x.Id == cityId);
        }

        public static async Task<int?> GetPlanControlCityIdAsync(IServiceProvider serviceProvider, City? city, int serviceTypeId, int? serviceFieldId, int dossierTypeId)
        {
            int? result = null;
            try
            {
                var cityId = await GetSateliteMainCityIdAsync(serviceProvider, city);

                if (cityId.HasValue)
                {
                  var ds = serviceProvider.GetRequiredService<CedoContext>();
                    var list = await ds.PlanControlSettings.Where(x => x.SourceCityId == cityId &&
                        x.DossierTypeId == dossierTypeId &&
                        x.ServiceTypeId == serviceTypeId)
                        .OrderByDescending(x => x.Id).ToListAsync();

                    if (serviceFieldId.HasValue)
                        list = list.Where(x => x.ServiceFieldId == serviceFieldId.Value).OrderByDescending(x => x.Id).ToList();

                    PlanControlSetting? model = null;
                    if (list.Any())
                        model = list.FirstOrDefault();

                    //=== اگر تنظیمات ثبت نشده باشد خود شهر برگردانده شود
                    if (model != null)
                    {
                        if (model.IsActive && model.TargetCityId.HasValue)
                        {
                            result = model.TargetCityId.Value;
                        }
                        else if (model.IsActive)
                        {
                            //=== فعال باشد ولی شهر مقصد نداشته باشد خود شهر برگردانده می شود
                            result = cityId;
                        }
                        else
                        {
                            //=== غیرفعال باشد کنترل نمی شود
                            return null;
                        }
                    }
                    else
                    {
                        result = cityId;
                    }
                }
            }
            catch (Exception)
            {
                result = null;
            }
            return result;
        }

        public static async Task<Guid?> GetPlanControlDefaultControllerAsync(IServiceProvider serviceProvider, City? city, int serviceTypeId, int? serviceFieldId, int? dossierTypeId, int? buildingSubGroupId)
        {
            Guid? result = null;
            try
            {
                var cityId = await GetSateliteMainCityIdAsync(serviceProvider, city);

                if (cityId.HasValue)
                {
                  var ds = serviceProvider.GetRequiredService<CedoContext>();
                    var list = await ds.PlanControlSettings.Include(x => x.DefaultUserId).Where(x => x.SourceCityId == cityId &&
                        x.DossierTypeId == dossierTypeId &&
                        (x.BuildingSubGroupId == null || x.BuildingSubGroupId == buildingSubGroupId) &&
                        x.ServiceTypeId == serviceTypeId)
                        .OrderByDescending(x => x.Id).ToListAsync();

                    if (serviceFieldId.HasValue)
                        list = list.Where(x => x.ServiceFieldId == serviceFieldId.Value).OrderByDescending(x => x.Id).ToList();

                    PlanControlSetting? model = null;
                    if (list.Any())
                        model = list.FirstOrDefault();

                    if (model != null)
                    {
                        if (model.IsActive /*&& model.DefaultUserId != null*/)
                        {
                            result = model.DefaultUserIdId;
                        }
                    }

                    if (result == null && dossierTypeId.HasValue)
                    {
                        return await GetPlanControlDefaultControllerAsync(serviceProvider, city, serviceTypeId, serviceFieldId, null, buildingSubGroupId);
                    }
                }
            }
            catch (Exception)
            {
                result = null;
            }
            return result;
        } 

        public static async Task<List<Guid>> GetPlanControlDefaultControllerListAsync(IServiceProvider serviceProvider, City? city, int serviceTypeId, int? serviceFieldId, int dossierTypeId, int? buildingSubGroupId = null)
        {
            List<Guid> result = new List<Guid>();
            try
            {
                var cityId = await GetSateliteMainCityIdAsync(serviceProvider, city);

                if (cityId.HasValue)
                {
                  var ds = serviceProvider.GetRequiredService<CedoContext>();
                    var list = await ds.PlanControlSettings.Include(x => x.DefaultUserId)
                        .Where(x => 
                            x.SourceCityId == cityId &&
                            (buildingSubGroupId == null || x.BuildingSubGroupId == buildingSubGroupId) &&
                        //x.DossierTypeId == dossierTypeId &&
                        x.ServiceTypeId == serviceTypeId)
                        .OrderByDescending(x => x.Id).ToListAsync();

                    if (serviceFieldId.HasValue)
                        list = list.Where(x => x.ServiceFieldId == serviceFieldId.Value).OrderByDescending(x => x.Id).ToList();

                    if (list.Any())
                    {
                        foreach (var item in list)
                        {
                            if (item.DefaultUserIdId.HasValue)
                                result.Add(item.DefaultUserIdId.Value);
                        }
                    }
                }
            }
            catch (Exception)
            {
                //=== do nothing
            }
            return result;
        }


        public static async Task<int> GetDossierMainCityId(IServiceProvider serviceProvider, int constructionLicenseId)
        {
            var result = 0;
            try
            {
              var ds = serviceProvider.GetRequiredService<CedoContext>();
                var model = await ds.ConstructionLicenses.Include(x => x.Estate.Municipality.City).FirstOrDefaultAsync(x => x.Id == constructionLicenseId);

                if (model != null)
                    result = await GetSateliteMainCityIdAsync(serviceProvider, model.Estate.Municipality.City) ?? 0;
            }
            catch
            { }

            return result;
        }

        public static async Task<int> GetDossierMainCitySyncCode(IServiceProvider serviceProvider, int constructionLicenseId)
        {
            var result = 0;
            try
            {
              var ds = serviceProvider.GetRequiredService<CedoContext>();
                var model = await ds.ConstructionLicenses.Include(x => x.Estate.Municipality.City).FirstOrDefaultAsync(x => x.Id == constructionLicenseId);

                if (model != null)
                    result = await GetSateliteMainCitySyncCodeAsync(serviceProvider, model.Estate.Municipality.City) ?? 0;
            }
            catch
            { }

            return result;
        }

        public static async Task<string> GetDossierMainCityNameAsync(IServiceProvider serviceProvider, City? city)
        {
            var result = "";
            try
            {
                var parentCityName = "";
                var cityName = "";

                if (city != null)
                {
                    if (city.IsSatellite)
                    {
                        var cityId = await GetSateliteMainCityIdAsync(serviceProvider, city);
                        var temp = await GetCityAsync(serviceProvider, cityId ?? 0);
                        if (temp != null)
                            parentCityName = temp.Name;
                    }

                    cityName = city.Name;

                    if (!string.IsNullOrEmpty(parentCityName))
                        result = $"{parentCityName} ({cityName})";
                    else
                        result = cityName;
                }
            }
            catch
            { }

            return result;
        }

    }
}
