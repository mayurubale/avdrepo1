-- 1.	How many customers registered in the first six months of 2017? Name the column registration_count.
SELECT * FROM customers;
SELECT COUNT(*) AS registration_count FROM customers
WHERE YEAR(registration_date) = 2017 AND MONTH(registration_date) <= 6;

-- 2.	Show the number of registrations in the current week. Name the column registrations_current_week.
SELECT COUNT(*) FROM customers
	WHERE YEAR(registration_date) = CURRENT_DATE() 
	AND 
	WEEK(registration_date) = WEEK(CURRENT_DATE()) ;
    
-- 3.	Create a report containing the 2017 monthly registration counts.
-- Show the registration_month and registration_count columns. Order the results by month.

SELECT MONTH(registration_date) AS registration_month, COUNT(*) registration_count FROM customers
WHERE YEAR(registration_date) = 2017
GROUP BY registration_month
ORDER BY registration_month;

-- 4Find the registration count for each month in each year. 
-- Show the following columns: registration_year, registration_month, and registration_count. 
-- Order the results by year and month.

SELECT YEAR(registration_date) AS registration_year, MONTH(registration_date) AS registration_month, COUNT(*) AS registration_count 
FROM
	customers
GROUP BY registration_year, registration_month
ORDER BY registration_year, registration_month;

-- 5. Write an SQL query to find the number of customer registrations per year for each channel.

SELECT YEAR(registration_date) AS registration_year, channel_id, COUNT(*) AS customer_register 
	FROM customers
GROUP BY YEAR(registration_date) , channel_id
ORDER BY registration_year;

-- 6. Write an SQL query to find the number of customer registrations per year for organic search channel.
SELECT * FROM channels;
SELECT * FROM customers;

select year(registration_date),count(registration_date) from customers
where channel_id = (
	SELECT id FROM channels
	WHERE channel_name = 'Organic Search'
	)
group by year(registration_date);

-- 7.	Create a report to show the weekly counts of registration in 2017, based on the customer country. 
-- Show the following columns: registration_week, country, and registration_count. Order the results by week.

SELECT * FROM channels;
SELECT * FROM customers;
SELECT WEEK(registration_date) AS registration_week,country,COUNT(registration_date) AS registration_count
FROM customers
WHERE YEAR(registration_date) = 2017
GROUP BY registration_week,country
ORDER BY registration_week;



-- 8.	Among customers registered in 2017, show how many made at least one purchase (name the column customers_with_purchase) 
-- and the number of all the customers registered in 2017 (name the column all_customers).
SELECT * FROM customers;
SELECT DISTINCT COUNT(customer_id) AS all_customers, COUNT(first_order_id)  AS customers_with_purchase
FROM customers
WHERE YEAR(registration_date) = 2017;

-- 9. Find the lifetime conversion rate among customers who registered in 2017.
-- Show the result in a column named conversion_rate. Round the result to four decimal places.

SELECT ROUND((COUNT(first_order_id)/COUNT(*))*100,4) AS conversion_rate FROM customers
WHERE YEAR(registration_date) = 2017;

-- 10.	Find the conversion rate for each customer channel. Show the channel_name and conversion_rate columns.
-- Display the conversion rates as percentages rounded to two decimal places.
SELECT 
	(SELECT channel_name from channels WHERE customers.channel_id = channels.id ) AS channel_name,
	ROUND((COUNT(first_order_id)/COUNT(*))* 100 ,2)AS conversion_rate
FROM customers
GROUP BY channel_id;

SELECT channel_name, ROUND((COUNT(first_order_id)/COUNT(*))* 100 ,2)AS conversion_rate 
FROM customers cus INNER JOIN channels c 
	ON cus.channel_id = c.id
GROUP BY channel_name;

-- 11.	Create a report showing conversion rates in monthly basis. 
-- Display the conversion rates as ratios, rounded to three decimal places.
-- Show the following columns: year, month, and conversion_rate. Order the results by year and month.
SELECT * FROM customers;


SELECT YEAR(registration_date) AS year, MONTH(registration_date) as month,
ROUND(((COUNT(first_order_id)/COUNT(*))* 100),3) ratio
FROM customers
GROUP BY year, month
order by year, month;

-- 12.Create a report containing the conversion rates for weekly registration in each registration channel,
-- based on customers registered in 2017. 
-- Show the following columns: week, channel_name, and conversion_rate. 
-- Format the conversion rates as percentages, rounded to a single decimal place.
-- Order the results by week and channel name.

SELECT WEEK(registration_date) AS 'week',
	(SELECT  channel_name FROM channels where id = customers.channel_id) AS channel_name ,
ROUND((COUNT(first_order_id)/COUNT(*))*100,1) AS conversion_rate FROM customers
WHERE YEAR(registration_date) = 2017
GROUP BY channel_id, week
ORDER BY week, channel_name;


-- 13.Show customers' emails and interval between their first purchase and the date of registration. Name the column difference.

SELECT full_name,email , TIMESTAMPDIFF(DAY, registration_date,first_order_date) AS difference FROM customers
HAVING difference IS NOT NULL;

-- 14.Find the average time from registration to first order for each channel. 
-- Show two columns: channel_name and avg_days_to_first_order.

WITH avg_CTE AS (
	SELECT channel_id , 
    ROUND(AVG(TIMESTAMPDIFF(DAY, registration_date,first_order_date)),2) AS avg_days_to_first_order FROM customers
	GROUP BY channel_id
)
SELECT id, channel_name,avg_days_to_first_order FROM channels c INNER JOIN avg_cte a ON c.id = a.channel_id;

-- 15. Calculate the average number of days that passed between registration and first order in quarterly registration basis.
-- Show the following columns: year, quarter, and avg_days_to_first_order. Order the results by year and quarter.

SELECT 
	YEAR(registration_date) AS year, QUARTER(registration_date) AS quarter,
	ROUND(AVG(TIMESTAMPDIFF(DAY,registration_date,first_order_date)),2) avg_days_to_first_order 
FROM 
	customers
GROUP BY year, quarter
ORDER BY year, quarter;

-- 16.	Create a report of the average time to first order for weekly registration basis from 2017 in each registration channel.
-- Show the following columns: week, channel_name, and avg_days_to_first_order. Order the results by the week.

SELECT
    WEEK(registration_date) week,
	(SELECT channel_name FROM channels WHERE id = customers.channel_id) channel_name,
	AVG(TIMESTAMPDIFF(DAY, registration_date,first_order_date)) avg_days_to_first_order
FROM customers
WHERE YEAR(registration_date) = 2017
GROUP BY week, channel_name
ORDER BY week;

SELECT
    WEEK(registration_date) week,
	channel_name,
	AVG(TIMESTAMPDIFF(DAY, registration_date,first_order_date)) avg_days_to_first_order
FROM customers c INNER JOIN channels ch ON c.channel_id = ch.id
WHERE YEAR(registration_date) = 2017
GROUP BY week, channel_name
ORDER BY week;

-- 17. Find all customers who placed their first order within one month from registration, and their last order within three months from registration – 
-- let's see who's stopped ordering. 
-- For each customer show these columns: email, full_name, first_order_date, last_order_date.

WITH first_order_cte AS(
	SELECT first_order_date FROM customers
	where first_order_date BETWEEN registration_date AND DATE_ADD(registration_date, INTERVAL 1 MONTH)
), 
last_order_cte AS (
	SELECT last_order_date FROM customers
	where last_order_date BETWEEN registration_date AND DATE_ADD(registration_date, INTERVAL 3 MONTH)
)
SELECT email, full_name,registration_date, c.first_order_date, c.last_order_date
FROM customers c INNER JOIN first_order_cte cte1 ON c.first_order_date = cte1.first_order_date
INNER JOIN last_order_cte cte2 ON c.last_order_date =cte2.last_order_date;

-- BY USING SUBQUERY
SELECT email, full_name,registration_date, first_order_date, last_order_date
FROM customers
WHERE customer_id IN (
SELECT customer_id FROM customers
	WHERE 
		first_order_date BETWEEN registration_date AND DATE_ADD(registration_date, INTERVAL 1 MONTH) AND
		last_order_date BETWEEN registration_date AND DATE_ADD(registration_date, INTERVAL 3 MONTH)
);


-- 19.	Show two metrics in two different columns:
-- order_on_registration_date – the number of people who made their first order within one day from their registration date.
-- order_after_registration_date – the number of people who made their first order after their registration date.

SELECT 
	COUNT(
		(SELECT first_order_date from customers
		WHERE first_order_date = TIMESTAMPDIFF(DAY,registration_date, first_order_date))
    ) 
    AS order_on_registration_date,
	COUNT(first_order_date > DATE_ADD(registration_date, INTERVAL 1 DAY))AS order_after_registration_date
FROM customers ;

/* 20.	Create a conversion chart for monthly registration. Show the following columns:
year
month
registered_count
no_sale
three_days – the number of customers who made a purchase within 3 days from registration.
first_week – the number of customers who made a purchase during the first week but not within the first three days.
after_first_week – the number of customers who made a purchase after the 7th day.

Order the results by year and month.
*/
WITH conversion_chart_cte AS (
SELECT YEAR(registration_date) year, MONTH(registration_date) month,
CASE
	WHEN first_order_date BETWEEN registration_date AND DATE_ADD(registration_date, INTERVAL 3 DAY) THEN 'three_day'
    WHEN first_order_date BETWEEN DATE_ADD(registration_date, INTERVAL 3 DAY) AND DATE_ADD(registration_date, INTERVAL 7 DAY) THEN 'first_week'
    ELSE 'after_first_week'
END AS register_date 
FROM customers
WHERE first_order_date IS NOT NULL
GROUP BY year, month, register_date 
ORDER BY year, month
  )
  SELECT *, COUNT(*) OVER(PARTITION BY month,register_date) AS registered_count FROM conversion_chart_cte
  
