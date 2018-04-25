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
char * normString (char * string);

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
(<ValorServicos>) {return ANTVSERV;}
(<tsVlrSvc>) {return ANTVSERV;}
(<ns3\:BaseCalculo>) {return ANTVSERV;}
(<BaseCalculo>) {return ANTVSERV;}
(<valorTotalServico>) {return ANTVSERV;}

		/* Procede valor de servico */

(<\/VALOR_SERVICO>) {return DEPVSERV;}
(<\/ValorServicos>) {return DEPVSERV;}
(<\/tsVlrSvc>) {return DEPVSERV;}
(<\/ns3\:BaseCalculo>) {return DEPVSERV;}
(<\/BaseCalculo>) {return DEPVSERV;}
(<\/valorTotalServico>) {return DEPVSERV;}

 	/* Tokens de tag precedente e procedente de valor de ISS (Todos os padroes de XML) */

		/* Precede valor de ISS */

(\<VALOR_ISS\>) {return ANTVISS;}
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

    /* Definicao de string para palavras e numeros com separador decimal */

([ A-Za-z0-9\,\.\-]+) {yylval.stringValue = strdup(normString(yytext)); return STRING;}

\n ;

. ;

%%

int yywrap() {
  return 1;
}

char * normString (char * string)
{
    int len = strlen(string);
    for(int i = 0; i < len; i++)
        if(string[i] == ',') string[i] = '.';

    unsigned char pointCouter = 0;
    for(int i = len-1; i >= 0; i--) {

        if(string[i] == '.' && pointCouter) {
            for(int j = i; j < len; j++)
                string[j] = string[j+1];
        }
        else if(string[i] == '.') pointCouter++;
    }
    return string;
}
