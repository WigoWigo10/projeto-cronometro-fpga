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

## Equipe

  * Higor Cavalcante
  * Ricardo Lucca
  * Luis Guilherme
  * Lucas Kramer
  * Schaidson Souza

## Como Compilar e Simular

1.  Clone este repositório.
2.  Abra o arquivo `quartus/cronometro.qpf` no Quartus II.
3.  Para testar um módulo individualmente, defina-o como "Top-Level Entity" no menu de arquivos do projeto.
4.  Inicie a compilação (`Processing > Start Compilation`).
5.  Para simular, abra o arquivo `.vwf` correspondente ao módulo na pasta `sim/`, configure os estímulos de entrada e execute o simulador (`Processing > Simulator Tool`).