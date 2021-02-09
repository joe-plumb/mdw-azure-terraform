CREATE TABLE [dbo].[DimAccount] (
    [AccountKey]                    INT             NULL,
    [ParentAccountKey]              INT             NULL,
    [AccountCodeAlternateKey]       INT             NULL,
    [ParentAccountCodeAlternateKey] INT             NULL,
    [AccountDescription]            NVARCHAR (4000) NULL,
    [AccountType]                   NVARCHAR (4000) NULL,
    [Operator]                      NVARCHAR (4000) NULL,
    [CustomMembers]                 NVARCHAR (4000) NULL,
    [ValueType]                     NVARCHAR (4000) NULL,
    [CustomMemberOptions]           NVARCHAR (4000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

