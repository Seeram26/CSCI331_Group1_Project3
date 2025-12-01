CREATE TYPE VehicleInformation.StockCode FROM NVARCHAR(50);
CREATE TYPE VehicleInformation.Color FROM NVARCHAR(50);
CREATE TYPE VehicleInformation.BuyerComments FROM NVARCHAR(4000);
GO
CREATE TABLE OperationsManagement.Stock (
    StockCode VehicleInformation.StockCode NOT NULL
        CONSTRAINT PK_Stock PRIMARY KEY,

    ModelID VehicleInformation.ModelID NOT NULL
        CONSTRAINT DF_Stock_Model DEFAULT (-1),

    Cost FinancialInformation.Amount NOT NULL
        CONSTRAINT DF_Stock_Cost DEFAULT (0.00)
        CONSTRAINT CHK_Stock_Cost CHECK (Cost >= 0),

    RepairsCost FinancialInformation.Amount NOT NULL
        CONSTRAINT DF_Stock_RepairsCost DEFAULT (0.00)
        CONSTRAINT CHK_Stock_RepairsCost CHECK (RepairsCost >= 0),

    PartsCost FinancialInformation.Amount NOT NULL
        CONSTRAINT DF_Stock_PartsCost DEFAULT (0.00)
        CONSTRAINT CHK_Stock_PartsCost CHECK (PartsCost >= 0),

    TransportInCost FinancialInformation.Amount NOT NULL
        CONSTRAINT DF_Stock_TransportInCost DEFAULT (0.00)
        CONSTRAINT CHK_Stock_TransportInCost CHECK (TransportInCost >= 0),

    IsRHD PII.BooleanFlag NOT NULL
        CONSTRAINT DF_Stock_IsRHD DEFAULT (0)
        CONSTRAINT CHK_Stock_IsRHD CHECK (IsRHD IN (0,1)),

    Color VehicleInformation.Color NOT NULL
        CONSTRAINT DF_Stock_Color DEFAULT ('Unknown'),

    BuyerComments VehicleInformation.BuyerComments NOT NULL
        CONSTRAINT DF_Stock_BuyerComments DEFAULT ('No Comment'),

    DateBought DATE NOT NULL
        CONSTRAINT DF_Stock_DateBought DEFAULT ('1900-01-01'),

    TimeBought TIME NOT NULL
        CONSTRAINT DF_Stock_TimeBought DEFAULT ('00:00:00'),

    ReviewRow ELTInformation.ReviewRow NOT NULL
        CONSTRAINT DF_Stock_ReviewRow DEFAULT (0)
);
GO

INSERT INTO OperationsManagement.Stock (
    StockCode, ModelID, Cost, RepairsCost, PartsCost, TransportInCost,
    IsRHD, Color, BuyerComments, DateBought, TimeBought, ReviewRow
)
SELECT
    COALESCE(s.StockCode, 'Unknown'),
    COALESCE(s.ModelID, -1),
    COALESCE(CAST(s.Cost AS DECIMAL(18,2)), 0.00),
    COALESCE(CAST(s.RepairsCost AS DECIMAL(18,2)), 0.00),
    COALESCE(CAST(s.PartsCost AS DECIMAL(18,2)), 0.00),
    COALESCE(CAST(s.TransportInCost AS DECIMAL(18,2)), 0.00),
    COALESCE(s.IsRHD, 0),
    COALESCE(s.Color, 'Unknown'),
    COALESCE(s.BuyerComments, 'No Comment'),
    COALESCE(s.DateBought, '1900-01-01'),
    COALESCE(s.TimeBought, '00:00:00'),

    CASE
        WHEN (
            (CASE WHEN s.StockCode IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.ModelID IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.Cost IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.RepairsCost IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.PartsCost IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.TransportInCost IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.IsRHD IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.Color IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.BuyerComments IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.DateBought IS NULL THEN 1 ELSE 0 END) +
            (CASE WHEN s.TimeBought IS NULL THEN 1 ELSE 0 END)
        ) > 0 THEN 1
        ELSE 0
    END AS ReviewRow

FROM PrestigeCars.Data.Stock AS s;
GO
