//-----------------------------------------------------------------------------
// Module: divisor_clock
//
// Description:
// Este modulo divide um clock de entrada de 50 MHz para gerar um clock de
// saida de 100 Hz com aproximadamente 50% de ciclo de trabalho (duty cycle).
//
//-----------------------------------------------------------------------------
module divisor_clock (
    // --- Portas de Entrada ---
    input  wire clk_in,      // Clock de entrada de 50 MHz
    input  wire rst,         // Reset assincrono (ativo em nivel baixo)

    // --- Porta de Saida ---
    output reg  clk_out      // Clock de saida de 100 Hz
);

    // --- Parametros ---
    // Fator de divisao para o clock da placa: 50000000 / 100 = 500000
    parameter DIVISOR = 500000;

    // --- Registradores Internos ---
    // O contador precisa ir ate (DIVISOR / 2) - 1, que e 249999.
    // log2(249999) = 17.9, portanto, sao necessarios 18 bits.
    reg [17:0] counter = 18'd0; // Inicializacao explicita

    // --- Logica Sequencial ---
    always @(posedge clk_in or negedge rst) begin
        if (!rst) begin
            // Condicao de Reset: zera o contador e a saida.
            counter <= 18'd0;
            clk_out <= 1'b0;
        end
        // A contagem so deve acontecer quando o reset nao estiver ativo.
        else if (counter == (DIVISOR / 2) - 1) begin
            // Atingiu o valor de meio ciclo.
            counter <= 18'd0;       // Zera o contador para um novo ciclo.
            clk_out <= ~clk_out;    // Inverte o sinal do clock de saida.
        end
        else begin
            // Se nao atingiu o limite, apenas incrementa o contador.
            counter <= counter + 18'd1;
        end
    end

endmodule