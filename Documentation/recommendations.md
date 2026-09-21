# Recommendations

These recommendations are evidence-based, derived from the sales, funnel, and cohort retention analysis of the Olist e-commerce dataset.

## 1. Implement a Targeted "Second Purchase" Campaign
**Problem:** The Repeat Purchase Rate is very low (3.03%), indicating a reliance on expensive new customer acquisition.
**Evidence:** Customer analysis shows that ~97% of users only ever make one purchase. Cohort analysis reveals a sharp drop-off in Month 1 to roughly 5%.
**Recommended Action:** Trigger an automated, personalized email sequence offering a time-sensitive discount 15-30 days after the first delivery. Focus the messaging on categories related to their initial purchase.
**Business Objective:** Increase Customer Lifetime Value (CLV) and reduce overall Customer Acquisition Cost (CAC) payback period.
**KPI to Monitor:** Repeat Purchase Rate, Average Time to Second Purchase.

## 2. Optimize Logistics Strategy for High-Potential States
**Problem:** Revenue is heavily concentrated in SP, while other populous states lag behind, potentially due to poor delivery experiences.
**Evidence:** Funnel analysis indicates varied delivery conversion rates by state, and sales analysis shows steep drop-offs in order volume outside the southeast region.
**Recommended Action:** Analyze the correlation between `freight_value`, `estimated_delivery_date` vs `actual_delivery_date`, and order volume in non-SP states. Consider establishing local distribution hubs or partnering with regional carriers to lower freight costs and delivery times.
**Business Objective:** Expand market share and increase sales penetration in underrepresented regions.
**KPI to Monitor:** Revenue by State (Year-over-Year growth), Average Freight Value per State.

## 3. Revamp the Post-Purchase Review Collection Process
**Problem:** Order reviews don't perfectly map to chronological delivery, and many reviews are for unfulfilled orders or left prematurely.
**Evidence:** The funnel indicates more total reviews exist than successfully delivered orders. 
**Recommended Action:** Redesign the review request pipeline to only trigger *after* the `order_delivered_customer_date` is stamped by the carrier. 
**Business Objective:** Generate accurate social proof and reduce skewed metrics from frustrated customers whose packages are stuck in transit.
**KPI to Monitor:** Delivered-to-Reviewed Conversion Rate.

## 4. Promote "Gateway" Products
**Problem:** Most product categories do not generate repeat buying behavior.
**Evidence:** Cohort and category analysis shows low retention across the board.
**Recommended Action:** Identify the specific product categories (e.g., consumables, beauty, pet supplies) that *do* have above-average repeat purchase rates. Reallocate a portion of the top-of-funnel marketing budget to feature these "gateway" products, as acquiring a customer through these items yields a higher lifetime value.
**Business Objective:** Improve long-term retention by acquiring customers through sticky product categories.
**KPI to Monitor:** Cohort Retention Rate (Month 3+), CLV by First-Purchase Category.
