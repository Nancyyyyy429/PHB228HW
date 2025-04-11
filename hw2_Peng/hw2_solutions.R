# Your Name: [Sano Peng]
# Course: PHB 228, Assignment 2
# Date: [9/4/2025]
# Description: This script works with data structures and mapping functions in R.

# Part 1: Version Control Setup
# Load required packages
library(palmerpenguins)
library(purrr)
library(dplyr)
library(ggplot2)

# Part 2: Data Structures

# 1. List Operations
# Extract unique species

# Create list where each element contains data for one species

# Add sample size attribute to each list element

# Access the sample size attribute


# 2. Matrix vs. Data Frame
# Create a matrix with numeric measurements

# Create a data frame with the same measurements

# Compare results and explain differences:
# [Your explanation here]

# When would you prefer each data structure?
# [Your explanation here]


# 3. Copy-on-Modify
# Create a vector x
x <- 1:5

# Create a reference y pointing to the same vector
y <- x

# Modify y and observe what happens to x

# Explanation of R's copy-on-modify behavior vs other languages:
# [Your explanation here]


# Part 3: Map Functions

# 4. Base R Apply Functions
# Use lapply() to calculate the mean of each numeric variable

# Use tapply() to find mean body mass by species

# Use tapply() to find mean body mass by species and sex

# Comparison of output types:
# [Your comparison here]


# 5. Purrr Map Functions
# Rewrite first task using map_dbl()

# Use map2() to calculate bill length to bill depth ratio for each species

# Create list with different statistics for each measurement variable

# Which approach do you prefer and why?
# [Your explanation here]


# 6. Practical Application
# Create histograms for each numeric variable using the map pattern


# Explanation of the efficiency of this approach:
# [Your explanation here]


# Part 4: Memory Management

# 7. Efficient Code
# Original inefficient code
system.time({
  result_inefficient <- numeric(0)
  for(i in 1:10000) {
    result_inefficient <- c(result_inefficient, i^2)
  }
})

# Your efficient version with pre-allocation
system.time({
  # Your code here
})

# Explanation of efficiency improvements:
# [Your explanation here]


# 8. Data Structure Selection
# a. Storing patient IDs and blood pressure readings
# Most appropriate data structure: 
# Explanation:

# b. Representing a correlation matrix between 5 variables
# Most appropriate data structure: 
# Explanation:

# c. Organizing multiple statistical models for different subsets
# Most appropriate data structure: 
# Explanation:

# d. Storing latitude and longitude coordinates for map plotting
# Most appropriate data structure: 
# Explanation:


