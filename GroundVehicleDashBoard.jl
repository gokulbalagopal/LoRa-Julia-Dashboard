using CSV, DataFrames, Dates,Statistics, Dash, DashHtmlComponents, DashCoreComponents, PlotlyJS, DataStructures,JSONTables
ground_vehicle_path = "/home/teamlary/mintsData/referenceMQTT/001e0610c2e7/"

#Filtering the json files
ground_vehicle_sensor_list = filter!(s->occursin(r".json", s),readdir(ground_vehicle_path))
ground_vehicle_sensor_path_list = ground_vehicle_path .* ground_vehicle_sensor_list

#Creating a single DataFrame with all the json files
df_ls = map((x)-> DataFrame(JSON3.read(read(x))),ground_vehicle_sensor_path_list)
df_combined = reduce(vcat, df_ls, cols=:union)



#= need to handle this with prometheus / sql  and make a single data frame with all the sensors combined
app = dash()
trace1 = scatter(;x = r[!,"date_time_rounded"], y = r[!,"NH3_mean"],mode= "markers + lines", marker_size = 5, marker_color = :green)
p1 = plot([trace1])
app.layout = html_div() do
    html_h1("Finally"),
    html_div("Its working"),
    dcc_graph(
        id="figure",
        figure=p1,
    )
end

run_server(app, "0.0.0.0", debug=true)
=#
