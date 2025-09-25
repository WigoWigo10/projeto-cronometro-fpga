//-----------------------------------------------------------------------------
// Module: memoria
//
// Description:
// Armazena 4 tempos de cronometro no formato BCD.
// Cada tempo e armazenado como um valor de 16 bits.
// A escrita e sincrona (acontece na borda do clock) e a leitura
// e assincrona (combinacional).
//-----------------------------------------------------------------------------
module memoria (
    // --- Portas de Entrada ---
    input wire       clock,            // Clock do sistema
    input wire       write_enable,     // Pulso para habilitar a escrita (do detector de transicao)
    input wire [1:0] write_address,    // Endereco de 2 bits (0-3) para escrever
    input wire [1:0] read_address,     // Endereco de 2 bits (0-3) para ler
    input wire [15:0] data_in,         // Dado de 16 bits (em BCD) a ser escrito

    // --- Porta de Saida ---
    output wire [15:0] data_out        // Dado de 16 bits (em BCD) lido da memoria
);

    // --- Bloco de Memoria ---
    // Array de 4 posicoes, cada uma com 16 bits.
    reg [15:0] tempos [3:0];

    // --- Logica de Escrita (Sincrona) ---
    always @(posedge clock) begin
        if (write_enable) begin
            // Se a escrita estiver habilitada, armazena o dado de entrada
            // no endereco especificado.
            tempos[write_address] <= data_in;
        end
    end

    // --- Logica de Leitura (Assincrona / Combinacional) ---
    // A saida sempre reflete o dado presente no endereco de leitura.
    assign data_out = tempos[read_address];

endmodule