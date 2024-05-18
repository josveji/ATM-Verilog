/* 
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código encargado de evaluar las pruebas de
"tester.v" en "ATM_controller.v". 
*/

`include "tester.v" // Incluyendo archivo de pruebas
//`include "ATM_controller.v" // Incluyendo máquina de estados
`include "ATM_rtlil.v" // Version RTLIL
//`include "ATM_synth.v" // Version synthesis
//`include "cmos_cells.v"


// Decclaración del módulo 

module ATM_tb;
    //Entradas
    wire clk, rst, tarjeta_recibida, tipo_trans, digito_stb, monto_stb; // Entradas
    wire [3:0] digito; 
    wire [31:0] monto;

    // Salidas
    wire balance_actualizado, entregar_dinero, pin_incorrecto; 
    wire advertencia, bloqueo, fondos_insuficientes;

    initial begin 
        $dumpfile("resultados_ATM.vcd"); // Archivo con resultados
        $dumpvars(-1, U0); 
        $monitor ("tarjeta_recibida=%b, tipo_trans=%b, digito_stb=%b, digito=%b, monto_stb=%b, monto=%b, balance_actualizado=%b, entregar_dinero=%b, pin_incorrecto=%b, advertencia=%b, bloqueo=%b, fondos_insuficientes=%b",
        tarjeta_recibida, tipo_trans, digito_stb, digito, monto_stb, monto, balance_actualizado, entregar_dinero, pin_incorrecto, advertencia, bloqueo, fondos_insuficientes);

    end

    // Para máquina de estados ATM_controller.v
    ATM_controller U0 (
        .clk (clk),
        .rst (rst), 
        .tarjeta_recibida (tarjeta_recibida),
        .tipo_trans(tipo_trans), 
        .digito_stb(digito_stb), 
        .digito(digito), 
        .monto_stb(monto_stb), 
        .monto(monto), 
        .balance_actualizado(balance_actualizado),
        .entregar_dinero(entregar_dinero),
        .pin_incorrecto(pin_incorrecto), 
        .advertencia(advertencia), 
        .bloqueo(bloqueo), 
        .fondos_insuficientes(fondos_insuficientes)
    );
    
    // Para tester de ATM_controller.v
    tester P0 (
        .clk (clk),
        .rst (rst), 
        .tarjeta_recibida (tarjeta_recibida),
        .tipo_trans(tipo_trans), 
        .digito_stb(digito_stb), 
        .digito(digito), 
        .monto_stb(monto_stb), 
        .monto(monto), 
        .balance_actualizado(balance_actualizado),
        .entregar_dinero(entregar_dinero),
        .pin_incorrecto(pin_incorrecto), 
        .advertencia(advertencia), 
        .bloqueo(bloqueo), 
        .fondos_insuficientes(fondos_insuficientes)
    );   

endmodule // Fin del módulo 
