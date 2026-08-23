# 📊 HR Analytics: Employee Attrition & Retention Strategy

<img width="1482" height="832" alt="image" src="https://github.com/user-attachments/assets/dd4428c6-13be-4498-97e1-e9e66311b3de" />

<img width="1486" height="833" alt="image" src="https://github.com/user-attachments/assets/e506fa41-54f0-4a44-ae3c-a3e74d94a541" />

## 📌 Project Overview

This project analyzes employee attrition (turnover) using the **IBM HR Analytics Dataset**. The goal is to identify **who is leaving, why they are leaving**, and provide **data-driven recommendations** to improve retention.

The project follows a complete **End-to-End Data Analytics workflow**:
- **Data Cleaning & Preparation** (Python/Pandas)
- **Advanced SQL Queries** (MySQL/PostgreSQL)
- **Interactive Dashboard** (Power BI)

---

## 🎯 Key Business Questions

1. What is the overall attrition rate?
2. Which departments have the highest turnover?
3. Does overtime significantly impact employee retention?
4. How does salary and job satisfaction affect leaving decisions?
5. What is the profile of a "high-risk" current employee?
6. What actionable steps can HR take to reduce attrition?

---

## 📁 Dataset Description

- **Source:** IBM HR Analytics (Kaggle)
- **Rows:** 1,470 employees
- **Columns:** 35 (Age, Attrition, Department, MonthlyIncome, OverTime, JobSatisfaction, YearsAtCompany, etc.)
- **Target Variable:** `Attrition` (Yes/No)

---

## 🛠️ Tech Stack

| Tool | Purpose |
| :--- | :--- |
| **Python (Pandas)** | Data cleaning and feature engineering |
| **SQL (MySQL/PostgreSQL)** | Data extraction, aggregation, and analytical queries |
| **Power BI** | Interactive dashboard creation and storytelling |

---

## 🔧 Data Cleaning & Preparation

1. **Loaded** raw CSV file into Pandas DataFrame.
2. **Converted** `Attrition` from "Yes"/"No" to binary (1/0) for numerical analysis.
3. **Standardized** categorical columns (`Department`, `OverTime`, `JobRole`) to `category` dtype.
4. **Created** new feature: `Tenure_Group` (0-2, 3-5, 6-10, 11-20, 20+ years).
5. **Exported** cleaned data as `hr_data_cleaned.csv` for SQL and Power BI import.

---

## 📈 Key SQL Analytical Queries

### 1. Overall Attrition Rate
```sql
SELECT ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee;
-- Result: 16.1%
```

### 2. Attrition by Department
```sql
SELECT Department,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee
GROUP BY Department
ORDER BY Attrition_Pct DESC;
-- Result: Sales (20.6%) > Human Resources (19.0%) > R&D (13.8%)
```

### 3. Overtime Impact on Attrition
```sql
SELECT OverTime,
       ROUND(100.0 * SUM(Attrition) / COUNT(*), 1) AS Attrition_Pct
FROM hr_employee
GROUP BY OverTime;
-- Result: Overtime = Yes (30.5%) vs Overtime = No (10.4%)
```

### 4. Salary Gap: Leavers vs Stayers
```sql
SELECT Attrition,
       ROUND(AVG(MonthlyIncome), 0) AS Avg_Salary
FROM hr_employee
GROUP BY Attrition;
-- Result: Leavers ($4,787) vs Stayers ($6,833)
```

### 5. High-Risk Employee Risk Score (Current Employees)
```sql
SELECT EmployeeNumber, Department, JobRole, OverTime, JobSatisfaction,
       (CASE WHEN OverTime = 'Yes' THEN 30 ELSE 0 END) +
       (CASE WHEN JobSatisfaction <= 2 THEN 25 ELSE 0 END) +
       (CASE WHEN MonthlyIncome < 5000 THEN 25 ELSE 0 END) +
       (CASE WHEN YearsAtCompany < 2 THEN 20 ELSE 0 END) AS Risk_Score
FROM hr_employee
WHERE Attrition = 0
ORDER BY Risk_Score DESC
LIMIT 10;
```

---

## 📊 Dashboard Preview

### Overview Page

| KPI | Value |
| :--- | :--- |
| Total Employees | 1,470 |
| Attrition Count | 237 |
| Attrition Rate | 16.1% |
| Average Monthly Income | $6,502 |

### Key Visualizations Included

- **Attrition by Department** – Sales has the highest turnover (20.6%), followed closely by Human Resources (19.0%).
- **Attrition by OverTime** – Overtime employees are ~3x more likely to leave (30.5% vs 10.4%).
- **Attrition by Job Satisfaction** – Lowest satisfaction (Rating 1) drives 22.8% attrition, nearly double the highest-satisfaction group (11.3%).
- **Attrition by Income Band** – Employees earning under $3K/month leave at 28.6%, vs 5.6% for those earning $12K+.
- **Attrition by Work-Life Balance** – Poor work-life balance (rated 1/4) shows the highest attrition at 31.2%.
- **High-Risk Profile Table** – Flags current employees most likely to quit, based on a weighted risk score.

### Dashboard Screenshots

*(Add your page 1 and page 2 screenshots here, e.g. `dashboard/page1_overview.png`, `dashboard/page2_risk_factors.png`)*

---

## 💡 Executive Summary & Recommendations

Based on the analysis, here are the top recommendations:

| Priority | Recommendation | Rationale |
| :--- | :--- | :--- |
| 🔴 High | Review Overtime Policies | Employees working overtime have a 30.5% attrition rate vs. 10.4% without. Implement better workload management and work-life balance initiatives. |
| 🔴 High | Address Low-Income Attrition | Employees earning under $3K/month leave at 28.6% — nearly 5x the rate of top earners. Conduct a market salary review, especially in Sales and R&D. |
| 🔴 High | Investigate HR Department Turnover | HR shows a surprisingly high 19.0% attrition rate, close to Sales. Worth a targeted review despite its small headcount (63 employees). |
| 🟡 Medium | Improve Onboarding for New Hires | Employees with 0–2 years of tenure show the highest attrition of any tenure band. Strengthen early engagement and mentorship programs. |
| 🟡 Medium | Target Work-Life Balance & Job Satisfaction | Poor work-life balance (31.2%) and low job satisfaction (22.8%) both correlate strongly with attrition. Conduct stay interviews and address engagement gaps. |
| 🟢 Low | Focus on Sales Representatives & Lab Technicians | These roles have the highest attrition by job role (39.8% and 23.9%). Investigate specific job challenges and career progression paths. |

---

## 🚀 How to Run This Project

### Prerequisites
- Python 3.x
- MySQL / PostgreSQL
- Power BI Desktop

### Steps

1. **Clone this repository**
   ```bash
   git clone https://github.com/Aniketjadhav0205/Hr-attrition-analytics.git
   cd Hr-attrition-analytics
   ```

2. **Install Python dependencies**
   ```bash
   pip install pandas openpyxl
   ```

3. **Run the cleaning script**
   ```bash
   python hr_data_cleaning.py
   ```

4. **Import data into SQL**
   - Create database `hr_analytics`.
   - Run the `create_table.sql` script.
   - Import `hr_data_cleaned.csv` using the import wizard.

5. **Open the Power BI file**
   - Open `HR_Attrition_Dashboard.pbix` to explore the interactive dashboard.

---

## 📁 Repository Structure

```
Hr-attrition-analytics/
│
├── data/
│   └── hr_data_cleaned.csv                     # Cleaned dataset
│
├── scripts/
│   └── hr_data_cleaning.py                     # Python cleaning script
│
├── sql/
│   └── hr_analytical_queries.sql               # All analytical queries
│
├── dashboard/
│   ├── HR_Attrition_Dashboard.pbix              # Power BI file
│   ├── page1_overview.png                      # Page 1 screenshot
│   └── page2_risk_factors.png                  # Page 2 screenshot
│
├── README.md                                   # This file
└── requirements.txt                            # Python dependencies
```

---

## 📝 Resume-Ready Skills Demonstrated

- **Data Wrangling:** Cleaned 1,470 records with 35 attributes using Pandas.
- **SQL:** Wrote analytical queries using aggregation, `CASE`, and weighted scoring logic.
- **Data Visualization:** Designed a two-page interactive Power BI dashboard with 8+ KPIs and charts, custom DAX measures, and a consistent risk-based color system.
- **Business Storytelling:** Translated raw data into actionable HR retention strategies.

---

## 🤝 Connect with Me

- **LinkedIn:** [Add your LinkedIn URL]
- **Portfolio:** [Add your portfolio URL]
- **Email:** [Add your email]
