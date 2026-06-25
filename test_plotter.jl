#!/usr/bin/env julia
"""
Test script for CSV Plotter
"""

using CSV
using DataFrames
using Plots
using Test

# Test CSV reading
function test_csv_reading()
    println("Testing CSV reading...")
    
    # Create a test CSV
    test_csv = "test_data.csv"
    open(test_csv, "w") do f
        write(f, "x,y\n1,2\n3,4\n5,6\n")
    end
    
    # Read and validate
    df = CSV.read(test_csv, DataFrame)
    @test ncol(df) == 2
    @test nrow(df) == 3
    @test df[!, 1] == [1, 3, 5]
    @test df[!, 2] == [2, 4, 6]
    
    rm(test_csv)
    println("✓ CSV reading test passed")
end

# Test plotting functionality
function test_plotting()
    println("Testing plotting...")
    
    # Create test data
    x = 1:10
    y = 2 .* x
    
    # Test different plot types
    try
        p1 = plot(x, y, title="Line Plot", xlabel="X", ylabel="Y")
        @test p1 !== nothing
        println("✓ Line plot test passed")
    catch e
        println("✗ Line plot test failed: $e")
    end
    
    try
        p2 = scatter(x, y, title="Scatter Plot", xlabel="X", ylabel="Y")
        @test p2 !== nothing
        println("✓ Scatter plot test passed")
    catch e
        println("✗ Scatter plot test failed: $e")
    end
    
    try
        p3 = bar(x, y, title="Bar Plot", xlabel="X", ylabel="Y")
        @test p3 !== nothing
        println("✓ Bar plot test passed")
    catch e
        println("✗ Bar plot test failed: $e")
    end
end

# Test command line parsing
function test_argparse()
    println("Testing argument parsing...")
    
    using ArgParse
    
    s = ArgParseSettings()
    @add_arg_table! s begin
        "filename"
            required = true
        "--xlabel"
            default = "X"
        "--ylabel"
            default = "Y"
        "--type"
            default = "line"
    end
    
    # Test with minimal args
    args = parse_args(s, ["test.csv"])
    @test args["filename"] == "test.csv"
    @test args["xlabel"] == "X"
    @test args["ylabel"] == "Y"
    @test args["type"] == "line"
    
    # Test with all args
    args = parse_args(s, ["test.csv", "--xlabel", "Time", "--ylabel", "Value", "--type", "scatter"])
    @test args["filename"] == "test.csv"
    @test args["xlabel"] == "Time"
    @test args["ylabel"] == "Value"
    @test args["type"] == "scatter"
    
    println("✓ Argument parsing test passed")
end

function main()
    println("Running CSV Plotter tests...")
    println("="^40)
    
    test_csv_reading()
    test_plotting()
    test_argparse()
    
    println("="^40)
    println("All tests completed!")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end