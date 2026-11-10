/*
**  BOCX140a.i
**
**  Atualiza‡Æo da situa‡Æo do Processo de Importa‡Æo
**  Recebe: p-num-pedido   = N£mero do Pedido de Compra
**          p-cod-emitente = C¢digo do Emitente
**          p-cod-estabel  = C¢digo do Estabelecimento
**
**  Cria‡Æo : 23/12/2003 - Cristiano de Souza
*/

def input parameter p-num-pedido   like pedido-compr.num-pedido no-undo.
def input parameter p-cod-emitente as integer no-undo.
def input parameter p-cod-estabel  like estabelec.cod-estabel    no-undo.

/*Variaveis Processo Importa‡Æo*/
def var c-nr-proc-imp  as char no-undo.
def var c-embarque     as char format "x(12)" no-undo.
def var c-return-imp   as char format "x(12)" no-undo.
def var c-return-value as char format "x(12)" no-undo.


FIND FIRST param-global NO-LOCK NO-ERROR.

if param-global.modulo-07 then 
     run cxbo/bocx140.p persistent set h-bocx140.

find emitente where 
     emitente.cod-emitente = p-cod-emitente no-lock no-error.

IF  param-global.modulo-07  AND
    (AVAIL emitente         AND
     emitente.natureza = 3  OR
     emitente.natureza = 4) THEN DO:
    RUN findPedido IN h-bocx140 (INPUT p-num-pedido,
                                 OUTPUT c-return-imp).

    IF  c-return-imp = "":U THEN DO:
        {utp/ut-table.i mgind ordem-compra 1}
        ASSIGN c-return-value = TRIM(RETURN-VALUE).

        RUN getCharfield IN h-bocx140 (INPUT "nr-proc-imp":U,
                                       OUTPUT c-nr-proc-imp).

        RUN atualizaSituacaoProcesso IN h-bocx140 (INPUT p-cod-estabel,
                                                   INPUT c-nr-proc-imp,
                                                   OUTPUT TABLE tt-bo-erro).
    END.
END.

IF  VALID-HANDLE(h-bocx140) THEN DO:
    DELETE PROCEDURE h-bocx140.
    ASSIGN h-bocx140 = ?.
END.
