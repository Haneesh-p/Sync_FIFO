# Sync_FIFO

## Synchronous FIFO with Synchronous Reset

This module implements a synthesizable, parameterized **Synchronous FIFO (First-In, First-Out)** memory buffer designed in Verilog. Both read and write operations are synchronized to the rising edge of a single clock domain, making it an efficient solution for data buffering and rate matching.

### Key Features

* **Single-Clock Domain:** Eliminates the need for complex clock domain crossing (CDC) circuitry.
  
**Active-Low Synchronous Reset:** Cleanly resets the internal read/write pointers and the data output register on the rising clock edge when `rst` is pulled low.



**Pointer-Based Status Flags:** Employs an extra bit in the pointer width (`add_width`) to distinguish between completely `full` and completely `empty` states seamlessly.



**Parametric Flexibility:** Easily scale the data width and FIFO capacity using `data_width` and `depth` parameters.



---

### Port Descriptions

* **clk** (Input, 1-bit): Master Clock signal. All operations occur on its rising edge.


* **rst** (Input, 1-bit): Active-Low Synchronous Reset. Clears pointers and output when pulled low (`0`).


* **wr_en** (Input, 1-bit): Write Enable. Drives data insertion into the FIFO memory when high.


* **rd_en** (Input, 1-bit): Read Enable. Drives data extraction from the FIFO memory when high.

 
**din** (Input, `[data_width-1:0]`): Parallel data input bus.

 
**dout** (Output, `[data_width-1:0]`): Registered parallel data output bus.


* **full** (Output, 1-bit): Status flag indicating the FIFO is full. Preventative logic ignores incoming writes.


* **empty** (Output, 1-bit): Status flag indicating the FIFO is empty. Preventative logic ignores incoming reads.



---

### Internal Architecture & Flag Logic

The FIFO utilizes a dual-port memory array (`mem`). The status flags are evaluated combinationally based on the status of the write pointer (`wr_ptr`) and read pointer (`rd_ptr`):
 
**Empty Condition:** Triggered when both pointers match exactly.


**Full Condition:** Triggered when the lower address bits match, but the MSB (Most Significant Bit) differs, indicating the write pointer has wrapped around the memory space once.


### Parameters


**data_width** (Default: `8`): The bit-width of each data word.



**depth** (Default: `16`): The maximum number of data words the memory array can hold.



**add_width** (Default: `4`): The actual address bus width needed to index the memory space ($2^{\text{add\_width}} = \text{depth}$).



---

### Implementation Notes

> ⚠️ **Design Notice:** The internal tracking logic increments pointers using blocking assignments (`=`) immediately following the memory write/read operations within the synchronous sequential blocks. Ensure your testbench simulation environments align with this timing behavior to avoid pre/post-synthesis mismatch edge cases.
> 
>
