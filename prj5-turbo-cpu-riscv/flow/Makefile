# TODO: Change to your Vivado IDE version and installed location
VIVADO_VERSION ?= 2019.1
VIVADO_TOOL_BASE ?= /opt/Xilinx_$(VIVADO_VERSION)

# TODO: Change to your own location of RISC-V cross compiler
RV_TOOLS_PATH := /opt/riscv32-none/bin

# Vivado and SDK tool executable binary location
VIVADO_TOOL_PATH := $(VIVADO_TOOL_BASE)/Vivado/$(VIVADO_VERSION)/bin
SDK_TOOL_PATH := $(VIVADO_TOOL_BASE)/SDK/$(VIVADO_VERSION)/bin

# Leveraged Vivado tools
VIVADO_BIN := $(VIVADO_TOOL_PATH)/vivado
HSI_BIN := $(SDK_TOOL_PATH)/hsi
BOOT_GEN_BIN := $(SDK_TOOL_PATH)/bootgen

# Temporal directory to hold hardware design output files 
# (i.e., bitstream, hardware definition file (HDF))
HW_PLATFORM := $(shell pwd)/hw_plat
BITSTREAM := $(HW_PLATFORM)/system.bit
HW_DESIGN_HDF := $(HW_PLATFORM)/system.hdf

# Default Vivado GUI launching flags if not specified in command line
HW_ACT ?= none
HW_VAL ?= none

ifeq ($(findstring $(HW_ACT), "none bhv_sim pst_sim"), )
BENCH ?= basic:01
else
ifeq ($(HW_VAL),none)
BENCH ?= basic:01
else
BENCH ?= $(HW_VAL)
endif
endif

BENCH_SUITE := $(shell echo $(BENCH) | awk -F ":" '{print $$1}')
ifeq ($(findstring $(BENCH_SUITE), "basic medium advanced hello microbench"), )
$(error Please carefully specify name of benchmark suite among basic, medium and advaced)
endif

BENCH_NUM := $(shell echo $(BENCH) | awk -F ":" '{print $$2}')
BENCH_NAME := $(shell cat $(shell pwd)/benchmark/$(BENCH_SUITE)/list | grep "\#$(BENCH_NUM)" | awk -F "," '{print $$2}')

ifeq (${BENCH_NUM}, )
BENCH_NUM := all
endif

ifeq ($(findstring $(HW_ACT), "bhv_sim pst_sim"), )
HW_VAL_USE := $(HW_VAL)
else
ifeq (${BENCH_NAME}, )
$(error Please carefully specify the serial number of benchmark)
endif
HW_VAL_USE := $(BENCH_SUITE) $(BENCH_NAME)
endif

DUMP_TIME ?= 0 0

# FPGA Evaluation
FPGA_RUN := $(shell pwd)/run/fpga_run.sh 

CI_RUN ?= n

USER ?= none

BOARD_IP ?= none

RUN_LOG=$(BENCH_SUITE)_bench

HW_DBG ?= n

.PHONY: FORCE

#==========================================
# Compilation of RISC-V CPU benchmark
#==========================================

hello: FORCE
	@echo "Compiling RISC-V CPU hello benchmark..."
	@cp -r ../benchmark/include/ ./benchmark/
	@cp -r ../benchmark/common/ ./benchmark/
	@cp -r ../benchmark/hello/ ./benchmark/
	$(MAKE) -C ./benchmark RV_TOOLS_PATH=$(RV_TOOLS_PATH) $@

hello_clean: FORCE
	$(MAKE) -C ./benchmark $@

microbench: FORCE
	@echo "Compiling RISC-V CPU microbench benchmark..."
	@cp -r ../benchmark/include/ ./benchmark/
	@cp -r ../benchmark/common/ ./benchmark/
	@cp -r ../benchmark/microbench/ ./benchmark/
	$(MAKE) -C ./benchmark RV_TOOLS_PATH=$(RV_TOOLS_PATH) $@

microbench_clean: FORCE
	$(MAKE) -C ./benchmark $@

#==========================================
# Hardware Design
#==========================================
vivado_prj: FORCE
	@echo "Executing $(HW_ACT) for Vivado project..."
	@mkdir -p $(HW_PLATFORM)
	@bash ./run/testbench_gen.sh $(DUMP_TIME)
ifneq ($(CI_RUN),y)
	@-git checkout -- run/log
	$(MAKE) -C ./hardware VIVADO=$(VIVADO_BIN) HW_ACT=$(HW_ACT) HW_VAL="$(HW_VAL_USE)" O=$(HW_PLATFORM) $@
	@-git add --all && git commit -m "autocmt: $@ HW_ACT=$(HW_ACT) HW_VAL=\"$(HW_VAL)\""
else
	$(MAKE) -C ./hardware VIVADO=$(VIVADO_BIN) HW_ACT=$(HW_ACT) HW_VAL="$(HW_VAL_USE)" O=$(HW_PLATFORM) $@
endif

bit_bin:
	@echo "Generating .bit.bin file for system.bit..."
	$(MAKE) -C ./hardware BOOT_GEN=$(BOOT_GEN_BIN) O=$(HW_PLATFORM) $@

#==========================================
# Cloud environment usage
#==========================================
ROLE ?= 0
local_run:
	@mkdir -p ./run/log
	@cd ./run && LOG_LEVEL=$(LOG_LEVEL) bash ci_run.sh $(ROLE) $(BENCH_SUITE) \
				| tee ./log/$(RUN_LOG).log

