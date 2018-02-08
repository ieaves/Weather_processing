######################### Input / Output Files #########################

file_directory = 'processed_data'
output_directory = 'final_data'

######################### Processing Data #########################

file_list = c('merged_weather_data.csv', 'merged_station_normal_data.csv')
full_path_list = as.vector(sapply(file_list, function(x) file.path(file_directory, x)))
join_col = 'station'

# Left outer joins all tables in the file_list. Assumes that the first file in 
# file_list has all rows that should be included.
df = data.table::fread(full_path_list[[1]])
for(file in full_path_list[2:length(full_path_list)]){
  df2 = data.table::fread(file)
  df = df[df2, on=join_col]
}

######################### Writing Output Data #########################

file = file.path(output_directory, 'full_merged_weather_data.csv')
write.csv(df, file, row.names=FALSE)

file = file.path(output_directory, 'full_merged_weather_data_2016.csv')
write.csv(df[df[['DATE']]==2016], file, row.names=FALSE)