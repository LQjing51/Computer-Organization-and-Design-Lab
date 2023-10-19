# open shell checkpoint
open_checkpoint ${script_dir}/../shell/shell.dcp

# open role checkpoint
read_checkpoint -cell [get_cells mpsoc_i/accel_role_0/inst] ${dcp_dir}/${rpt_prefix}.dcp
read_checkpoint -cell [get_cells mpsoc_i/accel_role_1/inst] ${dcp_dir}/${rpt_prefix}.dcp
read_checkpoint -cell [get_cells mpsoc_i/accel_role_2/inst] ${dcp_dir}/${rpt_prefix}.dcp
read_checkpoint -cell [get_cells mpsoc_i/accel_role_3/inst] ${dcp_dir}/${rpt_prefix}.dcp

# setup output logs and reports
report_timing_summary -file ${synth_rpt_dir}/${rpt_prefix}_timing.rpt -delay_type max -max_paths 20

# Design optimization
opt_design

