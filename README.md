# Useful VHDL entities

The project is implemented with Xilinx ISE 14.7 but it should be easy to migrate it to Vivado. For Altera platforms, some IP cores must be adapted. Includes Xilinx ISE testbench and wave configuration files.

All the contents were developed for the [passive remote sensing group (RSLab)](https://prs.upc.edu/) as a part of the [Remote Sensing Laboratory](http://www.tsc.upc.edu/en/research/rslab), a research line of the [CommmSensLab Group](http://www.tsc.upc.edu/en/research/commsenslab) at the [Signal Theory and Communications Department (TSC)](http://www.tsc.upc.edu/en) of the [Universitat Politècnica de Catalunya (UPC)](http://www.upc.edu/?set_language=en).

New versions of this program may be found at [GitHub](https://github.com/danipascual/VHDL-utilities). 

## Main contents

### Generic use

File  | Description
------------- | ----------
AND_sync.vhd  | Ensures a pipelined AND operation of large vectors by nesting smaller ANDs.
OR_sync.vhd  | Ensures a pipelined OR operation of large vectors by nesting smaller ORs.
compare_vectors.vhd  | Compares if two vectors are equal. Pipeline is ensured by proper setting the size of the AND_sync entity.
detect_change.vhd  | Detects a change on a vector. Pipeline is ensured by proper setting the size of the compare_vectors entity.
strobe_adapter_fast2slow.vhd  | Adapts a strobe line from a fast clock to a slower clock.
strobe_adapter_slow2fast.vhd  | Adapts a strobe line from a slow clock to a faster clock.
priority_encoder.vhd  | Finds the MSB of a vector. Pipeline is not ensured if the vector is too large.
priority_encoder_nested.vhd  | Finds the MSB of a vector. Pipeline is ensured by nesting priority_encoder and by proper setting their size.
sync_SIGNALS.vhd  | Sync signals with same rate.
generic_decoder.vhd  |  Generic BCD-to-decimal decoder. To be done.
generic_decoder_accum.vhd  | Generic BCD-to-decimal decoder with accumulation. To be done.

### Examples

File  | Description
------------- | ----------
max_vector_8.vhd  | Finds the maximum between 2 unsigned vectors of 8 bits. Pipeline is ensured.
find_MSB_complex_32.vhd  | Finds the MSB of a 32 bits complex unsigned signal (i.e. 32 bits I + 32 bits Q). Pipeline is ensured by proper setting the priority_encoder_nested.
find_MSB_complex_epoch_32.vhd  | Finds the MSB of a 32 bits complex unsigned signal (i.e. 32 bits I + 32 bits Q) with a non-sliding window of "EPOCH" samples. Pipeline is ensured by proper setting the priority_encoder_nested.
agc_16_complex.vhd  | Continuous AGC of a 16 bits complex signal (i.e. 16 bits I + 16 bits Q).
moving_average_FIR_256_8_SIGNED.vhd  | Moving average of 256 samples of a 8 bits signed signal.
max_vector_8.vhd  | Finds the maximum between 2 unsigned vectors of 8 bits. Pipeline is ensured.
average_16bU_1024_64.vhd  | Average of a 1024 samples vector over 64 realizations without a sliding window. Samples are 6 bits unsigned. Pipeline is ensured. 
priority_decoder_2_4.vhd  | BCD-to-decimal decoder with an input width of 2 bits.
priority_decoder_3_8.vhd  | BCD-to-decimal decoder with an input width of 3 bits.
priority_decoder_4_16_nesting.vhd  | BCD-to-decimal decoder with an input width of 4 bits by using nested priority_decoder_3_8.vhd entities.
decoder_acumm_4_16.vhd  |  BCD-to-decimal decoder with accumulation with an input width of 4 bits.
histogram_4_64.vhd  | Histogram (PDF) of a 4 bit signal over 64 realizations.
cdf_4_64.vhd  | CDF of a 4 bit signal over 64 realizations.
perncentile50_4_64.vhd  | 50% percentile of a 4 bit signal over 64 realizations.

**AGC**: Automatic Control Gain  
**BCD**: Binary Coded Decimal
**MSB**: Most Significant Bit  
**PDF**: Probability Density Function  
**CDF**: Cumulative Density Function  

## Licence
You may find a specific licence files in each directory.

## Contact
Daniel Pascual (daniel.pascual at protonmail.com)