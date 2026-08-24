CREATE OR REPLACE TABLE RAW_SECURITIES (
    security_id STRING,
    ticker STRING,
    security_name STRING,
    asset_class STRING,
    sector STRING,
    industry STRING,
    country STRING,
    currency STRING
);

CREATE OR REPLACE TABLE RAW_PORTFOLIOS (
    portfolio_id STRING,
    portfolio_name STRING,
    portfolio_type STRING,
    portfolio_manager STRING,
    benchmark STRING
);

CREATE OR REPLACE TABLE RAW_HOLDINGS (
    portfolio_id STRING,
    security_id STRING,
    trade_date DATE,
    quantity NUMBER,
    average_cost FLOAT
);

CREATE OR REPLACE TABLE RAW_MARKET_PRICES (
    date DATE,
    security_id STRING,
    open_price FLOAT,
    high_price FLOAT,
    low_price FLOAT,
    close_price FLOAT,
    volume NUMBER
);