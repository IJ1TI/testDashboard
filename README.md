# CSV Plotter - Simple Julia Visualization Tool

A simple, cross-platform Julia tool to visualize 2-column CSV data interactively.

## Features

- **Cross-platform**: Works on Linux, Windows, and macOS
- **Interactive plots**: Supports interactive visualization
- **Multiple plot types**: Line, scatter, bar, and histogram plots
- **Customizable**: Set titles, axis labels, and dimensions
- **Save capability**: Export plots to image files
- **Standalone executable**: Can be compiled to run without Julia installed

## Requirements

- Julia 1.8 or higher
- Required packages: ArgParse, CSV, DataFrames, Plots

## Installation

### Method 1: Clone and run directly

```bash
# Clone the repository
git clone https://github.com/IJ1TI/testDashboard.git
cd testDashboard

# Install dependencies (first time only)
julia --project -e 'using Pkg; Pkg.instantiate()'

# Run the plotter
julia --project csv_plotter.jl sample_data.csv
```

### Method 2: Add as a package (optional)

```julia
using Pkg
Pkg.add(url="https://github.com/IJ1TI/testDashboard.git")
```

### Method 3: Standalone Executable (No Julia Required)

Build a standalone executable that includes the Julia runtime:

```bash
# Clone the repository
git clone https://github.com/IJ1TI/testDashboard.git
cd testDashboard

# Install PackageCompiler (if not already installed)
julia -e 'using Pkg; Pkg.add("PackageCompiler")'

# Build the standalone executable
julia build_standalone.jl

# Run the executable (no Julia installation needed)
./csv_plotter sample_data.csv --title "My Plot"
```

**Note:** The standalone executable will be larger (~50-100MB) as it includes the Julia runtime.

#### Windows Standalone
```batch
:: Build
julia build_standalone.jl

:: Run
csv_plotter.exe data.csv --title "My Plot"
```

#### Linux/macOS Standalone
```bash
# Make executable
chmod +x csv_plotter

# Run
./csv_plotter data.csv --title "My Plot"
```

## Usage

### Basic usage

```bash
# Plot a CSV file with default settings
julia --project csv_plotter.jl data.csv

# With custom labels and title
julia --project csv_plotter.jl data.csv --xlabel "Time" --ylabel "Value" --title "My Data"

# As a scatter plot
julia --project csv_plotter.jl data.csv --type scatter

# Save plot to file
julia --project csv_plotter.jl data.csv --save plot.png

# Non-interactive mode
julia --project csv_plotter.jl data.csv --interactive false
```

### Command-line options

```
Usage: julia csv_plotter.jl [filename.csv] [options]

Options:
    --xlabel XLABEL    Set x-axis label (default: "X")
    --ylabel YLABEL    Set y-axis label (default: "Y")
    --title TITLE      Set plot title (default: "CSV Data Plot")
    --type PLOT_TYPE   Set plot type: line, scatter, bar, histogram (default: line)
    --interactive      Use interactive backend (default: true)
    --save FILENAME    Save plot to file
    --width WIDTH      Plot width in pixels (default: 800)
    --height HEIGHT    Plot height in pixels (default: 600)
    --help             Show help
```

### CSV Format

The CSV file must have exactly 2 columns. The first column is used for x-values, the second for y-values.

Example `data.csv`:
```csv
x,y
1,2
2,4
3,6
4,8
5,10
```

## Backends

The tool automatically selects the best available backend:

1. **GR** (default): Fast, works well cross-platform
2. **Plotly**: Web-based interactive plots
3. **PyPlot**: Matplotlib-based plots

For best interactive experience, install the GR backend:
```julia
using Pkg
Pkg.add("GR")
```

## Windows Setup

### Option 1: Using Julia from command prompt

1. Install Julia from https://julialang.org/downloads/
2. Add Julia to PATH during installation
3. Open Command Prompt and navigate to the repository
4. Run the plotter as shown above

### Option 2: Create a batch file

Create `plot.bat`:
```batch
@echo off
julia --project csv_plotter.jl %1 %2 %3 %4 %5 %6 %7 %8 %9
```

Then run:
```batch
plot.bat data.csv --title "My Plot"
```

## Linux Setup

### Install Julia

```bash
# Ubuntu/Debian
sudo apt install julia

# Fedora
sudo dnf install julia

# Arch Linux
sudo pacman -S julia
```

### Create a shell script

Create `csv-plot`:
```bash
#!/bin/bash
julia --project "$(dirname "$0")/csv_plotter.jl" "$@"
```

Make it executable:
```bash
chmod +x csv-plot
```

Then run:
```bash
./csv-plot data.csv --title "My Plot"
```

## Example Plots

### Line plot (default)
```bash
julia --project csv_plotter.jl sample_data.csv --title "Linear Data"
```

### Scatter plot
```bash
julia --project csv_plotter.jl sample_data.csv --type scatter --title "Scatter Plot"
```

### Bar chart
```bash
julia --project csv_plotter.jl sample_data.csv --type bar --title "Bar Chart"
```

### Histogram
```bash
julia --project csv_plotter.jl sample_data.csv --type histogram --ylabel "Frequency"
```

## Building Standalone Executable

To create a standalone executable that runs without Julia installed:

### Requirements for Building
- Julia 1.8+ (only needed for building, not for running the final executable)
- PackageCompiler.jl package

### Build Steps

1. **Install PackageCompiler** (if not already installed):
   ```julia
   using Pkg
   Pkg.add("PackageCompiler")
   ```

2. **Build the executable**:
   ```bash
   julia build_standalone.jl
   ```

3. **Run the executable**:
   ```bash
   # Linux/macOS
   ./csv_plotter data.csv --title "My Plot"
   
   # Windows
   csv_plotter.exe data.csv --title "My Plot"
   ```

### Notes
- The first build may take several minutes
- The executable will be ~50-100MB in size
- The executable includes the Julia runtime and all dependencies
- First run of the executable may take a few seconds to initialize

## Troubleshooting

### "Package not found" errors

Run:
```julia
using Pkg
Pkg.instantiate()
```

### No plot window appears

Try specifying a different backend:
```julia
using Plots
plotly()  # or pyplot(), or gr()
```

### CSV reading issues

Ensure your CSV has exactly 2 columns and uses commas as separators.

## License

MIT License

## Contributing

Feel free to submit issues and pull requests!
