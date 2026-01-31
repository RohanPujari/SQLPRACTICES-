-- 1. Create the Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50)
);

-- 2. Create the OrderDetails Table
CREATE TABLE OrderDetails (
    DetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 3. Insert Sample Data
INSERT INTO Products VALUES (1, 'Phone', 'Electronics'), (2, 'Laptop', 'Electronics'), (3, 'Chair', 'Furniture');

INSERT INTO OrderDetails (DetailID, OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 101, 1, 2, 500.00),
(2, 101, 3, 1, 150.00),
(3, 102, 2, 1, 1200.00),
(4, 103, 1, 1, 500.00),
(5, 104, 3, 4, 150.00);