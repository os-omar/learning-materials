CREATE DATABASE IF NOT EXISTS Sales;

USE Sales;



CREATE TABLE IF NOT EXISTS Sales.customers (
	customer_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	email_address VARCHAR(255) UNIQUE KEY,
	number_of_complaints INT DEFAULT 0
);

ALTER TABLE Sales.customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0;

ALTER TABLE Sales.customers
ADD COLUMN gender ENUM('M',
'F') AFTER customers.last_name;

INSERT INTO Sales.customers (first_name, last_name, gender, email_address, number_of_complaints) VALUES ('John', 'Mackinley', 'M', 'john.mckinley@365careers.com', 0);

INSERT INTO Sales.customers (first_name, last_name, gender)
VALUES ('Peter', 'Figaro', 'M');

ALTER TABLE Sales.customers
DROP INDEX email_address;

CREATE TABLE IF NOT EXISTS Sales.sales (
	purchase_number INT NOT NULL AUTO_INCREMENT,
	date_of_purchase DATE NOT NULL,
	customer_id INT,
	item_code VARCHAR(10) NOT NULL,
PRIMARY KEY (purchase_number),
FOREIGN KEY (customer_id) REFERENCES Sales.customers(customer_id) ON
DELETE
	CASCADE
);

ALTER TABLE Sales.sales
ADD FOREIGN KEY (customer_id) REFERENCES Sales.customers(customer_id) 
ON DELETE CASCADE;

ALTER TABLE Sales.sales
DROP FOREIGN KEY sales_ibfk_1;


SELECT * FROM Sales.customers c;


DROP TABLE Sales.sales;

CREATE TABLE IF NOT EXISTS Sales.items(
	item_code varchar(255),   
	item varchar(255),   
	unit_price numeric(10,2),   
    company_id varchar(255),
PRIMARY KEY (item_code)   
);

CREATE TABLE IF NOT EXISTS Sales.companies(
    company_id varchar(255),   
    company_name varchar(255),  
    headquarters_phone_number INT,   
primary key (company_id)
);

SELECT * from Sales.companies c;

DROP TABLE Sales.sales;
DROP TABLE Sales.customers;
DROP TABLE Sales.items;
DROP TABLE Sales.companies;

