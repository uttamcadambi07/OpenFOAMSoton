#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
import os

def plot_wall_shear_stress():
    """
    Reads wall shear stress data from an OpenFOAM .raw file and plots
    the x-component of the stress against the x-coordinate.
    """
    # --- Configuration ---
    # Define the path to your data file
    file_path = os.path.join(
        "postProcessing", "sampleDict", "1", "wallShearStress_surf1.raw"
    )

    # Check if the data file exists
    if not os.path.exists(file_path):
        print(f"❌ Error: Data file not found at '{file_path}'")
        return

    print(f"✅ Found data file. Reading from '{file_path}'...")
    
    try:
        # --- Data Loading ---
        # Load the data using NumPy.
        # We only need the first column (index 0, for x-coordinate) and
        # the fourth column (index 3, for wallShearStress_x).
        data = np.loadtxt(file_path, usecols=(0, 3))

        # For clarity, let's sort the data by the x-coordinate.
        # This ensures the line plot is drawn correctly from left to right.
        sorted_data = data[data[:, 0].argsort()]

        # Extract the sorted columns into clearly named variables
        x_coordinate = sorted_data[:, 0]
        wss_x = sorted_data[:, 1]

        # --- Plotting ---
        print("📊 Generating plot...")
        fig, ax = plt.subplots(figsize=(12, 7))

        ax.plot(x_coordinate, -wss_x, marker='o', markersize=3, linestyle='-', color='teal')

        # --- Formatting the Plot ---
        ax.set_title("Wall Shear Stress Distribution", fontsize=16, fontweight='bold')
        ax.set_xlabel("X-Coordinate", fontsize=12)
        ax.set_ylabel("Wall Shear Stress (X-Component), $\\tau_{wx}$", fontsize=12)
        ax.grid(True, which='both', linestyle='--', linewidth=0.5)
        
        # Add a horizontal line at y=0 for reference
        ax.axhline(0, color='black', linewidth=0.8, linestyle='-')

        plt.tight_layout() # Adjust layout to prevent labels from overlapping
        # plt.show()
        print("Saving plot...")
        # plt.show()
        plt.savefig("plot.png")

    except Exception as e:
        print(f"❌ An error occurred while processing the file: {e}")


if __name__ == "__main__":
    plot_wall_shear_stress()