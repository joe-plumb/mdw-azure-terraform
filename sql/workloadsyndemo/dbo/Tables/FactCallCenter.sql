CREATE TABLE [dbo].[FactCallCenter] (
    [FactCallCenterID]    INT             NULL,
    [DateKey]             INT             NULL,
    [WageType]            NVARCHAR (4000) NULL,
    [Shift]               NVARCHAR (4000) NULL,
    [LevelOneOperators]   INT             NULL,
    [LevelTwoOperators]   INT             NULL,
    [TotalOperators]      INT             NULL,
    [Calls]               INT             NULL,
    [AutomaticResponses]  INT             NULL,
    [Orders]              INT             NULL,
    [IssuesRaised]        INT             NULL,
    [AverageTimePerIssue] INT             NULL,
    [ServiceGrade]        FLOAT (53)      NULL,
    [Date]                DATETIME2 (7)   NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

