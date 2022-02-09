SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
last_name
DROP TABLE retirement_info;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
;

SELECT * FROM retirement_info;

-- Joining retirement_info and dept_emp tables
SELECT r.emp_no, 
	r.first_name, 
	r.last_name, 
	d.to_date
INTO current_emp
FROM retirement_info as r
LEFT JOIN dept_emp as d
ON r.emp_no = d.emp_no
WHERE d.to_date = ('9999-01-01');

select * from current_emp;

SELECT de.dept_no, COUNT(ce.emp_no)
INTO dept_retiree_count
FROM current_emp AS ce
LEFT JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--Retiring employee info
SELECT e.emp_no, last_name, first_name, gender, salary
INTO emp_info
FROM employees AS e
LEFT JOIN salaries AS s
ON e.emp_no = s.emp_no
LEFT JOIN dept_emp AS d
ON e.emp_no = d.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND d.to_date = ('9999-01-01');

--List of managers per deparment
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no, 
	ce.first_name, 
	ce.last_name, 
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
			INNER JOIN departments AS d
				ON (de.dept_no = d.dept_no);
				
SELECT * FROM departments;

--Sales team retirees.
SELECT e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM emp_info AS e 
	INNER JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE de.dept_no = ('d007')		
AND de.to_date = ('9999-01-01');

SELECT e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM emp_info AS e 
	INNER JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE de.dept_no IN ('d005','d007') 		
AND de.to_date = ('9999-01-01');

SELECT COUNT(emp_no) FROM employees;



				
