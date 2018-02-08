process_file <- function(root, file_name, col_names){
  url = file.path(root, file_name)
  df = data.table::fread(url, na.string="")
  names(df) <- col_names
  df[[names(df)[2]]] = sub( "[CSRPQ]", "", df[[col_names[2]]])
  df[[names(df)[2]]] = as.numeric(df[[col_names[2]]])
  return(df)
}

process_file_list <- function(root, file_list){
  file = names(file_list[1])
  col_names = file_list[[file]]
  df = process_file(root, file, col_names)
  
  for(file in names(file_list[2:length(file_list)])){
    col_names = file_list[[file]]
    df2 = process_file(root, file, col_names)
    df = df[df2, on=col_names[[1]]]
  }
  return(df)
}
output_file = file.path('processed_data', 'merged_station_normal_data.csv')
root_url = 'https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/precipitation/'
urls = list('ann-prcp-avgnds-ge001hi.txt'=c('station', 'prcp001_day_tenths'),
            'ann-prcp-avgnds-ge010hi.txt'=c('station','prcp010_day_tenths'),
            'ann-prcp-avgnds-ge100hi.txt'=c('station','prcp100_day_tenths'),
            'ann-prcp-normal.txt'=c('station','prcpnorm_inch_hundredths'))

final_df = process_file_list(root_url, urls)

root_url = 'https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/products/temperature/'
urls = list('ann-tmax-avgnds-grth090.txt'=c('station', 'temp090_day_tenths'),
            'ann-tmin-avgnds-lsth032.txt'=c('station','temp032_day_tenths'))

temp_df = process_file_list(root_url, urls)
final_df = final_df[temp_df, on='station']

file = 'https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/station-inventories/allstations.txt'
col_names = c('station','lat','lon')
latlon_df <- read.table(file, header=FALSE, fill=TRUE, na.strings=c('', NA),
                        stringsAsFactors=FALSE)
latlon_df <- latlon_df[,c(1,2,3)]
names(latlon_df) <- col_names
final_df = final_df[latlon_df, on='station']

file = 'https://www1.ncdc.noaa.gov/pub/data/normals/1981-2010/station-inventories/zipcodes-normals-stations.txt'
col_names <- c('station', 'zip')
zipcodes_df <- read.table(file, header=FALSE, fill=TRUE, na.strings=c("", "NA"),
                          stringsAsFactors=FALSE, colClasses='character')
zipcodes_df <- na.omit(zipcodes_df) 
zipcodes_df <- zipcodes_df[,c(1,2)] #this and previous gets rid of poorly read multi-word place names and resulting bad rows
names(zipcodes_df) <- col_names

final_df = final_df[zipcodes_df, on='station']
write.csv(final_df, output_file, row.names=FALSE)