# Sakila Database Analysis with R and data.table

This project contains R queries and analysis of the Sakila sample database using the data.table package.

## Requirements

- R (version 4.0 or higher recommended)
- Required R packages:
  - `RSQLite` - For SQLite database connection
  - `data.table` - For efficient data manipulation
  - `ggplot2` - For data visualization

## Installation

Install the required packages in R:

```r
install.packages(c("RSQLite", "data.table", "ggplot2"))
```

## Project Structure

- `sqlite-sakila.db` - Sakila SQLite database file
- `sakila_queries.R` - Main R script with all queries
- `rental_rate_by_rating.png` - Visualization output
- `films_by_language.png` - Additional visualization

## Queries Included

1. **Query 1**: Display all films with rating PG and rental duration > 5 days
2. **Query 2**: Average rental rate of films, grouped by rating
3. **Query 3**: Count total number of films in each language
4. **Query 4**: List customers' names and the store they belong to
5. **Query 5**: Payment amount, payment date, and staff member who processed each payment
6. **Query 6**: Find films that are not rented
7. **Query 7**: Create visualizations of the data

## Usage

Run the analysis script:

```bash
Rscript sakila_queries.R
```

Or in R console:

```r
source("sakila_queries.R")
```

## Output

The script will:
- Print results of all queries to the console
- Generate two PNG files with visualizations
- Display summary statistics

## Database Schema

The Sakila database contains the following tables used in this analysis:
- `film` - Movie information
- `language` - Language information
- `customer` - Customer details
- `store` - Store information
- `payment` - Payment transactions
- `staff` - Staff member details
- `rental` - Rental records
- `inventory` - Inventory items

## Author

Assignment for Sakila Database Analysis Course

## Date

November 14, 2025

