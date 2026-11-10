/***************************************************************************
**
**     Programa....: AQ0502.I
**
**     Objetivo....: Procedure de consistˆncia da atualiza‡Æo estoque MAQ
**
***************************************************************************/

PROCEDURE pi-cria-tt-erro:

    def input parameter cod-mensag  as integer                      no-undo.
    def input parameter c-complem   as char                         no-undo.
    def input parameter p-tp-msg    as INTEGER                      no-undo.
    
    run utp/ut-msgs.p ( input "msg",
                        input cod-mensag,
                        input c-complem).
    
    CREATE tt-print-erro.
    ASSIGN tt-print-erro.cd-erro  = cod-mensag
           tt-print-erro.mensagem = RETURN-VALUE
           tt-print-erro.tp-msg   = p-tp-msg.

    IF AVAIL carg-rural THEN
        ASSIGN tt-print-erro.num-carga = carg-rural.num-carg.
    
END.

procedure pi-erro:
    
    DEF INPUT PARAMETER p-num-carga LIKE liber-carg.num-carg        NO-UNDO.
    def input parameter cod-mensag  as integer                      no-undo.
    def input parameter c-complem   as char                         no-undo.
    DEF INPUT PARAMETER p-proc-msg  AS LOG                          NO-UNDO.


    def var c-cabec1 as char format "X(132)".
    def var c-cabec2 as char format "X(132)".          
    def var c-textolabel as char no-undo.
    
    create tt-erro-aux.
    assign tt-erro-aux.cd-erro  = cod-mensag
           tt-erro-aux.mensagem = c-complem
           l-erro           = yes.

    if line-counter > 62 then
        page.

    if line-counter <= 5 then do:

        assign c-cabec1 = "".
                
        {utp/ut-field.i movind liber-carg num-carg 1}
        assign c-textolabel = "   " + trim(return-value).
        assign c-cabec1 = c-cabec1 + substring(c-textolabel,1,11,"character") + " ".

        {utp/ut-liter.i Erro * R}        
        assign c-cabec1 = c-cabec1 + trim(return-value) + "    ".
        {utp/ut-liter.i Mensagem * R}        
        assign c-cabec1 = c-cabec1 + trim(return-value).
        assign c-cabec2 = "----------- ------  ------------------------------------------------------------------------------------------".
                                                                        
        put c-cabec1 at 0 skip.
        put c-cabec2 at 0 skip.
    end.

    put p-num-carga at 1.
    put string(cod-mensag,">>>>>9") at 13.

    run pi-print-editor (input tt-erro-aux.mensagem, 80).

    for each tt-editor:
        put tt-editor.conteudo at 21 format "X(80)" skip. 
    end.

end. 

/* fim do programa */

