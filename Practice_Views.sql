--Problem 1: The "Clean Revenue" View The accounting team wants a simple way to see revenue without typing Quantity * UnitPrice every time.
--Create a View named v_OrderRevenue that shows DetailID, ProductID, and a calculated column TotalRevenue.
Create View OrderRevenue as
Select DetailID, ProductID, (Quantity*UnitPrice) as Total_Revenue
FROM OrderDetails;

--2.Write a SELECT statement to find all rows from the view (v_OrderRevenue) where the Total_Revenue is greater than 300.
Select * from OrderRevenue 
Where Total_Revenue > 100;
--Problem 3: The Growth View
--Take your "Percentage Growth" query and wrap it in a view called v_GrowthReport.
Create VIEW v_GrowthReport as
With Velocity AS(
SELECT DetailID, Quantity, COALESCE(Lag(Quantity) OVER (ORDER BY DetailID),0) as Previous_Ouantity
FROM OrderDetails
)

SELECT DetailID, Quantity, 
		Previous_Ouantity,
		CASE 
        WHEN Previous_Ouantity = 0 THEN 0
        ELSE (Quantity - Previous_Ouantity) * 100.0 / Previous_Ouantity
    END AS Growth_Percentage
FROM Velocity;

--4: Write the SQL command to create a basic index named idx_product on the ProductID column of the OrderDetails table.
CREATE INDEX idx_product_id 
ON OrderDetails (ProductID);

CREATE INDEX idx_order_product 
ON OrderDetails (OrderID, ProductID);

CREATE UNIQUE INDEX idx_unique_detail 
ON OrderDetails (DetailID);

--Let's Build the Scenario - List Comparison
-- Table A: What we have in the back room
CREATE TABLE Warehouse (
    ProductID INT,
    ProductName VARCHAR(50)
);

-- Table B: What is currently on the shelves
CREATE TABLE Storefront (
    ProductID INT,
    ProductName VARCHAR(50)
);

INSERT INTO Warehouse VALUES (1, 'Phone'), (2, 'Laptop'), (3, 'Chair'), (4, 'Desk');
INSERT INTO Storefront VALUES (1, 'Phone'), (2, 'Laptop'), (5, 'Lamp');
CREATE TABLE DefectiveItems (ProductName VARCHAR(50));
INSERT INTO DefectiveItems VALUES ('Chair'), ('Keyboard');

Select * from Storefront;
Select * from Warehouse;
Select * from DefectiveItems;

--Problem 1: The Master Inventory (UNION) The manager wants a single list of every product name we carry, whether it's in the warehouse, 
--the storefront, or both. Duplicate names should be removed.
--Task: Combine the ProductName from both tables using UNION.
SELECT ProductName FROM Storefront
UNION ALL
SELECT ProductName FROM Warehouse;

--2: The In-Stock Check (INTERSECT) We want to know which products are physically in the warehouse and also currently displayed on the storefront.
--Task: Use INTERSECT to find the names present in both tables.
SELECT ProductName FROM Storefront
INTERSECT
SELECT ProductName FROM Warehouse;

--3:The Restock Alert (EXCEPT / MINUS) We need to find products that are sitting in the warehouse but are missing from the storefront. 
--These are items we need to bring out to the shelves.
--Task: Use EXCEPT (or MINUS if you are on Oracle) to find what is in Warehouse but not in Storefront.
SELECT ProductName FROM Storefront
EXCEPT
SELECT ProductName FROM Warehouse;

--The Goal: Find all products that are in the Warehouse AND are NOT in the DefectiveItems list.
--How would you write that using EXCEPT?

SELECT ProductName FROM Warehouse 
EXCEPT
SELECT ProductName FROM DefectiveItems;

--Find a list of all products that are either in the Warehouse OR the Storefront, but EXCLUDE anything that is in the DefectiveItems table.
SELECT ProductName FROM Storefront
UNION
SELECT ProductName FROM Warehouse 
EXCEPT
SELECT ProductName FROM DefectiveItems;

--If the Storefront has a "Phone" and the Warehouse has a "Phone", which operation should you use if you want to count both of them to see your total stock?

--In a real database, if Storefront had 10 million rows, searching for a product by name would be slow. We need an Index to make it lightning-fast.
--Create an index named idx_product_name on the ProductName column of the Storefront table.

CREATE INDEX  idx_product_name 
ON Storefront(ProductName);

