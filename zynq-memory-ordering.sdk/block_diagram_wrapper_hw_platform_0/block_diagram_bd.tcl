
################################################################
# This is a generated script based on design: block_diagram
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source block_diagram_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name block_diagram

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: acquire_global_ready
proc create_hier_cell_acquire_global_ready { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_acquire_global_ready() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 1 -to 0 all_enables
  create_bd_pin -dir I -from 0 -to 0 all_ha_readies
  create_bd_pin -dir O global_ready

  # Create instance: and_global_enable_and_negated_result, and set properties
  set and_global_enable_and_negated_result [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 and_global_enable_and_negated_result ]
  set_property -dict [ list \
CONFIG.C_SIZE {2} \
 ] $and_global_enable_and_negated_result

  # Create instance: concat_global_enable_and_negated_result, and set properties
  set concat_global_enable_and_negated_result [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_global_enable_and_negated_result ]

  # Create instance: get_all_ha_enables, and set properties
  set get_all_ha_enables [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 get_all_ha_enables ]
  set_property -dict [ list \
CONFIG.DIN_FROM {1} \
CONFIG.DIN_TO {1} \
CONFIG.DIN_WIDTH {2} \
 ] $get_all_ha_enables

  # Create instance: get_global_enable, and set properties
  set get_global_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 get_global_enable ]
  set_property -dict [ list \
CONFIG.DIN_FROM {0} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {2} \
 ] $get_global_enable

  # Create instance: negate_result, and set properties
  set negate_result [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 negate_result ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $negate_result

  # Create instance: xor_enables_with_readies, and set properties
  set xor_enables_with_readies [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 xor_enables_with_readies ]
  set_property -dict [ list \
CONFIG.C_OPERATION {xor} \
CONFIG.C_SIZE {1} \
 ] $xor_enables_with_readies

  # Create port connections
  connect_bd_net -net and_global_enable_and_negated_result_Res [get_bd_pins global_ready] [get_bd_pins and_global_enable_and_negated_result/Res]
  connect_bd_net -net processing_system7_0_GPIO_O [get_bd_pins all_enables] [get_bd_pins get_all_ha_enables/Din] [get_bd_pins get_global_enable/Din]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins negate_result/Op1] [get_bd_pins xor_enables_with_readies/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins concat_global_enable_and_negated_result/In1] [get_bd_pins negate_result/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins all_ha_readies] [get_bd_pins xor_enables_with_readies/Op2]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins and_global_enable_and_negated_result/Op1] [get_bd_pins concat_global_enable_and_negated_result/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins concat_global_enable_and_negated_result/In0] [get_bd_pins get_global_enable/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins get_all_ha_enables/Dout] [get_bd_pins xor_enables_with_readies/Op1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: acquire_combined_ha_enable
proc create_hier_cell_acquire_combined_ha_enable { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_acquire_combined_ha_enable() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 1 -to 0 all_enables
  create_bd_pin -dir O combined_ha_enable

  # Create instance: and_global_enable_and_ha_enable, and set properties
  set and_global_enable_and_ha_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_reduced_logic:2.0 and_global_enable_and_ha_enable ]
  set_property -dict [ list \
CONFIG.C_SIZE {2} \
 ] $and_global_enable_and_ha_enable

  # Create instance: concat_global_enable_and_ha_enable, and set properties
  set concat_global_enable_and_ha_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_global_enable_and_ha_enable ]

  # Create instance: get_global_enable, and set properties
  set get_global_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 get_global_enable ]
  set_property -dict [ list \
CONFIG.DIN_FROM {0} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {2} \
 ] $get_global_enable

  # Create instance: get_ha_enable, and set properties
  set get_ha_enable [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 get_ha_enable ]
  set_property -dict [ list \
CONFIG.DIN_FROM {1} \
CONFIG.DIN_TO {1} \
CONFIG.DIN_WIDTH {2} \
CONFIG.DOUT_WIDTH {1} \
 ] $get_ha_enable

  # Create port connections
  connect_bd_net -net processing_system7_0_GPIO_O [get_bd_pins all_enables] [get_bd_pins get_global_enable/Din] [get_bd_pins get_ha_enable/Din]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins combined_ha_enable] [get_bd_pins and_global_enable_and_ha_enable/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins and_global_enable_and_ha_enable/Op1] [get_bd_pins concat_global_enable_and_ha_enable/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins concat_global_enable_and_ha_enable/In0] [get_bd_pins get_global_enable/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins concat_global_enable_and_ha_enable/In1] [get_bd_pins get_ha_enable/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports

  # Create instance: acquire_combined_ha_enable
  create_hier_cell_acquire_combined_ha_enable [current_bd_instance .] acquire_combined_ha_enable

  # Create instance: acquire_global_ready
  create_hier_cell_acquire_global_ready [current_bd_instance .] acquire_global_ready

  # Create instance: all_readies, and set properties
  set all_readies [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 all_readies ]

  # Create instance: axi4_metrics_counter_0, and set properties
  set axi4_metrics_counter_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:axi4_metrics_counter:1.0 axi4_metrics_counter_0 ]
  set_property -dict [ list \
CONFIG.C_axi4_monitor_DATA_WIDTH {64} \
 ] $axi4_metrics_counter_0

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $axi_interconnect_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]

  # Create instance: concat_all_ha_readies, and set properties
  set concat_all_ha_readies [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_all_ha_readies ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {1} \
 ] $concat_all_ha_readies

  # Create instance: hardware_accelerator_0, and set properties
  set hardware_accelerator_0 [ create_bd_cell -type ip -vlnv user.org:user:hardware_accelerator:1.0 hardware_accelerator_0 ]
  set_property -dict [ list \
CONFIG.C_data_ARUSER_WIDTH {1} \
CONFIG.C_data_AWUSER_WIDTH {1} \
CONFIG.C_data_BUSER_WIDTH {1} \
CONFIG.C_data_DATA_WIDTH {64} \
CONFIG.C_data_RUSER_WIDTH {1} \
CONFIG.C_data_WUSER_WIDTH {1} \
 ] $hardware_accelerator_0

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.0 ila_0 ]
  set_property -dict [ list \
CONFIG.C_DATA_DEPTH {4096} \
 ] $ila_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {2} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_TTC0_IO {MIO 18 .. 19} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_ACP {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_ACP]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins hardware_accelerator_0/registers]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_pins axi4_metrics_counter_0/s_axi_lite] [get_bd_intf_pins axi_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net hardware_accelerator_0_data [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins hardware_accelerator_0/data]
connect_bd_intf_net -intf_net [get_bd_intf_nets hardware_accelerator_0_data] [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins ila_0/SLOT_0_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets hardware_accelerator_0_data] [get_bd_intf_pins axi4_metrics_counter_0/axi4_monitor] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net hardware_accelerator_0_ready [get_bd_pins all_readies/In1] [get_bd_pins axi4_metrics_counter_0/counter_finish] [get_bd_pins concat_all_ha_readies/In0] [get_bd_pins hardware_accelerator_0/ready]
  connect_bd_net -net hier_1_Res [get_bd_pins acquire_global_ready/global_ready] [get_bd_pins all_readies/In0]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins axi4_metrics_counter_0/aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins hardware_accelerator_0/aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi4_metrics_counter_0/aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/M01_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins hardware_accelerator_0/aclk] [get_bd_pins ila_0/clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_ACP_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net processing_system7_0_GPIO_O [get_bd_pins acquire_combined_ha_enable/all_enables] [get_bd_pins acquire_global_ready/all_enables] [get_bd_pins processing_system7_0/GPIO_O]
  connect_bd_net -net util_reduced_logic_0_Res [get_bd_pins acquire_combined_ha_enable/combined_ha_enable] [get_bd_pins axi4_metrics_counter_0/counter_start] [get_bd_pins hardware_accelerator_0/enable]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins acquire_global_ready/all_ha_readies] [get_bd_pins concat_all_ha_readies/dout]
  connect_bd_net -net xlconcat_0_dout1 [get_bd_pins all_readies/dout] [get_bd_pins processing_system7_0/IRQ_F2P]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces hardware_accelerator_0/data] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_DDR_LOWOCM] SEG_processing_system7_0_ACP_DDR_LOWOCM
  create_bd_addr_seg -range 0x400000 -offset 0xE0000000 [get_bd_addr_spaces hardware_accelerator_0/data] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_IOP] SEG_processing_system7_0_ACP_IOP
  create_bd_addr_seg -range 0x40000000 -offset 0x40000000 [get_bd_addr_spaces hardware_accelerator_0/data] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_M_AXI_GP0] SEG_processing_system7_0_ACP_M_AXI_GP0
  create_bd_addr_seg -range 0x1000000 -offset 0xFC000000 [get_bd_addr_spaces hardware_accelerator_0/data] [get_bd_addr_segs processing_system7_0/S_AXI_ACP/ACP_QSPI_LINEAR] SEG_processing_system7_0_ACP_QSPI_LINEAR
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi4_metrics_counter_0/s_axi_lite/s_axi_lite_reg] SEG_axi4_metrics_counter_0_s_axi_lite_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs hardware_accelerator_0/registers/registers_reg] SEG_hardware_accelerator_0_registers_reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 310 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 330 -defaultsOSRD
preplace inst axi4_metrics_counter_0 -pg 1 -lvl 4 -y 330 -defaultsOSRD
preplace inst acquire_combined_ha_enable -pg 1 -lvl 2 -y 380 -defaultsOSRD -resize 291 88
preplace inst proc_sys_reset_0 -pg 1 -lvl 1 -y 200 -defaultsOSRD
preplace inst hardware_accelerator_0 -pg 1 -lvl 3 -y 270 -defaultsOSRD
preplace inst ila_0 -pg 1 -lvl 4 -y -120 -defaultsOSRD
preplace inst acquire_global_ready -pg 1 -lvl 3 -y 530 -defaultsOSRD
preplace inst all_readies -pg 1 -lvl 4 -y 520 -defaultsOSRD
preplace inst axi_interconnect_0 -pg 1 -lvl 4 -y 110 -defaultsOSRD
preplace inst concat_all_ha_readies -pg 1 -lvl 2 -y 520 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 2 -y 170 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -y 310 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 5 1 NJ
preplace netloc hardware_accelerator_0_ready 1 1 3 370 590 NJ 590 1040
preplace netloc axi_interconnect_1_M01_AXI 1 2 2 NJ 180 1050
preplace netloc processing_system7_0_GPIO_O 1 1 5 370 440 760 440 NJ 440 NJ 440 1800
preplace netloc processing_system7_0_M_AXI_GP0 1 1 5 380 30 NJ 30 NJ 230 NJ 200 1780
preplace netloc hier_1_Res 1 3 1 1030
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 6 20 450 NJ 450 NJ 450 NJ 450 NJ 450 1790
preplace netloc proc_sys_reset_0_interconnect_aresetn 1 1 3 380 310 NJ 90 NJ
preplace netloc xlconcat_0_dout 1 2 1 NJ
preplace netloc processing_system7_0_FIXED_IO 1 5 1 NJ
preplace netloc util_reduced_logic_0_Res 1 2 2 770 360 NJ
preplace netloc axi_interconnect_0_M00_AXI 1 4 1 1400
preplace netloc proc_sys_reset_0_peripheral_aresetn 1 1 3 370 10 740 130 1060
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 10 290 360 20 770 20 1070 430 1390 420 1780
preplace netloc axi_interconnect_1_M00_AXI 1 2 1 760
preplace netloc hardware_accelerator_0_data 1 3 1 1090
preplace netloc xlconcat_0_dout1 1 4 1 1400
levelinfo -pg 1 -10 190 570 900 1240 1590 1840 -top -590 -bot 600
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


