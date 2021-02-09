CREATE TABLE [dbo].[DimCustomer_SCD] (
    [CustomerKey]          INT              NULL,
    [GeographyKey]         INT              NULL,
    [CustomerAlternateKey] NVARCHAR (4000)  NULL,
    [Title]                NVARCHAR (4000)  NULL,
    [FirstName]            NVARCHAR (4000)  NULL,
    [LastName]             NVARCHAR (4000)  NULL,
    [NameStyle]            BIT              NULL,
    [BirthDate]            DATETIME2 (7)    NULL,
    [MaritalStatus]        NVARCHAR (4000)  NULL,
    [EmailAddress]         NVARCHAR (4000)  NULL,
    [YearlyIncome]         DECIMAL (38, 18) NULL,
    [TotalChildren]        INT              NULL,
    [NumberChildrenAtHome] INT              NULL,
    [EnglishEducation]     NVARCHAR (4000)  NULL,
    [StartDate]            DATETIME2 (7)    NULL,
    [EndDate]              DATETIME2 (7)    NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

