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

DROP TABLE retiring_titles;
--Create Retiring Titles Count
SELECT title, COUNT(emp_no) AS Ret_Emps
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

SELECT * FROM retiring_titles;

DROP TABLE title_counts;
--Create Current Employee Title Counts
SELECT title, COUNT(e.emp_no) AS Curr_Emps
INTO title_counts
FROM employees as e
JOIN titles as t
ON e.emp_no = t.emp_no
WHERE to_date = ('9999-01-01')
GROUP BY title;

SELECT * FROM title_counts;

--Title summary
SELECT tc.title, 
	to_char(rt.ret_emps, 'FM99,999') AS Retiring, 
	to_char(tc.Curr_emps, 'FM99,999') AS Curr_Emps,
	ROUND((CAST(rt.ret_emps AS NUMERIC)/CAST(tc.Curr_emps AS NUMERIC)*100.00),2) AS Retiring_Perc
FROM title_counts AS tc
JOIN retiring_titles AS rt
ON tc.title = rt.title;

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
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND
	de.to_date = ('9999-01-01')
ORDER BY e.emp_no, to_date DESC;

DROP TABLE dept_retiree_count;
--Create Retiree Count by Department
SELECT d.dept_no, COUNT(u.emp_no)
INTO dept_retiree_count
FROM unique_titles AS u
LEFT JOIN dept_emp AS d
ON u.emp_no = d.emp_no
WHERE to_date = ('9999-01-01')
GROUP BY d.dept_no;

DROP mentors_count; 
--Create Mentors Count by Dept.
SELECT dept_no, COUNT(emp_no)
INTO mentors_count
FROM mentorship_eligibility
GROUP BY dept_no
ORDER BY dept_no;

-- Create Dept Count for all current employees
SELECT dept_no, COUNT(emp_no)
INTO dept_count
FROM dept_emp
WHERE to_date = ('9999-01-01')
GROUP BY dept_no;

DROP TABLE dept_summary;
--Create Deparment Summary with Retiring, Mentors and Current employee counts along with retiring percent
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

-- Format Dept Summary Table
SELECT Dept_No,
	Dept_name,
	to_Char(Retiring_count, 'FM99,999') AS Retiring,
	Mentor_count AS Mentors,
	to_char(Department_Count, 'FM99,999') AS Dept_Emps,
	Retiring_Perc	
FROM dept_summary;

--Summary of Summary
SELECT to_char(SUM(Retiring_count), 'FM99,999') AS Retiring,
	to_char(SUM(Mentor_Count),'FM99,999') AS Mentors,
	to_char(sum(Department_count), 'FM999,999') AS Employees
FROM dept_summary;

SELECT COUNT(emp_no) FROM unique_titles;

SELECT SUM(Retiring_count) FROM dept_summary;

SELECT SUM(Count) FROM retiring_titles;

SELECT * FROM dept_summary;

SELECT emp_no, COUNT(emp_no)
FROM dept_emp
WHERE to_date = ('9999-01-01')
GROUP BY emp_no
ORDER BY COUNT(emp_no) DESC


