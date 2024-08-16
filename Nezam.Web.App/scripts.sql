USE [CEDOWA-RT-V2]
GO
/****** Object:  Schema [cedo]    Script Date: 8/16/2024 6:11:46 PM ******/
CREATE SCHEMA [cedo]
GO
/****** Object:  Schema [puyahlpdsk]    Script Date: 8/16/2024 6:11:46 PM ******/
CREATE SCHEMA [puyahlpdsk]
GO
/****** Object:  FullTextCatalog [ftDocumentIndexCatalog]    Script Date: 8/16/2024 6:11:46 PM ******/
CREATE FULLTEXT CATALOG [ftDocumentIndexCatalog] WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
GO
/****** Object:  FullTextCatalog [FullTextSearch]    Script Date: 8/16/2024 6:11:46 PM ******/
CREATE FULLTEXT CATALOG [FullTextSearch] WITH ACCENT_SENSITIVITY = ON
GO
/****** Object:  UserDefinedFunction [dbo].[ToMiladi]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[ToMiladi] (@DateStr varchar(10))

RETURNS DATETIME

AS

BEGIN

declare @YYear int,@MMonth int,@DDay int,@epbase int,@epyear int,@mdays int,@persian_jdn int,@i int,

@j int,@l int,@n int,@TMPRESULT varchar(10),@IsValideDate int,@TempStr varchar(20),@TmpDateStr varchar(10)

SET @i=charindex('/',@DateStr)

IF LEN(@DateStr) - CHARINDEX('/', @DateStr,CHARINDEX('/', @DateStr,1)+1) = 4

BEGIN

IF ( ISDATE(@TmpDateStr) =1 )

RETURN @TmpDateStr

ELSE

RETURN NULL

END

ELSE

SET @TmpDateStr = @DateStr

IF ((@i<>0) and

(ISNUMERIC(REPLACE(@TmpDateStr,'/',''))=1) and

(charindex('.',@TmpDateStr)=0))

BEGIN

SET @YYear=CAST(SUBSTRING(@TmpDateStr,1,@i-1) AS INT)

IF ( @YYear< 1300 )

SET @YYear =@YYear + 1300

IF @YYear > 9999

RETURN NULL

SET @TempStr= SUBSTRING(@TmpDateStr,@i+1,Len(@TmpDateStr))

SET @i=charindex('/',@TempStr)

SET @MMonth=CAST(SUBSTRING(@TempStr,1,@i-1) AS INT)

SET @MMonth=@MMonth-- -1

SET @TempStr= SUBSTRING(@TempStr,@i+1,Len(@TempStr))

SET @DDay=CAST(@TempStr AS INT)

SET @DDay=@DDay-- - 1

IF ( @YYear >= 0 )

SET @epbase = @YYear - 474

Else

SET @epbase = @YYear - 473

SET @epyear = 474 + (@epbase % 2820)

IF (@MMonth <= 7 )

SET @mdays = ((@MMonth) - 1) * 31

Else

SET @mdays = ((@MMonth) - 1) * 30 + 6

SET @persian_jdn =(@DDay) + @mdays + CAST((((@epyear * 682) - 110) / 2816) as int) + (@epyear - 1) * 365 + CAST((@epbase / 2820) as int ) * 1029983 + (1948321 - 1)

IF (@persian_jdn > 2299160)

BEGIN

SET @l = @persian_jdn + 68569

SET @n = CAST(((4 * @l) / 146097) as int)

SET @l = @l - CAST(((146097 * @n + 3) / 4) as int)

SET @i = CAST(((4000 * (@l + 1)) / 1461001) as int)

SET @l = @l - CAST( ((1461 * @i) / 4) as int) + 31

SET @j = CAST(((80 * @l) / 2447) as int)

SET @DDay = @l - CAST( ((2447 * @j) / 80) as int)

SET @l = CAST((@j / 11) as int)

SET @MMonth = @j + 2 - 12 * @l

SET @YYear = 100 * (@n - 49) + @i + @l

END

SET @TMPRESULT=Cast(@MMonth as varchar(2))+'/'+CAST(@DDay as Varchar(2))+'/'+CAST(@YYear as varchar(4))

RETURN Cast(@TMPRESULT as varchar(10))

END

RETURN NULL
END
GO
/****** Object:  UserDefinedFunction [dbo].[TOShamsi]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[TOShamsi] (@MDate  DateTime) 
RETURNS Varchar(10)
AS 
BEGIN
   DECLARE @SYear  as Integer
   DECLARE @SMonth  as Integer
   DECLARE @SDay  as Integer
   DECLARE @charSYear  as Varchar(10)
   DECLARE @charSMonth  as Varchar(10)
   DECLARE @charSDay  as Varchar(10)
   DECLARE @AllDays  as float
   DECLARE @ShiftDays  as float
   DECLARE @OneYear  as float
   DECLARE @LeftDays  as float
   DECLARE @YearDay  as Integer
   DECLARE @Farsi_Date  as Varchar(10)
   SET @MDate=@MDate-CONVERT(char,@MDate,114)
 
  SET @ShiftDays=466699   +2


/*----------- leap  --------------------
DECLARE @p_leap_date SMALLDATETIME
    DECLARE @p_check_day TINYINT
 
    SET @p_leap_date = CONVERT(VARCHAR(4), year(@MDate)) + '0228'
    SET @p_check_day = DATEPART(d, DATEADD(d, 1, @p_leap_date))
    IF (@p_check_day = 29)
        SET @OneYear= 366.24199
else
		SET @OneYear= 365.24199

    


IF year(@MDate) % 400 = 0
     -- Years divisible by 400 (e.g. 1600, 2000) are always leap years
     SET @OneYear= 365.24199 
  ELSE
  BEGIN
    IF year(@MDate) % 100 = 0
       -- Years not divisible by 400 but divisible by 100 (e.g. 1900) are never leap years
       SET @OneYear= 365.24199
    ELSE
    BEGIN
      IF year(@MDate) % 4 = 0
         -- Years not divisible by 400 or 100 but divisible by 4 (e.g. 1976) are always leap years
         SET @OneYear= 365.24199
      ELSE
         SET @OneYear= 365.24199
    END
  END

----------- leap  --------------------*/
   SET @OneYear= 365.24199

   SET @SYear = 0
   SET @SMonth = 0
   SET @SDay = 0
   SET @AllDays  = CAst(@Mdate as Real)
 
   SET @AllDays = @AllDays + @ShiftDays
 
  SET @SYear = (@AllDays / @OneYear) --trunc





  SET @LeftDays = @AllDays - @SYear * @OneYear
 
  if (@LeftDays < 0.5)
  begin
    SET @SYear=@SYear+1
    SET @LeftDays = @AllDays - @SYear * @OneYear
  end;
 
  SET @YearDay = @LeftDays --trunc
  if (@LeftDays - @YearDay) >= 0.5
    SET @YearDay=@YearDay+1
 
  if ((@YearDay / 31) > 6 )
  begin
    SET @SMonth = 6
    SET @YearDay=@YearDay-(6 * 31)
    SET @SMonth= @SMonth+( @YearDay / 30)
    if (@YearDay % 30) <> 0
      SET @SMonth=@SMonth+1
    SET @YearDay=@YearDay-((@SMonth - 7) * 30)
  end
  else
  begin
    SET @SMonth = @YearDay / 31
    if (@YearDay % 31) <> 0
      SET @SMonth=@SMonth+1
    SET @YearDay=@YearDay-((@SMonth - 1) * 31)
  end
  SET @SDay = @YearDay
  SET @SYear= @SYear+1
 
set @charSYear=CAST (@SYear   as VarChar(10))
if (@SMonth<10)	set @charSMonth='0'+CAST (@SMonth   as VarChar(10)) else set @charSMonth=CAST (@SMonth   as VarChar(10))
if (@SDay<10)	set @charSDay='0'+CAST (@SDay   as VarChar(10)) else set @charSDay=CAST (@SDay   as VarChar(10))

 SET @Farsi_Date = @charSYear   + '/' + @charSMonth + '/' + @charSDay
 Return @Farsi_Date
end;



GO
/****** Object:  Table [cedo].[ConstructionLicenses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EstateId] [int] NOT NULL,
	[ConstructionLicenseTypeId] [int] NOT NULL,
	[UsageTypeId] [int] NOT NULL,
	[RefNumber] [nvarchar](64) NOT NULL,
	[LicenseNumber] [nvarchar](64) NOT NULL,
	[LicenseDate] [datetime2](7) NOT NULL,
	[RequestDate] [datetime2](7) NOT NULL,
	[ValidityDuration] [int] NOT NULL,
	[BeforeWideningArea] [real] NOT NULL,
	[AfterWideningArea] [real] NOT NULL,
	[OccupancyPercentage] [real] NOT NULL,
	[DensityPercentage] [real] NULL,
	[DeploymentSideId] [int] NOT NULL,
	[MaxAllowedFloorGround] [int] NOT NULL,
	[OnGround] [bit] NOT NULL,
	[DossierNumber] [nvarchar](64) NULL,
	[DossierDate] [datetime2](7) NULL,
	[OtherUsageTypes] [nvarchar](256) NULL,
	[StatusId] [int] NOT NULL,
	[StepId] [int] NOT NULL,
	[ExcavationDangerStatusId] [int] NULL,
	[StructureTypeId] [int] NULL,
	[HasViolation] [bit] NULL,
	[MaxAllowedFloorBase] [int] NOT NULL,
	[BuildingGroupSettingId] [int] NULL,
	[LicenseExpireDate] [datetime2](7) NULL,
	[TrackCode] [nvarchar](max) NULL,
	[IsManualSuperVisor] [bit] NULL,
	[FormStepId] [int] NULL,
	[DossierSerial] [nvarchar](50) NULL,
	[RegDate] [datetime2](7) NULL,
	[DossierTypeId] [int] NOT NULL,
	[ParentId] [int] NULL,
	[MaxConstructionLicenseFloorsCount] [int] NULL,
	[FinalBuildingGroupSettingId] [int] NULL,
	[IsReleased] [bit] NULL,
	[ReleaseDate] [datetime2](7) NULL,
	[TransitionalDossierNumber] [nvarchar](max) NULL,
	[TransitionalDossierSerial] [nvarchar](max) NULL,
	[DossierFormalCode] [nvarchar](max) NULL,
	[Density] [int] NULL,
	[TransitionalDossierNumber2] [nvarchar](max) NULL,
	[TransitionalDossierSerial2] [nvarchar](max) NULL,
 CONSTRAINT [PK_ConstructionLicenses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeDesignerRequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeDesignerRequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ChangeDesignerRequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[PaymentComeBackRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PaymentComeBackRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NOT NULL,
	[RequestAmount] [int] NOT NULL,
	[PayedAmount] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[AccountNumber] [nvarchar](128) NOT NULL,
	[BankName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[RequestStatusId] [int] NOT NULL,
 CONSTRAINT [PK_PaymentComeBackRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Bills]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Bills](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NULL,
	[BillTypeId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](2000) NULL,
	[BuildingGroup] [nvarchar](max) NULL,
	[FloorCount] [nvarchar](max) NULL,
	[Metraje] [nvarchar](max) NULL,
	[CourseHoldingMemberId] [uniqueidentifier] NULL,
	[SeparationRequestId] [int] NULL,
	[GasRequestId] [int] NULL,
	[GasRequestOncallId] [int] NULL,
 CONSTRAINT [PK_Bills] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwPaymentCallBackReport]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPaymentCallBackReport]
AS
SELECT        cedo.PaymentComeBackRequests.RequestAmount, cedo.PaymentComeBackRequests.PayedAmount, cedo.PaymentComeBackRequests.RegDate, cedo.PaymentComeBackRequests.AccountNumber, 
                         cedo.PaymentComeBackRequests.BankName, cedo.PaymentComeBackRequests.Description, cedo.ChangeDesignerRequestStatuses.Title, cedo.PaymentComeBackRequests.RequestStatusId, 
                         cedo.ConstructionLicenses.DossierSerial
FROM            cedo.PaymentComeBackRequests INNER JOIN
                         cedo.ChangeDesignerRequestStatuses ON cedo.PaymentComeBackRequests.RequestStatusId = cedo.ChangeDesignerRequestStatuses.Id INNER JOIN
                         cedo.Bills ON cedo.PaymentComeBackRequests.BillId = cedo.Bills.Id INNER JOIN
                         cedo.ConstructionLicenses ON cedo.Bills.ConstructionLicenseId = cedo.ConstructionLicenses.Id
WHERE        (cedo.PaymentComeBackRequests.RequestStatusId = 3)
GO
/****** Object:  Table [cedo].[Members]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Members](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[MemberTypeId] [int] NOT NULL,
	[MembershipCode] [nvarchar](32) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ExpireDate] [datetime2](7) NOT NULL,
	[ExtensionDate] [datetime2](7) NULL,
	[IsActive] [bit] NOT NULL,
	[SyncCode] [int] NULL,
	[MemberShipTypeId] [int] NOT NULL,
	[FormalCode] [nvarchar](max) NULL,
 CONSTRAINT [PK_Members] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SeparationPlanRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SeparationPlanRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceRequestId] [uniqueidentifier] NOT NULL,
	[ReqPlaque] [nvarchar](128) NOT NULL,
	[ReqUnit] [nvarchar](128) NULL,
	[ReqRegion] [nvarchar](128) NULL,
	[Address] [nvarchar](2048) NOT NULL,
	[LicenseNumber] [nvarchar](128) NULL,
	[LicenseDate] [datetime2](7) NULL,
	[WorkEndNumber] [nvarchar](128) NULL,
	[WorkEndDate] [datetime2](7) NULL,
	[InitialMetrage] [float] NOT NULL,
	[InitialRoofs] [int] NOT NULL,
	[UnitCount] [int] NOT NULL,
	[CedoNumber] [nvarchar](max) NULL,
	[StatusId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[MunicipalityId] [int] NULL,
	[ScopeRequestTypeId] [int] NOT NULL,
	[CityId] [int] NOT NULL,
 CONSTRAINT [PK_SeparationPlanRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfiles]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfiles](
	[Id] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](128) NOT NULL,
	[LastName] [nvarchar](128) NOT NULL,
	[Gender] [bit] NULL,
	[NationalCode] [nvarchar](10) NULL,
	[BirthCertId] [nvarchar](20) NULL,
	[Father] [nvarchar](128) NULL,
	[Birthdate] [datetime2](7) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Comment] [nvarchar](1024) NULL,
 CONSTRAINT [PK_UserProfiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Cities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Cities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProvinceId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[UtmZone] [int] NOT NULL,
	[Capital] [bit] NOT NULL,
	[SyncCode] [int] NULL,
	[IsSatellite] [bit] NOT NULL,
	[IsSatelliteConfig] [bit] NOT NULL,
 CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ServiceRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ServiceRequests](
	[Id] [uniqueidentifier] NOT NULL,
	[RequestTypeId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[RequestStatusId] [int] NOT NULL,
 CONSTRAINT [PK_ServiceRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SeparationPlanRequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SeparationPlanRequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SeparationPlanRequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SeparationInvolvedMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SeparationInvolvedMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SeparationRequestId] [int] NOT NULL,
	[MemberServiceId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[TeamLead] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_SeparationInvolvedMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ActivityLicenses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ActivityLicenses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[IssuedCityId] [int] NOT NULL,
	[LicenseSerial] [nvarchar](32) NOT NULL,
	[IssueDate] [datetime2](7) NOT NULL,
	[ExtensionDate] [datetime2](7) NULL,
	[ExpireDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ActivityLicenses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SeparationRequestSurveies]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SeparationRequestSurveies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SeparationRequestId] [int] NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Metrage] [float] NOT NULL,
	[Roofs] [int] NOT NULL,
	[SurveyDate] [datetime2](7) NOT NULL,
	[MunicipalityResponse] [bit] NOT NULL,
	[IsCommercial] [bit] NOT NULL,
	[SurveyUpdateDate] [datetime2](7) NULL,
 CONSTRAINT [PK_SeparationRequestSurveies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MemberServices]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberServices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ActivityLicenseId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[ServiceFieldId] [int] NULL,
	[CityId] [int] NOT NULL,
	[GradeId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[AcquisitionDate] [datetime2](7) NULL,
 CONSTRAINT [PK_MemberServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARA-Users]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARA-Users](
	[Id] [uniqueidentifier] NOT NULL,
	[Disabled] [bit] NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[RefreshToken] [nvarchar](max) NULL,
	[RefreshTokenExpiryTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PARA-Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[InvolvedMemberStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[InvolvedMemberStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_InvolvedMemberStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwSeperationPlans]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwSeperationPlans]
AS
SELECT        cedo.SeparationPlanRequests.Id AS ردیف, cedo.Cities.Name AS شهرستان, cedo.SeparationPlanRequests.RegDate AS [تاریخ ثبت], dbo.UserProfiles.FirstName AS [نام مالک], dbo.UserProfiles.LastName AS [نام خانوادگی], 
                         dbo.UserProfiles.NationalCode AS [کد ملی], dbo.[PARA-Users].PhoneNumber AS [موبایل مالک], cedo.SeparationPlanRequests.Address AS آدرس, cedo.SeparationPlanRequests.ReqPlaque AS [پلاک ثبتی], 
                         cedo.SeparationPlanRequests.UnitCount AS [تعداد واحد], cedo.SeparationPlanRequests.LicenseNumber AS [شماره پروانه], cedo.SeparationPlanRequests.LicenseDate AS [تاریخ پروانه], 
                         cedo.SeparationPlanRequests.InitialMetrage AS متراژ, cedo.SeparationPlanRequests.InitialRoofs AS [تعداد سقف], cedo.SeparationPlanRequestStatuses.Title AS [وضعیت پرونده], 
                         cedo.SeparationRequestSurveies.Metrage AS [متراژ نقشه بردار], cedo.SeparationRequestSurveies.Roofs AS [تعداد سقف نقشه بردار], cedo.SeparationRequestSurveies.IsCommercial AS تجاری, 
                         cedo.Members.MembershipCode AS [شماره عضویت مهندس], UserProfiles_1.FirstName AS [نام مهندس], UserProfiles_1.LastName AS [نام خانوادگی مهندس], cedo.SeparationInvolvedMembers.TeamLead AS سرگروه, 
                         cedo.InvolvedMemberStatuses.Title AS [وضعیت مهندس], cedo.SeparationRequestSurveies.SurveyDate AS [اولین نقشه برداری], cedo.SeparationRequestSurveies.SurveyUpdateDate AS [آخرین نقشه برداری]
FROM            cedo.MemberServices INNER JOIN
                         cedo.SeparationInvolvedMembers ON cedo.MemberServices.Id = cedo.SeparationInvolvedMembers.MemberServiceId AND cedo.MemberServices.Id = cedo.SeparationInvolvedMembers.MemberServiceId AND 
                         cedo.MemberServices.Id = cedo.SeparationInvolvedMembers.MemberServiceId INNER JOIN
                         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id AND cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id AND 
                         cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
                         cedo.Members ON cedo.ActivityLicenses.MemberId = cedo.Members.Id AND cedo.ActivityLicenses.MemberId = cedo.Members.Id AND cedo.ActivityLicenses.MemberId = cedo.Members.Id INNER JOIN
                         dbo.[PARA-Users] AS [PARA-Users_1] ON cedo.Members.UserId = [PARA-Users_1].Id AND cedo.Members.UserId = [PARA-Users_1].Id INNER JOIN
                         dbo.UserProfiles AS UserProfiles_1 ON [PARA-Users_1].Id = UserProfiles_1.Id AND [PARA-Users_1].Id = UserProfiles_1.Id AND [PARA-Users_1].Id = UserProfiles_1.Id AND [PARA-Users_1].Id = UserProfiles_1.Id AND 
                         [PARA-Users_1].Id = UserProfiles_1.Id AND [PARA-Users_1].Id = UserProfiles_1.Id AND [PARA-Users_1].Id = UserProfiles_1.Id AND [PARA-Users_1].Id = UserProfiles_1.Id AND [PARA-Users_1].Id = UserProfiles_1.Id AND 
                         [PARA-Users_1].Id = UserProfiles_1.Id INNER JOIN
                         cedo.InvolvedMemberStatuses ON cedo.SeparationInvolvedMembers.StatusId = cedo.InvolvedMemberStatuses.Id AND cedo.SeparationInvolvedMembers.StatusId = cedo.InvolvedMemberStatuses.Id AND 
                         cedo.SeparationInvolvedMembers.StatusId = cedo.InvolvedMemberStatuses.Id RIGHT OUTER JOIN
                         cedo.SeparationPlanRequests INNER JOIN
                         cedo.Cities ON cedo.SeparationPlanRequests.CityId = cedo.Cities.Id INNER JOIN
                         cedo.ServiceRequests ON cedo.SeparationPlanRequests.ServiceRequestId = cedo.ServiceRequests.Id INNER JOIN
                         dbo.[PARA-Users] ON cedo.ServiceRequests.UserId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id INNER JOIN
                         cedo.SeparationPlanRequestStatuses ON cedo.SeparationPlanRequests.StatusId = cedo.SeparationPlanRequestStatuses.Id AND cedo.SeparationPlanRequests.StatusId = cedo.SeparationPlanRequestStatuses.Id AND 
                         cedo.SeparationPlanRequests.StatusId = cedo.SeparationPlanRequestStatuses.Id ON cedo.SeparationInvolvedMembers.SeparationRequestId = cedo.SeparationPlanRequests.Id LEFT OUTER JOIN
                         cedo.SeparationRequestSurveies ON cedo.SeparationPlanRequests.Id = cedo.SeparationRequestSurveies.SeparationRequestId
GO
/****** Object:  Table [cedo].[PaymentReceipts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PaymentReceipts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[TrackCode] [nvarchar](1000) NULL,
	[PaymentStatusId] [int] NOT NULL,
	[BillPaymentCode] [nvarchar](128) NULL,
	[PayCode] [nvarchar](128) NULL,
	[PaymentDate] [datetime2](7) NULL,
	[Token] [nvarchar](128) NULL,
	[HashCardNumber] [nvarchar](128) NULL,
	[RRN] [nvarchar](128) NULL,
	[InstanceId] [int] NULL,
	[PaymentTypeId] [int] NULL,
	[Comment] [nvarchar](512) NULL,
	[Description] [nvarchar](1024) NULL,
 CONSTRAINT [PK_PaymentReceipts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Payment]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Payment]
AS
SELECT        cedo.PaymentReceipts.Amount, cedo.PaymentReceipts.RRN, cedo.Bills.ConstructionLicenseId, cedo.ConstructionLicenses.DossierNumber, cedo.ConstructionLicenses.LicenseNumber, 
                         cedo.PaymentReceipts.PaymentStatusId
FROM            cedo.PaymentReceipts INNER JOIN
                         cedo.Bills ON cedo.PaymentReceipts.BillId = cedo.Bills.Id INNER JOIN
                         cedo.ConstructionLicenses ON cedo.Bills.ConstructionLicenseId = cedo.ConstructionLicenses.Id
WHERE        (cedo.PaymentReceipts.PaymentStatusId = 2)
GO
/****** Object:  Table [cedo].[BillDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BillDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NOT NULL,
	[CostTypeId] [int] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[Tax] [bigint] NOT NULL,
 CONSTRAINT [PK_BillDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BillTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BillTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_BillTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CostTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CostTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CostTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwBillDetail]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwBillDetail]
AS
SELECT TOP (100) PERCENT cedo.Bills.Id, cedo.Bills.ConstructionLicenseId, cedo.BillTypes.Title, SUM(cedo.BillDetails.Amount) AS Expr1, cedo.ConstructionLicenses.DossierNumber, cedo.BillDetails.CostTypeId, cedo.BillDetails.Amount, cedo.BillDetails.Tax, cedo.CostTypes.Title AS Expr2, cedo.BillDetails.Id AS Expr3
FROM  cedo.Bills INNER JOIN
         cedo.BillTypes ON cedo.Bills.BillTypeId = cedo.BillTypes.Id INNER JOIN
         cedo.BillDetails ON cedo.Bills.Id = cedo.BillDetails.BillId INNER JOIN
         cedo.ConstructionLicenses ON cedo.Bills.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
         cedo.CostTypes ON cedo.BillDetails.CostTypeId = cedo.CostTypes.Id
GROUP BY cedo.Bills.Id, cedo.Bills.ConstructionLicenseId, cedo.BillTypes.Title, cedo.ConstructionLicenses.DossierNumber, cedo.BillDetails.CostTypeId, cedo.BillDetails.Amount, cedo.BillDetails.Tax, cedo.CostTypes.Title, cedo.BillDetails.Id
HAVING (cedo.Bills.Id = 14019)
ORDER BY cedo.Bills.ConstructionLicenseId
GO
/****** Object:  Table [cedo].[ServiceFields]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ServiceFields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ServiceFields] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ServiceTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ServiceTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ServiceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[LegalMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[LegalMembers](
	[Id] [int] NOT NULL,
	[RegNumber] [nvarchar](32) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[LegalMemberTypeId] [int] NOT NULL,
 CONSTRAINT [PK_LegalMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Estates]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Estates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MunicipalityId] [int] NOT NULL,
	[Code] [nvarchar](128) NOT NULL,
	[MainPlaque] [nvarchar](100) NOT NULL,
	[SecondaryPlaque] [nvarchar](100) NOT NULL,
	[PiecePlaque] [nvarchar](100) NULL,
	[PartPlaque] [nvarchar](64) NOT NULL,
	[District] [nvarchar](128) NULL,
	[Street] [nvarchar](128) NOT NULL,
	[Alley] [nvarchar](128) NULL,
	[Plaque] [nvarchar](20) NULL,
	[PostalCode] [nvarchar](15) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[OwnershipDocumentTypeId] [int] NOT NULL,
	[Address] [nvarchar](max) NULL,
 CONSTRAINT [PK_Estates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[InvolvedMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[InvolvedMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[MemberServiceId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ExpireDate] [datetime2](7) NULL,
	[IsCoordinator] [bit] NOT NULL,
	[WorkItem] [float] NULL,
	[Description] [nvarchar](max) NULL,
	[ModifiedWorkItem] [bit] NOT NULL,
	[Metraje] [float] NULL,
	[InvolvedMemberTypeId] [int] NOT NULL,
	[IsManualSelect] [bit] NOT NULL,
	[QuotaYear] [int] NULL,
 CONSTRAINT [PK_InvolvedMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwConstructionLisenceLab]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwConstructionLisenceLab]
AS
SELECT TOP (100) PERCENT cedo.LegalMembers.Id, cedo.LegalMembers.Title, cedo.LegalMembers.LegalMemberTypeId, cedo.ConstructionLicenses.DossierNumber, cedo.MemberServices.ServiceTypeId, cedo.MemberServices.ServiceFieldId, cedo.ServiceTypes.Title AS Expr1, cedo.ServiceFields.Title AS Expr2, cedo.InvolvedMembers.RegDate, cedo.Cities.Name, cedo.Cities.SyncCode
FROM  cedo.Members INNER JOIN
         cedo.LegalMembers ON cedo.Members.Id = cedo.LegalMembers.Id AND cedo.Members.Id = cedo.LegalMembers.Id AND cedo.Members.Id = cedo.LegalMembers.Id INNER JOIN
         cedo.ActivityLicenses ON cedo.Members.Id = cedo.ActivityLicenses.MemberId AND cedo.Members.Id = cedo.ActivityLicenses.MemberId AND cedo.Members.Id = cedo.ActivityLicenses.MemberId INNER JOIN
         cedo.MemberServices ON cedo.ActivityLicenses.Id = cedo.MemberServices.ActivityLicenseId AND cedo.ActivityLicenses.Id = cedo.MemberServices.ActivityLicenseId AND cedo.ActivityLicenses.Id = cedo.MemberServices.ActivityLicenseId INNER JOIN
         cedo.InvolvedMembers ON cedo.MemberServices.Id = cedo.InvolvedMembers.MemberServiceId AND cedo.MemberServices.Id = cedo.InvolvedMembers.MemberServiceId AND cedo.MemberServices.Id = cedo.InvolvedMembers.MemberServiceId INNER JOIN
         cedo.ConstructionLicenses ON cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
         cedo.ServiceFields ON cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id AND cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id AND cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id INNER JOIN
         cedo.ServiceTypes ON cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id AND cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id AND cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id INNER JOIN
         cedo.Estates ON cedo.ConstructionLicenses.EstateId = cedo.Estates.Id AND cedo.ConstructionLicenses.EstateId = cedo.Estates.Id AND cedo.ConstructionLicenses.EstateId = cedo.Estates.Id INNER JOIN
         cedo.Cities ON cedo.MemberServices.CityId = cedo.Cities.Id AND cedo.MemberServices.CityId = cedo.Cities.Id AND cedo.MemberServices.CityId = cedo.Cities.Id
WHERE (cedo.LegalMembers.LegalMemberTypeId = 4)
GO
/****** Object:  Table [dbo].[Flows]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Flows](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[RouteParam] [nvarchar](128) NULL,
	[Group] [nvarchar](100) NULL,
 CONSTRAINT [PK_Flows] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowVersions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowVersions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FlowId] [int] NOT NULL,
	[Version] [int] NOT NULL,
 CONSTRAINT [PK_FlowVersions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowSteps]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowSteps](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[VisitedAt] [datetime2](7) NULL,
	[DoneAt] [datetime2](7) NULL,
	[Comment] [nvarchar](max) NULL,
	[FlowInstanceId] [int] NOT NULL,
	[FlowNodeId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[OwnerId] [uniqueidentifier] NULL,
	[Title] [nvarchar](512) NULL,
	[SubTitle] [nvarchar](128) NULL,
 CONSTRAINT [PK_FlowSteps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StepRecordLogs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StepRecordLogs](
	[Id] [int] NOT NULL,
	[RecordId] [nvarchar](256) NULL,
	[Entity] [nvarchar](256) NULL,
	[DateTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_StepRecordLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowInstances]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowInstances](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FlowVersionId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[TrackCode] [nvarchar](max) NULL,
	[Title] [nvarchar](512) NULL,
	[StatusId] [int] NOT NULL,
	[UserGroupId] [int] NOT NULL,
	[ParentInstanceId] [int] NULL,
 CONSTRAINT [PK_FlowInstances] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[TrackCode]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TrackCode]
AS
SELECT        dbo.Flows.Name, dbo.FlowInstances.TrackCode, dbo.StepRecordLogs.RecordId, dbo.StepRecordLogs.Entity, dbo.[PARA-Users].UserName, dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName
FROM            dbo.Flows INNER JOIN
                         dbo.FlowVersions ON dbo.Flows.Id = dbo.FlowVersions.FlowId INNER JOIN
                         dbo.FlowInstances ON dbo.FlowVersions.Id = dbo.FlowInstances.FlowVersionId INNER JOIN
                         dbo.FlowSteps ON dbo.FlowInstances.Id = dbo.FlowSteps.FlowInstanceId INNER JOIN
                         dbo.StepRecordLogs ON dbo.FlowSteps.Id = dbo.StepRecordLogs.Id INNER JOIN
                         dbo.[PARA-Users] ON dbo.FlowSteps.OwnerId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id
WHERE        (dbo.StepRecordLogs.Entity = N'LicenseInquery') AND (dbo.StepRecordLogs.RecordId = N'1212')
GO
/****** Object:  Table [cedo].[InvolvedMemberType]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[InvolvedMemberType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_InvolvedMemberType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwInvolvedMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwInvolvedMembers]
AS
SELECT        TOP (100) PERCENT cedo.MemberServices.Id AS Expr1, cedo.InvolvedMembers.ConstructionLicenseId, cedo.InvolvedMembers.Id AS InvolvedmemberId, cedo.Members.SyncCode, dbo.UserProfiles.FirstName, 
                         dbo.UserProfiles.LastName, cedo.ConstructionLicenses.DossierNumber, cedo.ServiceTypes.Title AS Expr2, cedo.ServiceFields.Title AS ServiceTypes, cedo.ServiceTypes.Id AS ServiceTypeId, 
                         cedo.InvolvedMemberStatuses.Title, cedo.MemberServices.ServiceFieldId, cedo.InvolvedMembers.RegDate, cedo.InvolvedMembers.StatusId, cedo.ActivityLicenses.MemberId, cedo.InvolvedMemberType.Title AS Expr3, 
                         cedo.InvolvedMembers.MemberServiceId, cedo.InvolvedMembers.Metraje
FROM            cedo.MemberServices INNER JOIN
                         cedo.InvolvedMembers ON cedo.MemberServices.Id = cedo.InvolvedMembers.MemberServiceId INNER JOIN
                         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id AND cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id AND 
                         cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
                         cedo.Members ON cedo.ActivityLicenses.MemberId = cedo.Members.Id INNER JOIN
                         dbo.[PARA-Users] ON cedo.Members.UserId = dbo.[PARA-Users].Id AND cedo.Members.UserId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id INNER JOIN
                         cedo.ConstructionLicenses ON cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND 
                         cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
                         cedo.ServiceTypes ON cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id AND cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id AND 
                         cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id INNER JOIN
                         cedo.ServiceFields ON cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id AND cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id AND 
                         cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id INNER JOIN
                         cedo.InvolvedMemberStatuses ON cedo.InvolvedMembers.StatusId = cedo.InvolvedMemberStatuses.Id AND cedo.InvolvedMembers.StatusId = cedo.InvolvedMemberStatuses.Id AND 
                         cedo.InvolvedMembers.StatusId = cedo.InvolvedMemberStatuses.Id INNER JOIN
                         cedo.InvolvedMemberType ON cedo.InvolvedMembers.InvolvedMemberTypeId = cedo.InvolvedMemberType.Id
WHERE        (cedo.InvolvedMembers.ConstructionLicenseId = 5622 OR
                         cedo.InvolvedMembers.ConstructionLicenseId = 2200) AND (cedo.MemberServices.ServiceFieldId = 3)
ORDER BY cedo.ConstructionLicenses.DossierNumber
GO
/****** Object:  Table [cedo].[PlanControlStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PlanControlStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_PlanControlStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[PlanControls]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PlanControls](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[ConstructionLicenseDocumentId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[PlanControlStatusId] [int] NOT NULL,
	[IsChangePlanControl] [bit] NOT NULL,
 CONSTRAINT [PK_PlanControls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ConstructionLicenseDocuments]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseDocuments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[DocumentTypeId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[RegDate] [datetime2](7) NULL,
 CONSTRAINT [PK_ConstructionLicenseDocuments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[DocumentTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DocumentTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_DocumentTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwPlanControl]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPlanControl]
AS
SELECT cedo.PlanControls.*, cedo.ConstructionLicenseDocuments.DocumentTypeId, cedo.DocumentTypes.Title, cedo.ConstructionLicenseDocuments.ConstructionLicenseId, cedo.PlanControlStatuses.Title AS Expr1
FROM  cedo.PlanControls INNER JOIN
         cedo.ConstructionLicenseDocuments ON cedo.PlanControls.ConstructionLicenseDocumentId = cedo.ConstructionLicenseDocuments.Id INNER JOIN
         cedo.DocumentTypes ON cedo.ConstructionLicenseDocuments.DocumentTypeId = cedo.DocumentTypes.Id INNER JOIN
         cedo.PlanControlStatuses ON cedo.PlanControls.PlanControlStatusId = cedo.PlanControlStatuses.Id
WHERE (cedo.ConstructionLicenseDocuments.ConstructionLicenseId = 45)
GO
/****** Object:  View [dbo].[UserTypePhoneNumbers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UserTypePhoneNumbers]
AS
SELECT        cedo.ServiceTypes.Title, cedo.ServiceFields.Title AS ServiceField, cedo.ServiceTypes.Id AS ServiceTypeId, dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, cedo.MemberServices.IsActive, 
                         dbo.[PARA-Users].PhoneNumber
FROM            cedo.MemberServices INNER JOIN
                         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
                         cedo.Members ON cedo.ActivityLicenses.MemberId = cedo.Members.Id AND cedo.ActivityLicenses.MemberId = cedo.Members.Id AND cedo.ActivityLicenses.MemberId = cedo.Members.Id INNER JOIN
                         dbo.[PARA-Users] ON cedo.Members.UserId = dbo.[PARA-Users].Id AND cedo.Members.UserId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND 
                         dbo.[PARA-Users].Id = dbo.UserProfiles.Id INNER JOIN
                         cedo.ServiceFields ON cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id AND cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id AND 
                         cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id INNER JOIN
                         cedo.ServiceTypes ON cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id AND cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id AND cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id
WHERE        (cedo.ServiceTypes.Id = 3) AND (cedo.MemberServices.IsActive = 1)
GO
/****** Object:  Table [cedo].[BuildingUnits]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingUnits](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FloorId] [int] NOT NULL,
	[UsageTypeId] [int] NOT NULL,
	[UnitCount] [int] NOT NULL,
	[Area] [float] NOT NULL,
 CONSTRAINT [PK_BuildingUnits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Floors]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Floors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[FloorTypeId] [int] NOT NULL,
	[FloorRegisterStepId] [int] NOT NULL,
 CONSTRAINT [PK_Floors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FloorTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FloorTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FloorTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Floors]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Floors]
AS
SELECT cedo.ConstructionLicenses.Id, cedo.ConstructionLicenses.DossierNumber, Floors_1.FloorTypeId, cedo.FloorTypes.Title, cedo.BuildingUnits.Area, cedo.BuildingUnits.Id AS BuildingUnitId, Floors_1.Id AS Expr1
FROM  cedo.ConstructionLicenses INNER JOIN
         cedo.Floors AS Floors_1 ON cedo.ConstructionLicenses.Id = Floors_1.ConstructionLicenseId INNER JOIN
         cedo.FloorTypes ON Floors_1.FloorTypeId = cedo.FloorTypes.Id INNER JOIN
         cedo.BuildingUnits ON Floors_1.Id = cedo.BuildingUnits.FloorId
WHERE (cedo.ConstructionLicenses.DossierNumber = N'55767')
GO
/****** Object:  Table [cedo].[Municipalities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Municipalities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CityId] [int] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[RegionCode] [int] NULL,
	[RegionTitle] [nvarchar](128) NULL,
 CONSTRAINT [PK_Municipalities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwIncompleteBills]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwIncompleteBills]
AS
SELECT        TOP (100) PERCENT cedo.ConstructionLicenses.Id, cedo.ConstructionLicenses.DossierNumber, cedo.Cities.Name, cedo.BillDetails.CostTypeId, cedo.BillDetails.Amount, cedo.Municipalities.CityId
FROM            cedo.Bills INNER JOIN
                         cedo.BillDetails ON cedo.Bills.Id = cedo.BillDetails.BillId INNER JOIN
                         cedo.ConstructionLicenses ON cedo.Bills.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
                         cedo.Estates ON cedo.ConstructionLicenses.EstateId = cedo.Estates.Id INNER JOIN
                         cedo.Municipalities ON cedo.Estates.MunicipalityId = cedo.Municipalities.Id INNER JOIN
                         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id
WHERE        (cedo.BillDetails.CostTypeId = 1) AND (cedo.BillDetails.Amount = 0)
ORDER BY cedo.Municipalities.CityId
GO
/****** Object:  Table [cedo].[BuildingSubGroups]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingSubGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BuildingGroupId] [int] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[SyncCode] [int] NOT NULL,
 CONSTRAINT [PK_BuildingSubGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BuildingGroupSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingGroupSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MunicipalityId] [int] NULL,
	[Title] [nvarchar](128) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FloorCount] [int] NOT NULL,
	[Metraj] [int] NOT NULL,
	[NeedsGeo] [bit] NOT NULL,
	[NeedsArchitecturePlan] [bit] NOT NULL,
	[NeedsStructurePlan] [bit] NOT NULL,
	[NeedsElectricPlan] [bit] NOT NULL,
	[NeedsMechanicPlan] [bit] NOT NULL,
	[NeedsArchitectureSupervisor] [bit] NOT NULL,
	[NeedsStructureSupervisor] [bit] NOT NULL,
	[NeedsElectricSupervisor] [bit] NOT NULL,
	[NeedsMechanicSupervisor] [bit] NOT NULL,
	[NeedsSurveyorSupervisor] [bit] NOT NULL,
	[NeedsExecuter] [bit] NOT NULL,
	[NeedsInsuranceCheck] [bit] NOT NULL,
	[ContractDuration] [int] NOT NULL,
	[GeoMinArea] [int] NOT NULL,
	[GeoMinFloorCount] [int] NOT NULL,
	[ManualSupervisorSelection] [bit] NOT NULL,
	[MinMetrajNeedsExecuter] [int] NOT NULL,
	[MinMetraj] [int] NOT NULL,
	[SubGroupId] [int] NOT NULL,
	[ArchitechtureContractDuration] [int] NOT NULL,
	[ElectricityContractDuration] [int] NOT NULL,
	[IsChangeDesigner] [bit] NOT NULL,
	[MechanicContractDuration] [int] NOT NULL,
	[StructureContractDuration] [int] NOT NULL,
	[ExecuterContractDuration] [int] NOT NULL,
	[ExecuterMinContractAmount] [int] NOT NULL,
	[MinFloorsNeedsExecuter] [int] NOT NULL,
	[SupervisorCount] [int] NOT NULL,
	[NeedsMechaniOrElectricity] [bit] NOT NULL,
	[ExpireDate] [datetime2](7) NULL,
	[DossierTypeId] [int] NULL,
 CONSTRAINT [PK_BuildingGroupSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwBuildingGroupSetting]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwBuildingGroupSetting]
AS
SELECT   cedo.BuildingGroupSettings.Title AS Expr2, cedo.BuildingSubGroups.Title AS Expr3, cedo.BuildingSubGroups.SyncCode, cedo.Municipalities.Title AS Expr4, cedo.Cities.Name, 
                         cedo.BuildingGroupSettings.IsActive, cedo.BuildingGroupSettings.SupervisorCount, cedo.BuildingGroupSettings.NeedsSurveyorSupervisor
FROM         cedo.Municipalities INNER JOIN
                         cedo.BuildingGroupSettings ON cedo.Municipalities.Id = cedo.BuildingGroupSettings.MunicipalityId INNER JOIN
                         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id RIGHT OUTER JOIN
                         cedo.BuildingSubGroups ON cedo.BuildingGroupSettings.SubGroupId = cedo.BuildingSubGroups.Id
WHERE     (cedo.BuildingGroupSettings.IsActive = 1) AND (cedo.BuildingGroupSettings.MunicipalityId > 41) AND (cedo.BuildingGroupSettings.FloorCount = 5)
GO
/****** Object:  Table [cedo].[DossierType]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DossierType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_DossierType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OwnershipDocumentTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OwnershipDocumentTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_OwnershipDocumentTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Owners]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Owners](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[IsAgent] [bit] NOT NULL,
	[FirstName] [nvarchar](128) NOT NULL,
	[LastName] [nvarchar](128) NOT NULL,
	[FatherName] [nvarchar](128) NOT NULL,
	[NationalCode] [nvarchar](10) NOT NULL,
	[IssuePlace] [nvarchar](128) NOT NULL,
	[Job] [nvarchar](128) NOT NULL,
	[SharePercentage] [real] NOT NULL,
	[ResidenceAddress] [nvarchar](256) NOT NULL,
	[ResidencePostalCode] [nvarchar](15) NULL,
	[WorkAddress] [nvarchar](256) NULL,
	[Phone] [nvarchar](20) NULL,
	[Mobile] [nvarchar](20) NOT NULL,
	[IsMainOwner] [bit] NOT NULL,
	[OwnerTypeId] [int] NOT NULL,
	[OtherOwnerType] [nvarchar](256) NULL,
	[UserId] [uniqueidentifier] NULL,
	[AttorneyNumber] [nvarchar](20) NULL,
	[BirthDate] [datetime2](7) NOT NULL,
	[IdNumber] [nvarchar](20) NOT NULL,
	[ChangeDate] [datetime2](7) NULL,
	[IsCahnged] [bit] NOT NULL,
	[IsMainPossessor] [bit] NOT NULL,
	[SanaCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_Owners] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwSupervisorContractTempDossier]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwSupervisorContractTempDossier]
AS
SELECT        TOP (100) PERCENT cedo.ConstructionLicenses.Id, cedo.DossierType.Title, cedo.ConstructionLicenses.DossierNumber, cedo.ConstructionLicenses.DossierSerial, cedo.Estates.Code, cedo.Cities.Name, 
                         cedo.ConstructionLicenses.StepId, cedo.ConstructionLicenses.StatusId, cedo.Municipalities.Title AS Expr1, cedo.OwnershipDocumentTypes.Title AS Expr2, cedo.Owners.FirstName, cedo.Owners.LastName, 
                         cedo.Owners.NationalCode, cedo.Owners.IsMainPossessor
FROM            cedo.ConstructionLicenses INNER JOIN
                         cedo.Estates ON cedo.ConstructionLicenses.EstateId = cedo.Estates.Id INNER JOIN
                         cedo.Municipalities ON cedo.Estates.MunicipalityId = cedo.Municipalities.Id INNER JOIN
                         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id INNER JOIN
                         cedo.DossierType ON cedo.ConstructionLicenses.DossierTypeId = cedo.DossierType.Id INNER JOIN
                         cedo.OwnershipDocumentTypes ON cedo.Estates.OwnershipDocumentTypeId = cedo.OwnershipDocumentTypes.Id LEFT OUTER JOIN
                         cedo.Owners ON cedo.ConstructionLicenses.Id = cedo.Owners.ConstructionLicenseId
WHERE        (cedo.ConstructionLicenses.StepId > 24) AND (cedo.ConstructionLicenses.StepId < 32) AND (cedo.ConstructionLicenses.StatusId = 1) AND (cedo.Owners.IsMainPossessor = 1)
ORDER BY cedo.Cities.Name
GO
/****** Object:  View [dbo].[StepPendings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[StepPendings]
AS
SELECT        dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, dbo.FlowSteps.StatusId, dbo.FlowSteps.OwnerId
FROM            dbo.FlowSteps INNER JOIN
                         dbo.[PARA-Users] ON dbo.FlowSteps.OwnerId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id
WHERE        (dbo.FlowSteps.StatusId = 1)
GO
/****** Object:  Table [dbo].[TimerTicks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimerTicks](
	[Id] [int] NOT NULL,
	[InvokeAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_TimerTicks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InstanceUserGroups]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstanceUserGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_InstanceUserGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwPendingTimers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPendingTimers]
AS
SELECT        TOP (100) PERCENT dbo.TimerTicks.InvokeAt, dbo.FlowSteps.StatusId, dbo.FlowInstances.StatusId AS InstanceStatus, dbo.FlowInstances.TrackCode, dbo.Flows.Name, FlowInstances_1.ParentInstanceId, 
                         FlowInstances_1.StatusId AS RootInstanceStatus
FROM            dbo.TimerTicks INNER JOIN
                         dbo.FlowSteps ON dbo.TimerTicks.Id = dbo.FlowSteps.Id INNER JOIN
                         dbo.FlowInstances ON dbo.FlowSteps.FlowInstanceId = dbo.FlowInstances.Id INNER JOIN
                         dbo.FlowVersions ON dbo.FlowInstances.FlowVersionId = dbo.FlowVersions.Id INNER JOIN
                         dbo.Flows ON dbo.FlowVersions.FlowId = dbo.Flows.Id INNER JOIN
                         dbo.InstanceUserGroups ON dbo.FlowInstances.UserGroupId = dbo.InstanceUserGroups.Id INNER JOIN
                         dbo.FlowInstances AS FlowInstances_1 ON dbo.InstanceUserGroups.Id = FlowInstances_1.UserGroupId
WHERE        (dbo.FlowInstances.StatusId = 1) AND (FlowInstances_1.ParentInstanceId IS NULL) AND (dbo.FlowSteps.StatusId = 1) AND (dbo.TimerTicks.InvokeAt > DATEADD(day, - 10, GETDATE())) AND (dbo.TimerTicks.InvokeAt < GETDATE())
ORDER BY dbo.TimerTicks.InvokeAt DESC
GO
/****** Object:  Table [cedo].[Attendees]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Attendees](
	[Id] [uniqueidentifier] NOT NULL,
	[HoldingLessonId] [uniqueidentifier] NOT NULL,
	[StatusId] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[Score] [real] NULL,
	[ScoreDate] [datetime2](7) NULL,
	[CourseHoldingMemberId] [uniqueidentifier] NOT NULL,
	[ReScore] [real] NULL,
	[ReScoreDate] [datetime2](7) NULL,
	[test] [nvarchar](max) NULL,
 CONSTRAINT [PK_Attendees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseHoldingMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseHoldingMembers](
	[Id] [uniqueidentifier] NOT NULL,
	[CourseHoldingId] [uniqueidentifier] NULL,
	[MemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_CourseHoldingMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[deleted_attendees]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[deleted_attendees]
AS
SELECT        cedo.CourseHoldingMembers.MemberId, cedo.Attendees.StatusId, cedo.PaymentReceipts.PaymentStatusId, dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, cedo.Members.MembershipCode, 
                         cedo.CourseHoldingMembers.CourseHoldingId, cedo.CourseHoldingMembers.Id AS HoldingMemberId, cedo.PaymentReceipts.Amount
FROM            cedo.CourseHoldingMembers INNER JOIN
                         cedo.Bills ON cedo.CourseHoldingMembers.Id = cedo.Bills.CourseHoldingMemberId AND cedo.CourseHoldingMembers.Id = cedo.Bills.CourseHoldingMemberId INNER JOIN
                         cedo.PaymentReceipts ON cedo.Bills.Id = cedo.PaymentReceipts.BillId AND cedo.Bills.Id = cedo.PaymentReceipts.BillId AND cedo.Bills.Id = cedo.PaymentReceipts.BillId INNER JOIN
                         cedo.Members ON cedo.CourseHoldingMembers.MemberId = cedo.Members.Id AND cedo.CourseHoldingMembers.MemberId = cedo.Members.Id AND cedo.CourseHoldingMembers.MemberId = cedo.Members.Id INNER JOIN
                         dbo.[PARA-Users] ON cedo.Members.UserId = dbo.[PARA-Users].Id AND cedo.Members.UserId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND 
                         dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id LEFT OUTER JOIN
                         cedo.Attendees ON cedo.CourseHoldingMembers.Id = cedo.Attendees.CourseHoldingMemberId
WHERE        (cedo.Attendees.StatusId IS NULL) AND (cedo.PaymentReceipts.PaymentStatusId = 2)
GO
/****** Object:  Table [cedo].[MemberCapacityDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberCapacityDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberServiceId] [int] NOT NULL,
	[WorkItem] [real] NOT NULL,
	[Metraj] [real] NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[Released] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[BuildingSubGroupId] [int] NOT NULL,
	[InvolvedMemberId] [int] NULL,
	[QuotaYear] [int] NULL,
	[Type] [int] NOT NULL,
 CONSTRAINT [PK_MemberCapacityDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwMemberCapacityDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwMemberCapacityDetails]
AS
SELECT        TOP (100) PERCENT cedo.MemberCapacityDetails.WorkItem, cedo.MemberCapacityDetails.Metraj, cedo.MemberCapacityDetails.Released, cedo.MemberCapacityDetails.QuotaYear, cedo.ServiceTypes.Title AS Service, 
                         cedo.ServiceFields.Title AS Field, cedo.MemberCapacityDetails.Description, cedo.MemberCapacityDetails.RegDate
FROM            cedo.MemberCapacityDetails INNER JOIN
                         cedo.MemberServices ON cedo.MemberCapacityDetails.MemberServiceId = cedo.MemberServices.Id INNER JOIN
                         cedo.ServiceTypes ON cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id INNER JOIN
                         cedo.ServiceFields ON cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id INNER JOIN
                         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
                         cedo.Members ON cedo.ActivityLicenses.MemberId = cedo.Members.Id
WHERE        (cedo.Members.Id = 6)
ORDER BY cedo.MemberCapacityDetails.RegDate DESC
GO
/****** Object:  View [dbo].[vwCapacity]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwCapacity]
AS
SELECT        TOP (100) PERCENT cedo.ActivityLicenses.MemberId, cedo.ServiceTypes.Title, cedo.InvolvedMembers.WorkItem, cedo.InvolvedMembers.Metraje, cedo.InvolvedMembers.QuotaYear, 
                         cedo.InvolvedMemberStatuses.Title AS Status, cedo.InvolvedMembers.Id, cedo.InvolvedMembers.ConstructionLicenseId
FROM            cedo.InvolvedMembers INNER JOIN
                         cedo.MemberServices ON cedo.InvolvedMembers.MemberServiceId = cedo.MemberServices.Id INNER JOIN
                         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
                         cedo.ServiceTypes ON cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id INNER JOIN
                         cedo.InvolvedMemberStatuses ON cedo.InvolvedMembers.StatusId = cedo.InvolvedMemberStatuses.Id
WHERE        (cedo.ActivityLicenses.MemberId = 6)
ORDER BY cedo.ServiceTypes.Title, cedo.InvolvedMembers.QuotaYear
GO
/****** Object:  View [dbo].[vwHistoryCapacity]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwHistoryCapacity]
AS
SELECT        TOP (100) PERCENT cedo.ActivityLicenses.MemberId, cedo.ServiceTypes.Title, cedo.MemberCapacityDetails.WorkItem, cedo.MemberCapacityDetails.Metraj, cedo.MemberCapacityDetails.QuotaYear, 
                         cedo.MemberCapacityDetails.InvolvedMemberId, cedo.MemberCapacityDetails.Description
FROM            cedo.MemberCapacityDetails INNER JOIN
                         cedo.MemberServices ON cedo.MemberCapacityDetails.MemberServiceId = cedo.MemberServices.Id INNER JOIN
                         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
                         cedo.ServiceTypes ON cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id
WHERE        (cedo.ActivityLicenses.MemberId = 6)
ORDER BY cedo.ServiceTypes.Title, cedo.MemberCapacityDetails.QuotaYear
GO
/****** Object:  Table [cedo].[Operators]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Operators](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OperatorTypeId] [int] NOT NULL,
	[CityId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Operators] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[UserDelegations]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[UserDelegations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DelegateSenderId] [uniqueidentifier] NOT NULL,
	[DelegateRecieverId] [uniqueidentifier] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_UserDelegations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OperatorTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OperatorTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_OperatorTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwOperator]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwOperator]
AS
SELECT cedo.OperatorTypes.Title, cedo.Cities.Name, cedo.UserDelegations.DelegateSenderId, cedo.UserDelegations.DelegateRecieverId, OperatorTypes_1.Title AS Expr1, cedo.OperatorTypes.Value
FROM  cedo.UserDelegations INNER JOIN
         cedo.Operators ON cedo.UserDelegations.DelegateSenderId = cedo.Operators.UserId INNER JOIN
         cedo.Cities ON cedo.Operators.CityId = cedo.Cities.Id INNER JOIN
         cedo.OperatorTypes ON cedo.Operators.OperatorTypeId = cedo.OperatorTypes.Id INNER JOIN
         cedo.Operators AS Operators_1 ON cedo.UserDelegations.DelegateRecieverId = Operators_1.UserId INNER JOIN
         cedo.OperatorTypes AS OperatorTypes_1 ON Operators_1.OperatorTypeId = OperatorTypes_1.Id
WHERE (cedo.Cities.Name = N'ارومیه')
GO
/****** Object:  View [dbo].[checkUser]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[checkUser]
AS
SELECT        TOP (100) PERCENT dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, dbo.UserProfiles.Father, dbo.UserProfiles.NationalCode, cedo.Members.MembershipCode, cedo.Members.IsActive, 
                         dbo.[PARA-Users].PhoneNumber
FROM            cedo.Members INNER JOIN
                         dbo.[PARA-Users] ON cedo.Members.UserId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id
WHERE        (cedo.Members.IsActive = 1)
ORDER BY dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, dbo.UserProfiles.Father
GO
/****** Object:  Table [cedo].[LicenseInqueries]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[LicenseInqueries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MunicipalityId] [int] NOT NULL,
	[Code] [nvarchar](128) NOT NULL,
	[LicenseNumber] [nvarchar](128) NOT NULL,
	[NationalCode] [nvarchar](10) NOT NULL,
	[LicenseInqueryStatusId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DossierTypeId] [int] NOT NULL,
	[OwnerFullName] [nvarchar](128) NOT NULL,
	[ConfirmDate] [datetime2](7) NULL,
	[RegDate] [datetime2](7) NULL,
	[RefNumber] [nvarchar](max) NULL,
	[IsShahrdariService] [bit] NOT NULL,
 CONSTRAINT [PK_LicenseInqueries] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwLicenseInqueries]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwLicenseInqueries]
AS
SELECT        TOP (100) PERCENT cedo.Municipalities.CityId, cedo.Municipalities.Title, cedo.LicenseInqueries.Id, cedo.LicenseInqueries.IsShahrdariService, cedo.LicenseInqueries.RefNumber, cedo.LicenseInqueries.RegDate, 
                         cedo.LicenseInqueries.Code, cedo.LicenseInqueries.LicenseNumber, cedo.LicenseInqueries.NationalCode, cedo.LicenseInqueries.OwnerFullName
FROM            cedo.LicenseInqueries INNER JOIN
                         cedo.Municipalities ON cedo.LicenseInqueries.MunicipalityId = cedo.Municipalities.Id INNER JOIN
                         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id
WHERE        (cedo.Municipalities.CityId = 3) AND (cedo.LicenseInqueries.RegDate > CONVERT(DATETIME, '2022-06-01 00:00:00', 102)) AND (cedo.LicenseInqueries.IsShahrdariService = 1)
ORDER BY cedo.LicenseInqueries.Id DESC
GO
/****** Object:  View [dbo].[DocumentFinder]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DocumentFinder]
AS
SELECT cedo.ConstructionLicenses.DossierNumber, cedo.ConstructionLicenseDocuments.Id, cedo.ConstructionLicenseDocuments.ConstructionLicenseId, cedo.ConstructionLicenseDocuments.DocumentTypeId, cedo.ConstructionLicenseDocuments.Description, cedo.ConstructionLicenseDocuments.RegDate, cedo.DocumentTypes.Title
FROM  cedo.ConstructionLicenseDocuments INNER JOIN
         cedo.ConstructionLicenses ON cedo.ConstructionLicenseDocuments.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
         cedo.DocumentTypes ON cedo.ConstructionLicenseDocuments.DocumentTypeId = cedo.DocumentTypes.Id
WHERE (cedo.ConstructionLicenses.DossierNumber = N'54360')
GO
/****** Object:  Table [dbo].[FlowStepStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowStepStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FlowStepStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowNodes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowNodes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Code] [int] NULL,
	[ShowInStepsList] [bit] NOT NULL,
	[NodeTypeId] [int] NOT NULL,
	[DiagramLayoutX] [int] NOT NULL,
	[DiagramLayoutY] [int] NOT NULL,
	[DiagramLayoutWidth] [int] NOT NULL,
	[DiagramLayoutHeight] [int] NOT NULL,
	[FlowVersionId] [int] NOT NULL,
	[LastChanged] [datetime2](7) NULL,
	[ActorId] [uniqueidentifier] NULL,
	[ForwardScriptCode] [nvarchar](max) NULL,
 CONSTRAINT [PK_FlowNodes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwPendingSteps]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPendingSteps]
AS
SELECT        dbo.FlowNodes.UniqueId, dbo.FlowNodes.Name, dbo.FlowNodes.Id, dbo.FlowNodes.Code, dbo.FlowNodes.ActorId, dbo.FlowSteps.StatusId, dbo.FlowSteps.OwnerId, dbo.FlowStepStatuses.Title, dbo.UserProfiles.FirstName, 
                         dbo.UserProfiles.LastName
FROM            dbo.FlowNodes INNER JOIN
                         dbo.FlowSteps ON dbo.FlowNodes.Id = dbo.FlowSteps.FlowNodeId INNER JOIN
                         dbo.FlowStepStatuses ON dbo.FlowSteps.StatusId = dbo.FlowStepStatuses.Id INNER JOIN
                         dbo.[PARA-Users] ON dbo.FlowSteps.OwnerId = dbo.[PARA-Users].Id INNER JOIN
                         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id
WHERE        (dbo.FlowNodes.UniqueId = '1e6c955c-e09b-4ff7-8f0f-cd11f8807c9f') AND (dbo.FlowSteps.StatusId <> 2)
GO
/****** Object:  Table [cedo].[SupervisionSteps]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionSteps](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FieldId] [int] NOT NULL,
	[Title] [nvarchar](512) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Order] [int] NOT NULL,
	[CoordinatorPaymentPercent] [int] NOT NULL,
	[SupervisorPaymentPercent] [int] NOT NULL,
	[FormNumber] [int] NOT NULL,
 CONSTRAINT [PK_SupervisionSteps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionStepForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionStepForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[StepId] [int] NOT NULL,
	[ContradictionDescription] [nvarchar](max) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[FloorNumber] [int] NULL,
	[IsCopy] [bit] NOT NULL,
 CONSTRAINT [PK_SupervisionStepForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionStepItemGroups]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionStepItemGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SupervisionStepId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[Title] [nvarchar](512) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_SupervisionStepItemGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionStepItems]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionStepItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NOT NULL,
	[Title] [nvarchar](512) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_SupervisionStepItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwStepFoms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwStepFoms]
AS
SELECT cedo.SupervisionStepForms.Id, cedo.SupervisionStepForms.InvolvedMemberId, cedo.SupervisionStepForms.StepId, cedo.SupervisionStepForms.FloorNumber, cedo.ServiceFields.Title, cedo.ServiceTypes.Title AS Expr1, cedo.SupervisionStepItemGroups.Title AS Expr2, cedo.SupervisionSteps.Title AS Expr3, cedo.SupervisionStepItems.Title AS Expr4, cedo.ConstructionLicenses.DossierNumber, cedo.SupervisionStepItems.Id AS Expr5
FROM  cedo.SupervisionStepForms INNER JOIN
         cedo.InvolvedMembers ON cedo.SupervisionStepForms.InvolvedMemberId = cedo.InvolvedMembers.Id INNER JOIN
         cedo.MemberServices ON cedo.InvolvedMembers.MemberServiceId = cedo.MemberServices.Id INNER JOIN
         cedo.ServiceFields ON cedo.MemberServices.ServiceFieldId = cedo.ServiceFields.Id INNER JOIN
         cedo.ServiceTypes ON cedo.MemberServices.ServiceTypeId = cedo.ServiceTypes.Id INNER JOIN
         cedo.SupervisionSteps ON cedo.SupervisionStepForms.StepId = cedo.SupervisionSteps.Id INNER JOIN
         cedo.SupervisionStepItemGroups ON cedo.SupervisionSteps.Id = cedo.SupervisionStepItemGroups.SupervisionStepId INNER JOIN
         cedo.SupervisionStepItems ON cedo.SupervisionStepItemGroups.Id = cedo.SupervisionStepItems.GroupId INNER JOIN
         cedo.ConstructionLicenses ON cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id
WHERE (cedo.SupervisionStepForms.InvolvedMemberId = 3785) AND (cedo.SupervisionStepForms.Id = 375) AND (cedo.ConstructionLicenses.DossierNumber = N'54523') AND (cedo.SupervisionStepItems.Id = 2508) AND (cedo.SupervisionStepItems.Title LIKE N'%درز انقطاع در اجراي ستون و تير هاي پيراموني انجام گرفته است. %')
GO
/****** Object:  View [dbo].[Operators]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Operators]
AS
SELECT cedo.OperatorTypes.Title, dbo.[PARA-Users].UserName, cedo.OperatorTypes.Value, cedo.Cities.Name, dbo.[PARA-Users].Id
FROM  cedo.Operators AS Operators_1 INNER JOIN
         cedo.OperatorTypes ON Operators_1.OperatorTypeId = cedo.OperatorTypes.Id INNER JOIN
         dbo.[PARA-Users] ON Operators_1.UserId = dbo.[PARA-Users].Id INNER JOIN
         cedo.Cities ON Operators_1.CityId = cedo.Cities.Id
GO
/****** Object:  View [dbo].[vwUserDeligation]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwUserDeligation]
AS
SELECT cedo.Operators.UserId, cedo.OperatorTypes.Title, cedo.OperatorTypes.Value, cedo.Cities.Name, dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName
FROM  cedo.Operators INNER JOIN
         cedo.OperatorTypes ON cedo.Operators.OperatorTypeId = cedo.OperatorTypes.Id INNER JOIN
         cedo.Cities ON cedo.Operators.CityId = cedo.Cities.Id INNER JOIN
         dbo.[PARA-Users] ON cedo.Operators.UserId = dbo.[PARA-Users].Id INNER JOIN
         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id
WHERE (cedo.Operators.UserId = 'b12e7414-afca-4b24-a8e6-334ae42c5168')
GO
/****** Object:  View [dbo].[ConstructionLicenseArea]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ConstructionLicenseArea]
AS
SELECT ConstructionLicenseId, SUM(SumArea) AS SumArea
FROM  (SELECT cedo.BuildingUnits.FloorId, SUM(cedo.BuildingUnits.Area) AS SumArea, cedo.Floors.ConstructionLicenseId
        FROM   cedo.BuildingUnits INNER JOIN
                 cedo.Floors ON cedo.BuildingUnits.FloorId = cedo.Floors.Id
        GROUP BY cedo.BuildingUnits.FloorId, cedo.Floors.ConstructionLicenseId) AS derivedtbl_1
GROUP BY ConstructionLicenseId
GO
/****** Object:  View [dbo].[vwWorkItemsSync]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwWorkItemsSync]
AS
SELECT cedo.InvolvedMembers.WorkItem, cedo.ConstructionLicenses.DossierNumber, cedo.MemberServices.ServiceTypeId, cedo.LegalMembers.LegalMemberTypeId, cedo.Members.SyncCode, cedo.MemberServices.ServiceFieldId, dbo.ConstructionLicenseArea.SumArea, cedo.Cities.SyncCode AS CitySyncCode
FROM  cedo.InvolvedMembers INNER JOIN
         cedo.ConstructionLicenses ON cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
         cedo.MemberServices ON cedo.InvolvedMembers.MemberServiceId = cedo.MemberServices.Id INNER JOIN
         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
         cedo.Members ON cedo.ActivityLicenses.MemberId = cedo.Members.Id INNER JOIN
         cedo.Estates ON cedo.ConstructionLicenses.EstateId = cedo.Estates.Id AND cedo.ConstructionLicenses.EstateId = cedo.Estates.Id INNER JOIN
         cedo.Municipalities ON cedo.Estates.MunicipalityId = cedo.Municipalities.Id INNER JOIN
         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id LEFT OUTER JOIN
         dbo.ConstructionLicenseArea ON cedo.ConstructionLicenses.Id = dbo.ConstructionLicenseArea.ConstructionLicenseId LEFT OUTER JOIN
         cedo.LegalMembers ON cedo.Members.Id = cedo.LegalMembers.Id
WHERE (cedo.InvolvedMembers.StatusId = 2 OR
         cedo.InvolvedMembers.StatusId = 4) AND (cedo.MemberServices.ServiceTypeId = 2 OR
         cedo.MemberServices.ServiceTypeId = 5 OR
         cedo.MemberServices.ServiceTypeId = 4 OR
         cedo.MemberServices.ServiceTypeId = 7)
GO
/****** Object:  Table [cedo].[MemberCapacities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberCapacities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[TotalMetraj] [real] NOT NULL,
	[RemainingMetraj] [real] NOT NULL,
	[RemainingWorkItem] [real] NOT NULL,
	[TotalWorkItem] [real] NOT NULL,
	[FieldId] [int] NULL,
	[LastSync] [datetime2](7) NOT NULL,
	[CityId] [int] NOT NULL,
	[MaxConcurrent] [int] NULL,
	[ServiceTypeId] [int] NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_MemberCapacities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwCapacityDetail]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCapacityDetail]
AS
SELECT TOP (100) PERCENT dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, cedo.Members.Id AS Expr1, cedo.MemberCapacities.Id, cedo.MemberCapacities.MemberId, cedo.MemberCapacities.TotalMetraj, cedo.MemberCapacities.RemainingMetraj, cedo.MemberCapacities.RemainingWorkItem, cedo.MemberCapacities.TotalWorkItem, cedo.MemberCapacities.FieldId, cedo.MemberCapacities.LastSync, cedo.MemberCapacities.CityId, 
         cedo.MemberCapacities.MaxConcurrent
FROM  cedo.MemberCapacities INNER JOIN
         cedo.Members ON cedo.MemberCapacities.MemberId = cedo.Members.Id INNER JOIN
         dbo.[PARA-Users] ON cedo.Members.UserId = dbo.[PARA-Users].Id AND cedo.Members.UserId = dbo.[PARA-Users].Id INNER JOIN
         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND 
         dbo.[PARA-Users].Id = dbo.UserProfiles.Id
WHERE (cedo.Members.Id = 20946)
ORDER BY cedo.MemberCapacities.Id DESC
GO
/****** Object:  Table [cedo].[ConstructionLicenseStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ConstructionLicenseStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ConstructionLicenseSteps]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseSteps](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ConstructionLicenseSteps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwContractDossiers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwContractDossiers]
AS
SELECT cedo.ConstructionLicenses.Id, cedo.ConstructionLicenses.EstateId, cedo.ConstructionLicenses.LicenseNumber, cedo.ConstructionLicenses.DossierNumber, cedo.ConstructionLicenses.StatusId, cedo.ConstructionLicenses.StepId, cedo.ConstructionLicenses.DossierSerial, cedo.ConstructionLicenseSteps.Title, cedo.ConstructionLicenseStatuses.Title AS Expr1, cedo.Estates.Code, cedo.Municipalities.Title AS Expr2, cedo.Cities.Name, cedo.Estates.OwnershipDocumentTypeId, 
         cedo.OwnershipDocumentTypes.Title AS Expr3
FROM  cedo.ConstructionLicenses INNER JOIN
         cedo.ConstructionLicenseSteps ON cedo.ConstructionLicenses.StepId = cedo.ConstructionLicenseSteps.Id AND cedo.ConstructionLicenses.StepId = cedo.ConstructionLicenseSteps.Id AND cedo.ConstructionLicenses.StepId = cedo.ConstructionLicenseSteps.Id INNER JOIN
         cedo.ConstructionLicenseStatuses ON cedo.ConstructionLicenses.StatusId = cedo.ConstructionLicenseStatuses.Id AND cedo.ConstructionLicenses.StatusId = cedo.ConstructionLicenseStatuses.Id AND cedo.ConstructionLicenses.StatusId = cedo.ConstructionLicenseStatuses.Id INNER JOIN
         cedo.Estates ON cedo.ConstructionLicenses.EstateId = cedo.Estates.Id AND cedo.ConstructionLicenses.EstateId = cedo.Estates.Id AND cedo.ConstructionLicenses.EstateId = cedo.Estates.Id INNER JOIN
         cedo.Municipalities ON cedo.Estates.MunicipalityId = cedo.Municipalities.Id AND cedo.Estates.MunicipalityId = cedo.Municipalities.Id AND cedo.Estates.MunicipalityId = cedo.Municipalities.Id INNER JOIN
         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id AND cedo.Municipalities.CityId = cedo.Cities.Id AND cedo.Municipalities.CityId = cedo.Cities.Id INNER JOIN
         cedo.OwnershipDocumentTypes ON cedo.Estates.OwnershipDocumentTypeId = cedo.OwnershipDocumentTypes.Id AND cedo.Estates.OwnershipDocumentTypeId = cedo.OwnershipDocumentTypes.Id AND cedo.Estates.OwnershipDocumentTypeId = cedo.OwnershipDocumentTypes.Id
WHERE (cedo.ConstructionLicenses.StatusId = 1) AND (cedo.Estates.OwnershipDocumentTypeId = 2) AND (cedo.ConstructionLicenses.StepId < 32)
GO
/****** Object:  Table [cedo].[CapacityCalculations]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CapacityCalculations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BuildingGroupSettingId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[ServiceFieldId] [int] NULL,
	[WorkItem] [float] NOT NULL,
	[MaxWorkItem] [int] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_CapacityCalculations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwCapacityCalculationsB200]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCapacityCalculationsB200]
AS
SELECT cedo.CapacityCalculations.Id, cedo.CapacityCalculations.BuildingGroupSettingId, cedo.CapacityCalculations.ServiceTypeId, cedo.CapacityCalculations.ServiceFieldId, cedo.CapacityCalculations.WorkItem, cedo.CapacityCalculations.MetrajRatio, cedo.CapacityCalculations.MaxWorkItem, cedo.CapacityCalculations.[Order], cedo.ServiceTypes.Title, cedo.ServiceFields.Title AS Expr1, cedo.BuildingGroupSettings.Title AS Expr2
FROM  cedo.CapacityCalculations INNER JOIN
         cedo.ServiceTypes ON cedo.CapacityCalculations.ServiceTypeId = cedo.ServiceTypes.Id INNER JOIN
         cedo.ServiceFields ON cedo.CapacityCalculations.ServiceFieldId = cedo.ServiceFields.Id INNER JOIN
         cedo.BuildingGroupSettings ON cedo.CapacityCalculations.BuildingGroupSettingId = cedo.BuildingGroupSettings.Id
WHERE (cedo.BuildingGroupSettings.Title = N'ب زیر 200 متر') AND (cedo.ServiceFields.Title <> N'سازه') AND (cedo.CapacityCalculations.[Order] = 30) AND (cedo.ServiceTypes.Title = N'ناظر')
GO
/****** Object:  Table [cedo].[BuildingCertificates]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingCertificates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[ConstructionLicenseTypeId] [int] NOT NULL,
	[BuildingCertificateNo] [nvarchar](128) NOT NULL,
	[DossierNo] [nvarchar](128) NULL,
	[IssuedDate] [datetime2](7) NOT NULL,
	[ValidityDuration] [int] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[ViolationPrivacy] [float] NULL,
 CONSTRAINT [PK_BuildingCertificates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwNotReleased]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwNotReleased]
AS
SELECT cedo.ConstructionLicenses.Id, cedo.ConstructionLicenses.LicenseNumber, cedo.ConstructionLicenses.DossierNumber, cedo.ConstructionLicenses.StatusId, cedo.ConstructionLicenses.StepId, cedo.ConstructionLicenses.IsReleased, cedo.ConstructionLicenses.DossierSerial, cedo.Cities.Name, cedo.ConstructionLicenseSteps.Title, cedo.ConstructionLicenseStatuses.Title AS Expr1
FROM  cedo.ConstructionLicenses INNER JOIN
         cedo.ConstructionLicenseStatuses ON cedo.ConstructionLicenses.StatusId = cedo.ConstructionLicenseStatuses.Id INNER JOIN
         cedo.ConstructionLicenseSteps ON cedo.ConstructionLicenses.StepId = cedo.ConstructionLicenseSteps.Id INNER JOIN
         cedo.Estates ON cedo.ConstructionLicenses.EstateId = cedo.Estates.Id INNER JOIN
         cedo.Municipalities ON cedo.Estates.MunicipalityId = cedo.Municipalities.Id INNER JOIN
         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id
WHERE (cedo.ConstructionLicenses.IsReleased IS NULL OR
         cedo.ConstructionLicenses.IsReleased = 0) AND (cedo.ConstructionLicenses.DossierSerial IS NULL OR
         cedo.ConstructionLicenses.DossierSerial LIKE '%-1401-%') AND (cedo.ConstructionLicenses.StatusId = 1) AND (cedo.ConstructionLicenses.Id NOT IN
             (SELECT ConstructionLicenseId
           FROM   cedo.BuildingCertificates))
GO
/****** Object:  View [dbo].[Duplicated-Members]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Duplicated-Members]
AS
SELECT   UserId, COUNT(*) AS count
FROM         cedo.Members
GROUP BY UserId
HAVING   (COUNT(*) > 1)
GO
/****** Object:  View [dbo].[vwNeedExecuterDossiers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwNeedExecuterDossiers]
AS
SELECT        cedo.ConstructionLicenses.Id, cedo.ConstructionLicenses.DossierNumber, cedo.BuildingGroupSettings.NeedsExecuter, cedo.Cities.Name
FROM            cedo.ConstructionLicenses INNER JOIN
                         cedo.Estates ON cedo.ConstructionLicenses.EstateId = cedo.Estates.Id INNER JOIN
                         cedo.Municipalities ON cedo.Estates.MunicipalityId = cedo.Municipalities.Id INNER JOIN
                         cedo.Cities ON cedo.Municipalities.CityId = cedo.Cities.Id INNER JOIN
                         cedo.BuildingGroupSettings ON cedo.ConstructionLicenses.BuildingGroupSettingId = cedo.BuildingGroupSettings.Id
WHERE        (cedo.BuildingGroupSettings.NeedsExecuter = 1)
GO
/****** Object:  View [dbo].[AcceptedPlanControls]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AcceptedPlanControls]
AS
SELECT cedo.ConstructionLicenses.Id, dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, cedo.ConstructionLicenses.DossierNumber, cedo.PlanControls.RegDate, cedo.PlanControls.InvolvedMemberId
FROM  cedo.InvolvedMembers INNER JOIN
         cedo.MemberServices ON cedo.InvolvedMembers.MemberServiceId = cedo.MemberServices.Id INNER JOIN
         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
         cedo.Members ON cedo.ActivityLicenses.MemberId = cedo.Members.Id INNER JOIN
         dbo.[PARA-Users] ON cedo.Members.UserId = dbo.[PARA-Users].Id INNER JOIN
         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id INNER JOIN
         cedo.ConstructionLicenses ON cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
         cedo.PlanControls ON cedo.InvolvedMembers.Id = cedo.PlanControls.InvolvedMemberId
WHERE (cedo.MemberServices.ServiceTypeId = 3) AND (cedo.PlanControls.PlanControlStatusId = 3) AND (cedo.MemberServices.ServiceFieldId = 3 OR
         cedo.MemberServices.ServiceFieldId = 4 OR
         cedo.MemberServices.ServiceFieldId = 5)
GO
/****** Object:  View [dbo].[RejectedPlanControls]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RejectedPlanControls]
AS
SELECT TOP (100) PERCENT cedo.ConstructionLicenses.Id, dbo.UserProfiles.FirstName, dbo.UserProfiles.LastName, cedo.ConstructionLicenses.DossierNumber, cedo.PlanControls.RegDate, cedo.PlanControls.InvolvedMemberId
FROM  cedo.InvolvedMembers INNER JOIN
         cedo.MemberServices ON cedo.InvolvedMembers.MemberServiceId = cedo.MemberServices.Id INNER JOIN
         cedo.ActivityLicenses ON cedo.MemberServices.ActivityLicenseId = cedo.ActivityLicenses.Id INNER JOIN
         cedo.Members ON cedo.ActivityLicenses.MemberId = cedo.Members.Id INNER JOIN
         dbo.[PARA-Users] ON cedo.Members.UserId = dbo.[PARA-Users].Id INNER JOIN
         dbo.UserProfiles ON dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id AND dbo.[PARA-Users].Id = dbo.UserProfiles.Id INNER JOIN
         cedo.ConstructionLicenses ON cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id AND cedo.InvolvedMembers.ConstructionLicenseId = cedo.ConstructionLicenses.Id INNER JOIN
         cedo.PlanControls ON cedo.InvolvedMembers.Id = cedo.PlanControls.InvolvedMemberId
WHERE (cedo.MemberServices.ServiceTypeId = 3) AND (cedo.PlanControls.PlanControlStatusId = 2) AND (cedo.MemberServices.ServiceFieldId = 3 OR
         cedo.MemberServices.ServiceFieldId = 4 OR
         cedo.MemberServices.ServiceFieldId = 5) AND (cedo.PlanControls.InvolvedMemberId NOT IN
             (SELECT InvolvedMemberId
           FROM   dbo.AcceptedPlanControls
           WHERE  (InvolvedMemberId = cedo.PlanControls.InvolvedMemberId) AND (Id = cedo.ConstructionLicenses.Id)))
GO
/****** Object:  View [dbo].[RejectedPlanControlsWithArea]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RejectedPlanControlsWithArea]
AS
SELECT dbo.ConstructionLicenseArea.ConstructionLicenseId, dbo.RejectedPlanControls.FirstName, dbo.RejectedPlanControls.LastName, dbo.RejectedPlanControls.DossierNumber, dbo.ConstructionLicenseArea.SumArea, dbo.RejectedPlanControls.RegDate
FROM  dbo.RejectedPlanControls INNER JOIN
         dbo.ConstructionLicenseArea ON dbo.RejectedPlanControls.Id = dbo.ConstructionLicenseArea.ConstructionLicenseId
GO
/****** Object:  Table [cedo].[ActivityTransferRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ActivityTransferRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[CityId] [int] NULL,
	[RequestDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[DestinationAddress] [nvarchar](128) NULL,
	[DestinationTell] [nvarchar](32) NULL,
	[Workplace] [nvarchar](128) NULL,
	[WorkplaceTell] [nvarchar](32) NULL,
	[StatusId] [int] NOT NULL,
 CONSTRAINT [PK_ActivityTransferRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ActivityTransferRequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ActivityTransferRequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ActivityTransferRequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[AdditionalSupervisionFields]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[AdditionalSupervisionFields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SupervisionFieldId] [uniqueidentifier] NOT NULL,
	[FieldId] [int] NOT NULL,
 CONSTRAINT [PK_AdditionalSupervisionFields] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ArchitectureExecutiveOperationsForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ArchitectureExecutiveOperationsForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Item12] [bit] NOT NULL,
	[Item13] [bit] NOT NULL,
	[Item14] [bit] NOT NULL,
	[Item15] [bit] NOT NULL,
	[Item16] [bit] NOT NULL,
	[Item17] [bit] NOT NULL,
	[Item18] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ArchitectureExecutiveOperationsForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ArchitecturePlanControlForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ArchitecturePlanControlForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Item12] [bit] NOT NULL,
	[Item13] [bit] NOT NULL,
	[Item14] [bit] NOT NULL,
	[Item15] [bit] NOT NULL,
	[Item16] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ArchitecturePlanControlForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ArchitectureRedLinesForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ArchitectureRedLinesForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
 CONSTRAINT [PK_ArchitectureRedLinesForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ArchitectureSafetyForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ArchitectureSafetyForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[InvolvedMemberId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Item1] [bit] NULL,
	[Item2] [bit] NULL,
	[Item3] [bit] NULL,
	[Item4] [bit] NULL,
	[Item5] [bit] NULL,
	[Item6] [bit] NULL,
	[Item7] [bit] NULL,
	[Item8] [bit] NULL,
	[Item9] [bit] NULL,
	[Item10] [bit] NULL,
	[Item11] [bit] NULL,
	[Item12] [bit] NULL,
	[Item13] [bit] NULL,
	[Item14] [bit] NULL,
	[Item15] [bit] NULL,
	[Item16] [bit] NULL,
	[Item17] [bit] NULL,
	[Item18] [bit] NULL,
	[Item19] [bit] NULL,
	[Item20] [bit] NULL,
	[Item21] [bit] NULL,
	[Item22] [bit] NULL,
	[Item23] [bit] NULL,
	[Item24] [bit] NULL,
	[Item25] [bit] NULL,
	[Item26] [bit] NULL,
	[Item27] [bit] NULL,
	[Item28] [bit] NULL,
	[Item29] [bit] NULL,
	[Item30] [bit] NULL,
	[Item31] [bit] NULL,
	[Item32] [bit] NULL,
	[Item33] [bit] NULL,
	[Item34] [bit] NULL,
	[Item35] [bit] NULL,
	[Item36] [bit] NULL,
	[Item37] [bit] NULL,
	[Item38] [bit] NULL,
	[Item39] [bit] NULL,
	[IsCopy] [bit] NOT NULL,
 CONSTRAINT [PK_ArchitectureSafetyForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ArchitectureSpecForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ArchitectureSpecForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ExteriorWallTypes] [int] NOT NULL,
	[ExteriorWallMaterials] [int] NOT NULL,
	[OtherExteriorWallMaterials] [nvarchar](128) NULL,
	[InteriorWallTypes] [int] NOT NULL,
	[InteriorWallMaterials] [int] NOT NULL,
	[OtherInteriorWallMaterials] [nvarchar](128) NULL,
	[ExteriorViews] [int] NOT NULL,
	[OtherExteriorViews] [nvarchar](128) NULL,
	[InteriorViews] [int] NOT NULL,
	[OtherInteriorViews] [nvarchar](128) NULL,
	[RoofTopCovers] [int] NOT NULL,
	[OtherRoofTopCovers] [nvarchar](128) NULL,
	[FloorCovers] [int] NOT NULL,
	[OtherFloorCovers] [nvarchar](128) NULL,
	[FalseCeilings] [int] NOT NULL,
	[OtherFalseCeilings] [nvarchar](128) NULL,
	[Windows] [int] NOT NULL,
	[OtherWindows] [nvarchar](128) NULL,
	[Stairs] [int] NOT NULL,
	[OtherStairs] [nvarchar](128) NULL,
	[GlassTypes] [int] NOT NULL,
	[GlassMaterials] [int] NOT NULL,
	[OtherGlassTypes] [nvarchar](128) NULL,
	[ExteriorWallsWaterproofings] [int] NOT NULL,
	[ExteriorWallsWaterproofingPlace] [nvarchar](128) NULL,
	[FloorHeatInsulation] [int] NOT NULL,
	[FloorHeatInsulationPlace] [nvarchar](128) NULL,
	[CeilingHeatInsulation] [int] NOT NULL,
	[CeilingHeatInsulationPlace] [nvarchar](128) NULL,
	[ExteriorWallHeatInsulation] [int] NOT NULL,
	[ExteriorWallHeatInsulationPlace] [nvarchar](128) NULL,
	[EnergyConsumptionGrade] [int] NOT NULL,
	[FloorsAccessibilitySystems] [int] NOT NULL,
	[ArchitectureQuality] [bit] NOT NULL,
	[StandardArchitectureMaterials] [bit] NOT NULL,
 CONSTRAINT [PK_ArchitectureSpecForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[AsBuiltRequest]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[AsBuiltRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[FirstMetraje] [real] NOT NULL,
	[CertificateMetraje] [real] NOT NULL,
	[FinalMetraje] [real] NOT NULL,
	[AsBuiltMetraje] [real] NOT NULL,
	[IntialBuildingGroupSettingId] [int] NULL,
	[FinalBuildingGroupId] [int] NULL,
	[IntialFloorCount] [int] NOT NULL,
	[FinalFloorCount] [int] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[StatusIdId] [int] NOT NULL,
	[DossierNumber] [nvarchar](max) NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_AsBuiltRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[AsBuiltRequestStatus]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[AsBuiltRequestStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AsBuiltRequestStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[AttendeeOptions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[AttendeeOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AttendeeId] [uniqueidentifier] NOT NULL,
	[OptionId] [int] NOT NULL,
 CONSTRAINT [PK_AttendeeOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[AttendeeSessions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[AttendeeSessions](
	[Id] [uniqueidentifier] NOT NULL,
	[SessionId] [uniqueidentifier] NOT NULL,
	[AttendeeId] [uniqueidentifier] NOT NULL,
	[StatusId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_AttendeeSessions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[AttendeeSessionStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[AttendeeSessionStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AttendeeSessionStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[AttendeeStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[AttendeeStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AttendeeStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BankAcountTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BankAcountTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_BankAcountTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BillDetailItems]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BillDetailItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BillDetailId] [int] NOT NULL,
	[TariffDetailItemId] [int] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[Tax] [bigint] NOT NULL,
	[Tool] [bigint] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DiscountAmount] [bigint] NOT NULL,
	[TaxDiscount] [bigint] NOT NULL,
	[ToolDiscount] [bigint] NOT NULL,
 CONSTRAINT [PK_BillDetailItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BuildingCertificateTimeouts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingCertificateTimeouts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CheckDuration] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[NextCheckDate] [datetime2](7) NULL,
 CONSTRAINT [PK_BuildingCertificateTimeouts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BuildingGroups]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_BuildingGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BuildingGroupSettingCities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingGroupSettingCities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BuildingGroupSettingId] [int] NOT NULL,
	[CityId] [int] NULL,
 CONSTRAINT [PK_BuildingGroupSettingCities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BuildingGroupSettingRatios]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingGroupSettingRatios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BuildingGroupSettingId] [int] NOT NULL,
	[MemberTypeId] [int] NULL,
	[ServiceFieldId] [int] NULL,
	[MetrajRatio] [float] NOT NULL,
	[WorkItemRatio] [float] NOT NULL,
	[ServiceTypeId] [int] NULL,
 CONSTRAINT [PK_BuildingGroupSettingRatios] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[BuildingWorkers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[BuildingWorkers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Responsibility] [nvarchar](max) NULL,
	[FullName] [nvarchar](max) NULL,
	[EmploymentLicenseNumber] [nvarchar](max) NULL,
	[AddressAndPhone] [nvarchar](max) NULL,
	[InvolvedMemberId] [int] NOT NULL,
 CONSTRAINT [PK_BuildingWorkers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CancelDossierBillDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CancelDossierBillDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CancelDossierBillId] [int] NOT NULL,
	[CostTypeId] [int] NOT NULL,
	[ReturnAmount] [bigint] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[PayedAmount] [bigint] NOT NULL,
 CONSTRAINT [PK_CancelDossierBillDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CancelDossierBills]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CancelDossierBills](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CancelDossierRequestId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[AccountNumber] [nvarchar](50) NULL,
	[BankName] [nvarchar](max) NULL,
 CONSTRAINT [PK_CancelDossierBills] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CancelDossierRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CancelDossierRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsOwnerRequest] [bit] NOT NULL,
	[RequestStatusId] [int] NOT NULL,
 CONSTRAINT [PK_CancelDossierRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CancelDossierStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CancelDossierStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CancelDossierStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CategoryManpowerSkillCards]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CategoryManpowerSkillCards](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CategoryManpowerSkillCards] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CedoAgencies]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CedoAgencies](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Address] [nvarchar](512) NOT NULL,
	[Telephone] [nvarchar](128) NOT NULL,
	[Fax] [nvarchar](128) NOT NULL,
	[PostalCode] [nvarchar](128) NOT NULL,
	[WebSite] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CedoAgencies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CedoAgencyCities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CedoAgencyCities](
	[Id] [uniqueidentifier] NOT NULL,
	[AgencyId] [uniqueidentifier] NOT NULL,
	[CityId] [int] NOT NULL,
 CONSTRAINT [PK_CedoAgencyCities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeDesignerRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeDesignerRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ServiceFieldId] [int] NULL,
	[IsOwnerRequest] [bit] NOT NULL,
	[RequestStatusId] [int] NOT NULL,
	[InvolvedMemberId] [int] NULL,
	[HasBuildingCertificate] [bit] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[AsBuiltRequest] [bit] NOT NULL,
	[RequestId] [uniqueidentifier] NULL,
	[NewDossierNumber] [nvarchar](max) NULL,
 CONSTRAINT [PK_ChangeDesignerRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeExecuterRequest]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeExecuterRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[OwnerDescription] [nvarchar](2048) NULL,
	[ExecuterDescription] [nvarchar](2048) NULL,
	[StatusId] [int] NOT NULL,
	[RemainingMetraje] [float] NOT NULL,
	[RemainingWorkItem] [float] NOT NULL,
	[AsBuiltRequest] [bit] NOT NULL,
	[RequestId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ChangeExecuterRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeExecuterRequestStatus]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeExecuterRequestStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ChangeExecuterRequestStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeOwnerRequestDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeOwnerRequestDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ChangeOwnerRequestId] [int] NOT NULL,
	[OwnerId] [int] NOT NULL,
 CONSTRAINT [PK_ChangeOwnerRequestDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeOwnerRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeOwnerRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[IsBeforeCertificate] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[RequestStatusId] [int] NOT NULL,
	[BuildingProgress] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[LicenseNumber] [nvarchar](64) NULL,
	[RefNumber] [nvarchar](64) NULL,
	[RequestId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ChangeOwnerRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeOwnerStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeOwnerStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ChangeOwnerStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangePlanFeasibility]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangePlanFeasibility](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ChangePlanRequestId] [int] NOT NULL,
	[HasBuildingProgress] [bit] NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[IsConfirm] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ChangePlanFeasibility] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangePlanFeasibilityJudgement]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangePlanFeasibilityJudgement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ChangePlanFeasibilityId] [int] NOT NULL,
	[MemberServiceId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsExSupervisor] [bit] NOT NULL,
	[ResultDate] [datetime2](7) NULL,
	[IsConfirm] [bit] NOT NULL,
	[Result] [nvarchar](max) NULL,
	[ResultFileId] [int] NULL,
	[BuildingProgress] [float] NULL,
 CONSTRAINT [PK_ChangePlanFeasibilityJudgement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangePlanRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangePlanRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[MemberServiceId] [int] NOT NULL,
	[IsOwnerRequest] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[StatusId] [int] NOT NULL,
	[FloorCountFromBase] [int] NULL,
	[FloorCountFromGround] [int] NULL,
	[Metraje] [float] NULL,
	[HasNewLicense] [bit] NOT NULL,
	[ChangeArchiteturePlan] [bit] NOT NULL,
	[ChangeSrtucturePlan] [bit] NOT NULL,
	[ChangeElectricPlan] [bit] NOT NULL,
	[ChangeMechanicPlan] [bit] NOT NULL,
	[TempDossierNumber] [nvarchar](128) NULL,
	[IsAfterBuildingCertificate] [bit] NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[FirstMetraje] [float] NULL,
	[FirstFloorCountFromBase] [int] NULL,
	[FirstFloorCountFromGround] [int] NULL,
	[RequestId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ChangePlanRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangePlanRequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangePlanRequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ChangePlanRequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeSiteManagerRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeSiteManagerRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[Description] [nvarchar](2000) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[RequesterId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ChangeSiteManagerRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeSiteManagerStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeSiteManagerStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ChangeSiteManagerStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeSupervisorJudgment]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeSupervisorJudgment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ChangeSupervisorRequestId] [int] NOT NULL,
	[MemberServiceId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsExSupervisor] [bit] NOT NULL,
	[ResultDate] [datetime2](7) NULL,
	[IsConfirm] [bit] NOT NULL,
	[Result] [nvarchar](max) NULL,
	[BuildingProgress] [float] NULL,
	[ResultFileId] [int] NULL,
 CONSTRAINT [PK_ChangeSupervisorJudgment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeSupervisorRequest]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeSupervisorRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[SupervisorDescription] [nvarchar](2048) NULL,
	[OwnerDescription] [nvarchar](2048) NULL,
	[SupervisorResponsibilityAccept] [bit] NOT NULL,
	[OwnerResponsibilityAccept] [bit] NOT NULL,
	[EngineeringServiceDescription] [nvarchar](2048) NULL,
	[ArbitrationDescription] [nvarchar](2048) NULL,
	[IsOwnerPayer] [bit] NOT NULL,
	[IsNeedSupervisorConfirm] [bit] NOT NULL,
	[IsNeedArbitration] [bit] NOT NULL,
	[EngineeringServiceManagerDescription] [nvarchar](2048) NULL,
	[HasBuildingProgress] [bit] NOT NULL,
	[RemainingMetraje] [float] NULL,
	[RemainingWorkItem] [float] NULL,
	[RemainingCharge] [float] NULL,
	[RemainingCoordinatorCharge] [float] NULL,
	[NewSupervisroMemebrServiceId] [int] NULL,
	[IsAfterBuildingCertificate] [bit] NOT NULL,
	[IsOwnerRequest] [bit] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[StatusId] [int] NOT NULL,
	[SupervisroMemebrServiceId] [int] NULL,
	[NewDossierNumber] [nvarchar](max) NULL,
	[AsBuiltRequest] [bit] NOT NULL,
	[BuildingProgress] [float] NOT NULL,
	[RequestId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ChangeSupervisorRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ChangeSupervisorRequestStatus]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ChangeSupervisorRequestStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ChangeSupervisorRequestStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Complainees]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Complainees](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ComplaintId] [int] NOT NULL,
	[FirstName] [nvarchar](128) NOT NULL,
	[LastName] [nvarchar](128) NOT NULL,
	[NationalCode] [nvarchar](10) NULL,
	[Address] [nvarchar](1024) NULL,
 CONSTRAINT [PK_Complainees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintCommunicateds]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintCommunicateds](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ResultText] [nvarchar](max) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ComplaintResultStatusId] [int] NOT NULL,
	[ComplaintId] [int] NOT NULL,
	[Subject] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_ComplaintCommunicateds] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ComplaintId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ComplaintMemberTypeId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_ComplaintMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintMemberTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintMemberTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ComplaintMemberTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintResultMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintResultMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ComplaintResultId] [int] NOT NULL,
	[ComplaintMemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[VisitDate] [datetime2](7) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_ComplaintResultMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintResultStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintResultStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ComplaintResultStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintReviews]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintReviews](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ComplaintId] [int] NOT NULL,
	[ApplicantId] [int] NOT NULL,
	[Respondent] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ComplaintReviewTypeId] [int] NOT NULL,
 CONSTRAINT [PK_ComplaintReviews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintReviewTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintReviewTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ComplaintReviewTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Complaints]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Complaints](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ComplaintStatusId] [int] NOT NULL,
	[IntialResult] [nvarchar](max) NULL,
	[ComplainerAddress] [nvarchar](1024) NOT NULL,
	[ComplainerZipCode] [nvarchar](10) NOT NULL,
	[ViolationDate] [datetime2](7) NOT NULL,
	[ViolationPlace] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_Complaints] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ComplaintStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ComplaintStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ComplaintStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ConstructionLicenseComment]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[Title] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ConstructionLicenseComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ConstructionLicenseDescriptions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseDescriptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[DescriptionTypeId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ConstructionLicenseDescriptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ConstructionLicenseGeoLabs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseGeoLabs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[DeploymentLevel] [int] NOT NULL,
	[BoreCount] [int] NOT NULL,
	[BoreDepth] [real] NOT NULL,
	[DrillingTypeId] [int] NOT NULL,
	[DownHoleTest] [bit] NOT NULL,
 CONSTRAINT [PK_ConstructionLicenseGeoLabs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ConstructionLicenseOptions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](max) NULL,
	[Value] [nvarchar](max) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
 CONSTRAINT [PK_ConstructionLicenseOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ConstructionLicenseTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ConstructionLicenseTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ConstructionLicenseTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContactInfoTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContactInfoTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ContactInfoTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContractExpandation]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContractExpandation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[ServiceFieldId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Duration] [int] NOT NULL,
	[StartDate] [datetime2](7) NULL,
	[BuildingProgress] [int] NOT NULL,
	[Description] [nvarchar](2048) NULL,
	[ConstructionLicenseDocumentId] [int] NULL,
	[ContractExpandationStatusId] [int] NOT NULL,
 CONSTRAINT [PK_ContractExpandation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContractExpandationStatus]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContractExpandationStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ContractExpandationStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContractPaymentDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContractPaymentDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [int] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[PaymentTypeId] [int] NOT NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](128) NULL,
	[BankName] [nvarchar](50) NULL,
	[ChequeNumber] [nvarchar](20) NULL,
	[ContractPaymentForId] [int] NOT NULL,
 CONSTRAINT [PK_ContractPaymentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContractPaymentFors]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContractPaymentFors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ContractPaymentFors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContractPaymentTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContractPaymentTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ContractPaymentTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Contracts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Contracts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[ContractTypeId] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[Duration] [int] NOT NULL,
	[UnitAmount] [bigint] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[ContractNumber] [nvarchar](128) NULL,
	[SecretariatDate] [datetime2](7) NULL,
	[OfficeRegDate] [datetime2](7) NULL,
	[SecretariatNumber] [nvarchar](128) NULL,
	[Metraje] [float] NULL,
	[StatusId] [int] NOT NULL,
 CONSTRAINT [PK_Contracts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContractStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContractStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ContractStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ContractTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ContractTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ContractTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CostTypeDetailBills]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CostTypeDetailBills](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CostTypeDetailId] [int] NOT NULL,
	[BillTypeId] [int] NOT NULL,
 CONSTRAINT [PK_CostTypeDetailBills] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CostTypeDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CostTypeDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CostTypeId] [int] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[ServiceFieldId] [int] NULL,
	[IsCoordinatorPayment] [bit] NOT NULL,
 CONSTRAINT [PK_CostTypeDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CostTypeDetailSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CostTypeDetailSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CostTypeDetailId] [int] NOT NULL,
	[BuildingSubGroupId] [int] NULL,
	[Percentage] [float] NOT NULL,
 CONSTRAINT [PK_CostTypeDetailSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CostTypeOrder]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CostTypeOrder](
	[Id] [int] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_CostTypeOrder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseExecutors]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseExecutors](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](128) NULL,
	[Tel] [nvarchar](16) NULL,
	[Address] [nvarchar](128) NULL,
	[Url] [nvarchar](128) NULL,
	[ContractNumber] [nvarchar](128) NULL,
	[ContractDuration] [int] NOT NULL,
	[LicenceNumber] [nvarchar](128) NULL,
	[ContractDate] [datetime2](7) NOT NULL,
	[LicenceDate] [datetime2](7) NULL,
 CONSTRAINT [PK_CourseExecutors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseHoldings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseHoldings](
	[Id] [uniqueidentifier] NOT NULL,
	[CourseId] [uniqueidentifier] NOT NULL,
	[ExecutorId] [uniqueidentifier] NOT NULL,
	[StepId] [int] NOT NULL,
	[Title] [nvarchar](128) NULL,
	[HoldingDate] [datetime2](7) NULL,
	[RegStartDate] [datetime2](7) NOT NULL,
	[RegEndDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[EndDate] [datetime2](7) NULL,
	[ApprovalDate] [datetime2](7) NULL,
	[ApprovalNumber] [nvarchar](32) NULL,
	[CertRegDate] [datetime2](7) NULL,
	[CertRegNumber] [nvarchar](20) NULL,
 CONSTRAINT [PK_CourseHoldings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseHoldingSignatorieses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseHoldingSignatorieses](
	[Id] [uniqueidentifier] NOT NULL,
	[SignatoryId] [uniqueidentifier] NOT NULL,
	[CourseHoldingId] [uniqueidentifier] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_CourseHoldingSignatorieses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseHoldingSteps]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseHoldingSteps](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CourseHoldingSteps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseLessons]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseLessons](
	[Id] [uniqueidentifier] NOT NULL,
	[CourseId] [uniqueidentifier] NOT NULL,
	[LessonId] [uniqueidentifier] NOT NULL,
	[Required] [bit] NOT NULL,
 CONSTRAINT [PK_CourseLessons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseQualifiications]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseQualifiications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CourseId] [uniqueidentifier] NOT NULL,
	[ServiceFieldId] [int] NULL,
	[ServiceTypeId] [int] NULL,
	[EngGradeId] [int] NULL,
	[FieldType] [bit] NULL,
 CONSTRAINT [PK_CourseQualifiications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Courses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Courses](
	[Id] [uniqueidentifier] NOT NULL,
	[CourseTypeId] [int] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[MinReq] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[HasExam] [bit] NOT NULL,
 CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[CourseTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[CourseTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_CourseTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[DeploymentSides]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DeploymentSides](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_DeploymentSides] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[DescriptionTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DescriptionTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_DescriptionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[DossierBuildingGroupSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DossierBuildingGroupSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[NeedGeoTechnic] [bit] NOT NULL,
	[NeedElectricityPlan] [bit] NOT NULL,
	[NeedMechanicPlan] [bit] NOT NULL,
	[NeedExecuter] [bit] NOT NULL,
	[NeedsSurveyor] [bit] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsManualSuperVisor] [bit] NOT NULL,
	[IsChangeDesigner] [bit] NOT NULL,
	[SupervisorCount] [int] NOT NULL,
 CONSTRAINT [PK_DossierBuildingGroupSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[DossierCostSettingDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DossierCostSettingDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DossierCostSettingId] [int] NOT NULL,
	[TariffDetailItemId] [int] NOT NULL,
	[PercentDiscount] [float] NOT NULL,
	[MertajeDiscount] [float] NOT NULL,
 CONSTRAINT [PK_DossierCostSettingDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[DossierCostSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DossierCostSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[BuildingGroup] [nvarchar](128) NULL,
	[FloorCount] [nvarchar](128) NULL,
	[Metraje] [nvarchar](128) NULL,
	[BillTypeId] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[NeedExecuter] [bit] NOT NULL,
	[NeedGeoTechnic] [bit] NOT NULL,
	[NeedSurveyor] [bit] NOT NULL,
	[IsManualSuperVisor] [bit] NOT NULL,
 CONSTRAINT [PK_DossierCostSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[DrillingTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[DrillingTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_DrillingTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ElectricalExecutiveOperationsForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ElectricalExecutiveOperationsForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ElectricalExecutiveOperationsForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ElectricalPlanControlForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ElectricalPlanControlForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Item12] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ElectricalPlanControlForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ElectricalRedLinesForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ElectricalRedLinesForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ElectricalRedLinesForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ElectricalSpecForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ElectricalSpecForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[PipeType] [int] NOT NULL,
	[PipeTypeStandard] [bit] NOT NULL,
	[ExecutionPipeType] [int] NOT NULL,
	[ExecutionPipeTypeStandard] [bit] NOT NULL,
	[LengthProportion] [int] NOT NULL,
	[LightingCircuitsNum] [int] NOT NULL,
	[CommonLightingSystem] [int] NOT NULL,
	[OtherCommonLightingSystem] [nvarchar](max) NULL,
	[CommonLightingStandard] [bit] NOT NULL,
	[OutletCircuitNum] [int] NOT NULL,
	[OutletType] [int] NOT NULL,
	[OutletStandard] [bit] NOT NULL,
	[LightingOutletCircuits] [int] NOT NULL,
	[GroundSystem] [int] NOT NULL,
	[SparkArrestor] [int] NOT NULL,
	[SparkArrestorStandard] [bit] NOT NULL,
	[OpenerType] [int] NOT NULL,
	[OpenerCabling] [int] NOT NULL,
	[FireAlarmSystem] [int] NOT NULL,
	[FireAlarmStandard] [bit] NOT NULL,
	[GarageOpener] [int] NOT NULL,
	[GarageOpenerStandard] [bit] NOT NULL,
	[Iphone] [int] NOT NULL,
	[OtherIphone] [nvarchar](max) NULL,
	[IphoneStandard] [bit] NOT NULL,
	[TVAntenna] [int] NOT NULL,
	[TVAntennaStandard] [bit] NOT NULL,
	[TelephoneSystem] [int] NOT NULL,
	[TelPerUnit] [int] NOT NULL,
	[AudioSystem] [int] NOT NULL,
	[AudioSystemPerUnit] [int] NOT NULL,
	[CCTV] [nvarchar](max) NULL,
	[AdditionalEquipment] [int] NOT NULL,
	[OtherAdditionalEquipment] [nvarchar](max) NULL,
	[AdditionalStandard] [bit] NOT NULL,
	[PowerBranchType] [int] NOT NULL,
	[PhasesNum] [nvarchar](max) NULL,
	[AmpereValue] [nvarchar](max) NULL,
	[Generator] [int] NOT NULL,
	[GeneratorPhasesNum] [nvarchar](max) NULL,
	[GeneratorStandard] [bit] NOT NULL,
	[HazardLight] [int] NOT NULL,
	[HazardLightStandard] [bit] NOT NULL,
	[LightningArrester] [int] NOT NULL,
	[LightningArresterStandard] [bit] NOT NULL,
	[ElectricalQuality] [int] NOT NULL,
	[StandardElectricalMaterials] [int] NOT NULL,
 CONSTRAINT [PK_ElectricalSpecForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ElectricitySafetyForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ElectricitySafetyForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[InvolvedMemberId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Item1] [bit] NULL,
	[Item2] [bit] NULL,
	[Item3] [bit] NULL,
	[Item4] [bit] NULL,
	[Item5] [bit] NULL,
	[Item6] [bit] NULL,
	[Item7] [bit] NULL,
	[Item8] [bit] NULL,
	[Item9] [bit] NULL,
	[Item10] [bit] NULL,
	[Item11] [bit] NULL,
	[Item12] [bit] NULL,
	[Item13] [bit] NULL,
	[Item14] [bit] NULL,
	[Item15] [bit] NULL,
	[Item16] [bit] NULL,
	[Item17] [bit] NULL,
	[Item18] [bit] NULL,
	[Item19] [bit] NULL,
	[Item20] [bit] NULL,
	[IsCopy] [bit] NOT NULL,
 CONSTRAINT [PK_ElectricitySafetyForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Elevators]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Elevators](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ElectricalSpecFormId] [int] NOT NULL,
	[ElevatorType] [nvarchar](max) NULL,
	[ElevatorPersionCap] [int] NOT NULL,
	[ElevatorWeightCap] [real] NOT NULL,
	[ElevatorLength] [real] NOT NULL,
	[LowSpeed] [real] NOT NULL,
	[FastSpeed] [real] NOT NULL,
	[StopCount] [int] NOT NULL,
	[DoorType] [nvarchar](max) NULL,
	[DoorUsefulWidth] [real] NOT NULL,
	[DoorUsefulHight] [real] NOT NULL,
	[MechanicalDoorLock] [nvarchar](max) NULL,
	[LockBuilder] [nvarchar](max) NULL,
	[LockType] [nvarchar](max) NULL,
	[SpeedGovernorBuilder] [nvarchar](max) NULL,
	[SpeedGoverType] [nvarchar](max) NULL,
	[SafetyBrakeBuilder] [nvarchar](max) NULL,
	[SafetyBrakeType] [nvarchar](max) NULL,
	[StopLength] [nvarchar](max) NULL,
	[MotorBuilder] [nvarchar](max) NULL,
	[MotorSerialNumber] [nvarchar](max) NULL,
	[MotorType] [nvarchar](max) NULL,
	[StartPerHour] [nvarchar](max) NULL,
	[Power] [nvarchar](max) NULL,
	[Voltage] [nvarchar](max) NULL,
	[Current] [nvarchar](max) NULL,
	[LowRPM] [nvarchar](max) NULL,
	[FastRPM] [nvarchar](max) NULL,
	[GearboxType] [nvarchar](max) NULL,
	[GearboxBuilder] [nvarchar](max) NULL,
	[GearboxConversionRate] [nvarchar](max) NULL,
	[BrakeType] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[ExecutionQuality] [bit] NOT NULL,
	[MechanicalStopSpeed] [float] NULL,
	[StandardElevatorEquipment] [bit] NOT NULL,
 CONSTRAINT [PK_Elevators] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[EmploymentHistories]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[EmploymentHistories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NULL,
	[Description] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_EmploymentHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[EngineeringGrades]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[EngineeringGrades](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_EngineeringGrades] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[EngServiceCostScaleSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[EngServiceCostScaleSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DossierTypeId] [int] NOT NULL,
	[Scale] [real] NOT NULL,
 CONSTRAINT [PK_EngServiceCostScaleSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[EngServiceTariffDetailItems]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[EngServiceTariffDetailItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EngServiceTariffDetailId] [int] NOT NULL,
	[CostTypeDetailId] [int] NOT NULL,
	[BillTypeId] [int] NOT NULL,
	[Amount] [float] NOT NULL,
	[CanDiscount] [bit] NOT NULL,
	[TaxPercentage] [float] NOT NULL,
	[TollPercentage] [float] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_EngServiceTariffDetailItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[EngServiceTariffDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[EngServiceTariffDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EngServiceTariffId] [int] NOT NULL,
	[BuildingSubGroupId] [int] NOT NULL,
	[TariffAmount] [float] NOT NULL,
	[ExecuterAmount] [float] NOT NULL,
	[SurveyorAmount] [float] NOT NULL,
	[TechnicalAmount] [float] NOT NULL,
	[ConcreteLabAmount] [float] NOT NULL,
	[GeoTechnicAmount] [float] NOT NULL,
	[TaxPercentage] [float] NOT NULL,
	[TollPercentage] [float] NOT NULL,
 CONSTRAINT [PK_EngServiceTariffDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[EngServiceTariffs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[EngServiceTariffs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[ExpireDate] [datetime2](7) NULL,
 CONSTRAINT [PK_EngServiceTariffs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[EstateCoordinates]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[EstateCoordinates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[UtmX] [float] NOT NULL,
	[UtmY] [float] NOT NULL,
 CONSTRAINT [PK_EstateCoordinates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExaminationPlaces]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExaminationPlaces](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ExaminationPlaces] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Examinations]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Examinations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[ExaminationTypeId] [int] NOT NULL,
	[ExaminationPlaceId] [int] NOT NULL,
	[CeilingCount] [int] NOT NULL,
	[ExaminationStatusId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ExaminationFileId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Examinations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExaminationStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExaminationStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ExaminationStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExaminationTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExaminationTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ExaminationTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExcavationDangerStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExcavationDangerStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ExcavationDangerStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExecuterCompetenceSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExecuterCompetenceSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceFieldId] [int] NOT NULL,
	[GradeId] [int] NOT NULL,
	[MaxConcurrentMetraje] [int] NOT NULL,
	[MaxFloorCount] [int] NOT NULL,
	[MaxMetraje] [int] NULL,
	[MemberTypeId] [int] NOT NULL,
	[IsBulkMaker] [bit] NOT NULL,
	[MaxProjectCount] [int] NOT NULL,
	[MemberShipTypeId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
 CONSTRAINT [PK_ExecuterCompetenceSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExecuterContracts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExecuterContracts](
	[Id] [int] NOT NULL,
	[ContractSubject] [int] NOT NULL,
	[ContractPurpose] [bit] NOT NULL,
	[PurposeDescription] [nvarchar](1024) NULL,
	[Item21] [nvarchar](1024) NULL,
	[ContractConditions] [nvarchar](max) NULL,
	[ManagerFund] [bigint] NULL,
	[ManagerFundGurantee] [bigint] NULL,
	[ManagerWage] [float] NOT NULL,
	[ManagerWageGuarantee] [float] NULL,
	[ManagerWagePercent] [float] NULL,
 CONSTRAINT [PK_ExecuterContracts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExecuterContractSuspensionRequest]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExecuterContractSuspensionRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Duration] [int] NOT NULL,
	[OwnerDescription] [nvarchar](2048) NULL,
	[ExecuterDescription] [nvarchar](2048) NULL,
	[StatusId] [int] NOT NULL,
 CONSTRAINT [PK_ExecuterContractSuspensionRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExecuterContractSuspensionRequestStatus]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExecuterContractSuspensionRequestStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ExecuterContractSuspensionRequestStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExecuterContractTermination]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExecuterContractTermination](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[ArbitrationDescription] [nvarchar](1024) NULL,
	[HasBuildingProgress] [bit] NOT NULL,
	[IsOwnerPayer] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[StatusId] [int] NOT NULL,
	[IsOwnerRequest] [bit] NOT NULL,
 CONSTRAINT [PK_ExecuterContractTermination] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExecuterContractTerminationJudgment]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExecuterContractTerminationJudgment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExecuterContractTerminationId] [int] NOT NULL,
	[MemberServiceId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsExSupervisor] [bit] NOT NULL,
	[ResultDate] [datetime2](7) NULL,
	[IsConfirm] [bit] NOT NULL,
	[Result] [nvarchar](2048) NULL,
	[BuildingProgress] [float] NULL,
	[ResultFileId] [int] NULL,
 CONSTRAINT [PK_ExecuterContractTerminationJudgment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExecuterContractTerminationStatus]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExecuterContractTerminationStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ExecuterContractTerminationStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ExpertCostsSetting]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ExpertCostsSetting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CityId] [int] NOT NULL,
	[Clause27ExpertCost] [int] NOT NULL,
	[EsSupervisorCost] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ExpireDate] [datetime2](7) NULL,
 CONSTRAINT [PK_ExpertCostsSetting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FacilityDevicesSpecifications]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FacilityDevicesSpecifications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceTypeId] [int] NOT NULL,
	[FormId] [int] NOT NULL,
	[Count] [real] NULL,
	[Capacity] [real] NULL,
	[Description] [nvarchar](1024) NULL,
	[IsStandard] [bit] NULL,
 CONSTRAINT [PK_FacilityDevicesSpecifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FacilityDeviceTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FacilityDeviceTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FacilityDeviceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FacilityRequestFors]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FacilityRequestFors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FacilityRequestFors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FacilityRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FacilityRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[RequesterId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[FacilityForWorkItem] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[RequestForId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
 CONSTRAINT [PK_FacilityRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FacilityRequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FacilityRequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FacilityRequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FiscalBalances]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FiscalBalances](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[Amount] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[ServiceFieldId] [int] NOT NULL,
 CONSTRAINT [PK_FiscalBalances] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[FloorRegisterStep]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[FloorRegisterStep](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FloorRegisterStep] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasBranchOffices]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasBranchOffices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CityId] [int] NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Address] [nvarchar](512) NOT NULL,
	[Telephone] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_GasBranchOffices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasBranchUsers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasBranchUsers](
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [int] NOT NULL,
 CONSTRAINT [PK_GasBranchUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasCounterTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasCounterTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasCounterTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasOncallStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasOncallStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasOncallStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestAuditForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestAuditForms](
	[Id] [int] NOT NULL,
	[ExecutedBeforeAudit] [bit] NOT NULL,
	[HasFlag] [bit] NOT NULL,
	[RequiresConsentLetter] [bit] NOT NULL,
	[RequiresLicense] [bit] NOT NULL,
	[UsageTypeId] [int] NOT NULL,
	[CounterTypeId] [int] NOT NULL,
	[GMLocated] [bit] NOT NULL,
	[GMLocationDescription] [nvarchar](512) NULL,
	[HatchLocated] [bit] NOT NULL,
	[HatchDimention] [nvarchar](512) NULL,
	[HatchCount] [int] NOT NULL,
	[AirtightSeam] [bit] NOT NULL,
	[NormalSeam] [bit] NOT NULL,
	[NeedsSupportFounding] [bit] NOT NULL,
	[NeedsSupportClamp] [bit] NOT NULL,
	[SupportDescription] [nvarchar](max) NULL,
	[PipelineRounting] [bit] NOT NULL,
	[GCCount] [int] NOT NULL,
	[GCUsage] [float] NOT NULL,
	[HCount] [int] NOT NULL,
	[HUsage] [float] NOT NULL,
	[HChimney] [float] NOT NULL,
	[FireplaceCount] [int] NOT NULL,
	[FireplaceUsage] [float] NOT NULL,
	[FireplaceChimney] [float] NOT NULL,
	[RCCount] [int] NOT NULL,
	[RCUsage] [float] NOT NULL,
	[WHGroundCount] [int] NOT NULL,
	[WHGroundUsage] [float] NOT NULL,
	[WHGroundChimney] [float] NOT NULL,
	[WHWallCount] [int] NOT NULL,
	[WHWallUsage] [float] NOT NULL,
	[WHWallChimney] [float] NOT NULL,
	[PackageCount] [int] NOT NULL,
	[PackageUsage] [float] NOT NULL,
	[PackageChimney] [float] NOT NULL,
	[LICount] [int] NOT NULL,
	[LIUsage] [float] NOT NULL,
	[ChimneyOrder] [nvarchar](1024) NULL,
	[ChimneyHeight] [bit] NOT NULL,
	[Earthquake] [bit] NOT NULL,
	[GasFuse] [bit] NOT NULL,
	[GasLeakageAlert] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Units] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_GasRequestAuditForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestInvolvedMemberChangeLogs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestInvolvedMemberChangeLogs](
	[Id] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_GasRequestInvolvedMemberChangeLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestInvolvedMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestInvolvedMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [int] NULL,
	[MemberServiceId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[OncallId] [int] NULL,
 CONSTRAINT [PK_GasRequestInvolvedMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestOncallDescriptions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestOncallDescriptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GasRequestOncallId] [int] NOT NULL,
	[GasRequestOncallStatusId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_GasRequestOncallDescriptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestOncalls]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestOncalls](
	[ReporterName] [nvarchar](50) NOT NULL,
	[ReporterMobile] [nvarchar](11) NULL,
	[IsRental] [bit] NOT NULL,
	[GasLeakage] [bit] NOT NULL,
	[Monoxide] [bit] NOT NULL,
	[Fire] [bit] NOT NULL,
	[UnauthorizedDevelopment] [bit] NOT NULL,
	[DocumentAbsence] [bit] NOT NULL,
	[GasFlowIntruption] [bit] NOT NULL,
	[OtherReasons] [nvarchar](512) NULL,
	[CutDate] [datetime2](7) NOT NULL,
	[CounterNumber] [int] NOT NULL,
	[IsConnected] [bit] NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OwnerMobile] [nvarchar](11) NOT NULL,
	[OwnerName] [nvarchar](128) NOT NULL,
	[ServiceRequestId] [uniqueidentifier] NOT NULL,
	[Subscription] [nvarchar](30) NOT NULL,
	[TrackCode] [nvarchar](128) NOT NULL,
	[Address] [nvarchar](1024) NOT NULL,
	[StatusId] [int] NOT NULL,
 CONSTRAINT [PK_GasRequestOncalls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestOncallStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestOncallStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasRequestOncallStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [uniqueidentifier] NOT NULL,
	[TypeId] [int] NOT NULL,
	[CityId] [int] NOT NULL,
	[ScopeId] [int] NOT NULL,
	[Address] [nvarchar](512) NOT NULL,
	[AddressRegion] [nvarchar](128) NULL,
	[OwnershipTypeId] [int] NOT NULL,
	[FlagSerial] [nvarchar](50) NULL,
	[LocationLat] [real] NOT NULL,
	[LocationLng] [real] NOT NULL,
	[StatusId] [int] NOT NULL,
	[TrackCode] [nvarchar](128) NULL,
	[DossierNumber] [nvarchar](128) NULL,
	[IsFreeRequest] [bit] NOT NULL,
	[OncallTrackCode] [nvarchar](max) NULL,
	[FreeRequestComment] [nvarchar](2048) NULL,
 CONSTRAINT [PK_GasRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestScopeTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestScopeTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasRequestScopeTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestSplitDocuments]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestSplitDocuments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GasRequestSplitId] [int] NOT NULL,
	[DocumentTypeId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[SheetNumber] [int] NULL,
 CONSTRAINT [PK_GasRequestSplitDocuments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestSplitProblems]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestSplitProblems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SplitId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_GasRequestSplitProblems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestSplits]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestSplits](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GasRequestId] [int] NOT NULL,
	[UsageTypeId] [int] NOT NULL,
	[CounterTypeId] [int] NOT NULL,
	[Usage] [float] NOT NULL,
	[Area] [int] NOT NULL,
	[Units] [int] NOT NULL,
	[Floors] [int] NOT NULL,
	[OwnerName] [nvarchar](128) NULL,
	[OwnerNationalCode] [nvarchar](10) NULL,
	[ZipCode] [nvarchar](20) NULL,
	[OwnerMobile] [nvarchar](11) NULL,
	[BuiltIn] [bit] NOT NULL,
	[Subscription] [nvarchar](50) NULL,
	[FinalCounterTypeId] [int] NULL,
	[FinalUnits] [int] NULL,
	[FinalUsageTypeId] [int] NULL,
	[Counters] [int] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_GasRequestSplits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasRequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRequestTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRequestTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasRequestTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasRotatingForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasRotatingForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[HasSubscription] [bit] NOT NULL,
	[SubscriptionTypeId] [int] NOT NULL,
	[FlagSerial] [nvarchar](128) NOT NULL,
	[NeedsRegulator] [bit] NOT NULL,
	[ValveType] [nvarchar](128) NOT NULL,
	[PlanType] [bit] NOT NULL,
	[PrevSubscription] [nvarchar](128) NULL,
 CONSTRAINT [PK_GasRotatingForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasSubscriptionTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasSubscriptionTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasSubscriptionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasSupervisionResults]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasSupervisionResults](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[StateId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_GasSupervisionResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasSupervisionResultStates]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasSupervisionResultStates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasSupervisionResultStates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GasUsageTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GasUsageTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_GasUsageTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[GradeCalculationSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[GradeCalculationSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BuildingGroupSettingId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[ServiceFieldId] [int] NULL,
	[MinGradeId] [int] NOT NULL,
 CONSTRAINT [PK_GradeCalculationSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[HealthStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[HealthStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_HealthStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[HoldingLessonOptions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[HoldingLessonOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HoldingLessonId] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Cost] [int] NOT NULL,
 CONSTRAINT [PK_HoldingLessonOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[HoldingLessons]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[HoldingLessons](
	[Id] [uniqueidentifier] NOT NULL,
	[CourseLessonId] [uniqueidentifier] NOT NULL,
	[TeacherMemberServiceId] [int] NULL,
	[CourseHoldingId] [uniqueidentifier] NULL,
	[Tuition] [int] NOT NULL,
	[MinCapacity] [int] NOT NULL,
	[MaxCapacity] [int] NOT NULL,
	[MaxAbsence] [real] NOT NULL,
	[StatusId] [int] NOT NULL,
	[ReTuition] [int] NOT NULL,
	[ReHoldingDate] [datetime2](7) NULL,
	[ExamDate] [datetime2](7) NOT NULL,
	[HoldingEnd] [datetime2](7) NULL,
	[HoldingStart] [datetime2](7) NULL,
 CONSTRAINT [PK_HoldingLessons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[HoldingLessonSessions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[HoldingLessonSessions](
	[Id] [uniqueidentifier] NOT NULL,
	[HoldingLessonId] [uniqueidentifier] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_HoldingLessonSessions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[HoldingLessonStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[HoldingLessonStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_HoldingLessonStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[IntroductionRequests]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[IntroductionRequests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[RequestDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[StatusId] [int] NOT NULL,
	[Receiver] [nvarchar](256) NOT NULL,
	[TargetId] [int] NOT NULL,
 CONSTRAINT [PK_IntroductionRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[IntroductionRequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[IntroductionRequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_IntroductionRequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[IntroductionTargets]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[IntroductionTargets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgTitle] [nvarchar](128) NOT NULL,
	[ReceiverDescription] [nvarchar](1024) NOT NULL,
	[ReceiverTitle] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_IntroductionTargets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[LegalMemberPersonnels]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[LegalMemberPersonnels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LegalMemberId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
	[PostId] [int] NULL,
	[Entry] [datetime2](7) NULL,
	[ExitDate] [datetime2](7) NULL,
 CONSTRAINT [PK_LegalMemberPersonnels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[LegalMemberTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[LegalMemberTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_LegalMemberTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Lessons]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Lessons](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[Duration] [int] NOT NULL,
	[Validity] [int] NOT NULL,
 CONSTRAINT [PK_Lessons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[LicenseCapacities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[LicenseCapacities](
	[Id] [uniqueidentifier] NOT NULL,
	[MemberId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[ServiceFieldId] [int] NULL,
	[BuildingGroupId] [int] NULL,
	[Metraj] [float] NULL,
	[WorkItem] [float] NULL,
	[Concurrency] [int] NULL,
	[Floors] [int] NULL,
	[Date] [datetime2](7) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[PrevYears] [int] NULL,
 CONSTRAINT [PK_LicenseCapacities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[LicenseCapacityRemainings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[LicenseCapacityRemainings](
	[Id] [uniqueidentifier] NOT NULL,
	[Metraj] [float] NULL,
	[WorkItem] [float] NULL,
 CONSTRAINT [PK_LicenseCapacityRemainings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[LicenseInqueryStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[LicenseInqueryStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_LicenseInqueryStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ManpowerSkillCards]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ManpowerSkillCards](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CategoryManpowerSkillCardId] [int] NOT NULL,
	[Title] [nvarchar](128) NULL,
 CONSTRAINT [PK_ManpowerSkillCards] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ManpowerSkillCardValues]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ManpowerSkillCardValues](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HasIt] [bit] NOT NULL,
	[FullName] [nvarchar](128) NULL,
	[SkillCardNumber] [nvarchar](128) NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[ManpowerSkillCardId] [int] NOT NULL,
 CONSTRAINT [PK_ManpowerSkillCardValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MaterialCategories]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MaterialCategories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_MaterialCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Materials]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Materials](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MaterialCategoryId] [int] NOT NULL,
	[Title] [nvarchar](256) NULL,
 CONSTRAINT [PK_Materials] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MaterialValues]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MaterialValues](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MaterialId] [int] NOT NULL,
	[Type] [nvarchar](128) NULL,
	[Standard] [nvarchar](128) NULL,
	[StandardNumber] [nvarchar](128) NULL,
	[Description] [nvarchar](1024) NULL,
	[InvolvedMemberId] [int] NOT NULL,
 CONSTRAINT [PK_MaterialValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MechanicalExecutiveOperationsForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MechanicalExecutiveOperationsForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_MechanicalExecutiveOperationsForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MechanicalPlanControlForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MechanicalPlanControlForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Item12] [bit] NOT NULL,
	[Item13] [bit] NOT NULL,
	[item14] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_MechanicalPlanControlForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MechanicalRedLinesForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MechanicalRedLinesForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_MechanicalRedLinesForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MechanicalSpecForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MechanicalSpecForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[WaterPipesType] [int] NOT NULL,
	[WaterPipesStandard] [bit] NOT NULL,
	[SewerPipesType] [int] NOT NULL,
	[SewerPipesStandard] [bit] NOT NULL,
	[HeatingPipesType] [int] NOT NULL,
	[HeatingPipesStandard] [bit] NOT NULL,
	[GasPipesType] [int] NOT NULL,
	[GasPipesStandard] [bit] NOT NULL,
	[Topic19Observance] [int] NOT NULL,
	[EconomicalBuildingGroup] [int] NOT NULL,
	[FuelType] [int] NOT NULL,
	[FuelStandard] [bit] NOT NULL,
	[HeatingSystem] [int] NOT NULL,
	[HeatingSystemStandard] [bit] NOT NULL,
	[CoolingSystem] [int] NOT NULL,
	[CoolingSystemStandard] [bit] NOT NULL,
	[HeatColdTransmissionSystem] [int] NOT NULL,
	[HeatColdTransmissionStandard] [bit] NOT NULL,
	[SewageDisposalSystem] [int] NOT NULL,
	[SewageDisposalStandard] [bit] NOT NULL,
	[FireSystem] [int] NOT NULL,
	[FireSystemStandard] [bit] NOT NULL,
	[ElevatorSystem] [int] NOT NULL,
	[ElevatorSystemStandard] [bit] NOT NULL,
	[AuxiliaryFacilities] [int] NOT NULL,
	[OtherWaterPipesType] [nvarchar](max) NULL,
	[OtherSewerPipesType] [nvarchar](max) NULL,
	[OtherHeatingPipesType] [nvarchar](max) NULL,
	[OtherFuelType] [nvarchar](max) NULL,
	[OtherHeatingSystem] [nvarchar](max) NULL,
	[OtherCoolingSystem] [nvarchar](max) NULL,
	[OtherSewageDisposalSystem] [nvarchar](max) NULL,
	[OtherFireSystem] [nvarchar](max) NULL,
	[MechanicalQuality] [bit] NOT NULL,
	[StandardMechanicalMaterials] [bit] NOT NULL,
 CONSTRAINT [PK_MechanicalSpecForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MechanicSafetyForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MechanicSafetyForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[InvolvedMemberId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Item1] [bit] NULL,
	[Item2] [bit] NULL,
	[Item3] [bit] NULL,
	[Item4] [bit] NULL,
	[Item5] [bit] NULL,
	[Item6] [bit] NULL,
	[Item7] [bit] NULL,
	[Item8] [bit] NULL,
	[Item9] [bit] NULL,
	[Item10] [bit] NULL,
	[Item11] [bit] NULL,
	[Item12] [bit] NULL,
	[Item13] [bit] NULL,
	[Item14] [bit] NULL,
	[Item15] [bit] NULL,
	[Item16] [bit] NULL,
	[Item17] [bit] NULL,
	[Item18] [bit] NULL,
	[Item19] [bit] NULL,
	[Item20] [bit] NULL,
	[IsCopy] [bit] NOT NULL,
 CONSTRAINT [PK_MechanicSafetyForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MemberBankAcounts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberBankAcounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AcountNumber] [nvarchar](max) NULL,
	[BankAcountTypeId] [int] NOT NULL,
	[MemberId] [int] NOT NULL,
 CONSTRAINT [PK_MemberBankAcounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MemberContacts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberContacts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[ContactTypeId] [int] NOT NULL,
	[Data] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_MemberContacts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MemberShipTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberShipTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_MemberShipTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MemberTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_MemberTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[MemberWorkFields]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[MemberWorkFields](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[ServiceFieldId] [int] NOT NULL,
 CONSTRAINT [PK_MemberWorkFields] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OnlinePaymentSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OnlinePaymentSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CityId] [int] NOT NULL,
	[BillTypeId] [int] NOT NULL,
	[LoginAccount] [nvarchar](128) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_OnlinePaymentSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OrgPersonnels]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OrgPersonnels](
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_OrgPersonnels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OrgPosts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OrgPosts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_OrgPosts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OrgUnitPersonnels]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OrgUnitPersonnels](
	[Id] [uniqueidentifier] NOT NULL,
	[UnitId] [uniqueidentifier] NOT NULL,
	[PersonnelId] [uniqueidentifier] NOT NULL,
	[PostId] [int] NULL,
	[AssignedAt] [datetime2](7) NOT NULL,
	[UnassignedAt] [datetime2](7) NULL,
 CONSTRAINT [PK_OrgUnitPersonnels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OrgUnits]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OrgUnits](
	[Id] [uniqueidentifier] NOT NULL,
	[AgencyId] [uniqueidentifier] NOT NULL,
	[ParentUnitId] [uniqueidentifier] NULL,
	[UnitTypeId] [int] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[AutomationId] [bigint] NULL,
 CONSTRAINT [PK_OrgUnits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OrgUnitTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OrgUnitTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_OrgUnitTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[OwnerTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[OwnerTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_OwnerTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[PasswayTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PasswayTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_PasswayTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[PaymentStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PaymentStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_PaymentStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[PaymentTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PaymentTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_PaymentTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[PersonnelPosts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PersonnelPosts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_PersonnelPosts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[PlanControlSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[PlanControlSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceCityId] [int] NOT NULL,
	[ServiceFieldId] [int] NOT NULL,
	[TargetCityId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[DossierTypeId] [int] NULL,
	[DefaultUserIdId] [uniqueidentifier] NULL,
	[ServiceTypeId] [int] NOT NULL,
	[BuildingSubGroupId] [int] NULL,
 CONSTRAINT [PK_PlanControlSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ProjectWorkItemSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ProjectWorkItemSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CityId] [int] NULL,
	[WorkItem] [float] NOT NULL,
	[MaxCount] [int] NOT NULL,
	[DossierTypeId] [int] NULL,
 CONSTRAINT [PK_ProjectWorkItemSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Provinces]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Provinces](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[SyncCode] [int] NULL,
 CONSTRAINT [PK_Provinces] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[RealMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[RealMembers](
	[Id] [int] NOT NULL,
	[HealthStatusId] [int] NOT NULL,
 CONSTRAINT [PK_RealMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[RequestStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[RequestStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_RequestStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[RequestTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[RequestTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_RequestTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SentenceCancellations]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SentenceCancellations](
	[Id] [uniqueidentifier] NOT NULL,
	[LetterNumber] [nvarchar](max) NOT NULL,
	[LetterDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_SentenceCancellations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Sentences]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Sentences](
	[Id] [uniqueidentifier] NOT NULL,
	[PlaintiffName] [nvarchar](256) NOT NULL,
	[IsLegal] [bit] NOT NULL,
	[MemberId] [int] NOT NULL,
	[Description] [nvarchar](1024) NOT NULL,
	[Degree] [int] NOT NULL,
	[DateNotification] [datetime2](7) NOT NULL,
	[DurationInitial] [int] NULL,
	[DateFinalVerdict] [datetime2](7) NULL,
	[Duration] [int] NULL,
	[EndDate] [datetime2](7) NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[JudgmentLetterNumber] [nvarchar](128) NOT NULL,
	[DateSentenceLetter] [datetime2](7) NOT NULL,
	[SentenceStatusId] [int] NOT NULL,
 CONSTRAINT [PK_Sentences] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SentenceStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SentenceStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SentenceStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SeparationExchangeFiles]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SeparationExchangeFiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[EmptyExchangeFileDate] [datetime2](7) NULL,
	[FilledExchangeFileDate] [datetime2](7) NULL,
	[Serial] [nvarchar](max) NULL,
 CONSTRAINT [PK_SeparationExchangeFiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SeparationPlanRequestTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SeparationPlanRequestTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SeparationPlanRequestTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SGALetters]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SGALetters](
	[Id] [uniqueidentifier] NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[LetterTypeId] [int] NOT NULL,
	[Subject] [nvarchar](512) NOT NULL,
	[RegNumber] [nvarchar](128) NOT NULL,
	[Date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_SGALetters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SGALetterTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SGALetterTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SGALetterTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Signatories]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Signatories](
	[Id] [uniqueidentifier] NOT NULL,
	[Position] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Signatories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StructureExecutiveOperationsForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StructureExecutiveOperationsForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Item12] [bit] NOT NULL,
	[Item13] [bit] NOT NULL,
	[Item14] [bit] NOT NULL,
	[Item15] [bit] NOT NULL,
	[Item16] [bit] NOT NULL,
	[Item17] [bit] NOT NULL,
	[Item18] [bit] NOT NULL,
	[Item19] [bit] NOT NULL,
	[Item20] [bit] NOT NULL,
	[Item21] [bit] NOT NULL,
	[Item22] [bit] NOT NULL,
	[Item23] [bit] NOT NULL,
	[Item24] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_StructureExecutiveOperationsForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StructurePlanControlForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StructurePlanControlForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Item12] [bit] NOT NULL,
	[Item13] [bit] NOT NULL,
	[Item14] [bit] NOT NULL,
	[Item15] [bit] NOT NULL,
	[Item16] [bit] NOT NULL,
	[Item17] [bit] NOT NULL,
	[Item18] [bit] NOT NULL,
	[Item19] [bit] NOT NULL,
	[Item20] [bit] NOT NULL,
	[Item21] [bit] NOT NULL,
	[Item22] [bit] NOT NULL,
	[Item23] [bit] NOT NULL,
	[Item24] [bit] NOT NULL,
	[Item25] [bit] NOT NULL,
	[Item26] [bit] NOT NULL,
	[Item27] [bit] NOT NULL,
	[Item28] [bit] NOT NULL,
	[Item29] [bit] NOT NULL,
	[Item30] [bit] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_StructurePlanControlForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StructureRedLinesForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StructureRedLinesForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_StructureRedLinesForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StructureSafetyForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StructureSafetyForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[InvolvedMemberId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Item1] [bit] NULL,
	[Item2] [bit] NULL,
	[Item3] [bit] NULL,
	[Item4] [bit] NULL,
	[Item5] [bit] NULL,
	[Item6] [bit] NULL,
	[Item7] [bit] NULL,
	[Item8] [bit] NULL,
	[Item9] [bit] NULL,
	[Item10] [bit] NULL,
	[Item11] [bit] NULL,
	[Item12] [bit] NULL,
	[Item13] [bit] NULL,
	[Item14] [bit] NULL,
	[Item15] [bit] NULL,
	[Item16] [bit] NULL,
	[Item17] [bit] NULL,
	[Item18] [bit] NULL,
	[Item19] [bit] NULL,
	[Item20] [bit] NULL,
	[Item21] [bit] NULL,
	[Item22] [bit] NULL,
	[Item23] [bit] NULL,
	[Item24] [bit] NULL,
	[Item25] [bit] NULL,
	[Item26] [bit] NULL,
	[Item27] [bit] NULL,
	[Item28] [bit] NULL,
	[Item29] [bit] NULL,
	[Item30] [bit] NULL,
	[Item31] [bit] NULL,
	[Item32] [bit] NULL,
	[Item33] [bit] NULL,
	[Item34] [bit] NULL,
	[Item35] [bit] NULL,
	[Item36] [bit] NULL,
	[Item37] [bit] NULL,
	[Item38] [bit] NULL,
	[Item39] [bit] NULL,
	[Item40] [bit] NULL,
	[Item41] [bit] NULL,
	[Item42] [bit] NULL,
	[Item43] [bit] NULL,
	[Item44] [bit] NULL,
	[Item45] [bit] NULL,
	[Item46] [bit] NULL,
	[Item47] [bit] NULL,
	[Item48] [bit] NULL,
	[Item49] [bit] NULL,
	[IsCopy] [bit] NOT NULL,
 CONSTRAINT [PK_StructureSafetyForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StructureSpecForms]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StructureSpecForms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Item1] [bit] NOT NULL,
	[Item2] [bit] NOT NULL,
	[Item3] [bit] NOT NULL,
	[Item4] [bit] NOT NULL,
	[Item5] [bit] NOT NULL,
	[Item6] [bit] NOT NULL,
	[Item7] [bit] NOT NULL,
	[Item8] [bit] NOT NULL,
	[Item9] [bit] NOT NULL,
	[Item10] [bit] NOT NULL,
	[Item11] [bit] NOT NULL,
	[Item12] [bit] NOT NULL,
	[Item13] [bit] NOT NULL,
	[Item14] [bit] NOT NULL,
	[BuildingGroupImportance] [int] NOT NULL,
	[SoilType] [int] NOT NULL,
	[FoundationType] [int] NOT NULL,
	[StructuralMaterialsType] [int] NOT NULL,
	[OtherStructuralMaterialsType] [nvarchar](max) NULL,
	[StructuralType] [int] NOT NULL,
	[OtherStructuralType] [nvarchar](max) NULL,
	[RoofType] [int] NOT NULL,
	[OtherRoofType] [nvarchar](max) NULL,
	[BasementRetainingWall] [int] NOT NULL,
	[SoilMechanicTest] [bit] NOT NULL,
	[SoilMechanicTestResult] [bit] NOT NULL,
	[ConcreteSampleTest] [bit] NOT NULL,
	[ConcreteSampleTestResult] [bit] NOT NULL,
	[WeldingTest] [bit] NOT NULL,
	[WeldingTestResult] [bit] NOT NULL,
	[BearingWallSystem] [int] NOT NULL,
	[SimpleBuildingFrameSystem] [int] NOT NULL,
	[BendingFrameSystem] [int] NOT NULL,
	[DualOrCombinedSystem] [int] NOT NULL,
	[HorizontalTies] [int] NOT NULL,
	[VerticalTies] [int] NOT NULL,
	[StructureQuality] [bit] NOT NULL,
	[StandardStructuralMaterials] [bit] NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_StructureSpecForms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StructureTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StructureTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_StructureTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StudyGrades]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StudyGrades](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[SyncCode] [int] NOT NULL,
 CONSTRAINT [PK_StudyGrades] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[StudyRecords]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[StudyRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[UniversityId] [int] NOT NULL,
	[StudyGradeId] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[IsMainField] [bit] NOT NULL,
 CONSTRAINT [PK_StudyRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SubWorkItemSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SubWorkItemSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubGroupId] [int] NOT NULL,
	[Max] [int] NOT NULL,
	[WorkItem] [float] NOT NULL,
	[CityId] [int] NULL,
	[DossierTypeId] [int] NULL,
	[ServiceTypeId] [int] NULL,
 CONSTRAINT [PK_SubWorkItemSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionCandidates]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionCandidates](
	[Id] [uniqueidentifier] NOT NULL,
	[SupervisionFieldId] [uniqueidentifier] NOT NULL,
	[MemberId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[InitialScore] [float] NOT NULL,
	[CloseScore] [float] NOT NULL,
	[StatusId] [int] NOT NULL,
	[Description] [nvarchar](1024) NULL,
 CONSTRAINT [PK_SupervisionCandidates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionCandidateStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionCandidateStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SupervisionCandidateStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionFields]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionFields](
	[Id] [uniqueidentifier] NOT NULL,
	[FieldId] [int] NOT NULL,
	[SupervisionOrderId] [uniqueidentifier] NOT NULL,
	[MinGradeId] [int] NOT NULL,
 CONSTRAINT [PK_SupervisionFields] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionItemAnswers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionItemAnswers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[FormId] [int] NOT NULL,
	[Answer] [nvarchar](128) NULL,
 CONSTRAINT [PK_SupervisionItemAnswers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionOrders]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionOrders](
	[Id] [uniqueidentifier] NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[TypeId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[StatusId] [int] NOT NULL,
 CONSTRAINT [PK_SupervisionOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionOrderStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionOrderStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SupervisionOrderStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionOrderTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionOrderTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SupervisionOrderTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[From] [datetime2](7) NOT NULL,
	[EffectiveYears] [int] NOT NULL,
	[DesignAlpha] [float] NOT NULL,
	[DefaultCapacity] [int] NOT NULL,
	[OneFieldLegalWinnerPercentage] [float] NOT NULL,
	[TwoFieldLegalWinnerPercentage] [float] NOT NULL,
	[ThreeFieldLegalWinnerPercentage] [float] NOT NULL,
 CONSTRAINT [PK_SupervisionSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionStepItemOptions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionStepItemOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SupervisionStepItemId] [int] NOT NULL,
	[ItemOption] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SupervisionStepItemOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionStepPayments]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionStepPayments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InvolvedMemberId] [int] NOT NULL,
	[SupervisionStepId] [int] NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[PayDate] [datetime2](7) NULL,
	[Amount] [bigint] NOT NULL,
	[IsCoordinatorPayment] [bit] NOT NULL,
	[IsExSupervisorConfirmed] [bit] NOT NULL,
	[IsNeedIsExSupervisorConfirm] [bit] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[PaymentStatusId] [int] NOT NULL,
	[RemainingAmount] [bigint] NOT NULL,
	[PaymentPercent] [float] NOT NULL,
 CONSTRAINT [PK_SupervisionStepPayments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [cedo].[SupervisionStepPaymentStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[SupervisionStepPaymentStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SupervisionStepPaymentStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[TeacherLessons]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[TeacherLessons](
	[Id] [uniqueidentifier] NOT NULL,
	[LessonId] [uniqueidentifier] NOT NULL,
	[MemberServiceId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_TeacherLessons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[TempInvolvedMember]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[TempInvolvedMember](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkItem] [float] NULL,
	[Metraje] [float] NULL,
	[IsSent] [bit] NOT NULL,
 CONSTRAINT [PK_TempInvolvedMember] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Territories]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Territories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[TerritoryTypeId] [int] NOT NULL,
	[PasswayTypeId] [int] NOT NULL,
	[DocumentDimension] [real] NOT NULL,
	[AvailableDimension] [real] NOT NULL,
	[AvailableWidth] [real] NOT NULL,
	[CorrectiveWidth] [real] NOT NULL,
	[AfterCorrectionDimension] [real] NOT NULL,
 CONSTRAINT [PK_Territories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[TerritoryTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[TerritoryTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TerritoryTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[Universities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[Universities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[SyncCode] [int] NOT NULL,
 CONSTRAINT [PK_Universities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[UsageTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[UsageTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_UsageTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ValidMemberServices]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ValidMemberServices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MemberTypeId] [int] NOT NULL,
	[MembershipTypeId] [int] NOT NULL,
	[LegalMemberTypeId] [int] NULL,
	[MemberFieldId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[ServiceFieldId] [int] NULL,
 CONSTRAINT [PK_ValidMemberServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ViolationReportDetails]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ViolationReportDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ViolationReportId] [int] NOT NULL,
	[MainSubjectId] [int] NOT NULL,
	[Subject] [nvarchar](256) NOT NULL,
	[Detail] [nvarchar](2048) NOT NULL,
 CONSTRAINT [PK_ViolationReportDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ViolationReports]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ViolationReports](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionLicenseId] [int] NOT NULL,
	[ReporterMemberId] [int] NOT NULL,
	[ReportDate] [datetime2](7) NOT NULL,
	[IsCheckedOut] [bit] NOT NULL,
	[IsCommunicated] [bit] NOT NULL,
 CONSTRAINT [PK_ViolationReports] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ViolationReportSubjectTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ViolationReportSubjectTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_ViolationReportSubjectTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[ViolationReportUsers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[ViolationReportUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CityId] [int] NOT NULL,
 CONSTRAINT [PK_ViolationReportUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [cedo].[WorkItemSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cedo].[WorkItemSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BuildingGroupId] [int] NOT NULL,
	[Max] [int] NOT NULL,
	[WorkItem] [float] NOT NULL,
	[CityId] [int] NULL,
	[DossierTypeId] [int] NULL,
 CONSTRAINT [PK_WorkItemSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AttributePropertyValues]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributePropertyValues](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PropertyAttributeId] [int] NOT NULL,
	[PropertyName] [nvarchar](128) NOT NULL,
	[PropertyValue] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AttributePropertyValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BoundaryEvents]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BoundaryEvents](
	[Id] [int] NOT NULL,
	[BoundarySourceId] [int] NOT NULL,
 CONSTRAINT [PK_BoundaryEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CancelEvent]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CancelEvent](
	[Id] [int] NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[ConfirmMessage] [nvarchar](2048) NOT NULL,
 CONSTRAINT [PK_CancelEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ControllerActionCode]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControllerActionCode](
	[Id] [int] NOT NULL,
	[Code] [nvarchar](max) NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_ControllerActionCode] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ControllerActions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControllerActions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ControllerId] [int] NOT NULL,
	[ActionTypeId] [int] NOT NULL,
	[MethodName] [nvarchar](64) NOT NULL,
	[ActionName] [nvarchar](64) NULL,
	[Customized] [bit] NOT NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_ControllerActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ControllerActionTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControllerActionTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_ControllerActionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Controllers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Controllers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[ControllerTypeId] [int] NOT NULL,
	[EntityId] [int] NULL,
	[Name] [nvarchar](128) NULL,
	[Area] [nvarchar](128) NULL,
	[PartialCode] [nvarchar](max) NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_Controllers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ControllerTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ControllerTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_ControllerTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DashboardGadgets]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashboardGadgets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[GadgetViewId] [int] NULL,
	[Order] [int] NOT NULL,
	[Column] [int] NOT NULL,
	[Row] [int] NOT NULL,
	[ColumnSpan] [int] NOT NULL,
	[RowSpan] [int] NOT NULL,
 CONSTRAINT [PK_DashboardGadgets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataProtectionKeys]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataProtectionKeys](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](max) NULL,
	[Xml] [nvarchar](max) NULL,
 CONSTRAINT [PK_DataProtectionKeys] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataSourceDiagrams]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataSourceDiagrams](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DataSourceId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_DataSourceDiagrams] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataSourceEntities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataSourceEntities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectDataSourceId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[EntityName] [nvarchar](128) NOT NULL,
	[TableName] [nvarchar](128) NULL,
	[IsEnum] [bit] NOT NULL,
	[EntityDisplayCode] [nvarchar](max) NULL,
	[IsView] [bit] NOT NULL,
	[LastChanged] [datetime2](7) NULL,
	[GenerateDataServices] [bit] NOT NULL,
 CONSTRAINT [PK_DataSourceEntities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataSourceTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataSourceTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_DataSourceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DecisionTables]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DecisionTables](
	[Id] [uniqueidentifier] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[LastChanged] [datetime2](7) NULL,
	[ArchiveDateTime] [datetime2](7) NULL,
	[ArchiveComment] [nvarchar](max) NULL,
	[ArchivedById] [uniqueidentifier] NULL,
	[IsLocked] [bit] NOT NULL,
 CONSTRAINT [PK_DecisionTables] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DecisionTableTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DecisionTableTasks](
	[Id] [int] NOT NULL,
	[TableName] [nvarchar](256) NULL,
	[Script] [nvarchar](max) NULL,
	[DateScript] [nvarchar](max) NULL,
 CONSTRAINT [PK_DecisionTableTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiagramEntities]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiagramEntities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DiagramId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[Width] [int] NOT NULL,
	[Height] [int] NOT NULL,
 CONSTRAINT [PK_DiagramEntities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentIndices]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentIndices](
	[HelpId] [int] NOT NULL,
	[Title] [nvarchar](1024) NOT NULL,
	[Summary] [nvarchar](max) NULL,
	[Content] [nvarchar](max) NULL,
	[Order] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[ParentId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_DocumentIndices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailAccounts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailAccounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[SmtpServer] [nvarchar](512) NOT NULL,
	[SmtpServerPort] [int] NOT NULL,
	[UserName] [nvarchar](128) NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[From] [nvarchar](512) NOT NULL,
	[IsDefault] [bit] NOT NULL,
 CONSTRAINT [PK_EmailAccounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EntityProperties]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntityProperties](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectEntityId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Type] [nvarchar](128) NOT NULL,
	[CustomCode] [nvarchar](max) NULL,
	[LastChanged] [datetime2](7) NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_EntityProperties] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnumEntityItems]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnumEntityItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ItemValue] [nvarchar](128) NULL,
	[ItemDisplay] [nvarchar](128) NULL,
 CONSTRAINT [PK_EnumEntityItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorCatchEvent]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorCatchEvent](
	[Id] [int] NOT NULL,
	[ErrorType] [nvarchar](1024) NULL,
 CONSTRAINT [PK_ErrorCatchEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FirewallRules]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FirewallRules](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirewallId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DenyMessage] [nvarchar](2048) NULL,
	[IsActive] [bit] NOT NULL,
	[IsAllowed] [bit] NOT NULL,
	[IsCustom] [bit] NOT NULL,
	[Order] [int] NOT NULL,
	[RedirectToLogin] [bit] NULL,
 CONSTRAINT [PK_FirewallRules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Firewalls]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Firewalls](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[PreLoadRules] [bit] NOT NULL,
 CONSTRAINT [PK_Firewalls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowActors]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowActors](
	[Id] [uniqueidentifier] NOT NULL,
	[FlowVersionId] [int] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Color] [nvarchar](9) NULL,
	[LookupScript] [nvarchar](max) NULL,
	[Strategy] [int] NOT NULL,
	[Forwardable] [bit] NOT NULL,
 CONSTRAINT [PK_FlowActors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowConnectionType]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowConnectionType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_FlowConnectionType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowConnectors]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowConnectors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](128) NULL,
	[Order] [int] NOT NULL,
	[SourceNodeId] [int] NOT NULL,
	[ConnectionTypeId] [int] NOT NULL,
	[TargetNodeId] [int] NOT NULL,
	[DiagramLayoutSourcePort] [nvarchar](128) NULL,
	[DiagramLayoutTargetPort] [nvarchar](128) NULL,
	[ConditionScript] [nvarchar](max) NULL,
 CONSTRAINT [PK_FlowConnectors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowEventModes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowEventModes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_FlowEventModes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowEvents]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowEvents](
	[Id] [int] NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[EventModeId] [int] NOT NULL,
	[EventTriggerId] [int] NOT NULL,
 CONSTRAINT [PK_FlowEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowEventTriggers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowEventTriggers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_FlowEventTriggers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowEventTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowEventTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_FlowEventTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowGatewaies]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowGatewaies](
	[Id] [int] NOT NULL,
	[IsExclusive] [bit] NOT NULL,
	[WaitForIncomings] [bit] NOT NULL,
 CONSTRAINT [PK_FlowGatewaies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowInstanceLogs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowInstanceLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FlowInstanceId] [int] NOT NULL,
	[LogTypeId] [int] NOT NULL,
	[DateTime] [datetime2](7) NOT NULL,
	[Message] [nvarchar](max) NULL,
 CONSTRAINT [PK_FlowInstanceLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowInstancePauseLogs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowInstancePauseLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[InstanceId] [int] NOT NULL,
	[Time] [datetime2](7) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_FlowInstancePauseLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowInstanceStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowInstanceStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FlowInstanceStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowInstanceVariables]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowInstanceVariables](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FlowInstanceId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_FlowInstanceVariables] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowNodeLifeCycleEvents]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowNodeLifeCycleEvents](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NodeId] [int] NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[Script] [nvarchar](max) NULL,
 CONSTRAINT [PK_FlowNodeLifeCycleEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowNodeLifeCycleEventTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowNodeLifeCycleEventTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_FlowNodeLifeCycleEventTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowNodeTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowNodeTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_FlowNodeTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FlowStarterTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FlowStarterTasks](
	[Id] [int] NOT NULL,
	[FlowId] [int] NOT NULL,
	[StartupArgScript] [nvarchar](max) NULL,
 CONSTRAINT [PK_FlowStarterTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormEditTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormEditTasks](
	[Id] [int] NOT NULL,
	[UrlArgumentsScript] [nvarchar](max) NULL,
	[ViewUrlArgumentsScript] [nvarchar](max) NULL,
	[EditViewId] [int] NULL,
	[EditUrl] [nvarchar](2048) NULL,
	[ViewRecordViewId] [int] NULL,
	[ViewRecordUrl] [nvarchar](2048) NULL,
 CONSTRAINT [PK_FormEditTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormEntryTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormEntryTasks](
	[Id] [int] NOT NULL,
	[AddViewId] [int] NULL,
	[AddUrl] [nvarchar](2048) NULL,
	[ViewRecordViewId] [int] NULL,
	[ViewRecordUrl] [nvarchar](2048) NULL,
	[EditViewId] [int] NULL,
	[EditUrl] [nvarchar](2048) NULL,
	[UrlArgumentsScript] [nvarchar](max) NULL,
	[SingleRecord] [bit] NOT NULL,
 CONSTRAINT [PK_FormEntryTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncludedResources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncludedResources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Order] [int] NOT NULL,
	[Path] [nvarchar](1024) NOT NULL,
	[ResourceTypeId] [int] NOT NULL,
 CONSTRAINT [PK_IncludedResources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncludedResourceTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncludedResourceTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_IncludedResourceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InstanceUserGroupMembers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstanceUserGroupMembers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_InstanceUserGroupMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocalizablePhrases]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocalizablePhrases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Phrase] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_LocalizablePhrases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
 CONSTRAINT [PK_LogTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuItemExternalLinkSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuItemExternalLinkSettings](
	[Id] [int] NOT NULL,
	[Url] [nvarchar](1024) NULL,
	[ShowInNewTab] [bit] NOT NULL,
 CONSTRAINT [PK_MenuItemExternalLinkSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuItemFlowLinkSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuItemFlowLinkSettings](
	[Id] [int] NOT NULL,
	[FlowId] [int] NOT NULL,
 CONSTRAINT [PK_MenuItemFlowLinkSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuItems]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectMenuId] [int] NOT NULL,
	[ParentMenuItemId] [int] NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Order] [int] NOT NULL,
	[IconClass] [nvarchar](128) NULL,
	[ItemType] [int] NOT NULL,
	[Url] [nvarchar](2048) NULL,
	[TabOrWindow] [bit] NOT NULL,
 CONSTRAINT [PK_MenuItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuItemViewLinkSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuItemViewLinkSettings](
	[Id] [int] NOT NULL,
	[EntityViewId] [int] NOT NULL,
	[ShowInWindow] [bit] NOT NULL,
 CONSTRAINT [PK_MenuItemViewLinkSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MessageCatchEvents]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MessageCatchEvents](
	[Id] [int] NOT NULL,
	[MessageName] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_MessageCatchEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MessageThrowEvents]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MessageThrowEvents](
	[Id] [int] NOT NULL,
	[InstanceCode] [nvarchar](max) NULL,
	[MessageName] [nvarchar](200) NOT NULL,
	[VariabelsCode] [nvarchar](max) NULL,
 CONSTRAINT [PK_MessageThrowEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NodeAnnotationLayouts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NodeAnnotationLayouts](
	[Id] [int] NOT NULL,
	[Width] [float] NOT NULL,
	[Height] [float] NOT NULL,
	[OffsetX] [float] NOT NULL,
	[OffsetY] [float] NOT NULL,
 CONSTRAINT [PK_NodeAnnotationLayouts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NodeShapeStyles]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NodeShapeStyles](
	[Id] [int] NOT NULL,
	[Color] [nvarchar](max) NULL,
	[FillColor] [nvarchar](max) NULL,
	[BorderColor] [nvarchar](max) NULL,
	[BorderWidth] [real] NULL,
 CONSTRAINT [PK_NodeShapeStyles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NodeTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NodeTasks](
	[Id] [int] NOT NULL,
	[TaskTypeId] [int] NOT NULL,
 CONSTRAINT [PK_NodeTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationGroups]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_OrganizationGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationPosts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationPosts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[IsManagement] [bit] NOT NULL,
	[ParentId] [int] NOT NULL,
 CONSTRAINT [PK_OrganizationPosts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationUnits]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationUnits](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[IsManagementScope] [bit] NOT NULL,
	[ParentId] [int] NULL,
 CONSTRAINT [PK_OrganizationUnits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PageMetaTags]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PageMetaTags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Name] [nvarchar](256) NULL,
	[Content] [nvarchar](2048) NULL,
 CONSTRAINT [PK_PageMetaTags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARA-RoleClaims]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARA-RoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_PARA-RoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARA-Roles]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARA-Roles](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_PARA-Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARA-UserClaims]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARA-UserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_PARA-UserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARA-UserLogins]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARA-UserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PARA-UserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARA-UserRoles]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARA-UserRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PARA-UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PARA-UserTokens]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PARA-UserTokens](
	[UserId] [uniqueidentifier] NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_PARA-UserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonelDossiers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonelDossiers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PersonelId] [uniqueidentifier] NOT NULL,
	[WorkingStatusId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PersonelDossiers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonelGroups]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonelGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PersonelId] [uniqueidentifier] NOT NULL,
	[OrganizationGroupId] [int] NOT NULL,
 CONSTRAINT [PK_PersonelGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonelPosts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonelPosts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PersonelId] [uniqueidentifier] NOT NULL,
	[OrganizationPostId] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[EndDate] [datetime2](7) NULL,
 CONSTRAINT [PK_PersonelPosts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personels]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personels](
	[Id] [uniqueidentifier] NOT NULL,
	[PersonelCode] [nvarchar](64) NOT NULL,
	[EmploymentDate] [datetime2](7) NULL,
 CONSTRAINT [PK_Personels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PreviousSteps]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreviousSteps](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StepId] [int] NOT NULL,
	[PrevStepId] [int] NOT NULL,
 CONSTRAINT [PK_PreviousSteps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectCodeDirectories]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectCodeDirectories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[ParentDirectoryId] [int] NULL,
	[ProjectId] [int] NOT NULL,
 CONSTRAINT [PK_ProjectCodeDirectories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectCodeFiles]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectCodeFiles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[ParentDirectoryId] [int] NOT NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_ProjectCodeFiles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectDataSources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectDataSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[DataSourceName] [nvarchar](128) NULL,
	[DataSourceTypeId] [int] NOT NULL,
	[DefaultPkType] [nvarchar](128) NULL,
 CONSTRAINT [PK_ProjectDataSources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectHelps]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectHelps](
	[Id] [int] NOT NULL,
	[Summary] [nvarchar](max) NULL,
 CONSTRAINT [PK_ProjectHelps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectLoginSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectLoginSettings](
	[Id] [int] NOT NULL,
	[TwoFactorModeId] [int] NOT NULL,
 CONSTRAINT [PK_ProjectLoginSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectMenus]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectMenus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_ProjectMenus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectRecentDocuments]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectRecentDocuments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[DocType] [int] NOT NULL,
	[DocId] [nvarchar](128) NOT NULL,
	[SubId] [int] NULL,
	[DocTitle] [nvarchar](512) NOT NULL,
	[LastOpenedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ProjectRecentDocuments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Projects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](128) NOT NULL,
	[RouteParam] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NULL,
	[Namespace] [nvarchar](128) NULL,
	[DbSchema] [nvarchar](128) NULL,
	[LastDatabaseChange] [datetime2](7) NULL,
	[LastProjectBuild] [datetime2](7) NULL,
	[HomePageUrl] [nvarchar](2048) NULL,
	[ProjectVersion] [nvarchar](64) NULL,
	[Enabled] [bit] NOT NULL,
	[IsRuntime] [bit] NOT NULL,
	[Building] [bit] NOT NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectTranslations]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectTranslations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[CultureId] [int] NOT NULL,
	[LocalizablePhraseId] [int] NOT NULL,
	[Translation] [nvarchar](max) NULL,
 CONSTRAINT [PK_ProjectTranslations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectViews]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectViews](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[ViewWidget] [nvarchar](max) NULL,
	[LastModified] [datetime2](7) NOT NULL,
	[LastRequested] [datetime2](7) NULL,
	[LastDesigned] [datetime2](7) NULL,
	[LastPublished] [datetime2](7) NULL,
	[Customized] [bit] NOT NULL,
	[IsHomePage] [bit] NOT NULL,
	[ProjectId] [int] NOT NULL,
	[ViewTypeId] [int] NOT NULL,
	[LastChanged] [datetime2](7) NULL,
	[FileName] [nvarchar](128) NULL,
 CONSTRAINT [PK_ProjectViews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectWebPushSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectWebPushSettings](
	[Id] [int] NOT NULL,
	[VapidPublicKey] [nvarchar](1024) NOT NULL,
	[VapidPrivateKey] [nvarchar](1024) NOT NULL,
	[GcmSenderId] [nvarchar](1024) NOT NULL,
	[ReplyToAddress] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_ProjectWebPushSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropertyAttributes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropertyAttributes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityPropertyId] [int] NOT NULL,
	[AttributeType] [nvarchar](1024) NOT NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_PropertyAttributes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PwaPreCacheActions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PwaPreCacheActions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SettingId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
 CONSTRAINT [PK_PwaPreCacheActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PwaSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PwaSettings](
	[Id] [int] NOT NULL,
	[PwaEnabled] [bit] NOT NULL,
	[Name] [nvarchar](128) NULL,
	[ShortName] [nvarchar](128) NULL,
	[Description] [nvarchar](512) NULL,
	[BackgroundColor] [nvarchar](20) NULL,
	[ThemeColor] [nvarchar](20) NULL,
	[Direction] [nvarchar](4) NULL,
	[Display] [nvarchar](20) NULL,
	[Language] [nvarchar](20) NULL,
	[Orientation] [nvarchar](50) NULL,
	[CacheMode] [nvarchar](50) NULL,
 CONSTRAINT [PK_PwaSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PwaShortcutActions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PwaShortcutActions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SettingId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[Name] [nvarchar](128) NULL,
	[Description] [nvarchar](512) NULL,
 CONSTRAINT [PK_PwaShortcutActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleMenu]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleMenu](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MenuId] [int] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_RoleMenu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RuleDestinations]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleDestinations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[Url] [nvarchar](2048) NOT NULL,
	[Protocol] [nvarchar](10) NOT NULL,
	[Method] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_RuleDestinations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RuleDeviceSources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleDeviceSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[UserAgentFamily] [nvarchar](256) NULL,
	[OsFamily] [nvarchar](256) NULL,
	[DeviceFamily] [nvarchar](256) NULL,
	[IsNot] [bit] NOT NULL,
	[Mobile] [bit] NULL,
 CONSTRAINT [PK_RuleDeviceSources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RuleIdentitySources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleIdentitySources](
	[Id] [int] NOT NULL,
	[IsAuthenticated] [bit] NULL,
 CONSTRAINT [PK_RuleIdentitySources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RuleRoleSources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleRoleSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[IsNot] [bit] NOT NULL,
 CONSTRAINT [PK_RuleRoleSources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RuleSubnetSources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleSubnetSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[Subnet] [nvarchar](15) NOT NULL,
	[Length] [tinyint] NOT NULL,
	[IsNot] [bit] NOT NULL,
 CONSTRAINT [PK_RuleSubnetSources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RuleTimeSources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleTimeSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[StartDate] [datetime2](7) NULL,
	[StartTime] [time](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[EndTime] [time](7) NULL,
	[IsNot] [bit] NOT NULL,
 CONSTRAINT [PK_RuleTimeSources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RuleUserSources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleUserSources](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[IsNot] [bit] NOT NULL,
 CONSTRAINT [PK_RuleUserSources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScriptExecuteTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScriptExecuteTasks](
	[Id] [int] NOT NULL,
	[Script] [nvarchar](max) NULL,
 CONSTRAINT [PK_ScriptExecuteTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SendEmailTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SendEmailTasks](
	[Id] [int] NOT NULL,
	[EmailAccountId] [int] NULL,
	[ReceiverAddress] [nvarchar](max) NOT NULL,
	[Subject] [nvarchar](max) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_SendEmailTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SendSmsTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SendSmsTasks](
	[Id] [int] NOT NULL,
	[SmsAccountId] [int] NULL,
	[MobileNumber] [nvarchar](max) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_SendSmsTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SentSmses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SentSmses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SmsAccountId] [int] NOT NULL,
	[ReceiverNumber] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
 CONSTRAINT [PK_SentSmses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SmsAccounts]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmsAccounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Provider] [nvarchar](512) NOT NULL,
	[Number] [nvarchar](64) NOT NULL,
	[Username] [nvarchar](64) NOT NULL,
	[Password] [nvarchar](64) NOT NULL,
	[IsDefault] [bit] NOT NULL,
 CONSTRAINT [PK_SmsAccounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SolutionResources]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SolutionResources](
	[Id] [int] NOT NULL,
	[Migrations] [varbinary](max) NULL,
	[References] [varbinary](max) NULL,
	[Resources] [varbinary](max) NULL,
 CONSTRAINT [PK_SolutionResources] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SqlServerDataSourceConfigs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SqlServerDataSourceConfigs](
	[Id] [int] NOT NULL,
	[Server] [nvarchar](128) NOT NULL,
	[Database] [nvarchar](128) NOT NULL,
	[UserName] [nvarchar](128) NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SqlServerDataSourceConfigs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StepOwnerPools]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StepOwnerPools](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StepId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StepOwnerPools] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StepRecordDataLogs]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StepRecordDataLogs](
	[Id] [int] NOT NULL,
	[Log] [nvarchar](max) NULL,
 CONSTRAINT [PK_StepRecordDataLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupportedCultures]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportedCultures](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](5) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Default] [bit] NOT NULL,
 CONSTRAINT [PK_SupportedCultures] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UseDeveloperExceptionPage] [bit] NOT NULL,
	[UseHsts] [bit] NOT NULL,
	[UseHttpsRedirection] [bit] NOT NULL,
	[UseCors] [bit] NOT NULL,
	[LogWebServices] [bit] NOT NULL,
	[ErrorLogsMaxAge] [int] NOT NULL,
	[VisitStatsMaxAge] [int] NOT NULL,
	[WebServiceLogsMaxAge] [int] NOT NULL,
	[ApiSecretKey] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SystemSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TakenUserActions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TakenUserActions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ActionId] [int] NOT NULL,
	[StepId] [int] NOT NULL,
 CONSTRAINT [PK_TakenUserActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaskTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NULL,
	[Description] [nvarchar](512) NULL,
	[IsAutomated] [bit] NOT NULL,
	[ListOrder] [int] NOT NULL,
	[TaskIconType] [nvarchar](max) NULL,
 CONSTRAINT [PK_TaskTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Temp]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Temp](
	[Id] [int] NOT NULL,
	[A] [nvarchar](50) NULL,
	[B] [nvarchar](50) NULL,
	[C] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimerEvents]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimerEvents](
	[Id] [int] NOT NULL,
	[TimerTypeId] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[Hour] [int] NOT NULL,
	[Minute] [int] NOT NULL,
	[Second] [int] NOT NULL,
 CONSTRAINT [PK_TimerEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimerTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimerTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TimerTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TwoFactorModes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TwoFactorModes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TwoFactorModes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserActionTaskActions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserActionTaskActions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[UserActionTaskId] [int] NOT NULL,
	[Code] [int] NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_UserActionTaskActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserActionTasks]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserActionTasks](
	[Id] [int] NOT NULL,
	[ViewId] [int] NULL,
	[ViewUrl] [nvarchar](2048) NULL,
	[UrlArgumentsScript] [nvarchar](max) NULL,
	[RequireDescription] [bit] NULL,
 CONSTRAINT [PK_UserActionTasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ViewActions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ViewActions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ActionId] [int] NOT NULL,
	[ViewId] [int] NOT NULL,
 CONSTRAINT [PK_ViewActions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ViewComponents]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ViewComponents](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Code] [nvarchar](max) NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_ViewComponents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ViewComponentViews]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ViewComponentViews](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ViewComponentId] [int] NOT NULL,
	[ViewId] [int] NOT NULL,
 CONSTRAINT [PK_ViewComponentViews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ViewTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ViewTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[ForView] [bit] NOT NULL,
 CONSTRAINT [PK_ViewTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebPushSettings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebPushSettings](
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_WebPushSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebPushSubscriptions]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebPushSubscriptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WebPushSettingId] [uniqueidentifier] NOT NULL,
	[EndPoint] [nvarchar](max) NOT NULL,
	[Auth] [nvarchar](max) NULL,
	[P256dh] [nvarchar](max) NULL,
	[ExpirationTime] [datetime2](7) NULL,
 CONSTRAINT [PK_WebPushSubscriptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebServiceMethodRequestHeaders]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServiceMethodRequestHeaders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MethodId] [int] NOT NULL,
	[Header] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_WebServiceMethodRequestHeaders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebServiceMethodRouteArguments]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServiceMethodRouteArguments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MethodId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ClrDataType] [nvarchar](128) NOT NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_WebServiceMethodRouteArguments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebServiceMethods]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServiceMethods](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WebServiceId] [int] NOT NULL,
	[WebServiceMethodTypeId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Path] [nvarchar](1024) NULL,
	[ReturnClrType] [nvarchar](512) NULL,
	[BodyClrType] [nvarchar](512) NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_WebServiceMethods] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebServiceMethodTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServiceMethodTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_WebServiceMethodTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebServiceMethodUrlArguments]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServiceMethodUrlArguments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MethodId] [int] NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ClrDataType] [nvarchar](128) NOT NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_WebServiceMethodUrlArguments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebServices]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Url] [nvarchar](1024) NOT NULL,
	[ClientName] [nvarchar](128) NOT NULL,
	[WebServiceTypeId] [int] NOT NULL,
	[LastChanged] [datetime2](7) NULL,
 CONSTRAINT [PK_WebServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebServiceTypes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebServiceTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_WebServiceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkingStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkingStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
 CONSTRAINT [PK_WorkingStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[xpayment]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xpayment](
	[id] [int] NULL,
	[am] [bigint] NULL,
	[rem] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zzzzzzzzzz]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zzzzzzzzzz](
	[index] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [puyahlpdsk].[Departments]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [puyahlpdsk].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [puyahlpdsk].[DepartmentUsers]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [puyahlpdsk].[DepartmentUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[UserAccountId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DepartmentUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [puyahlpdsk].[Settings]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [puyahlpdsk].[Settings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NewTicketDescription] [nvarchar](max) NOT NULL,
	[NotifyUserBySms] [bit] NOT NULL,
	[NotifyHelpDeskBySms] [bit] NOT NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [puyahlpdsk].[SupportTickets]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [puyahlpdsk].[SupportTickets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[Subject] [nvarchar](512) NOT NULL,
	[TrackCode] [nvarchar](128) NULL,
 CONSTRAINT [PK_SupportTickets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [puyahlpdsk].[TicketReplies]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [puyahlpdsk].[TicketReplies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TicketId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[Content] [nvarchar](max) NOT NULL,
	[ReplyDate] [datetime2](7) NULL,
 CONSTRAINT [PK_TicketReplies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [puyahlpdsk].[TicketStatuses]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [puyahlpdsk].[TicketStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_TicketStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [cedo].[ArchitectureSafetyForms] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCopy]
GO
ALTER TABLE [cedo].[ArchitectureSpecForms] ADD  DEFAULT ((1)) FOR [ArchitectureQuality]
GO
ALTER TABLE [cedo].[ArchitectureSpecForms] ADD  DEFAULT ((1)) FOR [StandardArchitectureMaterials]
GO
ALTER TABLE [cedo].[AsBuiltRequest] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RegDate]
GO
ALTER TABLE [cedo].[Attendees] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CourseHoldingMemberId]
GO
ALTER TABLE [cedo].[BillDetailItems] ADD  DEFAULT ((0)) FOR [DiscountAmount]
GO
ALTER TABLE [cedo].[BillDetailItems] ADD  DEFAULT ((0)) FOR [TaxDiscount]
GO
ALTER TABLE [cedo].[BillDetailItems] ADD  DEFAULT ((0)) FOR [ToolDiscount]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [ContractDuration]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [GeoMinArea]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [GeoMinFloorCount]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [ManualSupervisorSelection]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [MinMetrajNeedsExecuter]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [MinMetraj]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((1)) FOR [SubGroupId]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((1)) FOR [ArchitechtureContractDuration]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((1)) FOR [ElectricityContractDuration]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [IsChangeDesigner]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((1)) FOR [MechanicContractDuration]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((1)) FOR [StructureContractDuration]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [ExecuterContractDuration]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [ExecuterMinContractAmount]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((5)) FOR [MinFloorsNeedsExecuter]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((5)) FOR [SupervisorCount]
GO
ALTER TABLE [cedo].[BuildingGroupSettings] ADD  DEFAULT ((0)) FOR [NeedsMechaniOrElectricity]
GO
ALTER TABLE [cedo].[BuildingWorkers] ADD  DEFAULT ((0)) FOR [InvolvedMemberId]
GO
ALTER TABLE [cedo].[CancelDossierBillDetails] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [PayedAmount]
GO
ALTER TABLE [cedo].[CapacityCalculations] ADD  DEFAULT ((8)) FOR [MaxWorkItem]
GO
ALTER TABLE [cedo].[CapacityCalculations] ADD  DEFAULT ((0)) FOR [Order]
GO
ALTER TABLE [cedo].[ChangeDesignerRequests] ADD  DEFAULT (CONVERT([bit],(0))) FOR [HasBuildingCertificate]
GO
ALTER TABLE [cedo].[ChangeDesignerRequests] ADD  DEFAULT ((0)) FOR [AsBuiltRequest]
GO
ALTER TABLE [cedo].[ChangeExecuterRequest] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [RemainingMetraje]
GO
ALTER TABLE [cedo].[ChangeExecuterRequest] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [RemainingWorkItem]
GO
ALTER TABLE [cedo].[ChangeExecuterRequest] ADD  DEFAULT ((0)) FOR [AsBuiltRequest]
GO
ALTER TABLE [cedo].[ChangeOwnerRequests] ADD  DEFAULT ((0)) FOR [BuildingProgress]
GO
ALTER TABLE [cedo].[ChangePlanRequests] ADD  DEFAULT ((0)) FOR [IsAfterBuildingCertificate]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsAfterBuildingCertificate]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RegDate]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] ADD  DEFAULT ((0)) FOR [AsBuiltRequest]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] ADD  DEFAULT ((0)) FOR [BuildingProgress]
GO
ALTER TABLE [cedo].[Cities] ADD  DEFAULT ((0)) FOR [IsSatellite]
GO
ALTER TABLE [cedo].[Cities] ADD  DEFAULT ((1)) FOR [IsSatelliteConfig]
GO
ALTER TABLE [cedo].[ComplaintCommunicateds] ADD  DEFAULT (N'') FOR [Subject]
GO
ALTER TABLE [cedo].[Complaints] ADD  DEFAULT (N'') FOR [ComplainerAddress]
GO
ALTER TABLE [cedo].[Complaints] ADD  DEFAULT (N'') FOR [ComplainerZipCode]
GO
ALTER TABLE [cedo].[Complaints] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ViolationDate]
GO
ALTER TABLE [cedo].[Complaints] ADD  DEFAULT (N'') FOR [ViolationPlace]
GO
ALTER TABLE [cedo].[ConstructionLicenseDescriptions] ADD  DEFAULT ((0)) FOR [DescriptionTypeId]
GO
ALTER TABLE [cedo].[ConstructionLicenseDescriptions] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RegDate]
GO
ALTER TABLE [cedo].[ConstructionLicenseGeoLabs] ADD  DEFAULT ((0)) FOR [DownHoleTest]
GO
ALTER TABLE [cedo].[ConstructionLicenses] ADD  DEFAULT ((0)) FOR [MaxAllowedFloorBase]
GO
ALTER TABLE [cedo].[ConstructionLicenses] ADD  DEFAULT ((1)) FOR [DossierTypeId]
GO
ALTER TABLE [cedo].[ContractExpandation] ADD  DEFAULT ((0)) FOR [ContractExpandationStatusId]
GO
ALTER TABLE [cedo].[ContractPaymentDetails] ADD  DEFAULT ((0)) FOR [ContractPaymentForId]
GO
ALTER TABLE [cedo].[Contracts] ADD  DEFAULT ((1)) FOR [StatusId]
GO
ALTER TABLE [cedo].[CostTypeDetails] ADD  DEFAULT ((0)) FOR [IsCoordinatorPayment]
GO
ALTER TABLE [cedo].[CourseExecutors] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ContractDate]
GO
ALTER TABLE [cedo].[Courses] ADD  DEFAULT (CONVERT([bit],(0))) FOR [HasExam]
GO
ALTER TABLE [cedo].[DossierBuildingGroupSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsManualSuperVisor]
GO
ALTER TABLE [cedo].[DossierBuildingGroupSettings] ADD  DEFAULT ((0)) FOR [IsChangeDesigner]
GO
ALTER TABLE [cedo].[DossierBuildingGroupSettings] ADD  DEFAULT ((0)) FOR [SupervisorCount]
GO
ALTER TABLE [cedo].[DossierCostSettings] ADD  DEFAULT ((0)) FOR [NeedExecuter]
GO
ALTER TABLE [cedo].[DossierCostSettings] ADD  DEFAULT ((0)) FOR [NeedGeoTechnic]
GO
ALTER TABLE [cedo].[DossierCostSettings] ADD  DEFAULT ((0)) FOR [NeedSurveyor]
GO
ALTER TABLE [cedo].[DossierCostSettings] ADD  DEFAULT ((0)) FOR [IsManualSuperVisor]
GO
ALTER TABLE [cedo].[ElectricitySafetyForms] ADD  DEFAULT ((0)) FOR [IsCopy]
GO
ALTER TABLE [cedo].[Elevators] ADD  DEFAULT ((1)) FOR [ExecutionQuality]
GO
ALTER TABLE [cedo].[Elevators] ADD  DEFAULT ((1)) FOR [StandardElevatorEquipment]
GO
ALTER TABLE [cedo].[EngServiceTariffDetailItems] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [SurveyorAmount]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [TechnicalAmount]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [ConcreteLabAmount]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [GeoTechnicAmount]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [TaxPercentage]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [TollPercentage]
GO
ALTER TABLE [cedo].[Estates] ADD  DEFAULT ('-') FOR [MainPlaque]
GO
ALTER TABLE [cedo].[Estates] ADD  DEFAULT ('-') FOR [SecondaryPlaque]
GO
ALTER TABLE [cedo].[Estates] ADD  DEFAULT ('-') FOR [PartPlaque]
GO
ALTER TABLE [cedo].[Estates] ADD  DEFAULT ('-') FOR [Street]
GO
ALTER TABLE [cedo].[Estates] ADD  DEFAULT ((1)) FOR [OwnershipDocumentTypeId]
GO
ALTER TABLE [cedo].[Examinations] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RegDate]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] ADD  DEFAULT ((0)) FOR [MemberTypeId]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsBulkMaker]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] ADD  DEFAULT ((0)) FOR [MaxProjectCount]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] ADD  DEFAULT ((1)) FOR [MemberShipTypeId]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] ADD  DEFAULT ((7)) FOR [ServiceTypeId]
GO
ALTER TABLE [cedo].[ExecuterContracts] ADD  DEFAULT ((0)) FOR [ManagerFund]
GO
ALTER TABLE [cedo].[ExecuterContracts] ADD  DEFAULT ((0)) FOR [ManagerFundGurantee]
GO
ALTER TABLE [cedo].[ExecuterContracts] ADD  DEFAULT ((0)) FOR [ManagerWage]
GO
ALTER TABLE [cedo].[ExecuterContracts] ADD  DEFAULT ((0)) FOR [ManagerWageGuarantee]
GO
ALTER TABLE [cedo].[ExecuterContracts] ADD  DEFAULT ((0)) FOR [ManagerWagePercent]
GO
ALTER TABLE [cedo].[ExecuterContractTermination] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsOwnerRequest]
GO
ALTER TABLE [cedo].[FacilityRequests] ADD  DEFAULT (CONVERT([bit],(0))) FOR [FacilityForWorkItem]
GO
ALTER TABLE [cedo].[FacilityRequests] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RegDate]
GO
ALTER TABLE [cedo].[FacilityRequests] ADD  DEFAULT ((0)) FOR [RequestForId]
GO
ALTER TABLE [cedo].[FacilityRequests] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [cedo].[FiscalBalances] ADD  DEFAULT ((0)) FOR [MemberId]
GO
ALTER TABLE [cedo].[FiscalBalances] ADD  DEFAULT ((0)) FOR [ServiceFieldId]
GO
ALTER TABLE [cedo].[Floors] ADD  DEFAULT ((1)) FOR [FloorRegisterStepId]
GO
ALTER TABLE [cedo].[GasRequestAuditForms] ADD  DEFAULT ((1)) FOR [Units]
GO
ALTER TABLE [cedo].[GasRequestOncallDescriptions] ADD  DEFAULT (N'') FOR [Description]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT ((0)) FOR [IsConnected]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT (N'') FOR [OwnerMobile]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT (N'') FOR [OwnerName]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceRequestId]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT (N'') FOR [Subscription]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT (N'') FOR [TrackCode]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT (N'') FOR [Address]
GO
ALTER TABLE [cedo].[GasRequestOncalls] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [cedo].[GasRequests] ADD  DEFAULT (CONVERT([real],(0))) FOR [LocationLat]
GO
ALTER TABLE [cedo].[GasRequests] ADD  DEFAULT (CONVERT([real],(0))) FOR [LocationLng]
GO
ALTER TABLE [cedo].[GasRequests] ADD  DEFAULT ((1)) FOR [StatusId]
GO
ALTER TABLE [cedo].[GasRequests] ADD  DEFAULT ((0)) FOR [IsFreeRequest]
GO
ALTER TABLE [cedo].[GasRequestSplitDocuments] ADD  DEFAULT ((1)) FOR [SheetNumber]
GO
ALTER TABLE [cedo].[GasRequestSplits] ADD  DEFAULT ((0)) FOR [Counters]
GO
ALTER TABLE [cedo].[GasRequestSplits] ADD  DEFAULT ((1)) FOR [Order]
GO
ALTER TABLE [cedo].[HoldingLessons] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [cedo].[HoldingLessons] ADD  DEFAULT ((0)) FOR [ReTuition]
GO
ALTER TABLE [cedo].[HoldingLessons] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ExamDate]
GO
ALTER TABLE [cedo].[IntroductionRequests] ADD  DEFAULT (N'') FOR [Receiver]
GO
ALTER TABLE [cedo].[IntroductionRequests] ADD  DEFAULT ((0)) FOR [TargetId]
GO
ALTER TABLE [cedo].[InvolvedMembers] ADD  DEFAULT ((0)) FOR [ModifiedWorkItem]
GO
ALTER TABLE [cedo].[InvolvedMembers] ADD  DEFAULT ((1)) FOR [InvolvedMemberTypeId]
GO
ALTER TABLE [cedo].[InvolvedMembers] ADD  DEFAULT ((0)) FOR [IsManualSelect]
GO
ALTER TABLE [cedo].[LicenseInqueries] ADD  DEFAULT ((1)) FOR [LicenseInqueryStatusId]
GO
ALTER TABLE [cedo].[LicenseInqueries] ADD  DEFAULT ((1)) FOR [DossierTypeId]
GO
ALTER TABLE [cedo].[LicenseInqueries] ADD  DEFAULT (N'') FOR [OwnerFullName]
GO
ALTER TABLE [cedo].[LicenseInqueries] ADD  DEFAULT ((0)) FOR [IsShahrdariService]
GO
ALTER TABLE [cedo].[ManpowerSkillCardValues] ADD  DEFAULT ((0)) FOR [ManpowerSkillCardId]
GO
ALTER TABLE [cedo].[MechanicalSpecForms] ADD  DEFAULT ((1)) FOR [MechanicalQuality]
GO
ALTER TABLE [cedo].[MechanicalSpecForms] ADD  DEFAULT ((1)) FOR [StandardMechanicalMaterials]
GO
ALTER TABLE [cedo].[MechanicSafetyForms] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCopy]
GO
ALTER TABLE [cedo].[MemberCapacities] ADD  DEFAULT (CONVERT([real],(0))) FOR [RemainingMetraj]
GO
ALTER TABLE [cedo].[MemberCapacities] ADD  DEFAULT (CONVERT([real],(0))) FOR [RemainingWorkItem]
GO
ALTER TABLE [cedo].[MemberCapacities] ADD  DEFAULT (CONVERT([real],(0))) FOR [TotalWorkItem]
GO
ALTER TABLE [cedo].[MemberCapacities] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [LastSync]
GO
ALTER TABLE [cedo].[MemberCapacities] ADD  DEFAULT ((0)) FOR [CityId]
GO
ALTER TABLE [cedo].[MemberCapacities] ADD  DEFAULT ((1400)) FOR [Year]
GO
ALTER TABLE [cedo].[MemberCapacityDetails] ADD  DEFAULT ((1)) FOR [BuildingSubGroupId]
GO
ALTER TABLE [cedo].[MemberCapacityDetails] ADD  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [cedo].[Members] ADD  DEFAULT ((1)) FOR [MemberShipTypeId]
GO
ALTER TABLE [cedo].[Owners] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [BirthDate]
GO
ALTER TABLE [cedo].[Owners] ADD  DEFAULT (N'') FOR [IdNumber]
GO
ALTER TABLE [cedo].[Owners] ADD  DEFAULT ((0)) FOR [IsCahnged]
GO
ALTER TABLE [cedo].[Owners] ADD  DEFAULT ((0)) FOR [IsMainPossessor]
GO
ALTER TABLE [cedo].[PaymentReceipts] ADD  DEFAULT ((1)) FOR [PaymentTypeId]
GO
ALTER TABLE [cedo].[PlanControls] ADD  DEFAULT ((0)) FOR [IsChangePlanControl]
GO
ALTER TABLE [cedo].[PlanControlSettings] ADD  DEFAULT ((1)) FOR [ServiceTypeId]
GO
ALTER TABLE [cedo].[Sentences] ADD  DEFAULT (N'') FOR [JudgmentLetterNumber]
GO
ALTER TABLE [cedo].[SeparationPlanRequests] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [cedo].[SeparationPlanRequests] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RegDate]
GO
ALTER TABLE [cedo].[SeparationPlanRequests] ADD  DEFAULT ((1)) FOR [ScopeRequestTypeId]
GO
ALTER TABLE [cedo].[SeparationPlanRequests] ADD  DEFAULT ((0)) FOR [CityId]
GO
ALTER TABLE [cedo].[SeparationRequestSurveies] ADD  DEFAULT (CONVERT([bit],(0))) FOR [MunicipalityResponse]
GO
ALTER TABLE [cedo].[SeparationRequestSurveies] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCommercial]
GO
ALTER TABLE [cedo].[Signatories] ADD  DEFAULT (N'') FOR [Position]
GO
ALTER TABLE [cedo].[StructureSafetyForms] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCopy]
GO
ALTER TABLE [cedo].[SupervisionFields] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SupervisionOrderId]
GO
ALTER TABLE [cedo].[SupervisionFields] ADD  DEFAULT ((0)) FOR [MinGradeId]
GO
ALTER TABLE [cedo].[SupervisionOrders] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RegDate]
GO
ALTER TABLE [cedo].[SupervisionOrders] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [cedo].[SupervisionStepForms] ADD  DEFAULT ((0)) FOR [IsCopy]
GO
ALTER TABLE [cedo].[SupervisionStepPayments] ADD  DEFAULT ((1)) FOR [PaymentStatusId]
GO
ALTER TABLE [cedo].[SupervisionStepPayments] ADD  DEFAULT ((0)) FOR [RemainingAmount]
GO
ALTER TABLE [cedo].[SupervisionStepPayments] ADD  DEFAULT ((0)) FOR [PaymentPercent]
GO
ALTER TABLE [cedo].[SupervisionSteps] ADD  DEFAULT ((0)) FOR [CoordinatorPaymentPercent]
GO
ALTER TABLE [cedo].[SupervisionSteps] ADD  DEFAULT ((0)) FOR [SupervisorPaymentPercent]
GO
ALTER TABLE [cedo].[SupervisionSteps] ADD  DEFAULT ((0)) FOR [FormNumber]
GO
ALTER TABLE [cedo].[TempInvolvedMember] ADD  CONSTRAINT [DF__TempInvol__IsSen__31AD415B]  DEFAULT ((0)) FOR [IsSent]
GO
ALTER TABLE [cedo].[ViolationReports] ADD  DEFAULT ((0)) FOR [IsCheckedOut]
GO
ALTER TABLE [cedo].[ViolationReports] ADD  DEFAULT ((0)) FOR [IsCommunicated]
GO
ALTER TABLE [dbo].[DataSourceEntities] ADD  DEFAULT (N'') FOR [EntityName]
GO
ALTER TABLE [dbo].[DataSourceEntities] ADD  DEFAULT (CONVERT([bit],(0))) FOR [GenerateDataServices]
GO
ALTER TABLE [dbo].[DecisionTables] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsLocked]
GO
ALTER TABLE [dbo].[DocumentIndices] ADD  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[EntityProperties] ADD  DEFAULT (N'') FOR [Name]
GO
ALTER TABLE [dbo].[EntityProperties] ADD  DEFAULT ((0)) FOR [Order]
GO
ALTER TABLE [dbo].[FlowActors] ADD  DEFAULT ((0)) FOR [Strategy]
GO
ALTER TABLE [dbo].[FlowActors] ADD  DEFAULT (CONVERT([bit],(0))) FOR [Forwardable]
GO
ALTER TABLE [dbo].[FlowEvents] ADD  DEFAULT ((1)) FOR [EventTriggerId]
GO
ALTER TABLE [dbo].[FlowNodes] ADD  DEFAULT ((0)) FOR [FlowVersionId]
GO
ALTER TABLE [dbo].[MessageThrowEvents] ADD  DEFAULT (N'') FOR [MessageName]
GO
ALTER TABLE [dbo].[PARA-Users] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [RefreshTokenExpiryTime]
GO
ALTER TABLE [dbo].[ProjectDataSources] ADD  DEFAULT ((1)) FOR [DataSourceTypeId]
GO
ALTER TABLE [dbo].[ProjectMenus] ADD  DEFAULT ((0)) FOR [Order]
GO
ALTER TABLE [dbo].[ProjectRecentDocuments] ADD  DEFAULT (N'') FOR [DocTitle]
GO
ALTER TABLE [dbo].[Projects] ADD  DEFAULT ((1)) FOR [Enabled]
GO
ALTER TABLE [dbo].[Projects] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsRuntime]
GO
ALTER TABLE [dbo].[Projects] ADD  DEFAULT (CONVERT([bit],(0))) FOR [Building]
GO
ALTER TABLE [dbo].[SystemSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [UseCors]
GO
ALTER TABLE [dbo].[SystemSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [LogWebServices]
GO
ALTER TABLE [dbo].[SystemSettings] ADD  DEFAULT ((14)) FOR [ErrorLogsMaxAge]
GO
ALTER TABLE [dbo].[SystemSettings] ADD  DEFAULT ((730)) FOR [VisitStatsMaxAge]
GO
ALTER TABLE [dbo].[SystemSettings] ADD  DEFAULT ((30)) FOR [WebServiceLogsMaxAge]
GO
ALTER TABLE [dbo].[SystemSettings] ADD  DEFAULT ('PUYA.BPMS.Api.SecretCode') FOR [ApiSecretKey]
GO
ALTER TABLE [dbo].[UserActionTaskActions] ADD  DEFAULT (N'') FOR [Title]
GO
ALTER TABLE [dbo].[UserActionTaskActions] ADD  DEFAULT ((0)) FOR [Order]
GO
ALTER TABLE [cedo].[ActivityLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ActivityLicenses_Cities_IssuedCityId] FOREIGN KEY([IssuedCityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[ActivityLicenses] CHECK CONSTRAINT [FK_ActivityLicenses_Cities_IssuedCityId]
GO
ALTER TABLE [cedo].[ActivityLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ActivityLicenses_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ActivityLicenses] CHECK CONSTRAINT [FK_ActivityLicenses_Members_MemberId]
GO
ALTER TABLE [cedo].[ActivityTransferRequests]  WITH CHECK ADD  CONSTRAINT [FK_ActivityTransferRequests_ActivityTransferRequestStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ActivityTransferRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ActivityTransferRequests] CHECK CONSTRAINT [FK_ActivityTransferRequests_ActivityTransferRequestStatuses_StatusId]
GO
ALTER TABLE [cedo].[ActivityTransferRequests]  WITH CHECK ADD  CONSTRAINT [FK_ActivityTransferRequests_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[ActivityTransferRequests] CHECK CONSTRAINT [FK_ActivityTransferRequests_Cities_CityId]
GO
ALTER TABLE [cedo].[ActivityTransferRequests]  WITH CHECK ADD  CONSTRAINT [FK_ActivityTransferRequests_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ActivityTransferRequests] CHECK CONSTRAINT [FK_ActivityTransferRequests_Members_MemberId]
GO
ALTER TABLE [cedo].[AdditionalSupervisionFields]  WITH CHECK ADD  CONSTRAINT [FK_AdditionalSupervisionFields_ServiceFields_FieldId] FOREIGN KEY([FieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[AdditionalSupervisionFields] CHECK CONSTRAINT [FK_AdditionalSupervisionFields_ServiceFields_FieldId]
GO
ALTER TABLE [cedo].[AdditionalSupervisionFields]  WITH CHECK ADD  CONSTRAINT [FK_AdditionalSupervisionFields_SupervisionFields_SupervisionFieldId] FOREIGN KEY([SupervisionFieldId])
REFERENCES [cedo].[SupervisionFields] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[AdditionalSupervisionFields] CHECK CONSTRAINT [FK_AdditionalSupervisionFields_SupervisionFields_SupervisionFieldId]
GO
ALTER TABLE [cedo].[ArchitectureExecutiveOperationsForms]  WITH CHECK ADD  CONSTRAINT [FK_ArchitectureExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ArchitectureExecutiveOperationsForms] CHECK CONSTRAINT [FK_ArchitectureExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ArchitecturePlanControlForms]  WITH CHECK ADD  CONSTRAINT [FK_ArchitecturePlanControlForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ArchitecturePlanControlForms] CHECK CONSTRAINT [FK_ArchitecturePlanControlForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ArchitectureRedLinesForms]  WITH CHECK ADD  CONSTRAINT [FK_ArchitectureRedLinesForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ArchitectureRedLinesForms] CHECK CONSTRAINT [FK_ArchitectureRedLinesForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ArchitectureSafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_ArchitectureSafetyForms_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ArchitectureSafetyForms] CHECK CONSTRAINT [FK_ArchitectureSafetyForms_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ArchitectureSafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_ArchitectureSafetyForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ArchitectureSafetyForms] CHECK CONSTRAINT [FK_ArchitectureSafetyForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ArchitectureSpecForms]  WITH CHECK ADD  CONSTRAINT [FK_ArchitectureSpecForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ArchitectureSpecForms] CHECK CONSTRAINT [FK_ArchitectureSpecForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[AsBuiltRequest]  WITH CHECK ADD  CONSTRAINT [FK_AsBuiltRequest_AsBuiltRequestStatus_StatusIdId] FOREIGN KEY([StatusIdId])
REFERENCES [cedo].[AsBuiltRequestStatus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[AsBuiltRequest] CHECK CONSTRAINT [FK_AsBuiltRequest_AsBuiltRequestStatus_StatusIdId]
GO
ALTER TABLE [cedo].[AsBuiltRequest]  WITH CHECK ADD  CONSTRAINT [FK_AsBuiltRequest_BuildingGroupSettings_FinalBuildingGroupId] FOREIGN KEY([FinalBuildingGroupId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
GO
ALTER TABLE [cedo].[AsBuiltRequest] CHECK CONSTRAINT [FK_AsBuiltRequest_BuildingGroupSettings_FinalBuildingGroupId]
GO
ALTER TABLE [cedo].[AsBuiltRequest]  WITH CHECK ADD  CONSTRAINT [FK_AsBuiltRequest_BuildingGroupSettings_IntialBuildingGroupSettingId] FOREIGN KEY([IntialBuildingGroupSettingId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
GO
ALTER TABLE [cedo].[AsBuiltRequest] CHECK CONSTRAINT [FK_AsBuiltRequest_BuildingGroupSettings_IntialBuildingGroupSettingId]
GO
ALTER TABLE [cedo].[AsBuiltRequest]  WITH CHECK ADD  CONSTRAINT [FK_AsBuiltRequest_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[AsBuiltRequest] CHECK CONSTRAINT [FK_AsBuiltRequest_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[AttendeeOptions]  WITH CHECK ADD  CONSTRAINT [FK_AttendeeOptions_Attendees_AttendeeId] FOREIGN KEY([AttendeeId])
REFERENCES [cedo].[Attendees] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[AttendeeOptions] CHECK CONSTRAINT [FK_AttendeeOptions_Attendees_AttendeeId]
GO
ALTER TABLE [cedo].[AttendeeOptions]  WITH CHECK ADD  CONSTRAINT [FK_AttendeeOptions_HoldingLessonOptions_OptionId] FOREIGN KEY([OptionId])
REFERENCES [cedo].[HoldingLessonOptions] ([Id])
GO
ALTER TABLE [cedo].[AttendeeOptions] CHECK CONSTRAINT [FK_AttendeeOptions_HoldingLessonOptions_OptionId]
GO
ALTER TABLE [cedo].[Attendees]  WITH CHECK ADD  CONSTRAINT [FK_Attendees_AttendeeStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[AttendeeStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Attendees] CHECK CONSTRAINT [FK_Attendees_AttendeeStatuses_StatusId]
GO
ALTER TABLE [cedo].[Attendees]  WITH CHECK ADD  CONSTRAINT [FK_Attendees_CourseHoldingMembers_CourseHoldingMemberId] FOREIGN KEY([CourseHoldingMemberId])
REFERENCES [cedo].[CourseHoldingMembers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Attendees] CHECK CONSTRAINT [FK_Attendees_CourseHoldingMembers_CourseHoldingMemberId]
GO
ALTER TABLE [cedo].[Attendees]  WITH CHECK ADD  CONSTRAINT [FK_Attendees_HoldingLessons_HoldingLessonId] FOREIGN KEY([HoldingLessonId])
REFERENCES [cedo].[HoldingLessons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Attendees] CHECK CONSTRAINT [FK_Attendees_HoldingLessons_HoldingLessonId]
GO
ALTER TABLE [cedo].[AttendeeSessions]  WITH CHECK ADD  CONSTRAINT [FK_AttendeeSessions_Attendees_AttendeeId] FOREIGN KEY([AttendeeId])
REFERENCES [cedo].[Attendees] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[AttendeeSessions] CHECK CONSTRAINT [FK_AttendeeSessions_Attendees_AttendeeId]
GO
ALTER TABLE [cedo].[AttendeeSessions]  WITH CHECK ADD  CONSTRAINT [FK_AttendeeSessions_AttendeeSessionStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[AttendeeSessionStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[AttendeeSessions] CHECK CONSTRAINT [FK_AttendeeSessions_AttendeeSessionStatuses_StatusId]
GO
ALTER TABLE [cedo].[AttendeeSessions]  WITH CHECK ADD  CONSTRAINT [FK_AttendeeSessions_HoldingLessonSessions_SessionId] FOREIGN KEY([SessionId])
REFERENCES [cedo].[HoldingLessonSessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[AttendeeSessions] CHECK CONSTRAINT [FK_AttendeeSessions_HoldingLessonSessions_SessionId]
GO
ALTER TABLE [cedo].[BillDetailItems]  WITH CHECK ADD  CONSTRAINT [FK_BillDetailItems_BillDetails_BillDetailId] FOREIGN KEY([BillDetailId])
REFERENCES [cedo].[BillDetails] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BillDetailItems] CHECK CONSTRAINT [FK_BillDetailItems_BillDetails_BillDetailId]
GO
ALTER TABLE [cedo].[BillDetailItems]  WITH CHECK ADD  CONSTRAINT [FK_BillDetailItems_EngServiceTariffDetailItems_TariffDetailItemId] FOREIGN KEY([TariffDetailItemId])
REFERENCES [cedo].[EngServiceTariffDetailItems] ([Id])
GO
ALTER TABLE [cedo].[BillDetailItems] CHECK CONSTRAINT [FK_BillDetailItems_EngServiceTariffDetailItems_TariffDetailItemId]
GO
ALTER TABLE [cedo].[BillDetails]  WITH CHECK ADD  CONSTRAINT [FK_BillDetails_Bills_BillId] FOREIGN KEY([BillId])
REFERENCES [cedo].[Bills] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BillDetails] CHECK CONSTRAINT [FK_BillDetails_Bills_BillId]
GO
ALTER TABLE [cedo].[BillDetails]  WITH CHECK ADD  CONSTRAINT [FK_BillDetails_CostTypes_CostTypeId] FOREIGN KEY([CostTypeId])
REFERENCES [cedo].[CostTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BillDetails] CHECK CONSTRAINT [FK_BillDetails_CostTypes_CostTypeId]
GO
ALTER TABLE [cedo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_BillTypes_BillTypeId] FOREIGN KEY([BillTypeId])
REFERENCES [cedo].[BillTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Bills] CHECK CONSTRAINT [FK_Bills_BillTypes_BillTypeId]
GO
ALTER TABLE [cedo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
GO
ALTER TABLE [cedo].[Bills] CHECK CONSTRAINT [FK_Bills_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_CourseHoldingMembers_CourseHoldingMemberId] FOREIGN KEY([CourseHoldingMemberId])
REFERENCES [cedo].[CourseHoldingMembers] ([Id])
GO
ALTER TABLE [cedo].[Bills] CHECK CONSTRAINT [FK_Bills_CourseHoldingMembers_CourseHoldingMemberId]
GO
ALTER TABLE [cedo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_GasRequestOncalls_GasRequestOncallId] FOREIGN KEY([GasRequestOncallId])
REFERENCES [cedo].[GasRequestOncalls] ([Id])
GO
ALTER TABLE [cedo].[Bills] CHECK CONSTRAINT [FK_Bills_GasRequestOncalls_GasRequestOncallId]
GO
ALTER TABLE [cedo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_GasRequests_GasRequestId] FOREIGN KEY([GasRequestId])
REFERENCES [cedo].[GasRequests] ([Id])
GO
ALTER TABLE [cedo].[Bills] CHECK CONSTRAINT [FK_Bills_GasRequests_GasRequestId]
GO
ALTER TABLE [cedo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_SeparationPlanRequests_SeparationRequestId] FOREIGN KEY([SeparationRequestId])
REFERENCES [cedo].[SeparationPlanRequests] ([Id])
GO
ALTER TABLE [cedo].[Bills] CHECK CONSTRAINT [FK_Bills_SeparationPlanRequests_SeparationRequestId]
GO
ALTER TABLE [cedo].[BuildingCertificates]  WITH CHECK ADD  CONSTRAINT [FK_BuildingCertificates_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BuildingCertificates] CHECK CONSTRAINT [FK_BuildingCertificates_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[BuildingCertificates]  WITH CHECK ADD  CONSTRAINT [FK_BuildingCertificates_ConstructionLicenseTypes_ConstructionLicenseTypeId] FOREIGN KEY([ConstructionLicenseTypeId])
REFERENCES [cedo].[ConstructionLicenseTypes] ([Id])
GO
ALTER TABLE [cedo].[BuildingCertificates] CHECK CONSTRAINT [FK_BuildingCertificates_ConstructionLicenseTypes_ConstructionLicenseTypeId]
GO
ALTER TABLE [cedo].[BuildingGroupSettingCities]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettingCities_BuildingGroupSettings_BuildingGroupSettingId] FOREIGN KEY([BuildingGroupSettingId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BuildingGroupSettingCities] CHECK CONSTRAINT [FK_BuildingGroupSettingCities_BuildingGroupSettings_BuildingGroupSettingId]
GO
ALTER TABLE [cedo].[BuildingGroupSettingCities]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettingCities_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[BuildingGroupSettingCities] CHECK CONSTRAINT [FK_BuildingGroupSettingCities_Cities_CityId]
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettingRatios_BuildingGroupSettings_BuildingGroupSettingId] FOREIGN KEY([BuildingGroupSettingId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios] CHECK CONSTRAINT [FK_BuildingGroupSettingRatios_BuildingGroupSettings_BuildingGroupSettingId]
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettingRatios_LegalMemberTypes_MemberTypeId] FOREIGN KEY([MemberTypeId])
REFERENCES [cedo].[LegalMemberTypes] ([Id])
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios] CHECK CONSTRAINT [FK_BuildingGroupSettingRatios_LegalMemberTypes_MemberTypeId]
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettingRatios_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios] CHECK CONSTRAINT [FK_BuildingGroupSettingRatios_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettingRatios_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[BuildingGroupSettingRatios] CHECK CONSTRAINT [FK_BuildingGroupSettingRatios_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[BuildingGroupSettings]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettings_BuildingSubGroups_SubGroupId] FOREIGN KEY([SubGroupId])
REFERENCES [cedo].[BuildingSubGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BuildingGroupSettings] CHECK CONSTRAINT [FK_BuildingGroupSettings_BuildingSubGroups_SubGroupId]
GO
ALTER TABLE [cedo].[BuildingGroupSettings]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettings_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
GO
ALTER TABLE [cedo].[BuildingGroupSettings] CHECK CONSTRAINT [FK_BuildingGroupSettings_DossierType_DossierTypeId]
GO
ALTER TABLE [cedo].[BuildingGroupSettings]  WITH CHECK ADD  CONSTRAINT [FK_BuildingGroupSettings_Municipalities_MunicipalityId] FOREIGN KEY([MunicipalityId])
REFERENCES [cedo].[Municipalities] ([Id])
GO
ALTER TABLE [cedo].[BuildingGroupSettings] CHECK CONSTRAINT [FK_BuildingGroupSettings_Municipalities_MunicipalityId]
GO
ALTER TABLE [cedo].[BuildingSubGroups]  WITH CHECK ADD  CONSTRAINT [FK_BuildingSubGroups_BuildingGroups_BuildingGroupId] FOREIGN KEY([BuildingGroupId])
REFERENCES [cedo].[BuildingGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BuildingSubGroups] CHECK CONSTRAINT [FK_BuildingSubGroups_BuildingGroups_BuildingGroupId]
GO
ALTER TABLE [cedo].[BuildingUnits]  WITH CHECK ADD  CONSTRAINT [FK_BuildingUnits_Floors_FloorId] FOREIGN KEY([FloorId])
REFERENCES [cedo].[Floors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[BuildingUnits] CHECK CONSTRAINT [FK_BuildingUnits_Floors_FloorId]
GO
ALTER TABLE [cedo].[BuildingUnits]  WITH CHECK ADD  CONSTRAINT [FK_BuildingUnits_UsageTypes_UsageTypeId] FOREIGN KEY([UsageTypeId])
REFERENCES [cedo].[UsageTypes] ([Id])
GO
ALTER TABLE [cedo].[BuildingUnits] CHECK CONSTRAINT [FK_BuildingUnits_UsageTypes_UsageTypeId]
GO
ALTER TABLE [cedo].[BuildingWorkers]  WITH CHECK ADD  CONSTRAINT [FK_BuildingWorkers_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[BuildingWorkers] CHECK CONSTRAINT [FK_BuildingWorkers_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[CancelDossierBillDetails]  WITH CHECK ADD  CONSTRAINT [FK_CancelDossierBillDetails_CancelDossierBills_CancelDossierBillId] FOREIGN KEY([CancelDossierBillId])
REFERENCES [cedo].[CancelDossierBills] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CancelDossierBillDetails] CHECK CONSTRAINT [FK_CancelDossierBillDetails_CancelDossierBills_CancelDossierBillId]
GO
ALTER TABLE [cedo].[CancelDossierBillDetails]  WITH CHECK ADD  CONSTRAINT [FK_CancelDossierBillDetails_CostTypes_CostTypeId] FOREIGN KEY([CostTypeId])
REFERENCES [cedo].[CostTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CancelDossierBillDetails] CHECK CONSTRAINT [FK_CancelDossierBillDetails_CostTypes_CostTypeId]
GO
ALTER TABLE [cedo].[CancelDossierBills]  WITH CHECK ADD  CONSTRAINT [FK_CancelDossierBills_CancelDossierRequests_CancelDossierRequestId] FOREIGN KEY([CancelDossierRequestId])
REFERENCES [cedo].[CancelDossierRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CancelDossierBills] CHECK CONSTRAINT [FK_CancelDossierBills_CancelDossierRequests_CancelDossierRequestId]
GO
ALTER TABLE [cedo].[CancelDossierRequests]  WITH CHECK ADD  CONSTRAINT [FK_CancelDossierRequests_CancelDossierStatuses_RequestStatusId] FOREIGN KEY([RequestStatusId])
REFERENCES [cedo].[CancelDossierStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CancelDossierRequests] CHECK CONSTRAINT [FK_CancelDossierRequests_CancelDossierStatuses_RequestStatusId]
GO
ALTER TABLE [cedo].[CancelDossierRequests]  WITH CHECK ADD  CONSTRAINT [FK_CancelDossierRequests_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CancelDossierRequests] CHECK CONSTRAINT [FK_CancelDossierRequests_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[CapacityCalculations]  WITH CHECK ADD  CONSTRAINT [FK_CapacityCalculations_BuildingGroupSettings_BuildingGroupSettingId] FOREIGN KEY([BuildingGroupSettingId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CapacityCalculations] CHECK CONSTRAINT [FK_CapacityCalculations_BuildingGroupSettings_BuildingGroupSettingId]
GO
ALTER TABLE [cedo].[CapacityCalculations]  WITH CHECK ADD  CONSTRAINT [FK_CapacityCalculations_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[CapacityCalculations] CHECK CONSTRAINT [FK_CapacityCalculations_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[CapacityCalculations]  WITH CHECK ADD  CONSTRAINT [FK_CapacityCalculations_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CapacityCalculations] CHECK CONSTRAINT [FK_CapacityCalculations_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[CedoAgencyCities]  WITH CHECK ADD  CONSTRAINT [FK_CedoAgencyCities_CedoAgencies_AgencyId] FOREIGN KEY([AgencyId])
REFERENCES [cedo].[CedoAgencies] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CedoAgencyCities] CHECK CONSTRAINT [FK_CedoAgencyCities_CedoAgencies_AgencyId]
GO
ALTER TABLE [cedo].[CedoAgencyCities]  WITH CHECK ADD  CONSTRAINT [FK_CedoAgencyCities_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CedoAgencyCities] CHECK CONSTRAINT [FK_CedoAgencyCities_Cities_CityId]
GO
ALTER TABLE [cedo].[ChangeDesignerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeDesignerRequests_ChangeDesignerRequestStatuses_RequestStatusId] FOREIGN KEY([RequestStatusId])
REFERENCES [cedo].[ChangeDesignerRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeDesignerRequests] CHECK CONSTRAINT [FK_ChangeDesignerRequests_ChangeDesignerRequestStatuses_RequestStatusId]
GO
ALTER TABLE [cedo].[ChangeDesignerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeDesignerRequests_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeDesignerRequests] CHECK CONSTRAINT [FK_ChangeDesignerRequests_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ChangeDesignerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeDesignerRequests_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ChangeDesignerRequests] CHECK CONSTRAINT [FK_ChangeDesignerRequests_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ChangeDesignerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeDesignerRequests_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[ChangeDesignerRequests] CHECK CONSTRAINT [FK_ChangeDesignerRequests_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[ChangeDesignerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeDesignerRequests_ServiceRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
GO
ALTER TABLE [cedo].[ChangeDesignerRequests] CHECK CONSTRAINT [FK_ChangeDesignerRequests_ServiceRequests_RequestId]
GO
ALTER TABLE [cedo].[ChangeExecuterRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeExecuterRequest_ChangeExecuterRequestStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ChangeExecuterRequestStatus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeExecuterRequest] CHECK CONSTRAINT [FK_ChangeExecuterRequest_ChangeExecuterRequestStatus_StatusId]
GO
ALTER TABLE [cedo].[ChangeExecuterRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeExecuterRequest_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeExecuterRequest] CHECK CONSTRAINT [FK_ChangeExecuterRequest_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ChangeExecuterRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeExecuterRequest_ServiceRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
GO
ALTER TABLE [cedo].[ChangeExecuterRequest] CHECK CONSTRAINT [FK_ChangeExecuterRequest_ServiceRequests_RequestId]
GO
ALTER TABLE [cedo].[ChangeOwnerRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_ChangeOwnerRequestDetails_ChangeOwnerRequests_ChangeOwnerRequestId] FOREIGN KEY([ChangeOwnerRequestId])
REFERENCES [cedo].[ChangeOwnerRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeOwnerRequestDetails] CHECK CONSTRAINT [FK_ChangeOwnerRequestDetails_ChangeOwnerRequests_ChangeOwnerRequestId]
GO
ALTER TABLE [cedo].[ChangeOwnerRequestDetails]  WITH CHECK ADD  CONSTRAINT [FK_ChangeOwnerRequestDetails_Owners_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [cedo].[Owners] ([Id])
GO
ALTER TABLE [cedo].[ChangeOwnerRequestDetails] CHECK CONSTRAINT [FK_ChangeOwnerRequestDetails_Owners_OwnerId]
GO
ALTER TABLE [cedo].[ChangeOwnerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeOwnerRequests_ChangeOwnerStatuses_RequestStatusId] FOREIGN KEY([RequestStatusId])
REFERENCES [cedo].[ChangeOwnerStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeOwnerRequests] CHECK CONSTRAINT [FK_ChangeOwnerRequests_ChangeOwnerStatuses_RequestStatusId]
GO
ALTER TABLE [cedo].[ChangeOwnerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeOwnerRequests_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeOwnerRequests] CHECK CONSTRAINT [FK_ChangeOwnerRequests_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ChangeOwnerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeOwnerRequests_ServiceRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
GO
ALTER TABLE [cedo].[ChangeOwnerRequests] CHECK CONSTRAINT [FK_ChangeOwnerRequests_ServiceRequests_RequestId]
GO
ALTER TABLE [cedo].[ChangePlanFeasibility]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanFeasibility_ChangePlanRequests_ChangePlanRequestId] FOREIGN KEY([ChangePlanRequestId])
REFERENCES [cedo].[ChangePlanRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangePlanFeasibility] CHECK CONSTRAINT [FK_ChangePlanFeasibility_ChangePlanRequests_ChangePlanRequestId]
GO
ALTER TABLE [cedo].[ChangePlanFeasibilityJudgement]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanFeasibilityJudgement_ChangePlanFeasibility_ChangePlanFeasibilityId] FOREIGN KEY([ChangePlanFeasibilityId])
REFERENCES [cedo].[ChangePlanFeasibility] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangePlanFeasibilityJudgement] CHECK CONSTRAINT [FK_ChangePlanFeasibilityJudgement_ChangePlanFeasibility_ChangePlanFeasibilityId]
GO
ALTER TABLE [cedo].[ChangePlanFeasibilityJudgement]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanFeasibilityJudgement_ConstructionLicenseDocuments_ResultFileId] FOREIGN KEY([ResultFileId])
REFERENCES [cedo].[ConstructionLicenseDocuments] ([Id])
GO
ALTER TABLE [cedo].[ChangePlanFeasibilityJudgement] CHECK CONSTRAINT [FK_ChangePlanFeasibilityJudgement_ConstructionLicenseDocuments_ResultFileId]
GO
ALTER TABLE [cedo].[ChangePlanFeasibilityJudgement]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanFeasibilityJudgement_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[ChangePlanFeasibilityJudgement] CHECK CONSTRAINT [FK_ChangePlanFeasibilityJudgement_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[ChangePlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanRequests_ChangePlanRequestStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ChangePlanRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangePlanRequests] CHECK CONSTRAINT [FK_ChangePlanRequests_ChangePlanRequestStatuses_StatusId]
GO
ALTER TABLE [cedo].[ChangePlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanRequests_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangePlanRequests] CHECK CONSTRAINT [FK_ChangePlanRequests_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ChangePlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanRequests_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[ChangePlanRequests] CHECK CONSTRAINT [FK_ChangePlanRequests_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[ChangePlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangePlanRequests_ServiceRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
GO
ALTER TABLE [cedo].[ChangePlanRequests] CHECK CONSTRAINT [FK_ChangePlanRequests_ServiceRequests_RequestId]
GO
ALTER TABLE [cedo].[ChangeSiteManagerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSiteManagerRequests_ChangeSiteManagerStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ChangeSiteManagerStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeSiteManagerRequests] CHECK CONSTRAINT [FK_ChangeSiteManagerRequests_ChangeSiteManagerStatuses_StatusId]
GO
ALTER TABLE [cedo].[ChangeSiteManagerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSiteManagerRequests_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeSiteManagerRequests] CHECK CONSTRAINT [FK_ChangeSiteManagerRequests_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ChangeSiteManagerRequests]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSiteManagerRequests_PARA-Users_RequesterId] FOREIGN KEY([RequesterId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeSiteManagerRequests] CHECK CONSTRAINT [FK_ChangeSiteManagerRequests_PARA-Users_RequesterId]
GO
ALTER TABLE [cedo].[ChangeSupervisorJudgment]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorJudgment_ChangeSupervisorRequest_ChangeSupervisorRequestId] FOREIGN KEY([ChangeSupervisorRequestId])
REFERENCES [cedo].[ChangeSupervisorRequest] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeSupervisorJudgment] CHECK CONSTRAINT [FK_ChangeSupervisorJudgment_ChangeSupervisorRequest_ChangeSupervisorRequestId]
GO
ALTER TABLE [cedo].[ChangeSupervisorJudgment]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorJudgment_ConstructionLicenseDocuments_ResultFileId] FOREIGN KEY([ResultFileId])
REFERENCES [cedo].[ConstructionLicenseDocuments] ([Id])
GO
ALTER TABLE [cedo].[ChangeSupervisorJudgment] CHECK CONSTRAINT [FK_ChangeSupervisorJudgment_ConstructionLicenseDocuments_ResultFileId]
GO
ALTER TABLE [cedo].[ChangeSupervisorJudgment]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorJudgment_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[ChangeSupervisorJudgment] CHECK CONSTRAINT [FK_ChangeSupervisorJudgment_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorRequest_ChangeSupervisorRequestStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ChangeSupervisorRequestStatus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] CHECK CONSTRAINT [FK_ChangeSupervisorRequest_ChangeSupervisorRequestStatus_StatusId]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorRequest_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] CHECK CONSTRAINT [FK_ChangeSupervisorRequest_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorRequest_MemberServices_NewSupervisroMemebrServiceId] FOREIGN KEY([NewSupervisroMemebrServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] CHECK CONSTRAINT [FK_ChangeSupervisorRequest_MemberServices_NewSupervisroMemebrServiceId]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorRequest_MemberServices_SupervisroMemebrServiceId] FOREIGN KEY([SupervisroMemebrServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] CHECK CONSTRAINT [FK_ChangeSupervisorRequest_MemberServices_SupervisroMemebrServiceId]
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest]  WITH CHECK ADD  CONSTRAINT [FK_ChangeSupervisorRequest_ServiceRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
GO
ALTER TABLE [cedo].[ChangeSupervisorRequest] CHECK CONSTRAINT [FK_ChangeSupervisorRequest_ServiceRequests_RequestId]
GO
ALTER TABLE [cedo].[Cities]  WITH CHECK ADD  CONSTRAINT [FK_Cities_Provinces_ProvinceId] FOREIGN KEY([ProvinceId])
REFERENCES [cedo].[Provinces] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Cities] CHECK CONSTRAINT [FK_Cities_Provinces_ProvinceId]
GO
ALTER TABLE [cedo].[Complainees]  WITH CHECK ADD  CONSTRAINT [FK_Complainees_Complaints_ComplaintId] FOREIGN KEY([ComplaintId])
REFERENCES [cedo].[Complaints] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Complainees] CHECK CONSTRAINT [FK_Complainees_Complaints_ComplaintId]
GO
ALTER TABLE [cedo].[ComplaintCommunicateds]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintCommunicateds_ComplaintResultStatuses_ComplaintResultStatusId] FOREIGN KEY([ComplaintResultStatusId])
REFERENCES [cedo].[ComplaintResultStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ComplaintCommunicateds] CHECK CONSTRAINT [FK_ComplaintCommunicateds_ComplaintResultStatuses_ComplaintResultStatusId]
GO
ALTER TABLE [cedo].[ComplaintCommunicateds]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintCommunicateds_Complaints_ComplaintId] FOREIGN KEY([ComplaintId])
REFERENCES [cedo].[Complaints] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ComplaintCommunicateds] CHECK CONSTRAINT [FK_ComplaintCommunicateds_Complaints_ComplaintId]
GO
ALTER TABLE [cedo].[ComplaintMembers]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintMembers_ComplaintMemberTypes_ComplaintMemberTypeId] FOREIGN KEY([ComplaintMemberTypeId])
REFERENCES [cedo].[ComplaintMemberTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ComplaintMembers] CHECK CONSTRAINT [FK_ComplaintMembers_ComplaintMemberTypes_ComplaintMemberTypeId]
GO
ALTER TABLE [cedo].[ComplaintMembers]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintMembers_Complaints_ComplaintId] FOREIGN KEY([ComplaintId])
REFERENCES [cedo].[Complaints] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ComplaintMembers] CHECK CONSTRAINT [FK_ComplaintMembers_Complaints_ComplaintId]
GO
ALTER TABLE [cedo].[ComplaintMembers]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintMembers_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[ComplaintMembers] CHECK CONSTRAINT [FK_ComplaintMembers_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[ComplaintResultMembers]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintResultMembers_ComplaintCommunicateds_ComplaintResultId] FOREIGN KEY([ComplaintResultId])
REFERENCES [cedo].[ComplaintCommunicateds] ([Id])
GO
ALTER TABLE [cedo].[ComplaintResultMembers] CHECK CONSTRAINT [FK_ComplaintResultMembers_ComplaintCommunicateds_ComplaintResultId]
GO
ALTER TABLE [cedo].[ComplaintResultMembers]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintResultMembers_ComplaintMembers_ComplaintMemberId] FOREIGN KEY([ComplaintMemberId])
REFERENCES [cedo].[ComplaintMembers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ComplaintResultMembers] CHECK CONSTRAINT [FK_ComplaintResultMembers_ComplaintMembers_ComplaintMemberId]
GO
ALTER TABLE [cedo].[ComplaintReviews]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintReviews_ComplaintMembers_ApplicantId] FOREIGN KEY([ApplicantId])
REFERENCES [cedo].[ComplaintMembers] ([Id])
GO
ALTER TABLE [cedo].[ComplaintReviews] CHECK CONSTRAINT [FK_ComplaintReviews_ComplaintMembers_ApplicantId]
GO
ALTER TABLE [cedo].[ComplaintReviews]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintReviews_ComplaintReviewTypes_ComplaintReviewTypeId] FOREIGN KEY([ComplaintReviewTypeId])
REFERENCES [cedo].[ComplaintReviewTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ComplaintReviews] CHECK CONSTRAINT [FK_ComplaintReviews_ComplaintReviewTypes_ComplaintReviewTypeId]
GO
ALTER TABLE [cedo].[ComplaintReviews]  WITH CHECK ADD  CONSTRAINT [FK_ComplaintReviews_Complaints_ComplaintId] FOREIGN KEY([ComplaintId])
REFERENCES [cedo].[Complaints] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ComplaintReviews] CHECK CONSTRAINT [FK_ComplaintReviews_Complaints_ComplaintId]
GO
ALTER TABLE [cedo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_ComplaintStatuses_ComplaintStatusId] FOREIGN KEY([ComplaintStatusId])
REFERENCES [cedo].[ComplaintStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Complaints] CHECK CONSTRAINT [FK_Complaints_ComplaintStatuses_ComplaintStatusId]
GO
ALTER TABLE [cedo].[ConstructionLicenseComment]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseComment_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseComment] CHECK CONSTRAINT [FK_ConstructionLicenseComment_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ConstructionLicenseComment]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseComment_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[ConstructionLicenseComment] CHECK CONSTRAINT [FK_ConstructionLicenseComment_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[ConstructionLicenseDescriptions]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseDescriptions_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseDescriptions] CHECK CONSTRAINT [FK_ConstructionLicenseDescriptions_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ConstructionLicenseDescriptions]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseDescriptions_DescriptionTypes_DescriptionTypeId] FOREIGN KEY([DescriptionTypeId])
REFERENCES [cedo].[DescriptionTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseDescriptions] CHECK CONSTRAINT [FK_ConstructionLicenseDescriptions_DescriptionTypes_DescriptionTypeId]
GO
ALTER TABLE [cedo].[ConstructionLicenseDocuments]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseDocuments_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseDocuments] CHECK CONSTRAINT [FK_ConstructionLicenseDocuments_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ConstructionLicenseDocuments]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseDocuments_DocumentTypes_DocumentTypeId] FOREIGN KEY([DocumentTypeId])
REFERENCES [cedo].[DocumentTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseDocuments] CHECK CONSTRAINT [FK_ConstructionLicenseDocuments_DocumentTypes_DocumentTypeId]
GO
ALTER TABLE [cedo].[ConstructionLicenseGeoLabs]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseGeoLabs_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseGeoLabs] CHECK CONSTRAINT [FK_ConstructionLicenseGeoLabs_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ConstructionLicenseGeoLabs]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseGeoLabs_DrillingTypes_DrillingTypeId] FOREIGN KEY([DrillingTypeId])
REFERENCES [cedo].[DrillingTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseGeoLabs] CHECK CONSTRAINT [FK_ConstructionLicenseGeoLabs_DrillingTypes_DrillingTypeId]
GO
ALTER TABLE [cedo].[ConstructionLicenseOptions]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenseOptions_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenseOptions] CHECK CONSTRAINT [FK_ConstructionLicenseOptions_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_BuildingGroupSettings_BuildingGroupSettingId] FOREIGN KEY([BuildingGroupSettingId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_BuildingGroupSettings_BuildingGroupSettingId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_BuildingGroupSettings_FinalBuildingGroupSettingId] FOREIGN KEY([FinalBuildingGroupSettingId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_BuildingGroupSettings_FinalBuildingGroupSettingId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenses_ParentId] FOREIGN KEY([ParentId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenses_ParentId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenseStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ConstructionLicenseStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenseStatuses_StatusId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenseSteps_StepId] FOREIGN KEY([StepId])
REFERENCES [cedo].[ConstructionLicenseSteps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenseSteps_StepId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenseTypes_ConstructionLicenseTypeId] FOREIGN KEY([ConstructionLicenseTypeId])
REFERENCES [cedo].[ConstructionLicenseTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_ConstructionLicenseTypes_ConstructionLicenseTypeId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_DeploymentSides_DeploymentSideId] FOREIGN KEY([DeploymentSideId])
REFERENCES [cedo].[DeploymentSides] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_DeploymentSides_DeploymentSideId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_DossierType_DossierTypeId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_Estates_EstateId] FOREIGN KEY([EstateId])
REFERENCES [cedo].[Estates] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_Estates_EstateId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_ExcavationDangerStatuses_ExcavationDangerStatusId] FOREIGN KEY([ExcavationDangerStatusId])
REFERENCES [cedo].[ExcavationDangerStatuses] ([Id])
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_ExcavationDangerStatuses_ExcavationDangerStatusId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_StructureTypes_StructureTypeId] FOREIGN KEY([StructureTypeId])
REFERENCES [cedo].[StructureTypes] ([Id])
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_StructureTypes_StructureTypeId]
GO
ALTER TABLE [cedo].[ConstructionLicenses]  WITH CHECK ADD  CONSTRAINT [FK_ConstructionLicenses_UsageTypes_UsageTypeId] FOREIGN KEY([UsageTypeId])
REFERENCES [cedo].[UsageTypes] ([Id])
GO
ALTER TABLE [cedo].[ConstructionLicenses] CHECK CONSTRAINT [FK_ConstructionLicenses_UsageTypes_UsageTypeId]
GO
ALTER TABLE [cedo].[ContractExpandation]  WITH CHECK ADD  CONSTRAINT [FK_ContractExpandation_ConstructionLicenseDocuments_ConstructionLicenseDocumentId] FOREIGN KEY([ConstructionLicenseDocumentId])
REFERENCES [cedo].[ConstructionLicenseDocuments] ([Id])
GO
ALTER TABLE [cedo].[ContractExpandation] CHECK CONSTRAINT [FK_ContractExpandation_ConstructionLicenseDocuments_ConstructionLicenseDocumentId]
GO
ALTER TABLE [cedo].[ContractExpandation]  WITH CHECK ADD  CONSTRAINT [FK_ContractExpandation_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ContractExpandation] CHECK CONSTRAINT [FK_ContractExpandation_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ContractExpandation]  WITH CHECK ADD  CONSTRAINT [FK_ContractExpandation_ContractExpandationStatus_ContractExpandationStatusId] FOREIGN KEY([ContractExpandationStatusId])
REFERENCES [cedo].[ContractExpandationStatus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ContractExpandation] CHECK CONSTRAINT [FK_ContractExpandation_ContractExpandationStatus_ContractExpandationStatusId]
GO
ALTER TABLE [cedo].[ContractExpandation]  WITH CHECK ADD  CONSTRAINT [FK_ContractExpandation_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[ContractExpandation] CHECK CONSTRAINT [FK_ContractExpandation_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[ContractExpandation]  WITH CHECK ADD  CONSTRAINT [FK_ContractExpandation_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[ContractExpandation] CHECK CONSTRAINT [FK_ContractExpandation_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[ContractPaymentDetails]  WITH CHECK ADD  CONSTRAINT [FK_ContractPaymentDetails_ContractPaymentFors_ContractPaymentForId] FOREIGN KEY([ContractPaymentForId])
REFERENCES [cedo].[ContractPaymentFors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ContractPaymentDetails] CHECK CONSTRAINT [FK_ContractPaymentDetails_ContractPaymentFors_ContractPaymentForId]
GO
ALTER TABLE [cedo].[ContractPaymentDetails]  WITH CHECK ADD  CONSTRAINT [FK_ContractPaymentDetails_ContractPaymentTypes_PaymentTypeId] FOREIGN KEY([PaymentTypeId])
REFERENCES [cedo].[ContractPaymentTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ContractPaymentDetails] CHECK CONSTRAINT [FK_ContractPaymentDetails_ContractPaymentTypes_PaymentTypeId]
GO
ALTER TABLE [cedo].[ContractPaymentDetails]  WITH CHECK ADD  CONSTRAINT [FK_ContractPaymentDetails_Contracts_ContractId] FOREIGN KEY([ContractId])
REFERENCES [cedo].[Contracts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ContractPaymentDetails] CHECK CONSTRAINT [FK_ContractPaymentDetails_Contracts_ContractId]
GO
ALTER TABLE [cedo].[Contracts]  WITH CHECK ADD  CONSTRAINT [FK_Contracts_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Contracts] CHECK CONSTRAINT [FK_Contracts_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[Contracts]  WITH CHECK ADD  CONSTRAINT [FK_Contracts_ContractStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ContractStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Contracts] CHECK CONSTRAINT [FK_Contracts_ContractStatuses_StatusId]
GO
ALTER TABLE [cedo].[Contracts]  WITH CHECK ADD  CONSTRAINT [FK_Contracts_ContractTypes_ContractTypeId] FOREIGN KEY([ContractTypeId])
REFERENCES [cedo].[ContractTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Contracts] CHECK CONSTRAINT [FK_Contracts_ContractTypes_ContractTypeId]
GO
ALTER TABLE [cedo].[CostTypeDetailBills]  WITH CHECK ADD  CONSTRAINT [FK_CostTypeDetailBills_BillTypes_BillTypeId] FOREIGN KEY([BillTypeId])
REFERENCES [cedo].[BillTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CostTypeDetailBills] CHECK CONSTRAINT [FK_CostTypeDetailBills_BillTypes_BillTypeId]
GO
ALTER TABLE [cedo].[CostTypeDetailBills]  WITH CHECK ADD  CONSTRAINT [FK_CostTypeDetailBills_CostTypeDetails_CostTypeDetailId] FOREIGN KEY([CostTypeDetailId])
REFERENCES [cedo].[CostTypeDetails] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CostTypeDetailBills] CHECK CONSTRAINT [FK_CostTypeDetailBills_CostTypeDetails_CostTypeDetailId]
GO
ALTER TABLE [cedo].[CostTypeDetails]  WITH CHECK ADD  CONSTRAINT [FK_CostTypeDetails_CostTypes_CostTypeId] FOREIGN KEY([CostTypeId])
REFERENCES [cedo].[CostTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CostTypeDetails] CHECK CONSTRAINT [FK_CostTypeDetails_CostTypes_CostTypeId]
GO
ALTER TABLE [cedo].[CostTypeDetails]  WITH CHECK ADD  CONSTRAINT [FK_CostTypeDetails_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[CostTypeDetails] CHECK CONSTRAINT [FK_CostTypeDetails_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[CostTypeDetailSettings]  WITH CHECK ADD  CONSTRAINT [FK_CostTypeDetailSettings_BuildingSubGroups_BuildingSubGroupId] FOREIGN KEY([BuildingSubGroupId])
REFERENCES [cedo].[BuildingSubGroups] ([Id])
GO
ALTER TABLE [cedo].[CostTypeDetailSettings] CHECK CONSTRAINT [FK_CostTypeDetailSettings_BuildingSubGroups_BuildingSubGroupId]
GO
ALTER TABLE [cedo].[CostTypeDetailSettings]  WITH CHECK ADD  CONSTRAINT [FK_CostTypeDetailSettings_CostTypeDetails_CostTypeDetailId] FOREIGN KEY([CostTypeDetailId])
REFERENCES [cedo].[CostTypeDetails] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CostTypeDetailSettings] CHECK CONSTRAINT [FK_CostTypeDetailSettings_CostTypeDetails_CostTypeDetailId]
GO
ALTER TABLE [cedo].[CostTypeOrder]  WITH CHECK ADD  CONSTRAINT [FK_CostTypeOrder_CostTypes_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[CostTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CostTypeOrder] CHECK CONSTRAINT [FK_CostTypeOrder_CostTypes_Id]
GO
ALTER TABLE [cedo].[CourseExecutors]  WITH CHECK ADD  CONSTRAINT [FK_CourseExecutors_PARA-Users_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseExecutors] CHECK CONSTRAINT [FK_CourseExecutors_PARA-Users_Id]
GO
ALTER TABLE [cedo].[CourseHoldingMembers]  WITH CHECK ADD  CONSTRAINT [FK_CourseHoldingMembers_CourseHoldings_CourseHoldingId] FOREIGN KEY([CourseHoldingId])
REFERENCES [cedo].[CourseHoldings] ([Id])
GO
ALTER TABLE [cedo].[CourseHoldingMembers] CHECK CONSTRAINT [FK_CourseHoldingMembers_CourseHoldings_CourseHoldingId]
GO
ALTER TABLE [cedo].[CourseHoldingMembers]  WITH CHECK ADD  CONSTRAINT [FK_CourseHoldingMembers_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseHoldingMembers] CHECK CONSTRAINT [FK_CourseHoldingMembers_Members_MemberId]
GO
ALTER TABLE [cedo].[CourseHoldings]  WITH CHECK ADD  CONSTRAINT [FK_CourseHoldings_CourseExecutors_ExecutorId] FOREIGN KEY([ExecutorId])
REFERENCES [cedo].[CourseExecutors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseHoldings] CHECK CONSTRAINT [FK_CourseHoldings_CourseExecutors_ExecutorId]
GO
ALTER TABLE [cedo].[CourseHoldings]  WITH CHECK ADD  CONSTRAINT [FK_CourseHoldings_CourseHoldingSteps_StepId] FOREIGN KEY([StepId])
REFERENCES [cedo].[CourseHoldingSteps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseHoldings] CHECK CONSTRAINT [FK_CourseHoldings_CourseHoldingSteps_StepId]
GO
ALTER TABLE [cedo].[CourseHoldings]  WITH CHECK ADD  CONSTRAINT [FK_CourseHoldings_Courses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [cedo].[Courses] ([Id])
GO
ALTER TABLE [cedo].[CourseHoldings] CHECK CONSTRAINT [FK_CourseHoldings_Courses_CourseId]
GO
ALTER TABLE [cedo].[CourseHoldingSignatorieses]  WITH CHECK ADD  CONSTRAINT [FK_CourseHoldingSignatorieses_CourseHoldings_CourseHoldingId] FOREIGN KEY([CourseHoldingId])
REFERENCES [cedo].[CourseHoldings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseHoldingSignatorieses] CHECK CONSTRAINT [FK_CourseHoldingSignatorieses_CourseHoldings_CourseHoldingId]
GO
ALTER TABLE [cedo].[CourseHoldingSignatorieses]  WITH CHECK ADD  CONSTRAINT [FK_CourseHoldingSignatorieses_Signatories_SignatoryId] FOREIGN KEY([SignatoryId])
REFERENCES [cedo].[Signatories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseHoldingSignatorieses] CHECK CONSTRAINT [FK_CourseHoldingSignatorieses_Signatories_SignatoryId]
GO
ALTER TABLE [cedo].[CourseLessons]  WITH CHECK ADD  CONSTRAINT [FK_CourseLessons_Courses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [cedo].[Courses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseLessons] CHECK CONSTRAINT [FK_CourseLessons_Courses_CourseId]
GO
ALTER TABLE [cedo].[CourseLessons]  WITH CHECK ADD  CONSTRAINT [FK_CourseLessons_Lessons_LessonId] FOREIGN KEY([LessonId])
REFERENCES [cedo].[Lessons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseLessons] CHECK CONSTRAINT [FK_CourseLessons_Lessons_LessonId]
GO
ALTER TABLE [cedo].[CourseQualifiications]  WITH CHECK ADD  CONSTRAINT [FK_CourseQualifiications_Courses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [cedo].[Courses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[CourseQualifiications] CHECK CONSTRAINT [FK_CourseQualifiications_Courses_CourseId]
GO
ALTER TABLE [cedo].[CourseQualifiications]  WITH CHECK ADD  CONSTRAINT [FK_CourseQualifiications_EngineeringGrades_EngGradeId] FOREIGN KEY([EngGradeId])
REFERENCES [cedo].[EngineeringGrades] ([Id])
GO
ALTER TABLE [cedo].[CourseQualifiications] CHECK CONSTRAINT [FK_CourseQualifiications_EngineeringGrades_EngGradeId]
GO
ALTER TABLE [cedo].[CourseQualifiications]  WITH CHECK ADD  CONSTRAINT [FK_CourseQualifiications_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[CourseQualifiications] CHECK CONSTRAINT [FK_CourseQualifiications_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[CourseQualifiications]  WITH CHECK ADD  CONSTRAINT [FK_CourseQualifiications_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[CourseQualifiications] CHECK CONSTRAINT [FK_CourseQualifiications_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[Courses]  WITH CHECK ADD  CONSTRAINT [FK_Courses_CourseTypes_CourseTypeId] FOREIGN KEY([CourseTypeId])
REFERENCES [cedo].[CourseTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Courses] CHECK CONSTRAINT [FK_Courses_CourseTypes_CourseTypeId]
GO
ALTER TABLE [cedo].[DossierBuildingGroupSettings]  WITH CHECK ADD  CONSTRAINT [FK_DossierBuildingGroupSettings_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[DossierBuildingGroupSettings] CHECK CONSTRAINT [FK_DossierBuildingGroupSettings_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[DossierCostSettingDetails]  WITH CHECK ADD  CONSTRAINT [FK_DossierCostSettingDetails_DossierCostSettings_DossierCostSettingId] FOREIGN KEY([DossierCostSettingId])
REFERENCES [cedo].[DossierCostSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[DossierCostSettingDetails] CHECK CONSTRAINT [FK_DossierCostSettingDetails_DossierCostSettings_DossierCostSettingId]
GO
ALTER TABLE [cedo].[DossierCostSettingDetails]  WITH CHECK ADD  CONSTRAINT [FK_DossierCostSettingDetails_EngServiceTariffDetailItems_TariffDetailItemId] FOREIGN KEY([TariffDetailItemId])
REFERENCES [cedo].[EngServiceTariffDetailItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[DossierCostSettingDetails] CHECK CONSTRAINT [FK_DossierCostSettingDetails_EngServiceTariffDetailItems_TariffDetailItemId]
GO
ALTER TABLE [cedo].[DossierCostSettings]  WITH CHECK ADD  CONSTRAINT [FK_DossierCostSettings_BillTypes_BillTypeId] FOREIGN KEY([BillTypeId])
REFERENCES [cedo].[BillTypes] ([Id])
GO
ALTER TABLE [cedo].[DossierCostSettings] CHECK CONSTRAINT [FK_DossierCostSettings_BillTypes_BillTypeId]
GO
ALTER TABLE [cedo].[DossierCostSettings]  WITH CHECK ADD  CONSTRAINT [FK_DossierCostSettings_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[DossierCostSettings] CHECK CONSTRAINT [FK_DossierCostSettings_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ElectricalExecutiveOperationsForms]  WITH CHECK ADD  CONSTRAINT [FK_ElectricalExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ElectricalExecutiveOperationsForms] CHECK CONSTRAINT [FK_ElectricalExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ElectricalPlanControlForms]  WITH CHECK ADD  CONSTRAINT [FK_ElectricalPlanControlForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ElectricalPlanControlForms] CHECK CONSTRAINT [FK_ElectricalPlanControlForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ElectricalRedLinesForms]  WITH CHECK ADD  CONSTRAINT [FK_ElectricalRedLinesForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ElectricalRedLinesForms] CHECK CONSTRAINT [FK_ElectricalRedLinesForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ElectricalSpecForms]  WITH CHECK ADD  CONSTRAINT [FK_ElectricalSpecForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ElectricalSpecForms] CHECK CONSTRAINT [FK_ElectricalSpecForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ElectricitySafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_ElectricitySafetyForms_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ElectricitySafetyForms] CHECK CONSTRAINT [FK_ElectricitySafetyForms_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ElectricitySafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_ElectricitySafetyForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ElectricitySafetyForms] CHECK CONSTRAINT [FK_ElectricitySafetyForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[Elevators]  WITH CHECK ADD  CONSTRAINT [FK_Elevators_ElectricalSpecForms_ElectricalSpecFormId] FOREIGN KEY([ElectricalSpecFormId])
REFERENCES [cedo].[ElectricalSpecForms] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Elevators] CHECK CONSTRAINT [FK_Elevators_ElectricalSpecForms_ElectricalSpecFormId]
GO
ALTER TABLE [cedo].[EmploymentHistories]  WITH CHECK ADD  CONSTRAINT [FK_EmploymentHistories_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[EmploymentHistories] CHECK CONSTRAINT [FK_EmploymentHistories_Members_MemberId]
GO
ALTER TABLE [cedo].[EngServiceCostScaleSettings]  WITH CHECK ADD  CONSTRAINT [FK_EngServiceCostScaleSettings_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
GO
ALTER TABLE [cedo].[EngServiceCostScaleSettings] CHECK CONSTRAINT [FK_EngServiceCostScaleSettings_DossierType_DossierTypeId]
GO
ALTER TABLE [cedo].[EngServiceTariffDetailItems]  WITH CHECK ADD  CONSTRAINT [FK_EngServiceTariffDetailItems_BillTypes_BillTypeId] FOREIGN KEY([BillTypeId])
REFERENCES [cedo].[BillTypes] ([Id])
GO
ALTER TABLE [cedo].[EngServiceTariffDetailItems] CHECK CONSTRAINT [FK_EngServiceTariffDetailItems_BillTypes_BillTypeId]
GO
ALTER TABLE [cedo].[EngServiceTariffDetailItems]  WITH CHECK ADD  CONSTRAINT [FK_EngServiceTariffDetailItems_CostTypeDetails_CostTypeDetailId] FOREIGN KEY([CostTypeDetailId])
REFERENCES [cedo].[CostTypeDetails] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[EngServiceTariffDetailItems] CHECK CONSTRAINT [FK_EngServiceTariffDetailItems_CostTypeDetails_CostTypeDetailId]
GO
ALTER TABLE [cedo].[EngServiceTariffDetailItems]  WITH CHECK ADD  CONSTRAINT [FK_EngServiceTariffDetailItems_EngServiceTariffDetails_EngServiceTariffDetailId] FOREIGN KEY([EngServiceTariffDetailId])
REFERENCES [cedo].[EngServiceTariffDetails] ([Id])
GO
ALTER TABLE [cedo].[EngServiceTariffDetailItems] CHECK CONSTRAINT [FK_EngServiceTariffDetailItems_EngServiceTariffDetails_EngServiceTariffDetailId]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails]  WITH CHECK ADD  CONSTRAINT [FK_EngServiceTariffDetails_BuildingSubGroups_BuildingSubGroupId] FOREIGN KEY([BuildingSubGroupId])
REFERENCES [cedo].[BuildingSubGroups] ([Id])
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] CHECK CONSTRAINT [FK_EngServiceTariffDetails_BuildingSubGroups_BuildingSubGroupId]
GO
ALTER TABLE [cedo].[EngServiceTariffDetails]  WITH CHECK ADD  CONSTRAINT [FK_EngServiceTariffDetails_EngServiceTariffs_EngServiceTariffId] FOREIGN KEY([EngServiceTariffId])
REFERENCES [cedo].[EngServiceTariffs] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[EngServiceTariffDetails] CHECK CONSTRAINT [FK_EngServiceTariffDetails_EngServiceTariffs_EngServiceTariffId]
GO
ALTER TABLE [cedo].[EstateCoordinates]  WITH CHECK ADD  CONSTRAINT [FK_EstateCoordinates_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[EstateCoordinates] CHECK CONSTRAINT [FK_EstateCoordinates_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[Estates]  WITH CHECK ADD  CONSTRAINT [FK_Estates_Municipalities_MunicipalityId] FOREIGN KEY([MunicipalityId])
REFERENCES [cedo].[Municipalities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Estates] CHECK CONSTRAINT [FK_Estates_Municipalities_MunicipalityId]
GO
ALTER TABLE [cedo].[Estates]  WITH CHECK ADD  CONSTRAINT [FK_Estates_OwnershipDocumentTypes_OwnershipDocumentTypeId] FOREIGN KEY([OwnershipDocumentTypeId])
REFERENCES [cedo].[OwnershipDocumentTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Estates] CHECK CONSTRAINT [FK_Estates_OwnershipDocumentTypes_OwnershipDocumentTypeId]
GO
ALTER TABLE [cedo].[Examinations]  WITH CHECK ADD  CONSTRAINT [FK_Examinations_ConstructionLicenseDocuments_ExaminationFileId] FOREIGN KEY([ExaminationFileId])
REFERENCES [cedo].[ConstructionLicenseDocuments] ([Id])
GO
ALTER TABLE [cedo].[Examinations] CHECK CONSTRAINT [FK_Examinations_ConstructionLicenseDocuments_ExaminationFileId]
GO
ALTER TABLE [cedo].[Examinations]  WITH CHECK ADD  CONSTRAINT [FK_Examinations_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Examinations] CHECK CONSTRAINT [FK_Examinations_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[Examinations]  WITH CHECK ADD  CONSTRAINT [FK_Examinations_ExaminationPlaces_ExaminationPlaceId] FOREIGN KEY([ExaminationPlaceId])
REFERENCES [cedo].[ExaminationPlaces] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Examinations] CHECK CONSTRAINT [FK_Examinations_ExaminationPlaces_ExaminationPlaceId]
GO
ALTER TABLE [cedo].[Examinations]  WITH CHECK ADD  CONSTRAINT [FK_Examinations_ExaminationStatuses_ExaminationStatusId] FOREIGN KEY([ExaminationStatusId])
REFERENCES [cedo].[ExaminationStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Examinations] CHECK CONSTRAINT [FK_Examinations_ExaminationStatuses_ExaminationStatusId]
GO
ALTER TABLE [cedo].[Examinations]  WITH CHECK ADD  CONSTRAINT [FK_Examinations_ExaminationTypes_ExaminationTypeId] FOREIGN KEY([ExaminationTypeId])
REFERENCES [cedo].[ExaminationTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Examinations] CHECK CONSTRAINT [FK_Examinations_ExaminationTypes_ExaminationTypeId]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterCompetenceSettings_EngineeringGrades_GradeId] FOREIGN KEY([GradeId])
REFERENCES [cedo].[EngineeringGrades] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] CHECK CONSTRAINT [FK_ExecuterCompetenceSettings_EngineeringGrades_GradeId]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterCompetenceSettings_MemberShipTypes_MemberShipTypeId] FOREIGN KEY([MemberShipTypeId])
REFERENCES [cedo].[MemberShipTypes] ([Id])
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] CHECK CONSTRAINT [FK_ExecuterCompetenceSettings_MemberShipTypes_MemberShipTypeId]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterCompetenceSettings_MemberTypes_MemberTypeId] FOREIGN KEY([MemberTypeId])
REFERENCES [cedo].[MemberTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] CHECK CONSTRAINT [FK_ExecuterCompetenceSettings_MemberTypes_MemberTypeId]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterCompetenceSettings_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] CHECK CONSTRAINT [FK_ExecuterCompetenceSettings_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterCompetenceSettings_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[ExecuterCompetenceSettings] CHECK CONSTRAINT [FK_ExecuterCompetenceSettings_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[ExecuterContracts]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContracts_Contracts_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[Contracts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterContracts] CHECK CONSTRAINT [FK_ExecuterContracts_Contracts_Id]
GO
ALTER TABLE [cedo].[ExecuterContractSuspensionRequest]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContractSuspensionRequest_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterContractSuspensionRequest] CHECK CONSTRAINT [FK_ExecuterContractSuspensionRequest_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ExecuterContractSuspensionRequest]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContractSuspensionRequest_ExecuterContractSuspensionRequestStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ExecuterContractSuspensionRequestStatus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterContractSuspensionRequest] CHECK CONSTRAINT [FK_ExecuterContractSuspensionRequest_ExecuterContractSuspensionRequestStatus_StatusId]
GO
ALTER TABLE [cedo].[ExecuterContractTermination]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContractTermination_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterContractTermination] CHECK CONSTRAINT [FK_ExecuterContractTermination_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ExecuterContractTermination]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContractTermination_ExecuterContractTerminationStatus_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[ExecuterContractTerminationStatus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterContractTermination] CHECK CONSTRAINT [FK_ExecuterContractTermination_ExecuterContractTerminationStatus_StatusId]
GO
ALTER TABLE [cedo].[ExecuterContractTerminationJudgment]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContractTerminationJudgment_ConstructionLicenseDocuments_ResultFileId] FOREIGN KEY([ResultFileId])
REFERENCES [cedo].[ConstructionLicenseDocuments] ([Id])
GO
ALTER TABLE [cedo].[ExecuterContractTerminationJudgment] CHECK CONSTRAINT [FK_ExecuterContractTerminationJudgment_ConstructionLicenseDocuments_ResultFileId]
GO
ALTER TABLE [cedo].[ExecuterContractTerminationJudgment]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContractTerminationJudgment_ExecuterContractTermination_ExecuterContractTerminationId] FOREIGN KEY([ExecuterContractTerminationId])
REFERENCES [cedo].[ExecuterContractTermination] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExecuterContractTerminationJudgment] CHECK CONSTRAINT [FK_ExecuterContractTerminationJudgment_ExecuterContractTermination_ExecuterContractTerminationId]
GO
ALTER TABLE [cedo].[ExecuterContractTerminationJudgment]  WITH CHECK ADD  CONSTRAINT [FK_ExecuterContractTerminationJudgment_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[ExecuterContractTerminationJudgment] CHECK CONSTRAINT [FK_ExecuterContractTerminationJudgment_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[ExpertCostsSetting]  WITH CHECK ADD  CONSTRAINT [FK_ExpertCostsSetting_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ExpertCostsSetting] CHECK CONSTRAINT [FK_ExpertCostsSetting_Cities_CityId]
GO
ALTER TABLE [cedo].[FacilityDevicesSpecifications]  WITH CHECK ADD  CONSTRAINT [FK_FacilityDevicesSpecifications_FacilityDeviceTypes_DeviceTypeId] FOREIGN KEY([DeviceTypeId])
REFERENCES [cedo].[FacilityDeviceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FacilityDevicesSpecifications] CHECK CONSTRAINT [FK_FacilityDevicesSpecifications_FacilityDeviceTypes_DeviceTypeId]
GO
ALTER TABLE [cedo].[FacilityDevicesSpecifications]  WITH CHECK ADD  CONSTRAINT [FK_FacilityDevicesSpecifications_MechanicalSpecForms_FormId] FOREIGN KEY([FormId])
REFERENCES [cedo].[MechanicalSpecForms] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FacilityDevicesSpecifications] CHECK CONSTRAINT [FK_FacilityDevicesSpecifications_MechanicalSpecForms_FormId]
GO
ALTER TABLE [cedo].[FacilityRequests]  WITH CHECK ADD  CONSTRAINT [FK_FacilityRequests_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FacilityRequests] CHECK CONSTRAINT [FK_FacilityRequests_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[FacilityRequests]  WITH CHECK ADD  CONSTRAINT [FK_FacilityRequests_FacilityRequestFors_RequestForId] FOREIGN KEY([RequestForId])
REFERENCES [cedo].[FacilityRequestFors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FacilityRequests] CHECK CONSTRAINT [FK_FacilityRequests_FacilityRequestFors_RequestForId]
GO
ALTER TABLE [cedo].[FacilityRequests]  WITH CHECK ADD  CONSTRAINT [FK_FacilityRequests_FacilityRequestStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[FacilityRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FacilityRequests] CHECK CONSTRAINT [FK_FacilityRequests_FacilityRequestStatuses_StatusId]
GO
ALTER TABLE [cedo].[FacilityRequests]  WITH CHECK ADD  CONSTRAINT [FK_FacilityRequests_PARA-Users_RequesterId] FOREIGN KEY([RequesterId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FacilityRequests] CHECK CONSTRAINT [FK_FacilityRequests_PARA-Users_RequesterId]
GO
ALTER TABLE [cedo].[FiscalBalances]  WITH CHECK ADD  CONSTRAINT [FK_FiscalBalances_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FiscalBalances] CHECK CONSTRAINT [FK_FiscalBalances_Members_MemberId]
GO
ALTER TABLE [cedo].[FiscalBalances]  WITH CHECK ADD  CONSTRAINT [FK_FiscalBalances_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FiscalBalances] CHECK CONSTRAINT [FK_FiscalBalances_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[FiscalBalances]  WITH CHECK ADD  CONSTRAINT [FK_FiscalBalances_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[FiscalBalances] CHECK CONSTRAINT [FK_FiscalBalances_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[Floors]  WITH CHECK ADD  CONSTRAINT [FK_Floors_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Floors] CHECK CONSTRAINT [FK_Floors_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[Floors]  WITH CHECK ADD  CONSTRAINT [FK_Floors_FloorRegisterStep_FloorRegisterStepId] FOREIGN KEY([FloorRegisterStepId])
REFERENCES [cedo].[FloorRegisterStep] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Floors] CHECK CONSTRAINT [FK_Floors_FloorRegisterStep_FloorRegisterStepId]
GO
ALTER TABLE [cedo].[Floors]  WITH CHECK ADD  CONSTRAINT [FK_Floors_FloorTypes_FloorTypeId] FOREIGN KEY([FloorTypeId])
REFERENCES [cedo].[FloorTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Floors] CHECK CONSTRAINT [FK_Floors_FloorTypes_FloorTypeId]
GO
ALTER TABLE [cedo].[GasBranchOffices]  WITH CHECK ADD  CONSTRAINT [FK_GasBranchOffices_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasBranchOffices] CHECK CONSTRAINT [FK_GasBranchOffices_Cities_CityId]
GO
ALTER TABLE [cedo].[GasBranchUsers]  WITH CHECK ADD  CONSTRAINT [FK_GasBranchUsers_GasBranchOffices_BranchId] FOREIGN KEY([BranchId])
REFERENCES [cedo].[GasBranchOffices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasBranchUsers] CHECK CONSTRAINT [FK_GasBranchUsers_GasBranchOffices_BranchId]
GO
ALTER TABLE [cedo].[GasBranchUsers]  WITH CHECK ADD  CONSTRAINT [FK_GasBranchUsers_PARA-Users_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasBranchUsers] CHECK CONSTRAINT [FK_GasBranchUsers_PARA-Users_Id]
GO
ALTER TABLE [cedo].[GasRequestAuditForms]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestAuditForms_GasCounterTypes_CounterTypeId] FOREIGN KEY([CounterTypeId])
REFERENCES [cedo].[GasCounterTypes] ([Id])
GO
ALTER TABLE [cedo].[GasRequestAuditForms] CHECK CONSTRAINT [FK_GasRequestAuditForms_GasCounterTypes_CounterTypeId]
GO
ALTER TABLE [cedo].[GasRequestAuditForms]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestAuditForms_GasRequestSplits_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[GasRequestSplits] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestAuditForms] CHECK CONSTRAINT [FK_GasRequestAuditForms_GasRequestSplits_Id]
GO
ALTER TABLE [cedo].[GasRequestAuditForms]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestAuditForms_GasUsageTypes_UsageTypeId] FOREIGN KEY([UsageTypeId])
REFERENCES [cedo].[GasUsageTypes] ([Id])
GO
ALTER TABLE [cedo].[GasRequestAuditForms] CHECK CONSTRAINT [FK_GasRequestAuditForms_GasUsageTypes_UsageTypeId]
GO
ALTER TABLE [cedo].[GasRequestInvolvedMemberChangeLogs]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestInvolvedMemberChangeLogs_GasRequestInvolvedMembers_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[GasRequestInvolvedMembers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestInvolvedMemberChangeLogs] CHECK CONSTRAINT [FK_GasRequestInvolvedMemberChangeLogs_GasRequestInvolvedMembers_Id]
GO
ALTER TABLE [cedo].[GasRequestInvolvedMemberChangeLogs]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestInvolvedMemberChangeLogs_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[GasRequestInvolvedMemberChangeLogs] CHECK CONSTRAINT [FK_GasRequestInvolvedMemberChangeLogs_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestInvolvedMembers_GasRequestOncalls_OncallId] FOREIGN KEY([OncallId])
REFERENCES [cedo].[GasRequestOncalls] ([Id])
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers] CHECK CONSTRAINT [FK_GasRequestInvolvedMembers_GasRequestOncalls_OncallId]
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestInvolvedMembers_GasRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[GasRequests] ([Id])
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers] CHECK CONSTRAINT [FK_GasRequestInvolvedMembers_GasRequests_RequestId]
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestInvolvedMembers_InvolvedMemberStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[InvolvedMemberStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers] CHECK CONSTRAINT [FK_GasRequestInvolvedMembers_InvolvedMemberStatuses_StatusId]
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestInvolvedMembers_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[GasRequestInvolvedMembers] CHECK CONSTRAINT [FK_GasRequestInvolvedMembers_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[GasRequestOncallDescriptions]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestOncallDescriptions_GasRequestOncalls_GasRequestOncallId] FOREIGN KEY([GasRequestOncallId])
REFERENCES [cedo].[GasRequestOncalls] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestOncallDescriptions] CHECK CONSTRAINT [FK_GasRequestOncallDescriptions_GasRequestOncalls_GasRequestOncallId]
GO
ALTER TABLE [cedo].[GasRequestOncallDescriptions]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestOncallDescriptions_GasRequestOncallStatuses_GasRequestOncallStatusId] FOREIGN KEY([GasRequestOncallStatusId])
REFERENCES [cedo].[GasRequestOncallStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestOncallDescriptions] CHECK CONSTRAINT [FK_GasRequestOncallDescriptions_GasRequestOncallStatuses_GasRequestOncallStatusId]
GO
ALTER TABLE [cedo].[GasRequestOncalls]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestOncalls_GasOncallStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[GasOncallStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestOncalls] CHECK CONSTRAINT [FK_GasRequestOncalls_GasOncallStatuses_StatusId]
GO
ALTER TABLE [cedo].[GasRequestOncalls]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestOncalls_ServiceRequests_ServiceRequestId] FOREIGN KEY([ServiceRequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestOncalls] CHECK CONSTRAINT [FK_GasRequestOncalls_ServiceRequests_ServiceRequestId]
GO
ALTER TABLE [cedo].[GasRequests]  WITH CHECK ADD  CONSTRAINT [FK_GasRequests_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequests] CHECK CONSTRAINT [FK_GasRequests_Cities_CityId]
GO
ALTER TABLE [cedo].[GasRequests]  WITH CHECK ADD  CONSTRAINT [FK_GasRequests_GasRequestScopeTypes_ScopeId] FOREIGN KEY([ScopeId])
REFERENCES [cedo].[GasRequestScopeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequests] CHECK CONSTRAINT [FK_GasRequests_GasRequestScopeTypes_ScopeId]
GO
ALTER TABLE [cedo].[GasRequests]  WITH CHECK ADD  CONSTRAINT [FK_GasRequests_GasRequestStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[GasRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequests] CHECK CONSTRAINT [FK_GasRequests_GasRequestStatuses_StatusId]
GO
ALTER TABLE [cedo].[GasRequests]  WITH CHECK ADD  CONSTRAINT [FK_GasRequests_GasRequestTypes_TypeId] FOREIGN KEY([TypeId])
REFERENCES [cedo].[GasRequestTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequests] CHECK CONSTRAINT [FK_GasRequests_GasRequestTypes_TypeId]
GO
ALTER TABLE [cedo].[GasRequests]  WITH CHECK ADD  CONSTRAINT [FK_GasRequests_OwnershipDocumentTypes_OwnershipTypeId] FOREIGN KEY([OwnershipTypeId])
REFERENCES [cedo].[OwnershipDocumentTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequests] CHECK CONSTRAINT [FK_GasRequests_OwnershipDocumentTypes_OwnershipTypeId]
GO
ALTER TABLE [cedo].[GasRequests]  WITH CHECK ADD  CONSTRAINT [FK_GasRequests_ServiceRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequests] CHECK CONSTRAINT [FK_GasRequests_ServiceRequests_RequestId]
GO
ALTER TABLE [cedo].[GasRequestSplitDocuments]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplitDocuments_DocumentTypes_DocumentTypeId] FOREIGN KEY([DocumentTypeId])
REFERENCES [cedo].[DocumentTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestSplitDocuments] CHECK CONSTRAINT [FK_GasRequestSplitDocuments_DocumentTypes_DocumentTypeId]
GO
ALTER TABLE [cedo].[GasRequestSplitDocuments]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplitDocuments_GasRequestSplits_GasRequestSplitId] FOREIGN KEY([GasRequestSplitId])
REFERENCES [cedo].[GasRequestSplits] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestSplitDocuments] CHECK CONSTRAINT [FK_GasRequestSplitDocuments_GasRequestSplits_GasRequestSplitId]
GO
ALTER TABLE [cedo].[GasRequestSplitProblems]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplitProblems_GasRequestSplits_SplitId] FOREIGN KEY([SplitId])
REFERENCES [cedo].[GasRequestSplits] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestSplitProblems] CHECK CONSTRAINT [FK_GasRequestSplitProblems_GasRequestSplits_SplitId]
GO
ALTER TABLE [cedo].[GasRequestSplits]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplits_GasCounterTypes_CounterTypeId] FOREIGN KEY([CounterTypeId])
REFERENCES [cedo].[GasCounterTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestSplits] CHECK CONSTRAINT [FK_GasRequestSplits_GasCounterTypes_CounterTypeId]
GO
ALTER TABLE [cedo].[GasRequestSplits]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplits_GasCounterTypes_FinalCounterTypeId] FOREIGN KEY([FinalCounterTypeId])
REFERENCES [cedo].[GasCounterTypes] ([Id])
GO
ALTER TABLE [cedo].[GasRequestSplits] CHECK CONSTRAINT [FK_GasRequestSplits_GasCounterTypes_FinalCounterTypeId]
GO
ALTER TABLE [cedo].[GasRequestSplits]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplits_GasRequests_GasRequestId] FOREIGN KEY([GasRequestId])
REFERENCES [cedo].[GasRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestSplits] CHECK CONSTRAINT [FK_GasRequestSplits_GasRequests_GasRequestId]
GO
ALTER TABLE [cedo].[GasRequestSplits]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplits_GasUsageTypes_FinalUsageTypeId] FOREIGN KEY([FinalUsageTypeId])
REFERENCES [cedo].[GasUsageTypes] ([Id])
GO
ALTER TABLE [cedo].[GasRequestSplits] CHECK CONSTRAINT [FK_GasRequestSplits_GasUsageTypes_FinalUsageTypeId]
GO
ALTER TABLE [cedo].[GasRequestSplits]  WITH CHECK ADD  CONSTRAINT [FK_GasRequestSplits_GasUsageTypes_UsageTypeId] FOREIGN KEY([UsageTypeId])
REFERENCES [cedo].[GasUsageTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRequestSplits] CHECK CONSTRAINT [FK_GasRequestSplits_GasUsageTypes_UsageTypeId]
GO
ALTER TABLE [cedo].[GasRotatingForms]  WITH CHECK ADD  CONSTRAINT [FK_GasRotatingForms_GasRequestInvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[GasRequestInvolvedMembers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRotatingForms] CHECK CONSTRAINT [FK_GasRotatingForms_GasRequestInvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[GasRotatingForms]  WITH CHECK ADD  CONSTRAINT [FK_GasRotatingForms_GasSubscriptionTypes_SubscriptionTypeId] FOREIGN KEY([SubscriptionTypeId])
REFERENCES [cedo].[GasSubscriptionTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasRotatingForms] CHECK CONSTRAINT [FK_GasRotatingForms_GasSubscriptionTypes_SubscriptionTypeId]
GO
ALTER TABLE [cedo].[GasSupervisionResults]  WITH CHECK ADD  CONSTRAINT [FK_GasSupervisionResults_GasRequestInvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[GasRequestInvolvedMembers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasSupervisionResults] CHECK CONSTRAINT [FK_GasSupervisionResults_GasRequestInvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[GasSupervisionResults]  WITH CHECK ADD  CONSTRAINT [FK_GasSupervisionResults_GasSupervisionResultStates_StateId] FOREIGN KEY([StateId])
REFERENCES [cedo].[GasSupervisionResultStates] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GasSupervisionResults] CHECK CONSTRAINT [FK_GasSupervisionResults_GasSupervisionResultStates_StateId]
GO
ALTER TABLE [cedo].[GradeCalculationSettings]  WITH CHECK ADD  CONSTRAINT [FK_GradeCalculationSettings_BuildingGroupSettings_BuildingGroupSettingId] FOREIGN KEY([BuildingGroupSettingId])
REFERENCES [cedo].[BuildingGroupSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GradeCalculationSettings] CHECK CONSTRAINT [FK_GradeCalculationSettings_BuildingGroupSettings_BuildingGroupSettingId]
GO
ALTER TABLE [cedo].[GradeCalculationSettings]  WITH CHECK ADD  CONSTRAINT [FK_GradeCalculationSettings_EngineeringGrades_MinGradeId] FOREIGN KEY([MinGradeId])
REFERENCES [cedo].[EngineeringGrades] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GradeCalculationSettings] CHECK CONSTRAINT [FK_GradeCalculationSettings_EngineeringGrades_MinGradeId]
GO
ALTER TABLE [cedo].[GradeCalculationSettings]  WITH CHECK ADD  CONSTRAINT [FK_GradeCalculationSettings_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[GradeCalculationSettings] CHECK CONSTRAINT [FK_GradeCalculationSettings_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[GradeCalculationSettings]  WITH CHECK ADD  CONSTRAINT [FK_GradeCalculationSettings_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[GradeCalculationSettings] CHECK CONSTRAINT [FK_GradeCalculationSettings_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[HoldingLessonOptions]  WITH CHECK ADD  CONSTRAINT [FK_HoldingLessonOptions_HoldingLessons_HoldingLessonId] FOREIGN KEY([HoldingLessonId])
REFERENCES [cedo].[HoldingLessons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[HoldingLessonOptions] CHECK CONSTRAINT [FK_HoldingLessonOptions_HoldingLessons_HoldingLessonId]
GO
ALTER TABLE [cedo].[HoldingLessons]  WITH CHECK ADD  CONSTRAINT [FK_HoldingLessons_CourseHoldings_CourseHoldingId] FOREIGN KEY([CourseHoldingId])
REFERENCES [cedo].[CourseHoldings] ([Id])
GO
ALTER TABLE [cedo].[HoldingLessons] CHECK CONSTRAINT [FK_HoldingLessons_CourseHoldings_CourseHoldingId]
GO
ALTER TABLE [cedo].[HoldingLessons]  WITH CHECK ADD  CONSTRAINT [FK_HoldingLessons_CourseLessons_CourseLessonId] FOREIGN KEY([CourseLessonId])
REFERENCES [cedo].[CourseLessons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[HoldingLessons] CHECK CONSTRAINT [FK_HoldingLessons_CourseLessons_CourseLessonId]
GO
ALTER TABLE [cedo].[HoldingLessons]  WITH CHECK ADD  CONSTRAINT [FK_HoldingLessons_HoldingLessonStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[HoldingLessonStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[HoldingLessons] CHECK CONSTRAINT [FK_HoldingLessons_HoldingLessonStatuses_StatusId]
GO
ALTER TABLE [cedo].[HoldingLessons]  WITH CHECK ADD  CONSTRAINT [FK_HoldingLessons_MemberServices_TeacherMemberServiceId] FOREIGN KEY([TeacherMemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[HoldingLessons] CHECK CONSTRAINT [FK_HoldingLessons_MemberServices_TeacherMemberServiceId]
GO
ALTER TABLE [cedo].[HoldingLessonSessions]  WITH CHECK ADD  CONSTRAINT [FK_HoldingLessonSessions_HoldingLessons_HoldingLessonId] FOREIGN KEY([HoldingLessonId])
REFERENCES [cedo].[HoldingLessons] ([Id])
GO
ALTER TABLE [cedo].[HoldingLessonSessions] CHECK CONSTRAINT [FK_HoldingLessonSessions_HoldingLessons_HoldingLessonId]
GO
ALTER TABLE [cedo].[IntroductionRequests]  WITH CHECK ADD  CONSTRAINT [FK_IntroductionRequests_IntroductionRequestStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[IntroductionRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[IntroductionRequests] CHECK CONSTRAINT [FK_IntroductionRequests_IntroductionRequestStatuses_StatusId]
GO
ALTER TABLE [cedo].[IntroductionRequests]  WITH CHECK ADD  CONSTRAINT [FK_IntroductionRequests_IntroductionTargets_TargetId] FOREIGN KEY([TargetId])
REFERENCES [cedo].[IntroductionTargets] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[IntroductionRequests] CHECK CONSTRAINT [FK_IntroductionRequests_IntroductionTargets_TargetId]
GO
ALTER TABLE [cedo].[IntroductionRequests]  WITH CHECK ADD  CONSTRAINT [FK_IntroductionRequests_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[IntroductionRequests] CHECK CONSTRAINT [FK_IntroductionRequests_Members_MemberId]
GO
ALTER TABLE [cedo].[InvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_InvolvedMembers_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
GO
ALTER TABLE [cedo].[InvolvedMembers] CHECK CONSTRAINT [FK_InvolvedMembers_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[InvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_InvolvedMembers_InvolvedMemberStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[InvolvedMemberStatuses] ([Id])
GO
ALTER TABLE [cedo].[InvolvedMembers] CHECK CONSTRAINT [FK_InvolvedMembers_InvolvedMemberStatuses_StatusId]
GO
ALTER TABLE [cedo].[InvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_InvolvedMembers_InvolvedMemberType_InvolvedMemberTypeId] FOREIGN KEY([InvolvedMemberTypeId])
REFERENCES [cedo].[InvolvedMemberType] ([Id])
GO
ALTER TABLE [cedo].[InvolvedMembers] CHECK CONSTRAINT [FK_InvolvedMembers_InvolvedMemberType_InvolvedMemberTypeId]
GO
ALTER TABLE [cedo].[InvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_InvolvedMembers_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[InvolvedMembers] CHECK CONSTRAINT [FK_InvolvedMembers_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[LegalMemberPersonnels]  WITH CHECK ADD  CONSTRAINT [FK_LegalMemberPersonnels_LegalMembers_LegalMemberId] FOREIGN KEY([LegalMemberId])
REFERENCES [cedo].[LegalMembers] ([Id])
GO
ALTER TABLE [cedo].[LegalMemberPersonnels] CHECK CONSTRAINT [FK_LegalMemberPersonnels_LegalMembers_LegalMemberId]
GO
ALTER TABLE [cedo].[LegalMemberPersonnels]  WITH CHECK ADD  CONSTRAINT [FK_LegalMemberPersonnels_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
GO
ALTER TABLE [cedo].[LegalMemberPersonnels] CHECK CONSTRAINT [FK_LegalMemberPersonnels_Members_MemberId]
GO
ALTER TABLE [cedo].[LegalMemberPersonnels]  WITH CHECK ADD  CONSTRAINT [FK_LegalMemberPersonnels_PersonnelPosts_PostId] FOREIGN KEY([PostId])
REFERENCES [cedo].[PersonnelPosts] ([Id])
GO
ALTER TABLE [cedo].[LegalMemberPersonnels] CHECK CONSTRAINT [FK_LegalMemberPersonnels_PersonnelPosts_PostId]
GO
ALTER TABLE [cedo].[LegalMembers]  WITH CHECK ADD  CONSTRAINT [FK_LegalMembers_LegalMemberTypes_LegalMemberTypeId] FOREIGN KEY([LegalMemberTypeId])
REFERENCES [cedo].[LegalMemberTypes] ([Id])
GO
ALTER TABLE [cedo].[LegalMembers] CHECK CONSTRAINT [FK_LegalMembers_LegalMemberTypes_LegalMemberTypeId]
GO
ALTER TABLE [cedo].[LegalMembers]  WITH CHECK ADD  CONSTRAINT [FK_LegalMembers_Members_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[Members] ([Id])
GO
ALTER TABLE [cedo].[LegalMembers] CHECK CONSTRAINT [FK_LegalMembers_Members_Id]
GO
ALTER TABLE [cedo].[LicenseCapacities]  WITH CHECK ADD  CONSTRAINT [FK_LicenseCapacities_BuildingGroups_BuildingGroupId] FOREIGN KEY([BuildingGroupId])
REFERENCES [cedo].[BuildingGroups] ([Id])
GO
ALTER TABLE [cedo].[LicenseCapacities] CHECK CONSTRAINT [FK_LicenseCapacities_BuildingGroups_BuildingGroupId]
GO
ALTER TABLE [cedo].[LicenseCapacities]  WITH CHECK ADD  CONSTRAINT [FK_LicenseCapacities_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[LicenseCapacities] CHECK CONSTRAINT [FK_LicenseCapacities_Members_MemberId]
GO
ALTER TABLE [cedo].[LicenseCapacities]  WITH CHECK ADD  CONSTRAINT [FK_LicenseCapacities_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[LicenseCapacities] CHECK CONSTRAINT [FK_LicenseCapacities_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[LicenseCapacities]  WITH CHECK ADD  CONSTRAINT [FK_LicenseCapacities_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[LicenseCapacities] CHECK CONSTRAINT [FK_LicenseCapacities_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[LicenseCapacityRemainings]  WITH CHECK ADD  CONSTRAINT [FK_LicenseCapacityRemainings_LicenseCapacities_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[LicenseCapacities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[LicenseCapacityRemainings] CHECK CONSTRAINT [FK_LicenseCapacityRemainings_LicenseCapacities_Id]
GO
ALTER TABLE [cedo].[LicenseInqueries]  WITH CHECK ADD  CONSTRAINT [FK_LicenseInqueries_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[LicenseInqueries] CHECK CONSTRAINT [FK_LicenseInqueries_DossierType_DossierTypeId]
GO
ALTER TABLE [cedo].[LicenseInqueries]  WITH CHECK ADD  CONSTRAINT [FK_LicenseInqueries_LicenseInqueryStatuses_LicenseInqueryStatusId] FOREIGN KEY([LicenseInqueryStatusId])
REFERENCES [cedo].[LicenseInqueryStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[LicenseInqueries] CHECK CONSTRAINT [FK_LicenseInqueries_LicenseInqueryStatuses_LicenseInqueryStatusId]
GO
ALTER TABLE [cedo].[LicenseInqueries]  WITH CHECK ADD  CONSTRAINT [FK_LicenseInqueries_Municipalities_MunicipalityId] FOREIGN KEY([MunicipalityId])
REFERENCES [cedo].[Municipalities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[LicenseInqueries] CHECK CONSTRAINT [FK_LicenseInqueries_Municipalities_MunicipalityId]
GO
ALTER TABLE [cedo].[ManpowerSkillCards]  WITH CHECK ADD  CONSTRAINT [FK_ManpowerSkillCards_CategoryManpowerSkillCards_CategoryManpowerSkillCardId] FOREIGN KEY([CategoryManpowerSkillCardId])
REFERENCES [cedo].[CategoryManpowerSkillCards] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ManpowerSkillCards] CHECK CONSTRAINT [FK_ManpowerSkillCards_CategoryManpowerSkillCards_CategoryManpowerSkillCardId]
GO
ALTER TABLE [cedo].[ManpowerSkillCardValues]  WITH CHECK ADD  CONSTRAINT [FK_ManpowerSkillCardValues_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ManpowerSkillCardValues] CHECK CONSTRAINT [FK_ManpowerSkillCardValues_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[ManpowerSkillCardValues]  WITH CHECK ADD  CONSTRAINT [FK_ManpowerSkillCardValues_ManpowerSkillCards_ManpowerSkillCardId] FOREIGN KEY([ManpowerSkillCardId])
REFERENCES [cedo].[ManpowerSkillCards] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ManpowerSkillCardValues] CHECK CONSTRAINT [FK_ManpowerSkillCardValues_ManpowerSkillCards_ManpowerSkillCardId]
GO
ALTER TABLE [cedo].[Materials]  WITH CHECK ADD  CONSTRAINT [FK_Materials_MaterialCategories_MaterialCategoryId] FOREIGN KEY([MaterialCategoryId])
REFERENCES [cedo].[MaterialCategories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Materials] CHECK CONSTRAINT [FK_Materials_MaterialCategories_MaterialCategoryId]
GO
ALTER TABLE [cedo].[MaterialValues]  WITH CHECK ADD  CONSTRAINT [FK_MaterialValues_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[MaterialValues] CHECK CONSTRAINT [FK_MaterialValues_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[MaterialValues]  WITH CHECK ADD  CONSTRAINT [FK_MaterialValues_Materials_MaterialId] FOREIGN KEY([MaterialId])
REFERENCES [cedo].[Materials] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MaterialValues] CHECK CONSTRAINT [FK_MaterialValues_Materials_MaterialId]
GO
ALTER TABLE [cedo].[MechanicalExecutiveOperationsForms]  WITH CHECK ADD  CONSTRAINT [FK_MechanicalExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[MechanicalExecutiveOperationsForms] CHECK CONSTRAINT [FK_MechanicalExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[MechanicalPlanControlForms]  WITH CHECK ADD  CONSTRAINT [FK_MechanicalPlanControlForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[MechanicalPlanControlForms] CHECK CONSTRAINT [FK_MechanicalPlanControlForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[MechanicalRedLinesForms]  WITH CHECK ADD  CONSTRAINT [FK_MechanicalRedLinesForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[MechanicalRedLinesForms] CHECK CONSTRAINT [FK_MechanicalRedLinesForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[MechanicalSpecForms]  WITH CHECK ADD  CONSTRAINT [FK_MechanicalSpecForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[MechanicalSpecForms] CHECK CONSTRAINT [FK_MechanicalSpecForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[MechanicSafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_MechanicSafetyForms_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MechanicSafetyForms] CHECK CONSTRAINT [FK_MechanicSafetyForms_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[MechanicSafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_MechanicSafetyForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[MechanicSafetyForms] CHECK CONSTRAINT [FK_MechanicSafetyForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[MemberBankAcounts]  WITH CHECK ADD  CONSTRAINT [FK_MemberBankAcounts_BankAcountTypes_BankAcountTypeId] FOREIGN KEY([BankAcountTypeId])
REFERENCES [cedo].[BankAcountTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberBankAcounts] CHECK CONSTRAINT [FK_MemberBankAcounts_BankAcountTypes_BankAcountTypeId]
GO
ALTER TABLE [cedo].[MemberBankAcounts]  WITH CHECK ADD  CONSTRAINT [FK_MemberBankAcounts_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberBankAcounts] CHECK CONSTRAINT [FK_MemberBankAcounts_Members_MemberId]
GO
ALTER TABLE [cedo].[MemberCapacities]  WITH CHECK ADD  CONSTRAINT [FK_MemberCapacities_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberCapacities] CHECK CONSTRAINT [FK_MemberCapacities_Cities_CityId]
GO
ALTER TABLE [cedo].[MemberCapacities]  WITH CHECK ADD  CONSTRAINT [FK_MemberCapacities_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberCapacities] CHECK CONSTRAINT [FK_MemberCapacities_Members_MemberId]
GO
ALTER TABLE [cedo].[MemberCapacities]  WITH CHECK ADD  CONSTRAINT [FK_MemberCapacities_ServiceFields_FieldId] FOREIGN KEY([FieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[MemberCapacities] CHECK CONSTRAINT [FK_MemberCapacities_ServiceFields_FieldId]
GO
ALTER TABLE [cedo].[MemberCapacities]  WITH CHECK ADD  CONSTRAINT [FK_MemberCapacities_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[MemberCapacities] CHECK CONSTRAINT [FK_MemberCapacities_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[MemberCapacityDetails]  WITH CHECK ADD  CONSTRAINT [FK_MemberCapacityDetails_BuildingSubGroups_BuildingSubGroupId] FOREIGN KEY([BuildingSubGroupId])
REFERENCES [cedo].[BuildingSubGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberCapacityDetails] CHECK CONSTRAINT [FK_MemberCapacityDetails_BuildingSubGroups_BuildingSubGroupId]
GO
ALTER TABLE [cedo].[MemberCapacityDetails]  WITH CHECK ADD  CONSTRAINT [FK_MemberCapacityDetails_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberCapacityDetails] CHECK CONSTRAINT [FK_MemberCapacityDetails_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[MemberContacts]  WITH CHECK ADD  CONSTRAINT [FK_MemberContacts_ContactInfoTypes_ContactTypeId] FOREIGN KEY([ContactTypeId])
REFERENCES [cedo].[ContactInfoTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberContacts] CHECK CONSTRAINT [FK_MemberContacts_ContactInfoTypes_ContactTypeId]
GO
ALTER TABLE [cedo].[MemberContacts]  WITH CHECK ADD  CONSTRAINT [FK_MemberContacts_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberContacts] CHECK CONSTRAINT [FK_MemberContacts_Members_MemberId]
GO
ALTER TABLE [cedo].[Members]  WITH CHECK ADD  CONSTRAINT [FK_Members_MemberShipTypes_MemberShipTypeId] FOREIGN KEY([MemberShipTypeId])
REFERENCES [cedo].[MemberShipTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Members] CHECK CONSTRAINT [FK_Members_MemberShipTypes_MemberShipTypeId]
GO
ALTER TABLE [cedo].[Members]  WITH CHECK ADD  CONSTRAINT [FK_Members_MemberTypes_MemberTypeId] FOREIGN KEY([MemberTypeId])
REFERENCES [cedo].[MemberTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Members] CHECK CONSTRAINT [FK_Members_MemberTypes_MemberTypeId]
GO
ALTER TABLE [cedo].[Members]  WITH CHECK ADD  CONSTRAINT [FK_Members_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Members] CHECK CONSTRAINT [FK_Members_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[MemberServices]  WITH CHECK ADD  CONSTRAINT [FK_MemberServices_ActivityLicenses_ActivityLicenseId] FOREIGN KEY([ActivityLicenseId])
REFERENCES [cedo].[ActivityLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberServices] CHECK CONSTRAINT [FK_MemberServices_ActivityLicenses_ActivityLicenseId]
GO
ALTER TABLE [cedo].[MemberServices]  WITH CHECK ADD  CONSTRAINT [FK_MemberServices_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[MemberServices] CHECK CONSTRAINT [FK_MemberServices_Cities_CityId]
GO
ALTER TABLE [cedo].[MemberServices]  WITH CHECK ADD  CONSTRAINT [FK_MemberServices_EngineeringGrades_GradeId] FOREIGN KEY([GradeId])
REFERENCES [cedo].[EngineeringGrades] ([Id])
GO
ALTER TABLE [cedo].[MemberServices] CHECK CONSTRAINT [FK_MemberServices_EngineeringGrades_GradeId]
GO
ALTER TABLE [cedo].[MemberServices]  WITH CHECK ADD  CONSTRAINT [FK_MemberServices_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[MemberServices] CHECK CONSTRAINT [FK_MemberServices_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[MemberServices]  WITH CHECK ADD  CONSTRAINT [FK_MemberServices_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[MemberServices] CHECK CONSTRAINT [FK_MemberServices_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[MemberWorkFields]  WITH CHECK ADD  CONSTRAINT [FK_MemberWorkFields_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[MemberWorkFields] CHECK CONSTRAINT [FK_MemberWorkFields_Members_MemberId]
GO
ALTER TABLE [cedo].[MemberWorkFields]  WITH CHECK ADD  CONSTRAINT [FK_MemberWorkFields_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[MemberWorkFields] CHECK CONSTRAINT [FK_MemberWorkFields_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[Municipalities]  WITH CHECK ADD  CONSTRAINT [FK_Municipalities_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Municipalities] CHECK CONSTRAINT [FK_Municipalities_Cities_CityId]
GO
ALTER TABLE [cedo].[OnlinePaymentSettings]  WITH CHECK ADD  CONSTRAINT [FK_OnlinePaymentSettings_BillTypes_BillTypeId] FOREIGN KEY([BillTypeId])
REFERENCES [cedo].[BillTypes] ([Id])
GO
ALTER TABLE [cedo].[OnlinePaymentSettings] CHECK CONSTRAINT [FK_OnlinePaymentSettings_BillTypes_BillTypeId]
GO
ALTER TABLE [cedo].[OnlinePaymentSettings]  WITH CHECK ADD  CONSTRAINT [FK_OnlinePaymentSettings_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[OnlinePaymentSettings] CHECK CONSTRAINT [FK_OnlinePaymentSettings_Cities_CityId]
GO
ALTER TABLE [cedo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Operators] CHECK CONSTRAINT [FK_Operators_Cities_CityId]
GO
ALTER TABLE [cedo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_OperatorTypes_OperatorTypeId] FOREIGN KEY([OperatorTypeId])
REFERENCES [cedo].[OperatorTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Operators] CHECK CONSTRAINT [FK_Operators_OperatorTypes_OperatorTypeId]
GO
ALTER TABLE [cedo].[Operators]  WITH CHECK ADD  CONSTRAINT [FK_Operators_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Operators] CHECK CONSTRAINT [FK_Operators_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[OrgPersonnels]  WITH CHECK ADD  CONSTRAINT [FK_OrgPersonnels_PARA-Users_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[OrgPersonnels] CHECK CONSTRAINT [FK_OrgPersonnels_PARA-Users_Id]
GO
ALTER TABLE [cedo].[OrgUnitPersonnels]  WITH CHECK ADD  CONSTRAINT [FK_OrgUnitPersonnels_OrgPersonnels_PersonnelId] FOREIGN KEY([PersonnelId])
REFERENCES [cedo].[OrgPersonnels] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[OrgUnitPersonnels] CHECK CONSTRAINT [FK_OrgUnitPersonnels_OrgPersonnels_PersonnelId]
GO
ALTER TABLE [cedo].[OrgUnitPersonnels]  WITH CHECK ADD  CONSTRAINT [FK_OrgUnitPersonnels_OrgPosts_PostId] FOREIGN KEY([PostId])
REFERENCES [cedo].[OrgPosts] ([Id])
GO
ALTER TABLE [cedo].[OrgUnitPersonnels] CHECK CONSTRAINT [FK_OrgUnitPersonnels_OrgPosts_PostId]
GO
ALTER TABLE [cedo].[OrgUnitPersonnels]  WITH CHECK ADD  CONSTRAINT [FK_OrgUnitPersonnels_OrgUnits_UnitId] FOREIGN KEY([UnitId])
REFERENCES [cedo].[OrgUnits] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[OrgUnitPersonnels] CHECK CONSTRAINT [FK_OrgUnitPersonnels_OrgUnits_UnitId]
GO
ALTER TABLE [cedo].[OrgUnits]  WITH CHECK ADD  CONSTRAINT [FK_OrgUnits_CedoAgencies_AgencyId] FOREIGN KEY([AgencyId])
REFERENCES [cedo].[CedoAgencies] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[OrgUnits] CHECK CONSTRAINT [FK_OrgUnits_CedoAgencies_AgencyId]
GO
ALTER TABLE [cedo].[OrgUnits]  WITH CHECK ADD  CONSTRAINT [FK_OrgUnits_OrgUnits_ParentUnitId] FOREIGN KEY([ParentUnitId])
REFERENCES [cedo].[OrgUnits] ([Id])
GO
ALTER TABLE [cedo].[OrgUnits] CHECK CONSTRAINT [FK_OrgUnits_OrgUnits_ParentUnitId]
GO
ALTER TABLE [cedo].[OrgUnits]  WITH CHECK ADD  CONSTRAINT [FK_OrgUnits_OrgUnitTypes_UnitTypeId] FOREIGN KEY([UnitTypeId])
REFERENCES [cedo].[OrgUnitTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[OrgUnits] CHECK CONSTRAINT [FK_OrgUnits_OrgUnitTypes_UnitTypeId]
GO
ALTER TABLE [cedo].[Owners]  WITH CHECK ADD  CONSTRAINT [FK_Owners_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Owners] CHECK CONSTRAINT [FK_Owners_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[Owners]  WITH CHECK ADD  CONSTRAINT [FK_Owners_OwnerTypes_OwnerTypeId] FOREIGN KEY([OwnerTypeId])
REFERENCES [cedo].[OwnerTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Owners] CHECK CONSTRAINT [FK_Owners_OwnerTypes_OwnerTypeId]
GO
ALTER TABLE [cedo].[Owners]  WITH CHECK ADD  CONSTRAINT [FK_Owners_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[Owners] CHECK CONSTRAINT [FK_Owners_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[PaymentComeBackRequests]  WITH CHECK ADD  CONSTRAINT [FK_PaymentComeBackRequests_Bills_BillId] FOREIGN KEY([BillId])
REFERENCES [cedo].[Bills] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PaymentComeBackRequests] CHECK CONSTRAINT [FK_PaymentComeBackRequests_Bills_BillId]
GO
ALTER TABLE [cedo].[PaymentComeBackRequests]  WITH CHECK ADD  CONSTRAINT [FK_PaymentComeBackRequests_ChangeDesignerRequestStatuses_RequestStatusId] FOREIGN KEY([RequestStatusId])
REFERENCES [cedo].[ChangeDesignerRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PaymentComeBackRequests] CHECK CONSTRAINT [FK_PaymentComeBackRequests_ChangeDesignerRequestStatuses_RequestStatusId]
GO
ALTER TABLE [cedo].[PaymentReceipts]  WITH CHECK ADD  CONSTRAINT [FK_PaymentReceipts_Bills_BillId] FOREIGN KEY([BillId])
REFERENCES [cedo].[Bills] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PaymentReceipts] CHECK CONSTRAINT [FK_PaymentReceipts_Bills_BillId]
GO
ALTER TABLE [cedo].[PaymentReceipts]  WITH CHECK ADD  CONSTRAINT [FK_PaymentReceipts_PaymentStatuses_PaymentStatusId] FOREIGN KEY([PaymentStatusId])
REFERENCES [cedo].[PaymentStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PaymentReceipts] CHECK CONSTRAINT [FK_PaymentReceipts_PaymentStatuses_PaymentStatusId]
GO
ALTER TABLE [cedo].[PaymentReceipts]  WITH CHECK ADD  CONSTRAINT [FK_PaymentReceipts_PaymentTypes_PaymentTypeId] FOREIGN KEY([PaymentTypeId])
REFERENCES [cedo].[PaymentTypes] ([Id])
GO
ALTER TABLE [cedo].[PaymentReceipts] CHECK CONSTRAINT [FK_PaymentReceipts_PaymentTypes_PaymentTypeId]
GO
ALTER TABLE [cedo].[PlanControls]  WITH CHECK ADD  CONSTRAINT [FK_PlanControls_ConstructionLicenseDocuments_ConstructionLicenseDocumentId] FOREIGN KEY([ConstructionLicenseDocumentId])
REFERENCES [cedo].[ConstructionLicenseDocuments] ([Id])
GO
ALTER TABLE [cedo].[PlanControls] CHECK CONSTRAINT [FK_PlanControls_ConstructionLicenseDocuments_ConstructionLicenseDocumentId]
GO
ALTER TABLE [cedo].[PlanControls]  WITH CHECK ADD  CONSTRAINT [FK_PlanControls_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[PlanControls] CHECK CONSTRAINT [FK_PlanControls_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[PlanControls]  WITH CHECK ADD  CONSTRAINT [FK_PlanControls_PlanControlStatuses_PlanControlStatusId] FOREIGN KEY([PlanControlStatusId])
REFERENCES [cedo].[PlanControlStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PlanControls] CHECK CONSTRAINT [FK_PlanControls_PlanControlStatuses_PlanControlStatusId]
GO
ALTER TABLE [cedo].[PlanControlSettings]  WITH CHECK ADD  CONSTRAINT [FK_PlanControlSettings_BuildingSubGroups_BuildingSubGroupId] FOREIGN KEY([BuildingSubGroupId])
REFERENCES [cedo].[BuildingSubGroups] ([Id])
GO
ALTER TABLE [cedo].[PlanControlSettings] CHECK CONSTRAINT [FK_PlanControlSettings_BuildingSubGroups_BuildingSubGroupId]
GO
ALTER TABLE [cedo].[PlanControlSettings]  WITH CHECK ADD  CONSTRAINT [FK_PlanControlSettings_Cities_SourceCityId] FOREIGN KEY([SourceCityId])
REFERENCES [cedo].[Cities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PlanControlSettings] CHECK CONSTRAINT [FK_PlanControlSettings_Cities_SourceCityId]
GO
ALTER TABLE [cedo].[PlanControlSettings]  WITH CHECK ADD  CONSTRAINT [FK_PlanControlSettings_Cities_TargetCityId] FOREIGN KEY([TargetCityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[PlanControlSettings] CHECK CONSTRAINT [FK_PlanControlSettings_Cities_TargetCityId]
GO
ALTER TABLE [cedo].[PlanControlSettings]  WITH CHECK ADD  CONSTRAINT [FK_PlanControlSettings_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
GO
ALTER TABLE [cedo].[PlanControlSettings] CHECK CONSTRAINT [FK_PlanControlSettings_DossierType_DossierTypeId]
GO
ALTER TABLE [cedo].[PlanControlSettings]  WITH CHECK ADD  CONSTRAINT [FK_PlanControlSettings_PARA-Users_DefaultUserIdId] FOREIGN KEY([DefaultUserIdId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[PlanControlSettings] CHECK CONSTRAINT [FK_PlanControlSettings_PARA-Users_DefaultUserIdId]
GO
ALTER TABLE [cedo].[PlanControlSettings]  WITH CHECK ADD  CONSTRAINT [FK_PlanControlSettings_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PlanControlSettings] CHECK CONSTRAINT [FK_PlanControlSettings_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[PlanControlSettings]  WITH CHECK ADD  CONSTRAINT [FK_PlanControlSettings_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[PlanControlSettings] CHECK CONSTRAINT [FK_PlanControlSettings_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[ProjectWorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_ProjectWorkItemSettings_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[ProjectWorkItemSettings] CHECK CONSTRAINT [FK_ProjectWorkItemSettings_Cities_CityId]
GO
ALTER TABLE [cedo].[ProjectWorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_ProjectWorkItemSettings_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
GO
ALTER TABLE [cedo].[ProjectWorkItemSettings] CHECK CONSTRAINT [FK_ProjectWorkItemSettings_DossierType_DossierTypeId]
GO
ALTER TABLE [cedo].[RealMembers]  WITH CHECK ADD  CONSTRAINT [FK_RealMembers_HealthStatuses_HealthStatusId] FOREIGN KEY([HealthStatusId])
REFERENCES [cedo].[HealthStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[RealMembers] CHECK CONSTRAINT [FK_RealMembers_HealthStatuses_HealthStatusId]
GO
ALTER TABLE [cedo].[RealMembers]  WITH CHECK ADD  CONSTRAINT [FK_RealMembers_Members_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[RealMembers] CHECK CONSTRAINT [FK_RealMembers_Members_Id]
GO
ALTER TABLE [cedo].[SentenceCancellations]  WITH CHECK ADD  CONSTRAINT [FK_SentenceCancellations_Sentences_Id] FOREIGN KEY([Id])
REFERENCES [cedo].[Sentences] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SentenceCancellations] CHECK CONSTRAINT [FK_SentenceCancellations_Sentences_Id]
GO
ALTER TABLE [cedo].[Sentences]  WITH CHECK ADD  CONSTRAINT [FK_Sentences_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Sentences] CHECK CONSTRAINT [FK_Sentences_Members_MemberId]
GO
ALTER TABLE [cedo].[Sentences]  WITH CHECK ADD  CONSTRAINT [FK_Sentences_SentenceStatuses_SentenceStatusId] FOREIGN KEY([SentenceStatusId])
REFERENCES [cedo].[SentenceStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Sentences] CHECK CONSTRAINT [FK_Sentences_SentenceStatuses_SentenceStatusId]
GO
ALTER TABLE [cedo].[SeparationExchangeFiles]  WITH CHECK ADD  CONSTRAINT [FK_SeparationExchangeFiles_SeparationPlanRequests_RequestId] FOREIGN KEY([RequestId])
REFERENCES [cedo].[SeparationPlanRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SeparationExchangeFiles] CHECK CONSTRAINT [FK_SeparationExchangeFiles_SeparationPlanRequests_RequestId]
GO
ALTER TABLE [cedo].[SeparationInvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_SeparationInvolvedMembers_InvolvedMemberStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[InvolvedMemberStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SeparationInvolvedMembers] CHECK CONSTRAINT [FK_SeparationInvolvedMembers_InvolvedMemberStatuses_StatusId]
GO
ALTER TABLE [cedo].[SeparationInvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_SeparationInvolvedMembers_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[SeparationInvolvedMembers] CHECK CONSTRAINT [FK_SeparationInvolvedMembers_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[SeparationInvolvedMembers]  WITH CHECK ADD  CONSTRAINT [FK_SeparationInvolvedMembers_SeparationPlanRequests_SeparationRequestId] FOREIGN KEY([SeparationRequestId])
REFERENCES [cedo].[SeparationPlanRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SeparationInvolvedMembers] CHECK CONSTRAINT [FK_SeparationInvolvedMembers_SeparationPlanRequests_SeparationRequestId]
GO
ALTER TABLE [cedo].[SeparationPlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_SeparationPlanRequests_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[SeparationPlanRequests] CHECK CONSTRAINT [FK_SeparationPlanRequests_Cities_CityId]
GO
ALTER TABLE [cedo].[SeparationPlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_SeparationPlanRequests_Municipalities_MunicipalityId] FOREIGN KEY([MunicipalityId])
REFERENCES [cedo].[Municipalities] ([Id])
GO
ALTER TABLE [cedo].[SeparationPlanRequests] CHECK CONSTRAINT [FK_SeparationPlanRequests_Municipalities_MunicipalityId]
GO
ALTER TABLE [cedo].[SeparationPlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_SeparationPlanRequests_SeparationPlanRequestStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[SeparationPlanRequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SeparationPlanRequests] CHECK CONSTRAINT [FK_SeparationPlanRequests_SeparationPlanRequestStatuses_StatusId]
GO
ALTER TABLE [cedo].[SeparationPlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_SeparationPlanRequests_SeparationPlanRequestTypes_ScopeRequestTypeId] FOREIGN KEY([ScopeRequestTypeId])
REFERENCES [cedo].[SeparationPlanRequestTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SeparationPlanRequests] CHECK CONSTRAINT [FK_SeparationPlanRequests_SeparationPlanRequestTypes_ScopeRequestTypeId]
GO
ALTER TABLE [cedo].[SeparationPlanRequests]  WITH CHECK ADD  CONSTRAINT [FK_SeparationPlanRequests_ServiceRequests_ServiceRequestId] FOREIGN KEY([ServiceRequestId])
REFERENCES [cedo].[ServiceRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SeparationPlanRequests] CHECK CONSTRAINT [FK_SeparationPlanRequests_ServiceRequests_ServiceRequestId]
GO
ALTER TABLE [cedo].[SeparationRequestSurveies]  WITH CHECK ADD  CONSTRAINT [FK_SeparationRequestSurveies_SeparationInvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[SeparationInvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[SeparationRequestSurveies] CHECK CONSTRAINT [FK_SeparationRequestSurveies_SeparationInvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[SeparationRequestSurveies]  WITH CHECK ADD  CONSTRAINT [FK_SeparationRequestSurveies_SeparationPlanRequests_SeparationRequestId] FOREIGN KEY([SeparationRequestId])
REFERENCES [cedo].[SeparationPlanRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SeparationRequestSurveies] CHECK CONSTRAINT [FK_SeparationRequestSurveies_SeparationPlanRequests_SeparationRequestId]
GO
ALTER TABLE [cedo].[ServiceRequests]  WITH CHECK ADD  CONSTRAINT [FK_ServiceRequests_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[ServiceRequests] CHECK CONSTRAINT [FK_ServiceRequests_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[ServiceRequests]  WITH CHECK ADD  CONSTRAINT [FK_ServiceRequests_RequestStatuses_RequestStatusId] FOREIGN KEY([RequestStatusId])
REFERENCES [cedo].[RequestStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ServiceRequests] CHECK CONSTRAINT [FK_ServiceRequests_RequestStatuses_RequestStatusId]
GO
ALTER TABLE [cedo].[ServiceRequests]  WITH CHECK ADD  CONSTRAINT [FK_ServiceRequests_RequestTypes_RequestTypeId] FOREIGN KEY([RequestTypeId])
REFERENCES [cedo].[RequestTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ServiceRequests] CHECK CONSTRAINT [FK_ServiceRequests_RequestTypes_RequestTypeId]
GO
ALTER TABLE [cedo].[SGALetters]  WITH CHECK ADD  CONSTRAINT [FK_SGALetters_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SGALetters] CHECK CONSTRAINT [FK_SGALetters_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[SGALetters]  WITH CHECK ADD  CONSTRAINT [FK_SGALetters_SGALetterTypes_LetterTypeId] FOREIGN KEY([LetterTypeId])
REFERENCES [cedo].[SGALetterTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SGALetters] CHECK CONSTRAINT [FK_SGALetters_SGALetterTypes_LetterTypeId]
GO
ALTER TABLE [cedo].[Signatories]  WITH CHECK ADD  CONSTRAINT [FK_Signatories_PARA-Users_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[Signatories] CHECK CONSTRAINT [FK_Signatories_PARA-Users_Id]
GO
ALTER TABLE [cedo].[StructureExecutiveOperationsForms]  WITH CHECK ADD  CONSTRAINT [FK_StructureExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[StructureExecutiveOperationsForms] CHECK CONSTRAINT [FK_StructureExecutiveOperationsForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[StructurePlanControlForms]  WITH CHECK ADD  CONSTRAINT [FK_StructurePlanControlForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[StructurePlanControlForms] CHECK CONSTRAINT [FK_StructurePlanControlForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[StructureRedLinesForms]  WITH CHECK ADD  CONSTRAINT [FK_StructureRedLinesForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[StructureRedLinesForms] CHECK CONSTRAINT [FK_StructureRedLinesForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[StructureSafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_StructureSafetyForms_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[StructureSafetyForms] CHECK CONSTRAINT [FK_StructureSafetyForms_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[StructureSafetyForms]  WITH CHECK ADD  CONSTRAINT [FK_StructureSafetyForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[StructureSafetyForms] CHECK CONSTRAINT [FK_StructureSafetyForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[StructureSpecForms]  WITH CHECK ADD  CONSTRAINT [FK_StructureSpecForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[StructureSpecForms] CHECK CONSTRAINT [FK_StructureSpecForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[StudyRecords]  WITH CHECK ADD  CONSTRAINT [FK_StudyRecords_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[StudyRecords] CHECK CONSTRAINT [FK_StudyRecords_Members_MemberId]
GO
ALTER TABLE [cedo].[StudyRecords]  WITH CHECK ADD  CONSTRAINT [FK_StudyRecords_StudyGrades_StudyGradeId] FOREIGN KEY([StudyGradeId])
REFERENCES [cedo].[StudyGrades] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[StudyRecords] CHECK CONSTRAINT [FK_StudyRecords_StudyGrades_StudyGradeId]
GO
ALTER TABLE [cedo].[StudyRecords]  WITH CHECK ADD  CONSTRAINT [FK_StudyRecords_Universities_UniversityId] FOREIGN KEY([UniversityId])
REFERENCES [cedo].[Universities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[StudyRecords] CHECK CONSTRAINT [FK_StudyRecords_Universities_UniversityId]
GO
ALTER TABLE [cedo].[SubWorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_SubWorkItemSettings_BuildingSubGroups_SubGroupId] FOREIGN KEY([SubGroupId])
REFERENCES [cedo].[BuildingSubGroups] ([Id])
GO
ALTER TABLE [cedo].[SubWorkItemSettings] CHECK CONSTRAINT [FK_SubWorkItemSettings_BuildingSubGroups_SubGroupId]
GO
ALTER TABLE [cedo].[SubWorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_SubWorkItemSettings_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[SubWorkItemSettings] CHECK CONSTRAINT [FK_SubWorkItemSettings_Cities_CityId]
GO
ALTER TABLE [cedo].[SubWorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_SubWorkItemSettings_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
GO
ALTER TABLE [cedo].[SubWorkItemSettings] CHECK CONSTRAINT [FK_SubWorkItemSettings_DossierType_DossierTypeId]
GO
ALTER TABLE [cedo].[SubWorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_SubWorkItemSettings_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[SubWorkItemSettings] CHECK CONSTRAINT [FK_SubWorkItemSettings_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[SupervisionCandidates]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionCandidates_Members_MemberId] FOREIGN KEY([MemberId])
REFERENCES [cedo].[Members] ([Id])
GO
ALTER TABLE [cedo].[SupervisionCandidates] CHECK CONSTRAINT [FK_SupervisionCandidates_Members_MemberId]
GO
ALTER TABLE [cedo].[SupervisionCandidates]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionCandidates_SupervisionCandidateStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[SupervisionCandidateStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionCandidates] CHECK CONSTRAINT [FK_SupervisionCandidates_SupervisionCandidateStatuses_StatusId]
GO
ALTER TABLE [cedo].[SupervisionCandidates]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionCandidates_SupervisionFields_SupervisionFieldId] FOREIGN KEY([SupervisionFieldId])
REFERENCES [cedo].[SupervisionFields] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionCandidates] CHECK CONSTRAINT [FK_SupervisionCandidates_SupervisionFields_SupervisionFieldId]
GO
ALTER TABLE [cedo].[SupervisionFields]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionFields_EngineeringGrades_MinGradeId] FOREIGN KEY([MinGradeId])
REFERENCES [cedo].[EngineeringGrades] ([Id])
GO
ALTER TABLE [cedo].[SupervisionFields] CHECK CONSTRAINT [FK_SupervisionFields_EngineeringGrades_MinGradeId]
GO
ALTER TABLE [cedo].[SupervisionFields]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionFields_ServiceFields_FieldId] FOREIGN KEY([FieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[SupervisionFields] CHECK CONSTRAINT [FK_SupervisionFields_ServiceFields_FieldId]
GO
ALTER TABLE [cedo].[SupervisionFields]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionFields_SupervisionOrders_SupervisionOrderId] FOREIGN KEY([SupervisionOrderId])
REFERENCES [cedo].[SupervisionOrders] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionFields] CHECK CONSTRAINT [FK_SupervisionFields_SupervisionOrders_SupervisionOrderId]
GO
ALTER TABLE [cedo].[SupervisionItemAnswers]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionItemAnswers_SupervisionStepForms_FormId] FOREIGN KEY([FormId])
REFERENCES [cedo].[SupervisionStepForms] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionItemAnswers] CHECK CONSTRAINT [FK_SupervisionItemAnswers_SupervisionStepForms_FormId]
GO
ALTER TABLE [cedo].[SupervisionItemAnswers]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionItemAnswers_SupervisionStepItems_ItemId] FOREIGN KEY([ItemId])
REFERENCES [cedo].[SupervisionStepItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionItemAnswers] CHECK CONSTRAINT [FK_SupervisionItemAnswers_SupervisionStepItems_ItemId]
GO
ALTER TABLE [cedo].[SupervisionOrders]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionOrders_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionOrders] CHECK CONSTRAINT [FK_SupervisionOrders_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[SupervisionOrders]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionOrders_SupervisionOrderStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [cedo].[SupervisionOrderStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionOrders] CHECK CONSTRAINT [FK_SupervisionOrders_SupervisionOrderStatuses_StatusId]
GO
ALTER TABLE [cedo].[SupervisionOrders]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionOrders_SupervisionOrderTypes_TypeId] FOREIGN KEY([TypeId])
REFERENCES [cedo].[SupervisionOrderTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionOrders] CHECK CONSTRAINT [FK_SupervisionOrders_SupervisionOrderTypes_TypeId]
GO
ALTER TABLE [cedo].[SupervisionStepForms]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepForms_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[SupervisionStepForms] CHECK CONSTRAINT [FK_SupervisionStepForms_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[SupervisionStepForms]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepForms_SupervisionSteps_StepId] FOREIGN KEY([StepId])
REFERENCES [cedo].[SupervisionSteps] ([Id])
GO
ALTER TABLE [cedo].[SupervisionStepForms] CHECK CONSTRAINT [FK_SupervisionStepForms_SupervisionSteps_StepId]
GO
ALTER TABLE [cedo].[SupervisionStepItemGroups]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepItemGroups_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionStepItemGroups] CHECK CONSTRAINT [FK_SupervisionStepItemGroups_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[SupervisionStepItemGroups]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepItemGroups_SupervisionSteps_SupervisionStepId] FOREIGN KEY([SupervisionStepId])
REFERENCES [cedo].[SupervisionSteps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionStepItemGroups] CHECK CONSTRAINT [FK_SupervisionStepItemGroups_SupervisionSteps_SupervisionStepId]
GO
ALTER TABLE [cedo].[SupervisionStepItemOptions]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepItemOptions_SupervisionStepItems_SupervisionStepItemId] FOREIGN KEY([SupervisionStepItemId])
REFERENCES [cedo].[SupervisionStepItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionStepItemOptions] CHECK CONSTRAINT [FK_SupervisionStepItemOptions_SupervisionStepItems_SupervisionStepItemId]
GO
ALTER TABLE [cedo].[SupervisionStepItems]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepItems_SupervisionStepItemGroups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [cedo].[SupervisionStepItemGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionStepItems] CHECK CONSTRAINT [FK_SupervisionStepItems_SupervisionStepItemGroups_GroupId]
GO
ALTER TABLE [cedo].[SupervisionStepPayments]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepPayments_InvolvedMembers_InvolvedMemberId] FOREIGN KEY([InvolvedMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[SupervisionStepPayments] CHECK CONSTRAINT [FK_SupervisionStepPayments_InvolvedMembers_InvolvedMemberId]
GO
ALTER TABLE [cedo].[SupervisionStepPayments]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepPayments_SupervisionStepPaymentStatuses_PaymentStatusId] FOREIGN KEY([PaymentStatusId])
REFERENCES [cedo].[SupervisionStepPaymentStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionStepPayments] CHECK CONSTRAINT [FK_SupervisionStepPayments_SupervisionStepPaymentStatuses_PaymentStatusId]
GO
ALTER TABLE [cedo].[SupervisionStepPayments]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionStepPayments_SupervisionSteps_SupervisionStepId] FOREIGN KEY([SupervisionStepId])
REFERENCES [cedo].[SupervisionSteps] ([Id])
GO
ALTER TABLE [cedo].[SupervisionStepPayments] CHECK CONSTRAINT [FK_SupervisionStepPayments_SupervisionSteps_SupervisionStepId]
GO
ALTER TABLE [cedo].[SupervisionSteps]  WITH CHECK ADD  CONSTRAINT [FK_SupervisionSteps_ServiceFields_FieldId] FOREIGN KEY([FieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[SupervisionSteps] CHECK CONSTRAINT [FK_SupervisionSteps_ServiceFields_FieldId]
GO
ALTER TABLE [cedo].[TeacherLessons]  WITH CHECK ADD  CONSTRAINT [FK_TeacherLessons_Lessons_LessonId] FOREIGN KEY([LessonId])
REFERENCES [cedo].[Lessons] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[TeacherLessons] CHECK CONSTRAINT [FK_TeacherLessons_Lessons_LessonId]
GO
ALTER TABLE [cedo].[TeacherLessons]  WITH CHECK ADD  CONSTRAINT [FK_TeacherLessons_MemberServices_MemberServiceId] FOREIGN KEY([MemberServiceId])
REFERENCES [cedo].[MemberServices] ([Id])
GO
ALTER TABLE [cedo].[TeacherLessons] CHECK CONSTRAINT [FK_TeacherLessons_MemberServices_MemberServiceId]
GO
ALTER TABLE [cedo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Territories] CHECK CONSTRAINT [FK_Territories_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_PasswayTypes_PasswayTypeId] FOREIGN KEY([PasswayTypeId])
REFERENCES [cedo].[PasswayTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Territories] CHECK CONSTRAINT [FK_Territories_PasswayTypes_PasswayTypeId]
GO
ALTER TABLE [cedo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_TerritoryTypes_TerritoryTypeId] FOREIGN KEY([TerritoryTypeId])
REFERENCES [cedo].[TerritoryTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[Territories] CHECK CONSTRAINT [FK_Territories_TerritoryTypes_TerritoryTypeId]
GO
ALTER TABLE [cedo].[UserDelegations]  WITH CHECK ADD  CONSTRAINT [FK_UserDelegations_PARA-Users_DelegateRecieverId] FOREIGN KEY([DelegateRecieverId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[UserDelegations] CHECK CONSTRAINT [FK_UserDelegations_PARA-Users_DelegateRecieverId]
GO
ALTER TABLE [cedo].[UserDelegations]  WITH CHECK ADD  CONSTRAINT [FK_UserDelegations_PARA-Users_DelegateSenderId] FOREIGN KEY([DelegateSenderId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [cedo].[UserDelegations] CHECK CONSTRAINT [FK_UserDelegations_PARA-Users_DelegateSenderId]
GO
ALTER TABLE [cedo].[ValidMemberServices]  WITH CHECK ADD  CONSTRAINT [FK_ValidMemberServices_LegalMemberTypes_LegalMemberTypeId] FOREIGN KEY([LegalMemberTypeId])
REFERENCES [cedo].[LegalMemberTypes] ([Id])
GO
ALTER TABLE [cedo].[ValidMemberServices] CHECK CONSTRAINT [FK_ValidMemberServices_LegalMemberTypes_LegalMemberTypeId]
GO
ALTER TABLE [cedo].[ValidMemberServices]  WITH CHECK ADD  CONSTRAINT [FK_ValidMemberServices_MemberShipTypes_MembershipTypeId] FOREIGN KEY([MembershipTypeId])
REFERENCES [cedo].[MemberShipTypes] ([Id])
GO
ALTER TABLE [cedo].[ValidMemberServices] CHECK CONSTRAINT [FK_ValidMemberServices_MemberShipTypes_MembershipTypeId]
GO
ALTER TABLE [cedo].[ValidMemberServices]  WITH CHECK ADD  CONSTRAINT [FK_ValidMemberServices_MemberTypes_MemberTypeId] FOREIGN KEY([MemberTypeId])
REFERENCES [cedo].[MemberTypes] ([Id])
GO
ALTER TABLE [cedo].[ValidMemberServices] CHECK CONSTRAINT [FK_ValidMemberServices_MemberTypes_MemberTypeId]
GO
ALTER TABLE [cedo].[ValidMemberServices]  WITH CHECK ADD  CONSTRAINT [FK_ValidMemberServices_ServiceFields_MemberFieldId] FOREIGN KEY([MemberFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[ValidMemberServices] CHECK CONSTRAINT [FK_ValidMemberServices_ServiceFields_MemberFieldId]
GO
ALTER TABLE [cedo].[ValidMemberServices]  WITH CHECK ADD  CONSTRAINT [FK_ValidMemberServices_ServiceFields_ServiceFieldId] FOREIGN KEY([ServiceFieldId])
REFERENCES [cedo].[ServiceFields] ([Id])
GO
ALTER TABLE [cedo].[ValidMemberServices] CHECK CONSTRAINT [FK_ValidMemberServices_ServiceFields_ServiceFieldId]
GO
ALTER TABLE [cedo].[ValidMemberServices]  WITH CHECK ADD  CONSTRAINT [FK_ValidMemberServices_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [cedo].[ServiceTypes] ([Id])
GO
ALTER TABLE [cedo].[ValidMemberServices] CHECK CONSTRAINT [FK_ValidMemberServices_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [cedo].[ViolationReportDetails]  WITH CHECK ADD  CONSTRAINT [FK_ViolationReportDetails_ViolationReports_ViolationReportId] FOREIGN KEY([ViolationReportId])
REFERENCES [cedo].[ViolationReports] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ViolationReportDetails] CHECK CONSTRAINT [FK_ViolationReportDetails_ViolationReports_ViolationReportId]
GO
ALTER TABLE [cedo].[ViolationReportDetails]  WITH CHECK ADD  CONSTRAINT [FK_ViolationReportDetails_ViolationReportSubjectTypes_MainSubjectId] FOREIGN KEY([MainSubjectId])
REFERENCES [cedo].[ViolationReportSubjectTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ViolationReportDetails] CHECK CONSTRAINT [FK_ViolationReportDetails_ViolationReportSubjectTypes_MainSubjectId]
GO
ALTER TABLE [cedo].[ViolationReports]  WITH CHECK ADD  CONSTRAINT [FK_ViolationReports_ConstructionLicenses_ConstructionLicenseId] FOREIGN KEY([ConstructionLicenseId])
REFERENCES [cedo].[ConstructionLicenses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ViolationReports] CHECK CONSTRAINT [FK_ViolationReports_ConstructionLicenses_ConstructionLicenseId]
GO
ALTER TABLE [cedo].[ViolationReports]  WITH CHECK ADD  CONSTRAINT [FK_ViolationReports_InvolvedMembers_ReporterMemberId] FOREIGN KEY([ReporterMemberId])
REFERENCES [cedo].[InvolvedMembers] ([Id])
GO
ALTER TABLE [cedo].[ViolationReports] CHECK CONSTRAINT [FK_ViolationReports_InvolvedMembers_ReporterMemberId]
GO
ALTER TABLE [cedo].[ViolationReportUsers]  WITH CHECK ADD  CONSTRAINT [FK_ViolationReportUsers_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[ViolationReportUsers] CHECK CONSTRAINT [FK_ViolationReportUsers_Cities_CityId]
GO
ALTER TABLE [cedo].[ViolationReportUsers]  WITH CHECK ADD  CONSTRAINT [FK_ViolationReportUsers_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[ViolationReportUsers] CHECK CONSTRAINT [FK_ViolationReportUsers_PARA-Users_UserId]
GO
ALTER TABLE [cedo].[WorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_WorkItemSettings_BuildingGroups_BuildingGroupId] FOREIGN KEY([BuildingGroupId])
REFERENCES [cedo].[BuildingGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [cedo].[WorkItemSettings] CHECK CONSTRAINT [FK_WorkItemSettings_BuildingGroups_BuildingGroupId]
GO
ALTER TABLE [cedo].[WorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_WorkItemSettings_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [cedo].[Cities] ([Id])
GO
ALTER TABLE [cedo].[WorkItemSettings] CHECK CONSTRAINT [FK_WorkItemSettings_Cities_CityId]
GO
ALTER TABLE [cedo].[WorkItemSettings]  WITH CHECK ADD  CONSTRAINT [FK_WorkItemSettings_DossierType_DossierTypeId] FOREIGN KEY([DossierTypeId])
REFERENCES [cedo].[DossierType] ([Id])
GO
ALTER TABLE [cedo].[WorkItemSettings] CHECK CONSTRAINT [FK_WorkItemSettings_DossierType_DossierTypeId]
GO
ALTER TABLE [dbo].[AttributePropertyValues]  WITH CHECK ADD  CONSTRAINT [FK_AttributePropertyValues_PropertyAttributes_PropertyAttributeId] FOREIGN KEY([PropertyAttributeId])
REFERENCES [dbo].[PropertyAttributes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AttributePropertyValues] CHECK CONSTRAINT [FK_AttributePropertyValues_PropertyAttributes_PropertyAttributeId]
GO
ALTER TABLE [dbo].[BoundaryEvents]  WITH CHECK ADD  CONSTRAINT [FK_BoundaryEvents_FlowNodes_BoundarySourceId] FOREIGN KEY([BoundarySourceId])
REFERENCES [dbo].[FlowNodes] ([Id])
GO
ALTER TABLE [dbo].[BoundaryEvents] CHECK CONSTRAINT [FK_BoundaryEvents_FlowNodes_BoundarySourceId]
GO
ALTER TABLE [dbo].[BoundaryEvents]  WITH CHECK ADD  CONSTRAINT [FK_BoundaryEvents_FlowNodes_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BoundaryEvents] CHECK CONSTRAINT [FK_BoundaryEvents_FlowNodes_Id]
GO
ALTER TABLE [dbo].[CancelEvent]  WITH CHECK ADD  CONSTRAINT [FK_CancelEvent_FlowEvents_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowEvents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CancelEvent] CHECK CONSTRAINT [FK_CancelEvent_FlowEvents_Id]
GO
ALTER TABLE [dbo].[ControllerActionCode]  WITH CHECK ADD  CONSTRAINT [FK_ControllerActionCode_ControllerActions_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[ControllerActions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ControllerActionCode] CHECK CONSTRAINT [FK_ControllerActionCode_ControllerActions_Id]
GO
ALTER TABLE [dbo].[ControllerActions]  WITH CHECK ADD  CONSTRAINT [FK_ControllerActions_ControllerActionTypes_ActionTypeId] FOREIGN KEY([ActionTypeId])
REFERENCES [dbo].[ControllerActionTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ControllerActions] CHECK CONSTRAINT [FK_ControllerActions_ControllerActionTypes_ActionTypeId]
GO
ALTER TABLE [dbo].[ControllerActions]  WITH CHECK ADD  CONSTRAINT [FK_ControllerActions_Controllers_ControllerId] FOREIGN KEY([ControllerId])
REFERENCES [dbo].[Controllers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ControllerActions] CHECK CONSTRAINT [FK_ControllerActions_Controllers_ControllerId]
GO
ALTER TABLE [dbo].[Controllers]  WITH CHECK ADD  CONSTRAINT [FK_Controllers_ControllerTypes_ControllerTypeId] FOREIGN KEY([ControllerTypeId])
REFERENCES [dbo].[ControllerTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Controllers] CHECK CONSTRAINT [FK_Controllers_ControllerTypes_ControllerTypeId]
GO
ALTER TABLE [dbo].[Controllers]  WITH CHECK ADD  CONSTRAINT [FK_Controllers_DataSourceEntities_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[DataSourceEntities] ([Id])
GO
ALTER TABLE [dbo].[Controllers] CHECK CONSTRAINT [FK_Controllers_DataSourceEntities_EntityId]
GO
ALTER TABLE [dbo].[Controllers]  WITH CHECK ADD  CONSTRAINT [FK_Controllers_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Controllers] CHECK CONSTRAINT [FK_Controllers_Projects_ProjectId]
GO
ALTER TABLE [dbo].[DashboardGadgets]  WITH CHECK ADD  CONSTRAINT [FK_DashboardGadgets_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DashboardGadgets] CHECK CONSTRAINT [FK_DashboardGadgets_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[DashboardGadgets]  WITH CHECK ADD  CONSTRAINT [FK_DashboardGadgets_ProjectViews_GadgetViewId] FOREIGN KEY([GadgetViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DashboardGadgets] CHECK CONSTRAINT [FK_DashboardGadgets_ProjectViews_GadgetViewId]
GO
ALTER TABLE [dbo].[DataSourceDiagrams]  WITH CHECK ADD  CONSTRAINT [FK_DataSourceDiagrams_ProjectDataSources_DataSourceId] FOREIGN KEY([DataSourceId])
REFERENCES [dbo].[ProjectDataSources] ([Id])
GO
ALTER TABLE [dbo].[DataSourceDiagrams] CHECK CONSTRAINT [FK_DataSourceDiagrams_ProjectDataSources_DataSourceId]
GO
ALTER TABLE [dbo].[DataSourceEntities]  WITH CHECK ADD  CONSTRAINT [FK_DataSourceEntities_ProjectDataSources_ProjectDataSourceId] FOREIGN KEY([ProjectDataSourceId])
REFERENCES [dbo].[ProjectDataSources] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DataSourceEntities] CHECK CONSTRAINT [FK_DataSourceEntities_ProjectDataSources_ProjectDataSourceId]
GO
ALTER TABLE [dbo].[DecisionTables]  WITH CHECK ADD  CONSTRAINT [FK_DecisionTables_PARA-Users_ArchivedById] FOREIGN KEY([ArchivedById])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [dbo].[DecisionTables] CHECK CONSTRAINT [FK_DecisionTables_PARA-Users_ArchivedById]
GO
ALTER TABLE [dbo].[DecisionTables]  WITH CHECK ADD  CONSTRAINT [FK_DecisionTables_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DecisionTables] CHECK CONSTRAINT [FK_DecisionTables_Projects_ProjectId]
GO
ALTER TABLE [dbo].[DecisionTableTasks]  WITH CHECK ADD  CONSTRAINT [FK_DecisionTableTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DecisionTableTasks] CHECK CONSTRAINT [FK_DecisionTableTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[DiagramEntities]  WITH CHECK ADD  CONSTRAINT [FK_DiagramEntities_DataSourceDiagrams_DiagramId] FOREIGN KEY([DiagramId])
REFERENCES [dbo].[DataSourceDiagrams] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiagramEntities] CHECK CONSTRAINT [FK_DiagramEntities_DataSourceDiagrams_DiagramId]
GO
ALTER TABLE [dbo].[DiagramEntities]  WITH CHECK ADD  CONSTRAINT [FK_DiagramEntities_DataSourceEntities_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[DataSourceEntities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiagramEntities] CHECK CONSTRAINT [FK_DiagramEntities_DataSourceEntities_EntityId]
GO
ALTER TABLE [dbo].[DocumentIndices]  WITH CHECK ADD  CONSTRAINT [FK_DocumentIndices_DocumentIndices_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[DocumentIndices] ([Id])
GO
ALTER TABLE [dbo].[DocumentIndices] CHECK CONSTRAINT [FK_DocumentIndices_DocumentIndices_ParentId]
GO
ALTER TABLE [dbo].[DocumentIndices]  WITH CHECK ADD  CONSTRAINT [FK_DocumentIndices_ProjectHelps_HelpId] FOREIGN KEY([HelpId])
REFERENCES [dbo].[ProjectHelps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DocumentIndices] CHECK CONSTRAINT [FK_DocumentIndices_ProjectHelps_HelpId]
GO
ALTER TABLE [dbo].[EntityProperties]  WITH CHECK ADD  CONSTRAINT [FK_EntityProperties_DataSourceEntities_ProjectEntityId] FOREIGN KEY([ProjectEntityId])
REFERENCES [dbo].[DataSourceEntities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EntityProperties] CHECK CONSTRAINT [FK_EntityProperties_DataSourceEntities_ProjectEntityId]
GO
ALTER TABLE [dbo].[EnumEntityItems]  WITH CHECK ADD  CONSTRAINT [FK_EnumEntityItems_DataSourceEntities_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[DataSourceEntities] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EnumEntityItems] CHECK CONSTRAINT [FK_EnumEntityItems_DataSourceEntities_EntityId]
GO
ALTER TABLE [dbo].[ErrorCatchEvent]  WITH CHECK ADD  CONSTRAINT [FK_ErrorCatchEvent_FlowEvents_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowEvents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ErrorCatchEvent] CHECK CONSTRAINT [FK_ErrorCatchEvent_FlowEvents_Id]
GO
ALTER TABLE [dbo].[FirewallRules]  WITH CHECK ADD  CONSTRAINT [FK_FirewallRules_Firewalls_FirewallId] FOREIGN KEY([FirewallId])
REFERENCES [dbo].[Firewalls] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FirewallRules] CHECK CONSTRAINT [FK_FirewallRules_Firewalls_FirewallId]
GO
ALTER TABLE [dbo].[FlowActors]  WITH CHECK ADD  CONSTRAINT [FK_FlowActors_FlowVersions_FlowVersionId] FOREIGN KEY([FlowVersionId])
REFERENCES [dbo].[FlowVersions] ([Id])
GO
ALTER TABLE [dbo].[FlowActors] CHECK CONSTRAINT [FK_FlowActors_FlowVersions_FlowVersionId]
GO
ALTER TABLE [dbo].[FlowConnectors]  WITH CHECK ADD  CONSTRAINT [FK_FlowConnectors_FlowConnectionType_ConnectionTypeId] FOREIGN KEY([ConnectionTypeId])
REFERENCES [dbo].[FlowConnectionType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowConnectors] CHECK CONSTRAINT [FK_FlowConnectors_FlowConnectionType_ConnectionTypeId]
GO
ALTER TABLE [dbo].[FlowConnectors]  WITH CHECK ADD  CONSTRAINT [FK_FlowConnectors_FlowNodes_SourceNodeId] FOREIGN KEY([SourceNodeId])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowConnectors] CHECK CONSTRAINT [FK_FlowConnectors_FlowNodes_SourceNodeId]
GO
ALTER TABLE [dbo].[FlowConnectors]  WITH CHECK ADD  CONSTRAINT [FK_FlowConnectors_FlowNodes_TargetNodeId] FOREIGN KEY([TargetNodeId])
REFERENCES [dbo].[FlowNodes] ([Id])
GO
ALTER TABLE [dbo].[FlowConnectors] CHECK CONSTRAINT [FK_FlowConnectors_FlowNodes_TargetNodeId]
GO
ALTER TABLE [dbo].[FlowEvents]  WITH CHECK ADD  CONSTRAINT [FK_FlowEvents_FlowEventModes_EventModeId] FOREIGN KEY([EventModeId])
REFERENCES [dbo].[FlowEventModes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowEvents] CHECK CONSTRAINT [FK_FlowEvents_FlowEventModes_EventModeId]
GO
ALTER TABLE [dbo].[FlowEvents]  WITH CHECK ADD  CONSTRAINT [FK_FlowEvents_FlowEventTriggers_EventTriggerId] FOREIGN KEY([EventTriggerId])
REFERENCES [dbo].[FlowEventTriggers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowEvents] CHECK CONSTRAINT [FK_FlowEvents_FlowEventTriggers_EventTriggerId]
GO
ALTER TABLE [dbo].[FlowEvents]  WITH CHECK ADD  CONSTRAINT [FK_FlowEvents_FlowEventTypes_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[FlowEventTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowEvents] CHECK CONSTRAINT [FK_FlowEvents_FlowEventTypes_EventTypeId]
GO
ALTER TABLE [dbo].[FlowEvents]  WITH CHECK ADD  CONSTRAINT [FK_FlowEvents_FlowNodes_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowEvents] CHECK CONSTRAINT [FK_FlowEvents_FlowNodes_Id]
GO
ALTER TABLE [dbo].[FlowGatewaies]  WITH CHECK ADD  CONSTRAINT [FK_FlowGatewaies_FlowNodes_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowGatewaies] CHECK CONSTRAINT [FK_FlowGatewaies_FlowNodes_Id]
GO
ALTER TABLE [dbo].[FlowInstanceLogs]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstanceLogs_FlowInstances_FlowInstanceId] FOREIGN KEY([FlowInstanceId])
REFERENCES [dbo].[FlowInstances] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowInstanceLogs] CHECK CONSTRAINT [FK_FlowInstanceLogs_FlowInstances_FlowInstanceId]
GO
ALTER TABLE [dbo].[FlowInstanceLogs]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstanceLogs_LogTypes_LogTypeId] FOREIGN KEY([LogTypeId])
REFERENCES [dbo].[LogTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowInstanceLogs] CHECK CONSTRAINT [FK_FlowInstanceLogs_LogTypes_LogTypeId]
GO
ALTER TABLE [dbo].[FlowInstancePauseLogs]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstancePauseLogs_FlowInstances_InstanceId] FOREIGN KEY([InstanceId])
REFERENCES [dbo].[FlowInstances] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowInstancePauseLogs] CHECK CONSTRAINT [FK_FlowInstancePauseLogs_FlowInstances_InstanceId]
GO
ALTER TABLE [dbo].[FlowInstances]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstances_FlowInstances_ParentInstanceId] FOREIGN KEY([ParentInstanceId])
REFERENCES [dbo].[FlowInstances] ([Id])
GO
ALTER TABLE [dbo].[FlowInstances] CHECK CONSTRAINT [FK_FlowInstances_FlowInstances_ParentInstanceId]
GO
ALTER TABLE [dbo].[FlowInstances]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstances_FlowInstanceStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[FlowInstanceStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowInstances] CHECK CONSTRAINT [FK_FlowInstances_FlowInstanceStatuses_StatusId]
GO
ALTER TABLE [dbo].[FlowInstances]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstances_FlowVersions_FlowVersionId] FOREIGN KEY([FlowVersionId])
REFERENCES [dbo].[FlowVersions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowInstances] CHECK CONSTRAINT [FK_FlowInstances_FlowVersions_FlowVersionId]
GO
ALTER TABLE [dbo].[FlowInstances]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstances_InstanceUserGroups_UserGroupId] FOREIGN KEY([UserGroupId])
REFERENCES [dbo].[InstanceUserGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowInstances] CHECK CONSTRAINT [FK_FlowInstances_InstanceUserGroups_UserGroupId]
GO
ALTER TABLE [dbo].[FlowInstanceVariables]  WITH CHECK ADD  CONSTRAINT [FK_FlowInstanceVariables_FlowInstances_FlowInstanceId] FOREIGN KEY([FlowInstanceId])
REFERENCES [dbo].[FlowInstances] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowInstanceVariables] CHECK CONSTRAINT [FK_FlowInstanceVariables_FlowInstances_FlowInstanceId]
GO
ALTER TABLE [dbo].[FlowNodeLifeCycleEvents]  WITH CHECK ADD  CONSTRAINT [FK_FlowNodeLifeCycleEvents_FlowNodeLifeCycleEventTypes_EventTypeId] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[FlowNodeLifeCycleEventTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowNodeLifeCycleEvents] CHECK CONSTRAINT [FK_FlowNodeLifeCycleEvents_FlowNodeLifeCycleEventTypes_EventTypeId]
GO
ALTER TABLE [dbo].[FlowNodeLifeCycleEvents]  WITH CHECK ADD  CONSTRAINT [FK_FlowNodeLifeCycleEvents_FlowNodes_NodeId] FOREIGN KEY([NodeId])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowNodeLifeCycleEvents] CHECK CONSTRAINT [FK_FlowNodeLifeCycleEvents_FlowNodes_NodeId]
GO
ALTER TABLE [dbo].[FlowNodes]  WITH CHECK ADD  CONSTRAINT [FK_FlowNodes_FlowActors_ActorId] FOREIGN KEY([ActorId])
REFERENCES [dbo].[FlowActors] ([Id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[FlowNodes] CHECK CONSTRAINT [FK_FlowNodes_FlowActors_ActorId]
GO
ALTER TABLE [dbo].[FlowNodes]  WITH CHECK ADD  CONSTRAINT [FK_FlowNodes_FlowNodeTypes_NodeTypeId] FOREIGN KEY([NodeTypeId])
REFERENCES [dbo].[FlowNodeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowNodes] CHECK CONSTRAINT [FK_FlowNodes_FlowNodeTypes_NodeTypeId]
GO
ALTER TABLE [dbo].[FlowNodes]  WITH CHECK ADD  CONSTRAINT [FK_FlowNodes_FlowVersions_FlowVersionId] FOREIGN KEY([FlowVersionId])
REFERENCES [dbo].[FlowVersions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowNodes] CHECK CONSTRAINT [FK_FlowNodes_FlowVersions_FlowVersionId]
GO
ALTER TABLE [dbo].[Flows]  WITH CHECK ADD  CONSTRAINT [FK_Flows_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Flows] CHECK CONSTRAINT [FK_Flows_Projects_ProjectId]
GO
ALTER TABLE [dbo].[FlowStarterTasks]  WITH CHECK ADD  CONSTRAINT [FK_FlowStarterTasks_Flows_FlowId] FOREIGN KEY([FlowId])
REFERENCES [dbo].[Flows] ([Id])
GO
ALTER TABLE [dbo].[FlowStarterTasks] CHECK CONSTRAINT [FK_FlowStarterTasks_Flows_FlowId]
GO
ALTER TABLE [dbo].[FlowStarterTasks]  WITH CHECK ADD  CONSTRAINT [FK_FlowStarterTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowStarterTasks] CHECK CONSTRAINT [FK_FlowStarterTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[FlowSteps]  WITH CHECK ADD  CONSTRAINT [FK_FlowSteps_FlowInstances_FlowInstanceId] FOREIGN KEY([FlowInstanceId])
REFERENCES [dbo].[FlowInstances] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowSteps] CHECK CONSTRAINT [FK_FlowSteps_FlowInstances_FlowInstanceId]
GO
ALTER TABLE [dbo].[FlowSteps]  WITH CHECK ADD  CONSTRAINT [FK_FlowSteps_FlowNodes_FlowNodeId] FOREIGN KEY([FlowNodeId])
REFERENCES [dbo].[FlowNodes] ([Id])
GO
ALTER TABLE [dbo].[FlowSteps] CHECK CONSTRAINT [FK_FlowSteps_FlowNodes_FlowNodeId]
GO
ALTER TABLE [dbo].[FlowSteps]  WITH CHECK ADD  CONSTRAINT [FK_FlowSteps_FlowStepStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[FlowStepStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowSteps] CHECK CONSTRAINT [FK_FlowSteps_FlowStepStatuses_StatusId]
GO
ALTER TABLE [dbo].[FlowSteps]  WITH CHECK ADD  CONSTRAINT [FK_FlowSteps_PARA-Users_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [dbo].[FlowSteps] CHECK CONSTRAINT [FK_FlowSteps_PARA-Users_OwnerId]
GO
ALTER TABLE [dbo].[FlowVersions]  WITH CHECK ADD  CONSTRAINT [FK_FlowVersions_Flows_FlowId] FOREIGN KEY([FlowId])
REFERENCES [dbo].[Flows] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FlowVersions] CHECK CONSTRAINT [FK_FlowVersions_Flows_FlowId]
GO
ALTER TABLE [dbo].[FormEditTasks]  WITH CHECK ADD  CONSTRAINT [FK_FormEditTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FormEditTasks] CHECK CONSTRAINT [FK_FormEditTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[FormEditTasks]  WITH CHECK ADD  CONSTRAINT [FK_FormEditTasks_ProjectViews_EditViewId] FOREIGN KEY([EditViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[FormEditTasks] CHECK CONSTRAINT [FK_FormEditTasks_ProjectViews_EditViewId]
GO
ALTER TABLE [dbo].[FormEditTasks]  WITH CHECK ADD  CONSTRAINT [FK_FormEditTasks_ProjectViews_ViewRecordViewId] FOREIGN KEY([ViewRecordViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[FormEditTasks] CHECK CONSTRAINT [FK_FormEditTasks_ProjectViews_ViewRecordViewId]
GO
ALTER TABLE [dbo].[FormEntryTasks]  WITH CHECK ADD  CONSTRAINT [FK_FormEntryTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FormEntryTasks] CHECK CONSTRAINT [FK_FormEntryTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[FormEntryTasks]  WITH CHECK ADD  CONSTRAINT [FK_FormEntryTasks_ProjectViews_AddViewId] FOREIGN KEY([AddViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[FormEntryTasks] CHECK CONSTRAINT [FK_FormEntryTasks_ProjectViews_AddViewId]
GO
ALTER TABLE [dbo].[FormEntryTasks]  WITH CHECK ADD  CONSTRAINT [FK_FormEntryTasks_ProjectViews_EditViewId] FOREIGN KEY([EditViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[FormEntryTasks] CHECK CONSTRAINT [FK_FormEntryTasks_ProjectViews_EditViewId]
GO
ALTER TABLE [dbo].[FormEntryTasks]  WITH CHECK ADD  CONSTRAINT [FK_FormEntryTasks_ProjectViews_ViewRecordViewId] FOREIGN KEY([ViewRecordViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[FormEntryTasks] CHECK CONSTRAINT [FK_FormEntryTasks_ProjectViews_ViewRecordViewId]
GO
ALTER TABLE [dbo].[IncludedResources]  WITH CHECK ADD  CONSTRAINT [FK_IncludedResources_IncludedResourceTypes_ResourceTypeId] FOREIGN KEY([ResourceTypeId])
REFERENCES [dbo].[IncludedResourceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[IncludedResources] CHECK CONSTRAINT [FK_IncludedResources_IncludedResourceTypes_ResourceTypeId]
GO
ALTER TABLE [dbo].[IncludedResources]  WITH CHECK ADD  CONSTRAINT [FK_IncludedResources_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[IncludedResources] CHECK CONSTRAINT [FK_IncludedResources_Projects_ProjectId]
GO
ALTER TABLE [dbo].[InstanceUserGroupMembers]  WITH CHECK ADD  CONSTRAINT [FK_InstanceUserGroupMembers_InstanceUserGroups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [dbo].[InstanceUserGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[InstanceUserGroupMembers] CHECK CONSTRAINT [FK_InstanceUserGroupMembers_InstanceUserGroups_GroupId]
GO
ALTER TABLE [dbo].[InstanceUserGroupMembers]  WITH CHECK ADD  CONSTRAINT [FK_InstanceUserGroupMembers_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[InstanceUserGroupMembers] CHECK CONSTRAINT [FK_InstanceUserGroupMembers_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[MenuItemExternalLinkSettings]  WITH CHECK ADD  CONSTRAINT [FK_MenuItemExternalLinkSettings_MenuItems_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[MenuItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuItemExternalLinkSettings] CHECK CONSTRAINT [FK_MenuItemExternalLinkSettings_MenuItems_Id]
GO
ALTER TABLE [dbo].[MenuItemFlowLinkSettings]  WITH CHECK ADD  CONSTRAINT [FK_MenuItemFlowLinkSettings_Flows_FlowId] FOREIGN KEY([FlowId])
REFERENCES [dbo].[Flows] ([Id])
GO
ALTER TABLE [dbo].[MenuItemFlowLinkSettings] CHECK CONSTRAINT [FK_MenuItemFlowLinkSettings_Flows_FlowId]
GO
ALTER TABLE [dbo].[MenuItemFlowLinkSettings]  WITH CHECK ADD  CONSTRAINT [FK_MenuItemFlowLinkSettings_MenuItems_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[MenuItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuItemFlowLinkSettings] CHECK CONSTRAINT [FK_MenuItemFlowLinkSettings_MenuItems_Id]
GO
ALTER TABLE [dbo].[MenuItems]  WITH CHECK ADD  CONSTRAINT [FK_MenuItems_MenuItems_ParentMenuItemId] FOREIGN KEY([ParentMenuItemId])
REFERENCES [dbo].[MenuItems] ([Id])
GO
ALTER TABLE [dbo].[MenuItems] CHECK CONSTRAINT [FK_MenuItems_MenuItems_ParentMenuItemId]
GO
ALTER TABLE [dbo].[MenuItems]  WITH CHECK ADD  CONSTRAINT [FK_MenuItems_ProjectMenus_ProjectMenuId] FOREIGN KEY([ProjectMenuId])
REFERENCES [dbo].[ProjectMenus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuItems] CHECK CONSTRAINT [FK_MenuItems_ProjectMenus_ProjectMenuId]
GO
ALTER TABLE [dbo].[MenuItemViewLinkSettings]  WITH CHECK ADD  CONSTRAINT [FK_MenuItemViewLinkSettings_MenuItems_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[MenuItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MenuItemViewLinkSettings] CHECK CONSTRAINT [FK_MenuItemViewLinkSettings_MenuItems_Id]
GO
ALTER TABLE [dbo].[MenuItemViewLinkSettings]  WITH CHECK ADD  CONSTRAINT [FK_MenuItemViewLinkSettings_ProjectViews_EntityViewId] FOREIGN KEY([EntityViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[MenuItemViewLinkSettings] CHECK CONSTRAINT [FK_MenuItemViewLinkSettings_ProjectViews_EntityViewId]
GO
ALTER TABLE [dbo].[MessageCatchEvents]  WITH CHECK ADD  CONSTRAINT [FK_MessageCatchEvents_FlowEvents_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowEvents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MessageCatchEvents] CHECK CONSTRAINT [FK_MessageCatchEvents_FlowEvents_Id]
GO
ALTER TABLE [dbo].[MessageThrowEvents]  WITH CHECK ADD  CONSTRAINT [FK_MessageThrowEvents_FlowEvents_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowEvents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MessageThrowEvents] CHECK CONSTRAINT [FK_MessageThrowEvents_FlowEvents_Id]
GO
ALTER TABLE [dbo].[NodeAnnotationLayouts]  WITH CHECK ADD  CONSTRAINT [FK_NodeAnnotationLayouts_FlowNodes_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NodeAnnotationLayouts] CHECK CONSTRAINT [FK_NodeAnnotationLayouts_FlowNodes_Id]
GO
ALTER TABLE [dbo].[NodeShapeStyles]  WITH CHECK ADD  CONSTRAINT [FK_NodeShapeStyles_FlowNodes_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NodeShapeStyles] CHECK CONSTRAINT [FK_NodeShapeStyles_FlowNodes_Id]
GO
ALTER TABLE [dbo].[NodeTasks]  WITH CHECK ADD  CONSTRAINT [FK_NodeTasks_FlowNodes_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowNodes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NodeTasks] CHECK CONSTRAINT [FK_NodeTasks_FlowNodes_Id]
GO
ALTER TABLE [dbo].[NodeTasks]  WITH CHECK ADD  CONSTRAINT [FK_NodeTasks_TaskTypes_TaskTypeId] FOREIGN KEY([TaskTypeId])
REFERENCES [dbo].[TaskTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NodeTasks] CHECK CONSTRAINT [FK_NodeTasks_TaskTypes_TaskTypeId]
GO
ALTER TABLE [dbo].[OrganizationPosts]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationPosts_OrganizationUnits_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[OrganizationUnits] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrganizationPosts] CHECK CONSTRAINT [FK_OrganizationPosts_OrganizationUnits_ParentId]
GO
ALTER TABLE [dbo].[OrganizationUnits]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationUnits_OrganizationUnits_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[OrganizationUnits] ([Id])
GO
ALTER TABLE [dbo].[OrganizationUnits] CHECK CONSTRAINT [FK_OrganizationUnits_OrganizationUnits_ParentId]
GO
ALTER TABLE [dbo].[PageMetaTags]  WITH CHECK ADD  CONSTRAINT [FK_PageMetaTags_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PageMetaTags] CHECK CONSTRAINT [FK_PageMetaTags_Projects_ProjectId]
GO
ALTER TABLE [dbo].[PARA-RoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_PARA-RoleClaims_PARA-Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[PARA-Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PARA-RoleClaims] CHECK CONSTRAINT [FK_PARA-RoleClaims_PARA-Roles_RoleId]
GO
ALTER TABLE [dbo].[PARA-UserClaims]  WITH CHECK ADD  CONSTRAINT [FK_PARA-UserClaims_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PARA-UserClaims] CHECK CONSTRAINT [FK_PARA-UserClaims_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[PARA-UserLogins]  WITH CHECK ADD  CONSTRAINT [FK_PARA-UserLogins_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PARA-UserLogins] CHECK CONSTRAINT [FK_PARA-UserLogins_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[PARA-UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_PARA-UserRoles_PARA-Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[PARA-Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PARA-UserRoles] CHECK CONSTRAINT [FK_PARA-UserRoles_PARA-Roles_RoleId]
GO
ALTER TABLE [dbo].[PARA-UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_PARA-UserRoles_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PARA-UserRoles] CHECK CONSTRAINT [FK_PARA-UserRoles_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[PARA-UserTokens]  WITH CHECK ADD  CONSTRAINT [FK_PARA-UserTokens_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PARA-UserTokens] CHECK CONSTRAINT [FK_PARA-UserTokens_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[PersonelDossiers]  WITH CHECK ADD  CONSTRAINT [FK_PersonelDossiers_Personels_PersonelId] FOREIGN KEY([PersonelId])
REFERENCES [dbo].[Personels] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonelDossiers] CHECK CONSTRAINT [FK_PersonelDossiers_Personels_PersonelId]
GO
ALTER TABLE [dbo].[PersonelDossiers]  WITH CHECK ADD  CONSTRAINT [FK_PersonelDossiers_WorkingStatuses_WorkingStatusId] FOREIGN KEY([WorkingStatusId])
REFERENCES [dbo].[WorkingStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonelDossiers] CHECK CONSTRAINT [FK_PersonelDossiers_WorkingStatuses_WorkingStatusId]
GO
ALTER TABLE [dbo].[PersonelGroups]  WITH CHECK ADD  CONSTRAINT [FK_PersonelGroups_OrganizationGroups_OrganizationGroupId] FOREIGN KEY([OrganizationGroupId])
REFERENCES [dbo].[OrganizationGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonelGroups] CHECK CONSTRAINT [FK_PersonelGroups_OrganizationGroups_OrganizationGroupId]
GO
ALTER TABLE [dbo].[PersonelGroups]  WITH CHECK ADD  CONSTRAINT [FK_PersonelGroups_Personels_PersonelId] FOREIGN KEY([PersonelId])
REFERENCES [dbo].[Personels] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonelGroups] CHECK CONSTRAINT [FK_PersonelGroups_Personels_PersonelId]
GO
ALTER TABLE [dbo].[PersonelPosts]  WITH CHECK ADD  CONSTRAINT [FK_PersonelPosts_OrganizationPosts_OrganizationPostId] FOREIGN KEY([OrganizationPostId])
REFERENCES [dbo].[OrganizationPosts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonelPosts] CHECK CONSTRAINT [FK_PersonelPosts_OrganizationPosts_OrganizationPostId]
GO
ALTER TABLE [dbo].[PersonelPosts]  WITH CHECK ADD  CONSTRAINT [FK_PersonelPosts_Personels_PersonelId] FOREIGN KEY([PersonelId])
REFERENCES [dbo].[Personels] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PersonelPosts] CHECK CONSTRAINT [FK_PersonelPosts_Personels_PersonelId]
GO
ALTER TABLE [dbo].[Personels]  WITH CHECK ADD  CONSTRAINT [FK_Personels_UserProfiles_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[UserProfiles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Personels] CHECK CONSTRAINT [FK_Personels_UserProfiles_Id]
GO
ALTER TABLE [dbo].[PreviousSteps]  WITH CHECK ADD  CONSTRAINT [FK_PreviousSteps_FlowSteps_PrevStepId] FOREIGN KEY([PrevStepId])
REFERENCES [dbo].[FlowSteps] ([Id])
GO
ALTER TABLE [dbo].[PreviousSteps] CHECK CONSTRAINT [FK_PreviousSteps_FlowSteps_PrevStepId]
GO
ALTER TABLE [dbo].[PreviousSteps]  WITH CHECK ADD  CONSTRAINT [FK_PreviousSteps_FlowSteps_StepId] FOREIGN KEY([StepId])
REFERENCES [dbo].[FlowSteps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PreviousSteps] CHECK CONSTRAINT [FK_PreviousSteps_FlowSteps_StepId]
GO
ALTER TABLE [dbo].[ProjectCodeDirectories]  WITH CHECK ADD  CONSTRAINT [FK_ProjectCodeDirectories_ProjectCodeDirectories_ParentDirectoryId] FOREIGN KEY([ParentDirectoryId])
REFERENCES [dbo].[ProjectCodeDirectories] ([Id])
GO
ALTER TABLE [dbo].[ProjectCodeDirectories] CHECK CONSTRAINT [FK_ProjectCodeDirectories_ProjectCodeDirectories_ParentDirectoryId]
GO
ALTER TABLE [dbo].[ProjectCodeDirectories]  WITH CHECK ADD  CONSTRAINT [FK_ProjectCodeDirectories_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectCodeDirectories] CHECK CONSTRAINT [FK_ProjectCodeDirectories_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ProjectCodeFiles]  WITH CHECK ADD  CONSTRAINT [FK_ProjectCodeFiles_ProjectCodeDirectories_ParentDirectoryId] FOREIGN KEY([ParentDirectoryId])
REFERENCES [dbo].[ProjectCodeDirectories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectCodeFiles] CHECK CONSTRAINT [FK_ProjectCodeFiles_ProjectCodeDirectories_ParentDirectoryId]
GO
ALTER TABLE [dbo].[ProjectDataSources]  WITH CHECK ADD  CONSTRAINT [FK_ProjectDataSources_DataSourceTypes_DataSourceTypeId] FOREIGN KEY([DataSourceTypeId])
REFERENCES [dbo].[DataSourceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectDataSources] CHECK CONSTRAINT [FK_ProjectDataSources_DataSourceTypes_DataSourceTypeId]
GO
ALTER TABLE [dbo].[ProjectDataSources]  WITH CHECK ADD  CONSTRAINT [FK_ProjectDataSources_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectDataSources] CHECK CONSTRAINT [FK_ProjectDataSources_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ProjectHelps]  WITH CHECK ADD  CONSTRAINT [FK_ProjectHelps_Projects_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectHelps] CHECK CONSTRAINT [FK_ProjectHelps_Projects_Id]
GO
ALTER TABLE [dbo].[ProjectLoginSettings]  WITH CHECK ADD  CONSTRAINT [FK_ProjectLoginSettings_Projects_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectLoginSettings] CHECK CONSTRAINT [FK_ProjectLoginSettings_Projects_Id]
GO
ALTER TABLE [dbo].[ProjectLoginSettings]  WITH CHECK ADD  CONSTRAINT [FK_ProjectLoginSettings_TwoFactorModes_TwoFactorModeId] FOREIGN KEY([TwoFactorModeId])
REFERENCES [dbo].[TwoFactorModes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectLoginSettings] CHECK CONSTRAINT [FK_ProjectLoginSettings_TwoFactorModes_TwoFactorModeId]
GO
ALTER TABLE [dbo].[ProjectMenus]  WITH CHECK ADD  CONSTRAINT [FK_ProjectMenus_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectMenus] CHECK CONSTRAINT [FK_ProjectMenus_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ProjectRecentDocuments]  WITH CHECK ADD  CONSTRAINT [FK_ProjectRecentDocuments_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectRecentDocuments] CHECK CONSTRAINT [FK_ProjectRecentDocuments_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ProjectTranslations]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTranslations_LocalizablePhrases_LocalizablePhraseId] FOREIGN KEY([LocalizablePhraseId])
REFERENCES [dbo].[LocalizablePhrases] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectTranslations] CHECK CONSTRAINT [FK_ProjectTranslations_LocalizablePhrases_LocalizablePhraseId]
GO
ALTER TABLE [dbo].[ProjectTranslations]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTranslations_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectTranslations] CHECK CONSTRAINT [FK_ProjectTranslations_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ProjectTranslations]  WITH CHECK ADD  CONSTRAINT [FK_ProjectTranslations_SupportedCultures_CultureId] FOREIGN KEY([CultureId])
REFERENCES [dbo].[SupportedCultures] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectTranslations] CHECK CONSTRAINT [FK_ProjectTranslations_SupportedCultures_CultureId]
GO
ALTER TABLE [dbo].[ProjectViews]  WITH CHECK ADD  CONSTRAINT [FK_ProjectViews_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectViews] CHECK CONSTRAINT [FK_ProjectViews_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ProjectViews]  WITH CHECK ADD  CONSTRAINT [FK_ProjectViews_ViewTypes_ViewTypeId] FOREIGN KEY([ViewTypeId])
REFERENCES [dbo].[ViewTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectViews] CHECK CONSTRAINT [FK_ProjectViews_ViewTypes_ViewTypeId]
GO
ALTER TABLE [dbo].[ProjectWebPushSettings]  WITH CHECK ADD  CONSTRAINT [FK_ProjectWebPushSettings_Projects_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProjectWebPushSettings] CHECK CONSTRAINT [FK_ProjectWebPushSettings_Projects_Id]
GO
ALTER TABLE [dbo].[PropertyAttributes]  WITH CHECK ADD  CONSTRAINT [FK_PropertyAttributes_EntityProperties_EntityPropertyId] FOREIGN KEY([EntityPropertyId])
REFERENCES [dbo].[EntityProperties] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PropertyAttributes] CHECK CONSTRAINT [FK_PropertyAttributes_EntityProperties_EntityPropertyId]
GO
ALTER TABLE [dbo].[PwaPreCacheActions]  WITH CHECK ADD  CONSTRAINT [FK_PwaPreCacheActions_ControllerActions_ActionId] FOREIGN KEY([ActionId])
REFERENCES [dbo].[ControllerActions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PwaPreCacheActions] CHECK CONSTRAINT [FK_PwaPreCacheActions_ControllerActions_ActionId]
GO
ALTER TABLE [dbo].[PwaPreCacheActions]  WITH CHECK ADD  CONSTRAINT [FK_PwaPreCacheActions_PwaSettings_SettingId] FOREIGN KEY([SettingId])
REFERENCES [dbo].[PwaSettings] ([Id])
GO
ALTER TABLE [dbo].[PwaPreCacheActions] CHECK CONSTRAINT [FK_PwaPreCacheActions_PwaSettings_SettingId]
GO
ALTER TABLE [dbo].[PwaSettings]  WITH CHECK ADD  CONSTRAINT [FK_PwaSettings_Projects_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PwaSettings] CHECK CONSTRAINT [FK_PwaSettings_Projects_Id]
GO
ALTER TABLE [dbo].[PwaShortcutActions]  WITH CHECK ADD  CONSTRAINT [FK_PwaShortcutActions_ControllerActions_ActionId] FOREIGN KEY([ActionId])
REFERENCES [dbo].[ControllerActions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PwaShortcutActions] CHECK CONSTRAINT [FK_PwaShortcutActions_ControllerActions_ActionId]
GO
ALTER TABLE [dbo].[PwaShortcutActions]  WITH CHECK ADD  CONSTRAINT [FK_PwaShortcutActions_PwaSettings_SettingId] FOREIGN KEY([SettingId])
REFERENCES [dbo].[PwaSettings] ([Id])
GO
ALTER TABLE [dbo].[PwaShortcutActions] CHECK CONSTRAINT [FK_PwaShortcutActions_PwaSettings_SettingId]
GO
ALTER TABLE [dbo].[RoleMenu]  WITH CHECK ADD  CONSTRAINT [FK_RoleMenu_PARA-Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[PARA-Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoleMenu] CHECK CONSTRAINT [FK_RoleMenu_PARA-Roles_RoleId]
GO
ALTER TABLE [dbo].[RoleMenu]  WITH CHECK ADD  CONSTRAINT [FK_RoleMenu_ProjectMenus_MenuId] FOREIGN KEY([MenuId])
REFERENCES [dbo].[ProjectMenus] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoleMenu] CHECK CONSTRAINT [FK_RoleMenu_ProjectMenus_MenuId]
GO
ALTER TABLE [dbo].[RuleDestinations]  WITH CHECK ADD  CONSTRAINT [FK_RuleDestinations_FirewallRules_RuleId] FOREIGN KEY([RuleId])
REFERENCES [dbo].[FirewallRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleDestinations] CHECK CONSTRAINT [FK_RuleDestinations_FirewallRules_RuleId]
GO
ALTER TABLE [dbo].[RuleDeviceSources]  WITH CHECK ADD  CONSTRAINT [FK_RuleDeviceSources_FirewallRules_RuleId] FOREIGN KEY([RuleId])
REFERENCES [dbo].[FirewallRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleDeviceSources] CHECK CONSTRAINT [FK_RuleDeviceSources_FirewallRules_RuleId]
GO
ALTER TABLE [dbo].[RuleIdentitySources]  WITH CHECK ADD  CONSTRAINT [FK_RuleIdentitySources_FirewallRules_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FirewallRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleIdentitySources] CHECK CONSTRAINT [FK_RuleIdentitySources_FirewallRules_Id]
GO
ALTER TABLE [dbo].[RuleRoleSources]  WITH CHECK ADD  CONSTRAINT [FK_RuleRoleSources_FirewallRules_RuleId] FOREIGN KEY([RuleId])
REFERENCES [dbo].[FirewallRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleRoleSources] CHECK CONSTRAINT [FK_RuleRoleSources_FirewallRules_RuleId]
GO
ALTER TABLE [dbo].[RuleRoleSources]  WITH CHECK ADD  CONSTRAINT [FK_RuleRoleSources_PARA-Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[PARA-Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleRoleSources] CHECK CONSTRAINT [FK_RuleRoleSources_PARA-Roles_RoleId]
GO
ALTER TABLE [dbo].[RuleSubnetSources]  WITH CHECK ADD  CONSTRAINT [FK_RuleSubnetSources_FirewallRules_RuleId] FOREIGN KEY([RuleId])
REFERENCES [dbo].[FirewallRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleSubnetSources] CHECK CONSTRAINT [FK_RuleSubnetSources_FirewallRules_RuleId]
GO
ALTER TABLE [dbo].[RuleTimeSources]  WITH CHECK ADD  CONSTRAINT [FK_RuleTimeSources_FirewallRules_RuleId] FOREIGN KEY([RuleId])
REFERENCES [dbo].[FirewallRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleTimeSources] CHECK CONSTRAINT [FK_RuleTimeSources_FirewallRules_RuleId]
GO
ALTER TABLE [dbo].[RuleUserSources]  WITH CHECK ADD  CONSTRAINT [FK_RuleUserSources_FirewallRules_RuleId] FOREIGN KEY([RuleId])
REFERENCES [dbo].[FirewallRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleUserSources] CHECK CONSTRAINT [FK_RuleUserSources_FirewallRules_RuleId]
GO
ALTER TABLE [dbo].[RuleUserSources]  WITH CHECK ADD  CONSTRAINT [FK_RuleUserSources_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RuleUserSources] CHECK CONSTRAINT [FK_RuleUserSources_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[ScriptExecuteTasks]  WITH CHECK ADD  CONSTRAINT [FK_ScriptExecuteTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ScriptExecuteTasks] CHECK CONSTRAINT [FK_ScriptExecuteTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[SendEmailTasks]  WITH CHECK ADD  CONSTRAINT [FK_SendEmailTasks_EmailAccounts_EmailAccountId] FOREIGN KEY([EmailAccountId])
REFERENCES [dbo].[EmailAccounts] ([Id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[SendEmailTasks] CHECK CONSTRAINT [FK_SendEmailTasks_EmailAccounts_EmailAccountId]
GO
ALTER TABLE [dbo].[SendEmailTasks]  WITH CHECK ADD  CONSTRAINT [FK_SendEmailTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SendEmailTasks] CHECK CONSTRAINT [FK_SendEmailTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[SendSmsTasks]  WITH CHECK ADD  CONSTRAINT [FK_SendSmsTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SendSmsTasks] CHECK CONSTRAINT [FK_SendSmsTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[SendSmsTasks]  WITH CHECK ADD  CONSTRAINT [FK_SendSmsTasks_SmsAccounts_SmsAccountId] FOREIGN KEY([SmsAccountId])
REFERENCES [dbo].[SmsAccounts] ([Id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[SendSmsTasks] CHECK CONSTRAINT [FK_SendSmsTasks_SmsAccounts_SmsAccountId]
GO
ALTER TABLE [dbo].[SentSmses]  WITH CHECK ADD  CONSTRAINT [FK_SentSmses_SmsAccounts_SmsAccountId] FOREIGN KEY([SmsAccountId])
REFERENCES [dbo].[SmsAccounts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SentSmses] CHECK CONSTRAINT [FK_SentSmses_SmsAccounts_SmsAccountId]
GO
ALTER TABLE [dbo].[SolutionResources]  WITH CHECK ADD  CONSTRAINT [FK_SolutionResources_Projects_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SolutionResources] CHECK CONSTRAINT [FK_SolutionResources_Projects_Id]
GO
ALTER TABLE [dbo].[SqlServerDataSourceConfigs]  WITH CHECK ADD  CONSTRAINT [FK_SqlServerDataSourceConfigs_ProjectDataSources_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[ProjectDataSources] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SqlServerDataSourceConfigs] CHECK CONSTRAINT [FK_SqlServerDataSourceConfigs_ProjectDataSources_Id]
GO
ALTER TABLE [dbo].[StepOwnerPools]  WITH CHECK ADD  CONSTRAINT [FK_StepOwnerPools_FlowSteps_StepId] FOREIGN KEY([StepId])
REFERENCES [dbo].[FlowSteps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StepOwnerPools] CHECK CONSTRAINT [FK_StepOwnerPools_FlowSteps_StepId]
GO
ALTER TABLE [dbo].[StepOwnerPools]  WITH CHECK ADD  CONSTRAINT [FK_StepOwnerPools_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [dbo].[StepOwnerPools] CHECK CONSTRAINT [FK_StepOwnerPools_PARA-Users_UserId]
GO
ALTER TABLE [dbo].[StepRecordDataLogs]  WITH CHECK ADD  CONSTRAINT [FK_StepRecordDataLogs_StepRecordLogs_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[StepRecordLogs] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StepRecordDataLogs] CHECK CONSTRAINT [FK_StepRecordDataLogs_StepRecordLogs_Id]
GO
ALTER TABLE [dbo].[StepRecordLogs]  WITH CHECK ADD  CONSTRAINT [FK_StepRecordLogs_FlowSteps_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowSteps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StepRecordLogs] CHECK CONSTRAINT [FK_StepRecordLogs_FlowSteps_Id]
GO
ALTER TABLE [dbo].[TakenUserActions]  WITH CHECK ADD  CONSTRAINT [FK_TakenUserActions_FlowSteps_StepId] FOREIGN KEY([StepId])
REFERENCES [dbo].[FlowSteps] ([Id])
GO
ALTER TABLE [dbo].[TakenUserActions] CHECK CONSTRAINT [FK_TakenUserActions_FlowSteps_StepId]
GO
ALTER TABLE [dbo].[TakenUserActions]  WITH CHECK ADD  CONSTRAINT [FK_TakenUserActions_UserActionTaskActions_ActionId] FOREIGN KEY([ActionId])
REFERENCES [dbo].[UserActionTaskActions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TakenUserActions] CHECK CONSTRAINT [FK_TakenUserActions_UserActionTaskActions_ActionId]
GO
ALTER TABLE [dbo].[TimerEvents]  WITH CHECK ADD  CONSTRAINT [FK_TimerEvents_FlowEvents_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowEvents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TimerEvents] CHECK CONSTRAINT [FK_TimerEvents_FlowEvents_Id]
GO
ALTER TABLE [dbo].[TimerEvents]  WITH CHECK ADD  CONSTRAINT [FK_TimerEvents_TimerTypes_TimerTypeId] FOREIGN KEY([TimerTypeId])
REFERENCES [dbo].[TimerTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TimerEvents] CHECK CONSTRAINT [FK_TimerEvents_TimerTypes_TimerTypeId]
GO
ALTER TABLE [dbo].[TimerTicks]  WITH CHECK ADD  CONSTRAINT [FK_TimerTicks_FlowSteps_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[FlowSteps] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TimerTicks] CHECK CONSTRAINT [FK_TimerTicks_FlowSteps_Id]
GO
ALTER TABLE [dbo].[UserActionTaskActions]  WITH CHECK ADD  CONSTRAINT [FK_UserActionTaskActions_UserActionTasks_UserActionTaskId] FOREIGN KEY([UserActionTaskId])
REFERENCES [dbo].[UserActionTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserActionTaskActions] CHECK CONSTRAINT [FK_UserActionTaskActions_UserActionTasks_UserActionTaskId]
GO
ALTER TABLE [dbo].[UserActionTasks]  WITH CHECK ADD  CONSTRAINT [FK_UserActionTasks_NodeTasks_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[NodeTasks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserActionTasks] CHECK CONSTRAINT [FK_UserActionTasks_NodeTasks_Id]
GO
ALTER TABLE [dbo].[UserActionTasks]  WITH CHECK ADD  CONSTRAINT [FK_UserActionTasks_ProjectViews_ViewId] FOREIGN KEY([ViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[UserActionTasks] CHECK CONSTRAINT [FK_UserActionTasks_ProjectViews_ViewId]
GO
ALTER TABLE [dbo].[UserProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserProfiles_PARA-Users_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserProfiles] CHECK CONSTRAINT [FK_UserProfiles_PARA-Users_Id]
GO
ALTER TABLE [dbo].[ViewActions]  WITH CHECK ADD  CONSTRAINT [FK_ViewActions_ControllerActions_ActionId] FOREIGN KEY([ActionId])
REFERENCES [dbo].[ControllerActions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ViewActions] CHECK CONSTRAINT [FK_ViewActions_ControllerActions_ActionId]
GO
ALTER TABLE [dbo].[ViewActions]  WITH CHECK ADD  CONSTRAINT [FK_ViewActions_ProjectViews_ViewId] FOREIGN KEY([ViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[ViewActions] CHECK CONSTRAINT [FK_ViewActions_ProjectViews_ViewId]
GO
ALTER TABLE [dbo].[ViewComponents]  WITH CHECK ADD  CONSTRAINT [FK_ViewComponents_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ViewComponents] CHECK CONSTRAINT [FK_ViewComponents_Projects_ProjectId]
GO
ALTER TABLE [dbo].[ViewComponentViews]  WITH CHECK ADD  CONSTRAINT [FK_ViewComponentViews_ProjectViews_ViewId] FOREIGN KEY([ViewId])
REFERENCES [dbo].[ProjectViews] ([Id])
GO
ALTER TABLE [dbo].[ViewComponentViews] CHECK CONSTRAINT [FK_ViewComponentViews_ProjectViews_ViewId]
GO
ALTER TABLE [dbo].[ViewComponentViews]  WITH CHECK ADD  CONSTRAINT [FK_ViewComponentViews_ViewComponents_ViewComponentId] FOREIGN KEY([ViewComponentId])
REFERENCES [dbo].[ViewComponents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ViewComponentViews] CHECK CONSTRAINT [FK_ViewComponentViews_ViewComponents_ViewComponentId]
GO
ALTER TABLE [dbo].[WebPushSettings]  WITH CHECK ADD  CONSTRAINT [FK_WebPushSettings_PARA-Users_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebPushSettings] CHECK CONSTRAINT [FK_WebPushSettings_PARA-Users_Id]
GO
ALTER TABLE [dbo].[WebPushSubscriptions]  WITH CHECK ADD  CONSTRAINT [FK_WebPushSubscriptions_WebPushSettings_WebPushSettingId] FOREIGN KEY([WebPushSettingId])
REFERENCES [dbo].[WebPushSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebPushSubscriptions] CHECK CONSTRAINT [FK_WebPushSubscriptions_WebPushSettings_WebPushSettingId]
GO
ALTER TABLE [dbo].[WebServiceMethodRequestHeaders]  WITH CHECK ADD  CONSTRAINT [FK_WebServiceMethodRequestHeaders_WebServiceMethods_MethodId] FOREIGN KEY([MethodId])
REFERENCES [dbo].[WebServiceMethods] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebServiceMethodRequestHeaders] CHECK CONSTRAINT [FK_WebServiceMethodRequestHeaders_WebServiceMethods_MethodId]
GO
ALTER TABLE [dbo].[WebServiceMethodRouteArguments]  WITH CHECK ADD  CONSTRAINT [FK_WebServiceMethodRouteArguments_WebServiceMethods_MethodId] FOREIGN KEY([MethodId])
REFERENCES [dbo].[WebServiceMethods] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebServiceMethodRouteArguments] CHECK CONSTRAINT [FK_WebServiceMethodRouteArguments_WebServiceMethods_MethodId]
GO
ALTER TABLE [dbo].[WebServiceMethods]  WITH CHECK ADD  CONSTRAINT [FK_WebServiceMethods_WebServiceMethodTypes_WebServiceMethodTypeId] FOREIGN KEY([WebServiceMethodTypeId])
REFERENCES [dbo].[WebServiceMethodTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebServiceMethods] CHECK CONSTRAINT [FK_WebServiceMethods_WebServiceMethodTypes_WebServiceMethodTypeId]
GO
ALTER TABLE [dbo].[WebServiceMethods]  WITH CHECK ADD  CONSTRAINT [FK_WebServiceMethods_WebServices_WebServiceId] FOREIGN KEY([WebServiceId])
REFERENCES [dbo].[WebServices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebServiceMethods] CHECK CONSTRAINT [FK_WebServiceMethods_WebServices_WebServiceId]
GO
ALTER TABLE [dbo].[WebServiceMethodUrlArguments]  WITH CHECK ADD  CONSTRAINT [FK_WebServiceMethodUrlArguments_WebServiceMethods_MethodId] FOREIGN KEY([MethodId])
REFERENCES [dbo].[WebServiceMethods] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebServiceMethodUrlArguments] CHECK CONSTRAINT [FK_WebServiceMethodUrlArguments_WebServiceMethods_MethodId]
GO
ALTER TABLE [dbo].[WebServices]  WITH CHECK ADD  CONSTRAINT [FK_WebServices_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebServices] CHECK CONSTRAINT [FK_WebServices_Projects_ProjectId]
GO
ALTER TABLE [dbo].[WebServices]  WITH CHECK ADD  CONSTRAINT [FK_WebServices_WebServiceTypes_WebServiceTypeId] FOREIGN KEY([WebServiceTypeId])
REFERENCES [dbo].[WebServiceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WebServices] CHECK CONSTRAINT [FK_WebServices_WebServiceTypes_WebServiceTypeId]
GO
ALTER TABLE [puyahlpdsk].[DepartmentUsers]  WITH CHECK ADD  CONSTRAINT [FK_DepartmentUsers_Departments_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [puyahlpdsk].[Departments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [puyahlpdsk].[DepartmentUsers] CHECK CONSTRAINT [FK_DepartmentUsers_Departments_DepartmentId]
GO
ALTER TABLE [puyahlpdsk].[DepartmentUsers]  WITH CHECK ADD  CONSTRAINT [FK_DepartmentUsers_PARA-Users_UserAccountId] FOREIGN KEY([UserAccountId])
REFERENCES [dbo].[PARA-Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [puyahlpdsk].[DepartmentUsers] CHECK CONSTRAINT [FK_DepartmentUsers_PARA-Users_UserAccountId]
GO
ALTER TABLE [puyahlpdsk].[SupportTickets]  WITH CHECK ADD  CONSTRAINT [FK_SupportTickets_Departments_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [puyahlpdsk].[Departments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [puyahlpdsk].[SupportTickets] CHECK CONSTRAINT [FK_SupportTickets_Departments_DepartmentId]
GO
ALTER TABLE [puyahlpdsk].[SupportTickets]  WITH CHECK ADD  CONSTRAINT [FK_SupportTickets_TicketStatuses_StatusId] FOREIGN KEY([StatusId])
REFERENCES [puyahlpdsk].[TicketStatuses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [puyahlpdsk].[SupportTickets] CHECK CONSTRAINT [FK_SupportTickets_TicketStatuses_StatusId]
GO
ALTER TABLE [puyahlpdsk].[TicketReplies]  WITH CHECK ADD  CONSTRAINT [FK_TicketReplies_PARA-Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[PARA-Users] ([Id])
GO
ALTER TABLE [puyahlpdsk].[TicketReplies] CHECK CONSTRAINT [FK_TicketReplies_PARA-Users_UserId]
GO
ALTER TABLE [puyahlpdsk].[TicketReplies]  WITH CHECK ADD  CONSTRAINT [FK_TicketReplies_SupportTickets_TicketId] FOREIGN KEY([TicketId])
REFERENCES [puyahlpdsk].[SupportTickets] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [puyahlpdsk].[TicketReplies] CHECK CONSTRAINT [FK_TicketReplies_SupportTickets_TicketId]
GO
/****** Object:  StoredProcedure [dbo].[insert_attendee]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insert_attendee]   
	-- Add the parameters for the stored procedure here
	@attendeeId nvarchar(50),
	@courseHoldingId nvarchar(50),
	@holdingLessonId nvarchar(50),
	@memberId int,
	@amount int,
	@token nvarchar(128)
AS
BEGIN
	DECLARE @holdingMemberId UNIQUEIDENTIFIER;
	DECLARE @billId int;
	
	SET @holdingMemberId = NEWID();

	INSERT INTO cedo.CourseHoldingMembers Values(@holdingMemberId, CONVERT(uniqueidentifier, @courseHoldingId), @memberId, GETDATE());

	INSERT INTO cedo.Bills Values (NULL, 100, GETDATE(), N'صورت حساب دوره آموزشی', NULL, NULL, NULL, @holdingMemberId, NULL);
	SELECT @billId = @@IDENTITY

	INSERT INTO cedo.BillDetails Values (@billId, 100, @amount, 0)
	INSERT INTO cedo.PaymentReceipts Values (@billId, @amount, GETDATE(), NULL, 2, NULL, NULL, NULL, @token, NULL, NULL, NULL)

	INSERT INTO cedo.Attendees Values (CONVERT(uniqueidentifier, @attendeeId), CONVERT(uniqueidentifier, @holdingLessonId), 4, GETDATE(), NULL, NULL, @holdingMemberId, NULL, NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[MissingIndexes]    Script Date: 8/16/2024 6:11:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MissingIndexes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Select All
	SELECT
    db.[name] AS [DatabaseName],
    id.[object_id] AS [ObjectID],
    OBJECT_NAME(id.[object_id], db.[database_id]) AS [ObjectName],
    gs.avg_total_user_cost * ( gs.avg_user_impact / 100.0 ) * ( gs.user_seeks + gs.user_scans ) AS ImprovementMeasure,
    gs.[user_seeks] * gs.[avg_total_user_cost] * ( gs.[avg_user_impact] * 0.01 ) AS [IndexAdvantage],
    'CREATE INDEX [IX_' + OBJECT_NAME(id.[object_id], db.[database_id]) + '_' + REPLACE(REPLACE(REPLACE(ISNULL(id.[equality_columns], ''), ', ', '_'), '[', ''), ']', '') + CASE WHEN id.[equality_columns] IS NOT NULL AND id.[inequality_columns] IS NOT NULL THEN '_' ELSE '' END + REPLACE(REPLACE(REPLACE(ISNULL(id.[inequality_columns], ''), ', ', '_'), '[', ''), ']', '') + '_' + LEFT(CAST(NEWID() AS [NVARCHAR](64)), 5) + ']' + ' ON ' + id.[statement] + ' (' + ISNULL(id.[equality_columns], '') + CASE WHEN id.[equality_columns] IS NOT NULL AND id.[inequality_columns] IS NOT NULL THEN ',' ELSE '' END + ISNULL(id.[inequality_columns], '') + ')' + ISNULL(' INCLUDE (' + id.[included_columns] + ')', '') AS [ProposedIndex],
    id.[statement] AS [FullyQualifiedObjectName],
    id.[equality_columns] AS [EqualityColumns],
    id.[inequality_columns] AS [InEqualityColumns],
    id.[included_columns] AS [IncludedColumns],
    gs.[unique_compiles] AS [UniqueCompiles],
    gs.[user_seeks] AS [UserSeeks],
    gs.[user_scans] AS [UserScans],
    gs.[last_user_seek] AS [LastUserSeekTime],
    gs.[last_user_scan] AS [LastUserScanTime],
    gs.[avg_total_user_cost] AS [AvgTotalUserCost],
    gs.[avg_user_impact] AS [AvgUserImpact],
    gs.[system_seeks] AS [SystemSeeks],
    gs.[system_scans] AS [SystemScans],
    gs.[last_system_seek] AS [LastSystemSeekTime],
    gs.[last_system_scan] AS [LastSystemScanTime],
    gs.[avg_total_system_cost] AS [AvgTotalSystemCost],
    gs.[avg_system_impact] AS [AvgSystemImpact],
    CAST(CURRENT_TIMESTAMP AS [SMALLDATETIME]) AS [CollectionDate]
FROM
    [sys].[dm_db_missing_index_group_stats] gs WITH ( NOLOCK )
    JOIN [sys].[dm_db_missing_index_groups] ig WITH ( NOLOCK ) ON gs.[group_handle] = ig.[index_group_handle]
    JOIN [sys].[dm_db_missing_index_details] id WITH ( NOLOCK ) ON ig.[index_handle] = id.[index_handle]
    JOIN [sys].[databases] db WITH ( NOLOCK ) ON db.[database_id] = id.[database_id]
WHERE
    db.[database_id] = DB_ID()
    --AND gs.avg_total_user_cost * ( gs.avg_user_impact / 100.0 ) * ( gs.user_seeks + gs.user_scans ) > 10
ORDER BY
    [IndexAdvantage] DESC
OPTION ( RECOMPILE );

    -- Select Query
	SELECT
    'CREATE INDEX [IX_' + OBJECT_NAME(id.[object_id], db.[database_id]) + '_' + REPLACE(REPLACE(REPLACE(ISNULL(id.[equality_columns], ''), ', ', '_'), '[', ''), ']', '') + CASE WHEN id.[equality_columns] IS NOT NULL AND id.[inequality_columns] IS NOT NULL THEN '_' ELSE '' END + REPLACE(REPLACE(REPLACE(ISNULL(id.[inequality_columns], ''), ', ', '_'), '[', ''), ']', '') + '_' + LEFT(CAST(NEWID() AS [NVARCHAR](64)), 5) + ']' + ' ON ' + id.[statement] + ' (' + ISNULL(id.[equality_columns], '') + CASE WHEN id.[equality_columns] IS NOT NULL AND id.[inequality_columns] IS NOT NULL THEN ',' ELSE '' END + ISNULL(id.[inequality_columns], '') + ')' + ISNULL(' INCLUDE (' + id.[included_columns] + ')', '') AS [ProposedIndex]
FROM
    [sys].[dm_db_missing_index_group_stats] gs WITH ( NOLOCK )
    JOIN [sys].[dm_db_missing_index_groups] ig WITH ( NOLOCK ) ON gs.[group_handle] = ig.[index_group_handle]
    JOIN [sys].[dm_db_missing_index_details] id WITH ( NOLOCK ) ON ig.[index_handle] = id.[index_handle]
    JOIN [sys].[databases] db WITH ( NOLOCK ) ON db.[database_id] = id.[database_id]
WHERE
    db.[database_id] = DB_ID()
OPTION ( RECOMPILE );
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "InvolvedMembers (cedo)"
            Begin Extent = 
               Top = 356
               Left = 1963
               Bottom = 665
               Right = 2387
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 15
               Left = 616
               Bottom = 324
               Right = 966
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1062
               Bottom = 324
               Right = 1390
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 13
               Left = 1463
               Bottom = 415
               Right = 1891
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 15
               Left = 1952
               Bottom = 324
               Right = 2417
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 15
               Left = 2513
               Bottom = 324
               Right = 2841
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 2937
             ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AcceptedPlanControls'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'  Bottom = 324
               Right = 3426
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PlanControls (cedo)"
            Begin Extent = 
               Top = 330
               Left = 96
               Bottom = 639
               Right = 659
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 600
         Width = 948
         Width = 1470
         Width = 1386
         Width = 2448
         Width = 600
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AcceptedPlanControls'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AcceptedPlanControls'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[33] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[47] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 1
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 280
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 15
               Left = 412
               Bottom = 311
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 4
               Left = 727
               Bottom = 251
               Right = 897
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2220
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'checkUser'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'checkUser'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 281
               Right = 520
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1674
         Width = 1818
         Width = 1824
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ConstructionLicenseArea'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ConstructionLicenseArea'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[38] 4[24] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CourseHoldingMembers (cedo)"
            Begin Extent = 
               Top = 37
               Left = 606
               Bottom = 206
               Right = 866
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Attendees (cedo)"
            Begin Extent = 
               Top = 5
               Left = 1147
               Bottom = 209
               Right = 1371
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Bills (cedo)"
            Begin Extent = 
               Top = 37
               Left = 306
               Bottom = 297
               Right = 530
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PaymentReceipts (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 198
               Left = 921
               Bottom = 360
               Right = 1105
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 215
               Left = 1155
               Bottom = 345
               Right = 1379
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 214
               Left = 1497
               Bottom = 344
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'deleted_attendees'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Right = 1667
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2850
         Width = 1500
         Width = 3690
         Width = 3315
         Width = 1530
         Width = 1500
         Width = 1500
         Width = 3270
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'deleted_attendees'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'deleted_attendees'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[16] 4[26] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ConstructionLicenseDocuments (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 563
               Right = 589
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 616
               Bottom = 579
               Right = 1105
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "DocumentTypes (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1201
               Bottom = 418
               Right = 1668
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 600
         Width = 498
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 2232
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DocumentFinder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DocumentFinder'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 3480
         Width = 660
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Duplicated-Members'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Duplicated-Members'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 397
               Right = 445
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "Floors_1"
            Begin Extent = 
               Top = 30
               Left = 651
               Bottom = 368
               Right = 1041
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FloorTypes (cedo)"
            Begin Extent = 
               Top = 453
               Left = 295
               Bottom = 720
               Right = 685
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BuildingUnits (cedo)"
            Begin Extent = 
               Top = 95
               Left = 1419
               Bottom = 584
               Right = 2044
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2388
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1026
         Or = 1350
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Floors'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Floors'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Floors'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Operators_1"
            Begin Extent = 
               Top = 58
               Left = 957
               Bottom = 436
               Right = 1299
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OperatorTypes (cedo)"
            Begin Extent = 
               Top = 7
               Left = 296
               Bottom = 292
               Right = 519
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 300
               Left = 96
               Bottom = 609
               Right = 561
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 51
               Left = 1571
               Bottom = 360
               Right = 1899
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 3636
         Width = 1200
         Width = 3156
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
         Width = 1200
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Operators'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Operators'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Operators'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[18] 2[27] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PaymentReceipts (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 212
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Bills (cedo)"
            Begin Extent = 
               Top = 6
               Left = 261
               Bottom = 157
               Right = 468
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 506
               Bottom = 228
               Right = 738
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Payment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Payment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[22] 4[19] 2[32] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -240
         Left = 0
      End
      Begin Tables = 
         Begin Table = "InvolvedMembers (cedo)"
            Begin Extent = 
               Top = 4
               Left = 667
               Bottom = 495
               Right = 1091
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 30
               Left = 1279
               Bottom = 522
               Right = 1629
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 54
               Left = 1736
               Bottom = 363
               Right = 2064
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 55
               Left = 2248
               Bottom = 364
               Right = 2618
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 287
               Left = 2764
               Bottom = 596
               Right = 3229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 18
               Left = 3460
               Bottom = 327
               Right = 3788
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 13
               Left = 0
             ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RejectedPlanControls'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'  Bottom = 550
               Right = 489
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PlanControls (cedo)"
            Begin Extent = 
               Top = 373
               Left = 1740
               Bottom = 721
               Right = 2303
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1062
         Width = 972
         Width = 1776
         Width = 1578
         Width = 2940
         Width = 966
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2022
         Alias = 900
         Table = 2388
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 4584
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RejectedPlanControls'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RejectedPlanControls'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[11] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ConstructionLicenseArea"
            Begin Extent = 
               Top = 15
               Left = 530
               Bottom = 238
               Right = 954
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RejectedPlanControls"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 359
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1422
         Width = 2232
         Width = 1836
         Width = 2298
         Width = 2100
         Width = 1788
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RejectedPlanControlsWithArea'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RejectedPlanControlsWithArea'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[19] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FlowSteps"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 277
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 256
               Right = 470
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 6
               Left = 508
               Bottom = 136
               Right = 678
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StepPendings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'StepPendings'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Flows"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 215
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FlowVersions"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 119
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FlowInstances"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 198
               Right = 631
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FlowSteps"
            Begin Extent = 
               Top = 6
               Left = 669
               Bottom = 241
               Right = 839
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "StepRecordLogs"
            Begin Extent = 
               Top = 6
               Left = 877
               Bottom = 219
               Right = 1047
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 6
               Left = 1085
               Bottom = 208
               Right = 1309
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 73
               Left = 1330
               Bottom = 203
               Right = 1500
            End
       ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'TrackCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2235
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'TrackCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'TrackCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[51] 4[19] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 172
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 254
               Bottom = 188
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 6
               Left = 462
               Bottom = 136
               Right = 646
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 6
               Left = 684
               Bottom = 306
               Right = 908
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 193
               Left = 43
               Bottom = 323
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceFields (cedo)"
            Begin Extent = 
               Top = 190
               Left = 248
               Bottom = 344
               Right = 418
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 148
               Left = 474
               Bottom = 261
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'UserTypePhoneNumbers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1695
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'UserTypePhoneNumbers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'UserTypePhoneNumbers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Bills (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 464
               Right = 520
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BillTypes (cedo)"
            Begin Extent = 
               Top = 491
               Left = 162
               Bottom = 757
               Right = 490
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BillDetails (cedo)"
            Begin Extent = 
               Top = 0
               Left = 622
               Bottom = 418
               Right = 950
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 341
               Left = 997
               Bottom = 851
               Right = 1486
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "CostTypes (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1046
               Bottom = 281
               Right = 1390
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 600
         Width = 600
         Width = 2784
         Width = 978
         Width = 600
         Width = 1038
         Width = 978
         Width = 786
         Width = 2148
      End
   End
   Begin CriteriaPane = 
      Beg' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBillDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'in ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBillDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBillDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[26] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 138
               Left = 252
               Bottom = 268
               Right = 422
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "BuildingGroupSettings (cedo)"
            Begin Extent = 
               Top = 6
               Left = 252
               Bottom = 136
               Right = 505
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 149
               Left = 501
               Bottom = 279
               Right = 671
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BuildingSubGroups (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 155
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1800
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 660
         Width = 1650
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBuildingGroupSetting'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 4215
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBuildingGroupSetting'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwBuildingGroupSetting'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[34] 4[19] 2[6] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "InvolvedMembers (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 305
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 6
               Left = 290
               Bottom = 136
               Right = 468
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 506
               Bottom = 136
               Right = 676
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 165
               Left = 507
               Bottom = 278
               Right = 677
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvolvedMemberStatuses (cedo)"
            Begin Extent = 
               Top = 155
               Left = 299
               Bottom = 268
               Right = 469
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[34] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CapacityCalculations (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 517
               Right = 539
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 15
               Left = 635
               Bottom = 281
               Right = 963
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceFields (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1059
               Bottom = 281
               Right = 1387
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BuildingGroupSettings (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1483
               Bottom = 485
               Right = 2019
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 684
         Width = 1476
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacityCalculationsB200'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'= 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacityCalculationsB200'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacityCalculationsB200'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1462
               Bottom = 590
               Right = 1832
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberCapacities (cedo)"
            Begin Extent = 
               Top = 69
               Left = 2058
               Bottom = 634
               Right = 2461
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 324
               Right = 561
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 15
               Left = 657
               Bottom = 324
               Right = 985
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 600
         Width = 1536
         Width = 2082
         Width = 654
         Width = 4002
         Width = 852
         Width = 2448
         Width = 1758
         Width = 978
         Width = 1032
         Width = 1494
         Width = 1764
         Width = 1368
         Width = 3438
         Width = 1074
         Width = 948
         Width = 930
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Tab' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacityDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'le = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 3252
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacityDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwCapacityDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[10] 2[27] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 324
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LegalMembers (cedo)"
            Begin Extent = 
               Top = 15
               Left = 562
               Bottom = 635
               Right = 967
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1063
               Bottom = 324
               Right = 1391
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1487
               Bottom = 324
               Right = 1837
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvolvedMembers (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1933
               Bottom = 437
               Right = 2357
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 330
               Left = 1063
               Bottom = 639
               Right = 1552
            End
            DisplayFlags = 280
            TopColumn = 17
         End
         Begin Table = "ServiceFields (cedo)"
            Begin Extent = 
               Top = 330
               Left = 96' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwConstructionLisenceLab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
               Bottom = 596
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 450
               Left = 1648
               Bottom = 716
               Right = 1976
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Estates (cedo)"
            Begin Extent = 
               Top = 450
               Left = 2072
               Bottom = 759
               Right = 2576
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 560
               Left = 753
               Bottom = 869
               Right = 1081
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 600
         Width = 2718
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 936
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwConstructionLisenceLab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwConstructionLisenceLab'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 324
               Right = 585
            End
            DisplayFlags = 280
            TopColumn = 30
         End
         Begin Table = "ConstructionLicenseSteps (cedo)"
            Begin Extent = 
               Top = 14
               Left = 687
               Bottom = 280
               Right = 1015
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenseStatuses (cedo)"
            Begin Extent = 
               Top = 330
               Left = 96
               Bottom = 596
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Estates (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1111
               Bottom = 566
               Right = 1615
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1711
               Bottom = 500
               Right = 2039
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 15
               Left = 2135
               Bottom = 324
               Right = 2463
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OwnershipDocumentTypes (cedo)"
            Begin Extent = 
               Top = 285
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwContractDossiers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'           Left = 681
               Bottom = 551
               Right = 1009
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 780
         Width = 600
         Width = 600
         Width = 2574
         Width = 1974
         Width = 600
         Width = 600
         Width = 600
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwContractDossiers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwContractDossiers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[35] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MemberCapacityDetails (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 261
               Right = 234
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 6
               Left = 272
               Bottom = 136
               Right = 450
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 488
               Bottom = 136
               Right = 658
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 159
               Left = 492
               Bottom = 272
               Right = 662
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 4530
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrde' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHistoryCapacity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'r = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHistoryCapacity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwHistoryCapacity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[29] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Bills (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BillDetails (cedo)"
            Begin Extent = 
               Top = 6
               Left = 300
               Bottom = 136
               Right = 470
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 508
               Bottom = 221
               Right = 793
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "Estates (cedo)"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 6
               Left = 831
               Bottom = 136
               Right = 1001
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 138
               Left = 313
               Bottom = 268
               Right = 483
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Wid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwIncompleteBills'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'th = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwIncompleteBills'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwIncompleteBills'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[14] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[30] 4[27] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 2
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 28
               Left = 187
               Bottom = 250
               Right = 374
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvolvedMembers (cedo)"
            Begin Extent = 
               Top = 6
               Left = 476
               Bottom = 193
               Right = 683
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 102
               Left = 721
               Bottom = 458
               Right = 1101
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 312
               Left = 194
               Bottom = 531
               Right = 527
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 664
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 294
               Left = 640
               Bottom = 424
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 198
               Left = 929
               Bottom =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwInvolvedMembers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 370
               Right = 1161
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 6
               Left = 929
               Bottom = 119
               Right = 1116
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceFields (cedo)"
            Begin Extent = 
               Top = 6
               Left = 1137
               Bottom = 119
               Right = 1324
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvolvedMemberStatuses (cedo)"
            Begin Extent = 
               Top = 120
               Left = 1199
               Bottom = 233
               Right = 1386
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvolvedMemberType (cedo)"
            Begin Extent = 
               Top = 198
               Left = 412
               Bottom = 311
               Right = 582
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 18
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1965
         Width = 1500
         Width = 1500
         Width = 3060
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 600
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      PaneHidden = 
      Begin ColumnWidths = 11
         Column = 1965
         Alias = 1305
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwInvolvedMembers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwInvolvedMembers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "LicenseInqueries (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 231
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 6
               Left = 286
               Bottom = 166
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 6
               Left = 494
               Bottom = 136
               Right = 664
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1575
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwLicenseInqueries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwLicenseInqueries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[19] 4[22] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MemberCapacityDetails (cedo)"
            Begin Extent = 
               Top = 3
               Left = 622
               Bottom = 166
               Right = 818
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 39
               Left = 321
               Bottom = 243
               Right = 499
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 20
               Left = 67
               Bottom = 133
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceFields (cedo)"
            Begin Extent = 
               Top = 163
               Left = 63
               Bottom = 276
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 174
               Left = 620
               Bottom = 304
               Right = 790
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 184
               Left = 930
               Bottom = 314
               Right = 1122
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnW' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwMemberCapacityDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'idths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 7155
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwMemberCapacityDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwMemberCapacityDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[7] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 323
            End
            DisplayFlags = 280
            TopColumn = 28
         End
         Begin Table = "Estates (cedo)"
            Begin Extent = 
               Top = 140
               Left = 263
               Bottom = 270
               Right = 500
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 131
               Left = 56
               Bottom = 261
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 280
               Left = 218
               Bottom = 410
               Right = 388
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "BuildingGroupSettings (cedo)"
            Begin Extent = 
               Top = 60
               Left = 477
               Bottom = 190
               Right = 730
            End
            DisplayFlags = 280
            TopColumn = 14
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin C' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwNeedExecuterDossiers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'olumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwNeedExecuterDossiers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwNeedExecuterDossiers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[18] 4[34] 2[24] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 578
               Right = 712
            End
            DisplayFlags = 280
            TopColumn = 28
         End
         Begin Table = "ConstructionLicenseStatuses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 808
               Bottom = 281
               Right = 1136
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenseSteps (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1232
               Bottom = 281
               Right = 1560
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Estates (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1656
               Bottom = 324
               Right = 2160
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 15
               Left = 2256
               Bottom = 324
               Right = 2584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 15
               Left = 2680
               Bottom = 324
               Right = 3024
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      E' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwNotReleased'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'nd
      Begin ColumnWidths = 11
         Width = 284
         Width = 600
         Width = 600
         Width = 1386
         Width = 600
         Width = 600
         Width = 600
         Width = 1938
         Width = 600
         Width = 2574
         Width = 1026
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwNotReleased'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwNotReleased'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[25] 3[25] 2) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "UserDelegations (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 324
               Right = 483
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Operators (cedo)"
            Begin Extent = 
               Top = 15
               Left = 579
               Bottom = 422
               Right = 921
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1017
               Bottom = 324
               Right = 1345
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OperatorTypes (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1441
               Bottom = 281
               Right = 1769
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Operators_1"
            Begin Extent = 
               Top = 464
               Left = 271
               Bottom = 773
               Right = 613
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OperatorTypes_1"
            Begin Extent = 
               Top = 704
               Left = 998
               Bottom = 970
               Right = 1326
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Wid' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwOperator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'th = 284
         Width = 3600
         Width = 618
         Width = 3480
         Width = 3450
         Width = 2508
         Width = 3156
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwOperator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwOperator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[21] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PaymentComeBackRequests (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 259
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ChangeDesignerRequestStatuses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 254
               Bottom = 119
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Bills (cedo)"
            Begin Extent = 
               Top = 6
               Left = 462
               Bottom = 136
               Right = 686
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 138
               Left = 254
               Bottom = 268
               Right = 539
            End
            DisplayFlags = 280
            TopColumn = 30
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 15585
         Width = 1500
         Width = 1500
         Width = 7890
         Width = 1770
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPaymentCallBackReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPaymentCallBackReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPaymentCallBackReport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FlowNodes"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "FlowSteps"
            Begin Extent = 
               Top = 6
               Left = 282
               Bottom = 216
               Right = 452
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "FlowStepStatuses"
            Begin Extent = 
               Top = 6
               Left = 490
               Bottom = 102
               Right = 660
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 6
               Left = 698
               Bottom = 136
               Right = 922
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 102
               Left = 490
               Bottom = 232
               Right = 660
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnW' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPendingSteps'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'idths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPendingSteps'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPendingSteps'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[23] 4[14] 2[30] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "TimerTicks"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 102
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FlowSteps"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 207
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FlowInstances"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 136
               Right = 631
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FlowVersions"
            Begin Extent = 
               Top = 6
               Left = 669
               Bottom = 119
               Right = 839
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Flows"
            Begin Extent = 
               Top = 6
               Left = 877
               Bottom = 136
               Right = 1047
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InstanceUserGroups"
            Begin Extent = 
               Top = 151
               Left = 683
               Bottom = 230
               Right = 853
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FlowInstances_1"
            Begin Extent = 
               Top = 23
               Left = 1091
               Bottom = 236
               Right = 1268
            End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPendingTimers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2340
         Width = 1500
         Width = 1500
         Width = 1740
         Width = 3315
         Width = 2010
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPendingTimers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPendingTimers'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PlanControls (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 324
               Right = 659
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenseDocuments (cedo)"
            Begin Extent = 
               Top = 15
               Left = 755
               Bottom = 480
               Right = 1179
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DocumentTypes (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1275
               Bottom = 281
               Right = 1859
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PlanControlStatuses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1955
               Bottom = 281
               Right = 2283
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 600
         Width = 600
         Width = 600
         Width = 3432
         Width = 1638
         Width = 1650
         Width = 1620
         Width = 3216
         Width = 942
         Width = 786
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPlanControl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'       GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPlanControl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwPlanControl'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[50] 4[17] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 614
               Left = 261
               Bottom = 744
               Right = 439
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SeparationInvolvedMembers (cedo)"
            Begin Extent = 
               Top = 398
               Left = 25
               Bottom = 592
               Right = 222
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 618
               Left = 480
               Bottom = 748
               Right = 650
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 642
               Left = 741
               Bottom = 772
               Right = 934
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users_1"
            Begin Extent = 
               Top = 609
               Left = 1065
               Bottom = 739
               Right = 1289
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "UserProfiles_1"
            Begin Extent = 
               Top = 655
               Left = 1359
               Bottom = 785
               Right = 1529
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvolvedMemberStatuses (cedo)"
            Begin Extent = 
               Top = 470
               Left = 471' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSeperationPlans'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
               Bottom = 583
               Right = 641
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SeparationPlanRequests (cedo)"
            Begin Extent = 
               Top = 141
               Left = 471
               Bottom = 441
               Right = 670
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 482
               Left = 785
               Bottom = 612
               Right = 959
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceRequests (cedo)"
            Begin Extent = 
               Top = 43
               Left = 695
               Bottom = 239
               Right = 868
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 744
               Left = 38
               Bottom = 874
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 21
               Left = 1295
               Bottom = 283
               Right = 1465
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SeparationPlanRequestStatuses (cedo)"
            Begin Extent = 
               Top = 329
               Left = 779
               Bottom = 442
               Right = 949
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SeparationRequestSurveies (cedo)"
            Begin Extent = 
               Top = 149
               Left = 0
               Bottom = 384
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 25
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSeperationPlans'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSeperationPlans'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[19] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -240
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SupervisionStepForms (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 395
               Right = 558
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "InvolvedMembers (cedo)"
            Begin Extent = 
               Top = 15
               Left = 654
               Bottom = 387
               Right = 1078
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1174
               Bottom = 324
               Right = 1524
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceFields (cedo)"
            Begin Extent = 
               Top = 4
               Left = 1570
               Bottom = 270
               Right = 1898
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ServiceTypes (cedo)"
            Begin Extent = 
               Top = 54
               Left = 1993
               Bottom = 320
               Right = 2321
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SupervisionStepItemGroups (cedo)"
            Begin Extent = 
               Top = 723
               Left = 1932
               Bottom = 1032
               Right = 2550
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "SupervisionSteps (cedo)"
            Begin Extent = 
               Top = 531
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwStepFoms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'           Left = 1078
               Bottom = 840
               Right = 1562
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SupervisionStepItems (cedo)"
            Begin Extent = 
               Top = 330
               Left = 1865
               Bottom = 639
               Right = 2644
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 720
               Left = 96
               Bottom = 1029
               Right = 585
            End
            DisplayFlags = 280
            TopColumn = 17
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 600
         Width = 1650
         Width = 1290
         Width = 2130
         Width = 2448
         Width = 1206
         Width = 1884
         Width = 1884
         Width = 4986
         Width = 6120
         Width = 1482
         Width = 600
         Width = 1122
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1662
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwStepFoms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwStepFoms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 323
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "Estates (cedo)"
            Begin Extent = 
               Top = 6
               Left = 361
               Bottom = 208
               Right = 598
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 6
               Left = 636
               Bottom = 189
               Right = 806
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 6
               Left = 844
               Bottom = 182
               Right = 1014
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DossierType (cedo)"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 251
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OwnershipDocumentTypes (cedo)"
            Begin Extent = 
               Top = 186
               Left = 844
               Bottom = 299
               Right = 1014
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Owners (cedo)"
            Begin Extent = 
               Top = 286
               Left = 300
               B' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSupervisorContractTempDossier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'ottom = 416
               Right = 507
            End
            DisplayFlags = 280
            TopColumn = 21
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSupervisorContractTempDossier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwSupervisorContractTempDossier'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[7] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Operators (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 324
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OperatorTypes (cedo)"
            Begin Extent = 
               Top = 15
               Left = 534
               Bottom = 281
               Right = 862
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1478
               Bottom = 324
               Right = 1806
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PARA-Users"
            Begin Extent = 
               Top = 438
               Left = 831
               Bottom = 747
               Right = 1296
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "UserProfiles"
            Begin Extent = 
               Top = 335
               Left = 182
               Bottom = 644
               Right = 510
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 3516
         Width = 3600
         Width = 3156
         Width = 600
         Width = 948
         Width = 2046
         Width = 600
         Width = 600
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwUserDeligation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwUserDeligation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwUserDeligation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[17] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "InvolvedMembers (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1050
               Bottom = 552
               Right = 1474
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenses (cedo)"
            Begin Extent = 
               Top = 15
               Left = 1678
               Bottom = 628
               Right = 2167
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MemberServices (cedo)"
            Begin Extent = 
               Top = 15
               Left = 96
               Bottom = 536
               Right = 596
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ActivityLicenses (cedo)"
            Begin Extent = 
               Top = 455
               Left = 644
               Bottom = 764
               Right = 972
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Members (cedo)"
            Begin Extent = 
               Top = 500
               Left = 1478
               Bottom = 1045
               Right = 1848
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Estates (cedo)"
            Begin Extent = 
               Top = 291
               Left = 2491
               Bottom = 600
               Right = 2995
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Municipalities (cedo)"
            Begin Extent = 
               Top = 324
               Left = 3019' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWorkItemsSync'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
               Bottom = 633
               Right = 3347
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Cities (cedo)"
            Begin Extent = 
               Top = 62
               Left = 3322
               Bottom = 526
               Right = 3650
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ConstructionLicenseArea"
            Begin Extent = 
               Top = 13
               Left = 2646
               Bottom = 236
               Right = 3070
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "LegalMembers (cedo)"
            Begin Extent = 
               Top = 582
               Left = 2050
               Bottom = 1014
               Right = 2455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1884
         Width = 1464
         Width = 1122
         Width = 1602
         Width = 1764
         Width = 1950
         Width = 1350
         Width = 2112
         Width = 2142
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWorkItemsSync'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWorkItemsSync'
GO
