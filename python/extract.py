import yfinance as yf
import pandas as pd
from datetime import datetime

# List of tickers we're tracking, with sector/asset class we'll use as fallback
TICKERS = [
    "AAPL", "MSFT", "NVDA", "JPM", "GS", "JNJ", "AMZN",
    "XOM", "DIS", "GOOGL", "PG", "KO", "CVX", "GOVT", "LQD"
]

def extract_securities_info(tickers):
    """Pull company/security metadata for each ticker."""
    records = []
    for ticker in tickers:
        print(f"Fetching info for {ticker}...")
        info = yf.Ticker(ticker).info
        records.append({
            "security_id": ticker,
            "ticker": ticker,
            "security_name": info.get("longName", info.get("shortName", ticker)),
            "asset_class": "Fixed Income" if ticker in ["GOVT", "LQD"] else "Equity",
            "sector": info.get("sector", "N/A"),
            "industry": info.get("industry", "N/A"),
            "country": info.get("country", "N/A"),
            "currency": info.get("currency", "USD"),
        })
    return pd.DataFrame(records)

def extract_market_prices(tickers, period="90d"):
    """Pull daily OHLCV price history for each ticker."""
    all_prices = []
    for ticker in tickers:
        print(f"Fetching prices for {ticker}...")
        data = yf.download(ticker, period=period, progress=False)
        data = data.reset_index()
        data["security_id"] = ticker
        # Flatten column    names in case yfinance returns multi-level columns
        data.columns = [col if isinstance(col, str) else col[0] for col in data.columns]
        all_prices.append(data)
    combined = pd.concat(all_prices, ignore_index=True)
    combined = combined.rename(columns={
        "Date": "date",
        "Open": "open_price",
        "High": "high_price",
        "Low": "low_price",
        "Close": "close_price",
        "Volume": "volume"
    })
    return combined[["date", "security_id", "open_price", "high_price", "low_price", "close_price", "volume"]]

if __name__ == "__main__":
    print("Starting extraction...")
    securities_df = extract_securities_info(TICKERS)
    securities_df.to_csv("data/securities.csv", index=False)
    print(f"Saved {len(securities_df)} securities to data/securities.csv")

    prices_df = extract_market_prices(TICKERS)
    prices_df.to_csv("data/market_prices.csv", index=False)
    print(f"Saved {len(prices_df)} price rows to data/market_prices.csv")

    print("Extraction complete.")