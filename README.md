# Swiggy Data Analysis Project

## Project Overview

This project focuses on analyzing Swiggy food delivery data using SQL and MySQL Workbench. The goal is to clean the raw dataset, identify duplicate records, organize the data into a structured schema, and perform data analysis to understand restaurant ratings, food prices, popular dishes, and location-wise trends.

## Objectives

- Clean and prepare raw food delivery data for analysis.
- Identify duplicate and missing records.
- Convert order dates into a consistent date format.
- Design dimension tables and a fact table.
- Analyze restaurant ratings, dish prices, categories, and locations.
- Write SQL queries to extract meaningful insights from the data.

## Tools and Technologies

- **Database:** MySQL
- **SQL:** Data cleaning, filtering, aggregation, joins, duplicate detection, and data transformation
- **IDE:** MySQL Workbench

## Dataset Description

The dataset contains food delivery-related information, including:

- State and city
- Order date
- Restaurant name
- Restaurant location
- Food category
- Dish name
- Price in INR
- Restaurant or dish rating
- Rating count

*Note: The actual dataset source and record count can be added here when confirmed.*

## Project Workflow

### 1. Data Exploration
- Inspected the raw dataset and its columns.
- Reviewed data types and sample records.
- Checked for missing values and duplicate records.

### 2. Data Cleaning
- Standardized date values using MySQL date conversion functions.
- Checked for duplicate records.
- Reviewed missing and inconsistent values.

### 3. Database Design
Created a structured schema using a fact table and dimension tables.

**Dimension tables**
- `dim_date`
- `dim_location`
- `dim_restaurant`
- `dim_category`
- `dim_dish`

**Fact table**
- `fact_swiggy_orders`

The fact table connects to the dimension tables through keys to support organized and efficient analysis.

### 4. SQL Analysis
SQL queries were used to explore the dataset, identify duplicates, summarize records, and prepare data for further analysis.

## Key Business Questions

1. Which restaurants have the highest ratings?
2. Which food categories have the highest average prices?
3. Which dishes are the most expensive?
4. How does the number of records vary by city and state?
5. Which restaurants have the highest rating counts?
6. What are the monthly trends in the dataset?
7. Are there duplicate records in the raw data?
8. How can a star-schema design support further analysis?

*These are analysis questions for the project; add confirmed findings after running the corresponding queries.*

## Repository Structure

```text
swiggy-data-analysis/
│
├── README.md
├── data/
│   └── dataset_source.txt
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_duplicate_detection.sql
│   ├── 04_schema_creation.sql
│   ├── 05_data_transformation.sql
│   └── 06_analysis_queries.sql
└── screenshots/
    └── project_results.png
```

*Create these folders and files only as you organize your actual project. Include the dataset only if you have permission to share it.*

## Learning Outcomes

- Improved practical knowledge of SQL and MySQL Workbench.
- Learned to inspect and clean real-world-style data.
- Practiced duplicate detection and date conversion.
- Understood fact and dimension tables.
- Developed a foundation for analytical reporting and business insights.

## Conclusion

This project demonstrates the use of SQL for data preparation, database design, and exploratory analysis of food delivery data. It provides a foundation for deriving business insights and can be extended with interactive dashboards using Power BI or Tableau.

## Author

**Pallavi Aghao**

Aspiring Data Analyst | SQL | Excel | Power BI | Python

GitHub: Add your GitHub profile link here.
