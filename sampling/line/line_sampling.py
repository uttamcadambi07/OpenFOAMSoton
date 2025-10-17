#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
import os

def plot_velocity_profiles():
    """
    Reads OpenFOAM sampling data and plots staggered velocity profiles.
    """
    # --- Configuration ---
    # Path to the directory containing the data files
    data_directory = os.path.join("postProcessing", "sampleDict", "1")
    
    # Create a figure and axes for the plot
    fig, ax = plt.subplots(figsize=(10, 8))

    # --- Data Processing and Plotting Loop ---
    # Loop through the 9 profiles (from Centerline to Centerline8)
    for i in range(9):
        # Construct the filename based on the loop index 'i'
        if i == 0:
            # The first file has no number
            filename = "Centerline_U_UData.xy"
        else:
            filename = f"Centerline{i}_U_UData.xy"
        
        full_path = os.path.join(data_directory, filename)

        # Check if the file actually exists before trying to read it
        if not os.path.exists(full_path):
            print(f"Warning: File not found, skipping: {full_path}")
            continue

        try:
            # Load the data from the text file using NumPy
            # We only need the first two columns (y-coord and Ux)
            data = np.loadtxt(full_path, usecols=(0, 1))
            
            # Extract columns for clarity
            y_coordinate = data[:, 0]
            Ux_velocity = data[:, 1]

            # Apply the offset to avoid overlapping profiles
            Ux_offset = 2*Ux_velocity/0.028 + i
            
            # Plot the profile with a descriptive label
            ax.plot(Ux_offset, y_coordinate, label=f'Profile {i} (Ux + {i})')
            
        except Exception as e:
            print(f"Could not process file {full_path}. Error: {e}")

    # --- Final Plot Formatting ---
    ax.set_title(r"Staggered Velocity Profiles ($U_x/U_{\infty}$)", fontsize=16)
    ax.set_xlabel(r"$2 U_x/U_{\infty}$ + $x/H$", fontsize=12)
    ax.set_ylabel(r"$y/H$", fontsize=12)
    # ax.legend()
    # ax.grid(True, linestyle='--', alpha=0.7)
    
    print("Saving plot...")
    # plt.show()
    plt.savefig("plot.png")


if __name__ == "__main__":
    plot_velocity_profiles()