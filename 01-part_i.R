#In this script we are going to be completing Part I of the assignment brief

#Clear environment
rm(list = ls())   

#Load necessary packages
#Load packages without installing them
if (!require("pacman")) {
  install.packages("pacman")
}

#Load packages that do not require version control
pacman::p_load(
  tidyverse, #Data manipulation and analysis
  purrr, #Looping and applying functions
  ggplot2, #Data visualisations
  glue, #Combines strings and objects
  skimr, #Data summaries
  readr, #Data import functions
  janitor,#Data cleaning
  scales, #Percent formatting
  ggrepel, #Text repelling
  knitr) #Reproducibility


#Delete the # and run this only if packages have been updated and you need the specific version
#Load packages that require specific versions for reproducibility
if (!require("groundhog")) {
  install.packages("groundhog")
}

#Use groundhog to load packages that require specific versions
pkgs <- c( 'readr', #Data import functions
'janitor',#Data cleaning
'scales', #Percent formatting
'ggrepel', #Text repelling
'knitr') #Reproducibility

#groundhog.library(pkgs, "2024-10-31")


#Set option to avoid scientific notation
options(scipen=999) 

#Load the dataset
owid_dataset <- read.csv("owid_dataset.csv")

#Get an overview of the data set
#Inspect the first few rows to understand the range of variables
head(owid_dataset)

#View structure and data types
glimpse(owid_dataset) 
#Summary statistics for each variable
summary(owid_dataset) 
#Comprehensive summary including missing values
skim(owid_dataset) 

#Fix inconsistencies in the way the columns are named
cleaned_owid <- clean_names(owid_dataset)

#Rename columns for clarity
cleaned_owid <- cleaned_owid %>%
  rename(
    with_access_to_electricity = number_of_people_with_access_to_electricity,
    no_access_to_electricity = number_of_people_without_access_to_electricity,
    with_access_to_clean_fuels = number_with_clean_fuels_cooking,
    no_access_to_clean_fuels = number_without_clean_fuels_cooking
  )

#Checking for missing values in key variables
colSums(is.na(cleaned_owid))  #Get a count of missing values by column

#Remove rows with missing values in  columns
cleaned_owid <- na.omit(cleaned_owid)

#Confirm that missing values have been addressed
colSums(is.na(cleaned_owid))

#Remove 1990-1999 and 2017-2019 from the dataset due to NAs
cleaned_owid <- cleaned_owid %>%
  filter(!(year >= 1990 & year <= 1999 | year >= 2017 & year <= 2019))

#Dataset contains entities that are not countries
#Identify non-country entities
unique(cleaned_owid$entity)

#List of non-country entities
non_countries <- c(
  "World", "Africa Eastern and Southern", "Africa Western and Central", "Arab World",
  "Caribbean Small States", "Central Europe and the Baltics", "Early-demographic dividend",
  "East Asia & Pacific", "East Asia & Pacific (excluding high income)", "East Asia & Pacific (IDA & IBRD)",
  "Euro area", "Europe & Central Asia", "Europe & Central Asia (excluding high income)",
  "Europe & Central Asia (IDA & IBRD)", "European Union", "Fragile and conflict affected situations",
  "Heavily indebted poor countries (HIPC)", "High income", "IBRD only", "IDA & IBRD total",
  "IDA blend", "IDA only", "IDA total", "Late-demographic dividend", "Latin America & Caribbean",
  "Latin America & Caribbean (excluding high income)", "Latin America & Caribbean (IDA & IBRD)",
  "Least developed countries: UN classification", "Low & middle income", "Low income",
  "Lower middle income", "Middle East & North Africa", "Middle East & North Africa (excluding high income)",
  "Middle East & North Africa (IDA & IBRD)", "Middle income", "North America",
  "OECD members", "Other small states", "Pacific island small states", "Post-demographic dividend",
  "Pre-demographic dividend", "Small states", "South Asia", "South Asia (IDA & IBRD)",
  "Sub-Saharan Africa", "Sub-Saharan Africa (excluding high income)", "Sub-Saharan Africa (IDA & IBRD)",
  "Upper middle income"
)

#Remove out non-country entities from the dataset
only_countries_owid <- subset(cleaned_owid, !(entity %in% non_countries))


#Find mean and sd of the dataset, now that it is only countries and appropriate time frame
summary_stats <- only_countries_owid %>%
  summarise(
    with_access_to_electricity_mean = mean(with_access_to_electricity, na.rm = TRUE),
    with_access_to_electricity_sd = sd(with_access_to_electricity, na.rm = TRUE),
    no_access_to_electricity_mean = mean(no_access_to_electricity, na.rm = TRUE),
    no_access_to_electricity_sd = sd(no_access_to_electricity, na.rm = TRUE),
    with_access_to_clean_fuels_mean = mean(with_access_to_clean_fuels, na.rm = TRUE),
    with_access_to_clean_fuels_sd = sd(with_access_to_clean_fuels, na.rm = TRUE),
    no_access_to_clean_fuels_mean = mean(no_access_to_clean_fuels, na.rm = TRUE),
    no_access_to_clean_fuels_sd = sd(no_access_to_clean_fuels, na.rm = TRUE)
  )

#Make a table to show these summary stats in the report
summary_stats %>%
  kable(
    caption = "Summary Statistics of Access to Electricity and Clean Fuels",
    col.names = c("Mean Access to Electricity", "SD Access to Electricity",
                  "Mean No Access to Electricity", "SD No Access to Electricity",
                  "Mean Access to Clean Fuels", "SD Access to Clean Fuels",
                  "Mean No Access to Clean Fuels", "SD No Access to Clean Fuels")
  )


print(summary_stats, width = Inf)

#Data wrangling function
#Create a function that easily subsets data by country
subset_by_area <- function(data, entity_column, area) {
  #Subset the data for the specified years
  subset_data <- subset(data, data[[entity_column]] %in% area)
  return(subset_data)
}

#Test usage
malaysia_subset <- subset_by_area(cleaned_owid, 'entity', c('Malaysia'))

#Confirm to confirm output
head(malaysia_subset)


#ChatGPT suggested improved function 
filter_by_entity <- function(data, entity_column, entities, case_sensitive = TRUE) {
  # Check if entity_column exists in data
  if (!entity_column %in% colnames(data)) {
    stop("The specified entity column does not exist in the data.")
  }
  
  # Check if entities is non-empty
  if (length(entities) == 0) {
    stop("The 'entities' vector is empty. Please provide one or more entities to filter.")
  }
  
  # Apply case sensitivity if required
  if (!case_sensitive) {
    data <- data %>%
      filter(tolower(.data[[entity_column]]) %in% tolower(entities))
  } else {
    data <- data %>%
      filter(.data[[entity_column]] %in% entities)
  }
  
  return(data)
}

