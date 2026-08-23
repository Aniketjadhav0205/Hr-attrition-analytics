import pandas as pd
import numpy as np

# Load the data
df = pd.read_csv(r'C:\Users\artist\Desktop\DA project 1\data\WA_Fn-UseC_-HR-Employee-Attrition.csv')

# Quick look
print(df.head())
print(df.info())
print(df.isnull().sum())  # Check for missing values

# 1. Check for missing values - this dataset has some!
print(df.isnull().sum())

# 2. Drop duplicates if any
df.drop_duplicates(inplace=True)

# 3. Fix inconsistent department names (if any)
df['Department'] = df['Department'].str.strip()

# 4. Convert categorical columns to proper format
df['Attrition'] = df['Attrition'].map({'Yes': 1, 'No': 0})  # Binary for analysis

# 5. Create new useful columns
df['Tenure_Group'] = pd.cut(df['YearsAtCompany'], 
                            bins=[0, 2, 5, 10, 20, 40],
                            labels=['0-2', '3-5', '6-10', '11-20', '20+'])

# 6. Save cleaned data
df.to_csv(r'C:\Users\artist\Desktop\DA project 1\data\hr_data_cleaned.csv', index=False)
print("✅ Data cleaned! Shape:", df.shape)