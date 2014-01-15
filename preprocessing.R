# Required libraries
library(ggplot2)
library(plyr)
library(lubridate)

setwd("~/Dropbox/IDC 2014/log data/")

player13M <- read.csv(file="2013.12.10-01-actions.log.csv",
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

player13M <- cleanData(player13M)

## Plots

p <- ggplot(aes(x = secondsSinceSessionStart),
            data = player13M)

p <- p + geom_line(aes(y = ..count..,
                       color = as.factor(activityType),
                       group = as.factor(activityType)), 
                   stat="bin",
                   binwidth=30,
                   origin=0,
                   right=FALSE)

print(p)
