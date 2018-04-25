 /*  Parser de Xml para notas fiscais, parte Lex
  *
  *  Rodrigo Caus - 186807
  *	Victor Santolim - 187888
  */

%{

#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

void yyerror(char *);
double transfDouble(char *);
char *normCep(char * string);

%}


%%
	/* Tokens de delimitacao */

	/* Tokens de tag precedente e procedente de nome de cidade especifica. Exemplo: Belem e Parauapebas  */

		/* Tomador */

(<TOMADOR_CIDADE>) {return ANTCIDTOM;}
(<tsMunTmd>) {return ANTCIDTOM;}
(<\/TOMADOR_CIDADE>) {return DEPCIDTOM;}
(<\/tsMunTmd>) {return DEPCIDTOM;}

		/* Prestador */

(<PRESTADOR_CIDADE>) {return ANTCIDPREST;}
(<tsMunPtd>) {return ANTCIDPREST;}
(<\/PRESTADOR_CIDADE>) {return DEPCIDPREST;}
(<\/tsMunPtd>) {return DEPCIDPREST;}

	/* Tokens de tag precedente e procedente da area de aninhamento de informaçoes do tomador.
 	Exemplo: Nova Lima e Rio de Janeiro */

		/* Inicio area tomador */

(<Tomador>) {return AREATOM;}
(<ns3\:Tomador>) {return AREATOM;}
(<TomadorServico>) {return AREATOM;}
(<tomador>) {return AREATOM;}

		/* Fim area tomador */

(<\/Tomador>) {return FIMAREATOM;}
(<\/ns3\:Tomador>) {return FIMAREATOM;}
(<\/TomadorServico>) {return FIMAREATOM;}
(<\/tomador>) {return FIMAREATOM;}

 	/* Tokens de tag precedente e procedente da area de aninhamento de informaçoes do prestador.
 	Exemplo: Nova Lima e Rio de Janeiro */

		/* Inicio area prestador */

(<PrestadorServico>) {return AREAPREST;}
(<ns3\:PrestadorServico>) {return AREAPREST;}
(<prestador>) {return AREAPREST;}

		/* Fim area prestador */

(<\/PrestadorServico>) {return FIMAREAPREST;}
(<\/ns3\:PrestadorServico>) {return FIMAREAPREST;}
(<\/prestador>) {return FIMAREAPREST;}

 	/* Tokens de tag precedente e procedente de cep (neutro)
 	Exemplo: Nova Lima e Rio de Janeiro */

		/* Precede CEP */

(<Cep>) {return ANTCEP;}
(<ns3\:Cep>) {return ANTCEP;}
(<cep>) {return ANTCEP;}

		/* Procede CEP */

(<\/Cep>) {return DEPCEP;}
(<\/ns3\:Cep>) {return DEPCEP;}
(<\/cep>) {return DEPCEP;}

 	/* Tokens de tag precedente e procedente de valor de servicos (Todos os padroes de XML) */

		/* Precede valor de servico */

(<VALOR_SERVICO>) {return ANTVSERV;}
(<tsVlrSvc>) {return ANTVSERV;}
(<ns3\:BaseCalculo>) {return ANTVSERV;}
(<BaseCalculo>) {return ANTVSERV;}
(<valorTotalServico>) {return ANTVSERV;}

		/* Procede valor de servico */

(<\/VALOR_SERVICO>) {return DEPVSERV;}
(<\/tsVlrSvc>) {return DEPVSERV;}
(<\/ns3\:BaseCalculo>) {return DEPVSERV;}
(<\/BaseCalculo>) {return DEPVSERV;}
(<\/valorTotalServico>) {return DEPVSERV;}

 	/* Tokens de tag precedente e procedente de valor de ISS (Todos os padroes de XML) */

		/* Precede valor de ISS */

(<VALOR_ISS>) {return ANTVISS;}
(<tsVlrISSRet>) {return ANTVISS;}
(<ns3\:ValorIss>) {return ANTVISS;}
(<ValorIss>) {return ANTVISS;}
(<valorTotalISS>) {return ANTVISS;}

		/* Procede valor de ISS */

(<\/VALOR_ISS>) {return DEPVISS;}
(<\/tsVlrISSRet>) {return DEPVISS;}
(<\/ns3\:ValorIss>) {return DEPVISS;}
(<\/ValorIss>) {return DEPVISS;}
(<\/valorTotalISS>) {return DEPVISS;}

	/* Tokens de dados */

	/* Valores com separador decimal = '.' */

([0-9]+\.[0-9]+) {yylval.doubleValue = atof(yytext); return DOUBLE;}

	/* Valores com separador decimal = ',' */

([0-9]+\,[0-9]+) {yylval.doubleValue = transfDouble(yytext); return DOUBLE;}

    /* Nomes de cidades (strings sem numeros) */

([ A-Za-z]+) {yylval.stringValue = strdup(yytext); return STRING;}

    /* Valores para deteccao de CEP (00000000 ou 00000-000) */

([0-9]{8}) {yylval.stringValue = strdup(yytext); return STRING;}

([0-9]{5}\-[0-9]{3}) {yylval.stringValue = strdup(normCep(yytext)); return STRING;}

\n ;

. ;

%%

int yywrap() {
  return 1;
}

 /* Funcao que transforma uma string numerica com separador decimal virgula
 	em ponto, depois transforma em double e retorna */
double transfDouble(char * string)
{
	int i;
	int len = strlen(string);
	for( i=0 ; i< len ; i++)
	{
		if(string[i] == ',')
		{
			string[i] = '.';
			break;
		}
	}
	return atof(string);
}

    /*  Funcao que transforma uma string de CEP com separador traco '-'
        para um padrao apenas numerico */
char * normCep(char * string)
{
    char aposTraco = 0;
    int len = strlen(string);
    for (int i=0; i< len; i++)
    {
        if(string[i] == '-')
            aposTraco = 1;
        if(aposTraco == 1)
            string[i] = string[i+1];
    }

    return string;
}
