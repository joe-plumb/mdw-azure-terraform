CREATE TABLE [dbo].[Table1]
(
    col1 int NOT NULL
)
WITH
(
    DISTRIBUTION = HASH (col1),
    CLUSTERED COLUMNSTORE INDEX
)
GO
