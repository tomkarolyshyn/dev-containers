#!/bin/bash

# VITIS_DIR=/tools/Xilinx/Vitis/2024.2
VITIS_DIR=${1:-/tools/Xilinx/2025.2/Vitis}

echo "VITIS_DIR is set to: $VITIS_DIR"

pushd "$VITIS_DIR" || { echo "Directory not found!"; exit 1; }


# Change to directory where problematic standard libraries are.
# cd Vitis/2024.2/lib/lnx64.o/Ubuntu/
cd lib/lnx64.o/Ubuntu/

# Make backup copies of your current libraries.

if [ ! -f libstdc++.so.bkup ]; then
    mv libstdc++.so libstdc++.so.bkup
    mv libstdc++.so.6 libstdc++.so.6.bkup

    # Soft-link system libraries.
    ln -s /lib/x86_64-linux-gnu/libstdc++.so.6 libstdc++.so.6
    ln -s /lib/x86_64-linux-gnu/libstdc++.so.6 libstdc++.so

    # If the last step does not work due to wrong system libraries,
    # you can look for them with this command:
    ldconfig -p | grep stdc++

    echo "Vitis Fix applied"
else
    echo "Vitis Fix already applied"
fi

popd
