#!/bin/bash

dump_start=$1
dump_len=$2

testbench=hardware/sources/testbench/cpu_test.v

if [ "$dump_len" = 0 ]
then
	echo "endmodule" >> $testbench
else
	echo "initial" >> $testbench
	echo "begin" >> $testbench
	echo "  \$dumpfile(\"waveform.vcd\");" >> $testbench
	echo "  \$dumpvars;" >> $testbench
	echo "  \$dumpoff;" >> $testbench
	echo "  # $dump_start \$dumpon;" >> $testbench
	echo "  # $dump_len \$dumpoff;" >> $testbench
	echo "end" >> $testbench
	echo "endmodule" >> $testbench
fi
