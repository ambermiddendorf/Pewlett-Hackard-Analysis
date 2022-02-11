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

DROP TABLE mentorship_eligibility;
--Create Mentorship Eligibility Table
SELECT e.emp_no, 
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	de.dept_no,
	t.title
INTO mentorship_eligibility
FROM employees AS e
	LEFT OUTER JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
	LEFT OUTER JOIN titles AS t
	ON e.emp_no = t.emp_no
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY e.emp_no, to_date DESC


SELECT dept_no, COUNT(emp_no)
INTO mentors_count
FROM mentorship_eligibility
GROUP BY dept_no
ORDER BY dept_no;

SELECT dept_no, COUNT(emp_no)
INTO dept_count
FROM dept_emp
WHERE to_date = ('9999-01-01')
GROUP BY dept_no;


SELECT dc.dept_no AS Dept_No, 
	d.dept_name AS Dept_Name,
	dr.count AS Retiring_Count, 
	mc.count AS Mentor_Count,
	dc.count AS Department_Count,
	ROUND((CAST(dr.count AS NUMERIC)/CAST(dc.count AS NUMERIC)*100.00),2) AS Retiring_Perc
INTO dept_summary
FROM dept_count AS dc
LEFT JOIN dept_retiree_count AS dr
ON dc.dept_no = dr.dept_no
LEFT JOIN mentors_count AS mc
ON dc.dept_no = mc.dept_no
LEFT JOIN departments AS d
ON dc.dept_no=d.dept_no ;


