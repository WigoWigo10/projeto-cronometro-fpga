//-----------------------------------------------------------------------------
// Module: decodificador_7seg
//
// Description:
// Converte um valor de 4 bits em BCD (0-9) para o codigo de 7 segmentos
// correspondente. A saida e ativa em nivel baixo (0 = segmento aceso),
// compativel com displays de anodo comum.
//-----------------------------------------------------------------------------
module decodificador_7seg (
    // --- Porta de Entrada ---
    input  wire [3:0] bcd_in,    // Valor BCD de 4 bits (0-9)

    // --- Porta de Saida ---
    output reg  [6:0] seg_out    // Saida de 7 segmentos (g,f,e,d,c,b,a)
);

    // --- Logica Combinacional ---
    // Mapeia cada valor BCD para o seu padrao de 7 segmentos.
    always @(*) begin
        case (bcd_in)
            // bcd -> seg_out = 7'b(g,f,e,d,c,b,a)
            4'd0: seg_out = 7'b1000000; // 0
            4'd1: seg_out = 7'b1111001; // 1
            4'd2: seg_out = 7'b0100100; // 2
            4'd3: seg_out = 7'b0110000; // 3
            4'd4: seg_out = 7'b0011001; // 4
            4'd5: seg_out = 7'b0010010; // 5
            4'd6: seg_out = 7'b0000010; // 6
            4'd7: seg_out = 7'b1111000; // 7
            4'd8: seg_out = 7'b0000000; // 8
            4'd9: seg_out = 7'b0010000; // 9
            default: seg_out = 7'b1111111; // Desliga todos os segmentos
        endcase
    end

endmodule