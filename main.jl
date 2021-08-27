using CSV
using DataFrames
using Dates

#using TimeSeriesIO: TimeArray
df = CSV.read("//mnt//3fbf694d-d8e0-46c0-903d-69d994241206//mintsData//raw//b827eb52fc29//47cb5580002e004a//47cb5580002e004a_2021-06-17.csv",DataFrame)

first(df,5)
#df
df.dateTime = DateTime.(df.dateTime,"yyyy-mm-dd HH:MM:SS")

df.date_time_seconds_rounded = map((x) -> floor(x, Dates.Second(30)), df.dateTime)
df.date_time_minutes_rounded = map((x) -> floor(x, Dates.Minute(1)), df.dateTime)
df.date_time_hours_rounded = map((x) -> floor(x, Dates.Hour(1)), df.dateTime)
df.date_time_days_rounded = map((x) -> floor(x, Dates.Day(1)), df.dateTime)
print("Every 30 seconds",first(df.date_time_seconds_rounded ,10))
print("Every 1 minute",first(df.date_time_minutes_rounded ,10))
print("Every 1 hour",first(df.date_time_hours_rounded ,10))
print("Every 1 day",first(df.date_time_days_rounded ,10))
print(first(df.dateTime ,10))