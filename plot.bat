@echo off
REM CSV Plotter - Simple visualization tool
REM Usage: plot.bat filename.csv [options]

setlocal

REM Check if Julia is available
where julia >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Error: Julia is not installed or not in PATH
    echo Please install Julia from https://julialang.org/downloads/
    pause
    exit /b 1
)

REM Run the CSV plotter
julia --project "%~dp0csv_plotter.jl" %*

endlocal