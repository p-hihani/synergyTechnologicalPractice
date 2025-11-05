IF DB_ID('DelphiShop') IS NULL
BEGIN
    CREATE DATABASE DelphiShop;
END;

USE DelphiShop;

IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;

CREATE TABLE dbo.Products (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CONSTRAINT DF_Products_Price DEFAULT (0),
    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Products_CreatedAt DEFAULT (SYSUTCDATETIME())
);

INSERT INTO dbo.Products (Name, Price) VALUES
(N'Кофе', 3.50),
(N'Чай', 2.20),
(N'Печенье', 1.80);