# Insurance-Sales-Lead-Funnel-Analysis
This project simulates a real-world **Business Intelligence (BI) / Data Analyst** workflow: collecting and analyzing sales and lead funnel data for an insurance sales organization.   The goal is to understand agent performance, lead conversion efficiency, revenue trends, and operational improvements.

---

## 🧰 **Project Overview**

* **Business context:**  
  An insurance sales team manages many agents selling health plans. Leadership needs insights into:
  - Agent productivity
  - Lead-to-sale conversion rates
  - Premium revenue trends
  - Effectiveness of different lead sources
  - Operational bottlenecks

* **Dataset:**  
  Simulated data built with:
  - `agents.csv` – list of agents, regions, hire dates
  - `leads.csv` – leads assigned to agents, lead sources & statuses
  - `sales.csv` – closed sales, policy types, sale dates & premium amounts

* **Tools:**  
  - PostgreSQL for querying
  - (Optional) Tableau / Power BI for visualization

---

## 📊 **Key KPIs & Metrics**

| KPI | Why it matters |
|----|----------------|
| **Total sales & average premium per agent** | Identifies high-revenue agents & training needs |
| **Lead-to-sale conversion rate** | Measures sales funnel efficiency |
| **Top agents by total premium** | Highlights top performers |
| **Monthly premium growth** | Tracks business momentum |
| **Average premium per lead source** | Optimizes marketing spend |
| **Average time to convert** | Identifies operational bottlenecks |
| **Weighted agent performance score** | Combines volume & efficiency into a single index |

---

## 📈 **Advanced Analysis Examples**

✅ **Agent ranking by weighted performance score**  
Balances total premium and conversion rate.

✅ **Lead source ROI proxy**  
Which channels bring the highest average premium per lead.

✅ **Month-over-month revenue growth**  
Tracks sales momentum.

✅ **Time-to-convert**  
Measures speed from lead contact to closing.

✅ **Data quality checks**  
E.g., leads without agent IDs.

---
/data
  agents.csv
  leads.csv
  sales.csv

/sql
  analysis_queries.sql

README.md
