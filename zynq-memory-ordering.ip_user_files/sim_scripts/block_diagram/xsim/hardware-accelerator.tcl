

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "hardware-accelerator" "NUM_INSTANCES" "DEVICE_ID"  "C_registers_BASEADDR" "C_registers_HIGHADDR"
}
