####Install Packages -  this function checks if a package is installed and if not installs it
packages <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(dplyr)
packages(rgdal)
packages(sp)
packages(maptools)
packages(leaflet)
packages(ggplot2)
packages(ggmap)
packages(rbokeh)
packages(RCurl)
packages(dygraphs)
packages(xts)
library(xts)
library(dygraphs)
library(dplyr)
require(rgdal)
library(sp)
library(maptools)
library(leaflet)
library(ggplot2)
library(ggmap) #geocoding
library(rbokeh)
library(RCurl)
######################

#load data from GitHub
datdf <- getURL('https://raw.githubusercontent.com/IBMDataScience/SparkSummitDemo/master/data/clusterEnergyLocation.csv')
df <- read.csv(text = datdf)

#Jitter buildings that are at same lat/long
df$Lat <- round(jitter(df$Lat, factor = 0.00001),5)
df$Long<- round(jitter(df$Long, factor = 0.00001),5)

df$kmeans_label <- df$kmeans_label + 1 #label is 0:3 - add 1 to make 1:4
df$kmeans_label <- as.factor(df$kmeans_label)#as factor since this is label not numeric
df$ReClustering <- df$ReClustering+1 #binary reclustering - 0/1 --> 1/2
df$ReClustering <- as.factor(df$ReClustering)

df$billValues <- gsub('\\$','', df$Annual.Energy.Bill..USD.)#remove $ from value
df$billValues <- gsub(',','', df$billValues) #remove , from value
df$billValues <- as.numeric(gsub(' ','', df$billValues))#remove ' ' from value



##############################
## Leaflet Map 1 - show energy bill at each building
qpal <- colorQuantile("YlGnBu", df$Measured)

map <- leaflet(data = df) %>% 
  addProviderTiles("CartoDB.Positron")%>% 
  addCircleMarkers(
    radius = 6,
    fillColor = ~qpal(df$Measured),fillOpacity = 0.7,
    stroke = T, weight =2,color='#2b1d0e',
    popup = paste('Property: ', df$property_name,"<br> Annual Bill: ", df$Annual.Energy.Bill..USD.)) %>% 
  addLegend(position = "bottomright",na.label = "NA", title="Annual Energy Cost",colors=c('#FFFFD9','#99D6B9','#2280B8','#081D58'), labels = c('< $2,000','$2,000 - $4,000','$4,001- $6,000','$6,000 +'))
map

## Leaflet Map 2 - show clustering assignment of each building
qualPalette <- c("#1a9641","#d7191c")
clusterLabels <- seq(1:2)
df$color <- qualPalette[match(df$ReClustering, clusterLabels)]
qpal2 <- colorFactor(palette=qualPalette, df$ReClustering)

map2 <- leaflet(data = df) %>% 
  addProviderTiles("CartoDB.Positron")%>% 
  addCircleMarkers(
    lng = df$Long,
    lat = df$Lat,
    radius = 6,
    color = ~qpal2(df$ReClustering),
    stroke = F, fillOpacity = 0.7,
    popup = ~property_name)

addLegend(map2,position = "bottomright", colors=qualPalette,labels=c("Efficient","Inefficient"),na.label = "NA", title="Cluster Labels", opacity =0.7)
map2  
##############################
# Scatter plot with rbokeh- 

p2 <- figure() %>%
  ly_points(heating_gas, plug_load_consumption, data = df, color = kmeans_label,hover = c(heating_gas, plug_load_consumption))
p2
#####################################
# Working with sensor data 
dat <- getURL('https://raw.githubusercontent.com/IBMDataScience/SparkSummitDemo/master/data/CombinedSensorData.csv')
allSensors <- read.csv(text = dat)
allSensors$Unitarian.s <- as.POSIXct(allSensors$Unitarian.s,format='%m/%d/%Y %H:%M')
temps <- data.frame(allSensors$Unitarian.s, allSensors$Unitarian.t, allSensors$Parish.t, allSensors$Basement.t,allSensors$Office.t)
colnames(temps) <- c('Time','SanctuaryTemp','ParishTemp','BasementTemp','OfficeTemp')
t<- temps[,-1]
allTemps <- xts(t,order.by = temps$Time)# Create time series object 
dygraph(allTemps) #plot time series with dygraph

#####################################


