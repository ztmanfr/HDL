quartus_sh -t compile.tcl
quartus_pgm --mode=JTAG -o P;output_files\blink.sof@2
pause