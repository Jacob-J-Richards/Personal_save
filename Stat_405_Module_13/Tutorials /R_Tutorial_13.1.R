## Tibbles
library(dplyr)
as_tibble(iris) # iris is a data frame in Base R

## Select columns with `select()`
library(nycflights13) # you need the `nycflight13` package to use `flights` data
data(flights)
names(flights) # names() displays column names

# select columns by names
select(flights, year, month, day)

# select all columns between year and day (inclusive)
select(flights, year:day)

# select all columns except between year and day
select(flights, !(year:day))

# select all columns starts with "dep"
select(flights, starts_with("dep"))

# select all columns ends with "time"
select(flights, ends_with("time"))

# select all columns contains "time"
select(flights, contains("time"))

# select all columns starts with "dep", contains "time", and between year and day (inclusive)
select(flights, starts_with("dep"), contains("time"), year:day)

# select columns 1,3,5
select(flights, c(1,3,5))

# billboard is a dataset in the tidyverse package
# billboard contains song rankings for billboard top 100 in 2000
library(tidyverse)
data(billboard)
names(billboard) # names() returns columns of a dataset
select(billboard, num_range("wk", 20:23))


## Filter rows with `filter()`
# filter the flights departed on Jan 1.
filter(flights, month == 1, day == 1) # Here month == 1 & day == 1

# filter the flights departed on Nov or Dec
filter(flights, month == 11 | month == 12) 

# filter the flights to IAH
filter(flights, dest == "IAH") 

# filter the flights with arr_delay <= 120 or dep_delay > 120
filter(flights, arr_delay <= 120 | dep_delay > 120)


## Add new variables with `mutate()`
mutate(flights, gain = arr_delay - dep_delay, hours = air_time/60, gain_per_hour = gain/hours)
transmute(flights, gain = arr_delay - dep_delay, hours = air_time/60, gain_per_hour = gain/hours)

head(iris)
# apply log() to the columns that contain "Sepal"
mutated <- mutate_at(iris, vars(contains("Sepal")), log)
head(mutated) 

# apply log() to the numeric columns
mutated <- mutate_if(iris, is.numeric, log)
head(mutated)


## Arrange rows with `arrange()`
arrange(flights, year, month, day)
arrange(flights, desc(month))


## Grouped summaries with `summarize()`
# name = delay, value = mean(dep_delay, na.rm = TRUE)
summarize(flights, delay_mean = mean(dep_delay, na.rm = TRUE), delay_sd = sd(dep_delay, na.rm = TRUE))

# Together `group_by()`, `summarize()` will produce one row for each group
by_day <- group_by(flights, year, month, day) 
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))


## The pipe operator `%>%`
by_dest <- group_by(flights, dest) 
delay <- summarize(by_dest, count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != "HNL") 
delay

ggplot(data = delay, mapping = aes(x = dist, y = delay)) + 
  geom_point(aes(size = count), alpha = 1/3) + 
  geom_smooth(se = FALSE)

flights %>% 
  group_by(dest) %>% 
  summarize(count = n(), dist = mean(distance, na.rm = TRUE), delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20, dest != "HNL") %>% 
  ggplot(mapping = aes(x = dist, y = delay)) + 
  geom_point(aes(size = count), alpha = 1/3) + 
  geom_smooth(se = FALSE)


## Grouped summaries with `summarize()` (continue)
as_tibble(iris)
# without the pipe operator %>%
iris_grouped <- group_by(iris, Species) 
summarise_all(iris_grouped, mean)

# with the pipe operator %>%
# with summarise_all() - superseded by across()
iris %>% 
  group_by(Species) %>%
  summarise_all(mean)

# with the pipe operator %>%
# selection helper functions are useful for selecting columns
iris %>% 
  group_by(Species) %>%
  summarise(across(starts_with("Sepal"), mean))

# you need a `candisc` package to use the high school and beyond (HSB) data
library(candisc)
data(HSB) # data() loads specific data sets
# as_tibble() converts a dataframe to a tibble
# a tibble prints the first part of a dataset by default 
# We need head() to prints the first part of a dataframe
HSB_tbl <- as_tibble(HSB)
head(HSB_tbl)
# names() displays the column names of the HSB data
# ?HSB will give you more details about HSB data
names(HSB_tbl)
str(HSB_tbl)

# n() gives the current group size
HSB_tbl %>%
  group_by(race) %>%
  summarise(n = n())

# count() counts the unique values of variables
HSB_tbl %>% 
  count(race)
HSB_tbl %>% 
  count(race, gender)

# the means of reading, writing, math, and social science scores
# mean can be replaced with any summary function:
# mean(), median(), sum(), min(), max(), sd(), var(), ... 
HSB_tbl %>% 
  summarise(readm = mean(read), writem = mean(write), mathm = mean(math), ssm = mean(ss))

# the means of reading, writing, math, and social science scores by gender
HSB_tbl %>% 
  group_by(gender) %>%
  summarise(readm = mean(read), writem = mean(write), mathm = mean(math), ssm = mean(ss))

# the means of reading, writing, math, and social science scores by gender and race
HSB_tbl %>% 
  group_by(gender, race) %>%
  summarise(readm = mean(read), writem = mean(write), mathm = mean(math), ssm = mean(ss))

# the means of all numeric variables by gender
HSB_tbl %>% 
  group_by(gender) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

# the means of all numeric variables by ses for only asian and hispanic
HSB_tbl %>%
  filter(race %in% c("asian", "hispanic")) %>%
  group_by(ses) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))


## Mutating joins
# tribble() creates a tibble
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3")
x
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3")
y

# `inner_join()` keeps observations that appear in both data frames
inner_join(x, y, by = "key")

# `inner_join()` keeps observations that appear in both data frames
x %>% 
  inner_join(y, by = "key")

# `left_join()` keeps all observations in x 
left_join(x, y, by = "key")

# `left_join()` keeps all observations in x 
x %>% 
  left_join(y, by = "key")

# `right_join()` keeps all observations in y
right_join(x, y, by = "key")

# `right_join()` keeps all observations in y
x %>% 
  right_join(y, by = "key")

# `full_join()` keeps all observations in x and y
full_join(x, y, by = "key")

# `full_join()` keeps all observations in x and y
x %>% 
  full_join(y, by = "key")

