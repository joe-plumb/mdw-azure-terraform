CREATE TABLE [dbo].[NewFactCurrencyRate] (
    [AverageRate]  REAL            NULL,
    [CurrencyID]   NVARCHAR (4000) NULL,
    [CurrencyDate] DATETIME2 (7)   NULL,
    [EndOfDayRate] REAL            NULL,
    [CurrencyKey]  INT             NULL,
    [DateKey]      INT             NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

