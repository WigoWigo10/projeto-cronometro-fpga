//-----------------------------------------------------------------------------
// Module: cronometro (Top-Level)
//
// Description:
// Modulo principal que integra todos os sub-modulos para formar o
// cronometro digital com memoria, conectando a logica interna as
// portas fisicas da placa FPGA.
//-----------------------------------------------------------------------------
module cronometro (
    // --- Entradas Fisicas ---
    input  wire CLOCK_50,          // Clock de 50 MHz da placa
    input  wire KEY_RESET,         // Botao KEY0 para resetar o sistema (ativo em baixo)
    input  wire SW_RUN,             // Chave SW0 para iniciar/parar a contagem
    input  wire KEY_WRITE,          // Botao KEY1 para salvar o tempo (ativo em baixo)
    input  wire KEY_READ,           // Botao KEY2 para ler o tempo da memoria (ativo em baixo)
    input  wire SW_DISPLAY_MODE,   // Chave SW1 para selecionar o que e exibido

    // --- Saidas Fisicas (Displays de 7 Segmentos) ---
    output wire [6:0] HEX0,        // Centesimos, digito menos significativo
    output wire [6:0] HEX1,        // Centesimos, digito mais significativo
    output wire [6:0] HEX2,        // Segundos, digito menos significativo
    output wire [6:0] HEX3         // Segundos, digito mais significativo
);

    // --- Sinais Internos (Wires) ---

    // Sinal de clock de 100Hz gerado pelo divisor
    wire clk_100hz_wire;

    // Pulsos de um ciclo de clock para os botoes de escrita e leitura
    wire write_pulse_wire;
    wire read_pulse_wire;

    // Enderecos para a memoria (2 bits para 4 posicoes)
    wire [1:0] write_address_wire;
    wire [1:0] read_address_wire;

    // Saidas BCD do modulo contador
    wire [3:0] cs_unidade_wire;
    wire [3:0] cs_dezena_wire;
    wire [3:0] s_unidade_wire;
    wire [3:0] s_dezena_wire;

    // Barramento de 16 bits para agrupar os dados BCD
    wire [15:0] tempo_atual_bcd_wire;
    wire [15:0] tempo_memoria_bcd_wire;
    wire [15:0] display_bcd_wire;


    // --- Instancias dos Modulos ---

    // 1. Divisor de Frequencia: Gera 100Hz a partir de 50MHz
    divisor_clock inst_divisor (
        .clk_in(CLOCK_50),
        .rst(~KEY_RESET), // Botoes KEY sao ativos em nivel baixo, modulos esperam nivel alto
        .clk_out(clk_100hz_wire)
    );

    // 2. Detectores de Transicao (um para cada botao de acao)
    detector_transicao inst_detect_write (
        .signal_in(~KEY_WRITE),
        .clock(CLOCK_50),
        .clear(~KEY_RESET),
        .edge_detected(write_pulse_wire)
    );

    detector_transicao inst_detect_read (
        .signal_in(~KEY_READ),
        .clock(CLOCK_50),
        .clear(~KEY_RESET),
        .edge_detected(read_pulse_wire)
    );

    // 3. Contador do Cronometro
    contador_cronometro inst_contador (
        .clk_100hz(clk_100hz_wire),
        .reset(~KEY_RESET),
        .enable(SW_RUN),
        .cs_unidade(cs_unidade_wire),
        .cs_dezena(cs_dezena_wire),
        .s_unidade(s_unidade_wire),
        .s_dezena(s_dezena_wire)
    );

    // 4. Memoria
    memoria inst_memoria (
        .clock(CLOCK_50),
        .write_enable(write_pulse_wire),
        .write_address(write_address_wire),
        .read_address(read_address_wire),
        .data_in(tempo_atual_bcd_wire),
        .data_out(tempo_memoria_bcd_wire)
    );


    // --- Logica de Controle e Conexao (Glue Logic) ---

    // Agrupa as saidas do contador em um unico barramento de 16 bits para a memoria
    assign tempo_atual_bcd_wire = {s_dezena_wire, s_unidade_wire, cs_dezena_wire, cs_unidade_wire};

    // Contadores de Endereco (0 a 3) para escrita e leitura
    reg [1:0] write_address_reg = 2'd0;
    reg [1:0] read_address_reg  = 2'd0;

    always @(posedge CLOCK_50 or negedge KEY_RESET) begin
        if (!KEY_RESET) begin
            write_address_reg <= 2'd0;
            read_address_reg  <= 2'd0;
        end
        else begin
            // Incrementa o endereco de escrita quando o botao WRITE for pressionado
            if (write_pulse_wire) begin
                write_address_reg <= write_address_reg + 2'd1;
            end

            // Incrementa o endereco de leitura quando o botao READ for pressionado
            if (read_pulse_wire) begin
                read_address_reg <= read_address_reg + 2'd1;
            end
        end
    end

    // Conecta a saida dos registradores aos fios de endereco
    assign write_address_wire = write_address_reg;
    assign read_address_wire  = read_address_reg;

    // Logica de Selecao do Display (Multiplexador)
    // Se SW_DISPLAY_MODE for 1, mostra o tempo atual. Se for 0, mostra o da memoria.
    assign display_bcd_wire = SW_DISPLAY_MODE ? tempo_atual_bcd_wire : tempo_memoria_bcd_wire;


    // --- Decodificadores para os Displays ---
    
    // Conecta os 4 bits de cada digito BCD a um decodificador de 7 segmentos
    decodificador_7seg dec_hex0 (
        .bcd_in(display_bcd_wire[3:0]),
        .seg_out(HEX0)
    );
    decodificador_7seg dec_hex1 (
        .bcd_in(display_bcd_wire[7:4]),
        .seg_out(HEX1)
    );
    decodificador_7seg dec_hex2 (
        .bcd_in(display_bcd_wire[11:8]),
        .seg_out(HEX2)
    );
    decodificador_7seg dec_hex3 (
        .bcd_in(display_bcd_wire[15:12]),
        .seg_out(HEX3)
    );

endmodule