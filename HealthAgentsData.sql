CREATE TABLE agents (
    agent_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50),
    hire_date DATE
);

CREATE TABLE leads (
    lead_id SERIAL PRIMARY KEY,
    agent_id INT REFERENCES agents(agent_id),
    lead_source VARCHAR(50),
    contact_date DATE,
    status VARCHAR(20)  -- e.g., contacted, converted, lost
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    agent_id INT REFERENCES agents(agent_id),
    lead_id INT REFERENCES leads(lead_id),
    sale_date DATE,
    policy_type VARCHAR(50),
    premium_amount NUMERIC(10,2)
);


-- View agents
SELECT * FROM agents LIMIT 5;

-- View leads
SELECT * FROM leads LIMIT 5;

-- View sales
SELECT * FROM sales LIMIT 5;

-- Agent AVG Sale Premium 
SELECT 
    a.agent_id,
    a.name,
    COUNT(s.sale_id) AS total_sales,
    ROUND(AVG(s.premium_amount), 2) AS avg_premium
FROM agents a
LEFT JOIN sales s ON a.agent_id = s.agent_id
GROUP BY a.agent_id, a.name
ORDER BY total_sales DESC;

-- Agent Leads, Sales and Conversion Rate
SELECT
    a.agent_id,
    a.name,
    COUNT(DISTINCT l.lead_id) AS total_leads,
    COUNT(DISTINCT s.sale_id) AS total_sales,
    ROUND(
        CASE WHEN COUNT(DISTINCT l.lead_id) > 0 
            THEN COUNT(DISTINCT s.sale_id) * 100.0 / COUNT(DISTINCT l.lead_id)
            ELSE 0
        END, 2
    ) AS conversion_rate
FROM agents a
LEFT JOIN leads l ON a.agent_id = l.agent_id
LEFT JOIN sales s ON l.lead_id = s.lead_id
GROUP BY a.agent_id, a.name
ORDER BY conversion_rate DESC;

-- Top 5 Agent's Premiums
SELECT 
    a.agent_id,
    a.name,
    SUM(s.premium_amount) AS total_premium
FROM agents a
JOIN sales s ON a.agent_id = s.agent_id
GROUP BY a.agent_id, a.name
ORDER BY total_premium DESC
LIMIT 5;

-- Monthly Sales 
SELECT 
    DATE_TRUNC('month', sale_date) AS sale_month,
    COUNT(*) AS num_sales,
    SUM(premium_amount) AS total_premium
FROM sales
GROUP BY sale_month
ORDER BY sale_month;

-- Lead Source Conversion Rate
SELECT
    l.lead_source,
    COUNT(DISTINCT l.lead_id) AS total_leads,
    COUNT(DISTINCT s.sale_id) AS total_sales,
    ROUND(
        CASE WHEN COUNT(DISTINCT l.lead_id) > 0 
            THEN COUNT(DISTINCT s.sale_id) * 100.0 / COUNT(DISTINCT l.lead_id)
            ELSE 0
        END, 2
    ) AS conversion_rate
FROM leads l
LEFT JOIN sales s ON l.lead_id = s.lead_id
GROUP BY l.lead_source
ORDER BY conversion_rate DESC;

-- New Agent Sales
SELECT
    a.agent_id,
    a.name,
    a.hire_date,
    COUNT(s.sale_id) AS total_sales
FROM agents a
LEFT JOIN sales s ON a.agent_id = s.agent_id
WHERE a.hire_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY a.agent_id, a.name, a.hire_date
ORDER BY total_sales DESC;

-- Policy Type
SELECT
    policy_type,
    COUNT(*) AS num_sold,
    SUM(premium_amount) AS total_premium
FROM sales
GROUP BY policy_type
ORDER BY num_sold DESC;

-- Failed Leads
SELECT
    l.lead_id,
    l.agent_id,
    l.lead_source,
    l.contact_date
FROM leads l
LEFT JOIN sales s ON l.lead_id = s.lead_id
WHERE s.sale_id IS NULL;

-- AVG premium per Sale vs. Average Leads
SELECT
    a.agent_id,
    a.name,
    COUNT(DISTINCT l.lead_id) AS total_leads,
    COUNT(DISTINCT s.sale_id) AS total_sales,
    ROUND(AVG(s.premium_amount), 2) AS avg_premium_per_sale
FROM agents a
LEFT JOIN leads l ON a.agent_id = l.agent_id
LEFT JOIN sales s ON a.agent_id = s.agent_id
GROUP BY a.agent_id, a.name
ORDER BY avg_premium_per_sale DESC;

-- Monthly Growth 
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        SUM(premium_amount) AS total_premium
    FROM sales
    GROUP BY month
)
SELECT
    month,
    total_premium,
    LAG(total_premium) OVER (ORDER BY month) AS prev_month_premium,
    ROUND(
        CASE WHEN LAG(total_premium) OVER (ORDER BY month) > 0
             THEN (total_premium - LAG(total_premium) OVER (ORDER BY month)) * 100.0
                  / LAG(total_premium) OVER (ORDER BY month)
             ELSE NULL
        END, 2
    ) AS pct_growth
FROM monthly
ORDER BY month;

-- Agent Ranks 
WITH agent_metrics AS (
    SELECT
        a.agent_id,
        a.name,
        COUNT(DISTINCT l.lead_id) AS total_leads,
        COUNT(DISTINCT s.sale_id) AS total_sales,
        SUM(s.premium_amount) AS total_premium
    FROM agents a
    LEFT JOIN leads l ON a.agent_id = l.agent_id
    LEFT JOIN sales s ON a.agent_id = s.agent_id
    GROUP BY a.agent_id, a.name
)
SELECT
    agent_id,
    name,
    total_leads,
    total_sales,
    total_premium,
    ROUND(total_sales::decimal / NULLIF(total_leads, 0) * 50  -- weight conversion rate
        + total_premium / 1000 * 50, 2) AS performance_score
FROM agent_metrics
ORDER BY performance_score DESC;

-- Days Between Contact Date and Sale Date
SELECT
    ROUND(AVG(s.sale_date - l.contact_date), 2) AS avg_days_to_convert
FROM sales s
JOIN leads l ON s.lead_id = l.lead_id;

-- Data Quality Check (if null then assign to agent)
SELECT *
FROM leads
WHERE agent_id IS NULL;










