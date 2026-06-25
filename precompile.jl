# Precompile statements for PackageCompiler
# This ensures all necessary packages are included in the sysimage

using ArgParse
using CSV
using DataFrames
using Plots

# Precompile common functions
function precompile_functions()
    # CSV reading
    df = CSV.read(IOBuffer("x,y\n1,2\n3,4\n"), DataFrame)
    
    # Plotting functions
    p1 = plot([1,2,3], [1,2,3])
    p2 = scatter([1,2,3], [1,2,3])
    p3 = bar([1,2,3], [1,2,3])
    p4 = histogram([1,2,3,4,5])
    
    # Argument parsing
    s = ArgParseSettings()
    @add_arg_table! s begin
        "filename"
            required = true
    end
    args = parse_args(s, ["test.csv"])
    
    return nothing
end

# Call the function to ensure it's compiled
precompile_functions()