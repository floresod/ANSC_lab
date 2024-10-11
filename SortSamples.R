# Load necessary library
library(readxl)  # to read xlsx files
library(tidyverse)  # includes a number of useful packages 
library(writexl)  # to save table as xlsx


# Define the file path
file_path <- "Plates.xlsx"

# List of sheet names
sheets <- c("PlateA", "PlateB", "PlateC", "PlateD", "PlateE", "PlateF", "PlateG")

# Initialize an empty list to store data frames
plate_data_list <- list()

# Loop through each sheet and read the data into a list
for (sheet in sheets) {
  # Read the sheet into a data frame, treating the first column as row names (A-H)
  plate_data <- read_excel(file_path, sheet = sheet)
  
  # Rename the first column to "Row"
  colnames(plate_data)[1] <- "Row"
  
  # Add a new column with the name of the sheet
  plate_data$Plate <- sheet
  
  # Append the data frame to the list
  plate_data_list[[sheet]] <- plate_data
}

# Combine all the data frames into one
combined_plate_data <- do.call(rbind, plate_data_list)


# tidy format 
tidy_data <- combined_plate_data %>% 
  pivot_longer(cols = -c(Plate, Row), names_to = "Column", values_to = "Sample" ) %>% 
  unite(col = "Index_plate_map", Row, Column, sep = "" ) %>% 
  select(Plate, Index_plate_map, Sample)

######### Optional ####################################################################### 
# We can include a table with metadata, such as the barcodes and inlines used in each plate 
# and the pool where the samples are located. 
# we can joined them using left_join()
###########################################################################################

# Save the tidy data to an Excel file
write_xlsx(tidy_data, "Tidy_Plates_Data.xlsx")