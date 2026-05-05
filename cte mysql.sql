

select * from categories;
select * from channels;
select * from order_items;
select * from orders;
select * from products;
select * from customers;

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
  