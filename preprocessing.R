# Required libraries
library(ggplot2)
library(plyr)
library(lubridate)

player13M <- read.csv(file="player13MreducedActions.csv",
                      header=FALSE,
                      stringsAsFactors=FALSE)
player13M <- cbind(player13M, player="player13M")

player12M <- read.csv(file="player12MreducedActions.csv",
                      header=FALSE,
                      stringsAsFactors=FALSE)
player12M <- cbind(player12M, player="player12M")

combinedPlayerData <- rbind(player12M, player13M)

cleanData <- function(input) {
  input <- renameColumnHeaders(input)
  input["timestamp"] <- formatTimestamps(input[, "timestamp"])
  input <- excludeActivityTypesFromData(input)
  return(input)
}

excludeActivityTypesFromData <- function(input) {
  output <- subset(input,
                   subset = activityType != "StartTouch")
  return(output)
}

formatTimestamps <- function(timestamps) {
  return(
    ymd_hms(timestamps)
  )
}

renameColumnHeaders <- function(input) {
  output <- rename(input, c("V1" = "timestamp",
                            "V2" = "secondsSinceSessionStart",
                            "V3" = "logData",
                            "V4" = "screenPosition",
                            "V5" = "activityType",
                            "player" = "player"))
  return(output)
}

combinedPlayerData <- cleanData(combinedPlayerData)

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



# p12M <- activityTypeOverTime(player12M)
# p13M <- activityTypeOverTime(player13M)

print(p12M)
print(p13M)
