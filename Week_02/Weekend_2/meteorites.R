
# 1. Reading in libraries & data -----------------------------------------------

library(tidyverse)
library(janitor)
library(assertr)

meteorites_raw_data <- read_csv("data/meteorite_landings.csv")
#head(meteorites_raw_data)
#summary(meteorites_raw_data)





# 1.1 Assertive Programming - column check --------------------------------

check_names <- function(raw_data){
  raw_data %>% 
    verify(has_all_names("id", 
                         "name", 
                         "mass (g)", 
                         "fall", 
                         "year", 
                         "GeoLocation"))
  return(head(raw_data))
}

check_names(meteorites_raw_data)
# The dataframe has all the variables needed 



 

# 1.2 Assertive Programming - latitude & longitude validity check ---------

checks_lat_long <- function(raw_data){
  raw_data %>% 
    separate(GeoLocation, c("latitude", "longitude"), ", ") %>% 
    mutate(latitude = str_remove(latitude, "\\(")) %>% #remove brackets
    mutate(longitude = str_remove(longitude, "\\)")) %>% 
    mutate(latitude = as.numeric(latitude)) %>% #change to numeric
    mutate(longitude = as.numeric(longitude)) %>% 
    verify(latitude >= -90 & latitude <= 90) %>% #check values are valid
    verify(longitude >= -180 & longitude <= 180)
  return(print("lat and long values are valid"))
}

checks_lat_long(meteorites_raw_data)
# Not all latitude and longitude values are valid






# 2. Cleaning data - change variable names to snake_case -----------------------


# using the `janitor` package
meteorites_cleaned_data <- clean_names(meteorites_raw_data)





# 3. Split multi-variable columns ----------------------------------------------

meteorites_cleaned_data <- meteorites_cleaned_data %>% 
  separate(geo_location, c("latitude", "longitude"), ", ") %>% 
  mutate(latitude = str_remove(latitude, "\\(")) %>% #remove brackets
         mutate(longitude = str_remove(longitude, "\\)")) %>% 
  mutate(latitude = as.numeric(latitude)) %>% #change to numeric
  mutate(longitude = as.numeric(longitude))





# 4. Replace missing values ----------------------------------------------------


# check how many NA values there are in `meteorites_cleaned_data`
meteorites_cleaned_data %>% 
  summarise(across(.col = everything(), .fns = ~ sum(is.na(.x))))
# There are 7315 NAs in latitude, and 7315 in longitude.


# replace these NA values with 0:
meteorites_cleaned_data <- meteorites_cleaned_data %>% 
  mutate(latitude = coalesce(latitude, 0, na.rm = TRUE)) %>% 
  mutate(longitude = coalesce(longitude, 0, na.rm = TRUE))

# 4.1 Assertive Programming - Now check if lat/long values are val --------


checks_lat_long_after_NA_rm <- function(cleaned_data){
  cleaned_data %>% 
    verify(latitude >= -90 & latitude <= 90) %>% #check values are valid
    verify(longitude >= -180 & longitude <= 180)
  return(print("lat and long values are valid"))
}

checks_lat_long_after_NA_rm(meteorites_cleaned_data)
# There is now only 1 longitude value that is invalid




# 5. Remove meteorites less than 1kg --------------------------------------


meteorites_cleaned_filtered <- meteorites_cleaned_data %>% 
  filter(mass_g >= 1000)
# 40845 rows have been removed





# 6. Order Data -----------------------------------------------------------

meteorites_cleaned_filtered <- meteorites_cleaned_filtered %>% 
  arrange(year)


# 7 - Write cleaned data  -------------------------------------------------

write_csv(meteorites_cleaned_filtered, "data/meteorites_cleaned_filtered.csv")

         