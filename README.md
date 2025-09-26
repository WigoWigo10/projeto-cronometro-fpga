# Cronômetro Digital com Memória para FPGA

![Quartus II](https://img.shields.io/badge/Quartus%20II-9.1-blue?style=for-the-badge&logo=intel)
![Verilog](https://img.shields.io/badge/Language-Verilog-green?style=for-the-badge)
![Cyclone II](https://img.shields.io/badge/FPGA-Cyclone%20II-orange?style=for-the-badge)

## Sobre o Projeto


Este repositório contém a implementação de um cronômetro digital com memória, desenvolvido em Verilog para a disciplina de **Tecnologia e Hardware Reprogramável**. O projeto foi projetado para ser sintetizado e executado em uma placa FPGA Altera Cyclone II.

O sistema realiza uma contagem de 0 a 59 segundos e 0 a 99 centésimos de segundo , com funcionalidades de início, parada, reinicialização e armazenamento de até 4 marcações de tempo em uma memória interna.

## Funcionalidades

O sistema é controlado por uma série de botões e chaves com as seguintes funções:

  * **`KEY0`**: Quando pressionada, reinicia a contagem do cronômetro para `00:00`.
  * **`KEY1`**: Atua como um controle de contagem.
      * `1`: Inicia ou continua a contagem.
      * `0`: Suspende a contagem.
  * **`Write`**: Armazena o tempo atual do cronômetro em uma das 4 posições da memória interna, de forma sequencial (0 -\> 1 -\> 2 -\> 3 -\> 0).
  * **`Read`**: Exibe no display o tempo armazenado na memória, avançando sequencialmente pelas posições a cada pressionamento.
  * **`Display`**: Chave seletora para o que é exibido nos displays.
      * `1`: Mostra a contagem corrente do cronômetro.
      * `0`: Mostra o valor lido da memória.

## Status do Projeto

Aqui está o progresso atual do desenvolvimento. Para mais detalhes sobre as tarefas, consulte a seção [Issues](https://github.com/WigoWigo10/projeto-cronometro-fpga/issues) do repositório.

### Módulos Concluídos (Done)

- [x] **Módulo 1: Divisor de Frequência**
    - [x] Código Verilog implementado e comentado.
    - [x] Módulo validado via simulação funcional.
- [x] **Módulo 2: Detector de Transição**
    - [x] Código Verilog implementado e comentado.
    - [x] Módulo validado via simulação funcional.
- [x] **Módulo 4: Memória Interna e Contadores de Endereço**
    - [x] Código Verilog implementado e comentado.
    - [x] Módulo validado via simulação funcional.

### Próximos Passos (To Do)

- [ ] **Módulo 3: Contador do Cronômetro** (centésimos e segundos)
- [ ] **Módulo 5: Integração Top-Level** (conectar todos os módulos)
- [ ] **Finalização:** Atribuição de Pinos (Pin Planner) e preparação da documentação final.

## Estrutura de Pastas

```
/projeto-cronometro-fpga/
├── doc/         # Contém a documentação (roteiros, manuais, etc.)
├── quartus/     # Arquivos do projeto Quartus II (.qpf, .qsf)
├── rtl/         # Código-fonte em Verilog (.v)
├── sim/         # Arquivos de simulação (.vwf)
└── README.md
```

## Hardware e Software

  * **Software de Síntese:** Intel Quartus II (Versão 9.1 SP2 Web Edition)
  * **Linguagem:** Verilog HDL
  * **Dispositivo Alvo:**
      * **Família:** Cyclone II
      * **Dispositivo:** EP2C20F484C7

## Atribuição de Pinos (Pin Assignments)

A tabela a seguir detalha a conexão entre as portas do módulo Verilog de nível superior (`cronometro.v`) e os pinos físicos da placa FPGA DE1.

### Entradas

| Sinal (Porta no Top-Level) | Componente na Placa | Pino no FPGA |
|:---|:---|:---|
| `CLOCK_50` | 50MHz Oscillator | `PIN_L1` |
| `KEY_RESET` | Push-button `KEY0` | `PIN_R22` |
| `SW_RUN` | Toggle Switch `SW0` | `PIN_L22` |
| `KEY_WRITE` | Push-button `KEY1` | `PIN_R21` |
| `KEY_READ` | Push-button `KEY2` | `PIN_T22` |
| `SW_DISPLAY_MODE` | Toggle Switch `SW1` | `PIN_L21` |

### Saídas

| Sinal (Porta no Top-Level) | Componente na Placa | Pino no FPGA |
|:---|:---|:---|
| **`HEX0[6:0]`** (Centésimos, LSB) | Display `HEX0` | |
| `HEX0[0]` | HEX0 - Segmento 0 | `PIN_J2` |
| `HEX0[1]` | HEX0 - Segmento 1 | `PIN_J1` |
| `HEX0[2]` | HEX0 - Segmento 2 | `PIN_H2` |
| `HEX0[3]` | HEX0 - Segmento 3 | `PIN_H1` |
| `HEX0[4]` | HEX0 - Segmento 4 | `PIN_F2` |
| `HEX0[5]` | HEX0 - Segmento 5 | `PIN_F1` |
| `HEX0[6]` | HEX0 - Segmento 6 | `PIN_E2` |
| **`HEX1[6:0]`** | Display `HEX1` | |
| `HEX1[0]` | HEX1 - Segmento 0 | `PIN_E1` |
| `HEX1[1]` | HEX1 - Segmento 1 | `PIN_H6` |
| `HEX1[2]` | HEX1 - Segmento 2 | `PIN_H5` |
| `HEX1[3]` | HEX1 - Segmento 3 | `PIN_H4` |
| `HEX1[4]` | HEX1 - Segmento 4 | `PIN_G3` |
| `HEX1[5]` | HEX1 - Segmento 5 | `PIN_D2` |
| `HEX1[6]` | HEX1 - Segmento 6 | `PIN_D1` |
| **`HEX2[6:0]`** (Segundos, LSB) | Display `HEX2` | |
| `HEX2[0]` | HEX2 - Segmento 0 | `PIN_G5` |
| `HEX2[1]` | HEX2 - Segmento 1 | `PIN_G6` |
| `HEX2[2]` | HEX2 - Segmento 2 | `PIN_C2` |
| `HEX2[3]` | HEX2 - Segmento 3 | `PIN_C1` |
| `HEX2[4]` | HEX2 - Segmento 4 | `PIN_E3` |
| `HEX2[5]` | HEX2 - Segmento 5 | `PIN_E4` |
| `HEX2[6]` | HEX2 - Segmento 6 | `PIN_D3` |
| **`HEX3[6:0]`** (Segundos, MSB) | Display `HEX3` | |
| `HEX3[0]` | HEX3 - Segmento 0 | `PIN_F4` |
| `HEX3[1]` | HEX3 - Segmento 1 | `PIN_D5` |
| `HEX3[2]` | HEX3 - Segmento 2 | `PIN_D6` |
| `HEX3[3]` | HEX3 - Segmento 3 | `PIN_J4` |
| `HEX3[4]` | HEX3 - Segmento 4 | `PIN_L8` |
| `HEX3[5]` | HEX3 - Segmento 5 | `PIN_F3` |
| `HEX3[6]` | HEX3 - Segmento 6 | `PIN_D4` |

## Equipe

  * Higor Cavalcante ([@WigoWigo10](https://github.com/WigoWigo10))
  * Ricardo Lucca ([@ricohd22](https://github.com/ricohd22))
  * Luis Guilherme ([@Asteeeeee](https://github.com/Asteeeeee))
  * Lucas Kramer
  * Schaidson Souza

## Como Compilar e Simular

1.  Clone este repositório.
2.  Abra o arquivo `quartus/cronometro.qpf` no Quartus II.
3.  Para testar um módulo individualmente, defina-o como "Top-Level Entity" no menu de arquivos do projeto.
4.  Inicie a compilação (`Processing > Start Compilation`).
5.  Para simular, abra o arquivo `.vwf` correspondente ao módulo na pasta `sim/`, configure os estímulos de entrada e execute o simulador (`Processing > Simulator Tool`).