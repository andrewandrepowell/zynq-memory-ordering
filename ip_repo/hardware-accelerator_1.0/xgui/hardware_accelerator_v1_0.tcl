# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "C_data_ID_WIDTH"
  ipgui::add_param $IPINST -name "C_data_ID"
  ipgui::add_param $IPINST -name "C_data_DATA_WIDTH" -widget comboBox
  ipgui::add_param $IPINST -name "C_data_AWUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_data_ARUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_data_WUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_data_RUSER_WIDTH"
  ipgui::add_param $IPINST -name "C_data_BUSER_WIDTH"

}

proc update_PARAM_VALUE.BUFFER_SIZE { PARAM_VALUE.BUFFER_SIZE } {
	# Procedure called to update BUFFER_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUFFER_SIZE { PARAM_VALUE.BUFFER_SIZE } {
	# Procedure called to validate BUFFER_SIZE
	return true
}

proc update_PARAM_VALUE.C_data_ID { PARAM_VALUE.C_data_ID } {
	# Procedure called to update C_data_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_data_ID { PARAM_VALUE.C_data_ID } {
	# Procedure called to validate C_data_ID
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

proc update_MODELPARAM_VALUE.C_data_ID { MODELPARAM_VALUE.C_data_ID PARAM_VALUE.C_data_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_data_ID}] ${MODELPARAM_VALUE.C_data_ID}
}

proc update_MODELPARAM_VALUE.BUFFER_SIZE { MODELPARAM_VALUE.BUFFER_SIZE PARAM_VALUE.BUFFER_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUFFER_SIZE}] ${MODELPARAM_VALUE.BUFFER_SIZE}
}

