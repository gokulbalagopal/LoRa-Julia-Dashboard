using CSV
using DataFrames
using Dates
using Statistics,StatsBase
using BenchmarkTools

#using TimeSeriesIO: TimeArray
data_frame = CSV.read("//mnt//3fbf694d-d8e0-46c0-903d-69d994241206//mintsData//raw//b827eb52fc29//47cb5580002e004a//47cb5580002e004a_2021-06-17.csv",DataFrame)
data_frame = select!(data_frame,Not([:gpsTime,:id]))


data_frame.dateTime = DateTime.(data_frame.dateTime,"yyyy-mm-dd HH:MM:SS")

function resampling_time_series_data(w,tf,df)
########################### Every 30 seconds ####################################
    if (w == "seconds")
        date_time_seconds_rounded = map((x) -> round(x, Dates.Second(tf)), df.dateTime)
        df_agg_seconds = select!(df,Not(:dateTime))
        df_agg_seconds.date_time_seconds_rounded  = date_time_seconds_rounded 
        gdf_date_time_seconds =  groupby(df_agg_seconds, :date_time_seconds_rounded)
        resampled_timeseries_data = combine(gdf_date_time_seconds, valuecols(gdf_date_time_seconds) .=> mean)
    end
    return resampled_timeseries_data

end
r = resampling_time_series_data("seconds",30,data_frame)
print(r)

########################### Minute wise ####################################
#=
date_time_minutes_rounded = map((x) -> round(x, Dates.Minute(1)), df.dateTime)
df_agg_minutes = select!(df,Not(:dateTime))
df_agg_minutes.date_time_minutes_rounded  = date_time_minutes_rounded 
gdf_date_time_minutes =  groupby(df_agg_minutes, :date_time_minutes_rounded)
combine(gdf_date_time_minutes, valuecols(gdf_date_time_minutes) .=> mean)
=#
########################### Every 1 hour ####################################
#=
date_time_hours_rounded = map((x) -> round(x, Dates.Hour(1)), df.dateTime)
df_agg_hours = select!(df,Not(:dateTime))
df_agg_hours.date_time_hours_rounded  = date_time_hours_rounded 
gdf_date_time_hours =  groupby(df_agg_hours, :date_time_hours_rounded)
combine(gdf_date_time_hours, valuecols(gdf_date_time_hours) .=> mean)
=#


