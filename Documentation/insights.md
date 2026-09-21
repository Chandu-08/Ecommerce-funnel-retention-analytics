# Business Insights

*(Note: Actual numbers will be updated after the final Power BI dashboard is populated with data.)*

## Insight 1: Customer Retention is a Major Opportunity
**Observation:** The analysis shows that a vast majority of customers made only a single purchase, while repeat customers account for a very small fraction of the total base.
**Metric:** Repeat Purchase Rate (3.03%).
**Comparison:** Compared to industry standards for mature e-commerce platforms, this retention rate is extremely low.
**Business Interpretation:** The business is heavily reliant on new customer acquisition rather than maximizing Customer Lifetime Value (CLV).
**Potential Action:** Implement targeted post-purchase retention campaigns, loyalty programs, or subscription models to incentivize second purchases.

## Insight 2: Funnel Drop-off at Shipping and Delivery
**Observation:** The funnel indicates a 98.3% conversion from Approved to Shipped (losing ~1,600 orders) and 98.7% conversion from Shipped to Delivered (losing ~1,180 orders). Interestingly, reviews exceed deliveries, meaning customers are reviewing products before they arrive or reviewing canceled orders.
**Metric:** Delivery conversion rate.
**Business Interpretation:** While order approval is near perfect, logistical fulfillment holds up over 2,800 orders.
**Potential Action:** Optimize the logistics pipeline and investigate why certain orders get stuck between approval and carrier pickup.

## Insight 3: Regional Concentration of Sales
**Observation:** A significant portion of total revenue and order volume is concentrated in the SP (São Paulo) state.
**Metric:** Revenue and Order Volume by State.
**Comparison:** SP generates X% more revenue than the next highest state.
**Business Interpretation:** Marketing and logistics are highly optimized for SP, but there is massive untapped potential or logistical friction in other regions.
**Potential Action:** Investigate freight costs and delivery times in underperforming states to determine if they are acting as barriers to entry.

## Insight 4: Cohort Retention Degradation
**Observation:** Looking at the cohort heatmap, customer return rates drop sharply after the first month (Average Month 1 retention is just 5.2%) and rarely recover in subsequent months.
**Metric:** Month 1 Cohort Retention.
**Business Interpretation:** The product offerings or customer experience are not currently driving habitual buying behavior.
**Potential Action:** Conduct a deep dive into the specific categories purchased by the small group of retained customers to understand what drives repeat business, and promote those "gateway" products to new users.

## Insight 5: Revenue vs. Freight Cost Imbalance
**Observation:** For certain lower-priced product categories, the `freight_value` makes up a disproportionately high percentage of the `order_value_calculated`.
**Metric:** Freight as % of Total Order Value.
**Business Interpretation:** High shipping costs relative to product price likely deter cart conversion and repeat purchases for these categories.
**Potential Action:** Negotiate better shipping rates for lightweight items, introduce a minimum order threshold for free shipping, or bundle products to increase Average Order Value (AOV).
