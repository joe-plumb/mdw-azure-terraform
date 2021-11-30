CREATE TABLE [dbo].[FactFinance-2010-02-01T00:00:00.000Z-2013-12-28T00:00:00] (
    [FinanceKey]         INT           NULL,
    [DateKey]            INT           NULL,
    [OrganizationKey]    INT           NULL,
    [DepartmentGroupKey] INT           NULL,
    [ScenarioKey]        INT           NULL,
    [AccountKey]         INT           NULL,
    [Amount]             FLOAT (53)    NULL,
    [Date]               DATETIME2 (7) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

