library(shiny)
library(shinythemes)
library(shinysense)
library(shinydashboard)
library(shinyWidgets)
library(dplyr)

empty_data <- data_frame(ForkLength_mm = 25:105, Value = NA)
cutoff <- min(empty_data$ForkLength_mm)
total_pop <- 100000

calc_territory_size <- function(fl){
  # from Grant and Kramer 1990
  # takes fork length in mm and returns territory size in hectares (multiplier converts m2 to hectares)
  (10 ^ (2.61 * log10(fl/10) - 2.83)) * 1e-4  # need to convert fl to cm
}

