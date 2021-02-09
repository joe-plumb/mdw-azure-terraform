CREATE TABLE [dbo].[FactSurveyResponse] (
    [SurveyResponseKey]             INT             NULL,
    [DateKey]                       INT             NULL,
    [CustomerKey]                   INT             NULL,
    [ProductCategoryKey]            INT             NULL,
    [EnglishProductCategoryName]    NVARCHAR (4000) NULL,
    [ProductSubcategoryKey]         INT             NULL,
    [EnglishProductSubcategoryName] NVARCHAR (4000) NULL,
    [Date]                          DATETIME2 (7)   NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

