-- Write a procedure that returns the total quantity sold, average quantity, and revenue generated for a given product ID between two dates. 
-- Then execute this procedure for product ID 101 between '2025-07-01' and '2025-07-10'. [sales analytics procedure]

CREATE TABLE sales (
name VARCHAR(30),
sale_id INT AUTO_INCREMENT PRIMARY KEY,
product_id INT,
sale_date DATE,
quantity_sold INT,
price DECIMAL(10,2));
INSERT INTO sales (name, product_id,sale_date,quantity_sold,price) VALUES
('a',101, '2025-07-01', 3, 1500.00),
('b',101, '2025-07-03', 2, 1500.00),
('c',102, '2025-07-02', 1, 900.00),
('d',101, '2025-07-05', 5, 1500.00);
select * from sales;
Sample Data:
(101, '2025-07-01', 3, 1500.00),
(101, '2025-07-03', 2, 1500.00),
(102, '2025-07-02', 1, 900.00),
(101, '2025-07-05', 5, 1500.00);
-- Write a procedure that returns the total quantity sold, average quantity, and revenue generated for a given product ID between two dates. 
-- Then execute this procedure for product ID 101 between '2025-07-01' and '2025-07-10'. [sales analytics procedure]
DELIMITER //
CREATE PROCEDURE sales_analytics_proc (IN start_date DATE,IN end_date DATE)
BEGIN
	SELECT 
		SUM(quantity_sold)  AS product_quantity_sold,
		AVG(quantity_sold)  AS avg_quantity,
		SUM(price* quantity_sold) AS revenue_genrated
	FROM sales
		where sale_date BETWEEN start_date AND end_date;
END
DELIMITER ;
CALL sales_analytics_proc('2025-07-01','2025-07-03');
select * from sales;

CREATE TABLE users (
	id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(30), email VARCHAR(40)
);
INSERT INTO users (name, email) VALUES ('Ravi', 'ravi@example.com'),('raj', 'raj@example.com'),('Amit', 'amit@example.com'),('Ravi', 'ravi@example.com');
select * from users

DELIMITER //
CREATE PROCEDURE duplicate_data_detection_proc (IN p_name VARCHAR(30), IN p_email VARCHAR(40))
BEGIN
		DECLARE count_of_name_email INT;
        
        SELECT COUNT(*) INTO count_of_name_email FROM users
		WHERE name = p_name AND email = p_email;
  IF
	count_of_name_email > 0 THEN      
        SELECT name , email, count(*) AS duplicate_count FROM users
		WHERE name = p_name AND email = p_email
        group by name , email;
	ELSE
		SELECT 'no information found' AS message;
END IF;
END 
DELIMITER ;
CALL duplicate_data_detection_proc ('mayur','raj@example.com');


    
	

	


