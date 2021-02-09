CREATE TABLE [dbo].[FactCurrencyRate] (
    [CurrencyKey]  INT           NULL,
    [DateKey]      INT           NULL,
    [AverageRate]  FLOAT (53)    NULL,
    [EndOfDayRate] FLOAT (53)    NULL,
    [Date]         DATETIME2 (7) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

