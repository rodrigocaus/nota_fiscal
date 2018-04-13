

%{
#include <stdio.h>
  #include <stdlib.h>
void yyerror(char *c);
int yylex(void);
%}

%%




%%
void yyerror(char *s) {
}
int main() {
  yyparse();
    return 0;
}

