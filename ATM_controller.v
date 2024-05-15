/* 
Tarea 3
Estudiante: Josué María Jiménez Ramírez, C13987 
Profesor: Enrique Coen Alfaro
Curso: Circuitos Digitales II
Periodo: I - 2024

Descripción del archivo: Este es el código que implementa la máquina de
estados para un controlador de un cajero automático (ATM). 
*/

// Declaración del módulo 

module ATMcontroller(clk, rst, tarjeta_recibida, tipo_trans, add_digit, 
digito_stb, digito, monto_stb, monto,  // Hasta acá las entradas
balance_actualizado, entregar_dinero, pin_incorrecto, advertencia, bloqueo, 
fondos_insuficientes,// Hasta acá salidas
nx_balance_actualizado, nx_entregar_dinero, 
nx_pin_incorrecto, nx_advertencia, nx_bloqueo, nx_fondos_insuficientes); // Hasta acá salidas como FFs

// Declarando entradas [9]
input clk, rst, tarjeta_recibida, tipo_trans, add_digit, digito_stb, monto_stb;
input [3:0] digito; // Digito del teclado
input [31:0] monto; // Monto para realizar transacción

// Variable interna para almacer los dígitos para el ingreso de pin
reg [15:0] pin_temporal; 
reg [15:0] nx_pin_temporal;
 

// Declarando salidas [6]
output reg balance_actualizado, entregar_dinero, pin_incorrecto;
output reg advertencia, bloqueo, fondos_insuficientes;

// Declarando salidas futuras [6]
output reg nx_balance_actualizado, nx_entregar_dinero, nx_pin_incorrecto;
output reg nx_advertencia, nx_bloqueo, nx_fondos_insuficientes;

// Contador de digitos
reg [4:0] contador_digitos;
reg [4:0] nx_contador_digitos;

// Declarando variables internas
// Balance de cuenta
reg [63:0] balance = 4500;
// Pin correcto es 4756 en BDC
/* 4 = 0100
   7 = 0111
   5 = 0101
   6 = 0110 
*/
parameter [15:0] pin_correcto = 16'b0100011101010110;

// Variables para contar intentos de PIN
reg [1:0] intento;
reg [1:0] nx_intento; 

// Declarando variables para manejo de estados
reg [3:0] state;    // Estado 
reg [3:0] nx_state; // Estado futuro

// Declarando estados 
parameter Esperando_tarjeta = 0;
parameter Verificar_pin = 1; 
parameter Deposito = 2;
parameter Retiro = 3; 
parameter Bloqueo = 4; 

always @(posedge clk) begin
    if (rst) begin // Cuando se activa rst
        state <= Esperando_tarjeta;
        intento <= 0;
        balance_actualizado <= 0; 
        entregar_dinero <= 0;
        pin_incorrecto <= 0;
        advertencia <= 0;
        bloqueo <= 0;
        fondos_insuficientes <= 0;
        pin_temporal <= 16'b0000000000000000;
        nx_contador_digitos <= 0;

    end else begin // Tratamiento de FFs
        state <= nx_state;
        intento <= nx_intento;
        balance_actualizado <= nx_balance_actualizado; 
        entregar_dinero <= nx_entregar_dinero;
        pin_incorrecto <= nx_pin_incorrecto;
        advertencia <= nx_advertencia;
        bloqueo <= nx_bloqueo;
        fondos_insuficientes <= nx_fondos_insuficientes;
        pin_temporal <= nx_pin_temporal;
        contador_digitos <= nx_contador_digitos;
    end
end // termina  @(posedge clk)

always @(*) begin 

    nx_state = state; 
    nx_intento = intento; 

    nx_balance_actualizado = balance_actualizado; 
    nx_entregar_dinero = entregar_dinero;
    nx_pin_incorrecto = pin_incorrecto;
    nx_advertencia = advertencia;
    nx_bloqueo = bloqueo;
    nx_fondos_insuficientes = fondos_insuficientes;
    nx_pin_temporal = pin_temporal ;
    nx_contador_digitos = contador_digitos;

    case(state) 
        // Estado 0
        Esperando_tarjeta: begin 
            nx_balance_actualizado = 0; // Todas las salidas son 0 en este estado
            nx_entregar_dinero = 0;
            nx_pin_incorrecto = 0;
            nx_advertencia = 0;
            nx_bloqueo = 0;
            nx_fondos_insuficientes = 0;
            nx_contador_digitos = 0;

            if (tarjeta_recibida) nx_state = Verificar_pin;
            else nx_state = Esperando_tarjeta; // Vuelve a Esperando_tarjeta
        end

        // Estado 1
        Verificar_pin: begin 
            if (nx_contador_digitos < 4 && add_digit)begin
                nx_contador_digitos = nx_contador_digitos +1;
                pin_temporal = {pin_temporal[11:0], digito};
                nx_state = Verificar_pin;
            end 
            else if (contador_digitos == 4 && digito_stb)begin
                if (pin_temporal == pin_correcto && ~tipo_trans) nx_state = Deposito;
                else if(pin_temporal == pin_correcto && tipo_trans) nx_state = Retiro;
            end
            
        end
        
        // Estado 2
        Deposito: begin 
            if (monto_stb) begin 
                balance = balance + monto; 
                nx_balance_actualizado = 1;
                nx_state = Esperando_tarjeta;
            end
            else nx_state = Deposito;
        end

        // Estado 3
        Retiro: begin 
            if (monto_stb)begin 
                if (monto > balance) nx_fondos_insuficientes = 1;
                else if (monto <= balance) begin 
                    balance = balance - monto; 
                    nx_entregar_dinero = 1;
                    nx_balance_actualizado = 1; 
                    nx_state = Esperando_tarjeta;
                end
            end
        end

        // Estado 4
        Bloqueo: begin 
            nx_bloqueo = 1;
            if (rst) nx_state = Esperando_tarjeta; 
            else nx_state = Bloqueo;  
        end

    
    endcase // Acá terminan los casos para los estados

end // Termina @(*)

endmodule