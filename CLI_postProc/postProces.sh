#!/bin/bash

# #############################################################################
# Script to run a sequence of post-processing utilities for simpleFoam.
# Workflow:
# 1. Calculate yPlus.
# 2. Calculate wallShearStress.
# 3. Calculate turbulence tensor R.
# #############################################################################

# --- Prerequisite Warning ---
echo "---------------------------------------------------------------------"
echo "⚠️  IMPORTANT: Please ensure the OpenFOAM environment is sourced!"
echo "   (e.g., by running 'source /opt/openfoam10/etc/bashrc')"
echo "---------------------------------------------------------------------"
echo

echo "🚀 Starting post-processing workflow..."
echo

# ==> Command 1: yPlus
echo "Step 1/3: Calculating yPlus..."
echo "---------------------------------------------------------------------"
simpleFoam -postProcess -func yPlus

# Check if the command was successful before proceeding.
if [ $? -ne 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "❌ Error: yPlus calculation failed. Check the output above."
  exit 1
fi
echo "---------------------------------------------------------------------"
echo "✅ yPlus calculation complete."
echo

# ==> Command 2: wallShearStress
echo "Step 2/3: Calculating wallShearStress..."
echo "---------------------------------------------------------------------"
simpleFoam -postProcess -func wallShearStress

# Check if the command was successful.
if [ $? -ne 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "❌ Error: wallShearStress calculation failed. Check the output above."
  exit 1
fi
echo "---------------------------------------------------------------------"
echo "✅ wallShearStress calculation complete."
echo

# ==> Command 3: R (Reynolds Stress Tensor)
echo "Step 3/3: Calculating turbulence tensor R..."
echo "---------------------------------------------------------------------"
simpleFoam -postProcess -func R

# Final check and success message.
if [ $? -eq 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "🎉🎉🎉 All post-processing functions completed successfully!"
else
  echo "---------------------------------------------------------------------"
  echo "❌ Error: Calculation of R failed. Check the output above."
  exit 1
fi
