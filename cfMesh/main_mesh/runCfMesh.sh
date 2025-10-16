#!/bin/bash

# #############################################################################
# Script to select a cfMesh configuration and run the meshing workflow.
# #############################################################################

# --- Step 1: Prerequisite Warning ---
echo "---------------------------------------------------------------------"
echo "⚠️  IMPORTANT: Please ensure the OpenFOAM environment is sourced!"
echo "   (e.g., by running 'source /opt/openfoam10/etc/bashrc')"
echo "---------------------------------------------------------------------"
echo

# --- Step 2: Prompt the User for Input ---
echo "Please choose the cfMesh configuration to use:"
echo "  1) Basic Mesh (uniform cell size)"
echo "  2) Local Refinement (finer cells near the object)"
echo "  3) Boundary Layers (special layers on the walls)"
echo
read -p "Enter your choice (1, 2, or 3): " choice
echo

# --- Step 3: Prepare the meshDict File Based on Choice ---
case "$choice" in
  1)
    echo "⚙️  Setting up for a Basic Mesh..."
    cp system/meshDict.basic system/meshDict
    ;;
  2)
    echo "⚙️  Setting up for Local Refinement..."
    cp system/meshDict.loc system/meshDict
    ;;
  3)
    echo "⚙️  Setting up for Boundary Layers..."
    cp system/meshDict.bl system/meshDict
    ;;
  *)
    echo "❌ Invalid choice. Please run the script again and enter 1, 2, or 3."
    exit 1 # Exit with an error status.
    ;;
esac

# Check if the 'cp' command was successful before proceeding.
if [ $? -ne 0 ]; then
    echo "❌ Error: Could not copy the dictionary file. Check that the source files exist."
    exit 1
fi

echo "✅ 'system/meshDict' is ready."
echo

# --- Step 4: Run the Meshing and Patching Commands ---
echo "🚀 Running the mesher (cartesian2DMesh)..."
echo "---------------------------------------------------------------------"
cartesian2DMesh

# Check if the mesher succeeded.
if [ $? -ne 0 ]; then
  echo "---------------------------------------------------------------------"
  echo "❌ Error: cartesian2DMesh failed. Check the output above for details."
  exit 1
fi

echo "---------------------------------------------------------------------"
echo "✅ Meshing complete. Now running createPatch..."
echo

# --- Step 5: Run createPatch ---
createPatch -overwrite

# Check if createPatch succeeded.
if [ $? -eq 0 ]; then
  echo "🎉 Meshing and patching completed successfully!"
else
  echo "❌ Error: createPatch failed. Check the output above for details."
  exit 1
fi
