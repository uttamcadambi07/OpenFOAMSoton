#!/bin/bash

# #############################################################################
# Script to import a Fluent .msh file and automatically patch it.
# Workflow:
# 1. Ask user for the .msh filename.
# 2. Run fluentMeshToFoam.
# 3. Run autoPatch.
# 4. Run createPatch.
# #############################################################################

# --- Step 1: Prerequisite Warning ---
echo "---------------------------------------------------------------------"
echo "⚠️  IMPORTANT: Please ensure the OpenFOAM environment is sourced!"
echo "   (e.g., by running 'source /opt/openfoam10/etc/bashrc')"
echo "---------------------------------------------------------------------"
echo

# --- Step 2: Get the Filename from the User ---
read -p "Enter the name of the Fluent mesh file (e.g., myMesh.msh): " fluentMeshFile
echo

# --- Step 3: Validate the User's Input ---
# Check if the user actually entered something.
if [ -z "$fluentMeshFile" ]; then
    echo "❌ Error: No filename was provided. Please run the script again."
    exit 1
fi

# Check if the file exists in the current directory.
if [ ! -f "$fluentMeshFile" ]; then
    echo "❌ Error: The file '$fluentMeshFile' was not found."
    echo "   Please make sure it is in the same directory as this script."
    exit 1
fi

echo "✅ File '$fluentMeshFile' found. Starting the import process..."
echo

# --- Step 4: Run the Commands in Sequence ---

# ==> Command 1: fluentMeshToFoam
echo "🚀 Step 1/3: Converting Fluent mesh..."
echo "---------------------------------------------------------------------"
fluentMeshToFoam "$fluentMeshFile"

# Check if the conversion was successful before proceeding.
if [ $? -ne 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "❌ Error: fluentMeshToFoam failed. Check the output above for details."
  exit 1
fi
echo "---------------------------------------------------------------------"
echo "✅ Mesh conversion successful."
echo

# ==> Command 2: autoPatch
echo "🚀 Step 2/3: Automatically detecting patches..."
echo "---------------------------------------------------------------------"
autoPatch 60 -overwrite

# Check if autoPatch was successful.
if [ $? -ne 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "❌ Error: autoPatch failed. Check the output above for details."
  exit 1
fi
echo "---------------------------------------------------------------------"
echo "✅ autoPatch completed."
echo

# ==> Command 3: createPatch
echo "🚀 Step 3/3: Finalizing patches..."
echo "---------------------------------------------------------------------"
createPatch -overwrite

# Final check and success message.
if [ $? -eq 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "🎉🎉🎉 Workflow completed successfully! Your mesh is ready."
else
  echo "---------------------------------------------------------------------"
  echo "❌ Error: createPatch failed. Check the output above for details."
  exit 1
fi
