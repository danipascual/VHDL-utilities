# Useful VHDL entities

The project is implemented with Xilinx ISE 14.7 but it should be easy to migrate it to Vivado. For Altera platforms, some IP cores (mainly RAM memories) must be adapted. Includes Xilinx ISE testbench and wave configuration files.

All the contents were developed for the [passive remote sensing group (RSLab)](https://prs.upc.edu/) as a part of the [Remote Sensing Laboratory](http://www.tsc.upc.edu/en/research/rslab), a research line of the [CommmSensLab Group](http://www.tsc.upc.edu/en/research/commsenslab) at the [Signal Theory and Communications Department (TSC)](http://www.tsc.upc.edu/en) of the [Universitat Politècnica de Catalunya (UPC)](http://www.upc.edu/?set_language=en).

New versions of this program may be found at [GitHub](https://github.com/danipascual/VHDL-utilities). 

## Contents
File  | Commit | Description
------------- | ------------- | ----------
AND_sync.vhd  | First | Ensures a pipelined AND operation of large vectors by nesting smaller ANDs.
OR_sync.vhd  | First | Ensures a pipelined OR operation of large vectors by nesting smaller ORs.
compare_vectors.vhd  | First | Compares if two vectors are equal. Pipeline is ensured by proper setting the size of the AND_sync entity.
detect_change.vhd  | First | Detects a change on a vector. Pipeline is ensured by proper setting the size of the compare_vectors entity.
strobe_adapter_fast2slow.vhd  | First | Adapts a strobe line from a fast clock to a slower clock.
strobe_adapter_slow2fast.vhd  | First | Adapts a strobe line from a slow clock to a faster clock.
priority_encoder.vhd  | First | Finds the MSB of a vector. Pipeline is not ensured if the vector is too large.
priority_encoder_nested.vhd  | First | Finds the MSB of a vector. Pipeline is ensured by nesting priority_encoder and by  proper setting their size.
sync_SIGNALS.vhd  | Second | Sync signals with same rate.

## Licence
You may find a specific licence files in each directory.

## Contact
Daniel Pascual (daniel.pascual at protonmail.com)
