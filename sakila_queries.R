# Sakila Database Queries using data.table
# Author: [Your Name]
# Date: 2025-11-14

# Load required libraries
library(RSQLite)
library(data.table)
library(ggplot2)

# Connect to SQLite database
con <- dbConnect(SQLite(), "sqlite-sakila.db")

# Load all required tables as data.tables
film_dt <- as.data.table(dbReadTable(con, "film"))
language_dt <- as.data.table(dbReadTable(con, "language"))
customer_dt <- as.data.table(dbReadTable(con, "customer"))
store_dt <- as.data.table(dbReadTable(con, "store"))
payment_dt <- as.data.table(dbReadTable(con, "payment"))
staff_dt <- as.data.table(dbReadTable(con, "staff"))
rental_dt <- as.data.table(dbReadTable(con, "rental"))
inventory_dt <- as.data.table(dbReadTable(con, "inventory"))

# Close database connection (we have all data in memory now)
dbDisconnect(con)

# ============================================================================
# QUERY 1: Display all films with rating PG and rental duration > 5 days
# ============================================================================
cat("\n========== QUERY 1 ==========\n")
cat("Films with rating PG and rental duration > 5 days:\n\n")

query1_result <- film_dt[rating == "PG" & rental_duration > 5, 
                         .(film_id, title, rating, rental_duration)]

print(query1_result)
cat("\nTotal films found:", nrow(query1_result), "\n")

# ============================================================================
# QUERY 2: Average rental rate of films, grouped by rating
# ============================================================================
cat("\n========== QUERY 2 ==========\n")
cat("Average rental rate by rating:\n\n")

query2_result <- film_dt[, .(average_rental_rate = mean(rental_rate, na.rm = TRUE)), 
                         by = rating]

print(query2_result)

# ============================================================================
# QUERY 3: Count total number of films in each language
# ============================================================================
cat("\n========== QUERY 3 ==========\n")
cat("Total films by language:\n\n")

query3_result <- film_dt[language_dt, on = .(language_id), 
                         .(language_name = i.name, film_count = .N), 
                         by = .EACHI]

# Alternative approach using merge
query3_result_alt <- merge(film_dt, language_dt, by.x = "language_id", by.y = "language_id")
query3_result_alt <- query3_result_alt[, .(film_count = .N), by = .(language_name = name)]

print(query3_result_alt)

# ============================================================================
# QUERY 4: List customers' names and the store they belong to
# ============================================================================
cat("\n========== QUERY 4 ==========\n")
cat("Customers and their stores:\n\n")

query4_result <- customer_dt[, .(customer_id, 
                                  customer_name = paste(first_name, last_name),
                                  store_id)]

print(head(query4_result, 20))
cat("\nTotal customers:", nrow(query4_result), "\n")

# ============================================================================
# QUERY 5: Payment amount, payment date, and staff member who processed it
# ============================================================================
cat("\n========== QUERY 5 ==========\n")
cat("Payment details with staff information:\n\n")

query5_result <- payment_dt[staff_dt, on = .(staff_id),
                            .(payment_id = i.payment_id,
                              amount = i.amount,
                              payment_date = i.payment_date,
                              staff_name = paste(first_name, last_name))]

# Alternative using merge
query5_result_alt <- merge(payment_dt, staff_dt, by = "staff_id")
query5_result_alt <- query5_result_alt[, .(payment_id, amount, payment_date, 
                                            staff_name = paste(first_name, last_name))]

print(head(query5_result_alt, 20))
cat("\nTotal payments:", nrow(query5_result_alt), "\n")

# ============================================================================
# QUERY 6: Find films that are not rented
# ============================================================================
cat("\n========== QUERY 6 ==========\n")
cat("Films that have never been rented:\n\n")

# Get all film_ids from inventory that have been rented
rented_inventory <- unique(rental_dt$inventory_id)
rented_films <- unique(inventory_dt[inventory_id %in% rented_inventory, film_id])

# Find films not in the rented list
query6_result <- film_dt[!film_id %in% rented_films, .(film_id, title)]

print(query6_result)
cat("\nTotal unreturned films:", nrow(query6_result), "\n")

# ============================================================================
# QUERY 7: Plot - Average Rental Rate by Film Rating
# ============================================================================
cat("\n========== QUERY 7 ==========\n")
cat("Creating visualization: Average Rental Rate by Film Rating\n\n")

# Create a more comprehensive plot
plot_data <- film_dt[, .(
  avg_rental_rate = mean(rental_rate, na.rm = TRUE),
  count = .N
), by = rating]

# Create the plot
p1 <- ggplot(plot_data, aes(x = rating, y = avg_rental_rate, fill = rating)) +
  geom_bar(stat = "identity", width = 0.7) +
  geom_text(aes(label = sprintf("$%.2f", avg_rental_rate)), 
            vjust = -0.5, size = 4) +
  labs(title = "Average Rental Rate by Film Rating",
       subtitle = "Sakila Database Analysis",
       x = "Film Rating",
       y = "Average Rental Rate ($)",
       caption = "Data source: Sakila Database") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(size = 16, face = "bold"),
        axis.text.x = element_text(size = 11),
        axis.text.y = element_text(size = 10)) +
  scale_fill_brewer(palette = "Set3")

# Save the plot
ggsave("rental_rate_by_rating.png", plot = p1, width = 10, height = 6, dpi = 300)
cat("Plot saved as: rental_rate_by_rating.png\n")

# Additional plot: Film Count by Language
p2 <- ggplot(query3_result_alt, aes(x = language_name, y = film_count, fill = language_name)) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_text(aes(label = film_count), vjust = -0.5, size = 5) +
  labs(title = "Total Films by Language",
       subtitle = "Sakila Database Analysis",
       x = "Language",
       y = "Number of Films",
       caption = "Data source: Sakila Database") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(size = 16, face = "bold"))

ggsave("films_by_language.png", plot = p2, width = 10, height = 6, dpi = 300)
cat("Additional plot saved as: films_by_language.png\n")

# ============================================================================
# SUMMARY STATISTICS
# ============================================================================
cat("\n========== SUMMARY ==========\n")
cat("Analysis complete!\n")
cat("Total tables processed: 8\n")
cat("Total queries executed: 7\n")
cat("Plots created: 2\n")

