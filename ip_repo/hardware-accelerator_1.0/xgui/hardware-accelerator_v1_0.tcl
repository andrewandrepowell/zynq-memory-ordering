# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"

}

proc update_PARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to update C_data_TARGET_SLAVE_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to validate C_data_TARGET_SLAVE_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.C_data_BURST_LEN { PARAM_VALUE.C_data_BURST_LEN } {
	# Procedure called to update C_data_BURST_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_BURST_LEN { PARAM_VALUE.C_data_BURST_LEN } {
	# Procedure called to validate C_data_BURST_LEN
	return true
}

proc update_PARAM_VALUE.C_data_ID_WIDTH { PARAM_VALUE.C_data_ID_WIDTH } {
	# Procedure called to update C_data_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_ID_WIDTH { PARAM_VALUE.C_data_ID_WIDTH } {
	# Procedure called to validate C_data_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_ADDR_WIDTH { PARAM_VALUE.C_data_ADDR_WIDTH } {
	# Procedure called to update C_data_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_ADDR_WIDTH { PARAM_VALUE.C_data_ADDR_WIDTH } {
	# Procedure called to validate C_data_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_DATA_WIDTH { PARAM_VALUE.C_data_DATA_WIDTH } {
	# Procedure called to update C_data_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_DATA_WIDTH { PARAM_VALUE.C_data_DATA_WIDTH } {
	# Procedure called to validate C_data_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_AWUSER_WIDTH { PARAM_VALUE.C_data_AWUSER_WIDTH } {
	# Procedure called to update C_data_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_AWUSER_WIDTH { PARAM_VALUE.C_data_AWUSER_WIDTH } {
	# Procedure called to validate C_data_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_ARUSER_WIDTH { PARAM_VALUE.C_data_ARUSER_WIDTH } {
	# Procedure called to update C_data_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_ARUSER_WIDTH { PARAM_VALUE.C_data_ARUSER_WIDTH } {
	# Procedure called to validate C_data_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_WUSER_WIDTH { PARAM_VALUE.C_data_WUSER_WIDTH } {
	# Procedure called to update C_data_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_WUSER_WIDTH { PARAM_VALUE.C_data_WUSER_WIDTH } {
	# Procedure called to validate C_data_WUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_RUSER_WIDTH { PARAM_VALUE.C_data_RUSER_WIDTH } {
	# Procedure called to update C_data_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_RUSER_WIDTH { PARAM_VALUE.C_data_RUSER_WIDTH } {
	# Procedure called to validate C_data_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_data_BUSER_WIDTH { PARAM_VALUE.C_data_BUSER_WIDTH } {
	# Procedure called to update C_data_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_BUSER_WIDTH { PARAM_VALUE.C_data_BUSER_WIDTH } {
	# Procedure called to validate C_data_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_registers_DATA_WIDTH { PARAM_VALUE.C_registers_DATA_WIDTH } {
	# Procedure called to update C_registers_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_registers_DATA_WIDTH { PARAM_VALUE.C_registers_DATA_WIDTH } {
	# Procedure called to validate C_registers_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_registers_ADDR_WIDTH { PARAM_VALUE.C_registers_ADDR_WIDTH } {
	# Procedure called to update C_registers_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_registers_ADDR_WIDTH { PARAM_VALUE.C_registers_ADDR_WIDTH } {
	# Procedure called to validate C_registers_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_registers_BASEADDR { PARAM_VALUE.C_registers_BASEADDR } {
	# Procedure called to update C_registers_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_registers_BASEADDR { PARAM_VALUE.C_registers_BASEADDR } {
	# Procedure called to validate C_registers_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_registers_HIGHADDR { PARAM_VALUE.C_registers_HIGHADDR } {
	# Procedure called to update C_registers_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_registers_HIGHADDR { PARAM_VALUE.C_registers_HIGHADDR } {
	# Procedure called to validate C_registers_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR { MODELPARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR PARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR}] ${MODELPARAM_VALUE.C_data_TARGET_SLAVE_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.C_data_BURST_LEN { MODELPARAM_VALUE.C_data_BURST_LEN PARAM_VALUE.C_data_BURST_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_BURST_LEN}] ${MODELPARAM_VALUE.C_data_BURST_LEN}
}

proc update_MODELPARAM_VALUE.C_data_ID_WIDTH { MODELPARAM_VALUE.C_data_ID_WIDTH PARAM_VALUE.C_data_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_ID_WIDTH}] ${MODELPARAM_VALUE.C_data_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_ADDR_WIDTH { MODELPARAM_VALUE.C_data_ADDR_WIDTH PARAM_VALUE.C_data_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_data_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_DATA_WIDTH { MODELPARAM_VALUE.C_data_DATA_WIDTH PARAM_VALUE.C_data_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_DATA_WIDTH}] ${MODELPARAM_VALUE.C_data_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_AWUSER_WIDTH { MODELPARAM_VALUE.C_data_AWUSER_WIDTH PARAM_VALUE.C_data_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_AWUSER_WIDTH}] ${MODELPARAM_VALUE.C_data_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_ARUSER_WIDTH { MODELPARAM_VALUE.C_data_ARUSER_WIDTH PARAM_VALUE.C_data_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_ARUSER_WIDTH}] ${MODELPARAM_VALUE.C_data_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_WUSER_WIDTH { MODELPARAM_VALUE.C_data_WUSER_WIDTH PARAM_VALUE.C_data_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_WUSER_WIDTH}] ${MODELPARAM_VALUE.C_data_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_RUSER_WIDTH { MODELPARAM_VALUE.C_data_RUSER_WIDTH PARAM_VALUE.C_data_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_RUSER_WIDTH}] ${MODELPARAM_VALUE.C_data_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_data_BUSER_WIDTH { MODELPARAM_VALUE.C_data_BUSER_WIDTH PARAM_VALUE.C_data_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_BUSER_WIDTH}] ${MODELPARAM_VALUE.C_data_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.C_registers_DATA_WIDTH { MODELPARAM_VALUE.C_registers_DATA_WIDTH PARAM_VALUE.C_registers_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_registers_DATA_WIDTH}] ${MODELPARAM_VALUE.C_registers_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_registers_ADDR_WIDTH { MODELPARAM_VALUE.C_registers_ADDR_WIDTH PARAM_VALUE.C_registers_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_registers_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_registers_ADDR_WIDTH}
}

