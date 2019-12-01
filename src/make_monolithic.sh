#!/bin/bash
OUTPUT_DIR=monolithic
OUTPUT_FILE=${OUTPUT_DIR}/mips_pipeline.vhd

mkdir ${OUTPUT_DIR} &> /dev/null || true

if [ -f ${OUTPUT_FILE} ]; then
	rm ${OUTPUT_FILE}
fi

cat components/*.vhd >> ${OUTPUT_FILE}
cat memories/*.vhd >> ${OUTPUT_FILE}
cat control_dp/*.vhd >> ${OUTPUT_FILE}
cat pipeline/*.vhd >> ${OUTPUT_FILE}
cat mips.vhd >> ${OUTPUT_FILE}
cat top.vhd >> ${OUTPUT_FILE}
cat ../test/*.vhd >> ${OUTPUT_FILE}

cp ../test/binaries/*.dat ${OUTPUT_DIR}
cp ghdl_run_tests.sh ${OUTPUT_DIR}
chmod +x ${OUTPUT_DIR}/ghdl_run_tests.sh
