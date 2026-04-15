USE ECommerce_DWH;
GO


-- ANALYSE 1: Wie hoch ist die durchschnittliche Lieferzeit?
-- Beantwortet: globaler Durchschnitt, aufgeschluesselt nach
--   (a) Versandart, (b) Monat und (c) Region des Lagers
-- ============================================================================

PRINT '=== ANALYSE 1: Durchschnittliche Lieferzeit ===';
GO

-- 1a) Globaler Ueberblick
SELECT
    COUNT(*)                                            AS GesamtSendungen,
    COUNT(ActualShippingDays)                           AS AbgeschlosseneSendungen,
    ROUND(AVG(CAST(PlannedShippingDays AS FLOAT)), 2)   AS AvgGeplanteTage,
    ROUND(AVG(CAST(ActualShippingDays  AS FLOAT)), 2)   AS AvgTatsaechlicheTage,
    ROUND(AVG(CAST(ActualShippingDays  AS FLOAT))
        - AVG(CAST(PlannedShippingDays AS FLOAT)), 2)   AS DurchschnittlicheAbweichung
FROM dbo.Fact_Sales
WHERE ActualShippingDays IS NOT NULL;
GO

-- 1b) Durchschnittliche Lieferzeit je Versandart
SELECT
    ds.ShippingMethod                                   AS Versandart,
    COUNT(*)                                            AS Sendungen,
    ROUND(AVG(CAST(f.PlannedShippingDays AS FLOAT)), 2) AS AvgGeplanteTage,
    ROUND(AVG(CAST(f.ActualShippingDays  AS FLOAT)), 2) AS AvgTatsaechlicheTage
FROM dbo.Fact_Sales       f
JOIN dbo.Dim_Shipper      ds ON ds.ShipperID = f.ShipperID
WHERE f.ActualShippingDays IS NOT NULL
GROUP BY ds.ShippingMethod
ORDER BY AvgTatsaechlicheTage;
GO

-- 1c) Durchschnittliche Lieferzeit je Monat (Saisonalität)
SELECT
    dd.Year  AS Jahr,
    dd.Month AS Monat,
    COUNT(*) AS Sendungen,
    ROUND(AVG(CAST(f.ActualShippingDays AS FLOAT)), 2)  AS AvgTatsaechlicheTage
FROM dbo.Fact_Sales  f
JOIN dbo.Dim_Date    dd ON dd.TimeID = f.TimeID
WHERE f.ActualShippingDays IS NOT NULL
GROUP BY dd.Year, dd.Month
ORDER BY dd.Year, dd.Month;
GO



-- ANALYSE 2: Wie hoch ist die Verspätungsquote?

-- Beantwortet: Anteil verspäteter Lieferungen (gesamt & je Versandart)
--   Eine Lieferung gilt als verspaetet, wenn ActualShippingDays > PlannedShippingDays

GO

-- 2a) Gesamtquote
SELECT
    COUNT(*)    AS GesamtSendungen,
    SUM(CAST(IsDelayed AS INT)) AS VerspaeteteSendungen,
    ROUND(
        100.0 * SUM(CAST(IsDelayed AS INT))
              / NULLIF(COUNT(*), 0), 2)  AS VerspaetungsquoteProzent,
    ROUND(AVG(CAST(DelayDays AS FLOAT)), 2) AS AvgVerspaetungTage
FROM dbo.Fact_Sales
WHERE ActualShippingDays IS NOT NULL;
GO

-- 2b) Quote je Versandart
SELECT
    ds.ShippingMethod AS Versandart,
    COUNT(*)  AS Sendungen,
    SUM(CAST(f.IsDelayed AS INT)) AS Verspätet,
    ROUND(
        100.0 * SUM(CAST(f.IsDelayed AS INT))
              / NULLIF(COUNT(*), 0), 2) AS QuoteProzent,
    ROUND(AVG(CAST(f.DelayDays AS FLOAT)), 2) AS AvgVerspaetungTage
FROM dbo.Fact_Sales f
JOIN dbo.Dim_Shipper  ds ON ds.ShipperID = f.ShipperID
WHERE f.ActualShippingDays IS NOT NULL
GROUP BY ds.ShippingMethod
ORDER BY QuoteProzent DESC;
GO

-- 2c) On-Time vs. Verspaetet (Ueberblick)
SELECT
    CASE
        WHEN ActualShippingDays IS NULL           THEN 'In Transit'
        WHEN ActualShippingDays > PlannedShippingDays THEN 'Verspaetet'
        ELSE 'Puenktlich'
    END AS Lieferstatus,
    COUNT(*)    AS Anzahl,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS AnteilProzent
FROM dbo.Fact_Sales
GROUP BY
    CASE
        WHEN ActualShippingDays IS NULL           THEN 'In Transit'
        WHEN ActualShippingDays > PlannedShippingDays THEN 'Verspaetet'
        ELSE 'Puenktlich'
    END;
GO



-- ANALYSE 3: Welche Versandart ist am kosteneffizientesten?

-- Kosteneffizienz = ShippingCost / ActualShippingDays
--   (Kosten pro Liefertag – je niedriger, desto effizienter)
--   Ausserdem: Durchschnittskosten absolut pro Versandart


SELECT
    ds.ShippingMethod AS Versandart,
    ds.ShippingCost  AS FixkostenProSendung,
    COUNT(*)  AS Sendungen,
    ROUND(AVG(CAST(f.ActualShippingDays AS FLOAT)), 2)AS AvgLiefertage,
    -- Kosten pro tatsaechlichem Liefertag (Effizienz-KPI)
    ROUND(
        ds.ShippingCost
        / NULLIF(AVG(CAST(f.ActualShippingDays AS FLOAT)), 0), 4)   AS KostenProLiefertag,
    -- Gesamtversandkosten dieser Methode
    ROUND(SUM(f.ShippingCost), 2) AS GesamtversandkostenEUR,
    -- Versandkostenanteil am Gesamtumsatz
    ROUND(
        100.0 * SUM(f.ShippingCost) / NULLIF(SUM(f.TotalAmount), 0), 2)AS VersandkostenanteilProzent
FROM dbo.Fact_Sales   f
JOIN dbo.Dim_Shipper  ds ON ds.ShipperID = f.ShipperID
WHERE f.ActualShippingDays IS NOT NULL
  AND f.ActualShippingDays > 0
GROUP BY ds.ShippingMethod, ds.ShippingCost
ORDER BY KostenProLiefertag;
GO



-- ANALYSE 4: Welcher Lieferdienst hat die höchste Verspätungsrate?
-- Ranking aller Carrier nach Verspätungsquote, inkl. Durchschnittsverzögerung


SELECT
    ds.ShipperName AS Lieferdienst,
    ds.ShippingMethod AS Versandart,
    ds.ShippingCost AS Kosten,
    COUNT(*) AS GesamtSendungen,
    SUM(CAST(f.IsDelayed AS INT)) AS VerspaeteteSendungen,
    ROUND( 100.0 * SUM(CAST(f.IsDelayed AS INT)) / NULLIF(COUNT(*), 0), 2)AS VerspaetungsrateProzent,
    ROUND(AVG(CASE WHEN f.IsDelayed = 1
                   THEN CAST(f.DelayDays AS FLOAT) END), 2)AS AvgVerspaetungWennZuspaet,
    ROUND(AVG(CAST(f.ActualShippingDays AS FLOAT)), 2)  AS AvgLiefertageGesamt,
    -- Ranking (1 = schlechteste Performance)
    RANK() OVER ( ORDER BY 100.0 * SUM(CAST(f.IsDelayed AS INT)) / NULLIF(COUNT(*), 0) DESC) 
    AS RankingVerspaetung
FROM dbo.Fact_Sales   f
JOIN dbo.Dim_Shipper  ds ON ds.ShipperID = f.ShipperID
WHERE f.ActualShippingDays IS NOT NULL
GROUP BY ds.ShipperName, ds.ShippingMethod, ds.ShippingCost
ORDER BY VerspaetungsrateProzent DESC;
GO


-- ANALYSE 5: Welche Produkte generieren den höchsten Profit?
-- Profit-Definition hier: SalesAmount - ShippingCost
-- Aufgeschluesselt nach Produkt und Kategorie
-- ============================================================================


-- 5a) Ranking einzelner Produkte
SELECT
    dp.ProductName  AS Produkt,
    dp.CategoryName AS Kategorie,
    dp.Price        AS Einzelpreis,
    SUM(f.Quantity) AS VerkaufteMenge,
    ROUND(SUM(f.SalesAmount), 2)AS GesamtUmsatz,
    ROUND(SUM(ISNULL(f.ShippingCost, 0)), 2)AS GesamtVersandkosten,
    ROUND(SUM(f.SalesAmount) - SUM(ISNULL(f.ShippingCost, 0)), 2) AS Profit,
    ROUND(100.0 * (SUM(f.SalesAmount) - SUM(ISNULL(f.ShippingCost, 0)))/ NULLIF(SUM(f.SalesAmount), 0)
    , 2)AS ProfitmargeПrozent,
    -- Ranking
    RANK() OVER (ORDER BY
        SUM(f.SalesAmount) - SUM(ISNULL(f.ShippingCost, 0)) DESC ) AS ProfitRank
FROM dbo.Fact_Sales   f
JOIN dbo.Dim_Product  dp ON dp.SCDID_Product = f.SCDID_Product
WHERE dp.IsCurrent = 1
GROUP BY dp.ProductName, dp.CategoryName, dp.Price
ORDER BY Profit DESC;
GO

-- 5b) Profit je Kategorie (Ueberblick)
SELECT
    dp.CategoryName AS Kategorie,
    COUNT(DISTINCT dp.ProductID) AS AnzahlProdukte,
    SUM(f.Quantity)AS VerkaufteMenge,
    ROUND(SUM(f.SalesAmount), 2) AS GesamtUmsatz,
    ROUND(SUM(f.SalesAmount) - SUM(ISNULL(f.ShippingCost, 0)), 2) AS GesamtProfit,
    ROUND(100.0 * (SUM(f.SalesAmount) - SUM(ISNULL(f.ShippingCost, 0)))/ NULLIF(SUM(f.SalesAmount), 0), 2) 
    AS ProfitmargeПrozent
FROM dbo.Fact_Sales   f
JOIN dbo.Dim_Product  dp ON dp.SCDID_Product = f.SCDID_Product
WHERE dp.IsCurrent = 1
GROUP BY dp.CategoryName
ORDER BY GesamtProfit DESC;
GO



-- ANALYSE 6: Welche Kundensegmente verursachen die meisten Lieferverzögerungen?

-- Segmentierung nach:
--   (a) Bundesstaat (State)
--   (b) Land (Country)
--   (c) Stadt (City)

PRINT '=== ANALYSE 6: Verzögerungen nach Kundensegment ===';
GO

-- 6a) Verspätungsquote je Bundesstaat
SELECT
    dc.State AS Bundesstaat,
    dc.Country AS Land,
    COUNT(*)AS GesamtBestellungen,
    SUM(CAST(f.IsDelayed AS INT)) AS VerspaeteteBestellungen,
    ROUND(100.0 * SUM(CAST(f.IsDelayed AS INT))/ NULLIF(COUNT(*), 0), 2)                                                         AS VerspaetungsquoteProzent,
    ROUND(AVG(CAST(f.DelayDays AS FLOAT)), 2) AS AvgVerspaetungTage,
    -- Ranking schlechteste Regionen
    RANK() OVER (
    ORDER BY 100.0 * SUM(CAST(f.IsDelayed AS INT)) / NULLIF(COUNT(*), 0) DESC)                                                            AS Rang
FROM dbo.Fact_Sales    f
JOIN dbo.Dim_Customer  dc ON dc.SCDID_Customer = f.SCDID_Customer
WHERE f.ActualShippingDays IS NOT NULL
  AND dc.IsCurrent = 1
GROUP BY dc.State, dc.Country
ORDER BY VerspaetungsquoteProzent DESC;
GO

-- 6b) Verspätungsquote je Stadt (Top 10 schlechteste)
SELECT TOP 10
    dc.City AS Stadt,
    dc.State AS Bundesstaat,
    COUNT(*) AS Bestellungen,
    SUM(CAST(f.IsDelayed AS INT))AS Verspaetet,
    ROUND(
        100.0 * SUM(CAST(f.IsDelayed AS INT))/ NULLIF(COUNT(*), 0)
    , 2)AS QuoteProzent
FROM dbo.Fact_Sales    f
JOIN dbo.Dim_Customer  dc ON dc.SCDID_Customer = f.SCDID_Customer
WHERE f.ActualShippingDays IS NOT NULL
  AND dc.IsCurrent = 1
GROUP BY dc.City, dc.State
ORDER BY QuoteProzent DESC;
GO

-- 6c) Kombinations-Analyse: Kundenregion + Versandart
--     Zeigt welche Region-Carrier-Kombinationen besonders problematisch sind
SELECT
    dc.State  AS Bundesstaat,
    ds.ShipperName AS Lieferdienst,
    ds.ShippingMethod  AS Versandart,
    COUNT(*)  AS Sendungen,
    SUM(CAST(f.IsDelayed AS INT))  AS Verspaetet,
    ROUND(100.0 * SUM(CAST(f.IsDelayed AS INT))/ NULLIF(COUNT(*), 0), 2)   AS QuoteProzent,
    ROUND(AVG(CAST(f.DelayDays AS FLOAT)), 2)  AS AvgVerzuegerungTage
FROM dbo.Fact_Sales    f
JOIN dbo.Dim_Customer  dc ON dc.SCDID_Customer = f.SCDID_Customer
JOIN dbo.Dim_Shipper   ds ON ds.ShipperID      = f.ShipperID
WHERE f.ActualShippingDays IS NOT NULL
  AND dc.IsCurrent = 1
GROUP BY dc.State, ds.ShipperName, ds.ShippingMethod
HAVING COUNT(*) > 0
ORDER BY QuoteProzent DESC;
GO

