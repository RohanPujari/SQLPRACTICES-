--*Practice Questions 2*
--Question 1: The "Loyalty Status" Report. The store manager wants a list of all customers.
--If a customer has spent more than $100 in total (across all their orders), label them as 'VIP'.
--If they have spent between $50 and $100, label them as 'Frequent'.
--If they have spent less than $50, label them as 'Regular'.
--Your Task: Show the FirstName, LastName, Total Spent, and their Loyalty_Status.

Select CASE WHEN SUM(o.TotalAmount) > 100 THEN 'VIP'
WHEN SUM(o.TotalAmount) >=50 AND SUM(o.TotalAmount)<100 THEN 'Frequent'
WHEN SUM(o.TotalAmount) <50 THEN 'Regular'
END as Loyality_status, c.FirstName, c.LastName, SUM(o.TotalAmount) AS  Total_Spent
FROM Orders o 
JOIN Customers c 
ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName , c.LastName;

--Question 2:
--The manager wants to see how much more expensive each book is compared to the cheapest book in the same category.
--The Goal: Show the Title, Category, Price, and a column called Difference_From_Cheapest.
SELECT Title, Category, Price, Price - MIN(Price) OVER (PARTITION BY Category) AS Difference_From_Cheapest
FROM Books;

--Questino 3:
--The Goal: Find the Title of every book that has zero sales (it does not exist in the Orders table).
Select b.Title
FROM Books b
LEFT JOIN Orders o 
On b.BookID = o.BookID 
WHERE OrderID IS NULL;

--Questions 4:
--Show the Category, the Total Stock Quantity for that category, and a third column showing what Percentage 
--of the total store inventory that category represents.
WITH CategoryTotals AS (
    SELECT Category, SUM(StockQuantity) as CatSum
    FROM Books
    GROUP BY Category
)
SELECT Category, CatSum, (CatSum * 100.0) / SUM(CatSum) OVER() AS Percentage
FROM CategoryTotals; 

--5. The Goal: Show CustomerName, their Total Spent in the last 30 days, and their Lifetime Total Spent.

Select c.FirstName, SUM(CASE WHEN o.OrderDate >='2025-12-20' THEN o.TotalAmount ELSE 0 END) AS Recent_Total, 
SUM(o.TotalAmount) AS LifeTime_Total
FROM Customers c 
JOIN Orders o 
ON o.CustomerID = c.CustomerID
GROUP BY c.FirstName;

--6. Sometimes data gets messy. Find if there are any Book Titles that appear more than once in our Books table.
--The Goal: List only the Titles that have duplicates and how many times they appear.

Select b.Title,Count(b.Title) as Book_Counts
FROM Books b 
GROUP BY b.Title
Having Count(b.Title) >1 ;


--Question 7 of 20: The "Top 3 Sales" (Ranking Mix)
--We want to see a list of our Top 3 most expensive orders, but we want to include the Customer's Last Name.
--Subquery
Select * 
FROM (Select o.TotalAmount, c.Lastname, RANK() OVER(order by o.TotalAmount DESC) as Top3_rank
FROM Orders o 
JOIN Customers c 
ON c.CustomerID = o.CustomerID)
Where Top3_rank <= 3;

--CTE
With TOP_Ranks AS
(Select o.TotalAmount, c.Lastname, RANK() OVER(order by o.TotalAmount DESC) as Top3_rank
FROM Orders o
JOIN Customers c
ON c.CustomerID = o.CustomerID)
Select * from TOP_Ranks
Where Top3_rank <=3;

--The Goal: Show each Author's LastName and the count of unique categories they write in.
Select (a.LastName), COUNT(DISTINCT b.Category) as UNIQUE_Cat
FROM Authors a 
JOIN Books b 
ON a.AuthorID = b.AuthorID
GROUP BY a.LastName;
--If the manager asks: "How many books did he write?"
--You use COUNT(Category). The answer is 3.
--If the manager asks: "How many different categories does he write in?"
--You use COUNT(DISTINCT Category). Even though there are 3 books, they are all the same category. The answer is 1.
--**Whenever you see the word "How many different..." or "How many unique...", your brain should immediately think: COUNT(DISTINCT column_name).

--9. The Goal: Show the Month Number and the Total Revenue (Sum of TotalAmount) for that month.
SELECT STRFTIME('%m', o.OrderDate) as Month_Number, SUm(o.TotalAmount) as Total_Revenue
FROM Orders o
GROUP BY Month_Number;

--10. Show each Category and a Status. Sum the StockQuantity for the category.
--If the sum is < 10 → 'CRITICAL'
--If the sum is 10 - 30 → 'LOW'
--Else → 'OK'

Select Category, CASE
	WHEN SUM(StockQuantity) <10 then 'CRITICAL'
	WHEN SUM(StockQuantity)>10 and SUM(StockQuantity)<= 30 then 'LOW'
	ELSE 'OK'
END as Status, SUM(b.StockQuantity)
FROM Books b 
GROUP BY b.Category;

--11.The manager wants to see the Title of the most expensive book we have.

SELECT b.Title, Max(b.Price)
FROM Books b;

--12. Find the FirstName and LastName of all customers who have placed an order worth more than $100.
Select *, c.FirstName, c.LastName
FROM Customers c 
LEFT JOIN Orders o 
ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount > '100';

--Subquery
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM Orders 
    WHERE TotalAmount > 100
);

-- 13.The manager wants a list of Categories where the average price of books in that category is greater than $15.
Select Category, AVG(b.Price) as average_price 
FROM Books b 
GROUP BY b.Category 
Having AVG(b.Price) > 15

--14. The Goal: Show the Title, the Current StockQuantity, and a new calculated column called Expected_Stock 
--which is the current stock multiplied by 2.
SELECT b.Title, b.StockQuantity, b.StockQuantity*2 as  Expected_Stock
FROM Books b

-- 15List the Title and the character count of that title. Only show titles longer than 20 characters.
Select b.title, LENGTH(b.Title) as Title_Length
FROM Books b 
WHERE LENGTH(b.Title) > 20;
--16. Find all books where the Title starts with "The".
Select * from Books b Where b.Title LIKE "THE%"
-- 17. Find the Title of all books where the Category is missing.

Select b.Title 
from Books b
WHERE b.Category is NULL;

-- 18. Show the Title, Original Price, and New_Price (Price + 10%) for 'Fiction' books.
Select b.Title, b.Price, b.Price*1.1 as New_Price
FROM Books b 
Where b.Category = 'Fiction';
-- 19. We need to find the one person who joined our store most recently.
--The Goal: Show FirstName, LastName, and JoinDate
SELECT FirstName, LastName, JoinDate
FROM Customers
ORDER BY JoinDate DESC;

-- 20. You’ve made it to the end! This is the most complex query yet because it 
--connects three different tables to get the answer.
--The Goal: Show the Author's LastName and their Total Sales, but only for authors who have sold more than $200 total.
SELECT a.LastName, SUM(o.TotalAmount) AS Grand_Total
FROM Authors a 
JOIN Books b ON b.AuthorID = a.AuthorID
JOIN Orders o ON o.BookID = b.BookID 
GROUP BY a.LastName
HAVING SUM(o.TotalAmount) > 200;








