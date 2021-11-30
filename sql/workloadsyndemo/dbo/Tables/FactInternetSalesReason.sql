CREATE TABLE [dbo].[FactInternetSalesReason] (
    [SalesOrderNumber]     NVARCHAR (4000) NULL,
    [SalesOrderLineNumber] INT             NULL,
    [SalesReasonKey]       INT             NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

