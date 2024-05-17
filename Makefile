tarea: testbench.v 	APAC.ys ondas_tarea1.gtkw
	yosys -s APAC.ys
	iverilog testbench.v
	vvp a.out
	gtkwave ondas_tarea1.gtkw

