if {${::act} == "bhv_sim"} {
	set sim_mod behav
} else {
	set sim_mod time_synth
}

run all
