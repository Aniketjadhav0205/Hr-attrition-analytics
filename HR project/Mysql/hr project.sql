USE hr_db;

#Attrition by Tenure Group (using the Tenure_Group logic)
WITH tenure_bins AS (
    SELECT *,
           CASE 
               WHEN YearsAtCompany < 2 THEN '0-2 years'
               WHEN YearsAtCompany BETWEEN 2 AND 5 THEN '2-5 years'
               WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10 years'
               WHEN YearsAtCompany BETWEEN 11 AND 20 THEN '11-20 years'
               ELSE '20+ years'
           END AS Tenure_Band
    FROM hr_employee
)
SELECT Tenure_Band,
       COUNT(*) AS Total_Employees,
       SUM(Attrition) AS Left_Count,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM tenure_bins
GROUP BY Tenure_Band
ORDER BY Attrition_Pct DESC;

#Attrition Risk Scorecard (Identify High-Risk Profiles)
SELECT EmployeeNumber,
       Age,
       Department,
       JobRole,
       MonthlyIncome,
       OverTime,
       JobSatisfaction,
       YearsAtCompany,
       -- Risk Score: Higher = More likely to leave
       (CASE WHEN OverTime = 'Yes' THEN 30 ELSE 0 END) +
       (CASE WHEN JobSatisfaction <= 2 THEN 25 ELSE 0 END) +
       (CASE WHEN MonthlyIncome < 5000 THEN 25 ELSE 0 END) +
       (CASE WHEN YearsAtCompany < 2 THEN 20 ELSE 0 END) AS Risk_Score
FROM hr_employee
WHERE Attrition = 0  -- Current employees
ORDER BY Risk_Score DESC
LIMIT 20;

#Department-Level Salary Comparison: Leavers vs Stayers
WITH dept_avg AS (
    SELECT Department,
           AVG(MonthlyIncome) AS Avg_Dept_Salary
    FROM hr_employee
    GROUP BY Department
)
SELECT e.Department,
       e.Attrition,
       COUNT(*) AS Employee_Count,
       ROUND(AVG(e.MonthlyIncome), 0) AS Avg_Salary,
       ROUND(AVG(d.Avg_Dept_Salary), 0) AS Dept_Avg_Salary,
       ROUND(AVG(e.MonthlyIncome) - AVG(d.Avg_Dept_Salary), 0) AS Salary_Gap
FROM hr_employee e
JOIN dept_avg d ON e.Department = d.Department
GROUP BY e.Department, e.Attrition
ORDER BY e.Department, e.Attrition DESC;

#Impact of Number of Companies Worked on Attrition
SELECT NumCompaniesWorked,
       COUNT(*) AS Total,
       SUM(Attrition) AS Left_Count,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee
GROUP BY NumCompaniesWorked
ORDER BY NumCompaniesWorked;

#Promotion Gap Analysis (Years Since Last Promotion)
SELECT YearsSinceLastPromotion,
       COUNT(*) AS Total,
       SUM(Attrition) AS Left_Count,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;

#Department & Job Role Combo with Highest Attrition
#Promotion Gap Analysis (Years Since Last Promotion)
SELECT Department,
       JobRole,
       COUNT(*) AS Total,
       SUM(Attrition) AS Left_Count,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee
GROUP BY Department, JobRole
HAVING COUNT(*) > 10  -- Filter out tiny roles for statistical relevance
ORDER BY Attrition_Pct DESC
LIMIT 10;

#Attrition vs Work-Life Balance Rating
SELECT WorkLifeBalance,
       COUNT(*) AS Total,
       SUM(Attrition) AS Left_Count,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;
 
# Top 5 Most "Expensive" Attrition (Lost Salary)
SELECT EmployeeNumber,
       Department,
       JobRole,
       MonthlyIncome,
       YearsAtCompany,
       YearsSinceLastPromotion
FROM hr_employee
WHERE Attrition = 1
ORDER BY MonthlyIncome DESC
LIMIT 5;

#Attrition by Education Field
SELECT EducationField,
       COUNT(*) AS Total,
       SUM(Attrition) AS Left_Count,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee
GROUP BY EducationField
ORDER BY Attrition_Pct DESC;

# Monthly Income Distribution by Attrition (Statistical View)
SELECT Attrition,
       ROUND(MIN(MonthlyIncome), 0) AS Min_Salary,
       ROUND(AVG(MonthlyIncome), 0) AS Avg_Salary,
       ROUND(MAX(MonthlyIncome), 0) AS Max_Salary
FROM hr_employee
GROUP BY Attrition;