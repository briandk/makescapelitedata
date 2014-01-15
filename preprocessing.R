# Required libraries
library(ggplot2)
library(plyr)
library(lubridate)

setwd("~/Dropbox/IDC 2014/log data/")

player1 <- read.csv(file="2013.12.10-01-actions.log.csv",
                    header=TRUE,
                    stringsAsFactors=FALSE)

cleanData <- function(input) {
  input <- renameColumnHeaders(input)
  input["timestamp"] <- formatTimestamps(input[, "timestamp"])
  return(input)
}

formatTimestamps <- function(timestamps) {
  return(
    ymd_hms(timestamps)
  )
}

renameColumnHeaders <- function(input) {
  return(
    rename(input, c("time_stamp"              = "timestamp",
                    "sec_since_session_start" = "secondsSinceSessionStart",
                    "data"                    = "logData",
                    "screen_position"         = "screenPosition",
                    "X__class__"              = "activityType")
    )
  )
}

player1 <- cleanData(player1)
