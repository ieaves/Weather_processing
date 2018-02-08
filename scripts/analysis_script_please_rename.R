######################### Input / Output Files #########################

file_directory = 'final_data'
file_name = file.path(file_directory, 'full_merged_weather_data_2016.csv')

######################### Processing Data #########################

df = data.table::fread(file_name)

# You should use Tibbles to do the means or w/e it is you need. I'm using data.table
# here, but you don't need to. You need to change a few things though -
# the function fread will return a data.table object instead of a data.frame
# all you need to do is something like df = as.data.frame(df)
group_cols = c('zip')
numeric_cols = names(df)[!(names(df) %in% c('station', 'DATE', 'lat', 'lon', 'zip'))]
avg_by_zip = df[, lapply(.SD, mean, na.rm=TRUE), by=group_cols, .SDcols=numeric_cols]
print(avg_by_zip)