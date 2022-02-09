--Create retirement titles from employees & titles
SELECT e.emp_no,
	first_name,
	last_name,
	title,
	from_date,
	to_date
INTO retirement_titles
FROM employees AS e
	INNER JOIN titles as t
	ON e.emp_no=t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND t.to_date = ('9999-01-01')
;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no, to_date DESC;

--Create Retiring Titles Count
SELECT title, COUNT(emp_no)
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;


