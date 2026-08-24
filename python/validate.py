import pandas as pd

def validate_market_prices(filepath="data/market_prices.csv"):
    """Check market prices for duplicates, missing values, and invalid prices."""
    df = pd.read_csv(filepath)

    issues = []

    # 1. Duplicate records (same security_id + date appearing more than once)
    duplicates = df[df.duplicated(subset=["security_id", "date"], keep=False)]
    if len(duplicates) > 0:
        dup_flagged = duplicates.copy()
        dup_flagged["error_type"] = "Duplicate record"
        issues.append(dup_flagged)

    # 2. Missing price values (nulls in any price column)
    price_cols = ["open_price", "high_price", "low_price", "close_price"]
    missing = df[df[price_cols].isnull().any(axis=1)]
    if len(missing) > 0:
        missing_flagged = missing.copy()
        missing_flagged["error_type"] = "Missing price"
        issues.append(missing_flagged)

    # 3. Invalid negative prices
    negative = df[(df[price_cols] < 0).any(axis=1)]
    if len(negative) > 0:
        negative_flagged = negative.copy()
        negative_flagged["error_type"] = "Negative price"
        issues.append(negative_flagged)

    # 4. Invalid logic: high price lower than low price
    illogical = df[df["high_price"] < df["low_price"]]
    if len(illogical) > 0:
        illogical_flagged = illogical.copy()
        illogical_flagged["error_type"] = "High price below low price"
        issues.append(illogical_flagged)

    if issues:
        all_issues = pd.concat(issues, ignore_index=True)
    else:
        all_issues = pd.DataFrame(columns=list(df.columns) + ["error_type"])

    clean_df = df.drop(index=df.index.intersection(all_issues.index)) if len(all_issues) > 0 else df

    return clean_df, all_issues

def validate_securities(filepath="data/securities.csv"):
    """Check securities metadata for missing critical fields."""
    df = pd.read_csv(filepath)
    missing_name = df[df["security_name"].isnull() | (df["security_name"] == "")]
    return missing_name

if __name__ == "__main__":
    print("Validating market prices...")
    clean_prices, price_issues = validate_market_prices()
    print(f"Clean rows: {len(clean_prices)}")
    print(f"Flagged rows: {len(price_issues)}")

    if len(price_issues) > 0:
        price_issues.to_csv("data/market_data_errors.csv", index=False)
        print("Saved flagged rows to data/market_data_errors.csv")
        print(price_issues["error_type"].value_counts())
    else:
        print("No data quality issues found in market prices.")

    print("\nValidating securities...")
    sec_issues = validate_securities()
    if len(sec_issues) > 0:
        print(f"Found {len(sec_issues)} securities with missing names.")
    else:
        print("No missing security names found.")

    print("\nValidation complete.")