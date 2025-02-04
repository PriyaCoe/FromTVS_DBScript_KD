USE [master]
GO
/****** Object:  Database [iotkpimaster]    Script Date: 7/3/2024 12:01:22 PM ******/
CREATE DATABASE [iotkpimaster]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'iotkpimaster', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\iotkpimaster.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'iotkpimaster_log', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Data\iotkpimaster_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [iotkpimaster] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [iotkpimaster].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [iotkpimaster] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [iotkpimaster] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [iotkpimaster] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [iotkpimaster] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [iotkpimaster] SET ARITHABORT OFF 
GO
ALTER DATABASE [iotkpimaster] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [iotkpimaster] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [iotkpimaster] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [iotkpimaster] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [iotkpimaster] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [iotkpimaster] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [iotkpimaster] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [iotkpimaster] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [iotkpimaster] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [iotkpimaster] SET  DISABLE_BROKER 
GO
ALTER DATABASE [iotkpimaster] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [iotkpimaster] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [iotkpimaster] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [iotkpimaster] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [iotkpimaster] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [iotkpimaster] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [iotkpimaster] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [iotkpimaster] SET RECOVERY FULL 
GO
ALTER DATABASE [iotkpimaster] SET  MULTI_USER 
GO
ALTER DATABASE [iotkpimaster] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [iotkpimaster] SET DB_CHAINING OFF 
GO
ALTER DATABASE [iotkpimaster] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [iotkpimaster] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [iotkpimaster] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [iotkpimaster] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [iotkpimaster] SET QUERY_STORE = OFF
GO
USE [iotkpimaster]
GO
/****** Object:  Synonym [dbo].[SYNONYM_Rawtable]    Script Date: 7/3/2024 12:01:23 PM ******/
CREATE SYNONYM [dbo].[SYNONYM_Rawtable] FOR [Rawtable]
GO
/****** Object:  Synonym [dbo].[SYNONYM_rawtable_archive]    Script Date: 7/3/2024 12:01:23 PM ******/
CREATE SYNONYM [dbo].[SYNONYM_rawtable_archive] FOR [rawtable_archive]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_weeks_of_month]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[udf_weeks_of_month] (@fromdate date) 
returns table as return (
with n as (select n from (values(0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) t(n))
, dates as (
  select top (datediff(day, @fromdate, dateadd(month, datediff(month, 0, @fromdate )+1, 0))) 
    [DateValue]=convert(date,dateadd(day,row_number() over(order by (select 1))-1,@fromdate))
  from n as deka cross join n as hecto
)
select 
    WeekOfMonth = row_number() over (order by datepart(week,DateValue))
  , Week        = datepart(week,DateValue)
  , WeekStart   = min(DateValue)
  , WeekEnd     = max(DateValue)
from dates
group by datepart(week,DateValue)
);
GO
/****** Object:  Table [dbo].[database_connection]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[database_connection](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Plantcode] [nvarchar](50) NULL,
	[Linecode] [nvarchar](50) NULL,
	[Companycode] [nvarchar](50) NULL,
	[connection] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LNK_ROLE_PERMISSION]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LNK_ROLE_PERMISSION](
	[RoleID] [int] NOT NULL,
	[Permission_id] [int] NOT NULL,
	[CompanyCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_UserGroup] PRIMARY KEY NONCLUSTERED 
(
	[RoleID] ASC,
	[Permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LNK_USER_Line]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LNK_USER_Line](
	[Unique_ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[CompanyCode] [nvarchar](50) NOT NULL,
	[PlantCode] [nvarchar](50) NOT NULL,
	[Line_Code] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LNK_USER_ROLE]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LNK_USER_ROLE](
	[UserID] [nvarchar](50) NOT NULL,
	[RoleID] [int] NOT NULL,
	[CompanyCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY NONCLUSTERED 
(
	[UserID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Portal_URL]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Portal_URL](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[URL] [nvarchar](max) NULL,
	[CompanyCode] [nvarchar](max) NULL,
	[PlantCode] [nvarchar](max) NULL,
	[LineCode] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Table_1]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_1](
	[Unique_id] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_area]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_area](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[Area_id] [nvarchar](50) NOT NULL,
	[Area_name] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[CompanyCode] [nvarchar](50) NOT NULL,
	[PlantCode] [varchar](100) NULL,
	[LineCode] [varchar](max) NULL,
 CONSTRAINT [PK_tbl_area] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Cities]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Cities](
	[Unique_id] [int] NOT NULL,
	[City_Name] [nvarchar](50) NULL,
	[State_id] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Cities] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Countries]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Countries](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[SortName] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[PhoneCode] [decimal](18, 0) NULL,
 CONSTRAINT [PK_tbl_Countries] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Customer]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Customer](
	[CompanyCode] [nvarchar](50) NOT NULL,
	[CompanyName] [nvarchar](200) NOT NULL,
	[DomainName] [nvarchar](50) NULL,
	[ContactPerson_FirstName] [nvarchar](50) NULL,
	[ContactPerson_LastName] [nvarchar](50) NULL,
	[ContactPerson_Mobile_NO] [numeric](18, 0) NULL,
	[ContactPerson_Email] [nvarchar](150) NULL,
	[LocationName] [nvarchar](150) NULL,
	[Address] [nvarchar](150) NULL,
	[City] [nvarchar](150) NULL,
	[state] [nvarchar](150) NULL,
	[Country] [nvarchar](150) NULL,
	[PostalCode] [nvarchar](150) NULL,
	[Logo] [nvarchar](150) NULL,
	[Manager] [nvarchar](150) NULL,
 CONSTRAINT [PK_tbl_Customer] PRIMARY KEY CLUSTERED 
(
	[CompanyCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_department]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_department](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[Dept_id] [nvarchar](50) NOT NULL,
	[Dept_name] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[CompanyCode] [nvarchar](50) NOT NULL,
	[PlantCode] [varchar](100) NULL,
	[LineCode] [varchar](max) NULL,
	[areacode] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_department] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Ewon_Details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Ewon_Details](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[device_id] [nvarchar](max) NULL,
	[devicename] [nvarchar](max) NULL,
	[t2maccount] [nvarchar](max) NULL,
	[t2musername] [nvarchar](max) NULL,
	[t2mpassword] [nvarchar](max) NULL,
	[t2mdeveloperid] [nvarchar](max) NULL,
	[t2mdeviceusername] [nvarchar](max) NULL,
	[t2mdevicepassword] [nvarchar](max) NULL,
	[companycode] [nvarchar](max) NULL,
	[plantcode] [nvarchar](max) NULL,
	[linecode] [nvarchar](max) NULL,
	[status] [varchar](max) NULL,
	[deviceip] [varchar](50) NULL,
	[ewonurl] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Function]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Function](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[FunctionID] [nvarchar](50) NOT NULL,
	[FunctionName] [nvarchar](50) NULL,
	[FunctionDescription] [nvarchar](150) NULL,
	[ParentPlant] [nvarchar](150) NULL,
	[IsActive] [nvarchar](50) NULL,
	[CompanyCode] [nvarchar](50) NOT NULL,
	[Dept_id] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Function] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_gmail_settings]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_gmail_settings](
	[UniqueId] [int] IDENTITY(1,1) NOT NULL,
	[Smtp_host] [nvarchar](150) NULL,
	[Smtp_port] [int] NULL,
	[Smtp_user] [nvarchar](150) NULL,
	[Smtp_pass] [nvarchar](150) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Created_by] [nvarchar](50) NOT NULL,
	[Create_date] [datetime] NOT NULL,
	[Updated_by] [nvarchar](50) NULL,
	[Update_date] [datetime] NULL,
 CONSTRAINT [PK_tbl_gmail_settings] PRIMARY KEY CLUSTERED 
(
	[UniqueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Holiday]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Holiday](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[HolidayID] [nvarchar](50) NOT NULL,
	[HolidayReason] [nvarchar](50) NOT NULL,
	[PlantID] [nvarchar](30) NOT NULL,
	[Date] [date] NOT NULL,
	[CompanyCode] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tbl_Holiday] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Line_Permission]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Line_Permission](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[Line_Code] [nvarchar](100) NULL,
	[Plant_Code] [nvarchar](100) NULL,
	[Area_Code] [nvarchar](100) NULL,
	[Dept_Code] [nvarchar](100) NULL,
	[CompanyCode] [nvarchar](50) NOT NULL,
	[Plantcode] [varchar](100) NULL,
	[roleid] [int] NULL,
 CONSTRAINT [PK_tbl_Line_Permission] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Line_Role]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Line_Role](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[RoleDescription] [nvarchar](150) NULL,
	[CompanyCode] [nvarchar](50) NULL,
	[PlantCode] [varchar](100) NULL,
	[roleid] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_MasterProduct]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_MasterProduct](
	[M_ID] [int] NULL,
	[Variant_Code] [varchar](20) NULL,
	[VariantName] [varchar](100) NULL,
	[VariantDescription] [varchar](100) NULL,
	[OperationName] [varchar](30) NULL,
	[Machine_Code] [varchar](30) NULL,
	[RecipeName] [varchar](30) NULL,
	[CycleTime] [decimal](18, 2) NULL,
	[CompanyCode] [nvarchar](100) NULL,
	[PlantCode] [nvarchar](100) NULL,
	[Cost] [nvarchar](100) NULL,
	[Line_Code] [varchar](100) NULL,
	[Auto_CycleTime] [decimal](10, 2) NULL,
	[Manual_CycleTime] [decimal](10, 2) NULL,
	[Ideal_cycletime] [decimal](10, 2) NULL,
	[No_of_fixtures] [decimal](10, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Permission]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Permission](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [nvarchar](50) NULL,
	[Module_name] [nvarchar](50) NULL,
	[View_form] [nvarchar](50) NULL,
	[Add_form] [nvarchar](50) NULL,
	[Edit_form] [nvarchar](50) NULL,
	[Delete_form] [nvarchar](50) NULL,
	[Permission_id] [int] NOT NULL,
	[CompanyCode] [nvarchar](50) NOT NULL,
	[Line_code] [varchar](100) NULL,
	[Plantcode] [varchar](100) NULL,
 CONSTRAINT [PK_tbl_Permission_1] PRIMARY KEY CLUSTERED 
(
	[Permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Plant]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Plant](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[PlantID] [nvarchar](50) NOT NULL,
	[PlantName] [nvarchar](50) NULL,
	[PlantDescription] [nvarchar](150) NULL,
	[PlantLocation] [nvarchar](150) NULL,
	[TimeZone] [nvarchar](50) NULL,
	[ParentOrganization] [nvarchar](150) NULL,
	[IsActive] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Plant] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_reports_list]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_reports_list](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[Report_name] [nvarchar](max) NULL,
	[Category] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[CompanyCode] [nvarchar](50) NULL,
	[PlantCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_reports_list] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Role]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Role](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[RoleDescription] [nvarchar](150) NULL,
	[CompanyCode] [nvarchar](50) NULL,
	[PlantCode] [varchar](100) NULL,
	[Line_code] [varchar](100) NULL,
 CONSTRAINT [PK_tbl_Role] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Skill]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Skill](
	[Unique_id] [int] NULL,
	[Skill_ID] [nvarchar](50) NULL,
	[SkillName] [nvarchar](500) NULL,
	[CompanyCode] [nvarchar](50) NULL,
	[Line_Code] [varchar](100) NULL,
	[PlantCode] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_States]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_States](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[State_name] [nvarchar](50) NULL,
	[Country_id] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_States] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_ToolLife_Maintenace]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ToolLife_Maintenace](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ToolID] [varchar](10) NULL,
	[LastMaintenaceDate] [date] NULL,
	[IsReplaced] [varchar](5) NULL,
	[No_of_Replacements] [int] NULL,
	[Currentusage] [decimal](18, 0) NULL,
	[Remarks] [varchar](30) NULL,
	[CompanyCode] [nvarchar](50) NULL,
	[PlantCode] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Unique_id] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[PhoneNo] [varchar](10) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[RoleID] [varchar](20) NULL,
	[IsActive] [varchar](50) NULL,
	[SkillSet] [varchar](30) NULL,
	[CompanyCode] [nvarchar](100) NULL,
	[PlantCode] [nvarchar](100) NULL,
	[IsAdmin] [bit] NULL,
	[IsSuperAdmin] [bit] NULL,
	[LastLoginDate] [datetime] NULL,
	[otp_code] [varchar](50) NULL,
	[one_time] [datetime] NULL,
	[VCode] [nvarchar](50) NULL,
	[LineRoleID] [varchar](50) NULL,
	[CurrentLoginDate] [datetime] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Unique_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsAdmin]  DEFAULT ((0)) FOR [IsAdmin]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsSuperAdmin]  DEFAULT ((0)) FOR [IsSuperAdmin]
GO
/****** Object:  StoredProcedure [dbo].[SP_Area_details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_Area_details]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@Area_id nvarchar(150)=null,
	@Area_name nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_area where CompanyCode=@CompanyCode AND(Area_id=@Area_id OR Area_name=@Area_name) AND PlantCode=@PlantCode)
		Begin
			Insert Into tbl_Area(Area_id,Area_name,Status,CompanyCode,PlantCode)
			Values(@Area_id,@Area_name,'Active',@CompanyCode,@PlantCode)
				set @result='Inserted'	
		END
		--Else
			--BEGIN
				--set @result='Already'
			--END
		--inserted by krishna(12-03-2020)--start--
		Else If exists(Select * From tbl_Area where CompanyCode=@CompanyCode AND Area_id=@Area_id AND PlantCode=@PlantCode)
			BEGIN
				set @result='Already Area_id'
			END
			Else 
				BEGIN
					set @result='Already Area_name'
				END	
		--inserted by krishna(12-03-2020)--end--
	End			
	Else If @QueryType='Update'
	Begin
	--inserted by krishna(12-03-2020)---start---
		If not exists(Select * From tbl_Area where CompanyCode=@CompanyCode AND Area_name=@Area_name and Unique_id!=@Unique_id AND PlantCode=@PlantCode)
			Begin
				Update tbl_area set Area_name=@Area_name
				Where Unique_id=@Unique_id 
					set @result='Updated'
			end
		Else 
				BEGIN
					set @result='Already Area_name'
				END	
	--inserted by krishna(12-03-2020)---end---
		--Update tbl_department set Dept_name=@Dept_name
		--	Where Unique_id=@Unique_id 
		--		set @result='Updated'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Assets]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Assets]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@CompanyCode nvarchar(150)=null,
	@AssetID nvarchar(150)=null,
	@FunctionName nvarchar(150),
	@AssetName nvarchar(150),
	@AssetDescription nvarchar(150),
	@ShiftID nvarchar(150),
	@PlantCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Assets where  CompanyCode=@CompanyCode AND (AssetID=@AssetID OR AssetName=@AssetName))
		Begin
			Insert Into tbl_Assets(AssetID,AssetName,FunctionName,AssetDescription,EOL,CompanyCode,PlantCode)
			Values(@AssetID,@AssetName,@FunctionName,@AssetDescription,@ShiftID,@CompanyCode,@PlantCode)
				set @result='Inserted'	
		END
		--inserted by krishna(12-03-2020)--start--
		--Else
			--BEGIN
				--set @result='Already'
			--END
		Else If exists(Select * From tbl_Assets where  CompanyCode=@CompanyCode AND AssetID=@AssetID )
			BEGIN
				set @result='Already AssetID'
			END
			Else 
				BEGIN
					set @result='Already AssetName'
				END	
		--inserted by krishna(12-03-2020)--end--
	End			
	Else If @QueryType='Update'
	Begin
		--inserted by krishna(12-03-2020)--start--
		--Update tbl_Assets set AssetName=@AssetName,FunctionName=@FunctionName,AssetDescription=@AssetDescription,
		--ShiftID=@ShiftID
		--Where Unique_id=@Unique_id
		--	set @result='Updated'
		If not exists(Select * From tbl_Assets where  CompanyCode=@CompanyCode AND  AssetName=@AssetName and Unique_id!=@Unique_id)
			Begin
				Update tbl_Assets set AssetName=@AssetName,FunctionName=@FunctionName,AssetDescription=@AssetDescription,
				EOL=@ShiftID
				Where Unique_id=@Unique_id
					set @result='Updated'
			end
		Else 
				BEGIN
					set @result='Already AssetName'
				END	
		--inserted by krishna(12-03-2020)--end--
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_bulkcopy_Machine]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [dbo].[SP_bulkcopy_Machine]
	@Machine_Code1 nvarchar(max)=null,
	@Machine_Code2 nvarchar(max)=null,
	@CompanyCode1 nvarchar(max)=null,
	@PlantCode1 nvarchar(max)=null,
	@Line_Code1 nvarchar(max)=null,
	@SQLReturn nvarchar(50) output	
AS
BEGIN	

	SET NOCOUNT ON;
	Declare @rcount int

	Declare @aid nvarchar(50),@AlertID1 nvarchar(50),@Alert_Name nvarchar(max),@P1_Variable nvarchar(max),@P1_PG nvarchar(max),@P1_Param nvarchar(max),
					@P2_Variable nvarchar(max),@P2_PG nvarchar(max),@P2_Param nvarchar(max),
					@Expression nvarchar(max),@Constant int,@DurationForAlert float,@Group_id nvarchar(max),@MessageText nvarchar(max),
					@CompanyCode nvarchar(max),@PlantCode nvarchar(max),@Line_Code nvarchar(max),
					@Remarks nvarchar(max),@DurationForRepetetion nvarchar(max)
	Set @rcount=0

	if(@Machine_Code1!=@Machine_Code2)
	begin

		DECLARE cursor_product99 CURSOR
		FOR SELECT distinct Alert_Name,P1_Variable,P1_PG,P1_Param,P2_Variable,P2_PG,P2_Param,
					Expression,Constant,DurationForAlert,Group_id,MessageText,CompanyCode,PlantCode,Line_Code,
					Remarks,DurationForRepetetion
					 FROM tbl_alert_settings 
					 WHERE Machine_Code =@Machine_Code1 and CompanyCode=@CompanyCode1 and PlantCode=@PlantCode1 and Line_Code=@Line_Code1  
					 and P1_Variable!='Loss' or P1_Variable!='Alarm'
					  
		OPEN cursor_product99;
 
		FETCH NEXT FROM cursor_product99 INTO 
			@Alert_Name,
			@P1_Variable,
			@P1_PG,
			@P1_Param,
			@P2_Variable,
			@P2_PG,
			@P2_Param,
			@Expression,
			@Constant,
			@DurationForAlert,
			@Group_id,
			@MessageText,
			@CompanyCode,
			@PlantCode,
			@Line_Code,
			@Remarks,
			@DurationForRepetetion;
 
		WHILE @@FETCH_STATUS = 0
			BEGIN

				SET @aid = (SELECT ISNULL(MAX(unique_id),0)+1 FROM tbl_alert_settings)

					if not exists(select *from tbl_alert_settings where Machine_code=@Machine_Code2 and Alert_Name=@Alert_Name and P1_Variable=@P1_Variable and P1_PG=@P1_PG and 
					P1_Param=@P1_Param and P2_Variable=@P2_Variable and P2_PG=@P2_PG and P2_Param=@P2_Param and Expression=@Expression and Constant=@Constant and DurationForAlert=@DurationForAlert and 
					Group_id=@Group_id and MessageText=@MessageText and CompanyCode=@CompanyCode and PlantCode=@PlantCode and Line_Code=@Line_Code)

					begin
						Insert Into tbl_alert_settings(Machine_code,Alert_Name,P1_Variable,P1_PG,P1_Param,P2_Variable,P2_PG,P2_Param,Expression,Constant,DurationForAlert,
						Group_id,MessageText,CompanyCode,PlantCode,Line_Code,Remarks,DurationForRepetetion,AlertID,unique_id)
						values(@Machine_Code2,@Alert_Name,@P1_Variable,@P1_PG,@P1_Param,@P2_Variable,@P2_PG,@P2_Param,
						@Expression,@Constant,@DurationForAlert,@Group_id,@MessageText,@CompanyCode,@PlantCode,@Line_Code,@Remarks,
						@DurationForRepetetion,@Machine_Code2+'AG'+@Group_id+'S'+@aid,@aid)

					end

					
				
				FETCH NEXT FROM cursor_product99 INTO 
					@Alert_Name,
					@P1_Variable,
					@P1_PG,
					@P1_Param,
					@P2_Variable,
					@P2_PG,
					@P2_Param,
					@Expression,
					@Constant,
					@DurationForAlert,
					@Group_id,
					@MessageText,
					@CompanyCode,
					@PlantCode,
					@Line_Code,
					@Remarks,
					@DurationForRepetetion;
			END;
 
		CLOSE cursor_product99;
 
		DEALLOCATE cursor_product99;

		--if not exists(select *from [tbl_GroupEscalation] where [AlertID]=@AlertID1 )
					--begin
						INSERT INTO [dbo].[tbl_GroupEscalation]([AlertID],[GroupID1],[GroupID2],[GroupID3],[GroupPriority],[CompanyCode],[PlantCode],[Line_Code],[Machine_Code])
				
						SELECT @Machine_Code2+'AG'+Group_id+'S'+@aid,a.[GroupID1],a.[GroupID2],a.[GroupID3],a.[GroupPriority],a.[CompanyCode],a.[PlantCode],a.[Line_Code],@Machine_Code2
						FROM [tbl_GroupEscalation] a 
						join tbl_alert_settings b on a.AlertID=b.AlertID and a.[CompanyCode]=b.[CompanyCode] and a.[PlantCode]=b.[PlantCode] and a.[Line_Code]=b.[Line_Code]
						WHERE a.Machine_Code = @Machine_Code1 
				
					--end

				set @rcount=3


	end
	else
	begin 
		set @rcount=5
	end
	
		set @SQLReturn=@rcount

END
GO
/****** Object:  StoredProcedure [dbo].[SP_ChangePassword]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ChangePassword]
@Input1 nvarchar(50)=null,
@Input2 nvarchar(50)=null,
@Input3 nvarchar(50)=null,
@SQLReturn nvarchar(50) Output
AS
BEGIN
SET NOCOUNT ON;
UPDATE Users SET Password=@Input3 WHERE Email=@Input1 AND Password=@Input2
	IF @@ROWCOUNT > 0
		SET @SQLReturn='Changed'
	ELSE 
		SET @SQLReturn='NotChanged'
END
GO
/****** Object:  StoredProcedure [dbo].[SP_check_holiday_live]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_check_holiday_live] 
	@plant varchar(max),
	@company varchar(max),
	@Date varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [HolidayReason]
  FROM [dbo].[tbl_Holiday] where [CompanyCode]=@company and [PlantID]=@plant and Date=@Date
   
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Checklogin]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Checklogin]  
 @UserName nvarchar(50),  
 @Password nvarchar(50),
 @Lastlogin Datetime, 
 @SQLReturn nvarchar(50) output, 
 @lastlogindate Datetime Out  
AS  
BEGIN   
 SET NOCOUNT ON;  
 Declare @result nvarchar(50) 
		declare @lastdate1 as datetime,@lastdate2 as datetime,@currentlogindate as datetime,@currentlogin1 as datetime,@currentlogin2 as datetime 
 Set @result=''  
 If exists(Select * From Users where UserName=@UserName)  
  Begin  
   If exists(Select * From Users where UserName=@UserName AND Password=@Password)  
   Begin  
		set @lastdate1 = @Lastlogin
		set @lastdate2 = @lastdate1
		set @currentlogindate=Getdate()
		set @currentlogin1 =@currentlogindate
		set @currentlogin2 = @currentlogin1
		select @currentlogin2
		set @lastlogindate=(select lastlogindate from Users where UserName=@UserName)
		Update Users set LastLoginDate=@lastdate2 from Users where UserName=@UserName 
		Update Users set CurrentLoginDate=@currentlogin2 from Users where UserName=@UserName
		set @result='Login Successfull...!'   
   END  
   Else If exists(Select * From Users where UserName=@UserName AND otp_code=@Password)  
   Begin  
   set @lastlogindate=(select lastlogindate from Users where UserName=@UserName)
   Update Users set LastLoginDate=@Lastlogin from Users where UserName=@UserName 
   UPDATE Users SET otp_code=Null,one_time=Null from Users where UserName=@UserName 
   set @result='Password Reset Successfull...!' 
   End
   ELSE  
   BEGIN  
    set @result='Password is Incorrect...!'   
   END  
  END  
  Else  
  BEGIN  
   set @result='UserName is Incorrect...!'  
  END  
 set @SQLReturn=@result  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Checklogin_20221007]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Checklogin_20221007]  
 @UserName nvarchar(50),  
 @Password nvarchar(50),
 @Lastlogin Datetime, 
 @SQLReturn nvarchar(50) output, 
 @lastlogindate Datetime Out  
AS  
BEGIN   
 SET NOCOUNT ON;  
 Declare @result nvarchar(50)  
 Set @result=''  
 If exists(Select * From Users where UserName=@UserName)  
  Begin  
   If exists(Select * From Users where UserName=@UserName AND Password=@Password)  
   Begin  
   set @lastlogindate=(select lastlogindate from Users where UserName=@UserName)
   Update Users set LastLoginDate=@Lastlogin from Users where UserName=@UserName 
   set @result='Login Successfull...!'   
   END  
   Else If exists(Select * From Users where UserName=@UserName AND otp_code=@Password)  
   Begin  
   set @lastlogindate=(select lastlogindate from Users where UserName=@UserName)
   Update Users set LastLoginDate=@Lastlogin from Users where UserName=@UserName 
   UPDATE Users SET otp_code=Null,one_time=Null from Users where UserName=@UserName 
   set @result='Password Reset Successfull...!' 
   End
   ELSE  
   BEGIN  
    set @result='Password is Incorrect...!'   
   END  
  END  
  Else  
  BEGIN  
   set @result='UserName is Incorrect...!'  
  END  
 set @SQLReturn=@result  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Customer_details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Customer_details]
	@QueryType nvarchar(25),
	@CompanyCode nvarchar(50)=null,
	@CompanyName nvarchar(150)=null,
	@DomainName nvarchar(50)=null,
	@ContactPerson_FirstName nvarchar(50)=null,
	@ContactPerson_LastName nvarchar(50)=null,
	@ContactPerson_Mobile_NO numeric(18,0)=null,
	@ContactPerson_Email nvarchar(150)=null,
	@LocationName nvarchar(150)=null,
	@Address nvarchar(150)=null,
	@City nvarchar(150)=null,
	@state nvarchar(150)=null,
	@Country nvarchar(150)=null,
	@PostalCode nvarchar(150)=null,
	@Logo nvarchar(150)=null,
	@Manager nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		--inserted by krishna(12-03-2020)--start--**duplicate email id (on users table)need to be validated before new customer creation**
		--If not exists(Select * From tbl_Customer where CompanyName=@CompanyName OR CompanyCode=@CompanyCode)
		If not exists(Select * From tbl_Customer where CompanyCode=@CompanyCode)
		--inserted by krishna(12-03-2020)--end--
		Begin
			Insert Into tbl_Customer(CompanyCode,CompanyName,DomainName,ContactPerson_FirstName,ContactPerson_LastName,ContactPerson_Mobile_NO,ContactPerson_Email
			,LocationName,Address,City,state,Country,PostalCode,Logo,Manager)
			Values(@CompanyCode,@CompanyName,@DomainName,@ContactPerson_FirstName,@ContactPerson_LastName,@ContactPerson_Mobile_NO,@ContactPerson_Email,
			@LocationName,@Address,@City,@state,@Country,@PostalCode,@Logo,@Manager)
				set @result='Inserted'	
		End
		--inserted by krishna(12-03-2020)--start--
		--Else
			--BEGIN
				--set @result='Already'
			--END
		Else If exists(Select * From tbl_Customer where CompanyCode=@CompanyCode)
			BEGIN
				set @result='Already CompanyCode'
			END
		--inserted by krishna(12-03-2020)--end--
	End			
	Else If @QueryType='Update'
	Begin
		Update tbl_Customer set CompanyName=@CompanyName,DomainName=@DomainName,ContactPerson_FirstName=@ContactPerson_FirstName,ContactPerson_LastName=@ContactPerson_LastName,
		ContactPerson_Mobile_NO=@ContactPerson_Mobile_NO,ContactPerson_Email=@ContactPerson_Email,LocationName=@LocationName,Address=@Address,
		City=@City,state=@state,Country=@Country,PostalCode=@PostalCode,Logo=@Logo,Manager=@Manager
		Where CompanyCode=@CompanyCode
			set @result='Updated'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DataLoggingUpdate]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE Procedure [dbo].[SP_DataLoggingUpdate]
as
Begin
/*
select CompanyCode as CompanyName,Line_Code,Max(time_stamp) as Last_Updated_Time,DATEADD(mi,331,getdate()) as Current_DateTime into #temp  from SYNONYM_rawtable(nolock) 

 group by Line_Code,CompanyCode

select *,DATEDIFF(mi,Last_Updated_Time,Current_DateTime) as Time_Diff_Min from #temp
*/
Print 'Disable'
End
GO
/****** Object:  StoredProcedure [dbo].[SP_delete_usersettings]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_delete_usersettings]
	@QueryType nvarchar(25),
	@Parameter nvarchar(150)=null,
	@Parameter1 nvarchar(150)=null
AS
BEGIN	
	SET NOCOUNT ON;
    IF @QueryType='Delete_Customer'
	BEGIN
		DELETE FROM tbl_customer WHERE CompanyCode=@Parameter
		DELETE FROM Users WHERE CompanyCode=@Parameter
		DELETE FROM LNK_USER_ROLE WHERE  CompanyCode=@Parameter 
	END
	Else If @QueryType='Delete_Plantdetails'
		DELETE FROM tbl_Plant WHERE Unique_id=@Parameter 
	Else If @QueryType='Delete_Functiondetails'
		DELETE FROM tbl_Function WHERE Unique_id=@Parameter 
	Else If @QueryType='Delete_Operationsettings'
		DELETE FROM tbl_Operation WHERE Unique_id=@Parameter 
	Else If @QueryType='Delete_Assets'
		DELETE FROM tbl_Assets WHERE Unique_id=@Parameter 
	Else If @QueryType='Delete_Products'
		DELETE FROM tbl_MasterProduct WHERE M_ID=@Parameter 
	Else If @QueryType='Delete_holiday'
		DELETE FROM tbl_Holiday WHERE HolidayID=@Parameter  
	ELSE IF @QueryType='Delete_role'
	BEGIN
		declare @count int
		set @count=(select count(UserID) from Users where RoleID=@Parameter)

		if(@count=0)
			begin
				DELETE FROM tbl_Role WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM tbl_Permission WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM LNK_ROLE_PERMISSION WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM Users WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM LNK_USER_ROLE WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
			end
		
	END
	ELSE IF @QueryType='Delete_Skill'
		DELETE FROM tbl_Skill WHERE Unique_id=@Parameter 
	ELSE IF @QueryType='Delete_User'
	BEGIN
		DELETE FROM Users WHERE UserID=@Parameter AND CompanyCode=@Parameter1
		DELETE FROM LNK_USER_ROLE WHERE UserID=@Parameter AND CompanyCode=@Parameter1
	END
	ELSE IF @QueryType='Delete_Operator_skill'
		DELETE FROM tbl_OperatorSkillMatrix WHERE O_ID=@Parameter
	ELSE IF @QueryType='Delete_alarm'
		DELETE FROM AlarmTable_Setting WHERE A_ID=@Parameter
	ELSE IF @QueryType='Delete_rejection'
		DELETE FROM tbl_Rejection WHERE R_ID=@Parameter
	ELSE IF @QueryType='Delete_loss'
		DELETE FROM LossesTable_Setting WHERE ID=@Parameter
	ELSE IF @QueryType='Delete_tool'
		DELETE FROM tbl_toollist WHERE ID=@Parameter
	ELSE IF @QueryType='Delete_Operator'
		DELETE FROM tbl_Operator WHERE OP_ID=@Parameter
	ELSE IF @QueryType='Delete_shift'
		DELETE FROM ShiftSetting WHERE ID=@Parameter
	ELSE IF @QueryType='Delete_Dept'
		DELETE FROM tbl_department WHERE Unique_id=@Parameter
	ELSE IF @QueryType='Delete_Area'
		DELETE FROM tbl_Area WHERE Unique_id=@Parameter


	--added by deepa for target roduction setting--
	ELSE IF @QueryType='Delete_Targetproduction'
		DELETE FROM tbl_Production_setting WHERE id=@Parameter
	Else If @QueryType='Delete_loss_category'
		DELETE FROM tbl_losscategory WHERE id=@Parameter
	Else If @QueryType='Delete_loss_type'
		DELETE FROM tbl_losstype WHERE id=@Parameter
	Else if @Querytype='Delete_Permissions_edit'
		Delete from tbl_line_permission where roleid=@Parameter
	Else If @QueryType='Delete_Subassembly'
		DELETE FROM tbl_Subassembly WHERE unique_id=@Parameter
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Department_details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Department_details]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@Dept_id nvarchar(150)=null,
	@Dept_name nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@AreaCode nvarchar(50),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_department where CompanyCode=@CompanyCode AND(Dept_id=@Dept_id OR Dept_name=@Dept_name) AND PlantCode=@PlantCode )
		Begin
			Insert Into tbl_department(Dept_id,Dept_name,Status,CompanyCode,PlantCode,areacode)
			Values(@Dept_id,@Dept_name,'Active',@CompanyCode,@PlantCode,@AreaCode)
				set @result='Inserted'	
		END
		--Else
			--BEGIN
				--set @result='Already'
			--END
		--inserted by krishna(12-03-2020)--start--
		Else If exists(Select * From tbl_department where CompanyCode=@CompanyCode AND Dept_id=@Dept_id AND PlantCode=@PlantCode )
			BEGIN
				set @result='Already Dept_id'
			END
			Else 
				BEGIN
					set @result='Already Dept_name'
				END	
		--inserted by krishna(12-03-2020)--end--
	End			
	Else If @QueryType='Update'
	Begin
	--inserted by krishna(12-03-2020)---start---
		If not exists(Select * From tbl_department where CompanyCode=@CompanyCode AND Dept_name=@Dept_name and Unique_id!=@Unique_id AND PlantCode=@PlantCode )
			Begin
				Update tbl_department set Dept_name=@Dept_name,Areacode=@AreaCode
				Where Unique_id=@Unique_id 
					set @result='Updated'
			end
		Else 
				BEGIN
					set @result='Already Dept_name'
				END	
	--inserted by krishna(12-03-2020)---end---
		--Update tbl_department set Dept_name=@Dept_name
		--	Where Unique_id=@Unique_id 
		--		set @result='Updated'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Diagnostic_history]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- Author:      <Mohan>
-- Create Date: <2021-08-03>
-- Description: <Fetch the Diagnostics History on selected duration(from date & to date)>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Diagnostic_history]
(
    -- Parameters for the SPAlertSummary
    @CompanyCode Nvarchar(100)=Null,
	@PlantCode NVarchar(100)=Null,
	@LineCode as varchar(50)=Null,
	@Fromdate Date=Null,
	@Todate Date=Null 

)
AS
BEGIN
--Fetching the data from [Diagnostics_Event_details] table 
--For Selection of History data between the mentioned duration by user in the portal
	SELECT top 100 a.[Device_ID],a.[Device_ref],a.[LogTime],b.devicename,a.[EventText] as EventName
	FROM [dbo].[Diagnostics_Event_details] a join tbl_ewon_details b on a.device_id = b.device_id
	where a.LogTime BETWEEN Convert(datetime,@Fromdate) AND (Convert(datetime,@Todate)+1)
	and a.CompanyCode=@CompanyCode and a.PlantCode=@PlantCode and a.LineCode=@LineCode
	order by a.[Device_ID],a.[Device_ref],a.LogTime desc

END
GO
/****** Object:  StoredProcedure [dbo].[sp_Diagnostic_history_Default]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- Author:      <Mohan>
-- Create Date: <2021-08-03>
-- Description: <Fetch the Diagnostics History on selected duration(from date & to date)>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Diagnostic_history_Default]
(
    -- Parameters for the SPAlertSummary
    @CompanyCode Nvarchar(100)=Null,
	@PlantCode NVarchar(100)=Null,
	@LineCode as varchar(50)=Null

)
AS
BEGIN
--Fetching the data from [Diagnostics_Event_details] table 
--For Selection of History data between the mentioned duration by user in the portal
	
	SELECT distinct OUTSIDE.*,b.devicename FROM[Diagnostics_Event_details] OUTSIDE
                    join tbl_ewon_details b on OUTSIDE.device_id = b.device_id,
                    (SELECT distinct[Device_ID], [Device_ref], MAX(LogTime) as maxtimestamp 
                    FROM[Diagnostics_Event_details] GROUP BY[Device_ID], [Device_ref]) AS INSIDE 
                    WHERE OUTSIDE.[Device_ID] = INSIDE.[Device_ID] AND OUTSIDE.[Device_ref] = INSIDE.[Device_ref] 
                    AND OUTSIDE.LogTime = INSIDE.maxtimestamp AND OUTSIDE.Device_ref!='message' 
                    AND OUTSIDE.device_ref!='code' AND OUTSIDE.device_ref!='success' 
                    AND OUTSIDE.CompanyCode=@CompanyCode AND  OUTSIDE.PlantCode=@PlantCode AND OUTSIDE.LineCode=@LineCode 
                    order by b.devicename, OUTSIDE.[Device_ref], OUTSIDE.[LogTime]

END
GO
/****** Object:  StoredProcedure [dbo].[sp_Diagnostics]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[sp_Diagnostics]
	@QueryType nvarchar(max),
	@deviceid nvarchar(max)=null,
	@deviceref nvarchar(150)=null,
	@make nvarchar(150)=null,
	@gateway nvarchar(250)=null,
	@partnumber nvarchar(250)=null,
	@ioserver nvarchar(250)=null,
	@macaddress nvarchar(250)=null,
	@connectedTo nvarchar(250)=null,
	@installed nvarchar(250)=null,
	@remarks nvarchar(max)=null,
	@CompanyCode nvarchar(150)=null,
	@PlantCode nvarchar(150)=null,
	@LineCode nvarchar(150)=null,
	@unique_id int=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @rcount int

	Set @rcount=0
	If @QueryType='Insert'
	Begin

		if not exists(select *from [Diagnostics_Settings] where CompanyCode=@CompanyCode AND linecode=@LineCode AND PlantCode=@PlantCode and [Device_ID]=@deviceid and [Device_Ref]=@deviceref)
		begin
			Insert Into [dbo].[Diagnostics_Settings] ([Device_ID],[Device_Ref],[make],[gateway],[Part_Number],[IO_Server],[Mac_Address],[Connecetd_to]
														,[Intsalled],[Remarks],[CompanyCode],[PlantCode],[LineCode])
			Values(@deviceid,@deviceref,@make,@gateway,@partnumber,@ioserver,@macaddress,@connectedTo,@installed,@remarks,@CompanyCode,@PlantCode,@LineCode)
			set @rcount=1
		end
		else
		begin
			set @rcount=4
		end
		
			
	End			

	Else If @QueryType='Update'

	Begin
		Update [Diagnostics_Settings] set [Device_Ref]=@deviceref,[make]=@make,[gateway]=@gateway,
		[Part_Number]=@partnumber,[IO_Server]=@ioserver,[Mac_Address]=@macaddress,[Connecetd_to]=@connectedTo,
		[Intsalled]=@installed,[Remarks]=@remarks
		Where [Unique_ID]=@unique_id and [Device_ID]=@deviceid

		
		set @rcount=2
	End

	Else IF @QueryType='Delete_Diagnostics_details'
		Begin
			
			delete from [Diagnostics_Settings] where [Unique_ID]=@unique_id

			set @rcount=3
		END
	set @SQLReturn=@rcount
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Diagnostics_Event_Insert_Update]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[SP_Diagnostics_Event_Insert_Update]
	@deviceid nvarchar(150)=null,
	@deviceref nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,
	@PlantCode nvarchar(150)=null,
	@LineCode nvarchar(150)=null,
	@event nvarchar(150)=null,
	@eventtext nvarchar(150)=null,
	@logtime DateTime=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int,@changedTime datetime,@uniqueid int
	Set @result=''
		
		set @changedTime=(select (DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @logtime), 0)))

		If not exists(Select top 1 * From [dbo].[Diagnostics_Event_details] 
					where [Device_ID]=@deviceid and [Device_Ref]=@deviceref and 
					[CompanyCode]=@CompanyCode and [PlantCode]=@PlantCode and [LineCode]=@LineCode and 
					[EventName]=@event and 
					LogTime=(select distinct Max(LogTime) from [Diagnostics_Event_details] 
					where [Device_ID]=@deviceid and [Device_Ref]=@deviceref and 
					[CompanyCode]=@CompanyCode and [PlantCode]=@PlantCode and [LineCode]=@LineCode)
					order by LogTime desc)
		Begin
			
			Insert Into [dbo].[Diagnostics_Event_details] ([Device_ID],[Device_ref],[EventName],[EventText],[CompanyCode],[PlantCode],[LineCode],[LogTime],[Time_stamp])
			Values(@deviceid,@deviceref,@event,@eventtext,@CompanyCode,@PlantCode,@LineCode,@changedTime,@changedTime)

				set @result='Inserted'	
		END
		
		
		Else 
			BEGIN

			set @uniqueid=(Select top 1 [Unique_ID] From [dbo].[Diagnostics_Event_details] 
					where [Device_ID]=@deviceid and [Device_Ref]=@deviceref and 
					[CompanyCode]=@CompanyCode and [PlantCode]=@PlantCode and [LineCode]=@LineCode and 
					[EventName]=@event and 
					LogTime=(select distinct Max(LogTime) from [Diagnostics_Event_details] 
					where [Device_ID]=@deviceid and [Device_Ref]=@deviceref and 
					[CompanyCode]=@CompanyCode and [PlantCode]=@PlantCode and [LineCode]=@LineCode)
					order by LogTime desc)

				update [Diagnostics_Event_details] set [Time_stamp]=@changedTime
				where [Unique_ID]=@uniqueid

				set @result='Updated'	
			END	
		
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Ewon_Details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[SP_Ewon_Details]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@Unique_id int=null 
	

AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
	If @QueryType='Details'
	Begin
		select * from [tbl_Ewon_Details] where CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode
	End	
	Else If @QueryType='edit_Details'
	Begin
		select * from [tbl_Ewon_Details] where id=@Unique_id 
	End		
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FactoryKPI_linedetails_1]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_FactoryKPI_linedetails_1]
@CompanyCode nvarchar(150),
@PlantCode nvarchar(150),
@LineCode nvarchar(150)


as
BEGIN
select b.dept_name as Dept_Name,c.area_name as Area_Name from tbl_function as a 
inner join tbl_department as b on b.dept_id=a.dept_id and b.companycode=@companycode and b.plantcode=@PlantCode 
inner join tbl_area as c on b.areacode=c.area_id and c.companycode=@companycode and c.plantcode=@PlantCode 
where a.companycode=@companycode and a.parentplant =@PlantCode and a.FunctionID =@LineCode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Feedback]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Feedback]
	@QueryType nvarchar(25),
	@id int=null,
	@username nvarchar(150),
	@feedback nvarchar(150),
	@document nvarchar(max)=null,
	@comments nvarchar(max),
	@plant nvarchar(150),
	@date date,
	@company nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
		Begin
			
				INSERT INTO [dbo].[tbl_Feedback]([UserName],[Feedback],[FB_Comments],[FB_Document],[FB_Date],[CompanyCode],[PlantCode])
					VALUES(@username,@feedback,@comments,@document,@date,@company,@plant)
						set @result='Inserted'
			
		End			
	
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Forgotpassword]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_Forgotpassword]
@Input1 nvarchar(50)=null,
@Input2 nvarchar(50)=null,
@SQLReturn nvarchar(50) Output
AS
BEGIN
SET NOCOUNT ON;
Declare @result nvarchar(50)
Set @result=''
IF exists(SELECT * FROM Users WHERE Email=@Input1)
	BEGIN
	--added by pranitha
		UPDATE Users SET Password=@Input2,one_time= DateAdd(minute,10,Format(cast(CURRENT_TIMESTAMP as datetime),'dd-MMM-yyyy HH:mm:ss')) WHERE Email=@Input1
			IF @@ROWCOUNT > 0
			SET @result='OK'
	END
ElSE
	BEGIN
		SET @result='Notok'
	END
set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Function]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_Function]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@FunctionID nvarchar(150)=null,
	@FunctionName nvarchar(150)=null,
	@FunctionDescription nvarchar(150)=null,
	@ParentPlant nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,
	@Dept_id nvarchar(150)=null,
	@IsActive nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Function where CompanyCode=@CompanyCode AND (FunctionID=@FunctionID OR FunctionName=@FunctionName))
		Begin
			Insert Into tbl_Function(FunctionID,FunctionName,Dept_id,FunctionDescription,ParentPlant,IsActive,CompanyCode)
			Values(@FunctionID,@FunctionName,@Dept_id,@FunctionDescription,@ParentPlant,@IsActive,@CompanyCode)
				set @result='Inserted'	
		END
		Else If exists(Select * From tbl_Function where CompanyCode=@CompanyCode AND FunctionID=@FunctionID)
				BEGIN
					set @result='Already FunctionID'
				END
				Else 
					BEGIN
						set @result='Already FunctionName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		
		Begin
			If not exists(Select FunctionName From tbl_Function where CompanyCode=@CompanyCode AND FunctionName=@FunctionName and ParentPlant=@ParentPlant AND FunctionID=@FunctionID and Dept_id=@Dept_id and FunctionDescription=@FunctionDescription)
				BEGIN
					Update tbl_Function set FunctionName=@FunctionName,Dept_id=@Dept_id,FunctionDescription=@FunctionDescription,
					ParentPlant=@ParentPlant,IsActive=@IsActive Where FunctionID=@FunctionID 
						set @result='Updated'

				END
			Else 
						BEGIN
							set @result='Already FunctionName'
						END
		End
		set @SQLReturn=@result
	End
	


	Else If @QueryType='Delete'
	Begin	
		DELETE FROM tbl_Function WHERE FunctionID=@FunctionID 
		set @result='Deleted'
	End
	set @SQLReturn=@result



END
GO
/****** Object:  StoredProcedure [dbo].[SP_get_no_of_lines]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_get_no_of_lines]

@CompanyCode nvarchar(150),
@PlantCode nvarchar(150)

AS
BEGIN

select * from tbl_Function where CompanyCode=@CompanyCode and ParentPlant=@PlantCode
  

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetSettings_data]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE prOCEDURE [dbo].[SP_GetSettings_data]
	@QueryType nvarchar(150),
	@Parameter nvarchar(150)=null,
	@Parameter1 nvarchar(150)=null,
	@Parameter2 nvarchar(150)=null,
	@subassembly nvarchar(150)=null,
	@Parameter4 nvarchar(150)=null,
	@Parameter3 nvarchar(150)=null
AS
BEGIN	
	SET NOCOUNT ON;
	
	If @QueryType='Customer'
		SELECT * FROM tbl_Customer
	Else If @QueryType='PropertyGroup'
		SELECT * FROM [tbl_SMS_Group] WHERE CompanyCode=@Parameter1 AND [PlantCode]=@Parameter and [Line_code]=@Parameter2
	Else If @QueryType='Portal_URL_details'
		SELECT distinct [id] as Unique_id,[URL],[CompanyCode],[PlantCode],[LineCode]FROM [dbo].[Portal_URL] WHERE CompanyCode=@Parameter1 AND [PlantCode]=@Parameter
	ELSE IF @QueryType='Edit_URL'
		SELECT distinct [id] as Unique_id,[URL],[CompanyCode],[PlantCode],[LineCode]FROM [dbo].[Portal_URL] WHERE id=@Parameter 
	ELSE IF @QueryType='Feedback_details'
		SELECT distinct * FROM tbl_Feedback 
		--WHERE CompanyCode=@Parameter1 and PlantCode=@Parameter
	Else If @QueryType='Assets'
		SELECT * FROM tbl_Assets WHERE CompanyCode=@Parameter1 AND PlantCode=@Parameter and FunctionName=@Parameter2
	Else If @QueryType='Function'
		SELECT * FROM tbl_Function WHERE CompanyCode=@Parameter1 AND ParentPlant=@Parameter 
	Else If @QueryType='NewFunction'
		SELECT * FROM tbl_Function WHERE CompanyCode=@Parameter1 AND ParentPlant=@Parameter and FunctionID=@Parameter2
	Else If @QueryType='Function_details'
		SELECT A.FunctionID,A.FunctionName,B.PlantName,A.IsActive,A.Unique_id FROM tbl_Function AS A INNER JOIN tbl_Plant AS B ON A.ParentPlant=B.PlantID
	Else If @QueryType='Customer_Function_details'
		SELECT A.FunctionID,A.FunctionName,B.PlantName,A.IsActive,A.Unique_id FROM tbl_Function AS A INNER JOIN tbl_Plant AS B ON A.ParentPlant=B.PlantID
		and A.CompanyCode=B.ParentOrganization	WHERE A.CompanyCode=@Parameter1 AND A.ParentPlant=@Parameter
	Else If @QueryType='NewCustomer_Function_details'
		SELECT A.FunctionID,A.FunctionName,B.PlantName,A.IsActive,A.Unique_id,c.dept_name FROM tbl_Function AS A INNER JOIN tbl_Plant AS B ON A.ParentPlant=B.PlantID
		and A.CompanyCode=B.ParentOrganization join tbl_department c on c.dept_id=a.dept_id	and c.[CompanyCode]=A.[CompanyCode] and c.[PlantCode]=A.ParentPlant 
		WHERE A.CompanyCode=@Parameter1 AND A.ParentPlant=@Parameter 
	Else If @QueryType='Customer_Plant'
		SELECT * FROM tbl_Plant WHERE ParentOrganization=@Parameter1
	Else If @QueryType='Plant'
		SELECT * FROM tbl_Plant
	ELSE IF @QueryType='Company_Operations'
		SELECT * FROM tbl_Operation WHERE CompanyCode=@Parameter1 and Plantcode=@Parameter and Line_Code=@Parameter2
	ELSE IF @QueryType='Company_Operations_select'
		SELECT * FROM tbl_Operation WHERE CompanyCode=@Parameter1 and Plantcode=@Parameter
	ELSE IF @QueryType='NewCompany_Operations_select'
		SELECT * FROM tbl_Operation WHERE CompanyCode=@Parameter1 and Plantcode=@Parameter and Line_Code=@Parameter2
	ELSE IF @QueryType='Operations'
		SELECT * FROM tbl_Operation 
	ELSE IF @QueryType='Products'
		SELECT * FROM tbl_MasterProduct WHERE CompanyCode=@Parameter1 and Line_Code=@Parameter
	ELSE IF @QueryType='Holiday'
		SELECT * FROM tbl_Holiday WHERE CompanyCode=@Parameter1
	ELSE IF @QueryType='User'
		SELECT * FROM users  WHERE CompanyCode=@Parameter1
	ELSE IF @QueryType='Roles'
		SELECT * FROM tbl_role WHERE CompanyCode=@Parameter1 AND PlantCode=@Parameter 
	ELSE IF @QueryType='LineRoles'
		SELECT * FROM tbl_Line_Role WHERE CompanyCode=@Parameter1
	ELSE IF @QueryType='ShiftSettings'
		SELECT * FROM ShiftSetting WHERE CompanyCode=@Parameter1 AND PlantCode=@Parameter and LineCode=@Parameter2
	
	ELSE IF @QueryType='Assetsdetails'
		SELECT AssetID,AssetName,AssetDescription,A.Unique_id,B.FunctionName as 'funname',C.ShiftName as 'sname' FROM tbl_Assets AS A INNER JOIN tbl_Function AS B ON A.FunctionName=B.FunctionID
		INNER JOIN ShiftSetting AS C ON A.EOL=C.ID
	ELSE IF @QueryType='Customer_Assetsdetails'
		SELECT AssetID,AssetName,AssetDescription,A.Unique_id,B.FunctionName as 'funname',A.EOL as 'sname' 
		FROM tbl_Assets AS A INNER JOIN tbl_Function AS B ON A.FunctionName=B.FunctionID
		WHERE A.CompanyCode=@Parameter1 AND B.CompanyCode=@Parameter1 
		AND A.PlantCode=@Parameter AND B.ParentPlant=@Parameter AND B.FunctionID=@Parameter2
	ELSE IF @QueryTYpe='Customer_Product_details'
		SELECT A.Variant_Code,A.VariantName,A.VariantDescription,A.M_ID,A.RecipeName,A.CycleTime,A.Cost,A.auto_cycletime as Autocycletime,A.manual_cycletime as Manualcycletime,B.OperationName AS 'OpName',C.AssetName AS 'AsName' FROM tbl_MasterProduct AS A 
		INNER JOIN tbl_Operation AS B ON A.OperationName=B.OperationID and A.Companycode=B.Companycode and A.PlantCode=B.PlantCode and A.Line_code=B.Line_code
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.Companycode=C.Companycode and A.PlantCode=C.PlantCode and A.Line_code=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter
	ELSE IF @QueryTYpe='NewCustomer_Product_details'
		SELECT A.Variant_Code,A.VariantName,A.VariantDescription,A.M_ID,A.RecipeName,A.CycleTime,A.Cost,A.auto_cycletime as Autocycletime,A.manual_cycletime as Manualcycletime,B.OperationName AS 'OpName',C.AssetName AS 'AsName' FROM tbl_MasterProduct AS A 
		INNER JOIN tbl_Operation AS B ON A.OperationName=B.OperationID and A.Companycode=B.Companycode and A.PlantCode=B.PlantCode and A.Line_code=B.Line_code
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.Companycode=C.Companycode and A.PlantCode=C.PlantCode and A.Line_code=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter And A.Line_code=@Parameter2
	ELSE IF @QueryTYpe='Product_details'
		SELECT A.Variant_Code,A.VariantName,A.VariantDescription,A.M_ID,A.RecipeName,A.CycleTime,A.Cost,B.OperationName AS 'OpName',C.AssetName AS 'AsName' FROM tbl_MasterProduct AS A INNER JOIN tbl_Operation AS B ON A.OperationName=B.OperationID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID
	ELSE IF @QueryType='Edit_Customer'
		SELECT * FROM tbl_Customer WHERE CompanyCode=@Parameter
	ELSE IF @QueryType='Edit_Function'
		SELECT * FROM tbl_Function WHERE Unique_id=@Parameter
	ELSE IF @QueryType='Edit_Plant'
		SELECT * FROM tbl_Plant WHERE Unique_id=@Parameter 
	ELSE IF @QueryType='Edit_Operation'
		SELECT * FROM tbl_Operation WHERE Unique_id=@Parameter 
	ELSE IF @QueryType='Edit_Assets'
		SELECT * FROM tbl_Assets WHERE Unique_id=@Parameter
	ELSE IF @QueryType='Edit_Products'
		SELECT * FROM tbl_MasterProduct WHERE M_ID=@Parameter 
	ELSE IF @QueryType='Edit_holiday'
		SELECT HolidayReason,CONVERT(nvarchar(150),Date,105) AS 'Date',HolidayID,Unique_id FROM tbl_Holiday WHERE HolidayID=@Parameter
	ELSE IF @QueryType='Customer_Holiday_details'
		SELECT A.HolidayID,A.HolidayReason,B.PlantName,A.Unique_id,A.Date,CONVERT(nvarchar(150),A.Date,105) AS 'Dates'
		 FROM tbl_Holiday AS A INNER JOIN tbl_Plant AS B ON A.PlantID=B.PlantID
		 WHERE A.CompanyCode=@Parameter1 AND B.ParentOrganization=@Parameter1
	ELSE IF @QueryType='Holiday_details'
		SELECT A.HolidayID,A.HolidayReason,B.PlantName,A.Unique_id,A.Date,CONVERT(nvarchar(150),A.Date,105) AS 'Dates'
		 FROM tbl_Holiday AS A INNER JOIN tbl_Plant AS B ON A.PlantID=B.PlantID
	--ELSE IF @QueryType='Edit_holiday'
	--	SELECT * FROM tbl_Holiday WHERE Unique_id=@Parameter
	--ELSE IF @QueryType='Customer_Holiday_details'
	--	SELECT A.HolidayID,A.HolidayReason,B.PlantName,A.Unique_id,A.Date,CONVERT(nvarchar(150),A.Date,105) AS 'Dates'
	--	 FROM tbl_Holiday AS A INNER JOIN tbl_Plant AS B ON A.PlantID=B.PlantID
	--	 WHERE A.CompanyCode=@Parameter1 AND B.ParentOrganization=@Parameter1
	--ELSE IF @QueryType='Holiday_details'
	--	SELECT A.HolidayID,A.HolidayReason,B.PlantName,A.Unique_id,A.Date,CONVERT(nvarchar(150),A.Date,105) AS 'Dates'
	--	 FROM tbl_Holiday AS A INNER JOIN tbl_Plant AS B ON A.PlantID=B.PlantID
	ELSE IF @QueryType='Role_details'
		SELECT A.RoleID,A.RoleName,A.RoleDescription FROM tbl_Role AS A 
		WHERE A.CompanyCode=@Parameter1 and PlantCode=@Parameter 
	ELSE IF @QueryType='Customer_Skill_details'
		SELECT * FROM tbl_Skill WHERE CompanyCode=@Parameter1
		--SELECT [Unique_id],[SkillName],(select [FunctionName] from tbl_Function where FunctionID=[Line_Code])Line_Code FROM [dbo].[tbl_Skill] WHERE CompanyCode=@Parameter1
	ELSE IF @QueryType='NewCustomer_Skill_details'
		SELECT * FROM tbl_Skill WHERE CompanyCode=@Parameter1 and PlantCode=@Parameter and Line_Code=@Parameter2
	ELSE IF @QueryType='Skill_details'
		SELECT * FROM tbl_Skill 
	ELSE IF @QueryType='Skills'
		SELECT * FROM tbl_Skill WHERE CompanyCode=@Parameter1 and Line_Code=@Parameter
	ELSE IF @QueryType='SkillsForUserSettings'
		SELECT * FROM tbl_Skill WHERE CompanyCode=@Parameter1 
	ELSE IF @QueryType='Edit_role'
	BEGIN
		SELECT * FROM tbl_Role WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
		SELECT * FROM tbl_Permission WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
	END
	ELSE IF @QueryType='Edit_Skill'
		SELECT * FROM tbl_Skill WHERE Unique_id=@Parameter 
	ELSE IF @QueryType='Edit_User'
		SELECT * FROM Users WHERE UserID=@Parameter AND CompanyCode=@Parameter1 
	ELSE IF @QueryType='Customer_User_details'
		--SELECT A.UserID,A.FirstName,A.LastName,A.PhoneNo,A.Email,C.SkillName,D.RoleName,A.Unique_id FROM Users AS A  INNER JOIN tbl_Skill AS C ON A.SkillSet=C.Skill_ID(MODIFIED BY KRISHNA 12-03-2020)
		SELECT a.UserName,A.UserID,A.FirstName,A.LastName,A.PhoneNo,A.Email,C.SkillName,D.RoleName,A.Unique_id,l.RoleName as LineRoleID FROM Users AS A  INNER JOIN tbl_Skill AS C ON A.SkillSet=C.Skill_ID
		 INNER JOIN tbl_Role AS D ON A.RoleID=D.RoleID left Join tbl_Line_Role l on l.roleid=a.LineRoleID
		 WHERE A.CompanyCode=@Parameter AND C.CompanyCode=@Parameter AND D.CompanyCode=@Parameter 
	ELSE IF @QueryType='User_details'
		SELECT A.UserID,A.FirstName,A.LastName,A.PhoneNo,A.Email,C.SkillName,D.RoleName FROM Users AS A LEFT JOIN tbl_Skill AS C ON A.SkillSet=C.Skill_ID
		 LEFT JOIN tbl_Role AS D ON A.RoleID=D.RoleID
	ELSE IF @QueryType='Customer_User_details'
		SELECT A.UserID,A.FirstName,A.LastName,A.PhoneNo,A.Email,C.SkillName,D.RoleName FROM Users AS A LEFT JOIN tbl_Skill AS C ON A.SkillSet=C.Skill_ID
		 LEFT JOIN tbl_Role AS D ON A.RoleID=D.RoleID
		 WHERE A.CompanyCode=@Parameter AND A.PlantCode=@Parameter1
	ELSE IF @QueryType='Customer_Operator_skill'
		SELECT A.OperatorID,A.ScoreValue,B.SkillName AS 'SName',O_ID,C.OperatorName FROM tbl_OperatorSkillMatrix AS A 
		INNER JOIN tbl_skill AS B ON A.SkillName=B.Skill_ID 
		INNER JOIN tbl_operator AS C ON A.OperatorID=C.OperatorID
		WHERE A.CompanyCode=@Parameter1 AND B.CompanyCode=@Parameter1 AND C.CompanyCode=@Parameter1 
	ELSE IF @QueryType='NewCustomer_Operator_skill'
		SELECT A.OperatorID,A.ScoreValue,B.SkillName AS 'SName',O_ID,C.OperatorName FROM tbl_OperatorSkillMatrix AS A 
		INNER JOIN tbl_skill AS B ON A.SkillName=B.Skill_ID 
		INNER JOIN tbl_operator AS C ON A.OperatorID=C.OperatorID
		WHERE A.CompanyCode=@Parameter1 AND B.CompanyCode=@Parameter1 AND C.CompanyCode=@Parameter1 AND B.Line_Code=@Parameter2 And B.PlantCode=@Parameter
	ELSE IF @QueryType='Operator_skill'
		SELECT A.OperatorID,A.ScoreValue,B.SkillName AS 'SName',O_ID FROM tbl_OperatorSkillMatrix AS A 
		INNER JOIN tbl_skill AS B ON A.SkillName=B.Skill_ID
	ELSE IF @QueryType='Edit_Operator_skill'
		SELECT * FROM tbl_OperatorSkillMatrix WHERE O_ID=@Parameter
	ELSE IF @QueryType='Customer_Alarm_details'
		SELECT A.Alarm_ID,A.A_ID,A.Alarm_Description,B.FunctionName,C.AssetName FROM AlarmTable_Setting AS A INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.CompanyCode=B.CompanyCode and B.CompanyCode=C.CompanyCode and A.PlantCode=B.ParentPlant and
		C.PlantCode=B.ParentPlant and A.Line_code=B.FUnctionID and B.FUnctionID=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter
	ELSE IF @QueryType='NewCustomer_Alarm_details'
		SELECT A.Alarm_ID,A.A_ID,A.Alarm_Description,B.FunctionName,C.AssetName FROM AlarmTable_Setting AS A INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.CompanyCode=B.CompanyCode and B.CompanyCode=C.CompanyCode and A.PlantCode=B.ParentPlant and
		C.PlantCode=B.ParentPlant and A.Line_code=B.FUnctionID and B.FUnctionID=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter AND A.Line_code=@Parameter2
	ELSE IF @QueryType='Alarm_details'
		SELECT A.Alarm_ID,A.A_ID,A.Alarm_Description,B.FunctionName,C.AssetName FROM AlarmTable_Setting AS A INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID
	ELSE IF @QueryType='Edit_alarm'
		SELECT * FROM AlarmTable_Setting WHERE A_ID=@Parameter
	ELSE IF @QueryType='Edit_Rejection'
		SELECT * FROM tbl_Rejection WHERE R_ID=@Parameter
	ELSE IF @QueryType='Customer_Rejectiondetails'
	BEGIN
		SELECT A.R_ID,A.RejectionCode,A.RejectionName,A.RejectionDescription,B.VariantName AS 'PName',C.OperationName AS 'OName',D.AssetName AS 'AName'
		FROM tbl_Rejection AS A INNER JOIN tbl_MasterProduct AS B ON A.ProductName=B.Variant_Code and A.CompanyCode=B.CompanyCode and A.PlantCode=B.PlantCode and A.Line_code=B.Line_Code
		INNER JOIN tbl_Operation AS C ON A.OperationName=C.OperationID and  A.CompanyCode=C.CompanyCode and A.PlantCode=C.PlantCode and A.Line_code=C.Line_Code
		INNER JOIN tbl_Assets AS D ON A.AssetName=D.AssetID and A.CompanyCode=D.CompanyCode and A.PlantCode=D.PlantCode and A.Line_code=D.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter

	END
	ELSE IF @QueryType='NewCustomer_Rejectiondetails'
	BEGIN
		SELECT A.R_ID,A.RejectionCode,A.RejectionName,A.RejectionDescription,B.VariantName AS 'PName',C.OperationName AS 'OName',D.AssetName AS 'AName'
		FROM tbl_Rejection AS A INNER JOIN tbl_MasterProduct AS B ON A.ProductName=B.Variant_Code and A.CompanyCode=B.CompanyCode and A.PlantCode=B.PlantCode and A.Line_code=B.Line_Code
		INNER JOIN tbl_Operation AS C ON A.OperationName=C.OperationID and  A.CompanyCode=C.CompanyCode and A.PlantCode=C.PlantCode and A.Line_code=C.Line_Code
		INNER JOIN tbl_Assets AS D ON A.AssetName=D.AssetID and A.CompanyCode=D.CompanyCode and A.PlantCode=D.PlantCode and A.Line_code=D.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter and A.Line_code=@Parameter2

	END
	ELSE IF @QueryType='Rejection_details'
		SELECT A.R_ID,A.RejectionCode,A.RejectionName,A.RejectionDescription,B.VariantName AS 'PName',C.OperationName AS 'OName',D.AssetName AS 'AName' 
		FROM tbl_Rejection AS A INNER JOIN tbl_MasterProduct AS B ON A.ProductName=B.Variant_Code
		INNER JOIN tbl_Operation AS C ON A.OperationName=C.OperationID
		INNER JOIN tbl_Assets AS D ON A.AssetName=D.AssetID
	ELSE IF @QueryType='Edit_Loss'
		SELECT * FROM LossesTable_Setting WHERE ID=@Parameter
	ELSE IF @QueryType='Customer_Lossesdetails'
		SELECT A.Loss_ID,A.ID,A.Loss_Description,B.FunctionName,C.AssetName FROM LossesTable_Setting AS A INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.CompanyCode=B.CompanyCode and B.CompanyCode=C.CompanyCode and A.PlantCode=B.ParentPlant and
		C.PlantCode=B.ParentPlant and A.Line_code=B.FUnctionID and B.FUnctionID=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter
	ELSE IF @QueryType='NewCustomer_Lossesdetails'
		SELECT A.Loss_ID,A.ID,A.Loss_Description,B.FunctionName,C.AssetName FROM LossesTable_Setting AS A INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.CompanyCode=B.CompanyCode and B.CompanyCode=C.CompanyCode and A.PlantCode=B.ParentPlant and
		C.PlantCode=B.ParentPlant and A.Line_code=B.FUnctionID and B.FUnctionID=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter and A.Line_code=@Parameter2
	ELSE IF @QueryType='Losses_details'
		SELECT A.Loss_ID,A.ID,A.Loss_Description,B.FunctionName,C.AssetName FROM LossesTable_Setting AS A INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID
	ELSE IF @QueryType='Edit_tool'
		SELECT * FROM tbl_toollist WHERE ID=@Parameter

	ELSE IF @QueryType='Get_tool'
		SELECT * FROM tbl_toollist WHERE ToolID=@Parameter and Line_code=@Parameter1 and Active=1
	
	--ELSE IF @QueryType='Get_ewonurl'
	--	SELECT * FROM tbl_ewon_details WHERE M=@Parameter and Line_code=@Parameter1 and Active=1

	ELSE IF @QueryType='Get_ewondevicename'
		SELECT * FROM tbl_ewon_details WHERE Companycode=@Parameter and plantcode=@Parameter1 and linecode=@Parameter2
	ELSE IF @QueryType='Get_ewonassetdevice'
		SELECT * FROM tbl_ewon_details WHERE Companycode=@Parameter and plantcode=@Parameter1 and DeviceName=@Parameter2
	
	ELSE IF @QueryType='Customer_Toolsdetails'
		SELECT A.ToolID,A.ID,A.ToolName,B.FunctionName,C.AssetName FROM tbl_toollist AS A 
		INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID and A.CompanyCode=B.CompanyCode and A.PlantCode=B.ParentPlant
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.CompanyCode=C.CompanyCode and A.PlantCode=C.PlantCode and A.Line_code=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter 
	ELSE IF @QueryType='NewCustomer_Toolsdetails'
		SELECT A.ToolID,A.ID,A.ToolName,B.FunctionName,C.AssetName FROM tbl_toollist AS A 
		INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID and A.CompanyCode=B.CompanyCode and A.PlantCode=B.ParentPlant
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID and A.CompanyCode=C.CompanyCode and A.PlantCode=C.PlantCode and A.Line_code=C.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter and A.Line_code=@Parameter2
	ELSE IF @QueryType='Tools_details'
		SELECT A.ToolID,A.ID,A.ToolName,B.FunctionName,C.AssetName FROM tbl_toollist AS A INNER JOIN tbl_Function AS B ON A.Line_Code=B.FunctionID
		INNER JOIN tbl_Assets AS C ON A.Machine_Code=C.AssetID
	ELSE IF @QueryType='Edit_Operator'
		SELECT * FROM tbl_Operator WHERE OP_ID=@Parameter
	ELSE IF @QueryType='Customer_Operator_details'
		SELECT A.OP_ID,A.OperatorName,A.OperatorID,B.AssetName AS 'AName' FROM tbl_Operator AS A 
		INNER JOIN tbl_Assets AS B ON A.AssetName=B.AssetID and A.CompanyCode=B.CompanyCode and A.PlantCode=b.PlantCode and a.line_code=b.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter 
	ELSE IF @QueryType='NewCustomer_Operator_details'
		SELECT A.OP_ID,A.OperatorName,A.OperatorID,B.AssetName AS 'AName' FROM tbl_Operator AS A 
		INNER JOIN tbl_Assets AS B ON A.AssetName=B.AssetID and A.CompanyCode=B.CompanyCode and A.PlantCode=b.PlantCode and a.line_code=b.FunctionName
		WHERE A.CompanyCode=@Parameter1 AND A.PlantCode=@Parameter and a.line_code=@Parameter2
	ELSE IF @QueryType='Operator_details'
		SELECT A.OP_ID,A.OperatorName,A.OperatorID,B.AssetName AS 'AName' FROM tbl_Operator AS A 
		INNER JOIN tbl_Assets AS B ON A.AssetName=B.AssetID 
	ELSE IF @QueryType='Customer_Shift_details'
		SELECT * FROM ShiftSetting WHERE CompanyCode=@Parameter1 AND PlantCode=@Parameter
	ELSE IF @QueryType='NewCustomer_Shift_details'
		SELECT * FROM ShiftSetting WHERE CompanyCode=@Parameter1 AND PlantCode=@Parameter and LineCode=@Parameter2
	ELSE IF @QueryType='Shift_details'
		SELECT * FROM ShiftSetting 
	ELSE IF @QueryType='Edit_Shift'
		SELECT * FROM ShiftSetting WHERE ID=@Parameter
	ELSE IF @QueryType='Operators'
		SELECT * FROM tbl_Operator WHERE CompanyCode=@Parameter1 and Line_Code=@Parameter
	ELSE IF @QueryType='Country_list'
		SELECT * FROM tbl_Countries
	ELSE IF @QueryTYpe='State_list'
		SELECT * FROM tbl_States WHERE Country_id=@Parameter
	ELSE IF @QueryType='City_list'
		SELECT * FRom tbl_Cities WHERE State_id=@Parameter
	ELSE IF @QueryType='Dept_details'
		SELECT * FROM tbl_department WHERE CompanyCode=@Parameter1 and  PlantCode=@Parameter
	ELSE IF @QueryType='Area_details'
		SELECT * FROM tbl_area WHERE CompanyCode=@Parameter1 and  PlantCode=@Parameter
	ELSE IF @QueryType='newDept_details'
		SELECT d.Unique_id,d.Dept_id,d.Dept_name,d.Status,d.CompanyCode,d.LineCode,d.PlantCode,a.Area_name FROM tbl_department d left join tbl_area a on d.areacode=a.area_id and d.plantcode=a.plantcode WHERE d.CompanyCode=@Parameter1 and  d.PlantCode=@Parameter 
	ELSE IF @QueryType='Edit_Dept'
		SELECT * FROM tbl_department WHERE Unique_id=@Parameter
	ELSE IF @QueryType='Edit_Area'
		SELECT * FROM tbl_area WHERE Unique_id=@Parameter
	ELSE IF @QueryType='Groups_Users'
		SELECT * FROM tbl_SMS_Group WHERE CompanyCode=@Parameter1 AND PlantCode=@Parameter and Line_code=@Parameter2
	ELSE IF @QueryType='Edit_UserGroup'
		BEGIN
			SELECT * FROM tbl_SMS_Group WHERE GroupID=@Parameter AND CompanyCode=@Parameter1
			SELECT * FROM tbl_SMS_GroupPermission WHERE GroupID=@Parameter AND CompanyCode=@Parameter1
		END
	Else IF @QueryType='Alert_details'
		Begin
			--Select * from tbl_alert_settings where CompanyCode=@Parameter1 AND PlantCode=@Parameter and Line_code=@Parameter2
			SELECT [alertID],[Machine_Code],[Alert_Name],[P1_Variable],[P1_PG],[P1_Param],
			[P2_Variable],[P2_PG],[P2_Param],[Expression],[Constant],[DurationForAlert],[Group_id],[MessageText]
			,[CompanyCode],[PlantCode],[Line_Code],[Remarks],[DurationForRepetetion]
			,unique_id  
			FROM [dbo].[tbl_alert_settings]
			where CompanyCode=@Parameter1 AND PlantCode=@Parameter and Line_code=@Parameter2
		END
	Else IF @QueryType='Edit_alert'
		Begin
			--Select * from tbl_alert_settings where unique_id=@Parameter
			SELECT a.[Machine_Code],a.[Alert_Name],a.[P1_Variable],a.[P1_PG],a.[P1_Param],a.[P2_Variable],a.[P2_PG],a.[P2_Param]
				  ,a.[Expression],a.[Constant],a.[DurationForAlert],b.[Groupid1],b.[Groupid2],b.[Groupid3],a.[MessageText],
				  a.[CompanyCode],a.[PlantCode],a.[Line_Code],a.[Remarks],a.[DurationForRepetetion],a.[alertID] ,a.[unique_id]
			FROM [dbo].[tbl_alert_settings] a
			join [dbo].[tbl_GroupEscalation] b on a.[alertID]=b.[AlertID] 
			where a.unique_id=@Parameter
		END

		---Update the below code in to SP_GetSettings_data Procedure
	Else If @QueryType='Alert_details_webservice'
	BEGIN
		SELECT a.AlertID,a.Group_id,a.DurationForRepetetion,b.P_Values as 'val1',a.Constant as 'val2',a.Alert_Name,
		a.Expression,a.DurationForAlert,a.MessageText,a.CompanyCode,a.PlantCode,a.Line_Code,a.Machine_Code,b.StartTime,c.[AssetName]
		FROM tbl_alert_settings as a inner join tbl_Live_Values_Alert as b on a.AlertID=b.AlertID
		join [tbl_Assets] c on a.Machine_Code=c.[AssetID] and a.CompanyCode=c.CompanyCode and a.PlantCode=c.PlantCode and a.Line_Code=c.[FunctionName]
	END

	Else If @QueryType='Diagnostic_details' 
	BEGIN
		SELECT [Unique_ID] ,[Device_ID] as DeviceID,[Device_Ref] as DeviceRef,[Part_Number] as partnumber
      ,[IO_Server] as ioserver,[Mac_Address] as macaddress,[Connecetd_to] as connectedto
      ,[Intsalled] as installed,[Remarks] as remarks,[make] as make,
	  [gateway]=(case when [gateway]=1 then 'Yes' else 'No' end) 
		FROM [dbo].[Diagnostics_Settings] 
		where CompanyCode=@Parameter1 AND PlantCode=@Parameter and LineCode=@Parameter2
	END

	Else If @QueryType='Edit_diagnostics_details' 
	BEGIN
		SELECT [Unique_ID] ,[Device_ID] as DeviceID,[Device_Ref] as DeviceRef,[Part_Number] as partnumber
      ,[IO_Server] as ioserver,[Mac_Address] as macaddress,[Connecetd_to] as connectedto
      ,[Intsalled] as installed,[Remarks] as remarks,[make] as make,[gateway] as gateway
		FROM [dbo].[Diagnostics_Settings] 
		where [Unique_ID]=@Parameter
	END

	ELSE IF @QueryType='Edit_MISGroup'
		BEGIN
		SELECT * FROM tbl_MIS_Group WHERE GroupID=@Parameter AND CompanyCode = @Parameter1 and Line_Code=@Parameter2
		SELECT * FROM tbl_MIS_GroupPermission WHERE GroupID=@Parameter AND CompanyCode = @Parameter1 and Line_Code=@Parameter2
		END

	ELSE IF @QueryType='Get_MISGroup'
		SELECT * FROM tbl_MIS_Group WHERE CompanyCode=@Parameter1 AND PlantCode = @Parameter and Line_Code=@Parameter2

	ELSE IF @QueryType='Get_MISReport'
		SELECT a.[Unique_id],a.[GroupID],a.[ReportID],a.[Shift1],a.[Shift2],a.[Shift3],a.[Days]
        ,a.[CompanyCode],a.[PlantCode],a.[line_code],b.groupname
		FROM [dbo].[tbl_MISReports] a join [tbl_MIS_Group] b on a.[GroupID]=b.[GroupID] 
		WHERE a.CompanyCode=@Parameter1 AND a.PlantCode = @Parameter and a.Line_Code=@Parameter2

	ELSE IF @QueryType='Edit_ReportGroup'
		BEGIN
		SELECT * FROM tbl_MISReports WHERE ReportID=@Parameter AND CompanyCode = @Parameter1 and Line_Code=@Parameter2
		SELECT * FROM tbl_MISReport_Permission WHERE ReportID=@Parameter AND CompanyCode = @Parameter1 and Line_Code=@Parameter2
		END

	ELSE IF @QueryType='Get_Reports'
		SELECT * FROM tbl_MIS_Report_list WHERE CompanyCode=@Parameter1 AND PlantCode=@Parameter and Line_Code=@Parameter2

	ELSE IF @QueryType='Delete_MISGroup'
		BEGIN
		DELETE FROM tbl_MIS_Group WHERE GroupID=@Parameter
		DELETE FROM tbl_MIS_GroupPermission WHERE GroupID=@Parameter
		END

	ELSE IF @QueryType='Delete_ReportGroup'
		BEGIN
		DELETE FROM tbl_MISReports WHERE ReportID=@Parameter
		DELETE FROM tbl_MISReport_Permission WHERE ReportID=@Parameter
		END
	Else If @QueryType='Subassembly_details'
		BEGIN
			Select s.Unique_id as Unique_id,s.subassemblyid as Subassembly_id,s.SubassemblyName as Subassembly_name,b.AssetID as MachineCode from tbl_subassembly A INNER JOIN tbl_Assets AS B ON A.Plantcode=B.ParentPlant
		and A.CompanyCode=B.CompanyCode and A.ParentPlant=B.Plantcode and B.Functionname=A.ParentLine WHERE A.CompanyCode=@Parameter1 AND A.ParentPlant=@Parameter and A.ParentLine=@Parameter2
		END
ELSE IF @QueryType='LineRole_details'
		SELECT * FROM tbl_Line_Role WHERE CompanyCode=@Parameter1 
		ELSE IF @QueryType='Edit_line_role'
	BEGIN
		SELECT * FROM tbl_Line_Role WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
		SELECT * FROM tbl_line_Permission WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
	END


	ELSE IF @QueryType='Get_QReason'
		SELECT a.Unique_id,a.Reason,b.AssetName as 'Machine' FROM tbl_Quality_Reason_Setting as a inner join tbl_Assets as b on a.Machine=b.AssetID
		WHERE a.CompanyCode=@Parameter AND a.PlantCode=@Parameter1 AND b.CompanyCode=@Parameter AND b.PlantCode=@Parameter1
		ELSE IF @QueryType='Edit_QReson'
		SELECT * FROM tbl_Quality_Reason_Setting WHERE Unique_id=@Parameter
		ELSE IF @QueryType='Delete_QReson'
		DELETE FROM tbl_Quality_Reason_Setting WHERE Unique_id=@Parameter
		ELSE IF @QueryType='Get_machine'
		SELECT * FROM tbl_Assets where CompanyCode=@Parameter AND PlantCode=@Parameter1 and FunctionName=@Parameter2
		ELSE IF @QueryType='Get_Operators'
		SELECT * FROM tbl_Operator WHERE AssetName=@Parameter AND CompanyCode=@Parameter1 AND PlantCode=@Parameter2
		ELSE IF @QueryType='Get_Variants'
		SELECt * FROM tbl_MasterProduct WHERE Machine_Code=@Parameter AND CompanyCode=@Parameter1 AND PlantCode=@Parameter2 and line_code=@Parameter4
		ELSE IF @QueryType='Get_Reasons'
		SELECT Reject_Reason FROM tbl_Product_Reject_reason WHERE Machine_code=@Parameter AND CompanyCode=@Parameter1 AND PlantCode=@Parameter2 and Reject_Reason != '' group by Reject_Reason
		ELSE IF @QueryType='Get_Subassembly'
		--SELECT SubassemblyName FROM tbl_Product_Reject_reason WHERE Machine_code=@Parameter AND CompanyCode=@Parameter1 AND PlantCode=@Parameter2 group by SubassemblyName
		SELECT SubassemblyName FROM tbl_Subassembly WHERE CompanyCode=@Parameter1 and ParentPlant=@Parameter2 and ParentLine=@Parameter
		ELSE IF @QueryType='Get_Reports_list'
		--SELECT * FROM tbl_reports_list where Category=@Parameter --AND CompanyCode=@Parameter1 AND PlantCode=@Parameter2 
			SELECT * FROM tbl_reports_list where Category=@Parameter and Unique_id !=1 and Unique_id !=2 and Unique_id !=3 --AND CompanyCode=@Parameter1 AND PlantCode=@Parameter2 
		ELSE IF @QueryType='Get_LossCategory'
		SELECT * FROM tbl_losscategory where PlantCode=@Parameter and CompanyCode=@Parameter1  and Line_Code=@Parameter2
	ELSE IF @QueryType='Get_LossType'
		SELECT * FROM  tbl_losstype WHERE PlantCode=@Parameter and CompanyCode=@Parameter1  and Line_Code=@Parameter2
	ELSE IF @QueryType='Get_loss_details'
		SELECT * FROM LossesTable_Setting where CompanyCode=@Parameter1 and PlantCode=@Parameter and Loss_Category=@Parameter2 and(@Subassembly is null or Subassambly=@Subassembly)
	ELSE IF @QueryType='Get_subassambly'
		SELECT * FROM tbl_Subassembly WHERE CompanyCode=@Parameter1 and ParentPlant=@Parameter and ParentMachine=@Parameter2
	ELSE IF @QueryType='Loss_category'
		SELECT * FROM tbl_losscategory WHERE PlantCode=@Parameter and CompanyCode=@Parameter1  and Line_Code=@Parameter2
	ELSE IF @QueryType='Edit_Loss_category'
		SELECT * FROM tbl_losscategory WHERE ID=@Parameter 
	ELSE IF @QueryType='Loss_type'
		SELECT * FROM tbl_losstype WHERE PlantCode=@Parameter and CompanyCode=@Parameter1  and Line_Code=@Parameter2
	ELSE IF @QueryType='Edit_Loss_type'
		SELECT * FROM tbl_losstype WHERE ID=@Parameter 
	ELSE IF @QueryType='Get_cycle_time'
		IF @Parameter2 = 'All'
		BEGIN
			SELECT Movement,Type,Cycle_time FROM tbl_cycle_time WHERE CompanyCode=@Parameter1 and PlantCode=@Parameter and if_applicable='Y' group by Movement,Type,Cycle_time
		END
		ELSE
		BEGIN
			SELECT * FROM tbl_cycle_time WHERE CompanyCode=@Parameter1 and PlantCode=@Parameter and Variant=@Parameter2
		END
		
	ELSE IF @QueryType='Edit_cycle_time'
		IF @Parameter2 = 'All'
		BEGIN
			SELECT Movement,Type,Cycle_time FROM tbl_cycle_time WHERE Movement=@Parameter and Type=@Parameter1 and if_applicable='Y' group by Movement,Type,Cycle_time
		END
		ELSE
		BEGIN
			SELECT * FROM tbl_cycle_time WHERE ID=@Parameter
		END
	Else If @QueryType='Subassembly_details'
		BEGIN
			Select A.Unique_id as Unique_id,A.subassemblyid as Subassembly_id,A.SubassemblyName as Subassembly_name,b.AssetName as MachineCode from tbl_subassembly A INNER JOIN tbl_Assets AS B ON B.Plantcode=A.ParentPlant
		and A.CompanyCode=B.CompanyCode and A.ParentPlant=B.Plantcode and B.Functionname=A.ParentLine WHERE A.CompanyCode=@Parameter1 AND A.ParentPlant=@Parameter and A.ParentLine=@Parameter2
		END

	ELSE IF @QueryType='Edit_Subassembly'
		SELECT * FROM tbl_Subassembly WHERE Unique_id=@Parameter

		ELSE IF @QueryType='Get_Movement' 
		SELECT * FROM tbl_cycle_time where CompanyCode=@Parameter1 and PlantCode=@Parameter and 
		Machine=@Parameter2 and Variant=@Parameter3

		ELSE IF @QueryType='Get_User'
		SELECT UserName FROM Users WHERE UserName=@Parameter

	   ELSE IF @QueryType='LineRoles'
		SELECT * FROM tbl_Line_Role WHERE CompanyCode=@Parameter1

		ELSE IF @QueryType='Skills'
		SELECT * FROM tbl_Skill WHERE CompanyCode=@Parameter1 and Line_Code=@Parameter

	ELSE IF @QueryType='SkillsForUserSettings'
		SELECT * FROM tbl_Skill WHERE CompanyCode=@Parameter1 

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Groups_Users]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_Groups_Users]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@GroupID int=null,
	@GroupName nvarchar(150),
	@GroupDescription nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_SMS_Group where CompanyCode=@CompanyCode AND(GroupID=@GroupID OR GroupName=@GroupName) AND PlantCode=@PlantCode and Line_code=@LineCode )
		Begin
			SET @GroupID = (SELECT ISNULL(MAX(GroupID), 0) + 1 FROM tbl_SMS_Group)
			Insert Into tbl_SMS_Group(GroupID,GroupName,GroupDescription,CompanyCode,PlantCode,Line_code)
			Values(@GroupID,@GroupName,@GroupDescription,@CompanyCode,@PlantCode,@LineCode)
				set @result=Concat('Inserted',@GroupID)
		END
		Else If exists(Select * From tbl_SMS_Group where CompanyCode=@CompanyCode AND GroupID=@GroupID AND PlantCode=@PlantCode and Line_code=@LineCode)
				BEGIN
					set @result='Already GroupID'
				END
				Else 
					BEGIN
						set @result='Already GroupName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_SMS_Group where CompanyCode=@CompanyCode AND GroupName=@GroupName AND GroupID!=@GroupID AND PlantCode=@PlantCode and Line_code=@LineCode)
				BEGIN
					Update tbl_SMS_Group set GroupDescription=@GroupDescription,GroupName=@GroupName
					Where GroupID=@GroupID 
						set @result=Concat('Updated',@GroupID)
				END
			Else 
						BEGIN
							set @result='Already GroupName'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_holiday]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_holiday]
	@QueryType nvarchar(25),
	--@Unique_id int=null,
	@HolidayID nvarchar(150)=null,
	@HolidayReason nvarchar(150),
	@PlantID nvarchar(150),
	@Date date,
	@CompanyCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
		Begin
			If not exists(Select * From tbl_Holiday where (HolidayID=@HolidayID OR HolidayReason=@HolidayReason or Date=@Date) AND CompanyCode=@CompanyCode)
			Begin
				Insert Into tbl_Holiday(HolidayID,HolidayReason,PlantID,Date,CompanyCode)
				Values(@HolidayID,@HolidayReason,@PlantID,@Date,@CompanyCode)
					set @result='Inserted'	
			END
			Else If exists(Select * From tbl_Holiday where  HolidayID=@HolidayID AND CompanyCode=@CompanyCode )
				BEGIN
					set @result='Already HolidayID'
				END
				Else If exists(Select * From tbl_Holiday where Date=@Date AND CompanyCode=@CompanyCode )
				BEGIN
					set @result='Already Date Assigned'
				END
					Else 
						BEGIN
							set @result='Already HolidayReason'
						END	
		End			
	Else If @QueryType='Update'
		Begin
			If not exists(Select * From tbl_Holiday where HolidayReason=@HolidayReason and Date=@Date AND CompanyCode=@CompanyCode AND HolidayID!=@HolidayID )
				BEGIN
					Update tbl_Holiday set HolidayReason=@HolidayReason,PlantID=@PlantID,Date=@Date
					Where HolidayID=@HolidayID
						set @result='Updated'
				END
				Else If exists(Select * From tbl_Holiday where  Date=@Date AND CompanyCode=@CompanyCode )
				BEGIN
					set @result='Already Date Assigned'
				END
					Else 
								BEGIN
									set @result='Already HolidayReason'
								END
		End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_holiday_20231226]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_holiday_20231226]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@HolidayID nvarchar(150)=null,
	@HolidayReason nvarchar(150),
	@PlantID nvarchar(150),
	@Date date,
	@CompanyCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
		Begin
			If not exists(Select * From tbl_Holiday where (HolidayID=@HolidayID OR HolidayReason=@HolidayReason or Date=@Date) AND CompanyCode=@CompanyCode)
			Begin
				Insert Into tbl_Holiday(HolidayID,HolidayReason,PlantID,Date,CompanyCode)
				Values(@HolidayID,@HolidayReason,@PlantID,@Date,@CompanyCode)
					set @result='Inserted'	
			END
			Else If exists(Select * From tbl_Holiday where  HolidayID=@HolidayID AND CompanyCode=@CompanyCode )
				BEGIN
					set @result='Already HolidayID'
				END
				Else If exists(Select * From tbl_Holiday where Date=@Date AND CompanyCode=@CompanyCode )
				BEGIN
					set @result='Already Date Assigned'
				END
					Else 
						BEGIN
							set @result='Already HolidayReason'
						END	
		End			
	Else If @QueryType='Update'
		Begin
			If not exists(Select * From tbl_Holiday where HolidayReason=@HolidayReason and Date=@Date AND CompanyCode=@CompanyCode AND Unique_id!=@Unique_id )
				BEGIN
					Update tbl_Holiday set HolidayReason=@HolidayReason,PlantID=@PlantID,Date=@Date
					Where Unique_id=@Unique_id
						set @result='Updated'
				END
				Else If exists(Select * From tbl_Holiday where  Date=@Date AND CompanyCode=@CompanyCode )
				BEGIN
					set @result='Already Date Assigned'
				END
					Else 
								BEGIN
									set @result='Already HolidayReason'
								END
		End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Hourly_live]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--[SP_Hourly_live] 'S2','VFOE','M1','Teal','Hosur_unit_1'

CREATE Procedure [dbo].[SP_Hourly_live](@Shift AS Varchar(10),@Line AS VARCHAR(10),
		@Machine_code As Varchar(50),
		@CompanyCode As Nvarchar(100),
		@PlantCode NVarchar(100))
As 
DECLARE @From As DateTime,
		@To As DateTime,
		@Variant VARCHAR(50),
		@shift_id VARCHAR(50)

If(DATEPART(hour,Dateadd(HH,0,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))<>23)  

begin  

Set @From=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour, Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++':00:00.000'))  

Set @To=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour,Dateadd(HH,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++':00:00.000'))  

end  

else  

Begin  

Set @From=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour, Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++':00:00.000'))  

Set @To=(SELECT Convert(datetime,Convert(date,Dateadd(DAY,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++(Convert(Varchar,DATEPART(hour,Dateadd(HH,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++':00:00.000'))  

end 
if((select  hour from Hourly_Live where CompanyCode=@CompanyCode and PlantCode=@PlantCode and Line_Code=@Line and machine_code=@machine_code and Shift_ID=@Shift group by hour) is Null)
	begin
	insert into Hourly_Live(Shift_ID,Line_Code,Machine_code,Variant_code,Hour,Ok_Parts,Rework_Parts,NOK_Parts,
								StartTime,Lastupdate,CompanyCode,PlantCode)  
	SELECT Shift_ID,Line_Code,Machine_Code, Variant_code,DATEPART(hour,Time_Stamp) [Hour],(Max(OK_Parts)-MIN(OK_Parts)) As OK_Parts,
	(Max(Rework_Parts)-MIN(Rework_Parts)) As Rework_Parts, (Max(NOK_Parts)-MIN(NOK_Parts)) As NOK_Parts,Min(time_stamp) as StartTime,
	Max(time_stamp) as Lastupdate,CompanyCode,PlantCode FROM RAWTable(Nolock) where Time_Stamp between @From and @To and companycode=@companycode and PlantCode=@PlantCode and Line_Code=@Line and machine_code=@machine_code and machine_code=@machine_code
	GROUP BY  DATEPART(hour,Time_Stamp),Shift_ID,Line_Code,Machine_Code,Variant_code,CompanyCode,PlantCode ORDER BY Hour 
	end
else If(DATEPART(hour,Dateadd(HH,0,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))<>(select  hour from Hourly_Live where CompanyCode=@CompanyCode  and PlantCode=@PlantCode and Line_Code=@Line  and  machine_code=@machine_code  group by hour)) 
	Begin
	truncate table Hourly_Live
	--delete from Hourly_Live where CompanyCode=@CompanyCode	and PlantCode=@PlantCode and Line_Code=@Line and Machine_Code=@machine_code
	insert into Hourly_Live(Shift_ID,Line_Code,Machine_code,Variant_code,Hour,Ok_Parts,Rework_Parts,NOK_Parts,
								StartTime,Lastupdate,CompanyCode,PlantCode)  
	SELECT Shift_ID,Line_Code,Machine_Code, Variant_code,DATEPART(hour,Time_Stamp) [Hour],(Max(OK_Parts)-MIN(OK_Parts)) As OK_Parts,
	(Max(Rework_Parts)-MIN(Rework_Parts)) As Rework_Parts, (Max(NOK_Parts)-MIN(NOK_Parts)) As NOK_Parts,Min(time_stamp) as StartTime,
	Max(time_stamp) as Lastupdate,CompanyCode,PlantCode FROM RAWTable(Nolock) where Time_Stamp between @From and @To and companycode=@companycode and machine_code=@machine_code
	GROUP BY  DATEPART(hour,Time_Stamp),Shift_ID,Line_Code,Machine_Code,Variant_code,CompanyCode,PlantCode ORDER BY Hour 
	end
Else
	Begin
	
	
IF object_id('tempdb..#Hourly_Live') is Not NULL
		Drop table #Hourly_Live
		CREATE TABLE #Hourly_Live(Shift_ID varchar(50),Line_Code varchar(50),Machine_code varchar(50),Variant_code varchar(50),Hour int,Ok_Parts int,
										NOK_Parts int,Rework_Parts int,StartTime datetime,Lastupdate datetime,CompanyCode varchar(100),PlantCode varchar(100)) 

	--;With cte As
 --(Select r.Shift_id,r.Variant_Code, r.Machine_Code, r.line_code,
 --  Min(r.Time_Stamp) As MinTime,
 --  Max(r.Time_Stamp) As MaxTime,
 --  r.Companycode,r.Plantcode
 --From RAWTable r
 --Where r.Time_Stamp Between @From And @To
 --Group By r.Variant_Code,r.line_code, r.Machine_Code,r.Shift_id,r.Companycode,r.Plantcode)

 ; With MyCTE as (
select Shift_id,Machine_code,Line_code,Companycode,Plantcode,
Time_Stamp, Variant_code
, MyGroup = ROW_NUMBER() OVER (ORDER BY Time_Stamp) - ROW_NUMBER() OVER (PARTITION BY Variant_code,CompanyCode ORDER BY Time_Stamp)
from RAWTable(Nolock) where Time_Stamp between @From and @To and companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line
),
 CTE as (
select Shift_id,Machine_code,Line_code,Companycode,Plantcode,Variant_code, MinTime = MIN(Time_Stamp), MaxTime = MAX(Time_Stamp)
FROM MyCTE
GROUP BY MyGroup, Variant_code,Shift_id,Machine_code,Line_code,Companycode,Plantcode
--ORDER BY MIN(Timestamp)
)

   	--select * from #Hourly_Live
	insert into #Hourly_Live   
	Select c.Shift_id,c.Line_code,c.Machine_code,c.Variant_Code,DATEPART(hour,MinRow.Time_Stamp) [Hour], 
	MaxRow.OK_Parts - MinRow.OK_Parts As OK_Parts,
    MaxRow.NOK_Parts - MinRow.NOK_Parts As NOK_Parts,
    MaxRow.Rework_Parts - MinRow.Rework_Parts As Rework_Parts,
	MinRow.Time_Stamp As StartTime, MaxRow.Time_Stamp As EndTime,    
	c.Companycode,c.Plantcode
 From cte c
 Cross Apply (Select r1.Time_Stamp, r1.OK_Parts, r1.NOK_Parts, r1.Rework_Parts From RAWTable(Nolock) r1 
    Where c.Variant_Code = r1.Variant_Code And c.Machine_Code = r1.Machine_Code and c.Line_code=r1.line_code and c.companycode=r1.companycode and c.Plantcode=r1.Plantcode and c.shift_id=r1.shift_id And c.MinTime = r1.Time_Stamp) MinRow
 Cross Apply (Select r2.Time_Stamp, r2.OK_Parts, r2.NOK_Parts, r2.Rework_Parts From RAWTable(Nolock) r2 
    Where c.Variant_Code = r2.Variant_Code And c.Machine_Code = r2.Machine_Code and c.Line_code=r2.line_code and c.companycode=r2.companycode and c.Plantcode=r2.Plantcode and c.shift_id=r2.shift_id And c.MaxTime = r2.Time_Stamp) MaxRow order by StartTime
	
	If((select top 1 shift_id from Hourly_Live where companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line order by starttime desc)=(select top 1 shift_id  from #Hourly_Live where companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line order by starttime desc))
	Begin
	If((select top 1 Variant_code from Hourly_Live where companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line order by starttime desc)=(select top 1 Variant_code from #Hourly_Live where companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line order by starttime desc))
		begin
		set @Variant=(select top 1 Variant_code from Hourly_Live where companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line order by starttime desc)
		Set @shift_id=(select top 1 shift_id from Hourly_Live where companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line order by starttime desc)
		select * into #temp from #Hourly_Live where  companycode=@companycode and machine_code=@machine_code and Variant_code=@Variant and Plantcode=@PlantCode and Line_code=@line and shift_id=@shift_id
		and starttime=(select max(starttime) from Hourly_Live where companycode=@companycode and machine_code=@machine_code and Plantcode=@PlantCode and Line_code=@line)
		Update Hourly_Live set Shift_id=t.Shift_id,Ok_Parts=t.Ok_Parts,Nok_Parts=t.Nok_Parts,Rework_parts=t.Rework_parts,lastupdate=t.lastupdate
		from   #temp t where Hourly_Live.companycode=t.companycode and Hourly_Live.machine_code=t.machine_code and Hourly_Live.Plantcode=t.PlantCode and Hourly_Live.Line_code=t.Line_code and Hourly_Live.Variant_code=t.Variant_code and Hourly_Live.Shift_id=t.shift_id
	
		end
	Else 
		Begin
		insert into Hourly_Live select top 1 * from #Hourly_Live order by starttime desc
		end
	End
	Else
		Begin
		insert into Hourly_Live select top 1 * from #Hourly_Live order by starttime desc
		End

	End
GO
/****** Object:  StoredProcedure [dbo].[SP_Hourly_live_Summary]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[SP_Hourly_live_Summary] 
@CompanyCode as NVarchar(100),
@PlantCode NVarchar(100),
@line as varchar(50),
@MachineCode as varchar(50),
@Fromdate datetime, 
@Todate Datetime
As

Begin
--Declare @Fromdate datetime, @Todate Datetime
--If(DATEPART(hour,Dateadd(HH,0,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))<>23)
--begin
--Set @Fromdate=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour, Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++':00:00.000'))
--Set @Todate=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour,Dateadd(HH,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++':00:00.000'))
--end
--else
--Begin
--Set @Fromdate=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour, Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++':00:00.000'))
--Set @Todate=(SELECT Convert(datetime,Convert(date,Dateadd(DAY,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++(Convert(Varchar,DATEPART(hour,Dateadd(HH,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++':00:00.000'))
--end


IF OBJECT_ID('tempdb..#losstime') IS NOT NULL    
    DROP TABLE #losstime;
IF OBJECT_ID('tempdb..#losstime_temp') IS NOT NULL    
    DROP TABLE #losstime_temp;
Create table #losstime(Timestamp datetime,Variant_code Varchar(50),Machine_Code Varchar(50),Line_Code Varchar(50),CompanyCode NVarchar(100),PlantCode NVarchar(100),Loss int)
Create table #losstime_temp(Timestamp datetime,Variant_code Varchar(50),Machine_Code Varchar(50),Line_Code Varchar(50),CompanyCode NVarchar(100),PlantCode NVarchar(100),Loss int)
insert into #Losstime_temp(Timestamp,Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,Loss) 
select Time_Stamp,Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,Automoderunning = CASE Auto_Mode_Running 
WHEN '1' THEN 
DATEDIFF(SECOND,Time_Stamp,LEAD(Time_Stamp,1) over (PARTITION BY Machine_Code,Variant_code order by Time_stamp ))

else
0
end  FROM RAWTable(Nolock) where Machine_Status=3 and Time_Stamp between @FromDate and @ToDate and Machine_Code=@MachineCode and Line_Code=@line and CompanyCode=@CompanyCode and PlantCode=@PlantCode


If ((select count(*) from #losstime_temp)>0)
insert into #Losstime(Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,Loss) select Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,Loss from #Losstime_temp
else 
insert into #Losstime(Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,Loss) select Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,0 from RAWTable(nolock) 
where Time_Stamp between @FromDate and @ToDate and Machine_Code=@MachineCode and Line_Code=@line and CompanyCode=@CompanyCode and PlantCode=@PlantCode 
group by Machine_Code,Line_Code,CompanyCode,PlantCode,Variant_code

IF OBJECT_ID('tempdb..#ShiftWise_Availability') IS NOT NULL    
    DROP TABLE #ShiftWise_Availability;
	Create table #ShiftWise_Availability(Variant_code Varchar(50),Line_Code varchar(10),Machine_Code varchar(10),CompanyCode NVarchar(100),PlantCode NVarchar(100),Machine_Status varchar(30),
	Availability decimal,UpTime decimal,DownTime decimal,LossTime decimal,TotalProductionTime int,lastupdate datetime,Date date);

With uptime(Timestamp,Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,Up)as (select Time_Stamp,Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,Automoderunning = CASE Auto_Mode_Running 
WHEN '1' THEN 
DATEDIFF(SECOND,Time_Stamp,LEAD(Time_Stamp,1) over (PARTITION BY Machine_Code,Variant_code order by Time_stamp ))

else
0
end  FROM RAWTable(Nolock) where Time_Stamp between @FromDate and @ToDate and Machine_Code=@MachineCode and Line_Code=@line and CompanyCode=@CompanyCode and PlantCode=@PlantCode),

--Storing total Uptime into Tempup CTE tabe
tempup(Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,up) as (select Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,sum(Up)/60 as UpTime from uptime group by Variant_code,Machine_Code,CompanyCode,PlantCode,Line_Code),


--Storing total Uptime into Tempup CTE tabe
templosstime(Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,loss) as (select Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,sum(loss)/60 as lossTime from #losstime group by Variant_code,Machine_Code,CompanyCode,PlantCode,Line_Code),


--Here Collecting the Downtime based on the Auto_Mode_Running
Downtime(Timestamp,Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,down)as (select Time_Stamp,Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode, Automoderunning = CASE Auto_Mode_Running 
WHEN '0' THEN 
DATEDIFF(SECOND,Time_Stamp,LEAD(Time_Stamp,1) over (PARTITION BY Machine_Code,Variant_code order by Time_stamp ))

else
0
end  FROM RAWTable(Nolock) where Time_Stamp between @FromDate and @ToDate and Machine_Code=@MachineCode and Line_Code=@line and CompanyCode=@CompanyCode and PlantCode=@PlantCode),
--Storing total Downtime into Tempup CTE tabe
tempdown(Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,down) as (select Variant_code,Machine_Code,Line_Code,CompanyCode,PlantCode,sum(down)/60 as DownTime from downtime group by CompanyCode,PlantCode,Machine_Code,Variant_code,Line_Code),


Shifttime(totalStime,CompanyCode,PlantCode) as (select DATEDIFF(MINUTE,@FromDate,@ToDate),CompanyCode,PlantCode from ShiftSetting where CompanyCode=@CompanyCode and PlantCode=@PlantCode group by CompanyCode,PlantCode),


--Machine status 
temp(Variant_code,machine_code,Machine_status,CompanyCode,PlantCode,Lastupdate) as (select Variant_code,Machine_Code,Machine_status,CompanyCode,PlantCode,max(time_stamp) from RAWTable(Nolock) where Time_Stamp between @FromDate
and @ToDate and Machine_Code=@MachineCode and Line_Code=@line and CompanyCode=@CompanyCode and PlantCode=@PlantCode  group by Variant_code,Machine_Code,CompanyCode,PlantCode,Machine_Status),

status(Variant_code,machine_code,machine_status,CompanyCode,PlantCode,lastupdate) as (Select * from temp where lastupdate in (select max(lastupdate) from temp group by machine_code,Variant_code))

--Inserting the data into Live_Availability table
Insert into #ShiftWise_Availability(Variant_code,Line_Code,Machine_Code,Machine_status,UpTime,DownTime,LossTime,TotalProductiontime,Availability,lastupdate,date,CompanyCode,PlantCode)
select u.Variant_code,u.Line_Code,u.Machine_Code,s.machine_status,up as Uptime,down as Downtime,loss as lossTime,st.totalStime TotalProductionTime,
case when up=0 then 0 else up*100/(totalStime) end Availability,s.lastupdate,convert(date,s.lastupdate),s.CompanyCode,s.PlantCode from status s,shifttime st,tempup u,tempdown d,templosstime 
where s.machine_code=u.Machine_Code and s.machine_code=d.Machine_Code and templosstime.machine_code=d.Machine_Code and s.CompanyCode=st.CompanyCode
and s.PlantCode=st.PlantCode and s.Variant_code=u.Variant_code and s.Variant_code=d.Variant_code and s.Variant_code=templosstime.Variant_code

end 
/* Part-1 Availability Calculation Part End */

/* Part-2 Quality,Performance and OEE Calculation Part Satrt */
Begin

IF OBJECT_ID('tempdb..#temp') IS NOT NULL     
    DROP TABLE #temp;
	Create table #temp(Line_Code Varchar(50),Machine_Code Varchar(50),Variant_Code Varchar(50),OK_Parts INT,NOK_Parts INT,Rework_Parts INT,Time_stamp datetime,CompanyCode NVarchar(100),PlantCode NVarchar(100))
Insert into #temp select Line_Code,Machine_Code,Variant_Code,Sum(OK_Parts) as OK_Parts,sum(NOK_Parts) as NOK_Parts,Sum(Rework_Parts) as Rework_Parts,max(Lastupdate) Time_stamp,CompanyCode,PlantCode from hourly_live
where Machine_Code=@MachineCode and Line_Code=@line and CompanyCode=@CompanyCode and PlantCode=@PlantCode
group by Line_Code,Machine_Code,Variant_Code,CompanyCode,PlantCode
--With Variant(CompanyCode,PlantCode,V_code,Datetime)as (Select CompanyCode,PlantCode,Variant_Code,max(Time_Stamp) from RAWTable(Nolock) 
--where Time_Stamp between @FromDate and @ToDate  group by CompanyCode,PlantCode,Variant_Code)
--select Line_Code,Machine_Code,r.Variant_Code,OK_Parts,NOK_Parts,Rework_Parts,Time_Stamp,r.CompanyCode,r.PlantCode into #temp from RAWTable(Nolock) r inner join Variant v
--on v.V_code=r.Variant_Code and r.CompanyCode=v.CompanyCode and r.PlantCode=v.PlantCode and r.Time_Stamp=v.Datetime 

--select top 6 * from rawtable(nolock) where companycode='Teal'order by time_stamp desc

IF OBJECT_ID('tempdb..#Perf') IS NOT NULL    
    DROP TABLE #Perf;
	create table #Perf(Variant_Code Varchar(50),Machine_Code Varchar(20),CycleTime decimal,CompanyCode NVarchar(100),PlantCode NVarchar(100))

insert into #Perf select t.Variant_Code,t.Machine_Code,(OK_Parts+NOK_Parts+Rework_Parts)*CycleTime/60 as totalCycleTime,t.CompanyCode,t.PlantCode from #temp t 
inner join tbl_MasterProduct p on t.Variant_Code=p.Variant_Code and t.Machine_Code=p.Machine_code and t.CompanyCode=p.CompanyCode and t.PlantCode=p.PlantCode

;With Avail(Variant_Code,Machine_code,UpTime,Availability,date,lastupdate,CompanyCode,PlantCode) as (select Variant_Code,Machine_code,UpTime,Availability,convert(date,date),lastupdate,CompanyCode,PlantCode from #ShiftWise_Availability where Date=Convert(date,@FromDate)),

perf(Variant_Code,Machine_code,CompanyCode,PlantCode,Performance) as (select p.Variant_Code,p.Machine_code,p.CompanyCode,p.PlantCode,sum(CycleTime)/a.UpTime*100 as Performance  
from #Perf p inner join Avail a on a.Machine_code=p.Machine_code and a.CompanyCode=p.CompanyCode and a.PlantCode=p.PlantCode and a.Variant_Code=p.Variant_Code group by p.Variant_Code,p.Machine_Code,p.CompanyCode,p.PlantCode,UpTime),

Quality(Variant_Code,Line_code,Machine_code,CompanyCode,PlantCode,Quality) as (Select Variant_Code,Line_Code, Machine_code,CompanyCode,PlantCode,
Case when(sum(OK_Parts)+sum(Rework_Parts))=0 then 0 else (sum(OK_Parts)+sum(Rework_Parts))*100/(sum(OK_Parts)+Sum(NOK_Parts)+sum(Rework_Parts)) end Quality from #temp 
group by Machine_Code,Variant_Code,Line_Code,CompanyCode,PlantCode)


--Avail(Machine_code,Availability,date,lastupdate) as (select Machine_code,Availability,convert(date,date),lastupdate from #ShiftWise_Availability where Date=Convert(date,@FromDate))
--insert into tbl_Live_OEE(Line_Code,Machine_Code,CompanyCode,PlantCode,Quality,Performance,Availability,OEE,lastupdate)
select q.Variant_Code,q.Line_Code,q.Machine_code,q.CompanyCode,q.PlantCode,t.OK_Parts,t.NOK_Parts,t.Rework_Parts,Quality,Convert(decimal(10,2),Performance) as Performance,a.Availability,
Convert(decimal(10,2),(Quality*Performance*Availability)/10000) as OEE,a.lastupdate
from ((Quality q inner join Perf p on q.Machine_Code=p.Machine_Code and q.Variant_Code=p.Variant_Code and q.CompanyCode=p.CompanyCode and q.PlantCode=p.PlantCode) inner join Avail a on a.Machine_code=q.Machine_code) 
inner join #temp t on t.Machine_code=q.Machine_code  and t.Variant_Code=q.Variant_Code

end
--Delete the data
--delete from  tbl_Live_OEE WHERE lastupdate NOT IN (SELECT TOP 1 lastupdate FROM tbl_Live_OEE order by lastupdate desc)
/* Part-2 Quality,Performance and OEE Calculation Part End */
GO
/****** Object:  StoredProcedure [dbo].[SP_Hourly_Production_Report]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SP_Hourly_Production_Report]  ---It should be run very day morning 
@CompanyCode as Nvarchar(100),
@PlantCode NVarchar(100),
@linecode as varchar(50),
@machinecode as nvarchar(50),
@date  as varchar(50),
@flag as varchar(50)

As
Begin
     if @flag='hourly'
	 begin
		IF OBJECT_ID('tempdb..#temp') IS NOT NULL

		Drop table #temp

		Create table #temp(Date varchar(50),Line_code Varchar(50),Mcahine_code Varchar(50),Variant_code Varchar(50),Parts_Category Varchar(50),HR1 decimal(10,0),

		HR2 decimal(10,0),HR3 decimal(10,0),HR4 decimal(10,0),HR5 decimal(10,0),HR6 decimal(10,0),HR7 decimal(10,0),HR8 decimal(10,0),HR9 decimal(10,0),HR10 decimal(10,0),HR11 decimal(10,0),HR12 decimal(10,0),HR13 decimal(10,0),HR14 decimal(10,0),HR15 decimal(10,0),HR16 decimal(10,0),

		HR17 decimal(10,0),HR18 decimal(10,0),HR19 decimal(10,0),HR20 decimal(10,0),HR21 decimal(10,0),HR22 decimal(10,0),HR23 decimal(10,0),HR24 decimal(10,0),CompanyCode NVarchar(100),PlantCode NVarchar(100))


		Insert into #temp(Date,Line_code,Mcahine_code,Variant_code,Parts_Category,CompanyCode,PlantCode,HR1,HR2,HR3,HR4,HR5,HR6,HR7,HR8,HR9,HR10,HR11,HR12

		,HR13,HR14,HR15,HR16,HR17,HR18,HR19,HR20,HR21,HR22,HR23,HR24)

		Select * from(
		Select Date,Hour,Ok_Parts,Line_code,Machine_code,Variant_code,'OK_Parts' as OK,CompanyCode,PlantCode from tbl_HourlyTracker
		 where date like @date+'%%'  and line_code=@linecode and PlantCode=@PlantCode and CompanyCode=@CompanyCode and Machine_code=@machinecode
		) src
		pivot
		(
		  Sum(Ok_Parts)
		  for Hour in ([0], [1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11], [12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
		) piv;

		Insert into #temp(Date,Line_code,Mcahine_code,Variant_code,Parts_Category,CompanyCode,PlantCode,HR1,HR2,HR3,HR4,HR5,HR6,HR7,HR8,HR9,HR10,HR11,HR12

		,HR13,HR14,HR15,HR16,HR17,HR18,HR19,HR20,HR21,HR22,HR23,HR24)

		Select * from(
		Select Date,Hour,NOk_Parts,Line_code,Machine_code,Variant_code,'NOk_Parts' as NOK,CompanyCode,PlantCode from tbl_HourlyTracker
		 where date like @date+'%%'  and line_code=@linecode and PlantCode=@PlantCode and CompanyCode=@CompanyCode and Machine_code=@machinecode
		) src
		pivot
		(
		  Sum(NOk_Parts)
		  for Hour in ([0], [1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11], [12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
		) piv;


		Insert into #temp(Date,Line_code,Mcahine_code,Variant_code,Parts_Category,CompanyCode,PlantCode,HR1,HR2,HR3,HR4,HR5,HR6,HR7,HR8,HR9,HR10,HR11,HR12
		,HR13,HR14,HR15,HR16,HR17,HR18,HR19,HR20,HR21,HR22,HR23,HR24)

		 Select * from(
		 Select Date,Hour,Rework_Parts,Line_code,Machine_code,Variant_code,'Rework_Parts' as 'Rework',CompanyCode,PlantCode from tbl_HourlyTracker
		 where Date like @date+'%%'  and line_code=@linecode and PlantCode=@PlantCode and CompanyCode=@CompanyCode and Machine_code=@machinecode
		) src
		pivot
		(
		  Sum(Rework_Parts)
		  for Hour in ([0], [1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11], [12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
		 ) piv;

		select Date,m.VariantName as Variant_code,
		Case when ISNULL(SUM(HR1),0) is Null then 'NA' Else ISNULL(SUM(HR1),0) END AS [7AM-8AM],
		Case when ISNULL(SUM(HR2),0) is Null then 'NA' Else ISNULL(SUM(HR2),0) END AS [8AM-9AM],
		Case when ISNULL(SUM(HR3),0) is Null then 'NA' Else ISNULL(SUM(HR3),0) END AS [9AM-10AM],
		Case when ISNULL(SUM(HR4),0) is Null then 'NA' Else ISNULL(SUM(HR4),0) END AS [10AM-11AM],
		Case when ISNULL(SUM(HR5),0) is Null then 'NA' Else ISNULL(SUM(HR5),0) END AS [11AM-12PM],
		Case when ISNULL(SUM(HR6),0) is Null then 'NA' Else ISNULL(SUM(HR6),0) END AS [12PM-1PM],
		Case when ISNULL(SUM(HR7),0) is Null then 'NA' Else ISNULL(SUM(HR7),0) END AS [1PM-2PM],
		Case when ISNULL(SUM(HR8),0) is Null then 'NA' Else ISNULL(SUM(HR8),0) END AS [2PM-3PM],
		Case when ISNULL(SUM(HR9),0) is Null then 'NA' Else ISNULL(SUM(HR9),0) END AS [3PM-4PM],
		Case when ISNULL(SUM(HR10),0) is Null then 'NA' Else ISNULL(SUM(HR10),0) END AS [4PM-5PM],
		Case when ISNULL(SUM(HR11),0) is Null then 'NA' Else ISNULL(SUM(HR11),0) END AS [5PM-6PM],
		Case when ISNULL(SUM(HR12),0) is Null then 'NA' Else ISNULL(SUM(HR12),0) END AS [6PM-7PM],
		Case when ISNULL(SUM(HR13),0) is Null then 'NA' Else ISNULL(SUM(HR13),0) END AS [7PM-8PM],
		Case when ISNULL(SUM(HR14),0) is Null then 'NA' Else ISNULL(SUM(HR14),0) END AS [8PM-9PM],
		Case when ISNULL(SUM(HR15),0) is Null then 'NA' Else ISNULL(SUM(HR15),0) END AS [9PM-10PM],
		Case when ISNULL(SUM(HR16),0) is Null then 'NA' Else ISNULL(SUM(HR16),0) END AS [10PM-11PM],
		Case when ISNULL(SUM(HR17),0) is Null then 'NA' Else ISNULL(SUM(HR17),0) END AS [11PM-12AM],
		Case when ISNULL(SUM(HR18),0) is Null then 'NA' Else ISNULL(SUM(HR18),0) END AS [12AM-1AM],
		Case when ISNULL(SUM(HR19),0) is Null then 'NA' Else ISNULL(SUM(HR19),0) END AS [1AM-2AM],
		Case when ISNULL(SUM(HR20),0) is Null then 'NA' Else ISNULL(SUM(HR20),0) END AS [2AM-3AM],
		Case when ISNULL(SUM(HR21),0) is Null then 'NA' Else ISNULL(SUM(HR21),0) END AS [3AM-4AM],
		Case when ISNULL(SUM(HR22),0) is Null then 'NA' Else ISNULL(SUM(HR22),0) END AS [4AM-5AM],
		Case when ISNULL(SUM(HR23),0) is Null then 'NA' Else ISNULL(SUM(HR23),0) END AS [5AM-6AM],
		Case when ISNULL(SUM(HR24),0) is Null then 'NA' Else ISNULL(SUM(HR24),0) END AS [6AM-7AM] 
		from #temp t 
		inner join tbl_MasterProduct m on t.Variant_code=m.Variant_Code COLLATE SQL_Latin1_General_CP1_CI_AS and t.Line_code=m.Line_Code COLLATE SQL_Latin1_General_CP1_CI_AS
		and t.Mcahine_code=m.Machine_Code COLLATE SQL_Latin1_General_CP1_CI_AS
		and t.CompanyCode=m.CompanyCode COLLATE SQL_Latin1_General_CP1_CI_AS
		and t.PlantCode=m.PlantCode COLLATE SQL_Latin1_General_CP1_CI_AS GROUP BY Date,m.VariantName,t.Variant_code
		order by Date desc,t.Variant_code
	 end
else if @flag='monthly'
begin
	IF OBJECT_ID('tempdb..#temp') IS NOT NULL

	Drop table #temp1

	Create table #temp1(Date varchar(50),Line_code Varchar(50),Mcahine_code Varchar(50),Variant_code Varchar(50),Parts_Category Varchar(50),HR1 decimal(10,0),

	HR2 decimal(10,0),HR3 decimal(10,0),HR4 decimal(10,0),HR5 decimal(10,0),HR6 decimal(10,0),HR7 decimal(10,0),HR8 decimal(10,0),HR9 decimal(10,0),HR10 decimal(10,0),HR11 decimal(10,0),HR12 decimal(10,0),HR13 decimal(10,0),HR14 decimal(10,0),HR15 decimal(10,0),HR16 decimal(10,0),

	HR17 decimal(10,0),HR18 decimal(10,0),HR19 decimal(10,0),HR20 decimal(10,0),HR21 decimal(10,0),HR22 decimal(10,0),HR23 decimal(10,0),HR24 decimal(10,0),CompanyCode NVarchar(100),PlantCode NVarchar(100))


	Insert into #temp1(Date,Line_code,Mcahine_code,Variant_code,Parts_Category,CompanyCode,PlantCode,HR1,HR2,HR3,HR4,HR5,HR6,HR7,HR8,HR9,HR10,HR11,HR12

	,HR13,HR14,HR15,HR16,HR17,HR18,HR19,HR20,HR21,HR22,HR23,HR24)

	Select * from(
	Select Date,Hour,Ok_Parts,Line_code,Machine_code,Variant_code,'OK_Parts' as OK,CompanyCode,PlantCode from tbl_HourlyTracker
	 where date like @date+'%%'  and line_code=@linecode and PlantCode=@PlantCode and CompanyCode=@CompanyCode and Machine_code=@machinecode
	) src
	pivot
	(
	  Sum(Ok_Parts)
	  for Hour in ([0], [1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11], [12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
	) piv;

	Insert into #temp1(Date,Line_code,Mcahine_code,Variant_code,Parts_Category,CompanyCode,PlantCode,HR1,HR2,HR3,HR4,HR5,HR6,HR7,HR8,HR9,HR10,HR11,HR12

	,HR13,HR14,HR15,HR16,HR17,HR18,HR19,HR20,HR21,HR22,HR23,HR24)

	Select * from(
	Select Date,Hour,NOk_Parts,Line_code,Machine_code,Variant_code,'NOk_Parts' as NOK,CompanyCode,PlantCode from tbl_HourlyTracker
	 where date like @date+'%%'  and line_code=@linecode and PlantCode=@PlantCode and CompanyCode=@CompanyCode and Machine_code=@machinecode
	) src
	pivot
	(
	  Sum(NOk_Parts)
	  for Hour in ([0], [1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11], [12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
	) piv;


	Insert into #temp1(Date,Line_code,Mcahine_code,Variant_code,Parts_Category,CompanyCode,PlantCode,HR1,HR2,HR3,HR4,HR5,HR6,HR7,HR8,HR9,HR10,HR11,HR12
	,HR13,HR14,HR15,HR16,HR17,HR18,HR19,HR20,HR21,HR22,HR23,HR24)

	 Select * from(
	 Select Date,Hour,Rework_Parts,Line_code,Machine_code,Variant_code,'Rework_Parts' as 'Rework',CompanyCode,PlantCode from tbl_HourlyTracker
	 where Date like @date+'%%'  and line_code=@linecode and PlantCode=@PlantCode and CompanyCode=@CompanyCode and Machine_code=@machinecode
	) src
	pivot
	(
	  Sum(Rework_Parts)
	  for Hour in ([0], [1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11], [12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23])
	 ) piv;

	select Date,
	Case when ISNULL(SUM(HR1),0) is Null then 'NA' Else ISNULL(SUM(HR1),0) END AS [7AM-8AM],
	Case when ISNULL(SUM(HR2),0) is Null then 'NA' Else ISNULL(SUM(HR2),0) END AS [8AM-9AM],
	Case when ISNULL(SUM(HR3),0) is Null then 'NA' Else ISNULL(SUM(HR3),0) END AS [9AM-10AM],
	Case when ISNULL(SUM(HR4),0) is Null then 'NA' Else ISNULL(SUM(HR4),0) END AS [10AM-11AM],
	Case when ISNULL(SUM(HR5),0) is Null then 'NA' Else ISNULL(SUM(HR5),0) END AS [11AM-12PM],
	Case when ISNULL(SUM(HR6),0) is Null then 'NA' Else ISNULL(SUM(HR6),0) END AS [12PM-1PM],
	Case when ISNULL(SUM(HR7),0) is Null then 'NA' Else ISNULL(SUM(HR7),0) END AS [1PM-2PM],
	Case when ISNULL(SUM(HR8),0) is Null then 'NA' Else ISNULL(SUM(HR8),0) END AS [2PM-3PM],
	Case when ISNULL(SUM(HR9),0) is Null then 'NA' Else ISNULL(SUM(HR9),0) END AS [3PM-4PM],
	Case when ISNULL(SUM(HR10),0) is Null then 'NA' Else ISNULL(SUM(HR10),0) END AS [4PM-5PM],
	Case when ISNULL(SUM(HR11),0) is Null then 'NA' Else ISNULL(SUM(HR11),0) END AS [5PM-6PM],
	Case when ISNULL(SUM(HR12),0) is Null then 'NA' Else ISNULL(SUM(HR12),0) END AS [6PM-7PM],
	Case when ISNULL(SUM(HR13),0) is Null then 'NA' Else ISNULL(SUM(HR13),0) END AS [7PM-8PM],
	Case when ISNULL(SUM(HR14),0) is Null then 'NA' Else ISNULL(SUM(HR14),0) END AS [8PM-9PM],
	Case when ISNULL(SUM(HR15),0) is Null then 'NA' Else ISNULL(SUM(HR15),0) END AS [9PM-10PM],
	Case when ISNULL(SUM(HR16),0) is Null then 'NA' Else ISNULL(SUM(HR16),0) END AS [10PM-11PM],
	Case when ISNULL(SUM(HR17),0) is Null then 'NA' Else ISNULL(SUM(HR17),0) END AS [11PM-12AM],
	Case when ISNULL(SUM(HR18),0) is Null then 'NA' Else ISNULL(SUM(HR18),0) END AS [12AM-1AM],
	Case when ISNULL(SUM(HR19),0) is Null then 'NA' Else ISNULL(SUM(HR19),0) END AS [1AM-2AM],
	Case when ISNULL(SUM(HR20),0) is Null then 'NA' Else ISNULL(SUM(HR20),0) END AS [2AM-3AM],
	Case when ISNULL(SUM(HR21),0) is Null then 'NA' Else ISNULL(SUM(HR21),0) END AS [3AM-4AM],
	Case when ISNULL(SUM(HR22),0) is Null then 'NA' Else ISNULL(SUM(HR22),0) END AS [4AM-5AM],
	Case when ISNULL(SUM(HR23),0) is Null then 'NA' Else ISNULL(SUM(HR23),0) END AS [5AM-6AM],
	Case when ISNULL(SUM(HR24),0) is Null then 'NA' Else ISNULL(SUM(HR24),0) END AS [6AM-7AM] 
	from #temp1 t 
	inner join tbl_MasterProduct m on t.Variant_code=m.Variant_Code COLLATE SQL_Latin1_General_CP1_CI_AS and t.Line_code=m.Line_Code COLLATE SQL_Latin1_General_CP1_CI_AS
	and t.Mcahine_code=m.Machine_Code COLLATE SQL_Latin1_General_CP1_CI_AS
	and t.CompanyCode=m.CompanyCode COLLATE SQL_Latin1_General_CP1_CI_AS
	and t.PlantCode=m.PlantCode COLLATE SQL_Latin1_General_CP1_CI_AS GROUP BY Date
	order by Date desc
	
end
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insert_comments]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE PROCEDURE [dbo].[SP_insert_comments]
	@QueryType nvarchar(25),
	@username nvarchar(150)=null,
	@time nvarchar(150)=null,
	@alertid nvarchar(150)=null,
	@starttime datetime=null,
	@endtime datetime=null,
	@comment nvarchar(max)=null,
	@uniqueid int=null,
	@company nvarchar(150)=null,
	@plant nvarchar(150)=null,
	@line nvarchar(max)=null,
	@machine nvarchar(max)=null,
	@group int=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
		
	If @QueryType='Comment_insert'
	Begin
		Begin
			
			insert into [tbl_Comments]([AlertID],[Comment],[CommentDateTime],[UserName],[InstanceStartTime],[InstanceEndTime],[CompanyCode],[PlantCode],[Line_Code],[Machine_Code],GroupId) 
			values(@alertid,@comment,@time,@username,@starttime,@endtime,@company,@plant,@line,@machine,@group)
				set @result='Inserted'	
		END
		
	End	
	else If @QueryType='Comment_delete'
	begin
		delete from [tbl_Comments] where [Unique_id]=@uniqueid
		set @result='deleted'
	end		
	
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insert_update_EwonDetails]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_insert_update_EwonDetails]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,
	@PlantCode nvarchar(150)=null,
	@Unique_id int=null,
	@deviceid nvarchar(max)=null,
	@deviceip nvarchar(max)=null,
	@devicename nvarchar(max)=null,
	@t2maccount nvarchar(max)=null,
	@t2musername nvarchar(max)=null,
	@t2mpassword nvarchar(max)=null,
	@t2mdeveloperid nvarchar(max)=null,
	@t2mdeviceusername nvarchar(max)=null,
	@t2mdevicepassword nvarchar(max)=null,
	@status nvarchar(max)=null,
	@ewonurl nvarchar(max)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
		
	If @QueryType='Insert'
	Begin
		If @deviceid not in(Select device_id From [dbo].[tbl_Ewon_Details] where CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode)
		Begin
			
			Insert Into [tbl_Ewon_Details](device_id,devicename,t2maccount,t2musername,t2mpassword,t2mdeveloperid,t2mdeviceusername,t2mdevicepassword,companycode,plantcode,linecode,status,deviceip,ewonurl)
			Values(@deviceid,@devicename,@t2maccount,@t2musername,@t2mpassword,@t2mdeveloperid,@t2mdeviceusername,@t2mdevicepassword,@CompanyCode,@PlantCode,@Line_code,@status,@deviceip,@ewonurl)
				set @result='Inserted'	
		END
		
		
			Else 
				BEGIN
					set @result='Already Available Ewonid'
				END	
		
	End			
	Else If @QueryType='Update'
	Begin
	  


		--If @emailid in(Select Email_ID From [tbl_Emails] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode)

			Begin
				Update [tbl_Ewon_Details] set device_id=@deviceid,devicename=@devicename,t2maccount=@t2maccount,t2musername=@t2musername,t2mpassword=@t2mpassword,
				t2mdeveloperid=@t2mdeveloperid,t2mdeviceusername=@t2mdeviceusername,t2mdevicepassword=@t2mdevicepassword,
				companycode=@CompanyCode,plantcode=@PlantCode,linecode=@Line_code,[status]=@status,deviceip=@deviceip,ewonurl=@ewonurl
				Where id=@Unique_id 
					set @result='Updated'
			end
		--Else 
		--		BEGIN
		--			set @result='Already MailID'
		--		END	
	
	End
	Else If @QueryType='Delete'
	Begin
	
		delete from [tbl_Ewon_Details] Where id=@Unique_id 
		set @result='Deleted'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insert_update_EwonDetails_20220331]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_insert_update_EwonDetails_20220331]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,
	@PlantCode nvarchar(150)=null,
	@Unique_id int=null,
	@deviceid nvarchar(max)=null,
	@deviceip nvarchar(max)=null,
	@devicename nvarchar(max)=null,
	@t2maccount nvarchar(max)=null,
	@t2musername nvarchar(max)=null,
	@t2mpassword nvarchar(max)=null,
	@t2mdeveloperid nvarchar(max)=null,
	@t2mdeviceusername nvarchar(max)=null,
	@t2mdevicepassword nvarchar(max)=null,
	@status nvarchar(max)=null,
	@ewonurl nvarchar(max)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
		
	If @QueryType='Insert'
	Begin
		If @deviceid not in(Select device_id From [dbo].[tbl_Ewon_Details] where CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode and [status]=@status)
		Begin
			
			Insert Into [tbl_Ewon_Details](device_id,devicename,t2maccount,t2musername,t2mpassword,t2mdeveloperid,t2mdeviceusername,t2mdevicepassword,companycode,plantcode,linecode,status,deviceip,ewonurl)
			Values(@deviceid,@devicename,@t2maccount,@t2musername,@t2mpassword,@t2mdeveloperid,@t2mdeviceusername,@t2mdevicepassword,@CompanyCode,@PlantCode,@Line_code,@status,@deviceip,@ewonurl)
				set @result='Inserted'	
		END
		
		
			Else 
				BEGIN
					set @result='Already Available Ewonid'
				END	
		
	End			
	Else If @QueryType='Update'
	Begin
		if not exists(select device_id From [dbo].[tbl_Ewon_Details] where  CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode and [status]=@status)
		begin
			If not exists(Select device_id From [dbo].[tbl_Ewon_Details] where CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode and [status]=@status and
				devicename=@devicename and t2maccount=@t2maccount and t2musername=@t2musername and t2mpassword=@t2mpassword and 
				t2mdeveloperid=@t2mdeveloperid and t2mdeviceusername=@t2mdeviceusername and t2mdevicepassword=@t2mdevicepassword and deviceip=@deviceip and ewonurl=@ewonurl)
			Begin
				Update [tbl_Ewon_Details] set device_id=@deviceid,devicename=@devicename,t2maccount=@t2maccount,t2musername=@t2musername,t2mpassword=@t2mpassword,
				t2mdeveloperid=@t2mdeveloperid,t2mdeviceusername=@t2mdeviceusername,t2mdevicepassword=@t2mdevicepassword,
				companycode=@CompanyCode,plantcode=@PlantCode,linecode=@Line_code,[status]=@status,deviceip=@deviceip,ewonurl=@ewonurl
				Where id=@Unique_id 
					set @result='Updated'
			end
			Else 
					BEGIN
						set @result='Already Available Ewonid'
					END	
			
		end
		Else 
					BEGIN
						set @result='Already Available Ewonid'
					END	
	
	End
	Else If @QueryType='Delete'
	Begin
	
		delete from [tbl_Ewon_Details] Where id=@Unique_id 
		set @result='Deleted'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insert_update_EwonDetails_20221119]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_insert_update_EwonDetails_20221119]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,
	@PlantCode nvarchar(150)=null,
	@Unique_id int=null,
	@deviceid nvarchar(max)=null,
	@deviceip nvarchar(max)=null,
	@devicename nvarchar(max)=null,
	@t2maccount nvarchar(max)=null,
	@t2musername nvarchar(max)=null,
	@t2mpassword nvarchar(max)=null,
	@t2mdeveloperid nvarchar(max)=null,
	@t2mdeviceusername nvarchar(max)=null,
	@t2mdevicepassword nvarchar(max)=null,
	@status nvarchar(max)=null,
	@ewonurl nvarchar(max)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
		
	If @QueryType='Insert'
	Begin
		If @deviceid not in(Select device_id From [dbo].[tbl_Ewon_Details] where CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode and [status]=@status)
		Begin
			
			Insert Into [tbl_Ewon_Details](device_id,devicename,t2maccount,t2musername,t2mpassword,t2mdeveloperid,t2mdeviceusername,t2mdevicepassword,companycode,plantcode,linecode,status,deviceip,ewonurl)
			Values(@deviceid,@devicename,@t2maccount,@t2musername,@t2mpassword,@t2mdeveloperid,@t2mdeviceusername,@t2mdevicepassword,@CompanyCode,@PlantCode,@Line_code,@status,@deviceip,@ewonurl)
				set @result='Inserted'	
		END
		
		
			Else 
				BEGIN
					set @result='Already Available Ewonid'
				END	
		
	End			
	Else If @QueryType='Update' --Update statement Modified by Rakesh
	Begin
		If exists(Select device_id From [dbo].[tbl_Ewon_Details] where CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode and [status]=@status and
				devicename=@devicename and t2maccount=@t2maccount and t2musername=@t2musername and t2mpassword=@t2mpassword and 
				t2mdeveloperid=@t2mdeveloperid and t2mdeviceusername=@t2mdeviceusername and t2mdevicepassword=@t2mdevicepassword and deviceip=@deviceip and ewonurl=@ewonurl)
			Begin
				Update [tbl_Ewon_Details] set device_id=@deviceid,devicename=@devicename,t2maccount=@t2maccount,t2musername=@t2musername,t2mpassword=@t2mpassword,
				t2mdeveloperid=@t2mdeveloperid,t2mdeviceusername=@t2mdeviceusername,t2mdevicepassword=@t2mdevicepassword,
				companycode=@CompanyCode,plantcode=@PlantCode,linecode=@Line_code,[status]=@status,deviceip=@deviceip,ewonurl=@ewonurl
				Where id=@Unique_id 
					
				set @result='Updated Successfully'
			end
		Else 
			BEGIN
				set @result='Ewonid Details Not Available'
			END	
			
			
	End
	/*
	Begin
		if not exists(select device_id From [dbo].[tbl_Ewon_Details] where  CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode and [status]=@status)
		begin
			If not exists(Select device_id From [dbo].[tbl_Ewon_Details] where CompanyCode=@CompanyCode AND linecode=@Line_code AND PlantCode=@PlantCode and [status]=@status and
				devicename=@devicename and t2maccount=@t2maccount and t2musername=@t2musername and t2mpassword=@t2mpassword and 
				t2mdeveloperid=@t2mdeveloperid and t2mdeviceusername=@t2mdeviceusername and t2mdevicepassword=@t2mdevicepassword and deviceip=@deviceip and ewonurl=@ewonurl)
			Begin
				Update [tbl_Ewon_Details] set device_id=@deviceid,devicename=@devicename,t2maccount=@t2maccount,t2musername=@t2musername,t2mpassword=@t2mpassword,
				t2mdeveloperid=@t2mdeveloperid,t2mdeviceusername=@t2mdeviceusername,t2mdevicepassword=@t2mdevicepassword,
				companycode=@CompanyCode,plantcode=@PlantCode,linecode=@Line_code,[status]=@status,deviceip=@deviceip,ewonurl=@ewonurl
				Where id=@Unique_id 
					set @result='Updated'
			end
			Else 
					BEGIN
						set @result='Already Available Ewonid'
					END	
			
		end
		Else 
					BEGIN
						set @result='Already Available Ewonid'
					END	
	
	End
	*/
	Else If @QueryType='Delete '
	Begin
	
		delete from [tbl_Ewon_Details] Where id=@Unique_id 
		set @result='Deleted Successfully'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insert_update_line_setting]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[SP_insert_update_line_setting]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@name nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@Unique_id int=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
		
	If @QueryType='Insert'
	Begin

		if exists(select [UserName] from Users where CompanyCode=@CompanyCode AND PlantCode=@PlantCode and [UserName]=@name)
			begin
				If @name not in(Select [UserName] From [dbo].[LNK_USER_Line] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode)
					Begin
			
						Insert Into [dbo].[LNK_USER_Line]([UserName],CompanyCode,PlantCode,Line_Code)
						Values(@name,@CompanyCode,@PlantCode,@Line_code)
							set @result='Inserted'	
					END
		
		
				Else 
					BEGIN
						set @result='Already MailID'
					END	
		
			end
		else
			begin
				set @result='Added MailID does not belongs to this Company'
			end

		
	End			
	Else If @QueryType='Update'
	Begin
	
		if exists(select [UserName] from Users where CompanyCode=@CompanyCode AND PlantCode=@PlantCode and [UserName]=@name)
			begin
				If @name not in(Select [UserName] From [dbo].[LNK_USER_Line] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode)
					Begin
						Update [dbo].[LNK_USER_Line] set [UserName]=@name,line_code=@Line_code
						Where Unique_id=@Unique_id 
							set @result='Updated'
					end
				Else 
					BEGIN
						set @result='Already MailID'
					END	
			end
	   else
			begin
				set @result='Added MailID does not belongs to this Company'
			end
	
	End
	Else If @QueryType='Delete'
	Begin
	
		delete from [dbo].[LNK_USER_Line] Where Unique_id=@Unique_id 
		set @result='Deleted'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insert_update_Report_Mail]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[SP_insert_update_Report_Mail]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@emailid nvarchar(150)=null,
	@name nvarchar(150)=null,
	@status nvarchar(150)=null,
	@exception nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@Unique_id int=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
		
	If @QueryType='Insert'
	Begin
		If @emailid not in(Select Email_ID From [dbo].[tbl_Emails] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode)
		Begin
			set @id=((select max(Unique_id) from [tbl_Emails])+1)
			Insert Into [tbl_Emails](Name,Email_ID,Status,exception,CompanyCode,PlantCode,line_code)
			Values(@name,@emailid,@status,@exception,@CompanyCode,@PlantCode,@Line_code)
				set @result='Inserted'	
		END
		
		
			Else 
				BEGIN
					set @result='Already MailID'
				END	
		
	End			
	Else If @QueryType='Update'
	Begin
	
		--If @emailid in(Select Email_ID From [tbl_Emails] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode)
			Begin
				Update [tbl_Emails] set Name=@name,Status=@status,line_code=@Line_code,Email_ID=@emailid,exception=@exception
				Where Unique_id=@Unique_id 
					set @result='Updated'
			end
		--Else 
		--		BEGIN
		--			set @result='Already MailID'
		--		END	
	
	End
	Else If @QueryType='Delete'
	Begin
	
		delete from [tbl_Emails] Where Unique_id=@Unique_id 
		set @result='Deleted'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_insert_update_Variable_setting]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






create PROCEDURE [dbo].[SP_insert_update_Variable_setting]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@varname nvarchar(150)=null,
	@group nvarchar(150)=null,
	@propname nvarchar(150)=null,
	--@type nvarchar(150)=null,
	--@unit nvarchar(150)=null,
	@value nvarchar(150)=null,
	--@desc nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@Unique_id int=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
		
	If @QueryType='Insert'
	Begin
		If @varname not in(Select [Variable] From [dbo].[tbl_SMS_Variable] where CompanyCode=@CompanyCode AND [Line_code]=@Line_code AND PlantCode=@PlantCode and [PropertyGroup]=@group)
		Begin
			
			Insert Into [dbo].[tbl_SMS_Variable]([Variable],[PropertyGroup],[ParameterName],[VarValue],[CompanyCode],[PlantCode],[Line_code])
			Values(@varname,@group,@propname,@value,@CompanyCode,@PlantCode,@Line_code)
				set @result='Inserted'	
		END
		
		
			Else 
				BEGIN
					set @result='Already VariableID'
				END	
		
	End			
	Else If @QueryType='Update'
	Begin
	
		If @varname not in(Select [Variable] From [dbo].[tbl_SMS_Variable] where CompanyCode=@CompanyCode AND [Line_code]=@Line_code AND PlantCode=@PlantCode and [PropertyGroup]=@group)
			Begin
				Update [dbo].[tbl_SMS_Variable] set [Variable]=@varname,[PropertyGroup]=@group,[ParameterName]=@propname,[VarValue]=@value
				Where Unique_id=@Unique_id 
					set @result='Updated'
			end
		Else 
				BEGIN
					set @result='Already VariableID'
				END	
	
	End
	Else If @QueryType='Delete'
	Begin
	
		delete from [dbo].[tbl_SMS_Variable] Where Unique_id=@Unique_id 
		set @result='Deleted'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Line_add]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_Line_add]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@name nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@Unique_id int=null 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
	If @QueryType='Details'
	Begin
		select * from [LNK_USER_Line] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode
	End	
	Else If @QueryType='edit_Details'
	Begin
		select * from [LNK_USER_Line] where Unique_id=@Unique_id 
	End		
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Line_Role_Permission]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_Line_Role_Permission]
	@QueryType nvarchar(25),
	@Line_Code nvarchar(150)=null,
	@Plant_Code nvarchar(150)=null,
	@RoleID nvarchar(150)=null,
	@Area_Code nvarchar(150)=null,
	@Dept_Code nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,

	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(SELECT * FROM tbl_Line_Permission 
                           WHERE RoleID=@RoleID AND Line_Code=@Line_Code and Plant_Code=@Plant_Code and Area_Code=@Area_Code and 
                         Dept_Code=@Dept_Code and CompanyCode=@CompanyCode )
		Begin
			--SET @RoleID = (SELECT ISNULL(MAX(RoleID), 0) FROM tbl_Role )
			--SET @RoleID = (SELECT ISNULL(MAX(RoleID), 0) + 1 FROM tbl_line_permission)
			
			Insert Into tbl_line_permission(RoleID,Line_Code,Plant_Code,Area_Code,Dept_Code,CompanyCode)
			Values(@RoleID,@Line_Code,@Plant_Code,@Area_Code,@Dept_Code,@CompanyCode)
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End		
	
	If @QueryType='Update'
	Begin
		
		Begin
		
		   
			Insert Into tbl_line_permission(RoleID,Line_Code,Plant_Code,Area_Code,Dept_Code,CompanyCode)
			Values(@RoleID,@Line_Code,@Plant_Code,@Area_Code,@Dept_Code,@CompanyCode)
				set @result='Updated'	
		END
		
	End			
	
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Line_Roles]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[SP_Line_Roles]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@RoleID int=null,
	@RoleName nvarchar(150),
	@RoleDescription nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Line_Role where CompanyCode=@CompanyCode AND RoleName=@RoleName AND PlantCode=@PlantCode )
		Begin
			SET @RoleID = (SELECT ISNULL(MAX(RoleID), 0) + 1 FROM tbl_Line_Role)
			Insert Into tbl_Line_Role(RoleID,RoleName,RoleDescription,CompanyCode,PlantCode)
			Values(@RoleID,@RoleName,@RoleDescription,@CompanyCode,@PlantCode)
				set @result=Concat('Inserted',@RoleID)	
		END
		Else If exists(Select * From tbl_Line_Role where CompanyCode=@CompanyCode AND RoleID=@RoleID AND PlantCode=@PlantCode )
				BEGIN
					set @result='Already RoleID'
				END
				Else 
					BEGIN
						set @result='Already RoleName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_Line_Role where CompanyCode=@CompanyCode AND RoleName=@RoleName AND RoleID!=@RoleID AND PlantCode=@PlantCode )
				BEGIN
					Update tbl_Line_Role set RoleDescription=@RoleDescription,RoleName=@RoleName
					Where RoleID=@RoleID 
						set @result=Concat('Updated',@RoleID)
				END
			Else 
						BEGIN
							set @result='Already RoleName'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_list_alert_comments]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [dbo].[SP_list_alert_comments]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@machine nvarchar(150),
	@alertid nvarchar(150),
	@comment nvarchar(max)=null,
	@start datetime=null,
	@Unique_id int=null,
	@Fromdate datetime=null,
	@Todate datetime=null
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
	If @QueryType='CommentDetails'
	Begin
		SELECT a.[AlertID],a.[CommentDateTime] as LastResponseDateTime,a.[Comment],a.[Unique_id],b.Alert_Name,
		  a.[UserName] as [LastResponded],a.[InstanceStartTime] as StartTime,a.[InstanceEndTime] as LastTime
		  FROM [dbo].[tbl_Comments] a join [dbo].[tbl_alert_settings] b on a.alertId=b.AlertID
		where a.[AlertID]=@alertid and a.[InstanceStartTime]=@start 
		order by [CommentDateTime] desc
		--and a.[CommentDateTime] BETWEEN Convert(datetime,@Fromdate) AND (Convert(datetime,@Todate)+1)
	End	
	If @QueryType='CommentDetails_history'
	Begin
		SELECT a.[AlertID],a.[CommentDateTime] as LastResponseDateTime,a.[Comment],a.[Unique_id],b.Alert_Name,
		  a.[UserName] as [LastResponded],a.[InstanceStartTime] as StartTime,a.[InstanceEndTime] as LastTime
		  FROM [dbo].[tbl_Comments] a join [dbo].[tbl_alert_settings] b on a.alertId=b.AlertID
		where a.[AlertID]=@alertid 
		and a.[InstanceStartTime]=@start 
		and a.[CommentDateTime] BETWEEN Convert(datetime,@Fromdate) AND (Convert(datetime,@Todate)+1)
		order by [CommentDateTime] desc
	End	
	If @QueryType='CommentDetails_All'
	Begin
		SELECT top 250 a.[AlertID],a.[CommentDateTime] as LastResponseDateTime,a.[Comment],a.[Unique_id],b.Alert_Name,
		  a.[UserName] as [LastResponded],a.[InstanceStartTime] as StartTime,a.[InstanceEndTime] as LastTime
		  FROM [dbo].[tbl_Comments] a join [dbo].[tbl_alert_settings] b on a.alertId=b.AlertID
		where a.[AlertID]=@alertid 
		and a.[CommentDateTime] BETWEEN Convert(datetime,@Fromdate) AND (Convert(datetime,@Todate)+1)
		 order by a.[InstanceStartTime] desc
	End	
		
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LossDetails]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Rakesh Ponnala>
-- Create date: <12-07-2019>
-- Description:	<Inserting the LossTime Start & End details into LossDeatils table from RawTable table>
-- =============================================
CREATE Procedure [dbo].[SP_LossDetails]
as
SET ANSI_WARNINGS OFF
Declare @FromDate as datetime,@ToDate as datetime

Set @FromDate=((select CONVERT(datetime,(convert(date,getdate()-1))))+' 07:00:00.000')	
Set @ToDate=((select CONVERT(datetime,(convert(date,getdate()))))+' 07:00:00.000')	

--Inserting DownTime Start&End 
Begin

--Insert into DowntimeDetails(Date,DowntimeStart,DownTimeEnd,DurationInSeconds)

SELECT CAST(Time_Stamp AS date) AS [Date],
CAST(MIN(Time_Stamp) AS time) AS LossTimeStart,
CAST(LossTimeEnd AS time) AS LossTimeEnd,
DATEDIFF(ss,MIN(Time_Stamp),LossTimeEnd) AS DurationInSeconds
FROM RAWTable t
OUTER APPLY
(
SELECT MIN(Time_Stamp) AS LossTimeEnd
FROM RAWTable
WHERE Time_Stamp > t.Time_Stamp
AND Auto_Mode_Running = 1
)t1
WHERE Auto_Mode_Running = 0 and Machine_Status=3 and Time_Stamp between @FromDate and @ToDate
GROUP BY CAST(Time_Stamp AS date),LossTimeEnd order by date,LossTimeStart

End
GO
/****** Object:  StoredProcedure [dbo].[SP_LossestblSettings]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_LossestblSettings]
	@QueryType nvarchar(25),
	@ID int=null,
	@Line_Code varchar(150),
	@Machine_Code nvarchar(150),
	@Loss_ID nvarchar(50)=null,
	@Loss_Description nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@Plantcode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From LossesTable_Setting where (Loss_ID=@Loss_ID OR Loss_Description=@Loss_Description) AND CompanyCode=@CompanyCode and Plantcode=@Plantcode)
		Begin
			Insert Into LossesTable_Setting(Line_Code,Machine_Code,Loss_ID,Loss_Description,CompanyCode,Plantcode)
			Values(@Line_Code,@Machine_Code,@Loss_ID,@Loss_Description,@CompanyCode,@Plantcode)
				set @result='Inserted'	
		END
		Else If exists(Select * From LossesTable_Setting where Loss_ID=@Loss_ID  AND CompanyCode=@CompanyCode and Plantcode=@Plantcode )
				BEGIN
					set @result='Already Loss_ID'
				END
				Else 
					BEGIN
						set @result='Already Loss_Description'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		
		Begin
			If not exists(Select * From LossesTable_Setting where Loss_Description=@Loss_Description AND CompanyCode=@CompanyCode and ID!=@ID  )
				BEGIN
					Update LossesTable_Setting set Line_Code=@Line_Code,Machine_Code=@Machine_Code,Loss_ID=@Loss_ID,Loss_Description=@Loss_Description
					Where ID=@ID
						set @result='Updated'
				END
			Else 
						BEGIN
							set @result='Already Loss_Description'
						END
		End
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Masterproduct]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_Masterproduct]
	@QueryType nvarchar(25),
	@M_ID int=null,
	@Variant_Code nvarchar(150)=null,
	@VariantName nvarchar(150),
	@VariantDescription nvarchar(150),
	@OperationName nvarchar(150),
	@Machine_Code nvarchar(150),
	@RecipeName nvarchar(150),
	@CycleTime nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150),
	@Cost decimal(10,2),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_MasterProduct where (Variant_Code=@Variant_Code OR VariantName=@VariantName) AND CompanyCode=@CompanyCode and PlantCode=@PlantCode and Line_Code=@LineCode)
		Begin
			Insert Into tbl_MasterProduct(Variant_Code,VariantName,VariantDescription,OperationName,Machine_Code,RecipeName,CycleTime,CompanyCode,Plantcode,Cost,Line_Code)
			Values(@Variant_Code,@VariantName,@VariantDescription,@OperationName,@Machine_Code,@RecipeName,@CycleTime,@CompanyCode,@PlantCode,@Cost,@LineCode)
				set @result='Inserted'	
		END
		Else If exists(Select * From tbl_MasterProduct where Variant_Code=@Variant_Code  AND CompanyCode=@CompanyCode and PlantCode=@PlantCode and Line_Code=@LineCode)
				BEGIN
					set @result='Already Variant_Code'
				END
				Else 
					BEGIN
						set @result='Already VariantName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_MasterProduct where VariantName=@VariantName AND CompanyCode=@CompanyCode and PlantCode=@PlantCode AND  Variant_Code!=@Variant_Code and Line_Code=@LineCode)
				BEGIN
				Update tbl_MasterProduct set VariantName=@VariantName,VariantDescription=@VariantDescription,OperationName=@OperationName,Machine_Code=@Machine_Code,RecipeName=@RecipeName,CycleTime=@CycleTime,Cost=@Cost,Line_Code=@LineCode
				Where Variant_Code=@Variant_Code AND CompanyCode=@CompanyCode and PlantCode=@PlantCode
					set @result='Updated'
				END
			Else 
						BEGIN
							set @result='Already VariantName'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_MIS_Groups_Users]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_MIS_Groups_Users]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@GroupID int=null,
	@GroupName nvarchar(150),
	@GroupDescription nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_MIS_Group where CompanyCode=@CompanyCode AND GroupName=@GroupName AND PlantCode=@PlantCode and Line_code=@LineCode )
		Begin
			SET @GroupID = (SELECT ISNULL(MAX(GroupID), 0) + 1 FROM tbl_MIS_Group)
			Insert Into tbl_MIS_Group(GroupID,GroupName,GroupDescription,CompanyCode,PlantCode,Line_code)
			Values(@GroupID,@GroupName,@GroupDescription,@CompanyCode,@PlantCode,@LineCode)
				set @result=Concat('Inserted',@GroupID)
		END
		Else If exists(Select * From tbl_MIS_Group where CompanyCode=@CompanyCode AND GroupID=@GroupID AND PlantCode=@PlantCode and Line_code=@LineCode)
				BEGIN
					set @result='Already GroupID'
				END
				Else 
					BEGIN
						set @result='Already GroupName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_MIS_Group where CompanyCode=@CompanyCode AND GroupName=@GroupName AND GroupID!=@GroupID AND PlantCode=@PlantCode and Line_code=@LineCode)
				BEGIN
					Update tbl_MIS_Group set GroupDescription=@GroupDescription,GroupName=@GroupName
					Where GroupID=@GroupID 
						set @result=Concat('Updated',@GroupID)
				END
			Else 
						BEGIN
							set @result='Already GroupName'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_MIS_Report_Permission]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MIS_Report_Permission]
	@QueryType nvarchar(25),
	@GroupID int=null,
	@ReportID int=null,
	@ReportName nvarchar(150)=null,
	@Companycode nvarchar(150),
	@Plantcode nvarchar(150),
	@LineCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_MISReport_Permission where GroupID=@GroupID AND ReportName=@ReportName and Plantcode=@Plantcode and Companycode=@Companycode  AND line_Code=@LineCode)
		Begin
			Insert into tbl_MISReport_Permission(GroupID,ReportID,ReportName,CompanyCode,PlantCode,line_code) values(@GroupID,@ReportID,@ReportName,@Companycode,@Plantcode,@LineCode)
			
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_MISReport_Permission where GroupID=@GroupID AND ReportName=@ReportName AND Plantcode=@Plantcode and Companycode=@Companycode  AND line_Code=@LineCode)
		Insert into tbl_MISReport_Permission(GroupID,ReportID,ReportName,CompanyCode,PlantCode,line_code) values(@GroupID,@ReportID,@ReportName,@Companycode,@Plantcode,@LineCode)
			
			set @result='Updated'
	End
	
	Else If @QueryType='Delete'
	Begin
--	  delete  from tbl_MISReports where ReportID=@ReportID  and Plantcode=@Plantcode and Companycode=@Companycode
	  delete  from tbl_MISReport_Permission where ReportID=@ReportID  and Plantcode=@Plantcode and Companycode=@Companycode AND line_Code=@LineCode
	  set @result='deleted'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_MIS_UserGroup_Permission]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MIS_UserGroup_Permission]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@Groupid int=null,
	@Userid nvarchar(150)=null,
	@Companycode nvarchar(150),
	@Plantcode nvarchar(150),
	@Linecode nvarchar(150)=null,
	
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_MIS_GroupPermission where GroupID=@Groupid AND Userid=@Userid and Plantcode=@Plantcode and Companycode=@Companycode AND line_Code=@LineCode)
		Begin
			Insert into tbl_MIS_GroupPermission(GroupID,UserID,CompanyCode,PlantCode,Line_code) values(@Groupid,@Userid,@Companycode,@Plantcode,@Linecode)
			
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_MIS_GroupPermission where GroupID=@Groupid AND Userid=@Userid and Plantcode=@Plantcode and Companycode=@Companycode AND line_Code=@LineCode)
		Insert into tbl_MIS_GroupPermission(GroupID,UserID,CompanyCode,PlantCode,Line_code) values(@Groupid,@Userid,@Companycode,@Plantcode,@Linecode)
			
			set @result='Updated'
	End
	
	Else If @QueryType='Delete'
	Begin
	--  delete  from tbl_MIS_Group where GroupID=@Groupid  and Plantcode=@Plantcode and Companycode=@Companycode
	  delete  from tbl_MIS_GroupPermission where GroupID=@Groupid  and Plantcode=@Plantcode and Companycode=@Companycode AND line_Code=@LineCode
	  set @result='deleted'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_new_delete_usersettings]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_new_delete_usersettings] 
	@QueryType nvarchar(150),
	@Parameter nvarchar(150)=null,
	@Parameter1 nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
   
   Declare @result nvarchar(50)
	Set @result=''

	IF @QueryType='Delete_role'
	BEGIN
		declare @count int
		set @count=(select count(UserID) from Users where RoleID=@Parameter)

		if(@count=0)
			begin
				DELETE FROM tbl_Role WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM tbl_Permission WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM LNK_ROLE_PERMISSION WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM Users WHERE RoleID=@Parameter AND CompanyCode=@Parameter1
				DELETE FROM LNK_USER_ROLE WHERE RoleID=@Parameter AND CompanyCode=@Parameter1

				set @result='deleted'
			end
		else
			begin
				set @result='failed'
			end
	END
	

	Else IF @QueryType='Delete_UserGroup'
	BEGIN
		declare @count1 int
		set @count1=(select count(UserID) from tbl_SMS_GroupPermission where GroupID=@Parameter)

		if(@count1=0)
			begin
				DELETE FROM tbl_SMS_Group WHERE GroupID=@Parameter AND CompanyCode=@Parameter1
				
				set @result='deleted'
			end
		else
			begin
				set @result='failed.Users'
			end
	END
	Else IF @QueryType='Delete_role_linepermission'
	BEGIN
		Delete from tbl_line_role where Roleid=@Parameter
		Delete from tbl_line_permission where Roleid=@Parameter
		set @result='Deleted'
	END
	
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Operation_details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Operation_details]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@OperationID nvarchar(150)=null,
	@OperationName nvarchar(150),
	@OperationDescription nvarchar(150),
	@CompanyCode nvarchar(150)=null,
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Operation where CompanyCode=@CompanyCode AND(OperationID=@OperationID OR OperationName=@OperationName) AND PlantCode=@PlantCode AND Line_Code=@LineCode)
		Begin
			Insert Into tbl_Operation(OperationID,OperationName,OperationDescription,CompanyCode,PlantCode,Line_Code)
			Values(@OperationID,@OperationName,@OperationDescription,@CompanyCode,@PlantCode,@LineCode)
				set @result='Inserted'	
		END
		Else If exists(Select * From tbl_Operation where CompanyCode=@CompanyCode AND OperationID=@OperationID  AND PlantCode=@PlantCode AND Line_Code=@LineCode)
				BEGIN
					set @result='Already OperationID'
				END
				Else 
					BEGIN
						set @result='Already OperationName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		Begin
			If not exists(Select * From tbl_Operation where CompanyCode=@CompanyCode AND OperationName=@OperationName AND Unique_id!=@Unique_id  AND PlantCode=@PlantCode AND Line_Code=@LineCode)
				BEGIN
					Update tbl_Operation set OperationName=@OperationName,OperationDescription=@OperationDescription,Line_Code=@LineCode
					Where Unique_id=@Unique_id
						set @result='Updated'
				END
			Else 
						BEGIN
							set @result='Already OperationName'
						END
		End
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Operator]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Operator]
	@QueryType nvarchar(25),
	@OP_ID int=null,
	@OperatorName nvarchar(150),
	@OperatorID varchar(150),
	@AssetName nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Operator where OperatorID=@OperatorID AND CompanyCode=@CompanyCode AND Line_Code=@LineCode)
		Begin
			Insert Into tbl_Operator(OperatorName,OperatorID,AssetName,CompanyCode,PlantCode,Line_Code)
			Values(@OPeratorName,@OperatorID,@AssetName,@CompanyCode,@PlantCode,@LineCode)
				set @result='Inserted'	
		END
		Else If exists(Select * From tbl_Operator where OperatorID=@OperatorID AND CompanyCode=@CompanyCode AND Line_Code=@LineCode)
				BEGIN
					set @result='Already OperatorID'
				END
	End			
	Else If @QueryType='Update'
	Begin
		Update tbl_Operator set OperatorName=@OperatorName,OperatorID=@OperatorID,AssetName=@AssetName,Line_Code=@LineCode
		Where OP_ID=@OP_ID
			set @result='Updated'

	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Operator_Live]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_Operator_Live]  
As  
Begin  
Declare @From datetime, @To Datetime  
If(DATEPART(hour,Dateadd(HH,0,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))=23)  
begin  
Set @From=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour, Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++':00:00.000'))  
Set @To=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour,Dateadd(HH,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++':00:00.000'))  
end  
else  
Begin  
Set @From=(SELECT Convert(datetime,Convert(date,Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++(Convert(Varchar,DATEPART(hour, Dateadd(mi,30,Dateadd(hh,5,Getdate()))))++':00:00.000'))  
Set @To=(SELECT Convert(datetime,Convert(date,Dateadd(DAY,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++(Convert(Varchar,DATEPART(hour,Dateadd(HH,1,Dateadd(mi,30,Dateadd(hh,5,Getdate())))))++':00:00.000'))  
end  

Truncate table tbl_Operator_Live  
Insert into tbl_Operator_Live  
select Machine_code,r.Line_Code,Variant_code,t.OperatorID,OperatorName,min(Time_Stamp) ,t.CompanyCode,t.PlantCode from [dbo].[tbl_Raw_Operator_Efficiency] r inner join tbl_Operator t on r.OperatorID=t.OperatorID  
where time_stamp between @From and @To group by t.OperatorID,t.CompanyCode,t.PlantCode,OperatorName,Machine_code,r.Line_Code,Variant_code  
/*
select Machine_code,Line_Code,Variant_code,t.OperatorID,OperatorName,min(Time_Stamp) as StartTime ,t.CompanyCode,t.PlantCode  into #tbl_Operator_Live from [dbo].[tbl_Raw_Operator_Efficiency] r 
inner join tbl_Operator t on r.OperatorID=t.OperatorID  
where time_stamp between @From and @To group by t.OperatorID,t.CompanyCode,t.PlantCode,OperatorName,Machine_code,Line_Code,Variant_code  

update tbl_Operator_Live set 
 Variant_code=t.Variant_code,
 OperatorID=t.OperatorID,
 OperatorName=t.OperatorName,
 StartTime=t.StartTime 
from #tbl_Operator_Live t where tbl_Operator_Live.Machine_code=t.Machine_code and tbl_Operator_Live.Line_Code=t.Line_Code and tbl_Operator_Live.CompanyCode=t.CompanyCode 
and tbl_Operator_Live.PlantCode=t.PlantCode
*/
End
GO
/****** Object:  StoredProcedure [dbo].[SP_OperatorSkill]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_OperatorSkill]
	@QueryType nvarchar(25),
	@O_ID int=null,
	@OperatorID nvarchar(150),
	@SkillName nvarchar(150),
	@ScoreValue decimal(18,0),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_OperatorSkillMatrix where OperatorID=@OperatorID AND CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode)
		Begin
			Insert Into tbl_OperatorSkillMatrix(OperatorID,SkillName,ScoreValue,CompanyCode,PlantCode,Line_Code)
			Values(@OperatorID,@SkillName,@ScoreValue,@CompanyCode,@PlantCode,@LineCode)
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End			
	Else If @QueryType='Update'
	Begin
		Update tbl_OperatorSkillMatrix set SkillName=@SkillName,ScoreValue=@ScoreValue,Line_Code=@LineCode
		Where O_ID=@O_ID
			set @result='Updated'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Plant]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Plant]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@PlantID nvarchar(150)=null,
	@PlantName nvarchar(150),
	@PlantDescription nvarchar(150),
	@PlantLocation nvarchar(150),
	@TimeZone nvarchar(150),
	@ParentOrganization nvarchar(150)=null,
	@IsActive nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Plant where (PlantID=@PlantID OR PlantName=@PlantName) AND ParentOrganization=@ParentOrganization)
		Begin
			Insert Into tbl_Plant(PlantID,PlantName,PlantDescription,PlantLocation,TimeZone,ParentOrganization,IsActive)
			Values(@PlantID,@PlantName,@PlantDescription,@PlantLocation,@TimeZone,@ParentOrganization,@IsActive)
				set @result='Inserted'	
		END
		Else If exists(Select * From tbl_Plant where PlantID=@PlantID  AND ParentOrganization=@ParentOrganization )
				BEGIN
					set @result='Already PlantID'
				END
				Else 
					BEGIN
						set @result='Already PlantName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		Begin
			If not exists(Select * From tbl_Plant where PlantName=@PlantName  AND ParentOrganization=@ParentOrganization AND Unique_id!=@Unique_id )
				BEGIN
					Update tbl_Plant set PlantName=@PlantName,PlantLocation=@PlantLocation,PlantDescription=@PlantDescription,TimeZone=@TimeZone,ParentOrganization=@ParentOrganization,
					IsActive=@IsActive Where Unique_id=@Unique_id
						set @result='Updated'
				END
			Else 
						BEGIN
							set @result='Already PlantName'
						END
		End
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Production_details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Rakesh Ponnala>
-- Create date: <26-09-2020>
-- Description:	<Fetch the CycleTime Histogram data from CycleTime table>
-- =============================================

CREATE Procedure [dbo].[SP_Production_details] 
@CompanyCode as Nvarchar(100),  
@PlantCode NVarchar(100),  
@linecode as varchar(50),
@Shift as varchar(50),
@Machinecode as varchar(50),
@Flag as varchar(50) --OkParts/Scrap
As
Begin
Declare @From as Datetime, @To as Datetime

set @From=(SELECT CONVERT(DATETIME, CONVERT(CHAR(8), Convert(date,dateadd(mi,330,getdate())), 112) 
  + ' ' + CONVERT(CHAR(8), StartTime, 108)) from shiftsetting where shiftname=@Shift and CompanyCode=@CompanyCode and PlantCode=@PlantCode and LineCode=@linecode)
Set @To=(select dateadd(mi,330,getdate()))

if object_id('temp..#Productioncount') is not Null
drop table #Productioncount
Create table #Productioncount(Count int Identity(1,1),time_stamp datetime,variant_code Varchar(50),ok_parts int,nok_parts int)
insert into #Productioncount(time_stamp,variant_code,ok_parts,nok_parts)Select time_stamp,variant_code,ok_parts,nok_parts from  cycletime where 
time_stamp between  @From and @To and Machine_code=@Machinecode and Line_code=@linecode  and CompanyCode=@CompanyCode and PlantCode=@PlantCode order by time_stamp 

If(@Flag='OKParts')
	select time_stamp,count,ok_parts as [Produced Qty] from #Productioncount where ok_parts<>0 order by time_stamp desc
Else if(@Flag='Scrap')
	select time_stamp,count,nok_parts as [Produced Qty] from #Productioncount where nok_parts<>0 order by time_stamp desc

End
GO
/****** Object:  StoredProcedure [dbo].[SP_Reject_Reasons]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================  
-- Author:  <Rakesh Ponnala>  
-- Create date: <29-09-2020>  
-- Description: <Fetch the rejection data from CycleTime table and insert into  >  
-- =============================================  
  
CREATE Procedure [dbo].[SP_Reject_Reasons]   

As  
Begin  
Declare @From Datetime,@To DateTime

Set @From= (select Convert(datetime,(convert(date,getdate()-1)))+'00:00:00.000')
Set @To= (select Convert(datetime,(convert(date,getdate())))+'00:00:00.000')
--Insert the data
insert into tbl_Product_Reject_reason(Date,Line_code,Machine_code,Shift_Id,Variant_code,Reject_Reason,Time_stamp,Companycode,Plantcode)
select convert(date,time_stamp),Line_code,Machine_code,Shift_Id,Variant_code,value as Reject_Reason,time_stamp,Companycode,Plantcode   from cycletime
cross apply STRING_SPLIT(reject_reason,',') where Time_stamp between @From and @To  and reject_reason<>'Null' and reject_reason is Not Null order by time_stamp

End
GO
/****** Object:  StoredProcedure [dbo].[SP_Rejection]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Rejection]
	@QueryType nvarchar(25),
	@R_ID int=null,
	@RejectionCode nvarchar(150),
	@RejectionName nvarchar(150),
	@RejectionDescription nvarchar(150),
	@ProductName nvarchar(150),
	@OperationName nvarchar(150),
	@AssetName nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
	if not exists(select RejectionCode from tbl_Rejection where CompanyCode=@CompanyCode and PlantCode=@PlantCode and Line_Code=@LineCode)
	begin
	Insert Into tbl_Rejection(RejectionCode,RejectionName,RejectionDescription,ProductName,OperationName,AssetName,CompanyCode,PlantCode,Line_Code)
		Values(@RejectionCode,@RejectionName,@RejectionDescription,@ProductName,@OperationName,@AssetName,@CompanyCode,@PlantCode,@LineCode)
			set @result='Inserted'	
	end
	Else
		BEGIN
			set @result='Already'
		END	
	End			
	Else If @QueryType='Update'
	Begin
		Update tbl_Rejection set RejectionCode=@RejectionCode,RejectionName=@RejectionName,RejectionDescription=@RejectionDescription,
		ProductName=@ProductName,OperationName=@OperationName,AssetName=@AssetName,Line_Code=@LineCode
		Where R_ID=@R_ID
			set @result='Updated'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Report_Mail]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_Report_Mail]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@emailid nvarchar(150)=null,
	@name nvarchar(150)=null,
	@status nvarchar(150)=null,
	@exception nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@Unique_id int=null 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
	If @QueryType='Details'
	Begin
		--select * from [tbl_Emails] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode
		SELECT [Name],[Email_ID],[Status],[Companycode],[PlantCode],[line_code],[Unique_id],
				exception=case 
				when [exception]=1 then 'Yes'
				else 'No'
				end
			  FROM [dbo].[tbl_Emails] where CompanyCode=@CompanyCode AND line_code=@Line_code AND PlantCode=@PlantCode
	End	
	Else If @QueryType='edit_Details'
	Begin
		select * from [tbl_Emails] where Unique_id=@Unique_id 
	End		
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Role_Permission]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_Role_Permission]
	@QueryType nvarchar(150),
	@Unique_id int=null,
	@Permission_id int=null,
	@RoleID nvarchar(150)=null,
	@Module_name nvarchar(150)=null,
	@View_form nvarchar(150)=null,
	@Add_form nvarchar(150)=null,
	@Edit_form nvarchar(150)=null,
	@Delete_form nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,
	@SQLReturn nvarchar(150) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(150)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Permission where RoleID=@RoleID AND Module_name=@Module_name)
		Begin
			--SET @RoleID = (SELECT ISNULL(MAX(RoleID), 0) FROM tbl_Role )
			SET @Permission_id = (SELECT ISNULL(MAX(Permission_id), 0) + 1 FROM tbl_permission)
			INSERT INTO LNK_ROLE_PERMISSION(RoleID,Permission_id,CompanyCode)VALUES(@RoleID,@Permission_id,@CompanyCode)
			Insert Into tbl_Permission(RoleID,Module_name,Edit_form,Add_form,View_form,Delete_form,Permission_id,CompanyCode)
			Values(@RoleID,@Module_name,@Edit_form,@Add_form,@View_form,@Delete_form,@Permission_id,@CompanyCode)
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End			
	Else If @QueryType='Update'
	Begin
		Update tbl_Permission set Edit_form=@Edit_form,Add_form=@Add_form,View_form=@View_form,Delete_form=@Delete_form
		Where RoleID=@RoleID AND Module_name=@Module_name
			set @result='Updated'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Role_Permission_20220223]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_Role_Permission_20220223]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@Permission_id int=null,
	@RoleID nvarchar(150)=null,
	@Module_name nvarchar(150)=null,
	@View_form nvarchar(150)=null,
	@Add_form nvarchar(150)=null,
	@Edit_form nvarchar(150)=null,
	@Delete_form nvarchar(150)=null,
	@CompanyCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Permission where RoleID=@RoleID AND Module_name=@Module_name)
		Begin
			--SET @RoleID = (SELECT ISNULL(MAX(RoleID), 0) FROM tbl_Role )
			SET @Permission_id = (SELECT ISNULL(MAX(Permission_id), 0) + 1 FROM tbl_permission)
			INSERT INTO LNK_ROLE_PERMISSION(RoleID,Permission_id,CompanyCode)VALUES(@RoleID,@Permission_id,@CompanyCode)
			Insert Into tbl_Permission(RoleID,Module_name,Edit_form,Add_form,View_form,Delete_form,Permission_id,CompanyCode)
			Values(@RoleID,@Module_name,@Edit_form,@Add_form,@View_form,@Delete_form,@Permission_id,@CompanyCode)
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End			
	Else If @QueryType='Update'
	Begin
		Update tbl_Permission set Edit_form=@Edit_form,Add_form=@Add_form,View_form=@View_form,Delete_form=@Delete_form
		Where RoleID=@RoleID AND Module_name=@Module_name
			set @result='Updated'
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Roles]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[SP_Roles]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@RoleID int=null,
	@RoleName nvarchar(150),
	@RoleDescription nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Role where CompanyCode=@CompanyCode AND RoleName=@RoleName AND PlantCode=@PlantCode and Line_code=@LineCode )
		Begin
			SET @RoleID = (SELECT ISNULL(MAX(RoleID), 0) + 1 FROM tbl_Role)
			Insert Into tbl_Role(RoleID,RoleName,RoleDescription,CompanyCode,PlantCode,Line_code)
			Values(@RoleID,@RoleName,@RoleDescription,@CompanyCode,@PlantCode,@LineCode)
				set @result=Concat('Inserted',@RoleID)	
		END
		Else If exists(Select * From tbl_Role where CompanyCode=@CompanyCode AND RoleID=@RoleID AND PlantCode=@PlantCode and Line_code=@LineCode)
				BEGIN
					set @result='Already RoleID'
				END
				Else 
					BEGIN
						set @result='Already RoleName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_Role where CompanyCode=@CompanyCode AND RoleName=@RoleName AND RoleID!=@RoleID AND PlantCode=@PlantCode and Line_code=@LineCode)
				BEGIN
					Update tbl_Role set RoleDescription=@RoleDescription,RoleName=@RoleName
					Where RoleID=@RoleID 
						set @result=Concat('Updated',@RoleID)
				END
			Else 
						BEGIN
							set @result='Already RoleName'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Settings_data]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE PROCEDURE [dbo].[SP_Settings_data] 
@Flag as nvarchar(150),
@CompanyCode nvarchar(150)=null,
@PlantCode nvarchar(150)=null,
@LineCode nvarchar(150)=null,
@MachineCode nvarchar(150)=null,
@Parameter nvarchar(150)=null
As
BEGIN
	IF @Flag = 'LineCode'
	BEGIN
		SELECT FunctionID AS 'Code',FunctionName AS 'Name' FROM tbl_Function 
		WHERE CompanyCode=@CompanyCode AND ParentPlant=@PlantCode 
	END
	else IF @Flag = 'NewLineCode'
	BEGIN
		SELECT FunctionID AS 'Code',FunctionName AS 'Name' FROM tbl_Function 
		WHERE CompanyCode=@CompanyCode AND ParentPlant=@PlantCode AND FunctionID=@LineCode 
	END
	ELSE IF @Flag='Subsystem'
	BEGIN
		SELECT AssetID AS 'Code',AssetName AS 'Name' FROM tbl_Assets 
		WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND FunctionName=@LineCode
	END
	ELSE IF @Flag='Variant'
	BEGIN
		SELECT Variant_Code AS 'Code',VariantName AS 'Name' FROM tbl_MasterProduct  
		WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode 
		AND Line_Code=@LineCode
		GROUP BY Variant_Code,VariantName
	END
	
	ELSE IF @Flag='Get_Customer'
	BEGIN
		SELECT CompanyCode AS 'Code',CompanyName AS 'Name' FROM tbl_Customer
	END
	ELSE IF @Flag='Get_Plant'
	BEGIN
		--if @Parameter='admin'
		--	SELECT PlantID AS 'Code',PlantName AS 'Name' FROM tbl_Plant WHERE ParentOrganization=@CompanyCode
		--else
		--    Begin
		--	select distinct l.plant_code as 'Code',p.plantname as 'Name' from tbl_line_permission l inner join tbl_Plant p on l.plant_code=p.plantid where l.Companycode=@CompanyCode
		--	and l.roleid=(select lineroleid from users where username=@LineCode)

		--	End
		SELECT PlantID AS 'Code',PlantName AS 'Name' FROM tbl_Plant WHERE ParentOrganization=@CompanyCode
	END
	ELSE IF @Flag='Get_Plant_Nonadmin'
	Begin
	select distinct l.plant_code as 'Code',p.plantname as 'Name' from tbl_line_permission l inner join tbl_Plant p on l.plant_code=p.plantid where l.Companycode=@CompanyCode
		and l.roleid=(select lineroleid from users where username=@LineCode)

	end

	ELSE IF @Flag='Get_Line_Login'
	BEGIN
		SELECT distinct a.FunctionID AS 'Code',a.FunctionName AS 'Name' FROM tbl_Function a
		join [LNK_USER_Line] b on a.[CompanyCode]=b.[CompanyCode] and a.ParentPlant=b.[PlantCode] 
		and a.FunctionID=b.[Line_Code]
		WHERE a.CompanyCode=@CompanyCode AND a.ParentPlant=@PlantCode and b.[UserName]=@LineCode
	END
	ELSE IF @Flag='Get_Line_Permission'
	BEGIN
		--Select l.Line_Code,Area_Code as AreaCode,Dept_Code from tbl_Line_Permission l inner join Users u on u.LineRoleID=l.roleid 
		--WHERE l.CompanyCode=@CompanyCode  and u.[UserName]=@LineCode

		Select l.Line_Code,f.functionname as Line_Name,area.area_name,dept.dept_id,dept.dept_name as Dept_Name,l.Area_Code as AreaCode,Dept_Code from tbl_Line_Permission l inner join Users u on u.LineRoleID=l.roleid inner join tbl_Function f on l.Line_code=f.functionID inner join tbl_Area area on area.area_id=l.area_code
        inner join tbl_department dept on dept.dept_id=l.dept_code WHERE l.CompanyCode=@CompanyCode  and u.[UserName]=@LineCode and l.plant_code=@PlantCode
	END
	ELSE IF @Flag='Get_Line_Permission_Admin'
	BEGIN
		Select f.Functionid as Line_Code,f.functionname as Line_Name,dept.dept_id as Dept_Code,dept.dept_name as Dept_Name,area.area_id as AreaCode,area.area_name from tbl_Function f
 inner join tbl_department dept on dept.dept_id=f.dept_id and dept.plantcode=f.parentplant
inner join tbl_Area area on area.area_id=dept.areacode and area.plantcode=dept.plantcode
WHERE f.CompanyCode=@CompanyCode   and f.parentplant=@PlantCode
	END
	ELSE IF @Flag='Get_dept'
	BEGIN
		SELECT Dept_id AS 'Code',Dept_name AS 'Name' FROM tbl_department WHERE CompanyCode=@CompanyCode and PlantCode=@PlantCode 
	END
	ELSE IF @Flag='Get_Operator'
		begin
			SELECT OperatorID AS 'Code',OperatorName AS 'Name' FROM tbl_Operator 
			WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode 
			AND Line_Code=@LineCode
		end

	ELSE IF @Flag='toollist'
		begin
			SELECT ToolID AS 'Code',ToolName AS 'Name' FROM  [dbo].[tbl_toollist]
			WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode 
			AND Line_code=@LineCode AND Machine_Code=@MachineCode
		end

	ELSE IF @Flag='toollist_dieset'
		begin
			select distinct b.ToolID AS 'Code',b.[ToolName] AS 'Name' from [dbo].[Dieset_stopandstart_Rawtable] a
			join [dbo].[tbl_toollist] b on a.[ToolID]=b.[ToolID] and a.CompanyCode=b.CompanyCode and a.PlantCode=b.PlantCode and 
			a.Line_code=b.Line_code
			WHERE a.CompanyCode=@CompanyCode AND a.PlantCode=@PlantCode order by Name
			--AND Line_code=@LineCode 
			--AND Machine_Code=@MachineCode
		end
    ELSE IF @Flag='Variablelist'
	BEGIN
		SELECT Distinct Variable AS 'Code',Variable AS 'Name' FROM tbl_SMS_Variable
		WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode and Machine_Code=@MachineCode
	END
	ELSE IF @Flag='PropertyGroup'
	BEGIN
		SELECT Distinct PropertyGroup AS 'Code',PropertyName As Name FROM tbl_SMS_Variable
		WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode and variable=@Parameter and Machine_Code=@MachineCode
	END
	ELSE IF @Flag='ParameterName'
	BEGIN
		SELECT Distinct 0 AS 'Code',ParameterName as 'Name' FROM tbl_SMS_Variable
		WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode and variable=@Parameter and Machine_Code=@MachineCode
	END
	Else IF @Flag='Group_details'
		Begin
			Select GroupID as 'Code',Groupname as 'Name' from tbl_SMS_Group  WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode
		END
	ELSE IF @Flag='Get_area'
	BEGIN
		SELECT Area_id AS 'Code',Area_name AS 'Name' FROM tbl_area WHERE CompanyCode=@CompanyCode and PlantCode=@PlantCode 
	END
	Else IF @Flag='Get_SubAssembly'
		Begin
			Select SubassemblyID as 'Code',SubassemblyName as 'Name' from tbl_Subassembly  WHERE CompanyCode=@CompanyCode AND [ParentPlant]=@PlantCode AND [ParentLine]=@LineCode and SubassemblyName != ''
		END
	ELSE IF @Flag='Operations'
		SELECT Operationid as 'Code' , OperationName as 'Name' FROM tbl_Operation WHERE CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ShiftSettings]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ShiftSettings]
	@QueryType nvarchar(25),
	@ID int=null,
	@ShiftName nvarchar(150),
	@StartTime time,
	@EndTime time,
	@BreakTime decimal(18,0),
	@CompanyCode nvarchar(150),
	@PlantCode varchar(150),
	@LineCode varchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From ShiftSetting where CompanyCode=@CompanyCode AND ShiftName=@ShiftName and PlantCode=@PlantCode and LineCode=@LineCode)
		Begin
			Insert Into ShiftSetting(ShiftName,StartTime,EndTime,BreakTime,CompanyCode,PlantCode,LineCode)
			Values(@ShiftName,@StartTime,@EndTime,@BreakTime,@CompanyCode,@PlantCode,@LineCode)
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From ShiftSetting where CompanyCode=@CompanyCode AND ShiftName=@ShiftName and PlantCode=@PlantCode and LineCode=@LineCode AND ID!=@ID )
				BEGIN
					Update ShiftSetting set StartTime=@StartTime,EndTime=@EndTime,BreakTime=@BreakTime,LineCode=@LineCode
					Where ID=@ID
						set @result='Updated'
				END
			Else 
						BEGIN
							set @result='Already'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Skills]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_Skills]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@Skill_ID nvarchar(150)=null,
	@SkillName nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150),
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_Skill where (Skill_ID=@Skill_ID OR SkillName=@SkillName) AND CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode)
		Begin
			Insert Into tbl_Skill(Skill_ID,SkillName,CompanyCode,PlantCode,Line_Code)
			Values(@Skill_ID,@SkillName,@CompanyCode,@PlantCode,@LineCode)
				set @result='Inserted'	
		END
		Else If exists(Select * From tbl_Skill where Skill_ID=@Skill_ID  AND CompanyCode=@CompanyCode AND PlantCode=@PlantCode AND Line_Code=@LineCode)
				BEGIN
					set @result='Already Skill_ID'
				END
				Else 
					BEGIN
						set @result='Already SkillName'
					END
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_Skill where SkillName=@SkillName AND CompanyCode=@CompanyCode AND Unique_id!=@Unique_id AND PlantCode=@PlantCode AND Line_Code=@LineCode)
				BEGIN
					Update tbl_Skill set SkillName=@SkillName,Line_Code=@LineCode
					Where Unique_id=@Unique_id
						set @result='Updated'
				END
			Else 
						BEGIN
							set @result='Already SkillName'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_SMS_Shift]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_SMS_Shift](@CompanyCode Varchar(100),
@PlantCode Varchar(100))
As
Begin
if((select shiftid from live where companycode=@CompanyCode and Plantcode=@PlantCode  group by shiftid)='S1')
	begin
	select ShiftID,Linecode,Variantcode,totalokparts,totalNokparts,Firstpassyeild,companycode,Plantcode from shiftwise 
	where companycode=@CompanyCode and Plantcode=@PlantCode and shiftid='s3' and date=convert(date,getdate()-1)
	select Shift_ID,Line_code,Availability,Performance,Quality,OEE,companycode,Plantcode from tbl_shiftwise_OEE 
	where companycode=@CompanyCode and Plantcode=@PlantCode and shift_id='s3' and date=convert(date,getdate()-1)
	end
else if((select shiftid from live where companycode=@CompanyCode and Plantcode=@PlantCode  group by shiftid)='S2')
	begin
	select ShiftID,Linecode,Variantcode,totalokparts,totalNokparts,Firstpassyeild,companycode,Plantcode from shiftwise 
	where companycode=@CompanyCode and Plantcode=@PlantCode  and shiftid='s1' and date=convert(date,getdate())
	select Shift_ID,Line_code,Availability,Performance,Quality,OEE,companycode,Plantcode from tbl_shiftwise_OEE 
	where companycode=@CompanyCode and Plantcode=@PlantCode and shift_id='s1' and date=convert(date,getdate())
	
	end
else if((select shiftid from live where companycode=@CompanyCode and Plantcode=@PlantCode group by shiftid)='S3')
	begin
	select ShiftID,Linecode,Variantcode,totalokparts,totalNokparts,Firstpassyeild,companycode,Plantcode from shiftwise 
	where companycode=@CompanyCode and Plantcode=@PlantCode and shiftid='s2' and date=convert(date,getdate())
	select Shift_ID,Line_code,Availability,Performance,Quality,OEE,companycode,Plantcode from tbl_shiftwise_OEE 
	where companycode=@CompanyCode and Plantcode=@PlantCode  and shift_id='s2' and date=convert(date,getdate())
	end
Else
	Print 'Non of the Shift'
End
GO
/****** Object:  StoredProcedure [dbo].[SP_stoppages_Report]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[SP_stoppages_Report]
@company AS NVARCHAR(MAX),
@plant AS NVARCHAR(MAX),
@Line AS NVARCHAR(MAX)=null,
@machine AS NVARCHAR(MAX)=null,
@date AS NVARCHAR(MAX)=null,
@Flag AS NVARCHAR(MAX)=null
As
Begin
DECLARE @cols AS NVARCHAR(MAX)
DECLARE @query  AS NVARCHAR(MAX)

IF @Flag='daily'
BEGIN
		
		select @cols = STUFF((SELECT ',' + QUOTENAME(b.Error_Category)
		from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID 
		where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND a.Date like @date+'%%'
		group by b.Error_Category
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
		,1,1,'')

		select a.Date,b.Error_Category, count(a.Alarm_ID) as "ID" into #temp
		from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID and a.machine_code=b.machine_code 
		where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND b.Machine_Code=@machine AND a.Date like @date+'%%'
		group by a.Date,b.Error_Category

		set @query = N'SELECT row_number() over(order by Date desc) as Sno,Date, '+ @cols + N' from
		(
			select * from #temp
		) x
		pivot
		(
		sum(ID)
		for Error_Category in ('+ @cols+' )
		) p '

		execute(@query);
		Drop table #temp
	END

ELSE IF @Flag='monthly'
BEGIN
		
		select @cols = STUFF((SELECT ',' + QUOTENAME(b.Error_Category)
			from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID 
			where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND a.Date like @date+'%%'
		group by b.Error_Category
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
		,1,1,'')

	select year(a.Date) as "Y",month(a.Date) as "M",b.Error_Category, count(a.Alarm_ID) as "ID" into #temp1
		from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID and a.machine_code=b.machine_code 
		where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND b.Machine_Code=@machine AND a.Date like @date+'%%'
		group by b.Error_Category,year(a.Date),month(a.Date) 

		set @query = N'SELECT row_number() over(order by M asc) as Sno,Y,M, '+ @cols + N' from
		(
			select * from #temp1
		) x
		pivot
		(
		sum(ID)
		for Error_Category in ('+ @cols+' )
		) p '

	execute(@query);
	Drop table #temp1
END
ELSE IF @Flag='daily_sum'
	BEGIN
		select @cols = STUFF((SELECT ',' + QUOTENAME(b.Error_Category)
		from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID 
		where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND a.Date like @date+'%%'
		group by b.Error_Category
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)')
		,1,1,'')

		select b.Error_Category,count(a.Alarm_ID) as "ID" into #temp3
		from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID and a.machine_code=b.machine_code 
		where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND b.Machine_Code=@machine AND a.Date like @date+'%%'
		group by b.Error_Category

		set @query = N'SELECT  '+ @cols + N' from
		(
			select * from #temp3
		) x
		pivot
		(
		sum(ID)
		for Error_Category in ('+ @cols+' )
		) p '

		execute(@query);
		Drop table #temp3
	END
	ELSE IF @Flag='monthly_sum'
	BEGIN
		select @cols = STUFF((SELECT ',' + QUOTENAME(b.Error_Category)
			from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID 
			where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND a.Date like @date+'%%'
			group by b.Error_Category
			FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)')
			,1,1,'')

		select b.Error_Category, count(a.Alarm_ID) as "ID" into #temp4
			from MachineAlarm as a inner join tbl_Pickup_Feeding_Error as b on a.Alarm_ID=b.AlarmID and a.machine_code=b.machine_code
			where a.CompanyCode=@company AND a.PlantCode=@plant AND a.Line_Code=@Line AND a.Date like @date+'%%'
			group by b.Error_Category

			set @query = N'SELECT  '+ @cols + N' from
			(
				select * from #temp4
			) x
			pivot
			(
			sum(ID)
			for Error_Category in ('+ @cols+' )
			) p '

		execute(@query);
		Drop table #temp4
	END
End
GO
/****** Object:  StoredProcedure [dbo].[SP_TargetProductionSetting]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Created by deepa for production target setting page--
CREATE PROCEDURE [dbo].[SP_TargetProductionSetting]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@CompanyCode nvarchar(150)=null,
	@PlantCode nvarchar(150)=null,
	@Linecode nvarchar(150),
	@ProductName nvarchar(150),
	@TargetProduction int,
	@ShiftID nvarchar(150),
	@fromdate Datetime,
	@todate Datetime,
	
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'

		Begin
			Insert Into tbl_Production_setting(Shift_id,Line_code,Productname,Targetproduction,fromdate,todate,companycode,plantcode)
			Values(@shiftid,@linecode,@productname,@targetproduction,@fromdate,@todate,@companycode,@plantcode)
				set @result='Inserted'	
		END
		
	Else If @QueryType='Update'
	
		
		
			Begin
				Update tbl_Production_setting set Shift_id=@shiftid,Line_code=@linecode,Productname=@productname,Targetproduction=@targetproduction,
				fromdate=@fromdate,todate=@todate,companycode=@companycode,plantcode=@plantcode
				
				Where id=@Unique_id
					set @result='Updated'
			end
		
		--inserted by deepa--end--
	
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_toollife]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_toollife] 
@Flag nvarchar(50),
@linecode nvarchar(10)=null,
@machine_code nvarchar(50)=null,
@fromdate date=null,
@todate date=null,
@CompanyCode nvarchar(150)=null,
@PlantCode nvarchar(150)=null
As
BEGIN
	IF @Flag = 'custom'
	BEGIN
		SELECT B.Line_code,B.Make,B.ToolName,B.Machine_Code,B.Part_number,B.Classification,B.Conversion_parameter,A.ToolID,
		CAST((A.CurrentLifeCycle/B.Conversion_parameter) as decimal(18,2)) AS 'currentlifecle',
		CAST((B.RatedLifeCycle/B.Conversion_parameter) as decimal(18,2)) AS 'ratedlifecle',
		CAST((((A.CurrentLifeCycle/B.Conversion_parameter))/(B.RatedLifeCycle/B.Conversion_parameter))* 100 AS decimal(18,2)) AS 'usage',
		B.UOM, ISNULL(CONVERT(varchar, C.LastMaintenaceDate, 23),'') AS 'lastmain'
		FROM tbl_Raw_Toollife AS A
		INNER JOIN tbl_toollist AS B ON A.ToolID=B.ToolID 
		LEFT JOIN tbl_ToolLife_Maintenace AS C ON A.ToolID=C.ToolID AND C.ID IN (SELECT MAX(id) from tbl_ToolLife_Maintenace
		GROUP BY ToolID)
		WHERE A.id IN (SELECT MAX(id) from tbl_Raw_Toollife
		GROUP BY ToolID) AND A.CompanyCode=@CompanyCode AND B.CompanyCode=@CompanyCode 
		AND A.Line_Code=@linecode AND A.Machine_Code=@machine_code AND A.PlantCode=@PlantCode AND B.PlantCode=@PlantCode
		 AND A.date
		 BETWEEN @fromdate AND @todate GROUP BY A.ToolID,A.Machine_Code,A.CurrentLifeCycle,B.Line_code,
		 B.Machine_Code,B.ToolName,B.Make,B.Part_number,B.Classification,B.Conversion_parameter,B.RatedLifeCycle,C.LastMaintenaceDate,B.UOM
	END
	ELSE IF @Flag = 'preventive'
	BEGIN
		SELECT B.Line_code,B.Make,B.ToolName,B.Machine_Code,B.Part_number,B.Classification,A.ToolID,
		CAST((A.CurrentLifeCycle/B.Conversion_parameter) as decimal(18,2)) AS 'currentlifecle',
		B.UOM,ISNULL(CONVERT(varchar, C.LastMaintenaceDate, 23),'') AS 'lastmain',ISNULL((C.IsReplaced),'') AS 'replaced',ISNULL((C.No_of_Replacements),'') AS 'noofreplce',ISNULL((C.Remarks),'') AS 'remark'  FROM tbl_Raw_Toollife AS A
		INNER JOIN tbl_toollist AS B ON A.ToolID=B.ToolID 
		LEFT JOIN tbl_ToolLife_Maintenace AS C ON A.ToolID=C.ToolID AND C.ID IN (SELECT MAX(id) from tbl_ToolLife_Maintenace
		GROUP BY ToolID)
		WHERE A.id IN (SELECT MAX(id) from tbl_Raw_Toollife
		GROUP BY ToolID) AND A.CompanyCode=@CompanyCode AND B.CompanyCode=@CompanyCode AND 
		 A.Line_Code=@linecode AND A.Machine_Code=@machine_code AND A.PlantCode=@PlantCode AND B.PlantCode=@PlantCode
		 GROUP BY A.ToolID,A.Machine_Code,A.CurrentLifeCycle,B.Line_code,B.Machine_Code,B.ToolName,
		B.Make,B.Part_number,B.Classification,B.Conversion_parameter,C.LastMaintenaceDate,B.UOM,C.IsReplaced,C.No_of_Replacements,C.Remarks
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_toollife_maintenance]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_toollife_maintenance]
@ToolID varchar(10),
@LastMaintenaceDate date=null,
@IsReplaced varchar(10)=null,
@No_of_Replacements int=null,
@Currentusage decimal(18, 0)=null,
@Remarks varchar(30)=null,
@CompanyCode nvarchar(150)=null,
@PlantCode nvarchar(150)=null
As
BEGIN
	Insert Into tbl_ToolLife_Maintenace(ToolID,LastMaintenaceDate,IsReplaced,No_of_Replacements,Currentusage,Remarks,CompanyCode,PlantCode)
	Values(@ToolID,@LastMaintenaceDate,@IsReplaced,@No_of_Replacements,@Currentusage,@Remarks,@CompanyCode,@PlantCode)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ToolLife_Usage_Check]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[SP_ToolLife_Usage_Check]
	@line nvarchar(max),
	@company nvarchar(max),
	@plant nvarchar(max)

as
Begin
	
	SELECT [Line_code],[Make],[ToolName],b.AssetName,[Part_number],[Classification],
	[Conversion_parameter],[ToolID],[currentlifecle],[ratedlifecle],[usage],[UOM],[lastmain]
	FROM [dbo].[tbl_temp_toollife_rawdata] a
	inner join tbl_assets b on a.Line_code=b.FunctionName and a.CompanyCode=b.CompanyCode and a.PlantCode=b.PlantCode
	WHERE (CAST(usage as float))>=60.00 
	and a.[CompanyCode]=@company and a.[PlantCode]=@plant and a.Line_code like @line order by (CAST(usage as float)) desc

End
GO
/****** Object:  StoredProcedure [dbo].[SP_toollist]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_toollist]
	@QueryType nvarchar(25),
	@ID int=null,
	@Line_Code nvarchar(150),
	@ToolName varchar(150),
	@ToolID nvarchar(150),
	@Make nvarchar(150),
	@UOM nvarchar(150),
	@Part_number nvarchar(150),
	@Classfication nvarchar(150),
	@RatedLifeCycle nvarchar(150),
	@Machine_Code nvarchar(150),
	@Conversion_parameter nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_toollist where CompanyCode=@CompanyCode AND (ToolID=@ToolID OR ToolName=@ToolName))
		Begin
			Insert Into tbl_toollist(Line_Code,Machine_Code,ToolID,ToolName,Make,UOM,Part_number,Classification,RatedLifeCycle,Conversion_parameter,CompanyCode,PlantCode)
			Values(@Line_Code,@Machine_Code,@ToolID,@ToolName,@Make,@UOM,@Part_number,@Classfication,@RatedLifeCycle,@Conversion_parameter,@CompanyCode,@PlantCode)
				set @result='Inserted'	
		END
		Else If exists(Select * From tbl_toollist where CompanyCode=@CompanyCode AND ToolID=@ToolID )
				BEGIN
					set @result='Already ToolID'
				END
				Else 
					BEGIN
						set @result='Already ToolName'
					END	
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_toollist where CompanyCode=@CompanyCode AND ToolName=@ToolName AND ID!=@ID )
				BEGIN
					Update tbl_toollist set Line_Code=@Line_Code,Machine_Code=@Machine_Code,ToolID=@ToolID,ToolName=@ToolName,Make=@Make,
					UOM=@UOM,Part_number=@Part_number,Classification=@Classfication,RatedLifeCycle=@RatedLifeCycle,Conversion_parameter=@Conversion_parameter
					Where ID=@ID
						set @result='Updated'
				END
			Else 
						BEGIN
							set @result='Already ToolName'
						END
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_update_responseIn_AlertSetting]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE PROCEDURE [dbo].[SP_update_responseIn_AlertSetting]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@status nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@laststatus nvarchar(150)=null,
	@username nvarchar(150)=null,
	@respondtime smalldatetime=null,
	@id nvarchar(150)=null,
	@starttime datetime=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@dummy datetime,@liveStartTime datetime,@updateDate datetime,@toupdate datetime,@DurationForRepetetion int
	Set @result=''
		
		
	If @QueryType='Update'
	Begin
	
		Begin
				Update [tbl_Alert_responding] set ResponseSelect=@status,[LastRespondStatus]=@laststatus,
				[LastResponded]=@username,[LastResponseDateTime]=@respondtime
				Where AlertID=@id 
				and StartTime=@starttime

				set @DurationForRepetetion=(select distinct Repetetion from [tbl_Alert_Status_Update] where [AlertID]=@id and start_time=@starttime); 
				set @dummy=(SELECT DATEADD(mi, CAST(Repetetion as Int),End_Time) from [tbl_Alert_Status_Update] where [AlertID]=@id and start_time=@starttime); 
				set @updateDate=(SELECT CAST(SWITCHOFFSET(DATEADD(mi, CAST(0 as Int),GETDATE()), '+05:30')as Datetime));
				set @toupdate=(SELECT CAST(SWITCHOFFSET(DATEADD(mi, CAST(@DurationForRepetetion as Int),GETDATE()), '+05:30')as Datetime));


				--update [tbl_Alert_Status_Update] set Acknowledge_status=@status where AlertID=@id 
				--and Start_Time=@starttime
				--	set @result='Updated'

				
				update [dbo].[tbl_Alert_Status_Update] set Acknowledge_status=@status,
				Next_Repetition_time=(CASE  
                        WHEN @dummy >@updateDate THEN @dummy
                        ELSE (DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @toupdate), 0))
                    END )
				Where [AlertID]=@id and start_time=@starttime

				set @result='Updated'
		end
		
	End
	
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_update_responseIn_AlertSetting_20210820]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[SP_update_responseIn_AlertSetting_20210820]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@status nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@id nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
		
		
	If @QueryType='Update'
	Begin
	
		Begin
				Update [tbl_Alert_responding] set ResponseSelect=@status
				Where AlertID=@id 
					set @result='Updated'
		end
		
	End
	
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_URL_details]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_URL_details]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@url nvarchar(150),
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@LineCode nvarchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
				
	If @QueryType='Update'
	Begin
	
		Update Portal_URL set URL=@url
				Where id=@Unique_id 
					set @result='Updated'
	
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UserGroup_Permission]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[SP_UserGroup_Permission]
	@QueryType nvarchar(25),
	@Unique_id int=null,
	@Groupid int=null,
	@Userid nvarchar(150)=null,
	@Companycode nvarchar(150),
	@Plantcode nvarchar(150),
	@Linecode nvarchar(150)=null,
	
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From tbl_SMS_GroupPermission where GroupID=@Groupid AND Userid=@Userid and Plantcode=@Plantcode and Companycode=@Companycode)
		Begin
			Insert into tbl_SMS_GroupPermission(GroupID,UserID,CompanyCode,PlantCode,Line_code) values(@Groupid,@Userid,@Companycode,@Plantcode,@Linecode)
			
				set @result='Inserted'	
		END
		Else
		BEGIN
			set @result='Already'
		END
	End			
	Else If @QueryType='Update'
	Begin
		If not exists(Select * From tbl_SMS_GroupPermission where GroupID=@Groupid AND Userid=@Userid and Plantcode=@Plantcode and Companycode=@Companycode)
		Insert into tbl_SMS_GroupPermission(GroupID,UserID,CompanyCode,PlantCode,Line_code) values(@Groupid,@Userid,@Companycode,@Plantcode,@Linecode)
			
			set @result='Updated'
	End
	
	Else If @QueryType='Delete'
	Begin
	  delete  from tbl_SMS_GroupPermission where GroupID=@Groupid  and Plantcode=@Plantcode and Companycode=@Companycode
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Users]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[SP_Users]
	@QueryType varchar(25),
	@Unique_id int=null,
	@UserID varchar(150),
	@FirstName varchar(150),
	@LastName varchar(150),
	@UserName nvarchar(150),
	@Password nvarchar(150),
	@PhoneNo varchar(150),
	@Email varchar(150),
	@RoleID varchar(150)=null,
	@IsActive varchar(150),
	@SkillSet varchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150)=null,
	@IsAdmin bit=0,
	@VCode nvarchar(50)=null,
	@LineRoleID varchar(150)=null,
	@SQLReturn nvarchar(50) output	 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50)
	Set @result=''
	If @QueryType='Insert'
	Begin
		If not exists(Select * From Users where PhoneNo=@PhoneNo OR UserID=@UserID OR Email=@Email)
		Begin
			if(@IsAdmin != 1)
			BEGIN
				INSERT INTO LNK_USER_ROLE(RoleID,UserID,CompanyCode)VALUES(@RoleID,@UserID,@CompanyCode)
			END
			Insert Into Users(UserID,FirstName,LastName,UserName,Password,PhoneNo,Email,RoleID,IsActive,SkillSet,CompanyCode,PlantCode,IsAdmin,VCode,LineRoleID)
			Values(@UserID,@FirstName,@LastName,@UserName,@Password,@PhoneNo,@Email,@RoleID,@IsActive,@SkillSet,@CompanyCode,@PlantCode,@IsAdmin,@VCode,@LineRoleID)
				set @result='Inserted'	
		END
		--inserted by krishna(12-03-2020)--start--
		--Else
		--BEGIN
			--set @result='Already'
		--END
		Else If exists(Select * From Users where UserID=@UserID )
			BEGIN
				set @result='Already UserID'
			END
		Else If exists(Select * From Users where PhoneNo=@PhoneNo )
			BEGIN
				set @result='Already PhoneNo'
			END
		else if exists(Select * From Users where Email=@Email )
			BEGIN
				set @result='Already Email'
			END
			
		--inserted by krishna(12-03-2020)--end--
			
		 
	End			
	Else If @QueryType='Update'
	Begin
	--inserted by krishna(12-03-2020)--start--
		--Update Users set FirstName=@FirstName,LastName=@LastName,UserName=@UserName,
		--Email=@Email,PhoneNo=@PhoneNo,RoleID=@RoleID,IsActive=@IsActive,
		--SkillSet=@SkillSet
		--Where UserID=@UserID AND CompanyCode=@CompanyCode
		--	set @result='Updated'
		If not exists(Select * From Users where (UserID!=@UserID and RoleID=@RoleID) and (PhoneNo=@PhoneNo or Email=@Email))
			BEGIN
			if(@IsAdmin != 1)
			BEGIN
				Update LNK_USER_ROLE set RoleID=@RoleID Where UserID=@UserID AND CompanyCode=@CompanyCode
			END
				Update Users set FirstName=@FirstName,LastName=@LastName,UserName=@UserName,
				Email=@Email,PhoneNo=@PhoneNo,RoleID=@RoleID,IsActive=@IsActive,
				SkillSet=@SkillSet,LineRoleID=@LineRoleID
				Where UserID=@UserID AND CompanyCode=@CompanyCode
					set @result='Updated'
			END
			else If exists(Select * From Users where PhoneNo=@PhoneNo and UserID!=@UserID )
					BEGIN
						set @result='Already PhoneNo'
					END
				else if exists(Select * From Users where Email=@Email and UserID!=@UserID )
						BEGIN
							set @result='Already Email'
						END

	--inserted by krishna(12-03-2020)--end--
	End
	set @SQLReturn=@result
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Variable_add]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





create PROCEDURE [dbo].[SP_Variable_add]
	@QueryType nvarchar(25),
	@Line_code nvarchar(150)=null,
	@CompanyCode nvarchar(150),
	@PlantCode nvarchar(150),
	@Unique_id int=null 
AS
BEGIN	
	SET NOCOUNT ON;
	Declare @result nvarchar(50),@id int
	Set @result=''
	If @QueryType='Details'
	Begin
		select a.[Unique_id],a.[Variable],b.[GroupName],a.[ParameterName],a.[VarValue],a.[PropertyGroup]
		 from [tbl_SMS_Variable] a 
		 join [tbl_SMS_Group] b on b.[GroupID]=a.[PropertyGroup] and a.CompanyCode=b.CompanyCode AND a.[Line_code]=b.[Line_code] AND a.PlantCode=b.PlantCode
		 where a.CompanyCode=@CompanyCode AND a.[Line_code]=@Line_code AND a.PlantCode=@PlantCode
	End	
	Else If @QueryType='edit_Details'
	Begin
		select a.[Unique_id],a.[Variable],b.[GroupName],a.[ParameterName],a.[VarValue],a.[PropertyGroup]
		 from [tbl_SMS_Variable] a 
		 join [tbl_SMS_Group] b on b.[GroupID]=a.[PropertyGroup] and a.CompanyCode=b.CompanyCode AND a.[Line_code]=b.[Line_code] AND a.PlantCode=b.PlantCode
		 where a.[Unique_id]=@Unique_id 
	End		
	
END
GO
/****** Object:  StoredProcedure [dbo].[SPAlertSummary]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SPAlertSummary]
(
    -- Parameters for the SPAlertSummary
    @CompanyCode Nvarchar(100)=Null,
	@PlantCode NVarchar(100)=Null,
	@LineCode as varchar(50)=Null,
	@Machine as varchar(50)=Null,
	@Fromdate Date=Null,
	@Todate Date=Null 

)
AS
BEGIN
--Fetching the data from tbl_SMS_history table 
--For Selection of History data between the mentioned duration by user in the portal
	SELECT tsh.AlertID,tsh.AlertDateAndTime,tba.MessageText,tsh.SentGroup,tsh.counts,tsh.InstanceCount FROM tbl_SMS_History tsh 
	INNER JOIN tbl_alert_settings tba ON tsh.AlertID = tba.AlertID and tsh.CompanyCode=tba.CompanyCode and tsh.PlantCode=tba.PlantCode and 
	tsh.Line_code=tba.Line_Code and tsh.Machine_Code=tsh.Machine_Code
	where  AlertDateAndTime BETWEEN Convert(datetime,@Fromdate) AND (Convert(datetime,@Todate)+1)
	and tsh.CompanyCode=@CompanyCode and tsh.PlantCode=@PlantCode and tsh.Line_code=@LineCode and tsh.Machine_Code=@Machine 
	order by AlertDateAndTime desc

END
GO
/****** Object:  StoredProcedure [dbo].[SPAlertSummary_Default]    Script Date: 7/3/2024 12:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- Author:      <Tamilmozhi>
-- Create Date: <2021-06-21>
-- Description: <Fetch the Alert History on selected duration(from date & to date)>
-- =============================================
CREATE PROCEDURE [dbo].[SPAlertSummary_Default]
(
    -- Parameters for the SPAlertSummary
    @CompanyCode Nvarchar(100)=Null,
	@PlantCode NVarchar(100)=Null,
	@LineCode as varchar(50)=Null,
	@Machine as varchar(50)=Null

)
AS
BEGIN
--Fetching the data from tbl_SMS_history table 
--For Selection of History data between the mentioned duration by user in the portal
	SELECT top 5 tsh.AlertID,tsh.AlertDateAndTime,tba.MessageText,tsh.SentGroup,tsh.counts,tsh.InstanceCount FROM tbl_SMS_History tsh 
	INNER JOIN tbl_alert_settings tba ON tsh.AlertID = tba.AlertID and tsh.CompanyCode=tba.CompanyCode and tsh.PlantCode=tba.PlantCode and 
	tsh.Line_code=tba.Line_Code and tsh.Machine_Code=tsh.Machine_Code
	--where tsh.CompanyCode=@CompanyCode and tsh.PlantCode=@PlantCode and tsh.Line_code=@LineCode and tsh.Machine_Code=@Machine 
	order by AlertDateAndTime desc

END
GO
USE [master]
GO
ALTER DATABASE [iotkpimaster] SET  READ_WRITE 
GO
