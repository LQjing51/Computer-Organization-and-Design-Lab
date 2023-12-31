# parsing argument
if {$argc != 2} {
	puts "The argument should be hw_act"
} else {
	set act [lindex $argv 0]
	set val [lindex $argv 1]
}

set project_name prj_0
	
# setting parameters
set script_dir [file dirname [info script]]

set impl_rpt_dir ${script_dir}/../vivado_out/impl_rpt
set sim_out_dir ${script_dir}/../vivado_out/sim

if {$act == "bit_gen"} {
	# load webtalk log
	#exec cp ./usage_statistics_webtalk.xml ${impl_rpt_dir} 

} elseif {$act == "bhv_sim"} {
	set sim_mod adder

	exec cp ./${project_name}/${project_name}.sim/sim_1/behav/xsim/${sim_mod}_test_behav.wdb \
		${sim_out_dir}/${sim_mod}.wdb

	exec cp ./${project_name}/${project_name}.sim/sim_1/behav/xsim/simulate.log \
		${sim_out_dir}/${sim_mod}.log

} elseif {$act == "wav_chk"} {
	set sim_mod adder
	exec cp ${sim_out_dir}/${sim_mod}.wcfg ${script_dir}/sim/${sim_mod}.wcfg 

} else {
	puts "Error: No specified actions for Vivado hardware project"
	exit
}
