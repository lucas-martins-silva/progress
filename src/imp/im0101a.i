/** Programa: imp/im0101a.i                                     **
**  Objetivo: Quando s∆o geradas notas fiscais complementares    **
**            com v†rios embarques, identifica em qual embarque  **
**            ocorreu erro                                       **/

    assign i-seq-erro = 0.
    create tt-bo-erro.
    {utp/ut-liter.i Erro_ocorrido_durante_a_geraá∆o_do_embarque * L}
    assign tt-bo-erro.parametros = trim(return-value) + " " + tt-parametros.embarque.
    run utp/ut-msgs.p (input "msg":U,
                       input 7912,
                       input tt-bo-erro.parametros).
    assign tt-bo-erro.i-sequen = i-seq-erro
           tt-bo-erro.cd-erro  = 7912
           tt-bo-erro.mensagem = return-value.
    
    if  valid-handle(h-acomp) then
        run pi-finalizar in h-acomp.

    run getTT-bo-erro in h-im0101a1 (output table tt-bo-erro append).
    
    if  valid-handle (h-im0101a1) then
        delete procedure h-im0101a1.  
    
    return "NOK":U.

/** imp/im0101a.i **/
