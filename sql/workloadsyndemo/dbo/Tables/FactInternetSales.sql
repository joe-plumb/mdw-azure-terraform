﻿CREATE TABLE [dbo].[FactInternetSales] (
    [ProductKey]            INT              NULL,
    [OrderDateKey]          INT              NULL,
    [DueDateKey]            INT              NULL,
    [ShipDateKey]           INT              NULL,
    [CustomerKey]           INT              NULL,
    [PromotionKey]          INT              NULL,
    [CurrencyKey]           INT              NULL,
    [SalesTerritoryKey]     INT              NULL,
    [SalesOrderNumber]      NVARCHAR (4000)  NULL,
    [SalesOrderLineNumber]  INT              NULL,
    [RevisionNumber]        INT              NULL,
    [OrderQuantity]         INT              NULL,
    [UnitPrice]             DECIMAL (38, 18) NULL,
    [ExtendedAmount]        DECIMAL (38, 18) NULL,
    [UnitPriceDiscountPct]  FLOAT (53)       NULL,
    [DiscountAmount]        FLOAT (53)       NULL,
    [ProductStandardCost]   DECIMAL (38, 18) NULL,
    [TotalProductCost]      DECIMAL (38, 18) NULL,
    [SalesAmount]           DECIMAL (38, 18) NULL,
    [TaxAmt]                DECIMAL (38, 18) NULL,
    [Freight]               DECIMAL (38, 18) NULL,
    [CarrierTrackingNumber] NVARCHAR (4000)  NULL,
    [CustomerPONumber]      NVARCHAR (4000)  NULL,
    [OrderDate]             DATETIME2 (7)    NULL,
    [DueDate]               DATETIME2 (7)    NULL,
    [ShipDate]              DATETIME2 (7)    NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);
