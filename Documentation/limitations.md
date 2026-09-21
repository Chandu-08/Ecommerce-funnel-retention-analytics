# Project Limitations

It is crucial to contextualize the findings of this analysis within the limitations of the dataset and the analytical methods used.

## 1. Historical Nature of Data
The Olist dataset represents historical e-commerce activity (primarily 2016–2018). While the analytical methodologies remain entirely valid, the specific numerical findings (e.g., total revenue, category popularity) do not reflect the current state of the Brazilian e-commerce market. 

## 2. Lack of Marketing and Acquisition Data
The dataset lacks top-of-funnel marketing metrics (e.g., website visits, bounce rates, ad spend, CAC, source/medium). 
* **Impact:** We cannot calculate Customer Acquisition Cost (CAC), Return on Ad Spend (ROAS), or determine which marketing channels drive the highest quality cohorts. The funnel begins at "Purchased", missing the crucial "Visited -> Added to Cart -> Checkout" stages.

## 3. Interpreting Missing Reviews
In the operational funnel analysis, a significant drop-off occurs at the "Reviewed" stage.
* **Important Caveat:** A missing review does **not** necessarily indicate customer dissatisfaction or a failed delivery experience. It simply means the customer chose not to engage with the review prompt. We cannot automatically classify non-reviewers as churned or unhappy.

## 4. Causation vs. Correlation
The insights presented are based on observational data. While we can identify correlations (e.g., higher freight costs associated with fewer orders in certain states), this analysis does not establish strict causation without controlled A/B testing.

## 5. Cohort Maturity
When viewing the Cohort Retention Matrix, recent cohorts (those near the end of the dataset's timeframe) have an inherently shorter observation window. 
* **Impact:** Immature cohorts should not be directly compared against mature cohorts for long-term metrics (e.g., Month 12 retention), as the newer cohorts haven't existed long enough to generate that data.

## 6. Financial Discrepancies
The dataset exhibits occasional discrepancies between the sum of `order_items.price` + `freight_value` and the total `order_payments.payment_value`. 
* **Resolution:** This is likely due to undocumented discounts, vouchers, or interest on installments. For this project, `payment_value` was treated as the ultimate source of truth for Revenue.
