#!/bin/bash

# Script to demonstrate the use of plantuml2png.sh

# Make sure the script is executable
chmod +x plantuml2png.sh

# Run conversion on the hello_world.wsd file and save to output directory
./plantuml2png.sh -v -o output/ hello_world.wsd

# Also create a file directly from the URL content
echo "Creating direct.wsd from URL content..."
echo "@startuml
Bob -> Alice : hello
@enduml" > direct.wsd

echo "Converting direct.wsd..."
./plantuml2png.sh -v -o output/ direct.wsd

echo "Conversion complete! Check the output directory for the generated PNG files."
