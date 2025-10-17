#!/bin/bash
# This script runs OpenFOAM sampling and then plots the wall shear stress.

echo "🚀 Step 1: Running OpenFOAM sampling utility..."

# Execute the post-processing command.
# This generates the .raw file needed by the Python script.
postProcess -func sampleDict

# Check if the last command was successful before proceeding.
if [ $? -eq 0 ]; then
    echo "✅ Sampling completed successfully."
    echo "-------------------------------------"
    echo "📊 Step 2: Plotting wall shear stress results..."
    
    # Execute your new Python plotting script.
    python3 patchSampling.py
    
    echo "-------------------------------------"
    echo "✨ All done!"
else
    # If postProcess fails, print an error and stop the script.
    echo "❌ Error: OpenFOAM post-processing failed. Aborting script."
    exit 1
fi
