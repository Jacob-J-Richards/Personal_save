## An example
library(tidyr)
# as_tibble() convert a data frame into a tibble
# recall the definition of tidy data
#   - Every column is variable
#   - Every row is an observation
#   - Every cell is a single value
# Does the iris data satisfy the three conditions? 
as_tibble(iris)

library(ggplot2)
# STEP 1: pivot_longer() lengthens data
iris %>%
  pivot_longer(cols = -Species, names_to = "Measures", values_to = "Values")

# STEP 2: `separate()` separates a character column into multiple columns
# recall the definition of tidy data
#   - Every column is variable
#   - Every row is an observation
#   - Every cell is a single value
# Does this reorganized iris data satisfy the three conditions? 
iris %>%
  pivot_longer(cols = -Species, names_to = "Measures", values_to = "Values") %>%
  separate(col = Measures, into = c("Part", "Measure"))

# STEP 3: `ggplot()` creates the plot
# Can you see the advantage of the reorganized iris data? 
iris %>%
  pivot_longer(cols = -Species, names_to = "Measures", values_to = "Values") %>%
  separate(col = Measures, into = c("Part", "Measure")) %>%
  ggplot(aes(x = Species, y = Values, color = Part)) + 
  geom_jitter() + 
  facet_grid(cols = vars(Measure)) + 
  theme_minimal()


## `pivot_longer()`
# table4a is an example dataset in tidyr 
table4a

table4a %>% 
  pivot_longer(cols = c(`1999`, `2000`), names_to = "year", values_to = "cases")


## `pivot_wider()`
# table2 is an example data in tidyr
table2

table2 %>%
  pivot_wider(names_from = type, values_from = count)


## `separate()`
table3

# By default, any non-alphanumeric character will be a delimiter. 
table3 %>%
  separate(rate, into = c("cases", "population"))

# you can specify your own delimiter using sep
# note that the types of cases and population are characters 
# separate() keeps the original type
table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/")

# convert = TRUE will convert to better type
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

# separate() will interpret the integers as positions to split at 1
table3 %>% 
  separate(year, into = c("century", "year"), sep = 1)

# separate() will interpret the integers as positions to split at -1
table3 %>% 
  separate(year, into = c("century", "year"), sep = -1)

# separate() will interpret the integers as positions to split at 2
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)


## `unite()`
table5

# By default, unite() will place an underscore(_)
table5 %>%
  unite(new, century, year)

table5 %>% 
  unite(new, century, year, sep = "")


