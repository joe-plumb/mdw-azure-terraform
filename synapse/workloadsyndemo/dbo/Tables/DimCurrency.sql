CREATE TABLE [dbo].[DimCurrency] (
    [CurrencyKey]          INT             NULL,
    [CurrencyAlternateKey] NVARCHAR (4000) NULL,
    [CurrencyName]         NVARCHAR (4000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

