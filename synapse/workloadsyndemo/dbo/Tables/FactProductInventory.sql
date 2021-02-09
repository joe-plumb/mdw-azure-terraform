CREATE TABLE [dbo].[FactProductInventory] (
    [ProductKey]   INT              NULL,
    [DateKey]      INT              NULL,
    [MovementDate] DATETIME2 (7)    NULL,
    [UnitCost]     DECIMAL (38, 18) NULL,
    [UnitsIn]      INT              NULL,
    [UnitsOut]     INT              NULL,
    [UnitsBalance] INT              NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

