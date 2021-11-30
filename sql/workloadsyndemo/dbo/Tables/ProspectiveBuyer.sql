CREATE TABLE [dbo].[ProspectiveBuyer] (
    [ProspectiveBuyerKey]  INT              NULL,
    [ProspectAlternateKey] NVARCHAR (4000)  NULL,
    [FirstName]            NVARCHAR (4000)  NULL,
    [MiddleName]           NVARCHAR (4000)  NULL,
    [LastName]             NVARCHAR (4000)  NULL,
    [BirthDate]            DATETIME2 (7)    NULL,
    [MaritalStatus]        NVARCHAR (4000)  NULL,
    [Gender]               NVARCHAR (4000)  NULL,
    [EmailAddress]         NVARCHAR (4000)  NULL,
    [YearlyIncome]         DECIMAL (38, 18) NULL,
    [TotalChildren]        INT              NULL,
    [NumberChildrenAtHome] INT              NULL,
    [Education]            NVARCHAR (4000)  NULL,
    [Occupation]           NVARCHAR (4000)  NULL,
    [HouseOwnerFlag]       NVARCHAR (4000)  NULL,
    [NumberCarsOwned]      INT              NULL,
    [AddressLine1]         NVARCHAR (4000)  NULL,
    [AddressLine2]         NVARCHAR (4000)  NULL,
    [City]                 NVARCHAR (4000)  NULL,
    [StateProvinceCode]    NVARCHAR (4000)  NULL,
    [PostalCode]           NVARCHAR (4000)  NULL,
    [Phone]                NVARCHAR (4000)  NULL,
    [Salutation]           NVARCHAR (4000)  NULL,
    [Unknown]              INT              NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

