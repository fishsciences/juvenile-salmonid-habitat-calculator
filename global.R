library(shiny)
library(shinythemes)
library(shinysense)
library(shinydashboard)
library(shinyWidgets)
library(dplyr)
library(ggplot2)
library(DT)

empty_data <- tibble(ForkLength_mm = 25:105, Value = NA)
cutoff <- min(empty_data$ForkLength_mm)

calc_territory_size <- function(fl){
  # from Grant and Kramer 1990
  # takes fork length in mm and returns territory size in hectares (multiplier converts m2 to hectares)
  (10 ^ (2.61 * log10(fl/10) - 2.83)) * 1e-4  # need to convert fl to cm
}

round4dec <- function(x){
  round(x * 1e4)/1e4
}

