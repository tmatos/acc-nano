# TCL File Generated by Component Editor 18.1
# Thu Aug 22 13:58:28 BRT 2019
# DO NOT MODIFY


# 
# atax_kernel "atax kernel by legup" v1.0
#  2019.08.22.13:58:28
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module atax_kernel
# 
set_module_property DESCRIPTION ""
set_module_property NAME atax_kernel
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "atax kernel by legup"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL legup_atax_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file legup_atax_top.v VERILOG PATH acelerador/atax/legup_atax_top.v TOP_LEVEL_FILE
add_fileset_file atax.v VERILOG PATH acelerador/atax/atax.v


# 
# parameters
# 
add_parameter BUS_SIZE INTEGER 64
set_parameter_property BUS_SIZE DEFAULT_VALUE 64
set_parameter_property BUS_SIZE DISPLAY_NAME BUS_SIZE
set_parameter_property BUS_SIZE TYPE INTEGER
set_parameter_property BUS_SIZE UNITS None
set_parameter_property BUS_SIZE HDL_PARAMETER true
add_parameter BUS_BYTES INTEGER 8
set_parameter_property BUS_BYTES DEFAULT_VALUE 8
set_parameter_property BUS_BYTES DISPLAY_NAME BUS_BYTES
set_parameter_property BUS_BYTES TYPE INTEGER
set_parameter_property BUS_BYTES UNITS None
set_parameter_property BUS_BYTES HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point start
# 
add_interface start conduit end
set_interface_property start associatedClock ""
set_interface_property start associatedReset ""
set_interface_property start ENABLED true
set_interface_property start EXPORT_OF ""
set_interface_property start PORT_NAME_MAP ""
set_interface_property start CMSIS_SVD_VARIABLES ""
set_interface_property start SVD_ADDRESS_GROUP ""

add_interface_port start coe_start_export export Input 1


# 
# connection point finish
# 
add_interface finish conduit end
set_interface_property finish associatedClock ""
set_interface_property finish associatedReset ""
set_interface_property finish ENABLED true
set_interface_property finish EXPORT_OF ""
set_interface_property finish PORT_NAME_MAP ""
set_interface_property finish CMSIS_SVD_VARIABLES ""
set_interface_property finish SVD_ADDRESS_GROUP ""

add_interface_port finish coe_finish_export export Output 1


# 
# connection point arg_a
# 
add_interface arg_a avalon start
set_interface_property arg_a addressUnits SYMBOLS
set_interface_property arg_a associatedClock clock
set_interface_property arg_a associatedReset reset
set_interface_property arg_a bitsPerSymbol 8
set_interface_property arg_a burstOnBurstBoundariesOnly false
set_interface_property arg_a burstcountUnits WORDS
set_interface_property arg_a doStreamReads false
set_interface_property arg_a doStreamWrites false
set_interface_property arg_a holdTime 0
set_interface_property arg_a linewrapBursts false
set_interface_property arg_a maximumPendingReadTransactions 0
set_interface_property arg_a maximumPendingWriteTransactions 0
set_interface_property arg_a readLatency 0
set_interface_property arg_a readWaitTime 1
set_interface_property arg_a setupTime 0
set_interface_property arg_a timingUnits Cycles
set_interface_property arg_a writeWaitTime 0
set_interface_property arg_a ENABLED true
set_interface_property arg_a EXPORT_OF ""
set_interface_property arg_a PORT_NAME_MAP ""
set_interface_property arg_a CMSIS_SVD_VARIABLES ""
set_interface_property arg_a SVD_ADDRESS_GROUP ""

add_interface_port arg_a avm_arg_A_read read Output 1
add_interface_port arg_a avm_arg_A_write write Output 1
add_interface_port arg_a avm_arg_A_address address Output 13
add_interface_port arg_a avm_arg_A_readdata readdata Input BUS_SIZE
add_interface_port arg_a avm_arg_A_writedata writedata Output BUS_SIZE
add_interface_port arg_a avm_arg_A_waitrequest waitrequest Input 1
add_interface_port arg_a avm_arg_A_byteenable byteenable Output BUS_BYTES


# 
# connection point arg_x
# 
add_interface arg_x avalon start
set_interface_property arg_x addressUnits SYMBOLS
set_interface_property arg_x associatedClock clock
set_interface_property arg_x associatedReset reset
set_interface_property arg_x bitsPerSymbol 8
set_interface_property arg_x burstOnBurstBoundariesOnly false
set_interface_property arg_x burstcountUnits WORDS
set_interface_property arg_x doStreamReads false
set_interface_property arg_x doStreamWrites false
set_interface_property arg_x holdTime 0
set_interface_property arg_x linewrapBursts false
set_interface_property arg_x maximumPendingReadTransactions 0
set_interface_property arg_x maximumPendingWriteTransactions 0
set_interface_property arg_x readLatency 0
set_interface_property arg_x readWaitTime 1
set_interface_property arg_x setupTime 0
set_interface_property arg_x timingUnits Cycles
set_interface_property arg_x writeWaitTime 0
set_interface_property arg_x ENABLED true
set_interface_property arg_x EXPORT_OF ""
set_interface_property arg_x PORT_NAME_MAP ""
set_interface_property arg_x CMSIS_SVD_VARIABLES ""
set_interface_property arg_x SVD_ADDRESS_GROUP ""

add_interface_port arg_x avm_arg_x_read read Output 1
add_interface_port arg_x avm_arg_x_write write Output 1
add_interface_port arg_x avm_arg_x_address address Output 8
add_interface_port arg_x avm_arg_x_readdata readdata Input BUS_SIZE
add_interface_port arg_x avm_arg_x_writedata writedata Output BUS_SIZE
add_interface_port arg_x avm_arg_x_waitrequest waitrequest Input 1
add_interface_port arg_x avm_arg_x_byteenable byteenable Output BUS_BYTES


# 
# connection point arg_y
# 
add_interface arg_y avalon start
set_interface_property arg_y addressUnits SYMBOLS
set_interface_property arg_y associatedClock clock
set_interface_property arg_y associatedReset reset
set_interface_property arg_y bitsPerSymbol 8
set_interface_property arg_y burstOnBurstBoundariesOnly false
set_interface_property arg_y burstcountUnits WORDS
set_interface_property arg_y doStreamReads false
set_interface_property arg_y doStreamWrites false
set_interface_property arg_y holdTime 0
set_interface_property arg_y linewrapBursts false
set_interface_property arg_y maximumPendingReadTransactions 0
set_interface_property arg_y maximumPendingWriteTransactions 0
set_interface_property arg_y readLatency 0
set_interface_property arg_y readWaitTime 1
set_interface_property arg_y setupTime 0
set_interface_property arg_y timingUnits Cycles
set_interface_property arg_y writeWaitTime 0
set_interface_property arg_y ENABLED true
set_interface_property arg_y EXPORT_OF ""
set_interface_property arg_y PORT_NAME_MAP ""
set_interface_property arg_y CMSIS_SVD_VARIABLES ""
set_interface_property arg_y SVD_ADDRESS_GROUP ""

add_interface_port arg_y avm_arg_y_read read Output 1
add_interface_port arg_y avm_arg_y_write write Output 1
add_interface_port arg_y avm_arg_y_address address Output 8
add_interface_port arg_y avm_arg_y_readdata readdata Input BUS_SIZE
add_interface_port arg_y avm_arg_y_writedata writedata Output BUS_SIZE
add_interface_port arg_y avm_arg_y_waitrequest waitrequest Input 1
add_interface_port arg_y avm_arg_y_byteenable byteenable Output BUS_BYTES

