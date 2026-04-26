# 👥 HR Employee Attrition Analysis

A data analytics project exploring employee attrition patterns using **SQL** for data analysis and **Power BI** for interactive visualizations.

---

## 📌 Project Overview

This project analyzes IBM HR employee data to uncover the key drivers of employee attrition. The goal is to identify at-risk employees, understand departmental trends, and build an employee risk scoring model to support data-driven HR decisions.

---

## 🗂️ Repository Structure

```
hr-attrition-analysis/
│
├── sql/
│   └── Hr_attrition.sql        # All SQL queries and analysis
│
├── powerbi/
│   └── hr_attrition_visuals.pbix  # Interactive Power BI dashboard
│
├── docs/
│   └── data_dictionary.md      # Column definitions and data notes
│
└── README.md
```

---

## 🔍 SQL Analysis

The SQL file covers the following analyses:

| Analysis | Description |
|---|---|
| Data Quality Check | Null checks across key columns |
| Attrition Overview | Overall attrition count (Yes/No) |
| Department Attrition Rate | % of employees leaving per department |
| Sales Department Deep-Dive | Avg income, overtime impact, job role breakdown |
| Job Satisfaction vs Attrition | Attrition rate by satisfaction score (1–4) |
| Salary Trends | Window functions: dense rank, LAG for salary drops |
| **Employee Risk Score** | Composite risk model: Overtime + Low Satisfaction + Salary Drop |

### 🧮 Employee Risk Score Model

A view (`employee_risk_score`) was created to classify each employee into a risk tier:

```sql
CASE
  WHEN total_risk_points >= 2 THEN 'HIGH RISK'
  WHEN total_risk_points = 1  THEN 'Medium Risk'
  ELSE                             'Low Risk'
END
```

**Risk factors:**
- Works overtime → +1
- Job satisfaction = 1 (lowest) → +1
- Monthly income dropped vs previous employee → +1

---

## 📊 Power BI Dashboard

The `.pbix` file contains an interactive dashboard with:

- Attrition rate by department and job role
- Monthly income distribution for leavers vs stayers
- Overtime and job satisfaction breakdowns
- Employee risk score distribution

> **To open:** Download the `.pbix` file and open it with [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free).

---

## 🗃️ Dataset

- **Source:** IBM HR Analytics Employee Attrition dataset (publicly available on Kaggle)
- **Table:** `hr_attrition`
- **Key columns:** `EmployeeNumber`, `Attrition`, `Department`, `JobRole`, `MonthlyIncome`, `JobSatisfaction`, `OverTime`

---

## 🛠️ Tools Used

![SQL](https://img.shields.io/badge/SQL-MySQL-blue?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi&logoColor=black)

- **SQL** — Data exploration, aggregation, window functions, CTEs, views
- **Power BI** — Interactive visualizations and dashboards

---

## 💡 Key Findings

- The **Sales department** has one of the highest attrition rates
- Employees working **overtime** are significantly more likely to leave
- **Low job satisfaction (score = 1)** is strongly correlated with attrition
- **Sales Representatives** show higher attrition than Sales Executives
- Employees with a **salary drop** relative to peers are at elevated risk

---

## 🚀 Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/raghadmohammedismail20-glitch
/hr-attrition-analysis.git
   ```

2. Run the SQL queries in your MySQL/PostgreSQL environment against the `hr_attrition` table.

3. Open `powerbi/hr_attrition_visuals.pbix` in Power BI Desktop.

---

## 📄 License

This project is for educational and portfolio purposes. The dataset is based on publicly available IBM HR data.
