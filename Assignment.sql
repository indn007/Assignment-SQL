create database AssignmentSql;

Use AssignmentSql;


-- Q1. Create a table called employees with constraints

CREATE TABLE employees (
  emp_id INT PRIMARY KEY NOT NULL,
  emp_name VARCHAR(100) NOT NULL,
  age INT CHECK (age >= 18),
  email VARCHAR(100) UNIQUE,
  salary DECIMAL(10,2) DEFAULT 30000);
  
-- Q2. Explain the purpose of constraints and how they help maintain data integrity.

-- Constraints are rules applied to columns to maintain data integrity. They prevent invalid data entry and enforce relationships.
-- Common Types:
-- NOT NULL: Prevents empty values
-- UNIQUE: Ensures no duplicates
-- PRIMARY KEY: Combines NOT NULL + UNIQUE
-- FOREIGN KEY: Links tables
-- CHECK: Validates logical conditions
-- DEFAULT: Assigns default values
		-- Example :-
CREATE TABLE employees2 (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100) NOT NULL,
  age INT CHECK (age >= 18),
  email VARCHAR(100) UNIQUE,
  salary DECIMAL(10,2) DEFAULT 30000,
  dept_id INT);
  
-- Q3. Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer.

-- NOT NULL ensures a column always has a value.
-- PRIMARY KEY ensures uniqueness and cannot contain NULLs.
-- A column with PRIMARY KEY is automatically NOT NULL.

-- Q4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.

--  Add Constraint Example
ALTER TABLE employees
ADD CONSTRAINT chk_salary CHECK (salary >= 10000);

-- Remove Constraint Example
ALTER TABLE employees
DROP INDEX email;

-- Q5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. Provide an example of an error message that might occur when violating a constraint.

-- INSERT, UPDATE, or DELETE data that breaks a constraint (like PRIMARY KEY, UNIQUE, CHECK, etc.), the database blocks the operation and shows an error. This ensures data integrity.

		-- Example: Violating UNIQUE Constraint
INSERT INTO employees (emp_id, email) VALUES (101, 'amit@example.com');
INSERT INTO employees (emp_id, email) VALUES (102, 'amit@example.com');
--  Error Message: ERROR 1062 (23000): Duplicate entry 'amit@example.com' for key 'email'

-- Q6. You created a products table without constraints as follows:

CREATE TABLE products (
product_id INT,
product_name VARCHAR(50),
price DECIMAL(10, 2));
    
-- Now, you realise that?
-- : The product_id should be a primary keyQ
-- : The price should have a default value of 50.00

-- Make  a PRIMARY KEY:
 ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- Set DEFAULT value for price:
ALTER TABLE products
MODIFY price DECIMAL(10,2) DEFAULT 50.00;

-- Q7. 



