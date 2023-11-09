CREATE DATABASE Customers_Orders_Products 

CREATE TABLE Customers 
(
CustomerID INT PRIMARY KEY,
Name VARCHAR(50),
Email VARCHAR(100)
)

INSERT INTO Customers VALUES(1, 'John Doe', 'johndoe@example.com')
INSERT INTO Customers VALUES(2, 'Jane Smith', 'janesmith@example.com')
INSERT INTO Customers VALUES(3, 'Robert Johnson', 'robertjohnson@example.com')
INSERT INTO Customers VALUES(4, 'Emily Brown', 'emilybrown@example.com')
INSERT INTO Customers VALUES(5, 'Michael Davis', 'michaeldavis@example.com')
INSERT INTO Customers VALUES(6, 'Sarah Wilson', 'sarahwilson@example.com')
INSERT INTO Customers VALUES(7, 'David Thompson', 'davidthompson@example.com')
INSERT INTO Customers VALUES(8, 'Jessica Lee', 'jessicalee@example.com')
INSERT INTO Customers VALUES(9, 'William Turner', 'williamturner@example.com')
INSERT INTO Customers VALUES(10, 'Olivia Martinez', 'oliviamartinez@example.com')

SELECT * FROM Customers

CREATE TABLE Orders
(
OrderID INT PRIMARY KEY,
CustomerID INT,
ProductName VARCHAR(50),
OrderDate DATE,
Quantity INT
)

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);

SELECT * FROM Orders


CREATE TABLE Products 
(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(50),
Price DECIMAL(10, 2)
)

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);

SELECT * FROM  Products

-----------all:
select * from customers
select * from orders
select * from products



---------Task 1 :-
---------1.	Write a query to retrieve all records from the Customers table..

SELECT * FROM Customers

---------2.	Write a query to retrieve the names and email addresses of customers whose names start with 'J'.

SELECT Name, Email FROM Customers
WHERE Name LIKE 'J%'

---------3.	Write a query to retrieve the order details (OrderID, ProductName, Quantity) for all orders..

select * from orders

----------4. Write a query to calculate the total quantity of products ordered.

SELECT SUM(Quantity) AS TotalQuantity
FROM orders ---------------------------------28

----------5. Write a query to retrieve the names of customers who have placed an order.

SELECT DISTINCT c.Name
FROM Customers c
JOIN Orders o 
ON 
c.CustomerID = o.CustomerID;

--------6. Write a query to retrieve the products with a price greater than $10.00.
SELECT ProductName, price FROM Products
WHERE Price > 10.00

-------7. Write a query to retrieve the customer name and order date for all orders placed on or after '2023-07-05'.

SELECT c.Name AS CustomerName, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '2023-07-05';

------8. Write a query to calculate the average price of all products.

SELECT AVG(Price) AS AveragePrice
FROM Products


------9. Write a query to retrieve the customer names along with the total quantity of products they have ordered.----
SELECT c.Name AS CustomerName, SUM(o.Quantity) AS TotalQuantity
FROM Customers c
LEFT JOIN 
Orders o
ON 
c.CustomerID = o.CustomerID
LEFT JOIN 
Orders 
ON
o.OrderID = o.OrderID
GROUP BY c.CustomerID, c.Name;



------10. Write a query to retrieve the products that have not been ordered.-----
SELECT p.ProductName
FROM Products p
LEFT JOIN 
Orders o 
ON
p.ProductID = p.ProductID
WHERE p.ProductID IS NULL

----------Task 2 :-
select * from customers
select * from orders
select * from products
---------1.	Write a query to retrieve the top 5 customers who have placed the highest total quantity of orders.
SELECT
    customers.customerid,
    customers.Name,
    SUM(orders.quantity) AS total_quantity_ordered
FROM
    customers
JOIN
    orders ON customers.customerId = orders.customerId
JOIN
    orders ON orders.orderId = orders.ordersId
GROUP BY
    customers.customerId,
    customers.name
ORDER BY
    total_quantity_ordered DESC

---------2.	Write a query to calculate the average price of products for each product category.

SELECT AVG(Price) AS AveragePrice
FROM Products


---------3.	Write a query to retrieve the customers who have not placed any orders.

SELECT Customers.customerId, Customers.Name
FROM Customers
LEFT JOIN Orders ON Customers.customerId = Orders.customerId
WHERE Orders.orderId IS NULL;


----------4. Write a query to retrieve the order details (OrderID, ProductName, Quantity) for orders placed by customers whose names start with 'M'.
SELECT Name, Email FROM Customers
WHERE Name LIKE 'M%'

---------5.	Write a query to calculate the total revenue generated from all orders.

SELECT SUM(Price) AS total_revenue
FROM products;

------------6.	Write a query to retrieve the customer names along with the total revenue generated from their orders.
SELECT
    C.customerId,
    C.Name,
    SUM(P.price * O.quantity) AS total_revenue
FROM Customers C
JOIN Orders O ON C.customerId = O.CustomerId
JOIN Products P ON O.productName = P.productName
GROUP BY C.CustomerId, C.Name;

select * from customers
select * from orders
select * from products

------------7.	Write a query to retrieve the customers who have placed at least one order for each product category.
SELECT DISTINCT C.CustomerID, C.Name
FROM Customers C
WHERE (
    SELECT COUNT(DISTINCT P.ProductID)
    FROM Products P
    WHERE P.ProductID NOT IN (
        SELECT DISTINCT P.ProductID
        FROM Products P
        LEFT JOIN Orders O ON P.ProductID = O.CustomerID
        WHERE O.CustomerID = C.CustomerID
    )
) = 0;


------------8.	Write a query to retrieve the customers who have placed orders on consecutive days.
WITH OrderedOrders AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS prev_order_date
    FROM Orders o
)

SELECT DISTINCT c.customer_id, c.customer_name
FROM Customers c
JOIN OrderedOrders oo ON c.customer_id = oo.customer_id
WHERE DATEDIFF(oo.order_date, oo.prev_order_date) = 1
ORDER BY c.customer_id;

------------9.	Write a query to retrieve the top 3 products with the highest average quantity ordered.
SELECT ProductName, AVG(quantity) AS avg_quantity_ordered
FROM orders
GROUP BY ProductName
ORDER BY avg_quantity_ordered DESC




-----------10.	Write a query to calculate the percentage of orders that have a quantity greater than the average quantity.
SELECT
    (COUNT(CASE WHEN quantity > avg_quantity THEN 1 ELSE NULL END) / COUNT(*)) * 100 AS percentage_above_average
FROM
    (SELECT AVG(quantity) AS avg_quantity FROM orders) AS subquery
JOIN
    orders ON 1=1;

-----Task 3:-
------1.	Write a query to retrieve the customers who have placed orders for all products.
----------2.	Write a query to retrieve the products that have been ordered by all customers.
select * from customers
select * from orders
select * from products

   









------3.	Write a query to calculate the total revenue generated from orders placed in each month.
4.	Write a query to retrieve the products that have been ordered by more than 50% of the customers.
5.	Write a query to retrieve the customers who have placed orders for all products in a specific category.
6.	Write a query to retrieve the top 5 customers who have spent the highest amount of money on orders.
7.	Write a query to calculate the running total of order quantities for each customer.
8.	Write a query to retrieve the top 3 most recent orders for each customer.
9.	Write a query to calculate the total revenue generated by each customer in the last 30 days.
10.	Write a query to retrieve the customers who have placed orders for at least two different product categories.
11.	Write a query to calculate the average revenue per order for each customer.
12.	Write a query to retrieve the products that have been ordered by customers from a specific country.
13.	Write a query to retrieve the customers who have placed orders for every month of a specific year.
14.	Write a query to retrieve the customers who have placed orders for a specific product in consecutive months.
----15.	Write a query to retrieve the products that have been ordered by a specific customer at least twice.



