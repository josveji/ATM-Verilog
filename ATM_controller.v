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

module ATM_controller(clk, rst, tarjeta_recibida, tipo_trans, digito_stb,
digito, pin, monto_stb, monto, balance_actualizado, entregar_dinero,
pin_incorrecto, advertencia, bloqueo, fondos_insuficientes,
nx_balance_actualizado, nx_entregar_dinero,
nx_pin_incorrecto, nx_advertencia, nx_bloqueo, nx_fondos_insuficientes);

// Declarando entradas
input clk, rst, tarjeta_recibida, digito_stb, monto_stb;
input [3:0] digito;
input [15:0] pin; 
input [31:0] monto; 

// Declarando salidas
output reg balance_actualizado, entregar_dinero, pin_incorrecto;
output reg advertencia, bloqueo, fondos_insuficientes;

// Declarando salidas futuras
output reg nx_balance_actualizado, nx_entregar_dinero, nx_pin_incorrecto;
output reg nx_advertencia, nx_bloqueo, nx_fondos_insuficientes;

// Declarando variables internas
parameter [63:0] balance = 4500;
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

// PIN correcto
localparam [15:0] pin_correcto = 4721;

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
    end else begin // Tratamiento de FFs
        state <= nx_state;
        intento <= nx_intento;
        balance_actualizado <= nx_balance_actualizado; 
        entregar_dinero <= nx_entregar_dinero;
        pin_incorrecto <= nx_pin_incorrecto;
        advertencia <= nx_advertencia;
        bloqueo <= nx_bloqueo;
        fondos_insuficientes <= nx_fondos_insuficientes;
    end

always @(*)

    nx_state = state; 
    nx_intento = intento; 

    nx_balance_actualizado = balance_actualizado; 
    nx_entregar_dinero = entregar_dinero;
    nx_pin_incorrecto = pin_incorrecto;
    nx_advertencia = advertencia;
    nx_bloqueo = bloqueo;
    nx_fondos_insuficientes = fondos_insuficientes;

    case(state) 
        // Estado 0
        Esperando_tarjeta: begin 
            nx_balance_actualizado = 0; // Todas las salidas son 0 en este estado
            nx_entregar_dinero = 0;
            nx_pin_incorrecto = 0;
            nx_advertencia = 0;
            nx_bloqueo = 0;
            nx_fondos_insuficientes = 0;

            if (tarjeta_recibida) nx_state = Verificar_pin;
            else nx_state = Esperando_tarjeta; // Vuelve a Esperando_tarjeta
        end

        // Estado 1
        Verificar_pin: begin 
            /*
            FALTA AGREGAR LÓGICA PARA VERIFICAR PIN Y TODO LO QUE 
            CONLLEVA
            */

            // Cuando el PIN es correcto
            if (pin == pin_correcto)begin 
                if (tipo_trans) nx_state = Retiro; // Pasa a estado retiro
                else nx_state = Deposito; // Pasa a estado deposito
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
                else if (monto =< balance) begin 
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

end

endmodule