//-----------------------------------------------------------------------------
// Module: contador_cronometro
//
// Description:
// Realiza a contagem de centesimos (0-99) e segundos (0-59).
// A saida e em BCD para facilitar a exibicao em displays de 7 segmentos.
//-----------------------------------------------------------------------------
module contador_cronometro (
    // --- Portas de Entrada ---
    input wire clk_100hz,    // Clock de 100 Hz vindo do divisor_clock
    input wire reset,        // Sinal de reset (ativo em nivel baixo)
    input wire enable,       // Habilita/desabilita a contagem

    // --- Portas de Saida (em BCD) ---
    output reg [3:0] cs_unidade,   // Centesimos - Unidade (HEX0)
    output reg [3:0] cs_dezena,    // Centesimos - Dezena  (HEX1)
    output reg [3:0] s_unidade,    // Segundos - Unidade   (HEX2)
    output reg [3:0] s_dezena      // Segundos - Dezena    (HEX3)
);

// --- Logica Sequencial ---
always @(posedge clk_100hz or negedge reset)
begin
    if (!reset) begin
        // Condicao de Reset: zera todos os digitos da contagem.
        cs_unidade <= 4'd0;
        cs_dezena  <= 4'd0;
        s_unidade  <= 4'd0;
        s_dezena   <= 4'd0;
    end
    else if (enable) begin
        // --- Lógica de Contagem em Cascata ---

        // Caso 1: Rollover completo dos centésimos (quando o tempo é X:99)
        // Zera os centésimos e aciona a lógica de incremento dos segundos.
        if (cs_unidade == 9 && cs_dezena == 9) begin
            cs_unidade <= 4'd0;
            cs_dezena  <= 4'd0;
            
            // Lógica dos Segundos (só é executada quando 1 segundo se passou)
            if (s_unidade == 9 && s_dezena == 5) begin // Caso especial: rollover de 59 para 00
                s_unidade <= 4'd0;
                s_dezena  <= 4'd0;
            end 
            else if (s_unidade == 9) begin // Caso de rollover da unidade: X9 -> (X+1)0
                s_unidade <= 4'd0;
                s_dezena  <= s_dezena + 4'd1;
            end 
            else begin // Caso de incremento normal da unidade: XY -> X(Y+1)
                s_unidade <= s_unidade + 4'd1;
            end
        end 
        
        // Caso 2: Rollover apenas da unidade de centésimos (quando o tempo é X:Y9, onde Y < 9)
        else if (cs_unidade == 9) begin
            cs_unidade <= 4'd0;
            cs_dezena  <= cs_dezena + 4'd1;
        end 
        
        // Caso 3: Incremento normal da unidade de centésimos
        else begin
            cs_unidade <= cs_unidade + 4'd1;
        end
    end
end

endmodule