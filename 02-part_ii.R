#In this script we are going to be completing Part II of the assignment brief



#For the visualisation part, I am only going to focus on the Asian subcategories
#Use my function to create a subset with only Asian regions
asia_owid <- subset_by_area(cleaned_owid, 'entity', c("South Asia", "East Asia & Pacific", "Europe & Central Asia"))

#Visualisation 1
#Line plot for trend of access to electricity over time for Asian subcategories
ggplot(data = asia_owid, mapping = aes(x = year, y = with_access_to_electricity, color = entity)) +
  geom_line() +
  labs(
    title = "Trend of Access to Electricity Over Time in Asian Subcategories",
    x = "Year",
    y = "Number of People with Access to Electricity",
    color = "Asian Subcategory"
  ) +
  theme_minimal()

#ChatGPT improved visaulisation 1
ggplot(data = asia_owid, mapping = aes(x = year, y = with_access_to_electricity, color = entity)) +
  geom_line(size = 1.1) +   # Thicker lines for visibility
  geom_point(size = 1.5) +  # Adds points to highlight data
  
  # Labels and title
  labs(
    title = "Trend of Access to Electricity Over Time in Asian Subcategories",
    x = "Year",
    y = "Number of People with Access to Electricity",
    color = "Asian Subcategory"
  ) +
  
  # Y-axis scale formatting
  scale_y_continuous(labels = scales::comma) +
  
  # Color palette for distinct groups
  scale_color_brewer(palette = "Set2") +
  
  # Theme adjustments
  theme_light() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    legend.position = "bottom",  # Moves legend below the plot
    legend.title = element_text(size = 11),
    legend.text = element_text(size = 9)
  )



#Visualisation 2
#Line plot for trends over time by region
ggplot(data = asia_owid, mapping = aes(x = year, y = with_access_to_electricity, color = entity)) +
  geom_line() +
  facet_wrap(~ entity, scales = "free_y") +
  labs(
    title = "Trends in Access to Electricity Over Time by Asian Subcategories",
    x = "Year",
    y = "Number of People with Access to Electricity",
    color = "Asian Subcategory"
  ) +
  theme_minimal()


#ChatGPT improved visualisation 2
ggplot(data = asia_owid, mapping = aes(x = year, y = with_access_to_electricity, color = entity)) +
  geom_line(size = 1.2) +  # Thicker line for better visibility
  geom_point(size = 1) +    # Optional: Points to highlight data
  
  # Faceting with free y scales and specified layout
  facet_wrap(~ entity, scales = "free_y", ncol = 3) +
  
  # Labels and title
  labs(
    title = "Trends in Access to Electricity Over Time by Asian Subcategories",
    x = "Year",
    y = "Number of People with Access to Electricity",
    color = "Asian Subcategory"
  ) +
  
  # Scale formatting for better readability
  scale_y_continuous(labels = scales::comma) +
  
  # Remove legend if each facet represents a unique category
  guides(color = "none") +
  
  # Theme customization for readability
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    strip.text = element_text(size = 10, face = "bold")  # Facet title text
  )

#Visualisation 3
ggplot(data = asia_owid, 
       mapping = aes(x = with_access_to_electricity, y = with_access_to_clean_fuels, color = entity)) +
         geom_point() + geom_smooth(method = "gam") + 
  facet_wrap(~ entity, scales = "free_y") +
         labs(
           title = "Relationship Between Access to Electricity and Access to Clean Fuels",
           x = "Number of People with Access to Electricity",
           y = "Number of People with Access to Clean Fuels",
           color = "Asian Subcategory"
         ) +
         theme_minimal()

#ChatGPT improved function 3
ggplot(data = asia_owid, 
       mapping = aes(x = with_access_to_electricity, y = with_access_to_clean_fuels, color = entity)) +
  geom_point(alpha = 0.7, size = 2) +  # Add transparency and size adjustment for points
  geom_smooth(method = "gam", se = FALSE, color = "darkgrey", linetype = "dashed") +  # Customize trend line
  
  # Faceting with flexible x and y scales
  facet_wrap(~ entity, scales = "free") +
  
  # Labels
  labs(
    title = "Relationship Between Access to Electricity and Access to Clean Fuels",
    x = "Number of People with Access to Electricity",
    y = "Number of People with Access to Clean Fuels",
    color = "Asian Subcategory"
  ) +
  
  # Axis formatting for large numbers
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma) +
  
  # Theme customization
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.title = element_text(size = 12),
    axis.text = element_text(size = 10),
    strip.text = element_text(size = 10, face = "bold"),  # Facet title styling
    legend.position = "bottom",  # Moves legend to the bottom for better layout
    legend.title = element_text(size = 11),
    legend.text = element_text(size = 9)
  )


#Visualisation function
#Function to create a line plot for trend of access to electricity over time
create_line_plot <- function(data, x_var, y_var, color_var, title, x_label, y_label, legend_title) {
  ggplot(data, aes_string(x = x_var, y = y_var, color = color_var)) +
    geom_line() +
    facet_wrap(~ entity, scales = "free_y") +
    labs(
      title = title,
      x = x_label,
      y = y_label,
      color = legend_title  # Set the legend title for the color aesthetic
    ) +
    theme_minimal()
}

#Test function using previously made data wrangling function
#Subset first
aus_nz_subset <- subset_by_area(cleaned_owid, 'entity', c('Australia', 'New Zealand'))

#Test visualisation function
#Visualisation function
create_line_plot(
  data = aus_nz_subset,
  x_var = "year",
  y_var = "with_access_to_electricity",
  color_var = "entity",
  title = "Trend of Access to Electricity Over Time in Australia and New Zealand",
  x_label = "Year",
  y_label = "Number of People with Access to Electricity",
  legend_title = "Country"
)

#ChatGPT improved function
# Enhanced function to create a line plot with facetting and customizable options
chatgpt_line_plot <- function(data, x_var, y_var, color_var, facet_var = NULL, title = "", x_label = "", y_label = "", legend_title = "", free_y_scales = FALSE) {
  
  # Initialize the plot with data and aesthetic mappings
  plot <- ggplot(data, aes_string(x = x_var, y = y_var, color = color_var)) +
    geom_line(size = 1) +  # Set line thickness for visibility
    labs(
      title = title,
      x = x_label,
      y = y_label,
      color = legend_title  # Set the legend title for the color aesthetic
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),  # Center-align and bold title
      legend.title = element_text(face = "bold")  # Bold legend title for emphasis
    )
  
  # Add faceting if a facet variable is provided
  if (!is.null(facet_var)) {
    plot <- plot + facet_wrap(as.formula(paste("~", facet_var)), scales = ifelse(free_y_scales, "free_y", "fixed"))
  }
  
  return(plot)
}


#Test ChatGPT's line plot
chatgpt_line_plot(
  data = aus_nz_subset,
  x_var = "year",
  y_var = "with_access_to_electricity",
  color_var = "entity",
  facet_var = "entity",
  title = "Trend of Access to Electricity Over Time",
  x_label = "Year",
  y_label = "Number of People with Access to Electricity",
  legend_title = "Country",
  free_y_scales = TRUE
)



