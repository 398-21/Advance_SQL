import pandas as pd

# Read the Parquet file
parquet_file = 'yellow_tripdata_2024-03.parquet'
df = pd.read_parquet(parquet_file)

# Convert to CSV
csv_file = 'yellow_tripdata_Mar.csv'
df.to_csv(csv_file, index=False)

print(f'Parquet file {parquet_file} has been converted to CSV file {csv_file}')
