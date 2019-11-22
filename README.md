# MIPS_pipeline
Implementação do MIPS pipeline para a disciplina PCS3612 – Organização e Arquitetura de Computadores I

# Build
Criar uma pasta para o build e executar o cmake.
```shell
$ pwd
{XXX}/MIPS_pipeline
$ mkdir build && cd build
$ cmake ..
```
Indexar e realizar os testes:
```shell
$ pwd
{XXX}/MIPS_pipeline/build
$ make index # aqui pode ser somente make
Scanning dependencies of target index
Built target index
$ make check
Scanning dependencies of target test.mips_single.top_tb_cp_dat_files
Built target test.mips_single.top_tb_cp_dat_files
Built target index
Scanning dependencies of target test.mips_single.top_tb_cp_mif_files
Built target test.mips_single.top_tb_cp_mif_files
Scanning dependencies of target test.mips_single.top_tb
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/test/mips_single/top_tb.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/top.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/mips.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/memories/imem.vhd
/home/joao/Code/usp/Arq_I/MIPS_pipeline/src/memories/imem.vhd:36:9:warning: declaration of "i" hides variable "i" [-Whide]
/home/joao/Code/usp/Arq_I/MIPS_pipeline/src/memories/imem.vhd:44:11:warning: declaration of "i" hides variable "i" [-Whide]
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/memories/dmem.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/control_dp/controller.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/control_dp/datapath.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/control_dp/maindec.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/control_dp/aludec.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/components/flopr.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/components/adder.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/components/sl2.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/components/mux2.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/components/regfile.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/components/signext.vhd
analyze /home/joao/Code/usp/Arq_I/MIPS_pipeline/src/components/alu.vhd
elaborate top_tb
Built target test.mips_single.top_tb
Scanning dependencies of target check
Test project /home/joao/Code/usp/Arq_I/MIPS_pipeline/build
    Start 1: test.mips_single.top_tb
1/1 Test #1: test.mips_single.top_tb ..........   Passed    0.00 sec

100% tests passed, 0 tests failed out of 1

Total Test time (real) =   0.00 sec
Built target check
```
