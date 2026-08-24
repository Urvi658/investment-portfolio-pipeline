CREATE OR REPLACE TABLE DIM_SECURITY AS
SELECT
    security_id,
    ticker,
    security_name,
    asset_class,
    sector,
    industry,
    country,
    currency
FROM FINANCE_DB.STAGING.STG_SECURITIES;

CREATE OR REPLACE TABLE DIM_PORTFOLIO AS
SELECT
    portfolio_id,
    portfolio_name,
    portfolio_type,
    portfolio_manager,
    benchmark
FROM FINANCE_DB.STAGING.STG_PORTFOLIOS;

CREATE OR REPLACE TABLE DIM_DATE AS
SELECT
    date_value AS date,
    YEAR(date_value) AS year,
    MONTH(date_value) AS month,
    DAY(date_value) AS day,
    DAYNAME(date_value) AS day_name,
    MONTHNAME(date_value) AS month_name,
    QUARTER(date_value) AS quarter,
    CASE WHEN DAYOFWEEK(date_value) IN (0,6) THEN FALSE ELSE TRUE END AS is_weekday
FROM (
    SELECT DATEADD(day, SEQ4(), '2026-01-01'::DATE) AS date_value
    FROM TABLE(GENERATOR(ROWCOUNT => 365))
);

CREATE OR REPLACE TABLE FACT_HOLDINGS AS
SELECT
    portfolio_id,
    security_id,
    trade_date,
    quantity,
    average_cost,
    current_price,