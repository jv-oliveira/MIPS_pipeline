#!/bin/bash
OUTPUT_FILE=mips_monolitic.vhd

if [ -f ${OUTPUT_FILE} ]; then
	rm ${OUTPUT_FILE}
fi

cat components/*vhd >> ${OUTPUT_FILE}
cat control_dp/*vhd >> ${OUTPUT_FILE}
cat mips.vhd >> ${OUTPUT_FILE}
cat top.vhd >> ${OUTPUT_FILE}


