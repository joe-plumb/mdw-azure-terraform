CREATE TABLE [dbo].[FactSalesQuota] (
    [SalesQuotaKey]    INT              NULL,
    [EmployeeKey]      INT              NULL,
    [DateKey]          INT              NULL,
    [CalendarYear]     INT              NULL,
    [CalendarQuarter]  INT              NULL,
    [SalesAmountQuota] DECIMAL (38, 18) NULL,
    [Date]             DATETIME2 (7)    NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

