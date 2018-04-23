#!/bin/bash

PASTA_TESTE=xml_aula
TARGET=$1

#Verifica a existencia de um arquivo target
if [ "$#" -lt 1 ];
then
	echo "Faltam argumentos!\n"
	exit
fi

for i in $(ls $PASTA_TESTE);
do
	#Verifica se o arquivo é um diretório
	if [ -d "$PASTA_TESTE/$i" ];
	then
		echo "$i"
		for j in $(ls "$PASTA_TESTE/$i");
		do
			./${TARGET} <"$PASTA_TESTE/$i/$j"
		done
		echo ""
	fi
done
