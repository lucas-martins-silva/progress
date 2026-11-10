/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN180B 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN180B MUT}
&ENDIF


{include/boini.i}


Procedure VerificarParamItem:

    def input param p-it-codigo as char format "x(16)".
    def output param table for tt-bo-erro.
    
    def var de-tot-proces       like proces-item.proporcao.
    def var i-seq-erro          as integer.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
        
    if  not can-find(first operacao where
                     operacao.it-codigo   = p-it-codigo and
                     operacao.cod-roteiro = "") and
    not can-find(first rot-item where
                 rot-item.it-codigo = p-it-codigo) then do:
         run utp/ut-msgs.p (input 'msg', input 8343, input "").        
         create tt-bo-erro.
         assign i-seq-erro              = i-seq-erro + 1
                tt-bo-erro.i-sequen     = i-seq-erro
                tt-bo-erro.cd-erro      = 8343
                tt-bo-erro.mensagem     = return-value.
    end.
    
    if can-find(first lista-compon-item where
                lista-compon-item.it-codigo = p-it-codigo) and
    not can-find(first proces-item where
                 proces-item.it-codigo = p-it-codigo) then do:
         run utp/ut-msgs.p (input 'msg', input 17831, input "").                 
         create tt-bo-erro.
         assign i-seq-erro              = i-seq-erro + 1
                tt-bo-erro.i-sequen     = i-seq-erro
                tt-bo-erro.cd-erro      = 17831
                tt-bo-erro.mensagem     = return-value.
    end.
    
    if can-find(first proces-item where
                 proces-item.it-codigo = p-it-codigo) then do:
        assign de-tot-proces = 0.
        for each proces-item
            where proces-item.it-codigo = p-it-codigo:
            assign de-tot-proces = de-tot-proces + proces-item.proporcao.
        end.
        
        if de-tot-proces < 99.99 or
           de-tot-proces > 100   then do:
            run utp/ut-msgs.p (input 'msg', input 17832, input "").        
            create tt-bo-erro.
            assign i-seq-erro              = i-seq-erro + 1
                   tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 17832
                   tt-bo-erro.mensagem     = return-value.    
        end.
    end.
    
    
End procedure.    
