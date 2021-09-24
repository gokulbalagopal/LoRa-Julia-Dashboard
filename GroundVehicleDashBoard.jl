using CSV, DataFrames, Dates,Statistics, Dash, DashHtmlComponents, DashCoreComponents, PlotlyJS, DataStructures,JSON3
global gnd_vehicle_data = DataFrame()
#deque_o3 = Deque{Float64}()
#deque_dt = Deque{DateTime}()

function gnd_vehicle_data_update()
    ground_vehicle_path ="/home/teamlary/mintsData/referenceMQTT/001e0610c2e7/"
    #Filtering the json files
    ground_vehicle_sensor_list = filter!(s->occursin(r".json", s),readdir(ground_vehicle_path))
    sensor_name = map((x)-> replace(x, r".json"=>""),ground_vehicle_sensor_list)

    ground_vehicle_sensor_path_list = ground_vehicle_path .* ground_vehicle_sensor_list

    #Creating a single DataFrame with all the json files
    df_ls = map((x)-> DataFrame(JSON3.read(read(x))),ground_vehicle_sensor_path_list)
    df_combined = reduce(vcat, df_ls, cols=:union)
    df_combined = insertcols!(df_combined, 2, :sensors => sensor_name, makeunique=true)
    return append!(gnd_vehicle_data,df_combined)
    
end

function update_o3_graph()
    df = gnd_vehicle_data_update()
    if(nrow(df) >= 100000)
        delete!(df, 1:8)
    end
    df_ozone = dropmissing(df, :ozone)
    data = scatter(;
                x = df_ozone.dateTime,
                y = df_ozone.ozone,
                mode = "lines+markers",
                name = "Ozone",
                marker_color = :red,
                marker_size = 5,
                    )
    
    layout = Layout(;
                title = "Ozone",
                xaxis_title = "time",
                yaxis_title = "O3",
                    )
    plot(data,layout)
  

end

app = dash()

app.layout = html_div() do

            dcc_graph(
                id="o3-live-graph",
                figure = update_o3_graph()
            ),

            dcc_interval(
                id="o3-graph-update",
                interval = 100, 
                n_intervals=0
            )

end



callback!(app,
            Output("o3-live-graph", "figure"),
            Input("o3-graph-update", "n_intervals")) do n
            update_o3_graph()

end

run_server(app, "0.0.0.0",debug = true)
