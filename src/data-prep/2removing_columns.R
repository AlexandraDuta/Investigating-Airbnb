###-- REMOVING COLUMNS --###

dir.create('temp/')

#-Load packages
install.packages("tidyverse",repos = "http://cran.us.r-project.org"); install.packages("dplyr",repos = "http://cran.us.r-project.org")
library(tidyverse);library(dplyr)

listings_raw <- read.csv('raw_data/listings_raw.csv')
calendar_raw <- read.csv('raw_data/calendar_raw.csv')
#-Removing unwanted columns from listings_venice
listings_col_removed = subset(listings_raw, select = (-c(host_response_rate, number_of_reviews, review_scores_rating, property_type, host_acceptance_rate, host_total_listings_count, reviews_per_month, listing_url, scrape_id, last_scraped, description, neighborhood_overview, picture_url, host_url, host_name, host_since, host_location, host_about, host_thumbnail_url, host_picture_url, host_neighbourhood, host_verifications, host_has_profile_pic, host_identity_verified, neighbourhood, neighbourhood_cleansed, neighbourhood_group_cleansed, latitude, longitude, amenities, minimum_minimum_nights, maximum_minimum_nights, minimum_maximum_nights, maximum_maximum_nights, minimum_nights_avg_ntm, maximum_nights_avg_ntm, calendar_updated,
                                                         host_listings_count, bathrooms, availability_30, availability_60, availability_90, availability_365, calendar_last_scraped, number_of_reviews_ltm, number_of_reviews_l30d, first_review, last_review, review_scores_cleanliness, review_scores_checkin, review_scores_communication, review_scores_location, review_scores_value, license, host_is_superhost, review_scores_accuracy, calculated_host_listings_count_entire_homes, calculated_host_listings_count_private_rooms, calculated_host_listings_count_shared_rooms, name, accommodates, bathrooms_text,
                                                         bedrooms, beds, calculated_host_listings_count, has_availability, instant_bookable, price, minimum_nights, maximum_nights, room_type)))

#-Removing columns from calendar_venice that are not relevant
calendar_col_removed = subset(calendar_raw, select = (-c(date, price, adjusted_price, minimum_nights, maximum_nights)))

#### 
write.csv(listings_col_removed,"temp/listings_col_removed.csv")
write.csv(calendar_col_removed,"temp/calendar_col_removed.csv")

#-Create dummy on whether it is booked
#-Group by listing_id the number of bookings
calendar_col_removed$booked <- ifelse(calendar_col_removed$available == "f", 1, 0)
agg_number <- calendar_col_removed %>% group_by(listing_id) %>% count(listing_id)
agg_booked <- calendar_col_removed %>% group_by(listing_id) %>% summarize(booked_number = sum(booked))

#-Merge both to calendar_venice
final_calendar_venice <- agg_booked %>% inner_join(agg_number, by = c("listing_id" = "listing_id"))

#-Merge calendar to listings df
listings_merged <- listings_col_removed %>% inner_join(final_calendar_venice, by = c("id" = "listing_id"))
write.csv(listings_merged,"temp/listings_merged.csv")