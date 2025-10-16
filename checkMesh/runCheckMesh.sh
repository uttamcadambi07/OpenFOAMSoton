#!/bin/bash

# #############################################################################
# Script to generate a mesh, check its quality, and export bad cells.
# Workflow:
# 1. Run blockMesh.
# 2. Run checkMesh.
# 3. Export the 'highAspectRatioCells' set to VTK format for visualization.
# #############################################################################

# --- Step 1: Prerequisite Warning ---
echo "---------------------------------------------------------------------"
echo "⚠️  IMPORTANT: Please ensure the OpenFOAM environment is sourced!"
echo "   (e.g., by running 'source /opt/openfoam10/etc/bashrc')"
echo "---------------------------------------------------------------------"
echo

# --- Step 2: Run the Commands in Sequence ---

# ==> Command 1: blockMesh
echo "🚀 Step 1/3: Generating the mesh with blockMesh..."
echo "---------------------------------------------------------------------"
blockMesh

# Check if the mesher was successful before proceeding.
if [ $? -ne 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "❌ Error: blockMesh failed. Check the output above for details."
  exit 1
fi
echo "---------------------------------------------------------------------"
echo "✅ blockMesh completed successfully."
echo

# ==> Command 2: checkMesh
echo "🚀 Step 2/3: Checking mesh quality..."
echo "---------------------------------------------------------------------"
checkMesh

# checkMesh usually exits with 0 even if it finds bad cells, so we just
# check for a catastrophic failure of the utility itself.
if [ $? -ne 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "❌ Error: checkMesh failed to run. Check the output above."
  exit 1
fi
echo "---------------------------------------------------------------------"
echo "✅ checkMesh completed. Any bad cells found are listed above."
echo

# ==> Command 3: foamToVTK
echo "🚀 Step 3/3: Exporting high aspect ratio cells for visualization..."
echo "   This creates a VTK/ folder to view the cell set in ParaView."
echo "---------------------------------------------------------------------"
foamToVTK -cellSet "highAspectRatioCells"

# Final check and success message.
if [ $? -eq 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "🎉🎉🎉 Workflow completed successfully!"
  echo "You can now view the bad cells by opening the files in the new VTK/ directory."
else
  echo "---------------------------------------------------------------------"
  echo "⚠️  NOTE: 'foamToVTK' may have failed. This is often because"
  echo "   'checkMesh' found NO high aspect ratio cells, which is a good result!"
  echo "   If the output above says the 'highAspectRatioCells' set was not found,"
  echo "   your mesh quality is likely excellent in that regard."
  # We don't exit with an error here, as a missing set is often not a "failure".
fi
