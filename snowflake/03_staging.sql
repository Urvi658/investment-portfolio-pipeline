CREATE OR REPLACE TABLE STG_SECURITIES AS
SELECT DISTINCT
    TRIM(security_id) AS security_id,
    TRIM(ticker) AS ticker,
    TRIM(security_name) AS security_name,
    TRIM(asset_class) AS asset_class,
    TRIM(sector) AS sector,
    TRIM(industry) AS industry,
    TRIM(country) AS country,
    TRIM(currency) AS currency
FROM FINANCE_DB.RAW.RAW_SECURITIES
WHERE security_id IS NOT NULL;

CREATE OR REPLACE TABLE STG_PORTFOLIOS AS
SELECT DISTINCT
    TRIM(portfolio_id) AS portfolio_id,
    TRIM(portfolio_name) AS portfolio_name,
    TRIM(portfolio_type) AS portfolio_type,
    TRIM(portfolio_manager) AS portfolio_manager,
    TRIM(benchmark) AS benchmark
FROM FINANCE_DB.RAW.RAW_PORTFOLIOS
WHERE portfolio_id IS NOT NULL;

CREATE OR REPLACE TABLE STG_HOLDINGS AS
SELECT DISTINCT
    TRIM(portfolio_id) AS portfolio_id,
    TRIM(security_id) AS security_id,
    trade_date,
    quantity,
    average_cost
FROM FINANCE_DB.RAW.RAW_HOLDINGS
WHERE portfolio_id IS NOT NULL
  AND security_id IS NOT NULL
  AND quantity > 0;

CREATE OR REPLACE TABLE STG_MARKET_PRICES AS
SELECT DISTINCT
    date,
    TRIM(security_id) AS security_id,
    open_price,
    high_price,
    low_price,
    close_price,
    volume
FROM FINANCE_DB.RAW.RAW_MARKET_PRICES
WHERE security_id IS NOT NULL
  AND date IS NOT NULL
  AND close_price IS NOT NULL
  AND close_price >= 0
  AND high_price >= low_price;