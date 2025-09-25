//-----------------------------------------------------------------------------
// Module: detector_transicao
//
// Description:
// Detecta a borda de subida de um sinal de entrada (signal_in) e gera
// um pulso de saida (edge_detected) com duracao de um ciclo de clock.
// E essencial para ler botoes e evitar ruidos (bouncing).
//-----------------------------------------------------------------------------
module detector_transicao (
    // --- Portas de Entrada ---
    input wire signal_in,   // O sinal do botao que sera monitorado
    input wire clock,       // Clock do sistema
    input wire clear,       // Reset assincrono (ativo em nivel baixo)

    // --- Porta de Saida ---
    output reg edge_detected // Pulso de saida
);

    // --- Registrador Interno ---
    // Armazena o estado anterior do sinal de entrada para comparacao.
    reg signal_in_prev;

    // --- Logica Sequencial ---
    always @(posedge clock or negedge clear) begin
        if (!clear) begin
            // Condicao de Reset: zera a saida e o estado anterior.
            edge_detected  <= 1'b0;
            signal_in_prev <= 1'b0;
        end
        // Compara o estado atual com o anterior para detectar a borda de subida
        else if (signal_in_prev == 1'b0 && signal_in == 1'b1) begin
            // Borda de subida detectada! (Sinal era 0 e agora e 1)
            edge_detected  <= 1'b1; // Gera o pulso de saida
            signal_in_prev <= signal_in; // Atualiza o estado anterior
        end
        else begin
            // Em qualquer outro caso, a saida fica em 0.
            edge_detected  <= 1'b0;
            signal_in_prev <= signal_in; // Atualiza o estado anterior
        end
    end

endmodule