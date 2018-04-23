/*  Parser de Xml para notas fiscais, parte Lex
 *
 *  Rodrigo Caus - 186807
 *	Victor Santolim - 187888
 */

%{

#include <stdlib.h>
#include <string.h>
void yyerror(char *);
double transfDouble(char *);
#include "y.tab.h"

%}


%%

(<TOMADOR_CIDADE_CODIGO>) {return ANTTOMCID;}
(<tsMunTmd>) {return ANTTOMCID;}

(<\/TOMADOR_CIDADE_CODIGO>) {return DEPTOMCID;}
(<\/tsMunTmd>) {return DEPTOMCID;}

((<PRESTADOR_CIDADE_CODIGO>)|(<tsMunPtd>)) {return ANTPRESTCID;}
((<\/PRESTADOR_CIDADE_CODIGO>)|(<\/tsMunPtd>)) {return DEPPRESTCID;}

(<Tomador>) {return AREATOM;}
(<ns3\:Tomador>) {return AREATOM;}
(<TomadorServico>) {return AREATOM;}
(<tomador>) {return AREATOM;}

(<\/Tomador>) {return FIMAREATOM;}
(<\/ns3\:Tomador>) {return FIMAREATOM;}
(<\/TomadorServico>) {return FIMAREATOM;}
(<\/tomador>) {return FIMAREATOM;}

(<PrestadorServico>) {return AREAPREST;}
(<ns3\:PrestadorServico>) {return AREAPREST;}
(<prestador>) {return AREAPREST;}

(<\/PrestadorServico>) {return FIMAREAPREST;}
(<\/ns3\:PrestadorServico>) {return FIMAREAPREST;}
(<\/prestador>) {return FIMAREAPREST;}

(<CodigoMunicipio>) {return ANTCID;}
(<ns3\:CodigoMunicipio>) {return ANTCID;}
(<codigoMunipio>) {return ANTCID;}

(<\/CodigoMunicipio>) {return DEPCID;}
(<\/ns3\:CodigoMunicipio>) {return DEPCID;}
(<\/codigoMunipio>) {return DEPCID;}

(<VALOR_SERVICO>) {return ANTVSERV;}
(<tsVlrSvc>) {return ANTVSERV;}
(<ns3\:BaseCalculo>) {return ANTVSERV;}
(<BaseCalculo>) {return ANTVSERV;}
(<valorTotalServico>) {return ANTVSERV;}

(<\/VALOR_SERVICO>) {return DEPVSERV;}
(<\/tsVlrSvc>) {return DEPVSERV;}
(<\/ns3\:BaseCalculo>) {return DEPVSERV;}
(<\/BaseCalculo>) {return DEPVSERV;}
(<\/valorTotalServico>) {return DEPVSERV;}

(<VALOR_ISS>) {return ANTVISS;}
(<tsVlrISSRet>) {return ANTVISS;}
(<ns3\:ValorIss>) {return ANTVISS;}
(<ValorIss>) {return ANTVISS;}
(<valorTotalISS>) {return ANTVISS;}

(<\/VALOR_ISS>) {return DEPVISS;}
(<\/tsVlrISSRet>) {return DEPVISS;}
(<\/ns3\:ValorIss>) {return DEPVISS;}
(<\/ValorIss>) {return DEPVISS;}
(<\/valorTotalISS>) {return DEPVISS;}


([ A-Za-z]+) {yylval.stringValue = strdup(yytext); return STRING;}

([0-9]+\.[0-9]+) {yylval.doubleValue = atof(yytext); return DOUBLE;}

([0-9]+\,[0-9]+) {yylval.doubleValue = transfDouble(yytext); return DOUBLE;}

. ;

%%

int yywrap() {
  return 1;
}

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
