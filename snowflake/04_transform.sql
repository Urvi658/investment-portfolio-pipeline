CREATE OR REPLACE TABLE TRF_MARKET_PRICES AS
SELECT
    date,
    security_id,
    open_price,
    high_price,
    low_price,
    close_price,
    volume,
    LAG(close_price) OVER (PARTITION BY security_id ORDER BY date) AS previous_close,
    (close_price - LAG(close_price) OVER (PARTITION BY security_id ORDER BY date))
        / NULLIF(LAG(close_price) OVER (PARTITION BY security_id ORDER BY date), 0) AS daily_return
FROM FINANCE_DB.STAGING.STG_MARKET_PRICES;

CREATE OR REPLACE TABLE TRF_HOLDINGS AS
WITH latest_prices AS (
    SELECT security_id, close_price
    FROM TRF_MARKET_PRICES
    QUALIFY ROW_NUMBER() OVER (PARTITION BY security_id ORDER BY date DESC) = 1
),
holding_values AS (
    SELECT
        h.portfolio_id,
        h.security_id,
        h.trade_date,
        h.quantity,
        h.average_cost,
        p.close_price AS current_price,
        h.quantity * p.close_price AS market_value
    FROM FINANCE_DB.STAGING.STG_HOLDINGS h
    JOIN latest_prices p ON h.security_id = p.security_id
),
portfolio_totals AS (
    SELECT portfolio_id, SUM(market_value) AS total_portfolio_value
    FROM holding_values
    GROUP BY portfolio_id
)
SELECT
    hv.portfolio_id,
    hv.security_id,
    hv.trade_date,
    hv.quantity,
    hv.average_cost,
    hv.current_price,
    hv.market_value,
    pt.total_portfolio_value,
    hv.market_value / NULLIF(pt.total_portfolio_value, 0) AS position_weight
FROM holding_values hv
JOIN portfolio_totals pt ON hv.portfolio_id = pt.portfolio_id;