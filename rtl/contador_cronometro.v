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
        // A contagem so acontece se o sinal 'enable' estiver ativo.

        // Incrementa a unidade de centesimos a cada pulso de 100 Hz.
        cs_unidade <= cs_unidade + 4'd1;

        if (cs_unidade == 9) begin
            cs_unidade <= 4'd0;
            cs_dezena <= cs_dezena + 4'd1;

            if (cs_dezena == 9) begin
                cs_dezena <= 4'd0;
                s_unidade <= s_unidade + 4'd1;

                if (s_unidade == 9) begin
                    s_unidade <= 4'd0;
                    s_dezena <= s_dezena + 4'd1;

                    // O limite para a dezena de segundos e 59.
                    if (s_dezena == 5) begin
                        s_dezena <= 4'd0;
                        // Neste ponto, o cronometro chegou a 59:99.
                        // Poderia-se parar a contagem ou voltar a zero.
                        // Para este projeto, ele simplesmente volta a 00:00 e continua.
                    end
                end
            end
        end
    end
end

endmodule