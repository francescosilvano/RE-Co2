## Renewable Energy and Environmental Footprint
## A Statistical Comparison of Renewable Energy Production and Levels of CO2 produced

## Authors:
## 1.   Francesco Silvano  - 101826
##      f.silvano@student.unisi.it
## 2.   Giacomo Noghera    - 101544
##      g.noghera@student.unisi.it

## Course in Statistics, A.A. 2022/2023
## Prof. Franceschi, Università di Siena
## The following script comes attached to the presentation "Renewable Energy and Environmental Footprint"
## Latest update: Saturday 20th May, 2023


# Install and load the required packages
install.packages(c("ggplot2", "readr"))
library(ggplot2)
library(readr)

# Read the OWID CO2 data from a CSV file
owid.co2.data <- read_csv("References/owid-co2-data.csv")

# Filter the OWID CO2 data for the specified conditions
filtered_owid <- filter(owid.co2.data, country == "OECD (GCP)" & year >= 2011 & year <= 2021) %>%
  select(year, co2)

# Create a scatterplot of the filtered OWID CO2 data
owid_plot <- plot(filtered_owid$year, filtered_owid$co2,
     xlab = "Year", ylab = "Total CO2",
     main = "Scatterplot of Total CO2 (OECD, 2011-2021)",
     col = "#6F1AB6",
     pch = 19)

# Read the energy data from a CSV file
energy <- read_csv("References/energy.csv")

# Filter the energy data for the specified conditions
filtered_energy <- filter(energy, Entity == "World" & Year >= 2011 & Year <= 2021) %>%
  select(Year, `Electricity from renewables (TWh)`)

# Create a scatterplot of the filtered energy data
energy_plot <- plot(filtered_energy$Year, filtered_energy$`Electricity from renewables (TWh)`,
     xlab = "Year", ylab = "Electricity from Renewables (TWh)",
     main = "Scatterplot of Electricity from Renewables (World, 2011-2021)",
     col = "#6F1AB6",
     pch = 19)


# Combine the filtered OWID CO2 data and filtered energy data
combined_data <- merge(filtered_owid, filtered_energy, by.x = "year", by.y = "Year", all = TRUE)

# Scale the y-axis values using normalization
combined_data$scaled_co2 <- (combined_data$co2 - min(combined_data$co2)) / (max(combined_data$co2) - min(combined_data$co2))
combined_data$scaled_energy <- (combined_data$`Electricity from renewables (TWh)` - min(combined_data$`Electricity from renewables (TWh)`)) / (max(combined_data$`Electricity from renewables (TWh)`)- min(combined_data$`Electricity from renewables (TWh)`))

# Create a line chart of the combined data with overlapping lines and scaled values
combined_plot <- ggplot(combined_data, aes(x = year)) +
  geom_path(aes(y = scaled_co2, color = "Total CO2")) +
  geom_path(aes(y = scaled_energy, color = "Electricity from Renewables")) +
  xlab("Year") +
  ylab("Scaled Value") +
  labs(title = "Combined Chart of Total CO2 and Electricity from Renewables") +
  scale_color_manual(values = c("#6F1AB6", "#FF9900")) +
  theme_minimal()

# Display the combined chart with overlapping lines and scaled values
print(combined_plot)


# Calculate Pearson's correlation coefficient
pearson_coeff <- cor(combined_data$scaled_co2, combined_data$scaled_energy)

print(pearson_coeff)


# FUTURE TRENDS
# The code below must be added IFF you want to plot the future trends in energy production and Co2 emissions 


# Generate future years
future_years <- 2022:2025

# Generate predictions for CO2 values
predicted_co2 <- predict(lm(scaled_co2 ~ year, data = combined_data), newdata = data.frame(year = future_years))

# Generate predictions for electricity from renewables values
predicted_energy <- predict(lm(scaled_energy ~ year, data = combined_data), newdata = data.frame(year = future_years))

# Create a dataframe for the predicted data
predicted_data <- data.frame(year = future_years, scaled_co2 = predicted_co2, scaled_energy = predicted_energy)


# Combine the two predicted subsets

# Create a line chart of the combined data with overlapping lines and scaled values
combined_plot_2 <- ggplot(combined_data, aes(x = year)) +
  geom_path(aes(y = scaled_co2, color = "Total CO2")) +
  geom_path(aes(y = scaled_energy, color = "Electricity from Renewables")) +
  geom_path(data = predicted_data, aes(y = scaled_co2, color = "Predicted CO2"), linetype = "dashed") +
  geom_path(data = predicted_data, aes(y = scaled_energy, color = "Predicted Electricity from Renewables"), linetype = "dashed") +
  xlab("Year") +
  ylab("Scaled Value") +
  labs(title = "Combined Chart of Total CO2 and Electricity from Renewables") +
  scale_color_manual(values = c("#6F1AB6", "#FF9900", "#6F1AB6", "#FF9900")) +
  scale_linetype_manual(values = c("solid", "solid", "dashed", "dashed")) +
  theme_minimal()

# Display the combined chart with overlapping lines and scaled values
print(combined_plot_2)
