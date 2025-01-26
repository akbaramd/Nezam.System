using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Nezam.CES.Data.Models;

namespace Nezam.CES.Data.Configurations;

public class TblUtmLogsConfiguration : IEntityTypeConfiguration<TblUtmLogs>
{
    public void Configure(EntityTypeBuilder<TblUtmLogs> entity)
    {
        entity.HasKey(e => e.Id);

        entity.Property(e => e.Id)
          .ValueGeneratedOnAdd()
          .HasColumnName("id");
        
        entity.ToTable("tbl_UTM_logs");

        entity.Property(e => e.Title)
            .HasMaxLength(200)
            .HasColumnName("title");
        
        entity.Property(e => e.Type)
          .HasMaxLength(200)
          .HasColumnName("type");
            
        entity.Property(e => e.Payload)
          .HasColumnName("payload");
        
        entity.Property(e => e.RegDate)
          .HasDefaultValueSql("(getdate())")
          .HasColumnType("datetime")
          .HasColumnName("reg_date");
        
    }
}