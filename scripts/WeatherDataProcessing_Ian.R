

########################## Zipcode Weather #################################



#### Process Annual Weather By Zipcode 
#download zipped files here: https://www.ncei.noaa.gov/data/gsoy/archive/) (documentation in parent directory)
#pull from saved data in D drive instead of from the web

l<- list.files('D:/Weather_AnnualSummary_2016')
L<- length(l)
gsoy<-rep(0,7) #six var collecting: DT32, DX90, DP01, DP10, DP1X, PRCP
wthr2016<-gsoy
for ( i in 1:L){
  print(i)
  setwd('D:/Weather_AnnualSummary_2016')
  flnm<-l[i]
  w<-read.csv(flnm)
  dateid<-which(w$DATE==2016)
  varid1<-which(names(w)=="DT32")
  varid2<-which(names(w)=="DX90")
  varid3<-which(names(w)=="DP01")
  varid4<-which(names(w)=="DP10")
  varid5<-which(names(w)=="DP1X")
  varid6<-which(names(w)=="PRCP")
  if (length(dateid)>0 ){
    gsoy[1]<-as.character(w$STATION[dateid])
    if (length(varid1)>0){
      gsoy[2]<-w[dateid,c('DT32')]
    } else{gsoy[2]<-NA}
    if (length(varid2)>0){
      gsoy[3]<-w[dateid,c('DX90')]
    } else{gsoy[3]<-NA}
    if (length(varid3)>0){
      gsoy[4]<-w[dateid,c('DP01')]
    } else{gsoy[4]<-NA}
    if (length(varid4)>0){
      gsoy[5]<-w[dateid,c('DP10')]
    } else{gsoy[5]<-NA}
    if (length(varid5)>0){
      gsoy[6]<-w[dateid,c('DP1X')]
    } else{gsoy[6]<-NA}
    if (length(varid6)>0){
      gsoy[7]<-w[dateid,c('PRCP')]
    } else{gsoy[7]<-NA}
    wthr2016<-rbind(wthr2016,gsoy)
  }
} 

wthr2016<-wthr2016[-1,]
wthr2016<-as.data.frame(wthr2016)
names(wthr2016)<-c('station','DT32','DX90','DP01','DP10','DP1X','PRCP')

#### Annual Weather Normals By Zipcode 

# access data repository ( or download at https://www.ncei.noaa.gov/data/normals-annualseasonal/archive/)
# documentation here: https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/readme.txt
# link names
#lnks<- c("ann-prcp-avgnds-ge001hi.txt","ann-prcp-avgnds-ge010hi.txt","ann-prcp-avgnds-ge100hi.txt", "ann-prcp-normal.txt","ann-tmax-avgnds-grth090.txt",
#  "ann-tmin-avgnds-lsth000.txt", "ann-tmin-avgnds-lsth032.txt")
# retrieve normals data  
prcp001<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/precipitation/ann-prcp-avgnds-ge001hi.txt')
names(prcp001)<-c('station','prcp001_day_tenths')
prcp001$station<-as.character(prcp001$station)
prcp001$prcp001_day_tenths<-as.character(prcp001$prcp001_day_tenths)
prcp001$prcp001_day_tenths<-sub( "[CSRPQ]","",prcp001$prcp001_day_tenths) #remove flags from norm data
prcp001$prcp001_day_tenths<-as.numeric(prcp001$prcp001_day_tenths)

prcp010<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/precipitation/ann-prcp-avgnds-ge010hi.txt')
names(prcp010)<-c('station','prcp010_day_tenths')
prcp010$station<-as.character(prcp010$station)
prcp010$prcp010_day_tenths<-as.character(prcp010$prcp010_day_tenths)
prcp010$prcp010_day_tenths<-sub( "[CSRPQ]","",prcp010$prcp010_day_tenths)
prcp010$prcp010_day_tenths<-as.numeric(prcp010$prcp010_day_tenths)

prcp100<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/precipitation/ann-prcp-avgnds-ge100hi.txt')
names(prcp100)<-c('station','prcp100_day_tenths')
prcp100$station<-as.character(prcp100$station)
prcp100$prcp100_day_tenths<-as.character(prcp100$prcp100_day_tenths)
prcp100$prcp100_day_tenths<-sub( "[CSRPQ]","",prcp100$prcp100_day_tenths)
prcp100$prcp100_day_tenths<-as.numeric(prcp100$prcp100_day_tenths)

prcpnorm<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/precipitation/ann-prcp-normal.txt')
names(prcpnorm)<-c('station','prcpnorm_inch_hundredths') #verify inch units
prcpnorm$station<-as.character(prcpnorm$station)
prcpnorm$prcpnorm_inch_hundredths<-as.character(prcpnorm$prcpnorm_inch_hundredths)
prcpnorm$prcpnorm_inch_hundredths<-sub( "[CSRPQ]","",prcpnorm$prcpnorm_inch_hundredths)
prcpnorm$prcpnorm_inch_hundredths<-as.numeric(prcpnorm$prcpnorm_inch_hundredths)

temp090<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/ann-tmax-avgnds-grth090.txt')
names(temp090)<-c('station','temp090_day_tenths')
temp090$station<-as.character(temp090$station)
temp090$temp090_day_tenths<-as.character(temp090$temp090_day_tenths)
temp090$temp090_day_tenths<-sub( "[CSRPQ]","",temp090$temp090_day_tenths)
temp090$temp090_day_tenths<-as.numeric(temp090$temp090_day_tenths)

temp032<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/ann-tmin-avgnds-lsth032.txt')
names(temp032)<-c('station','temp032_day_tenths')
temp032$station<-as.character(temp032$station)
temp032$temp032_day_tenths<-as.character(temp032$temp032_day_tenths)
temp032$temp032_day_tenths<-sub( "[CSRPQ]","",temp032$temp032_day_tenths)
temp032$temp032_day_tenths<-as.numeric(temp032$temp032_day_tenths)

# retrieve station data  
#   stations lat/long  
allstations<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/station-inventories/allstations.txt',header=FALSE,fill=TRUE)
allstations<-allstations[,c(1,2,3)] #get rid of unexplained columns, which also have poorly filled entries via read.table(..., fill=T)
names(allstations)<-c('station','lat','long')
allstations$station<-as.character(allstations$station)

#   station zip  
zipstations<-read.table('https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/station-inventories/zipcodes-normals-stations.txt',header=FALSE, fill=TRUE, na.strings=c("", "NA"))
zipstations<-na.omit(zipstations) 
zipstations<-zipstations[,c(1,2)] #this and previous gets rid of poorly read multi-word place names and resulting bad rows
names(zipstations)<-c('station', 'zip')
#zipstations$zip<-as.numeric(as.character(zipstations$zip)) #this doesn't do what it's supposed to do
zipstations$station<-as.character(zipstations$station)


# match stations with lat/long, zip, and reported normals 
#left_join(x,y) includes all of x, and matching rows of y
#inner_join(x,y) includes only rows of x and y with a matching value 
#full_join(x,y) includes all values to be matched over, and NAs where there are blanks
#matching done over values in by = c( , ,)
library(dplyr)

station_data<- left_join(allstations,zipstations, by ="station") %>%left_join(prcp001,by ="station")%>%left_join(prcp010,by='station')%>% left_join(prcp100,by='station')%>%
  left_join(prcpnorm, by='station') %>% left_join(temp032,by = 'station') %>% left_join(temp090, by = 'station')

statdatall<-left_join(station_data,wthr2016, by ='station')


#identify zipcodes with multiple stations, and pick the station with the most info/ merge the measures, dropping multiples
#start at 2 to ignore zip = NA, don't want to lump those together

u<-unique(as.character(station_data$zip) ) 
ul<-length(unique(station_data$zip))
sdl<-length(station_data[1,])
station_data_zip<-matrix(rep(0,ul*(sdl-1)),ncol = sdl-1)
names(station_data_zip)<-c('zipcode',names(station_data)[-c(1,4)])
for(x in 2: length(u)){
  id<-which(station_data$zip == u[x])
  uid<-station_data[id,-c(1,4)]
  preout<-colMeans(uid,na.rm=TRUE)
  station_data_zip[(x-1),]<-c(u[x],preout)
}
names(station_data_zip)<-c('zipcode',names(station_data)[-c(1,4)])



# match 2016 data with appropriate normals      
#??



### calculate distance from zips reported in survey to each weather station with 2016 data
#first match on zips
dat$zipcode<-as.factor(dat$zipcode)
datw<-left_join(dat,station_data_clean, by = c("zipcode" = "zip"))

#match on distance for zipcodes without stations in them

#only consider each zip in data once
datzips<-unique(dat$zipcode)

#match each zip in data with its lat and long from census zcta data
zipshortlist<-sapply(seq_along(datzips), function(x) which( zcta$GEOID == datzips[x]))
datlat<-zcta$INTPTLAT[as.numeric(zipshortlist)]
datlong<-zcta$INTPTLONG[as.numeric(zipshortlist)]
dz<-data.frame(matrix(c(datzips,datlat,datlong),ncol=3, byrow=FALSE))
names(dz)<-c("zip","lat","long")

#distance from each zip in dat to each weather station with 2016 record
distmat<- sapply(seq_along(dz$zip), function(y) sapply(seq_along(weather$STATION),function(x,y) distance(x,y), y))
dz$neareststationID<-sapply(seq_along(dz$zip), function(x) which.min(distmat[x,])) #this returns ID of station, which corresponds to ROW in weather data
dz$dist2station<-sapply(seq_along(dz$zip), function(x) min(distmax[x,]))
stationstats<-sapply(seq_along(dz$zip), function(x) weather[dz$neareststationID[x],])
zipweather<-cbind(dz,stationstats)







