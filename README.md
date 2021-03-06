# Leitura de Notas Fiscais

O objetivo do trabalho é implementar um programa de computador capaz de receber
como entrada uma Nota Fiscal de serviços prestados a prefeituras em formato XML
e automatizar a coleta de informações de interesse administrativo, como valores
de serviço e de ISS e cidades envolvidas, de modo a confeccionar uma tabela em
formato csv para fácil leitura e interpretação dessas informações. O programa é
escrito em duas partes, uma de análise léxica feita em LEX (flex), e outra de
análise sintática, feita em YACC (bison).

## Teste do programa

Há algumas maneiras de testar o programa.

Ele sendo executado da forma:

```
./main <arquivo_entrada.xml >arquivo_saida.csv
```

Com o script de teste:

```
sh test.sh main
```

ele irá rodar todos os arquivos de `xml_aula` e imprimir na saída padrão.

Com o Makefile, a saída é a mesma que no caso acima. O processo pode demorar a
ser finalizado quando se executa o comando pela primeira vez para compilar o código:

```
make test
```

Para gerar um arquivo csv, basta executar o make com arquivo de saida:

```
make test >saida.csv
```

O programa já está com saída formatada para o padrão de csv.

## Saida do programa

A saída é do padrão de csv separado por vírgulas, cujas
informações são da forma `cidade_tomador,cidade_prestador,valor_servico,valor_iss\n`
