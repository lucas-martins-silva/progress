/* Include para dar visible conforme ordem parametrizada */

IF tt-estrutura.atributo = "{1}":U THEN DO:
   ASSIGN {2}:VISIBLE IN BROWSE br-tt-bc-etiqueta = YES.
   
   ASSIGN v-num-tamanho = LENGTH(trim(tt-estrutura.titulo-col)).
   IF v-num-tamanho > 0 THEN {2}:WIDTH-CHAR IN BROWSE br-tt-bc-etiqueta = v-num-tamanho + 1.
   IF v-num-tamanho > 0 THEN {2}:LABEL IN BROWSE br-tt-bc-etiqueta = tt-estrutura.titulo-col. 
   
END. 

