-- 2409000328 LANDRY GASASIRA SHINGIRO MUGABE
create database inventory_managment_system;
-- create a user
create user 'landry'@'127.0.0.1' identified by '2409000328';
grant all privileges on inventory_managment_system .* to 'landry'@'127.0.0.1';

flush privileges; 

use inventory_managment_system;
-- create tables
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL,
    Description TEXT
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    SKU VARCHAR(50) UNIQUE NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE Location (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    LocationName VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    ContactInfo VARCHAR(100)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    LocationID INT,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    ReorderLevel INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
);

CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(100) NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE PurchaseOrder (
    PurchaseOrderID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierID INT,
    OrderDate DATETIME NOT NULL,
    ExpectedDeliveryDate DATETIME,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE PurchaseOrderDetail (
    PurchaseOrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (PurchaseOrderID, ProductID),
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrder(PurchaseOrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    ContactInfo VARCHAR(100) NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE SalesOrder (
    SalesOrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE SalesOrderDetail (
    SalesOrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (SalesOrderID, ProductID),
    FOREIGN KEY (SalesOrderID) REFERENCES SalesOrder(SalesOrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- insert into tables
INSERT INTO Category (CategoryName, Description)
VALUES 
('Electronics', 'Devices and gadgets'),
('Clothing', 'Apparel and accessories'),
('Furniture', 'Home and office furniture');

INSERT INTO Product (Name, Description, SKU, UnitPrice, CategoryID)
VALUES 
('Smartphone', 'Latest model with 128GB storage', 'SM12345', 699.99, 1),
('Laptop', '15-inch laptop with 8GB RAM', 'LP67890', 999.99, 1),
('T-Shirt', 'Cotton t-shirt, size M', 'TS12345', 19.99, 2),
('Office Chair', 'Ergonomic office chair', 'OC67890', 199.99, 3);

INSERT INTO Location (LocationName, Address, ContactInfo)
VALUES 
('Warehouse A', '123 Main St, City A', '555-1234'),
('Warehouse B', '456 Elm St, City B', '555-5678');

INSERT INTO Inventory (ProductID, LocationID, Quantity, ReorderLevel)
VALUES 
(1, 1, 50, 10),  -- Smartphone in Warehouse A
(2, 1, 30, 5),   -- Laptop in Warehouse A
(3, 2, 100, 20), -- T-Shirt in Warehouse B
(4, 2, 20, 5);   -- Office Chair in Warehouse B

INSERT INTO Supplier (SupplierName, ContactInfo, Address)
VALUES 
('Tech Supplier Inc.', '555-9876', '789 Tech St, City C'),
('Apparel Supplier Co.', '555-5432', '321 Fashion St, City D'),
('Furniture Supplier Ltd.', '555-8765', '654 Home St, City E');

INSERT INTO PurchaseOrder (SupplierID, OrderDate, ExpectedDeliveryDate, TotalAmount)
VALUES 
(1, '2023-10-01', '2023-10-10', 5000.00),  -- Order from Tech Supplier Inc.
(2, '2023-10-02', '2023-10-12', 1000.00),  -- Order from Apparel Supplier Co.
(3, '2023-10-03', '2023-10-15', 2000.00);  -- Order from Furniture Supplier Ltd.

INSERT INTO PurchaseOrderDetail (PurchaseOrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 10, 699.99),  -- 10 Smartphones in Purchase Order 1
(1, 2, 5, 999.99),   -- 5 Laptops in Purchase Order 1
(2, 3, 50, 19.99),   -- 50 T-Shirts in Purchase Order 2
(3, 4, 10, 199.99);  -- 10 Office Chairs in Purchase Order 3

INSERT INTO Customer (CustomerName, ContactInfo, Address)
VALUES 
('John Doe', '555-1111', '123 Customer St, City F'),
('Jane Smith', '555-2222', '456 Client St, City G');

INSERT INTO SalesOrder (CustomerID, OrderDate, TotalAmount)
VALUES 
(1, '2023-10-05', 1399.98),  -- Order from John Doe
(2, '2023-10-06', 199.99);   -- Order from Jane Smith

INSERT INTO SalesOrderDetail (SalesOrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 2, 699.99),  -- 2 Smartphones in Sales Order 1
(2, 4, 1, 199.99);  -- 1 Office Chair in Sales Order 2

-- select
-- Select all products with a price greater than $500
SELECT * FROM Product WHERE UnitPrice > 500;

-- Select all products in the 'Electronics' category
SELECT * FROM Product p
JOIN Category c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Electronics';

-- Select all inventory items with a quantity less than or equal to the reorder level
SELECT * FROM Inventory WHERE Quantity <= ReorderLevel;

-- Select all purchase orders placed on a specific date (e.g., '2023-10-01')
SELECT * FROM PurchaseOrder WHERE OrderDate = '2023-10-01';

-- Select all sales orders for a specific customer (e.g., CustomerID = 1)
SELECT * FROM SalesOrder WHERE CustomerID = 1;

-- Select all products supplied by a specific supplier (e.g., SupplierID = 1)
SELECT p.* FROM Product p
JOIN PurchaseOrderDetail pod ON p.ProductID = pod.ProductID
JOIN PurchaseOrder po ON pod.PurchaseOrderID = po.PurchaseOrderID
WHERE po.SupplierID = 1;

-- Select the names and quantities of products in a specific location (e.g., LocationID = 1)
SELECT p.Name, i.Quantity FROM Product p
JOIN Inventory i ON p.ProductID = i.ProductID
WHERE i.LocationID = 1;

-- Select all customers who live in a specific city (you'd need to add a City column to the Customer table for this)
-- Assuming you add a 'City' column:
-- SELECT * FROM Customer WHERE City = 'City F';  -- Replace 'City F' with the actual city name


-- Select all sales orders with a total amount greater than $1000
SELECT * FROM SalesOrder WHERE TotalAmount > 1000;

-- Select the product name and quantity for all items in a specific purchase order (e.g., PurchaseOrderID = 1)
SELECT p.Name, pod.Quantity FROM Product p
JOIN PurchaseOrderDetail pod ON p.ProductID = pod.ProductID
WHERE pod.PurchaseOrderID = 1;

-- Select the customer name and total amount for all sales orders placed on a specific date (e.g., '2023-10-05')
SELECT c.CustomerName, so.TotalAmount FROM Customer c
JOIN SalesOrder so ON c.CustomerID = so.CustomerID
WHERE so.OrderDate = '2023-10-05';

-- Select all products that have never been sold (This is a bit more complex and requires a subquery or a LEFT JOIN)
SELECT * FROM Product WHERE ProductID NOT IN (SELECT ProductID FROM SalesOrderDetail);

-- Or using LEFT JOIN:
SELECT p.* FROM Product p
LEFT JOIN SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;


-- Select all suppliers who have supplied products with a unit price greater than $200
SELECT DISTINCT s.* FROM Supplier s
JOIN PurchaseOrder po ON s.SupplierID = po.SupplierID
JOIN PurchaseOrderDetail pod ON po.PurchaseOrderID = pod.PurchaseOrderID
WHERE pod.UnitPrice > 200;

-- Select all locations that have at least 50 units of any product in stock
SELECT DISTINCT l.* FROM Location l
JOIN Inventory i ON l.LocationID = i.LocationID
WHERE i.Quantity >= 50;

-- Select the top 5 customers who have spent the most money (This requires aggregation and limiting)
SELECT c.CustomerName, SUM(so.TotalAmount) AS TotalSpent
FROM Customer c
JOIN SalesOrder so ON c.CustomerID = so.CustomerID
GROUP BY c.CustomerName
ORDER BY TotalSpent DESC
LIMIT 5;

-- update tables
UPDATE Category
SET 
    CategoryName = 'New Category Name', 
    Description = 'Updated description of the category'
WHERE CategoryID = 2;

UPDATE Product
SET 
    Name = 'New Product Name', 
    Description = 'Updated product description',
    SKU = 'NEW-SKU-12345', 
    UnitPrice = 29.99, 
    CategoryID = 2
WHERE ProductID = 1;

UPDATE Location
SET 
    LocationName = 'New Warehouse Location', 
    Address = 'New Address, City, Country', 
    ContactInfo = 'new.contact@location.com'
WHERE LocationID = 1;

UPDATE Inventory
SET 
    Quantity = 50, 
    ReorderLevel = 10
WHERE InventoryID = 1;

UPDATE Supplier
SET 
    SupplierName = 'New Supplier Name', 
    ContactInfo = 'new.contact@supplier.com', 
    Address = 'New Address, City, Country'
WHERE SupplierID = 1;

UPDATE PurchaseOrder
SET 
    ExpectedDeliveryDate = '2025-02-15 10:00:00',
    TotalAmount = 1500.50
WHERE PurchaseOrderID = 1;

UPDATE PurchaseOrderDetail
SET 
    Quantity = 100, 
    UnitPrice = 18.50
WHERE PurchaseOrderID = 1 AND ProductID = 2;

UPDATE Customer
SET 
    CustomerName = 'John Doe', 
    ContactInfo = 'john.doe@example.com', 
    Address = '123 New Street, City, Country'
WHERE CustomerID = 1;

UPDATE SalesOrderDetail
SET 
    Quantity = 5, 
    UnitPrice = 50.00
WHERE SalesOrderID = 1 AND ProductID = 3;

UPDATE PurchaseOrderDetail
SET 
    Quantity = 100, 
    UnitPrice = 18.50
WHERE PurchaseOrderID = 1 AND ProductID = 2;

-- create views
CREATE VIEW InventoryStatus AS
SELECT 
    p.Name AS ProductName,
    i.Quantity,
    i.ReorderLevel,
    l.LocationName
FROM 
    Inventory i
JOIN 
    Product p ON i.ProductID = p.ProductID
JOIN 
    Location l ON i.LocationID = l.LocationID;
    
    CREATE VIEW SalesSummary AS
SELECT 
    c.CustomerName,
    so.OrderDate,
    so.TotalAmount
FROM 
    SalesOrder so
JOIN 
    Customer c ON so.CustomerID = c.CustomerID;
    
 CREATE VIEW SupplierOrders AS
SELECT 
    s.SupplierName,
    po.OrderDate,
    po.ExpectedDeliveryDate,
    po.TotalAmount
FROM 
    PurchaseOrder po
JOIN 
    Supplier s ON po.SupplierID = s.SupplierID;
    
    CREATE VIEW LowInventory AS
SELECT 
    p.Name AS ProductName,
    i.Quantity,
    i.ReorderLevel,
    l.LocationName
FROM 
    Inventory i
JOIN 
    Product p ON i.ProductID = p.ProductID
JOIN 
    Location l ON i.LocationID = l.LocationID
WHERE 
    i.Quantity <= i.ReorderLevel;
    
    CREATE VIEW PurchaseOrderDetails AS
SELECT 
    po.PurchaseOrderID,
    p.Name AS ProductName,
    pod.Quantity,
    pod.UnitPrice
FROM 
    PurchaseOrderDetail pod
JOIN 
    Product p ON pod.ProductID = p.ProductID
JOIN 
    PurchaseOrder po ON pod.PurchaseOrderID = po.PurchaseOrderID;
    
    -- create procedures
    DELIMITER //
CREATE PROCEDURE AddNewProduct(
    IN p_Name VARCHAR(100),
    IN p_Description TEXT,
    IN p_SKU VARCHAR(50),
    IN p_UnitPrice DECIMAL(10, 2),
    IN p_CategoryID INT
)
BEGIN
    INSERT INTO Product (Name, Description, SKU, UnitPrice, CategoryID)
    VALUES (p_Name, p_Description, p_SKU, p_UnitPrice, p_CategoryID);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateInventoryLevel(
    IN p_ProductID INT,
    IN p_LocationID INT,
    IN p_Quantity INT
)
BEGIN
    UPDATE Inventory
    SET Quantity = p_Quantity
    WHERE ProductID = p_ProductID AND LocationID = p_LocationID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CreatePurchaseOrder(
    IN p_SupplierID INT,
    IN p_OrderDate DATETIME,
    IN p_ExpectedDeliveryDate DATETIME,
    IN p_TotalAmount DECIMAL(10, 2)
)
BEGIN
    INSERT INTO PurchaseOrder (SupplierID, OrderDate, ExpectedDeliveryDate, TotalAmount)
    VALUES (p_SupplierID, p_OrderDate, p_ExpectedDeliveryDate, p_TotalAmount);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE CreateSalesOrder(
    IN p_CustomerID INT,
    IN p_OrderDate DATETIME,
    IN p_TotalAmount DECIMAL(10, 2)
)
BEGIN
    INSERT INTO SalesOrder (CustomerID, OrderDate, TotalAmount)
    VALUES (p_CustomerID, p_OrderDate, p_TotalAmount);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdatePurchaseOrderQuantity(
    IN p_PurchaseOrderID INT,
    IN p_ProductID INT,
    IN p_NewQuantity INT
)
BEGIN
    UPDATE PurchaseOrderDetail
    SET Quantity = p_NewQuantity
    WHERE PurchaseOrderID = p_PurchaseOrderID AND ProductID = p_ProductID;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER UpdateInventoryOnSale
AFTER INSERT ON SalesOrderDetail
FOR EACH ROW
BEGIN
    UPDATE Inventory
    SET Quantity = Quantity - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER UpdateInventoryOnPurchase
AFTER INSERT ON PurchaseOrderDetail
FOR EACH ROW
BEGIN
    UPDATE Inventory
    SET Quantity = Quantity + NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END //
DELIMITER ;

-- create triggers
DELIMITER //
CREATE TRIGGER CheckLowInventoryBeforeSale
BEFORE INSERT ON SalesOrderDetail
FOR EACH ROW
BEGIN
    DECLARE v_Quantity INT;
    DECLARE v_ReorderLevel INT;
    
    SELECT Quantity, ReorderLevel INTO v_Quantity, v_ReorderLevel
    FROM Inventory
    WHERE ProductID = NEW.ProductID;
    
    IF v_Quantity - NEW.Quantity < v_ReorderLevel THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inventory is below reorder level, sale cannot be processed.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER PreventNegativeInventory
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.Quantity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inventory quantity cannot be negative.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER AutoUpdateReorderLevel
AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.Quantity < NEW.ReorderLevel THEN
        UPDATE Inventory
        SET ReorderLevel = NEW.Quantity
        WHERE ProductID = NEW.ProductID AND LocationID = NEW.LocationID;
    END IF;
END //
DELIMITER ;












   


