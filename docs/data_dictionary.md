# Data Dictionary# Data Dictionary
## Investment Portfolio Analytics & Risk Intelligence Pipeline

## Core Business Terms

**Market Value** = Quantity × Current Price
**Position Weight** = Security Market Value / Total Portfolio Market Value
**AUM (Assets Under Management)** = Sum of market value across all holdings in a portfolio
**Daily Return** = (Current Price − Previous Price) / Previous Price
**Portfolio Return** = Weighted sum of each holding's daily return, weighted by position weight
**Excess Return** = Portfolio Return − Benchmark Return
**Sector Exposure** = % of portfolio market value concentrated in a given sector

## Data Sources

- **Securities & Market Prices**: Real data pulled live via the `yfinance` Python library (Yahoo Finance API)
- **Portfolios & Holdings**: Synthetic data, hand-built to represent a realistic 2-fund investment firm

## Schema Architecture (Snowflake, database: FINANCE_DB)

| Schema | Purpose |
|---|---|
| RAW | Data exactly as extracted from source, no transformations |
| STAGING | Cleaned, trimmed, deduplicated, invalid records filtered out |
| TRANSFORM | Business logic applied — market value, weights, returns |
| ANALYTICS | Final dimensional model (star schema) consumed by Power BI |

## ANALYTICS Layer Tables

### DIM_SECURITY
| Column | Description |
|---|---|
| security_id | Ticker symbol, primary key |
| ticker | Same as security_id |
| security_name | Full company/fund name |
| asset_class | Equity or Fixed Income |
| sector | GICS sector (Technology, Financials, etc.) |
| industry | GICS industry |
| country | Country of domicile |
| currency | Trading currency |

### DIM_PORTFOLIO
| Column | Description |
|---|---|
| portfolio_id | Primary key (PORT_001, PORT_002) |
| portfolio_name | Display name (Growth Fund, Balanced Fund) |
| portfolio_type | Equity or Balanced |
| portfolio_manager | Manager name |
|