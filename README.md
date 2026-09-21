# 🛒 E-Commerce Funnel, Retention & Sales Analytics

> **An end-to-end SQL Server, Python, and Power BI project analyzing e-commerce sales performance, purchase-funnel conversion, and customer retention — built on the real Olist Brazilian E-Commerce dataset (~100K orders).**

## 📌 Business Problem

Top-line revenue numbers hide two things most e-commerce businesses can't see without deeper analysis: where the operational funnel is leaking orders, and how dependent the business is on new customer acquisition versus repeat buyers. Without that visibility, retention spend gets deprioritized in favor of top-of-funnel acquisition — even when acquisition is the more expensive lever.

This project answers three questions a growth/operations team would actually ask:
1. **What's our real revenue and order baseline?** Olist's data is spread across 9 linked tables with 1-to-many relationships (one order → multiple items → multiple payments) — getting this wrong silently duplicates revenue.
2. **Where do orders leak** between payment approval, carrier shipping, and delivery?
3. **How much of our business depends on repeat customers**, and how fast does retention decay after the first purchase?

## 🔑 Key Findings

*(All numbers below are computed directly from the dataset — no estimates or placeholders.)*

| Finding | What it means |
| :--- | :--- |
| **Repeat purchase rate: 3.03%** (Month 1 retention: 5.2%) | The business is almost entirely acquisition-driven — the vast majority of customers never return after their first order. |
| **2,800+ orders stuck or lost** between approval, shipping, and delivery, despite ~100% payment approval | The funnel leak isn't at checkout — it's in logistics fulfillment, after the sale is already made. |
| **Review scores are skewed by shipping delays**, not just product satisfaction — many reviews are submitted before delivery is even marked complete | Review data can't be trusted as a pure product-quality signal without adjusting for delivery timing. |

📄 **Full write-ups:** [Business Insights](Documentation/insights.md) · [Recommendations](Documentation/recommendations.md)

## 🛠️ Tech Stack & Skills Demonstrated

| Layer | Tools | What it's doing |
| :--- | :--- | :--- |
| Data consolidation | **SQL Server (T-SQL)** | Staging load, data quality checks, 1-to-many grain consolidation via CTEs, window functions, aggregation |
| Cohort & retention modeling | **Python (Pandas)** | First-purchase cohort assignment, retention matrix generation |
| Reporting | **Power BI** | Executive KPI dashboard, funnel visualization, retention heatmap |

*This project deliberately avoids machine learning — the goal is analytical depth and data integrity, not predictive modeling.*

## 🏗️ Pipeline

```text
9 raw CSVs → SQL staging tables 
  ↓
Data quality checks (orphan records, duplicates, invalid states) 
  ↓ 
Grain consolidation in SQL (CTEs) → analytical_orders table (1 row = 1 order) — prevents revenue duplication from 1-to-many joins 
  ↓ 
Python (Pandas): cohort assignment + retention matrix 
  ↓ 
Power BI: executive dashboard (KPIs, funnel, retention heatmap)
```

> **The grain-consolidation step is the technical core of this project:** order items and payments are aggregated to order-level before joining back to the orders table, which is what keeps revenue and order-count numbers accurate.

## 📂 Repository Structure

```text
├── Data/            # Raw CSV files (Olist dataset, via Kaggle) 
├── SQL/             # Sequential T-SQL scripts (01_staging → 06_funnel_analysis) 
├── Python/          # cohort_analysis.ipynb — retention matrix + heatmap generation 
├── PowerBI/         # DAX measure guide + final .pbix dashboard 
└── Documentation/   # Data dictionary, limitations, full insights & recommendations
```

## ⚠️ Limitations

* **Historical data (2016–2018)** — patterns reflect that period, not necessarily current platform behavior
* **Review scores are self-selected and time-sensitive** to delivery status — not a clean product-satisfaction measure on their own
* **No marketing/acquisition-channel data** — funnel leakage is analyzed operationally, not attributed to marketing quality
* **Correlational findings** (e.g., delivery delay vs. reviews) are not causal — see [Documentation/limitations.md](Documentation/limitations.md) for the full breakdown

## 📊 Dashboard Preview

*(Add a screenshot of your Power BI executive dashboard here once finalized — this is usually the first thing a recruiter looks at.)*

---
*Dataset: Olist Brazilian E-Commerce Public Dataset, via Kaggle.*
