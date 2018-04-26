/*  Parser de Xml para notas fiscais, parte YACC
 *
 *  Rodrigo Caus - 186807
 *	Victor Santolim - 187888
 */


%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *c);
int yylex(void);

char valorIss[20];
char valorServico[20];
char municipioTomador[100];
char municipioPrestador[100];

%}

%token ANTCIDTOM DEPCIDTOM ANTCIDPREST DEPCIDPREST
%token AREATOM FIMAREATOM AREAPREST FIMAREAPREST
%token ANTCEP DEPCEP ANTVSERV DEPVSERV ANTVISS DEPVISS
%token STRING

%left ANTCIDTOM DEPCIDTOM ANTCIDPREST DEPCIDPREST
%left AREATOM FIMAREATOM AREAPREST FIMAREAPREST
%left ANTCEP DEPCEP ANTVSERV DEPVSERV ANTVISS DEPVISS
%left STRING

%union {
    double doubleValue;
    char *stringValue;
}

%%

PROGRAMA:
    PROGRAMA INFORMACAO
    |
    ;

INFORMACAO:
    ANTVISS STRING DEPVISS {
        strcpy(valorIss, $<stringValue>2);
        free($<stringValue>2);
    }
    | ANTVSERV STRING DEPVSERV {
        strcpy(valorServico, $<stringValue>2);
        free($<stringValue>2);
    }
    /* Municipio do tomador */
    | ANTCIDTOM STRING DEPCIDTOM {
        strcpy(municipioTomador, $<stringValue>2);
        free($<stringValue>2);
    }
    /* Municipio do prestador */
    | ANTCIDPREST STRING DEPCIDPREST {
        strcpy(municipioPrestador, $<stringValue>2);
        free($<stringValue>2);
    }
    /* CEP do tomador em alternativa ao municipio */
    | AREATOM DADO ANTCEP STRING DEPCEP DADO FIMAREATOM {
        strcpy(municipioTomador, $<stringValue>4);
        free($<stringValue>4);
    }
    /* CEP do prestador em alternativa ao municipio */
    | AREAPREST DADO ANTCEP STRING DEPCEP DADO FIMAREAPREST {
        strcpy(municipioPrestador, $<stringValue>4);
        free($<stringValue>4);
    }
    | INFORMACAO INFORMACAO
    | INFORMACAO DADO
    | DADO INFORMACAO
    ;

DADO:
    /* Qualquer string não processada */
    STRING {
        free($<stringValue>1);
    }
    | DADO DADO
    |
    ;

%%

 /* Não será utilizada a função de erro na versão final */
void yyerror(char *s) {
    return;
}

int main() {

    // Inicializa as strings como vazias
    strcpy(valorIss, "-");
    strcpy(valorServico, "-");
    strcpy(municipioTomador, "-");
    strcpy(municipioPrestador, "-");

    yyparse();

    printf("%s,%s,%s,%s\n", municipioTomador, municipioPrestador
                            , valorServico, valorIss);

    return 0;
}
