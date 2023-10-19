# setting Synthesis options
set synth_directive default
# keep module port names in the netlist
set synth_flatten none
		
# synthesizing alu design
synth_design -top ${top_module} -part ${device} -mode out_of_context \
    -directive ${synth_directive} -flatten_hierarchy ${synth_flatten}

# report potential combinatinal loops
check_timing -verbose

# setup output logs and reports
report_utilization -hierarchical -file ${synth_rpt_dir}/${rpt_prefix}_util_hier.rpt
report_utilization -file ${synth_rpt_dir}/${rpt_prefix}_util.rpt

write_checkpoint -force ${dcp_dir}/${rpt_prefix}.dcp

