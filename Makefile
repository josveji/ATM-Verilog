tarea: testbench.v 	ATM.ys resultados_ATM_ordenados.gtkw
	yosys -s ATM.ys
	iverilog testbench.v
	vvp a.out
	gtkwave resultados_ATM_ordenados.gtkw

