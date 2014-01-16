# Required libraries
library(ggplot2)
library(plyr)
library(lubridate)

player13M <- read.csv(file="2013.12.10-01-actions.log.csv",
                      header=TRUE,
                      stringsAsFactors=FALSE)

player12M <- read.csv(file="2013.12.10-02-actions.log.csv",
                      header=TRUE,
                      stringsAsFactors=FALSE)

cleanData <- function(input) {
  input <- renameColumnHeaders(input)
  input["timestamp"] <- formatTimestamps(input[, "timestamp"])
  input <- excludeActivityTypesFromData(input)
  return(as.data.frame(input))
}

excludeActivityTypesFromData <- function(input) {
  output <- subset(input,
                   activityType != "StartTouch" &
                   activityType != "EndTouch")
  return(output)
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
player12M <- cleanData(player12M)

## Plots

initializePlot <- function(input) {
  p <- ggplot(aes(x = secondsSinceSessionStart),
              data = input)
  p <- p + xlab("Session Time Elapsed (s)")
  return(p)
}

activityTypeOverTime <- function(input) {
  p <- initializePlot(input)
  p <- p + geom_line(aes(y = ..count..,
                    color = as.factor(activityType),
                    group = as.factor(activityType)), 
                stat="bin",
                binwidth=30,
                origin=0,
                right=FALSE)
  p <- p + scale_color_brewer(palette="Set1",
                              name = "Activity Type")
  
  return(p)
}



p12M <- activityTypeOverTime(player12M)
p13M <- activityTypeOverTime(player13M)

print(p12M)
print(p13M)
