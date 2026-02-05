CREATE TABLE CompetitorProducts (
    CompID INT,
    CompName VARCHAR(100)
);

INSERT INTO CompetitorProducts VALUES 
(1, 'phone  '),    -- Extra spaces & lowercase
(2, 'LAPTOP'),         -- All caps
(3, 'Tablet '),      -- New product
(4, 'CHAIR');          -- In both lists

--1. Write a query that finds all unique product names that exist in BOTH our Products table and the CompetitorProducts table.
Select * FROM Products p;
Select * FROM CompetitorProducts;
--If you run your query exactly as it is, ' phone ' and 'PHONE' will be seen as different items because of the spaces and the casing. To a database, a space is a character just like a letter.
--The "Pro" Cleanup Version
--We will use TRIM() to shave off the spaces and UPPER() to make sure the casing matches.
--Task: Let's rewrite your query using a CTE so it stays organized. Try to fill in the blanks:
WITH CleanCompetitor AS (
    SELECT DISTINCT 
        TRIM(UPPER(CompName)) AS CleanName 
    FROM CompetitorProducts
),
CleanOurProducts AS (
    SELECT DISTINCT 
        TRIM(UPPER(ProductName)) AS CleanName 
    FROM Products
)
-- Now use your Set Operation on the clean versions
SELECT CleanName FROM CleanOurProducts
INTERSECT
SELECT CleanName FROM CleanCompetitor;

--Combine the ProductName from our table and the CompName from theirs into one big list (Clean them first!). 2. Use a Window Function (ROW_NUMBER) 
--to give every unique product a number based on its alphabetical order.
WITH FULLDATA as (SELECT TRIM(UPPER(ProductName)) as ProdName
FROM Products
UNION 
SELECT TRIM(UPPER(CompName))
FROM CompetitorProducts)
 SELECT ROW_NUMBER() OVER(Order By ProdName) as ProdNum, *
 FROM FULLDATA;
--The Scenario: Imagine our CompetitorProducts table now has a column called SkuCode that looks like this: ID_123_PHONE, ID_456_LAPTOP.
--The Goal: You only want the number in the middle (e.g., 123 or 456).
WITH FULLDATA AS (
    SELECT TRIM(UPPER(ProductName)) AS ProdName
    FROM Products
    UNION
    SELECT TRIM(UPPER(CompName))
    FROM CompetitorProducts
)
SELECT 
    ROW_NUMBER() OVER(ORDER BY ProdName) AS ProdNum,
    -- We use CONCAT here, and LOWER to make the name look nicer
    CONCAT('Product: ', ProdName) AS DisplayName
FROM FULLDATA;

--Can you modify the SELECT above to add one more column that shows the number of characters in each ProdName?

WITH FULLDATA AS (
    SELECT TRIM(UPPER(ProductName)) AS ProdName
    FROM Products
    UNION
    SELECT TRIM(UPPER(CompName))
    FROM CompetitorProducts
)
SELECT 
    ROW_NUMBER() OVER( ORDER BY ProdName) AS ProdNum,
    -- We use CONCAT here, and LOWER to make the name look nicer
    CONCAT('Product: ', ProdName) AS DisplayName, LENGTH(ProdName) as Char_Len
FROM FULLDATA;

--Imagine your Products table and CompetitorProducts table have different naming conventions. Your company uses a 3-letter prefix
--(like FUR for Furniture, ELE for Electronics).

WITH FULLDATA AS (
    SELECT TRIM(UPPER(ProductName)) AS ProdName
    FROM Products
    UNION
    SELECT TRIM(UPPER(CompName))
    FROM CompetitorProducts
)
SELECT 
    ROW_NUMBER() OVER( ORDER BY ProdName) AS ProdNum,
    -- We use CONCAT here, and LOWER to make the name look nicer
    CONCAT('Product: ', ProdName) AS DisplayName, LENGTH(ProdName) as Char_Len,
    SUBSTRING(ProdName, 1, 3) as CategoryCode
FROM FULLDATA;

