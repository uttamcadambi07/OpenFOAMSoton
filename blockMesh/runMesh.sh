#!/bin/bash

# #############################################################################
# Script to select a geometry, prepare the blockMeshDict, and run blockMesh.
# #############################################################################

echo "---------------------------------------------------------------------"
echo "⚠️  IMPORTANT: Please ensure the OpenFOAM environment is sourced!"
echo "   (e.g., by running 'source /opt/openfoam10/etc/bashrc')"
echo "---------------------------------------------------------------------"
echo

echo "Please choose the geometry to mesh:"
echo "  1) Flat Plate"
echo "  2) Cylinder"
echo
read -p "Enter your choice (1 or 2): " choice
echo

case "$choice" in
  1)
    echo "⚙️  Setting up mesh for a Flat Plate..."
    cp system/blockMeshDict.fp system/blockMeshDict
    ;;
  2)
    echo "⚙️  Setting up mesh for a Cylinder..."
    cp system/blockMeshDict.cylinder system/blockMeshDict
    ;;
  *)
    echo "❌ Invalid choice. Please run the script again and enter 1 or 2."
    exit 1
    ;;
esac

# Check if the 'cp' command was successful before proceeding
if [ $? -ne 0 ]; then
    echo "❌ Error: Could not copy the dictionary file. Please check paths and permissions."
    exit 1
fi

echo "✅ Dictionary 'system/blockMeshDict' is ready."
echo
echo "🚀 Running blockMesh..."
echo "---------------------------------------------------------------------"

# Execute the blockMesh command
blockMesh

# --- IMPROVEMENT HERE ---
# Check the exit code of the 'blockMesh' command
if [ $? -eq 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "🎉 blockMesh completed successfully!"
else
  echo "---------------------------------------------------------------------"
  echo "❌ Error: blockMesh failed. Check the output above for details."
  exit 1
fi
