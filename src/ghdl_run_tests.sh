#!/bin/bash

for tb in ../../test/*.vhd
do
	tb_entity=$(echo $tb | xargs -I{} basename {} | cut -d '.' -f 1)
	ghdl -a --std=08 --ieee=synopsys mips_pipeline.vhd
	ghdl -e --std=08 --ieee=synopsys $tb_entity
	ghdl -r --std=08 --ieee=synopsys $tb_entity
done
