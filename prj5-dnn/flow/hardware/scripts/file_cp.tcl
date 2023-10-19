# parsing argument
if {$argc != 1} {
	puts "Error: The argument should be hw_act"
	exit
} else {
	set act [lindex $argv 0]
}

set project_name prj_5
	
# setting parameters
set script_dir [file dirname [info script]]

set impl_rpt_dir ${script_dir}/../vivado_out/impl_rpt
set sim_out_dir ${script_dir}/../vivado_out/sim

if {$act == "bit_gen"} {
	# load webtalk log
	# exec cp ./usage_statistics_webtalk.xml ${impl_rpt_dir} 

} elseif {$act == "bhv_sim"} {
	if { [file exists ./${project_name}/${project_name}.sim/sim_1/behav/xsim/waveform.vcd] == 1 } {
		exec cp ./${project_name}/${project_name}.sim/sim_1/behav/xsim/waveform.vcd \
		    ${sim_out_dir}/waveform.vcd
	}

} elseif {$act == "wav_chk"} {
	exec cp ${sim_out_dir}/behav.wcfg ${script_dir}/../../../waveform/behav.wcfg

} else {
	puts "Error: No specified actions for Vivado hardware project"
	exit
}
