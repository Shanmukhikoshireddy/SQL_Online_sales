--create temp_orders as there is problem with date column
CREATE TABLE temp_orders (
    Order_ID TEXT,
    Order_Date TEXT, -- temporarily as text
    CustomerName TEXT,
    State TEXT,
    City TEXT
);

--Inserting data into temp_orders
COPY temp_orders(Order_ID, Order_Date, CustomerName, State, City)
FROM 'C:/Orders.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    QUOTE '"'
);

--Create original table orders
CREATE TABLE Orders (
    Order_ID TEXT,
    Order_Date DATE,
    CustomerName TEXT,
    State TEXT,
    City TEXT
);

-- copy the temp_order content to order by changing datatype of order_Date to date by using to_date function
INSERT INTO Orders(Order_ID, Order_Date, CustomerName, State, City)
SELECT
    Order_ID,
    TO_DATE(Order_Date, 'MM/DD/YYYY'),  -- Convert string to date
    CustomerName,
    State,
    City
FROM temp_orders;

--1.review befor going with queries
select * from Orders limit 10;

--2.Extracting month from order_date
SELECT EXTRACT(MONTH FROM Order_Date) AS order_month
FROM Orders;

--3.group by year
SELECT
    EXTRACT(YEAR FROM Order_Date) AS order_year,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY order_year
ORDER BY order_year;

--4.group by month
SELECT
    EXTRACT(MONTH FROM Order_Date) AS order_month,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY order_month
ORDER BY order_month;

--5group by year and month 
SELECT
    TO_CHAR(Order_Date, 'YYYY-MM') AS year_month,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY year_month
ORDER BY year_month;

--6.count(distinct order_id)
SELECT count(distinct order_ID) from orders;

-- create details table
CREATE TABLE Details (
    Order_ID TEXT,
	Amount INTEGER,
	Profit INTEGER,
	Quantity INTEGER,
	Category TEXT,
	Sub_category TEXT,
	PaymentMode TEXT
);

--inserting from csv file
COPY Details(Order_ID,Amount,Profit,Quantity,Category,Sub_category,PaymentMode)
FROM 'C:/Details.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    NULL '',
    QUOTE '"'
);

select * from details;

--7. Sum of amount
SELECT Category,SUM(Amount) as Total_Revenue from details group by category;

--8.Order by for sorting
SELECT Paymentmode,count(order_ID) as total from details group by paymentmode order by total;

--9. select top 5 customers customername,state,amount whose amount is highest of all
SELECT orders.CustomerName,orders.state,details.amount from orders,details order by details.amount desc limit 5;

--10. select customers and sum of quantity whose category is clothing limit 5
SELECT o.CUSTOMERNAME,SUM(d.quantity) as Sum_of_quantity from orders as o,details as d where category= 'Clothing' group by customerName limit 5;