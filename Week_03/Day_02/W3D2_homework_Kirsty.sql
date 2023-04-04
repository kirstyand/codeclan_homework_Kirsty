-- MVP


-- Q1
-- a
-- Find the first name, last name and team name of employees who are members of teams.

SELECT 
    e.first_name,
    e.last_name,
    t.name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id;

-- b
-- Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme.
SELECT 
    e.first_name,
    e.last_name,
    t.name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE e.pension_enrol;

-- c
-- Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80.
SELECT 
    e.first_name,
    e.last_name,
    t.name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS int) > 80;


-- Q2
-- a
-- Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.
SELECT 
    e.*,
    p.local_account_no,
    p.local_sort_code
FROM employees AS e
FULL JOIN pay_details AS p
ON e.pay_detail_id = p.id;

-- b
-- Amend your query above to also return the name of the team that each employee belongs to.
SELECT 
    e.*,
    p.local_account_no,
    p.local_sort_code,
    t.name AS team_name
FROM (employees AS e
     FULL JOIN pay_details AS p
     ON e.pay_detail_id = p.id)
INNER JOIN teams AS t
    ON e.team_id = t.id;

-- Q3
-- a
-- Make a table, which has each employee id along with the team that employee belongs to.
SELECT 
    e.id AS employee_id,
    t.name AS team_name
FROM employees AS e
INNER JOIN teams AS t
    ON e.team_id = t.id;
    
-- b
-- Breakdown the number of employees in each of the teams.
SELECT 
    t.name AS team_name,
    count(e.id) AS employee_count
FROM employees AS e
INNER JOIN teams AS t
    ON e.team_id = t.id
GROUP BY t.name;

-- c 
-- Order the table above by so that the teams with the least employees come first.
SELECT 
    t.name AS team_name,
    count(e.id) AS employee_count
FROM employees AS e
INNER JOIN teams AS t
    ON e.team_id = t.id
GROUP BY t.name
ORDER BY employee_count;


-- Q4
-- a
-- Create a table with the team id, team name and the count of the number of employees in each team.
SELECT
    t.id AS team_id,
    t.name AS team_name,
    count(e.id) AS employee_count
FROM teams AS t
INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY t.id;

-- b
-- The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of employees in the team. 
-- Calculate the total_day_charge for each team.
SELECT 
    t.name AS team_name,
    count(e.id) AS employee_count,
    t.charge_cost,
    (count(e.id) * CAST(t.charge_cost AS int)) AS total_day_charge
FROM teams AS t
INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY t.id;

-- c
-- How would you amend your query from above to show only those teams with a total_day_charge greater than 5000?
SELECT 
    t.name AS team_name,
    count(e.id) AS employee_count,
    t.charge_cost,
    (count(e.id) * CAST(t.charge_cost AS int)) AS total_day_charge
FROM teams AS t
INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY t.id
HAVING (count(e.id) * CAST(t.charge_cost AS int)) > 5000;


-- Extensions


-- Q5
-- How many of the employees serve on one or more committees?


SELECT 
    count(DISTINCT ec.committee_id) AS committee_count,
    ec.employee_id
FROM employees_committees AS ec
GROUP BY ec.employee_id
HAVING count(DISTINCT ec.committee_id) > 1;
 
    -- There are 2 employees that serve on >1 committee

-- Q6
-- How many of the employees do not serve on a committee?
SELECT 
count(e.id) AS count_employee,
ec.committee_id
FROM employees AS e
LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
WHERE ec.committee_id IS NULL 
GROUP BY ec.committee_id;

--There are 978 employees that don't serve on a committee.

