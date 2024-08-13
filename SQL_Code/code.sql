-- Create a database
CREATE
OR REPLACE DATABASE employee_db;
-- Create a schema within the database
USE DATABASE employee_db;
CREATE
OR REPLACE SCHEMA hr_schema;

-- Create a table for departments
CREATE
OR REPLACE TABLE hr_schema.departments (
    department_id INT AUTOINCREMENT PRIMARY KEY,
    department_name STRING
);

-- Create a table for employees
CREATE
OR REPLACE TABLE hr_schema.employees (
    employee_id INT AUTOINCREMENT PRIMARY KEY,
    first_name STRING,
    last_name STRING,
    department_id INT,
    hire_date DATE,
    salary NUMBER(10, 2),
    FOREIGN KEY (department_id) REFERENCES hr_schema.departments(department_id)
);

-- Insert data into departments table
INSERT INTO hr_schema.departments (department_name)
VALUES
    ('Sales'),
    ('Marketing'),
    ('Engineering'),
    ('HR');

-- Insert data into employees table
INSERT INTO hr_schema.employees (first_name, last_name, department_id, hire_date, salary)
VALUES
    ('John', 'Doe', 1, '2023-01-15', 60000),
    ('Jane', 'Smith', 2, '2022-11-22', 65000),
    ('Sam', 'Brown', 3, '2021-06-30', 70000),
    ('Emily', 'Davis', 4, '2020-09-10', 55000);


-- Query to get all employees
SELECT * FROM hr_schema.employees;

-- Query to get employees by department
SELECT e.first_name, e.last_name, d.department_name
FROM hr_schema.employees e
JOIN hr_schema.departments d ON e.department_id = d.department_id;

-- Query to get average salary by department
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM hr_schema.employees e
JOIN hr_schema.departments d ON e.department_id = d.department_id
GROUP BY d.department_name;


-- Create a task to update salary (example task to increase salary by 5%)
CREATE OR REPLACE TASK hr_schema.update_salary_task
  WAREHOUSE = IPL_DATAWAREHOUSE
  SCHEDULE = 'USING CRON 0 0 1 * * UTC' -- Runs on the 1st day of every month
AS
  UPDATE hr_schema.employees
  SET salary = salary * 1.05;

-- Enable the task
ALTER TASK hr_schema.update_salary_task RESUME;


