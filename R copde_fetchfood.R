setwd
getwd
# Step 1: Load datasets
library (readxl)
library(ggplot2)
#order_file <- read_excel("order_file.xlsx", 
#                        col_types = c("text", "text", "text", 
#                                      "numeric", "text", "text", "numeric"))
#View(order_file)
#penalty_file <- read_excel("penalty_file.xlsx")
library(readr)
data <- read_csv("order_file.csv",
                 col_types = cols(
                   order.id = col_character(),
                   driver.id = col_character(),
                   business.type = col_character(),
                   expected.profit = col_double(),
                   order.placed.time = col_character(),
                   delivery.completed.time = col_character(),
                   cancel.dummy = col_double()
                 ))
head(data)
View(order_file)
View(penalty_file)

# Step 2: Merge datasets on "driver.id"
data <- merge(order_file, penalty_file, by = "driver.id", )
options(scipen = 999)  ### to get decimal values without scientific exponential notation
# Remove rows with missing values
#data <- na.omit(data)
####expected mean of the dummy variable and Penalty variant####
data<- data[!is.na(data$expected.profit),]

summary_stats <- aggregate(expected.profit ~ penalty.variant, data = data, FUN = function(x) c(mean = mean(x), sd = sd(x)))
summary_stats <- do.call(data.frame, summary_stats) 
names(summary_stats)[2:3] <- c("mean", "sd")
print(summary_stats)
max_min_summary <- aggregate(expected.profit ~ cancel.dummy, data = data, 
                             FUN = function(x) c(Max = max(x, na.rm = TRUE), Min = min(x, na.rm = TRUE)))

# Format the results
max_min_summary <- do.call(data.frame, max_min_summary)
names(max_min_summary)[2:3] <- c("Maximum", "Minimum")

# Print the result
print(max_min_summary)


###p-value###

# ANOVA for penalty.variant
# Ensure `penalty.variant` is treated as a categorical variable
data$penalty.variant <- as.factor(data$penalty.variant)
anova_rides <- aov(expected.profit ~ penalty.variant, data = data)
print("ANOVA for Completed Rides (δ):")
print(summary(anova_rides))

###multiple testing####

bonferroni_test <- pairwise.t.test(data$expected.profit, data$penalty.variant, p.adjust.method = "bonferroni")
bonferroni_test 

###expected mean of profit startified by group pentalty variant###

summary_stats <- aggregate(expected.profit ~ cancel.dummy, data = data, FUN = function(x) c(mean = mean(x), sd = sd(x)))
summary_stats <- do.call(data.frame, summary_stats)  # Format as a data frame
names(summary_stats)[2:3] <- c("mean", "sd")  # Rename columns
print(summary_stats)

##p-value##

t_test_result <- t.test(expected.profit ~ cancel.dummy, data = data, var.equal = FALSE)
print(t_test_result)

######Chi-square between dummy and variant####

table_data <- table(data$penalty.variant, data$cancel.dummy)
table_data 

# Perform the Chi-Square Test
chi_square_result <- chisq.test(table_data)
print(chi_square_result)

################stratify this by group###################

data_cntrl <- subset(data, penalty.variant == 0)
data_trt1 <- subset(data, penalty.variant == 10)
data_trt2 <- subset(data, penalty.variant == 20)

###data_cntrl###
summary_stats <- aggregate(expected.profit ~ cancel.dummy, data = data_cntrl, FUN = function(x) c(mean = mean(x), sd = sd(x)))
summary_stats <- do.call(data.frame, summary_stats)  # Format as a data frame
names(summary_stats)[2:3] <- c("mean", "sd")  # Rename columns
print(summary_stats)

t_test_result <- t.test(expected.profit ~ cancel.dummy, data = data_cntrl, var.equal = FALSE)
print(t_test_result)

###data_trt1###

summary_stats <- aggregate(expected.profit ~ cancel.dummy, data = data_trt1, FUN = function(x) c(mean = mean(x), sd = sd(x)))
summary_stats <- do.call(data.frame, summary_stats)  # Format as a data frame
names(summary_stats)[2:3] <- c("mean", "sd")  # Rename columns
print(summary_stats)

t_test_result <- t.test(expected.profit ~ cancel.dummy, data = data_trt1, var.equal = FALSE)
print(t_test_result)

###data_trt2###

summary_stats <- aggregate(expected.profit ~ cancel.dummy, data = data_trt2, FUN = function(x) c(mean = mean(x), sd = sd(x)))
summary_stats <- do.call(data.frame, summary_stats)  # Format as a data frame
names(summary_stats)[2:3] <- c("mean", "sd")  # Rename columns
print(summary_stats)

t_test_result <- t.test(expected.profit ~ cancel.dummy, data = data_trt2, var.equal = FALSE)
print(t_test_result)

######business.type and dummy################


# Create a contingency table
table_data <- table(data$business.type, data$cancel.dummy)
print("Contingency Table:")
print(table_data)

# Calculate Row Percentages
row_percentages <- prop.table(table_data, 1) * 100  # Row-wise percentages (1 means rows)
print("Row Percentages:")
print(row_percentages)

# Calculate Column Percentages
col_percentages <- prop.table(table_data, 2) * 100  # Column-wise percentages (2 means columns)
print("Column Percentages:")
print(col_percentages)

# Combine the table with row and column percentages for easy viewing
table_with_percentages <- cbind(table_data, Row_Percentage = row_percentages[, 1], Column_Percentage = col_percentages[, 1])
print("Table with Row and Column Percentages:")
print(table_with_percentages)

# Perform the Chi-Square Test
chi_square_result <- chisq.test(table_data)
print(chi_square_result)

##############business.type and variant####

# Create a contingency table
table_data <- table(data$business.type, data$penalty.variant)
print("Contingency Table:")
print(table_data)

# Calculate Row Percentages
row_percentages <- prop.table(table_data, 1) * 100  # Row-wise percentages (1 means rows)
print("Row Percentages:")
print(row_percentages)

# Calculate Column Percentages
col_percentages <- prop.table(table_data, 2) * 100  # Column-wise percentages (2 means columns)
print("Column Percentages:")
print(col_percentages)

# Combine the table with row and column percentages for easy viewing
table_with_percentages <- cbind(table_data, Row_Percentage = row_percentages[, 1], Column_Percentage = col_percentages[, 1])
print("Table with Row and Column Percentages:")
print(table_with_percentages)

# Perform the Chi-Square Test
chi_square_result <- chisq.test(table_data)
print(chi_square_result)

#############Just Trial linear model###############
# Step 1: Fit the linear model with categorical predictor and adjust for continuous variable(s)
adjusted_model <- lm(expected.profit ~ factor(business.type) + factor(penalty.variant) + factor(cancel.dummy), data = data)

# Step 2: Summarize the model results
summary(adjusted_model)


# Step 12: Bar Graph - Penalty Variant vs Cancel Dummy
bar_data <- as.data.frame(table(data$penalty.variant, data$cancel.dummy))
names(bar_data) <- c("penalty_variant", "cancel_dummy", "Frequency")
bar_data <- merge(bar_data, aggregate(Frequency ~ penalty_variant, bar_data, sum),
                  by = "penalty_variant", suffixes = c("", "_total"))
bar_data$Proportion <- (bar_data$Frequency / bar_data$Frequency_total) * 100
ggplot(bar_data, aes(x = penalty_variant, y = Frequency, fill = cancel_dummy)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = sprintf("%.1f%%", Proportion)), 
            position = position_dodge(0.9), vjust = -0.5, size = 3) +
  labs(
    title = "Penalty Variant vs Cancel Dummy",
    x = "Penalty Variant ($)",
    y = "Frequency",
    fill = "Cancellation Status"
  ) +
  theme_minimal()

# Step 13: Bar Graph - Grocery and Restaurant
data$Group <- factor(data$penalty.variant, 
                     levels = c(0, 10, 20), 
                     labels = c("Control", "Treatment 1", "Treatment 2"))
group_data <- as.data.frame(table(data$business.type, data$cancel.dummy, data$Group))
names(group_data) <- c("business_type", "cancel_dummy", "Group", "Frequency")
group_data <- merge(group_data, aggregate(Frequency ~ business_type + Group, group_data, sum),
                    by = c("business_type", "Group"), suffixes = c("", "_total"))
group_data$Proportion <- (group_data$Frequency / group_data$Frequency_total) * 100

ggplot(group_data, aes(x = business_type, y = Frequency, fill = cancel_dummy)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = sprintf("%.1f%%", Proportion)), 
            position = position_dodge(0.9), vjust = -0.5, size = 3) +
  facet_wrap(~ Group) +
  labs(
    title = "Cancel Dummy by Business Type based on penalty",
    x = "Business Type",
    y = "Frequency",
    fill = "Cancellation Status"
  ) +
  theme_minimal()

# Calculate cancellation rates by penalty variant
cancel_rate_by_penalty <- aggregate(cancel.dummy ~ penalty.variant, data = data, FUN = function(x) mean(x))
names(cancel_rate_by_penalty) <- c("penalty.variant", "cancellation_rate")
print(cancel_rate_by_penalty)
# Plot cancellation rates by penalty variant
library(ggplot2)
ggplot(cancel_rate_by_penalty, aes(x = factor(penalty.variant), y = cancellation_rate, fill = factor(penalty.variant))) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  labs(title = "Cancellation Rate by Penalty Variant", x = "Penalty Variant ($)", y = "Cancellation Rate") +
  theme_minimal() +
  geom_text(aes(label = scales::percent(cancellation_rate, accuracy = 0.01)), vjust = -0.3, size = 4)
# Boxplot for expected profit by penalty variant
ggplot(data, aes(x = factor(penalty.variant), y = expected.profit, fill = factor(penalty.variant))) +
  geom_boxplot() +
  labs(title = "Expected Profit by Penalty Variant", x = "Penalty Variant ($)", y = "Expected Profit ($)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# Boxplot for cancellations vs expected profit
ggplot(data, aes(x = factor(cancel.dummy), y = expected.profit, fill = factor(cancel.dummy))) +
  geom_boxplot() +
  labs(title = "Expected Profit by Cancellation Status", x = "Cancellation Status", y = "Expected Profit ($)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")








library(readxl)
graph1 <- read_excel("cancel dummy and penalty variant.xlsx")
View(graph1)

custom_colors <- c("0"= "darkred",
                   "10" = "darkgreen",
                   "20"="darkblue") # Adjust based on groups

graph1$Penalty_variant <- factor(graph1$Penalty_variant,
                                 levels  = c("20","10","0"))

# Create the plot
ggplot(graph1, aes(fill = Penalty_variant, y = Percentage, x =Cancel_Dummy )) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_manual(values = custom_colors) +  # Use custom colors
  ggtitle("Cancellation Requests by Penalty Variant") +
  xlab("") +
  geom_text(aes(label = paste0(round(Percentage * 1, 1), "%")),  
            position = position_stack(vjust = 0.4),
            color = "white") +
  theme_minimal()+
  theme(legend.position = "bottom")


library(ggplot2)
library(dplyr)
data_summary <- data %>%
  group_by(penalty.variant) %>%
  summarize(mean_profit = mean(expected.profit, na.rm = TRUE))

# Create a bar graph
ggplot(data_summary, aes(x = factor(penalty.variant), y = mean_profit)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Bar Graph of Mean Expected Profit by Penalty Variant",
       x = "Penalty Variant ($)",
       y = "Mean Expected Profit") +
  theme_minimal()




# Step 4: Calculate Column Percentages
# Column percentages show the percentage distribution of cancellation status (0, 1) for each penalty variant
table_data_col_pct <- prop.table(table_data, 2) * 100  # Proportions by columns
print(table_data_col_pct)

# Step 5: Convert the contingency table with column percentages to a data frame for plotting
graph_data <- as.data.frame(table_data_col_pct)
names(graph_data) <- c("Penalty_variant", "Cancel_Dummy", "Percentage")

# Step 6: Create the plot for cancellation requests by penalty variant
custom_colors <- c("0" = "darkred", "1" = "darkgreen")  # Red for no cancellation, green for cancellation

ggplot(graph_data, aes(fill = Cancel_Dummy, y = Percentage, x = Penalty_variant)) +
  geom_bar(position = "dodge", stat = "identity") +  # Create a bar plot
  scale_fill_manual(values = custom_colors) +  # Custom colors for the bars
  ggtitle("Cancellation Requests by Penalty Variant (Column Percentages)") +  # Title of the plot
  xlab("Penalty Variant ($)") +  # Label for the x-axis
  ylab("Cancellation Percentage") +  # Label for the y-axis
  geom_text(aes(label = paste0(round(Percentage, 1), "%")),  # Display percentages on the bars
            position = position_dodge(0.8), vjust = -0.5) +  # Adjust text position
  theme_minimal() +  # Apply minimal theme
  theme(legend.position = "bottom")  # Position legend at the bottom

