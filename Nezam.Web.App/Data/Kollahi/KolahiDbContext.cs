using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Nezam.CES.Data.Configurations;
using Nezam.CES.Data.Models;
using Nezam.ESS.backend.Data.Configurations;
using Nezam.ESS.backend.Data.Models;

namespace Nezam.CES.Data;

public partial class KolahiDbContext : DbContext
{

    public KolahiDbContext(DbContextOptions<KolahiDbContext> options):base(options)
    {
        
    }
    public virtual required DbSet<TblPublicUser> TblPublicUsers { get; set; }
    public virtual required DbSet<TblDafaterOstan> TblDafaterOstans { get; set; }
    public virtual required DbSet<TblUtmMaininfo> TblUtmMaininfos { get; set; }
    public virtual required DbSet<TblUtmMerchants> TblUtmMerchants { get; set; }
    public virtual required DbSet<TblUtmPayment> TblUtmPayments { get; set; }
    public virtual required DbSet<TblUtmMaininfoTemp> TblUtmMaininfoTemps { get; set; }
    public virtual required DbSet<TblUtmMantageh> TblUtmMantagehs { get; set; }
    public virtual required DbSet<TblUtmTaarefe> TblUtmTaarefes { get; set; }
    public virtual required DbSet<TblUtmLogs> TblUtmLogs { get; set; }
    public virtual required DbSet<TblUtmEng> TblUtmEngs { get; set; }
    public virtual required DbSet<TblUtmSahmieh> TblUtmSahmiehs { get; set; }
    public virtual required DbSet<TblEngineer> TblEngineers { get; set; }
    public virtual DbSet<TblBargTempMapinfo> TblBargTempMapinfos { get; set; }
    public virtual required DbSet<TblEesDocuments> TblEesDocuments { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfiguration(new TblPublicUserConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmMerchantsConfiguration());
        modelBuilder.ApplyConfiguration(new TblDafaterOstanConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmMantagehConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmMaininfoConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmPaymentConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmMaininfoTempConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmTaarefeConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmSahmiehConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmEngConfiguration());
        modelBuilder.ApplyConfiguration(new TblEngineerConfiguration());
        modelBuilder.ApplyConfiguration(new TblUtmLogsConfiguration());
        modelBuilder.ApplyConfiguration(new TblEesDocumentsConfiguration());
        
        
        modelBuilder.Entity<TblBargTempMapinfo>(entity =>
        {
          entity.HasKey(e => e.TraceId);

          entity.ToTable("tbl_barg_temp_mapinfo");
          entity.Property(e => e.AreaCod)
            .HasColumnName("AreaCod");
          entity.Property(e => e.TraceId)
            .ValueGeneratedNever()
            .HasColumnName("trace_id");
          entity.Property(e => e.Address)
            .HasMaxLength(255)
            .HasColumnName("address");
          entity.Property(e => e.BargTraceId)
            .HasMaxLength(50)
            .HasDefaultValueSql("((0))")
            .HasColumnName("barg_trace_id");
          entity.Property(e => e.BranchInfo)
            .HasMaxLength(255)
            .HasColumnName("branch_info");
          entity.Property(e => e.Comments)
            .HasMaxLength(255)
            .HasColumnName("comments");
          entity.Property(e => e.Id)
            .ValueGeneratedOnAdd()
            .HasColumnName("id");
          entity.Property(e => e.MalekFname)
            .HasMaxLength(50)
            .HasColumnName("malek_fname");
          entity.Property(e => e.MalekName)
            .HasMaxLength(50)
            .HasColumnName("malek_name");
          entity.Property(e => e.MelliCod)
            .HasMaxLength(50)
            .HasColumnName("melli_cod");
          entity.Property(e => e.MobNo)
            .HasMaxLength(50)
            .HasColumnName("mob_no");
          entity.Property(e => e.PelakSabti)
            .HasMaxLength(255)
            .HasColumnName("pelak_sabti");
          entity.Property(e => e.SabtDate)
            .HasDefaultValueSql("(getdate())")
            .HasColumnType("datetime")
            .HasColumnName("sabt_date");
        });
    }
}