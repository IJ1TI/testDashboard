#!/usr/bin/env julia
"""
Build script to create standalone executable using PackageCompiler.jl

Usage:
    julia build_standalone.jl

This will create a standalone executable that can be run without Julia installed.
"""

using Pkg
using PackageCompiler

function main()
    println("Building standalone CSV Plotter executable...")
    println("="^50)
    
    # Ensure all dependencies are installed
    println("Installing/updating dependencies...")
    Pkg.instantiate()
    Pkg.resolve()
    
    # Precompile all packages to speed up the executable
    println("Precompiling packages...")
    using ArgParse
    using CSV
    using DataFrames
    using Plots
    
    println("All packages precompiled successfully.")
    
    # Create the executable
    println("\nCreating standalone executable...")
    
    # Define the app name
    app_name = "csv_plotter"
    
    # Create a sysimage that includes all dependencies
    println("Creating system image...")
    create_sysimage(
        :CSVPlotterApp,
        sysimage_path = "$app_name.so",
        precompile_statements_file = "precompile.jl"
    )
    
    # Create the executable
    println("Creating executable...")
    create_app(
        "$app_name.jl",
        "$app_name",
        sysimage_path = "$app_name.so",
        force = true
    )
    
    println("\n" * "="^50)
    println("✓ Standalone executable created successfully!")
    println("Executable: $app_name (or $app_name.exe on Windows)")
    println("\nTo run:")
    println("  Linux/macOS: ./$app_name data.csv")
    println("  Windows: $app_name.exe data.csv")
    println("\nNote: The executable includes the Julia runtime and all dependencies.")
    println("First run may take a few seconds to initialize.")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end