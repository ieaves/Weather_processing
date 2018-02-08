process_file <- function(file, desired_columns){
  df = data.table::fread(file, na.string="")
  missing_columns = desired_columns[!(desired_columns %in% names(df))]
  df[, (missing_columns) := NA]
  df = df[, ..desired_columns]
  
  return(df)
}

######################### Input / Output Files #########################
# Assumes working directory is set to the weather_data folder

raw_data_folder = 'raw_data'
raw_weather_data_folder = file.path(raw_data_folder, 'gsoy-latest')

dir.create(file.path(getwd(), 'processed_data'), showWarnings = FALSE)
output_file = file.path('processed_data', 'merged_weather_data.csv')

######################### Defining Final Column ######################### 

desired_columns = c('STATION', 'DATE', 'DT32', 'DX90', 'DP01', 'DP10', 'DP1X', 'PRCP')
final_column_names = desired_columns
final_column_names[1] = 'station'

######################### Processing Data #########################
# Assumes all columns except station are numeric. Should be modified if that's not true
files = list.files(raw_weather_data_folder, full.names=TRUE)
final_df = data.table::rbindlist(lapply(files, process_file, desired_columns))
data.table::setnames(final_df, desired_columns, final_column_names)

numeric_cols = final_column_names[!(final_column_names %in% 'station')]
for(col in numeric_cols){
  final_df[[col]] = as.numeric(final_df[[col]])
}


write.csv(final_df, output_file, row.names=FALSE)
