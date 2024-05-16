/* 
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código que implementa las pruebas (Probador) de 
verificación necesarias para el archivo "ATM_controller.v" (ATM). 
*/

// Declaración del módulo

module tester (
    // Outputs
    clk, 
    rst, 
    tarjeta_recibida, 
    tipo_trans, 
    add_digit, 
    digito_stb,
    digito,
    monto_stb,
    monto, 
    // Inputs
    balance_actualizado,
    entregar_dinero,
    pin_incorrecto, 
    advertencia, 
    bloqueo, 
    fondos_insuficientes,
    /*nx_balance_actualizado, nx_entregar_dinero, nx_pin_incorrecto,
    nx_advertencia, nx_bloqueo, nx_fondos_insuficientes*/
);

// Outputs
output clk, rst, tarjeta_recibida, tipo_trans, add_digit, digito_stb, monto_stb; 
output [3:0] digito; // Digito del teclado
output [31:0] monto; // Monto para realizar transacción

// Regs para Outputs
reg clk, rst, tarjeta_recibida, tipo_trans, add_digit, digito_stb, monto_stb;
reg [3:0] digito; // Digito del teclado
reg [31:0] monto;

// Inputs
input balance_actualizado, entregar_dinero, pin_incorrecto;
input advertencia, bloqueo, fondos_insuficientes;

// Wires para Inputs
wire balance_actualizado, entregar_dinero, pin_incorrecto;
wire advertencia, bloqueo, fondos_insuficientes;

// Declaración de reloj
always begin 
    #1 clk = !clk;
end

// Acá inicia el diseño de pruebas
always begin 
/*===================Prueba (1)=====================
Todo transcurre con normalidad. Se detecta tarjeta,
pin correcto, deposito de 2000 */ 
clk = 0;
tarjeta_recibida = 0; 
tipo_trans = 0; 
digito = 0; 
add_digit = 0; 
tipo_trans = 0; 
digito_stb = 0; 
monto_stb = 0; 


rst = 1;
#2 rst = 0;
monto = 10000;

#1 tarjeta_recibida = 1; // Se pasa al estado Verificar_pin
#1 tarjeta_recibida = 0; 
/* 4 = 0100
   7 = 0111
   5 = 0101
   6 = 0110 
*/
// Se ingresa el primer digito del pin
#1 digito = 4'b0100; // Pasa el 4
#2 add_digit = 1; // cambiar por digito_stb
#1 add_digit = 0; 
// Se ingresa el segundo digito del pin
digito = 4'b0111; // Pasa el 7
#1 add_digit = 1;
#1 add_digit = 0; 
// Se ingresa el tercer digito del pin
digito = 4'b0101; // Pasa el 5
#1 add_digit = 1;
#1 add_digit = 0; 
// Se ingresa el cuarto digito del pin
digito = 4'b0110; // Pasa el 6
#1 add_digit = 1;
#1 add_digit = 0; 

// Se verifica el pin
#1 tipo_trans = 0;  
#2 monto_stb = 1; // Se verifica correctamente y se para al estado Deposito
#1 monto_stb = 0;
//==================Fin Prueba (1)====================

#200 $finish;



end
endmodule