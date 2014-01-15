# Required libraries
library(ggplot2)
library(plyr)

setwd("~/Dropbox/IDC 2014/log data/")

set1 <- read.csv(file="2013.12.10-01-actions.log.csv",
                 header=TRUE,
                 stringsAsFactors=FALSE)

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

names(renameColumnHeaders(set1))
