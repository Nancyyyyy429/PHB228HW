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
unique(penguins$species)
# Create list where each element contains data for one species
species_list <- split(penguins,penguins$species)
# Add sample size attribute to each list element
species_list <- lapply(species_list, function(df) {
  attr(df, "sample_size") <- nrow(df)
  df
})

# Access the sample size attribute
lapply(species_list, attr, which = "sample_size")


# 2. Matrix vs. Data Frame
# Create a matrix with numeric measurements
numeric_matrix <- as.matrix(
  penguins[, c("bill_length_mm", "bill_depth_mm", 
                     "flipper_length_mm", "body_mass_g")]
)

# Create a data frame with the same measurements
numeric_df <- data.frame(penguins[, c("bill_length_mm", "bill_depth_mm", 
                                     "flipper_length_mm", "body_mass_g")])
# Create a data frame using subset of columns from penguins
numeric_df2 <- subset(penguins, select = c("bill_length_mm", "bill_depth_mm", 
                                          "flipper_length_mm", "body_mass_g"))
# Compare results and explain differences:
class(numeric_matrix)
#[1] "matrix" "array"
class(numeric_df)
#[1] "data.frame"
class(numeric_df2)
#[1] "tbl_df"     "tbl"        "data.frame"
str(numeric_matrix)
# num [1:344, 1:4] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...
# - attr(*, "dimnames")=List of 2
# ..$ : NULL
# ..$ : chr [1:4] "bill_length_mm" "bill_depth_mm" "flipper_length_mm" "body_mass_g"
str(numeric_df)
# 'data.frame':	344 obs. of  4 variables:
# $ bill_length_mm   : num  39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...
# $ bill_depth_mm    : num  18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...
# $ flipper_length_mm: int  181 186 195 NA 193 190 181 195 193 190 ...
# $ body_mass_g      : int  3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...
str(numeric_df2)
# tibble [344 × 4] (S3: tbl_df/tbl/data.frame)
# $ bill_length_mm   : num [1:344] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...
# $ bill_depth_mm    : num [1:344] 18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...
# $ flipper_length_mm: int [1:344] 181 186 195 NA 193 190 181 195 193 190 ...
# $ body_mass_g      : int [1:344] 3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...

# Looking at the output results, I noticed several differences:
# From class(), numeric_matrix is "matrix" and "array" types, numeric_df is simply "data.frame", while numeric_df2 is "tbl_df", "tbl", and "data.frame" (a tibble type).
# Looking at the str() output, the matrix stores all data as num type, while data.frame and tibble preserve original types (some columns as num, others as int).
# Storage structure differs: matrix uses a [rows,columns] format with dimnames attribute; data.frame stores as a list of variables; tibble has a more modern display format.
# The tibble (numeric_df2) provides more detailed type information than standard data.frame, like "num [1:344]" showing both the data type and row count.
#Both matrix and data frames appear to handle NA values similarly, all preserving missing values.


# When would you prefer each data structure?
# I'd use a matrix when doing numerical calculations like matrix multiplication or linear algebra, because they're faster and simpler when all data needs to be the same type.
# I'd choose a standard data frame when working with mixed data types (like combining numbers and categories) or when using base R functions that expect data frames.
# I'd pick a tibble when working with tidyverse packages (like dplyr or ggplot2) since tibbles work better with these tools and give cleaner output with better type information when printing large datasets.


# 3. Copy-on-Modify
# Create a vector x
x <- 1:5

# Create a reference y pointing to the same vector
y <- x

# Modify y and observe what happens to x
y[2]<-99
x
y
# Explanation of R's copy-on-modify behavior vs other languages:
# R uses "copy-on-modify" which means when I modified y by changing its second element to 99, and created a new copy of the vector for y rather than changing the original vector that x points to. 
# This is different from languages like Python or Java where variables are references to objects. 
# In those languages, if y references the same object as x, changing y would also change x because they point to the same memory location. 


# Part 3: Map Functions

# 4. Base R Apply Functions
# Use lapply() to calculate the mean of each numeric variable
numeric_cols <- c("bill_length_mm", "bill_depth_mm", 
                  "flipper_length_mm", "body_mass_g")
numeric_means <- lapply(penguins[, numeric_cols], mean, na.rm = TRUE)
numeric_means
# $bill_length_mm
# [1] 43.92193

# $bill_depth_mm
# [1] 17.15117

# $flipper_length_mm
# [1] 200.9152

# $body_mass_g
# [1] 4201.754

# Use tapply() to find mean body mass by species
species_mass <- tapply(penguins$body_mass_g, penguins$species, mean, na.rm = TRUE)
species_mass
# Adelie Chinstrap    Gentoo 
# 3700.662  3733.088  5076.016

# Use tapply() to find mean body mass by species and sex
species_sex_mass <- tapply(penguins$body_mass_g, 
                           list(Species = penguins$species, Sex = penguins$sex), 
                           mean, na.rm = TRUE)
species_sex_mass
#          Sex
# Species       female     male
# Adelie    3368.836 4043.493
# Chinstrap 3527.206 3938.971
# Gentoo    4679.741 5484.836

# Comparison of output types:
# lapply() returns a named list with each numeric variable's mean, 
# tapply() returns either a named vector (one grouping factor) or a 2D array/matrix (two grouping factors) depending on how many variables are used for grouping.


# 5. Purrr Map Functions
# Rewrite first task using map_dbl()
numeric_means_purrr <- map_dbl(penguins[, numeric_cols], mean, na.rm = TRUE)
numeric_means_purrr
# bill_length_mm     bill_depth_mm flipper_length_mm       body_mass_g 
# 43.92193          17.15117         200.91520        4201.75439 

# Use map2() to calculate bill length to bill depth ratio for each species
bill_ratio_by_species <- map(
  species_list,
  ~ map2_dbl(.x$bill_length_mm, .x$bill_depth_mm, ~ .x / .y)
)
bill_ratio_by_species

# $Adelie
# [1] 2.090909 2.270115 2.238889       NA 1.901554 1.907767 2.185393 2.000000 1.883978 2.079208 2.210526 2.184971 2.335227 1.820755 1.639810 2.056180 2.036842
# [18] 2.053140 1.869565 2.139535 2.065574 2.016043 1.869792 2.110497 2.255814 1.867725 2.182796 2.262570 2.037634 2.142857 2.365269 2.055249 2.219101 2.164021
# [35] 2.141176 1.857820 1.940000 2.281081 1.948187 2.083770 2.027778 2.217391 1.945946 2.238579 2.189349 2.106383 2.163158 1.984127 2.011173 1.995283 2.237288
# [52] 2.121693 1.955307 2.153846 1.906077 2.225806 2.228571 2.159574 2.198795 1.968586 2.112426 1.957346 2.211765 2.258242 2.128655 2.311111 2.191358 2.151832
# [69] 2.162651 2.154639 1.763158 2.157609 2.302326 2.423280 2.028571 2.313514 2.434524 1.917526 2.248447 2.204188 2.011628 2.437500 1.952128 1.809278 2.095506
# [86] 2.034483 1.861538 1.983871 1.994792 2.069149 1.983333 2.270718 1.988304 2.187845 2.092486 2.158730 2.048387 2.178378 2.055901 2.335135 1.955307 2.050000
# [103] 2.356250 1.890000 2.037634 2.100529 2.244186 1.910000 2.241176 2.273684 2.309091 2.246305 2.242938 2.164103 1.913043 2.333333 2.270588 1.819512 2.100000
# [120] 2.209677 2.104651 1.904040 2.364706 2.237838 2.213836 2.136842 2.204545 2.267760 2.280702 2.450000 2.150838 2.244792 1.989189 2.027027 2.164773 2.348571
# [137] 2.034286 2.000000 2.242424 2.217877 2.350877 2.360465 2.070968 2.394118 2.220238 2.085561 2.107527 1.989130 2.022472 2.088398 2.105263 2.243243
#
# $Chinstrap
# [1] 2.597765 2.564103 2.671875 2.427807 2.661616 2.539326 2.532967 2.818681 2.433862 2.577889 2.617978 2.546798 2.716763 2.872928 2.684211 2.576531 2.515000
# [18] 3.258427 2.494624 2.703297 2.450867 2.771429 2.602410 2.608247 2.608939 2.736842 2.744565 2.605263 2.606742 2.640000 2.463855 2.605769 2.544910 2.712766
# [35] 2.672043 2.827381 2.601093 2.512077 2.825301 2.688442 2.512821 2.640000 2.664921 2.676471 2.843575 2.745946 2.798883 2.500000 2.754011 2.878613 2.932927
# [52] 2.705263 2.641618 2.573604 2.456647 2.776596 2.722892 2.477387 2.670213 2.350515 2.661538 2.836364 2.688235 2.818182 2.403315 2.725275 2.673684 2.684492
#
# $Gentoo
# [1] 3.492424 3.067485 3.453901 3.289474 3.282759 3.444444 3.109589 3.052288 3.231343 3.038961 2.985401 3.043478 3.321168 3.315068 3.136986 3.140127 3.111111
# [18] 3.236842 3.186207 3.225166 3.510490 3.110345 3.206897 2.930380 3.274809 3.052980 3.111888 3.186667 3.370629 3.267974 3.091503 3.014085 3.110345 3.505882
# [35] 3.317568 2.969325 3.109489 2.566474 3.235294 3.101911 3.116788 3.100000 3.306569 3.306667 3.176101 3.136691 3.273381 3.176101 3.375940 2.860759 3.281690
# [52] 3.439716 3.131944 3.340000 3.229167 2.922078 3.151079 3.033333 2.979310 3.294118 3.282609 3.100671 3.287770 3.458599 3.225352 2.964286 3.208333 3.055556
# [69] 3.063380 3.380000 3.180000 2.974359 3.089744 3.141892 3.093333 3.037500 3.345070 3.134969 3.275362 2.756098 3.386207 3.365385 3.246575 3.144654 3.253623
# [86] 2.936416 3.013889 3.612676 3.392857 3.064706 3.166667 3.052632 3.137931 3.074534 3.027211 3.235669 3.126582 3.212329 3.361111 3.096970 3.233333 3.288235
# [103] 3.045161 3.273333 3.427536 2.906832 2.836735 3.379747 3.092857 3.185430 3.322368 3.132075 2.861842 3.159509 3.276596 3.443750 2.834395 3.012346 3.445255
# [120]       NA 3.272727 3.210191 3.054054 3.099379

# Create list with different statistics for each measurement variable
my_stats <- list(mean = mean, median = median, sd = sd)
stats_list <- map(
  my_stats,
  ~ map_dbl(penguins[, numeric_cols], .x, na.rm = TRUE)
)
stats_list
# $mean
# bill_length_mm     bill_depth_mm flipper_length_mm       body_mass_g 
# 43.92193          17.15117         200.91520        4201.75439 
# 
# $median
# bill_length_mm     bill_depth_mm flipper_length_mm       body_mass_g 
# 44.45             17.30            197.00           4050.00 
# 
# $sd
# bill_length_mm     bill_depth_mm flipper_length_mm       body_mass_g 
# 5.459584          1.974793         14.061714        801.954536 

# Which approach do you prefer and why?
# I personally find purrr more intuitive for these kinds of tasks, because its naming (e.g., map_dbl(), map2()) clearly signals what is returned or how the iteration happens. 
# The functions also compose nicely with the rest of the tidyverse, making it easy to integrate with pipelines (%>%).


# 6. Practical Application
# Create histograms for each numeric variable using the map pattern
nice_labels <- c(
  bill_length_mm = "Bill Length (mm)",
  bill_depth_mm = "Bill Depth (mm)",
  flipper_length_mm = "Flipper Length (mm)",
  body_mass_g = "Body Mass (g)"
)

histograms <- map(numeric_cols, function(var) {
  # Create a title based on the variable name
  title <- nice_labels[var]
  # Create the histogram with facets by species and color
  ggplot(penguins, aes(x = .data[[var]], fill = species)) +
    geom_histogram(alpha = 0.8, bins = 30, color="black") +
    facet_wrap(~ species, ncol = 1) +
    labs(title = paste("Distribution of", title),
         x = title,
         y = "Count") +
    theme_minimal() +
    theme(legend.position = "bottom") +
    scale_fill_brewer(palette = "Set1")
})

# Assign names to the plot list
names(histograms) <- numeric_cols

# Print the plots
histograms

# Explanation of the efficiency of this approach:
# It is more efficient because it allows me to write the plotting code only once and apply it to all numeric variables, 
# rather than repeating nearly identical code four times. This makes the code more maintainable - if I need to change any aspect of the plots (like colors, binning, or titles), 
# I only need to edit one place instead of four separate blocks of code. Additionally, storing the plots in a named list makes it easy to access individual histograms or display them all together as needed.


# Part 4: Memory Management

# 7. Efficient Code
# Original inefficient code
system.time({
  result_inefficient <- numeric(0)
  for(i in 1:10000) {
    result_inefficient <- c(result_inefficient, i^2)
  }
})
# user  system elapsed 
# 0.099   0.036   0.148 

# Your efficient version with pre-allocation
system.time({
  result_new <- numeric(10000)   # Preallocate space for 10,000 elements
  for(i in 1:10000) {
    result_new[i] <- i^2
  }
})
# user  system elapsed 
# 0.001   0.000   0.001 

# Explanation of efficiency improvements:
# assigning values by index result_new[i] <- i^2 avoids repeated copying, the Original inefficient code builds the vector step-by-step. 
# specially in a loop, it is made by R a complete new copy of all data, which gets very slow as the vector grows

# 8. Data Structure Selection
# a. Storing patient IDs and blood pressure readings
# Most appropriate data structure: 
# data frame like :
# patient_data <- data.frame(
# patient_id = c("ID1", "ID2", "ID3"),
# blood_pressure = c(number1, number2, number3)
# )
# Explanation:
# it can keep patient IDs and blood pressure measurements organized in columns.
# so it's easy to look up specific patients and analyze the blood pressure data.


# b. Representing a correlation matrix between 5 variables
# Most appropriate data structure: 
# matrix
# Explanation:
# because correlation data is arranged in rows and columns (5×5 ). 
# Matrices in R make it simple to perform calculations I might need later, like finding relationships between variables.

# c. Organizing multiple statistical models for different subsets
# Most appropriate data structure: 
# List
# Explanation:
# Lists in R can hold different types of objects, so I could keep each model separate but in one place. 
# Then I could easily loop through my models or compare their results.

# d. Storing latitude and longitude coordinates for map plotting
# Most appropriate data structure: 
# data frame
# Explanation:
# This structure works well with mapping functions, and I could add extra columns for things like location names or other information I want to show on my map.

