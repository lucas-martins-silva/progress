{include/i_dbvers.i}

{include/i-rpvar.i}

FORM "-------"
     "Anterior"
     "-------" 
     "--------" 
     "Atual"
     "---------" 
     WITH WIDTH 132 NO-BOX NO-LABEL PAGE-TOP TOP-ONLY FRAME f-cabecalho STREAM-IO.

&IF "{&mguni_version}" >= "2.071" &THEN
DO:
FORM ttRelat.ep-codigo-atu format "x(03)"
&ELSE
FORM ttRelat.ep-codigo-atu FORMAT ">>9"
&ENDIF
     ttRelat.cod-eqpto-atu 
&IF "{&mguni_version}" >= "2.071" &THEN
     ttRelat.ep-codigo-new format "x(03)"
&ELSE
     ttRelat.ep-codigo-new FORMAT ">>9"
&ENDIF
     ttRelat.cod-eqpto-new
     ttRelat.des-model
     ttRelat.des-erro FORMAT "X(41)"
    WITH WIDTH 132 NO-BOX DOWN FRAME f-dados STREAM-IO.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados:HANDLE).

END. 

{utp/ut-liter.i "Emp" *}
ASSIGN ttRelat.ep-codigo-atu:LABEL IN FRAME f-dados = trim(RETURN-VALUE) 
       ttRelat.ep-codigo-new:LABEL IN FRAME f-dados = trim(RETURN-VALUE).

{utp/ut-liter.i "Equipamento" *}
ASSIGN ttRelat.cod-eqpto-atu:LABEL IN FRAME f-dados = trim(RETURN-VALUE) 
       ttRelat.cod-eqpto-new:LABEL IN FRAME f-dados = trim(RETURN-VALUE) .
{utp/ut-liter.i "Descri‡Æo" *}
ASSIGN ttRElat.des-Model:LABEL IN FRAME f-dados = trim(RETURN-VALUE).
{utp/ut-liter.i "Erro" *}
ASSIGN ttRelat.des-erro:LABEL IN FRAME f-dados = RETURN-VALUE.


assign c-programa = "AB0201"
       c-versao   = "2.00"
       c-revisao  = "000"
       /** Define o destino do arquivo a ser gerado **/
       /*c-destino  = {varinc/var00002.i 04 integer(tt-param.destino)}*/
     .

/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

/** Busca empresa padrÆo **/
find first param-global no-lock no-error.
if  available param-global then
    assign c-empresa = param-global.grupo.

/** Guarda valores para imprimir t¡tulos **/
{utp/ut-liter.i "Altera‡Æo de C¢digo do Equipamento" *}
assign c-titulo-relat = trim(return-value).
{utp/ut-liter.i "ABASTECIMENTO E LUBRIFICA€ÇO" *}
assign c-sistema = trim(return-value).


{include/i-rpcab.i}    
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape. 

DISP  WITH FRAME f-cabecalho.
FOR EACH ttRelat NO-LOCK:
   DISP ttRelat.ep-codigo-atu  
         ttRelat.cod-eqpto-atu
         ttRelat.ep-codigo-new  
         ttRelat.cod-eqpto-new
         ttRelat.des-model
         ttRelat.des-erro
        WITH FRAME f-dados.
    DOWN WITH FRAME f-dados.
END.

{include/i-rpclo.i}     

return "OK". 
