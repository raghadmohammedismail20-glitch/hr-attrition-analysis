SELECT * FROM hr_attrition
limit 5;


SELECT DISTINCT attrition 
FROM hr_attrition;


SELECT 
    SUM(CASE WHEN attrition IS NULL THEN 1 ELSE 0 END) AS null_attrition,
    SUM(CASE WHEN monthlyincome IS NULL THEN 1 ELSE 0 END) AS null_income,
    SUM(CASE WHEN department IS NULL THEN 1 ELSE 0 END) AS null_department
FROM hr_attrition;


SELECT attrition, COUNT(*) AS total
FROM hr_attrition
GROUP BY attrition;


SELECT Department,ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM hr_attrition
GROUP BY Department;


SELECT attrition, AVG(MonthlyIncome)
FROM hr_attrition
WHERE Department = 'Sales'
GROUP BY attrition;



SELECT overtime, COUNT(*) AS total,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_attrition
WHERE department = 'Sales'
GROUP BY overtime
;


SELECT JobSatisfaction,count(*) AS total, 
SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS left_count ,
ROUND(SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)*100/count(*),2) AS attrition_rate 
FROM hr_attrition 
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


SELECT overtime, attrition,count(*)
FROM hr_attrition	
WHERE Department = 'Sales' AND attrition='Yes' 
GROUP BY overtime,JobRole
;



select distinct(jobrole) 
from hr_attrition
where Department='Sales';


SELECT jobrole, COUNT(*) AS total,
SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END) AS left_count,
ROUND(SUM(CASE WHEN attrition='yes' THEN 1 ELSE 0 END) *100 / COUNT(*),2) AS attrition_rate_pct
FROM hr_attrition
WHERE department = 'Sales'
GROUP BY jobrole;


SELECT MonthlyIncome,jobrole 
FROM hr_attrition
WHERE Jobrole='Sales Executive' OR Jobrole='Sales Representative'
ORDER BY JobRole;


SELECT hourlyrate,jobrole,AVG(hourlyrate) 
OVER(PARTITION BY  jobrole) AS AVG_hourly_rate
FROM hr_attrition ;


SELECT employeenumber,monthlyincome ,
DENSE_RANK() OVER (PARTITION BY  department ORDER BY  monthlyincome DESC) AS ranking_departments
FROM hr_attrition;


WITH CTE AS 
(SELECT employeenumber,monthlyincome,attrition,
LAG (monthlyincome) OVER (ORDER BY employeenumber) AS previous_salary,
monthlyincome-LAG (monthlyincome) OVER (ORDER BY employeenumber) AS salary_difference
FROM hr_attrition)
SELECT  attrition,COUNT(*)
FROM CTE
WHERE salary_difference <0
GROUP BY attrition
;



CREATE VIEW employee_risk_score AS
WITH cte2 AS (SELECT jobsatisfaction,overtime,monthlyincome,employeenumber, LAG(MONTHLYincome) OVER (ORDER BY employeenumber), monthlyincome-LAG(MONTHLYincome) OVER (ORDER BY employeenumber) AS Monthly_lag from hr_attrition), cte3 as (select employeenumber,overtime ,jobsatisfaction, CASE WHEN overtime="yes" THEN 1 else 0 END AS overtime_risk ,CASE WHEN jobsatisfaction=1 THEN 1 ELSE 0 END AS jobsatisfaction_risk , CASE WHEN Monthly_lag<0 THEN 1 ELSE 0 END AS monthlylag_risk from cte2) ,cte4 AS( select employeenumber, overtime_risk+jobsatisfaction_risk+monthlylag_risk AS total_risk_points,
 CASE
 WHEN overtime_risk+jobsatisfaction_risk+monthlylag_risk>=2 THEN 'HIGH RISK'
 WHEN overtime_risk+jobsatisfaction_risk+monthlylag_risk =1 THEN 'Medium Risk' 
ELSE 'low risk'
END AS risk_degree
 FROM cte3) 
 SELECT * FROM cte4 ;
 
 
 SELECT * 
 FROM employee_risk_score;
 
SELECT COUNT(*),risk_degree
FROM employee_risk_score
GROUP BY risk_degree;


SELECT department,COUNT(risk_degree),risk_degree,AVG(total_risk_points) AS avg_risk_points
FROM hr_attrition 
JOIN employee_risk_score
ON hr_attrition.employeenumber=employee_risk_score.employeenumber
WHERE department="Sales"
GROUP BY risk_degree;



SELECT * 
FROM ibm_hr.hr_attrition;