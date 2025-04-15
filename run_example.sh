#!/bin/bash

# Script to demonstrate the use of plantuml2png.sh

# Make sure the script is executable
chmod +x plantuml2png.sh

# Run conversion on the hello_world.wsd file
./plantuml2png.sh -v hello_world.wsd

echo "Conversion complete!"
