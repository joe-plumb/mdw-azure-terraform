﻿CREATE TABLE [dbo].[DimCustomer] (
    [CustomerKey]          INT              NULL,
    [GeographyKey]         INT              NULL,
    [CustomerAlternateKey] NVARCHAR (4000)  NULL,
    [Title]                NVARCHAR (4000)  NULL,
    [FirstName]            NVARCHAR (4000)  NULL,
    [MiddleName]           NVARCHAR (4000)  NULL,
    [LastName]             NVARCHAR (4000)  NULL,
    [NameStyle]            BIT              NULL,
    [BirthDate]            DATETIME2 (7)    NULL,
    [MaritalStatus]        NVARCHAR (4000)  NULL,
    [Suffix]               NVARCHAR (4000)  NULL,
    [Gender]               NVARCHAR (4000)  NULL,
    [EmailAddress]         NVARCHAR (4000)  NULL,
    [YearlyIncome]         DECIMAL (38, 18) NULL,
    [TotalChildren]        INT              NULL,
    [NumberChildrenAtHome] INT              NULL,
    [EnglishEducation]     NVARCHAR (4000)  NULL,
    [SpanishEducation]     NVARCHAR (4000)  NULL,
    [FrenchEducation]      NVARCHAR (4000)  NULL,
    [EnglishOccupation]    NVARCHAR (4000)  NULL,
    [SpanishOccupation]    NVARCHAR (4000)  NULL,
    [FrenchOccupation]     NVARCHAR (4000)  NULL,
    [HouseOwnerFlag]       NVARCHAR (4000)  NULL,
    [NumberCarsOwned]      INT              NULL,
    [AddressLine1]         NVARCHAR (4000)  NULL,
    [AddressLine2]         NVARCHAR (4000)  NULL,
    [Phone]                NVARCHAR (4000)  NULL,
    [DateFirstPurchase]    DATETIME2 (7)    NULL,
    [CommuteDistance]      NVARCHAR (4000)  NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

