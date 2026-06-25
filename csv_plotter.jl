#!/usr/bin/env julia
"""
Simple CSV Plotter - A Julia tool to visualize 2-column CSV data interactively

Usage:
    julia csv_plotter.jl [filename.csv] [options]

Options:
    --xlabel XLABEL    Set x-axis label
    --ylabel YLABEL    Set y-axis label  
    --title TITLE      Set plot title
    --type PLOT_TYPE   Set plot type: line, scatter, bar, histogram (default: line)
    --interactive      Use interactive backend (default: true)
    --save FILENAME    Save plot to file
    --help             Show this help

Examples:
    julia csv_plotter.jl data.csv
    julia csv_plotter.jl data.csv --title "My Data" --xlabel "Time" --ylabel "Value"
    julia csv_plotter.jl data.csv --type scatter --save plot.png
"""

using ArgParse
using CSV
using DataFrames
using Plots

function parse_commandline()
    s = ArgParseSettings(description="Simple CSV Plotter - Visualize 2-column CSV data")
    
    @add_arg_table! s begin
        "filename"
            help = "CSV file to plot"
            required = true
        "--xlabel"
            help = "X-axis label"
            default = "X"
        "--ylabel"
            help = "Y-axis label"
            default = "Y"
        "--title"
            help = "Plot title"
            default = "CSV Data Plot"
        "--type"
            help = "Plot type: line, scatter, bar, histogram"
            default = "line"
        "--interactive"
            help = "Use interactive backend"
            action = :store_true
        "--save"
            help = "Save plot to file"
        "--width"
            help = "Plot width in pixels"
            default = "800"
            arg_type = Int
        "--height"
            help = "Plot height in pixels"
            default = "600"
            arg_type = Int
    end
    
    return parse_args(s)
end

function validate_csv(filepath)
    """Check if CSV file exists and has exactly 2 columns"""
    if !isfile(filepath)
        error("File '$filepath' not found")
    end
    
    # Try to read the CSV
    try
        df = CSV.read(filepath, DataFrame)
        if ncol(df) != 2
            error("CSV must have exactly 2 columns, found $(ncol(df))")
        end
        return df
    catch e
        error("Error reading CSV file: $e")
    end
end

function create_plot(df, args)
    """Create plot based on arguments"""
    x_data = df[!, 1]
    y_data = df[!, 2]
    
    # Set backend based on interactivity
    if args["interactive"]
        # Try to use an interactive backend
        try
            gr()  # GR backend works well cross-platform
        catch
            try
                plotly()  # Plotly for web-based interactivity
            catch
                pyplot()  # Matplotlib backend
            end
        end
    else
        gr()  # Non-interactive GR backend
    end
    
    # Create plot based on type
    plot_type = lowercase(args["type"])
    
    p = if plot_type == "scatter"
        scatter(x_data, y_data, 
                xlabel=args["xlabel"], 
                ylabel=args["ylabel"],
                title=args["title"],
                legend=false,
                size=(args["width"], args["height"]))
    elseif plot_type == "bar"
        bar(x_data, y_data,
            xlabel=args["xlabel"], 
            ylabel=args["ylabel"],
            title=args["title"],
            legend=false,
            size=(args["width"], args["height"]))
    elseif plot_type == "histogram"
        histogram(y_data,
                  xlabel=args["xlabel"], 
                  ylabel=args["ylabel"],
                  title=args["title"],
                  legend=false,
                  size=(args["width"], args["height"]))
    else  # line (default)
        plot(x_data, y_data,
             xlabel=args["xlabel"], 
             ylabel=args["ylabel"],
             title=args["title"],
             legend=false,
             linewidth=2,
             marker=:circle,
             markersize=4,
             size=(args["width"], args["height"]))
    end
    
    return p
end

function main()
    args = parse_commandline()
    
    println("CSV Plotter - Loading data from: ", args["filename"])
    
    # Validate and load CSV
    df = validate_csv(args["filename"])
    println("Loaded CSV with $(nrow(df)) rows and $(ncol(df)) columns")
    
    # Create plot
    p = create_plot(df, args)
    
    # Save if requested
    if args["save"] !== nothing
        savefig(p, args["save"])
        println("Plot saved to: ", args["save"])
    end
    
    # Display plot
    display(p)
    
    # For interactive mode, keep the plot open
    if args["interactive"]
        println("Interactive plot displayed. Close the plot window to exit.")
        # Wait for user to close the plot
        try
            gui()  # This keeps the plot window open
        catch
            # Fallback: just display and wait
            println("Press Enter to exit...")
            readline()
        end
    end
end

# Check if we're being run as a script
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end