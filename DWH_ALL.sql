USE [master]
GO
/****** Object:  Database [ECommerce_DWH]    Script Date: 12.02.2026 17:07:06 ******/
CREATE DATABASE [ECommerce_DWH]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ECommerce_DWH', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MYSQL2025\MSSQL\DATA\ECommerce_DWH.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ECommerce_DWH_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MYSQL2025\MSSQL\DATA\ECommerce_DWH_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ECommerce_DWH] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ECommerce_DWH].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ECommerce_DWH] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET ARITHABORT OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ECommerce_DWH] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ECommerce_DWH] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ECommerce_DWH] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ECommerce_DWH] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET RECOVERY FULL 
GO
ALTER DATABASE [ECommerce_DWH] SET  MULTI_USER 
GO
ALTER DATABASE [ECommerce_DWH] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ECommerce_DWH] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ECommerce_DWH] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ECommerce_DWH] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ECommerce_DWH] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ECommerce_DWH] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [ECommerce_DWH] SET QUERY_STORE = ON
GO
ALTER DATABASE [ECommerce_DWH] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ECommerce_DWH]
GO
/****** Object:  Table [dbo].[Dim_Customer]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Customer](
	[SCDID_Customer] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[City] [nvarchar](60) NULL,
	[State] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NULL,
	[ValidFrom] [date] NOT NULL,
	[ValidTo] [date] NULL,
	[IsCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_Dim_Customer] PRIMARY KEY CLUSTERED 
(
	[SCDID_Customer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Date]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Date](
	[TimeID] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
 CONSTRAINT [PK_Dim_Date] PRIMARY KEY CLUSTERED 
(
	[TimeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Product]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Product](
	[SCDID_Product] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](200) NOT NULL,
	[CategoryName] [nvarchar](100) NULL,
	[ValidFrom] [date] NOT NULL,
	[ValidTo] [date] NULL,
	[IsCurrent] [bit] NOT NULL,
 CONSTRAINT [PK_Dim_Product] PRIMARY KEY CLUSTERED 
(
	[SCDID_Product] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Shipper]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Shipper](
	[ShipperID] [int] NOT NULL,
	[ShipperName] [nvarchar](100) NULL,
	[ShippingMethod] [nvarchar](50) NULL,
	[ShippingCost] [decimal](8, 2) NULL,
 CONSTRAINT [PK_Dim_Shipper] PRIMARY KEY CLUSTERED 
(
	[ShipperID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dim_Warehouse]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Warehouse](
	[WarehouseID] [int] NOT NULL,
	[WarehouseName] [varchar](10) NULL,
 CONSTRAINT [PK_Dim_Warehouse] PRIMARY KEY CLUSTERED 
(
	[WarehouseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fact_Sales]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Sales](
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[TimeID] [int] NOT NULL,
	[SCDID_Customer] [int] NOT NULL,
	[SCDID_Product] [int] NOT NULL,
	[ShipperID] [int] NOT NULL,
	[WarehouseID] [int] NOT NULL,
	[PlannedShippingDays] [int] NULL,
	[ActualShippingDays] [int] NULL,
	[DelayDays]  AS (case when [ActualShippingDays] IS NULL then NULL when [ActualShippingDays]>[PlannedShippingDays] then [ActualShippingDays]-[PlannedShippingDays] else (0) end),
	[IsDelayed]  AS (case when [ActualShippingDays] IS NULL then NULL when [ActualShippingDays]>[PlannedShippingDays] then (1) else (0) end),
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[SalesAmount] [decimal](10, 2) NOT NULL,
	[ShippingCost] [decimal](8, 2) NULL,
 CONSTRAINT [PK_Fact_Sales] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Dim_Customer_BK]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Dim_Customer_BK] ON [dbo].[Dim_Customer]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Dim_Customer_Current]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Dim_Customer_Current] ON [dbo].[Dim_Customer]
(
	[CustomerID] ASC,
	[IsCurrent] ASC
)
WHERE ([IsCurrent]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Dim_Date_YM]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Dim_Date_YM] ON [dbo].[Dim_Date]
(
	[Year] ASC,
	[Month] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Dim_Product_BK]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Dim_Product_BK] ON [dbo].[Dim_Product]
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Dim_Product_Cat]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Dim_Product_Cat] ON [dbo].[Dim_Product]
(
	[CategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Dim_Product_Current]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Dim_Product_Current] ON [dbo].[Dim_Product]
(
	[ProductID] ASC,
	[IsCurrent] ASC
)
WHERE ([IsCurrent]=(1))
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Dim_Shipper_Method]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Dim_Shipper_Method] ON [dbo].[Dim_Shipper]
(
	[ShippingMethod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fact_Customer]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Fact_Customer] ON [dbo].[Fact_Sales]
(
	[SCDID_Customer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fact_Date]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Fact_Date] ON [dbo].[Fact_Sales]
(
	[TimeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fact_Delayed]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Fact_Delayed] ON [dbo].[Fact_Sales]
(
	[ShipperID] ASC
)
INCLUDE([PlannedShippingDays],[ActualShippingDays]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fact_Product]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Fact_Product] ON [dbo].[Fact_Sales]
(
	[SCDID_Product] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fact_Shipper]    Script Date: 12.02.2026 17:07:06 ******/
CREATE NONCLUSTERED INDEX [IX_Fact_Shipper] ON [dbo].[Fact_Sales]
(
	[ShipperID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dim_Customer] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [dbo].[Dim_Product] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Customer] FOREIGN KEY([SCDID_Customer])
REFERENCES [dbo].[Dim_Customer] ([SCDID_Customer])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Customer]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Date] FOREIGN KEY([TimeID])
REFERENCES [dbo].[Dim_Date] ([TimeID])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Date]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Product] FOREIGN KEY([SCDID_Product])
REFERENCES [dbo].[Dim_Product] ([SCDID_Product])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Product]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Shipper] FOREIGN KEY([ShipperID])
REFERENCES [dbo].[Dim_Shipper] ([ShipperID])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Shipper]
GO
ALTER TABLE [dbo].[Fact_Sales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Warehouse] FOREIGN KEY([WarehouseID])
REFERENCES [dbo].[Dim_Warehouse] ([WarehouseID])
GO
ALTER TABLE [dbo].[Fact_Sales] CHECK CONSTRAINT [FK_Fact_Warehouse]
GO
/****** Object:  StoredProcedure [dbo].[Analyse_Kosten_Versandart]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Analyse_Kosten_Versandart]
AS
BEGIN
    SELECT
        sh.ShippingMethod AS VersandArt,
        COUNT(*)AS AnzahlSendungen,
        SUM(fs.SalesAmount) AS GesamtUmsatz,
        AVG(fs.ShippingCost)  AS Versandkosten,
        SUM(fs.ShippingCost) / NULLIF(SUM(fs.SalesAmount), 0) * 100 AS VersandkostenquoteProzent,
        AVG(fs.ActualShippingDays)AS DurchschnittlicheLieferdauer
    FROM Dim_Shipper sh
    JOIN Fact_Sales fs ON fs.ShipperID = sh.ShipperID
    GROUP BY sh.ShippingMethod
    ORDER BY Versandkosten;
END;
GO
/****** Object:  StoredProcedure [dbo].[Analyse_Lieferanten_Qualitaet]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Analyse_Lieferanten_Qualitaet]
AS
BEGIN
    SELECT
        ShipperID,
        COUNT(*) AS AnzahlSendungen,
        SUM(CASE 
                WHEN ActualShippingDays > PlannedShippingDays THEN 1 
                ELSE 0 
            END) AS VerspaeteteSendungen,
        SUM(CASE 
                WHEN ActualShippingDays > PlannedShippingDays THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*) AS FehlerquoteProzent
    FROM dbo.Fact_Sales
    GROUP BY ShipperID
    ORDER BY FehlerquoteProzent ASC;
END;
GO
/****** Object:  StoredProcedure [dbo].[Analyse_Liefertreue]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Analyse_Liefertreue]
AS
BEGIN
    SELECT
        ShipperID,
        COUNT(*) AS AnzahlLieferungen,
        AVG(PlannedShippingDays) AS DurchschnittGeplant,
        AVG(ActualShippingDays) AS DurchschnittTatsaechlich,
        AVG(ActualShippingDays) - AVG(PlannedShippingDays) AS DurchschnittlicheAbweichung,
        SUM(CASE 
               WHEN ActualShippingDays <= PlannedShippingDays THEN 1 
               ELSE 0 
            END) * 100.0/COUNT(*) AS ProzentPuenktlich
    FROM dbo.Fact_Sales
    GROUP BY ShipperID
    ORDER BY ProzentPuenktlich DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[Analyse_Umsatz_Produkt]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Analyse_Umsatz_Produkt]
AS
BEGIN
    SELECT
        dp.ProductName,
        SUM(fs.Quantity) AS GesamtMenge,
        SUM(fs.SalesAmount) AS GesamtUmsatz,
        AVG(fs.UnitPrice) AS Durchschnittspreis
    FROM dbo.Fact_Sales fs
    INNER JOIN dbo.Dim_Product dp
        ON dp.SCDID_Product = fs.SCDID_Product
    GROUP BY dp.ProductName
    ORDER BY GesamtUmsatz DESC;
END;

GO
/****** Object:  StoredProcedure [dbo].[Analyse_Versandkosten]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Analyse_Versandkosten]
AS
BEGIN
    SELECT
        ShipperID,
        COUNT(*) AS AnzahlSendungen,
        SUM(SalesAmount) AS GesamtUmsatz,
        SUM(ShippingCost) AS GesamteVersandkosten,
        SUM(ShippingCost) / NULLIF(SUM(SalesAmount), 0) * 100 AS VersandkostenquoteProzent,
        AVG(ActualShippingDays) AS DurchschnittlicheLieferdauer
    FROM dbo.Fact_Sales
    GROUP BY ShipperID
    ORDER BY VersandkostenquoteProzent ASC;
END;

GO
/****** Object:  StoredProcedure [dbo].[Analyse_Versandkosten_Lieferanten]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[Analyse_Versandkosten_Lieferanten]
AS
BEGIN
    SELECT
        ShipperID,
        COUNT(*) AS AnzahlSendungen,
        SUM(SalesAmount) AS GesamtUmsatz,
        SUM(ShippingCost) AS GesamteVersandkosten,
        SUM(ShippingCost) / NULLIF(SUM(SalesAmount), 0) * 100 AS VersandkostenquoteProzent,
        AVG(ActualShippingDays) AS DurchschnittlicheLieferdauer
    FROM dbo.Fact_Sales
    GROUP BY ShipperID
    ORDER BY VersandkostenquoteProzent ASC;
END;
GO
/****** Object:  StoredProcedure [dbo].[KPI_Dashboard]    Script Date: 12.02.2026 17:07:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[KPI_Dashboard]
AS
BEGIN
    SELECT
        -- Umsatz
        SUM(SalesAmount) AS Gesamtumsatz,

        -- Absatz
        SUM(Quantity) AS Gesamtmenge,

        -- Durchschnittlicher Bestellwert
        SUM(SalesAmount) / NULLIF(COUNT(DISTINCT OrderID), 0) AS DurchschnittlicherBestellwert,

        -- Durchschnittliche Lieferdauer
        AVG(ActualShippingDays) AS DurchschnittlicheLieferdauer,

        -- Puenktlichkeitsquote
        SUM(CASE 
                WHEN ActualShippingDays <= PlannedShippingDays THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*) AS PuenktlichkeitsquoteProzent,

        -- Versandkostenquote
        SUM(ShippingCost) / NULLIF(SUM(SalesAmount), 0) * 100 AS VersandkostenquoteProzent,

        -- Anzahl Bestellungen
        COUNT(DISTINCT OrderID) AS AnzahlBestellungen,

        -- Anzahl Produkte verkauft
        COUNT(DISTINCT ProductID) AS AnzahlProdukte

    FROM dbo.Fact_Sales;
END;
GO
USE [master]
GO
ALTER DATABASE [ECommerce_DWH] SET  READ_WRITE 
GO
