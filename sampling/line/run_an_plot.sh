#!/bin/bash
# This script runs OpenFOAM sampling and then plots the results.

echo "🚀 Step 1: Running OpenFOAM sampling utility..."

# Execute the post-processing command
postProcess -func sampleDict

# Check if the last command was successful before proceeding
if [ $? -eq 0 ]; then
    echo "✅ Sampling completed successfully."
    echo "-------------------------------------"
    echo "📊 Step 2: Plotting results with Python..."
    
    # Execute the Python plotting script
    # Make sure your Python script is named 'line_sampling.py'
    python3 line_sampling.py
    
    echo "-------------------------------------"
    echo "✨ All done!"
else
    # If postProcess fails, print an error and exit
    echo "❌ Error: OpenFOAM post-processing failed. Aborting script."
    exit 1
fi
