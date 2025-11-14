# Install required R packages for Sakila analysis

# Function to check and install packages
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    install.packages(package, repos = "https://cloud.r-project.org/", quiet = TRUE)
    library(package, character.only = TRUE)
    cat(paste("Installed and loaded:", package, "\n"))
  } else {
    cat(paste("Already installed:", package, "\n"))
  }
}

# Install required packages
cat("Installing required packages...\n\n")
install_if_missing("RSQLite")
install_if_missing("data.table")
install_if_missing("ggplot2")

cat("\nAll required packages are installed!\n")

