/*IM0016.i*/

def var i-numero-ordem like cotacao-item-cex.numero-ordem  no-undo. 
def var i-cod-emitente like cotacao-item-cex.cod-emitente  no-undo.
def var c-it-codigo    like cotacao-item-cex.it-codigo     no-undo.
def var i-seq-cotac    like cotacao-item-cex.seq-cotac     no-undo.
def var da-cotacao     like cotacao-item-cex.data-cotacao  no-undo.
def var c-return       as char   no-undo.
DEF VAR i-cod-desp     LIKE desp-imp.cod-desp              NO-UNDO.

find cotacao-item-cex 
    where rowid(cotacao-item-cex) = r-chave 
    no-lock no-error.
if avail cotacao-item-cex then
    assign i-numero-ordem = cotacao-item-cex.numero-ordem 
           i-cod-emitente = cotacao-item-cex.cod-emitente 
           c-it-codigo    = cotacao-item-cex.it-codigo
           i-seq-cotac    = cotacao-item-cex.seq-cotac
           da-cotacao     = cotacao-item-cex.data-cotacao
           i-mapa-cotacao = cotacao-item-cex.mapa-cotacao.

for each cotacao-item-cex fields(cotacao-item-cex.cod-emitente-desp cotacao-item-cex.mapa-cotacao cotacao-item-cex.cod-desp cotacao-item-cex.cod-itiner cotacao-item-cex.cod-pto-contr cotacao-item-cex.val-desp) no-lock
    where cotacao-item-cex.numero-ordem = i-numero-ordem and
          cotacao-item-cex.cod-emitente = i-cod-emitente and
          cotacao-item-cex.it-codigo    = c-it-codigo    and
          cotacao-item-cex.data-cotacao = da-cotacao     and
          cotacao-item-cex.seq-cotac    = i-seq-cotac    and
          cotacao-item-cex.mapa-cotacao = i-mapa-cotacao:

    if cotacao-item-cex.cod-emitente-desp = 0 then do:
        create tt-bo-erro.
        {utp/ut-liter.i Fornecedor_da_Despesa *L} 
        assign c-return = trim(return-value) + " " + STRING(cotacao-item-cex.cod-desp).
        {utp/ut-liter.i zero * L}
        assign i-seq-erro = i-seq-erro + 1.
        assign tt-bo-erro.parametros = c-return + "~~" + trim(return-value). 
        run utp/ut-msgs.p (input "msg",
                           input 7972,
                           input c-return + "~~" + return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
      	       tt-bo-erro.cd-erro  = 7972
     	       tt-bo-erro.mensagem = return-value.    
    end.                   
    IF cotacao-item-cex.cod-pto-contr = 0 THEN DO:
        create tt-bo-erro.
        {utp/ut-liter.i Despesa * L}
        assign c-return = trim(return-value) + " " + STRING(cotacao-item-cex.cod-desp). 
        {utp/ut-liter.i Ponto_de_Controle * L}
        assign i-seq-erro = i-seq-erro + 1.
        assign tt-bo-erro.parametros = c-return + "~~" + trim(return-value).
        run utp/ut-msgs.p (input "msg":U,
                           input 29569,
                           input c-return + "~~" + trim(return-value)).

        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 29569
               tt-bo-erro.mensagem     = return-value.

        {utp/ut-liter.i Despesa * L}
        ASSIGN c-return = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Ponto_de_Controle_do_Itiner rio * L}
        ASSIGN i-seq-erro = i-seq-erro + 1.
        ASSIGN tt-bo-erro.parametros = c-return + "~~" + TRIM(RETURN-VALUE).

        run utp/ut-msgs.p (INPUT "help":U,
                           INPUT 29569,
                           INPUT c-return + "~~" + TRIM(RETURN-VALUE)).

        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 29569
               tt-bo-erro.errorhelp    = return-value.

    end.
    IF cotacao-item-cex.val-desp = 0 OR
       cotacao-item-cex.val-desp = ? THEN DO:
        CREATE tt-bo-erro.
        {utp/ut-liter.i Valor_da_Despesa * L}
        ASSIGN c-return = TRIM(RETURN-VALUE) + " " + STRING(cotacao-item-cex.cod-desp).
        ASSIGN i-seq-erro = i-seq-erro + 1.
        ASSIGN tt-bo-erro.parametros = c-return + "~~" + TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 265,
                           INPUT c-return + "~~" + TRIM(RETURN-VALUE)).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro   = 265
               tt-bo-erro.mensagem  = RETURN-VALUE.
    END.

END.
/*IM0016.i*/
