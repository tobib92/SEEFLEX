# Load necessary library
library(ggplot2)

# Example data: You can replace this with your own dataset
set.seed(123)
data <- pca_weights[,3:4]

# Initialize variables
wss <- numeric(10)  # To store within-cluster sum of squares

# Calculate WSS for k from 1 to 10
for (k in 1:10) {
  kmeans_model <- kmeans(data, centers = k, nstart = 20)
  wss[k] <- kmeans_model$tot.withinss  # Total within-cluster sum of squares
}

# Create a data frame for plotting
elbow_data <- data.frame(k = 1:10, WSS = wss)

# Plotting the Elbow Method
ggplot(elbow_data, aes(x = k, y = WSS)) +
  geom_line() +
  geom_point() +
  labs(x = "number of clusters (k)",
       y = "total within-cluster sum of squares (WCSS)") +
  theme_bw() +
  scale_x_continuous(breaks = seq(min(elbow_data$k), max(elbow_data$k), by = 1)) +
  theme(panel.grid.minor = element_blank())
