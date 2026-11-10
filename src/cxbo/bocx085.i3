/************************************************************************************************
**
** BOCX085.I3 - Validacao Moeda
**
** Objetivo - quando o fornecedor da despesa for o mesmo forncedor do material, e obrigatorio que
**            a moeda seja igual a da cotacao do material. Quando ja houver uma despesa informada
**            com o mesmo fornecedor e obrigatorio que as despesas possuam a mesma moeda.
** Utilizada - BOCX085.P / BOCX305.P
************************************************************************************************/

if not can-find(moeda where moeda.mo-codigo = rowObject.mo-codigo) then do:
    assign i-seq-erro = i-seq-erro + 1.
    /* NAO ALTERAR - Distribuicao Magnus nao reconhece 
       pre-processador em chamada de includes */
    {utp/ut-table.i mguni moeda 1}
    /******************************************/
    create tt-bo-erro.
    assign tt-bo-erro.parametros = return-value.        
    run utp/ut-msgs.p (input "msg",
                       input 2,
                       input return-value).
    assign tt-bo-erro.i-sequen     = i-seq-erro
           tt-bo-erro.cd-erro      = 2
           tt-bo-erro.mensagem     = return-value.
end.
else do: 
    &IF "{&TABLE-NAME}" = "cotacao-item-cex" &THEN
        if rowObject.cod-emitente = rowObject.cod-emitente-desp then do:
            for first cotacao-item fields(cotacao-item.mo-codigo)
                where cotacao-item.numero-ordem     = rowObject.numero-ordem and
                      cotacao-item.cod-emitente     = rowObject.cod-emitente and
                      cotacao-item.it-codigo        = rowObject.it-codigo and
                      &if defined(bf-mat-comex) &then                                
                          cotacao-item.data-cotacao = rowObject.data-cotacao no-lock:
                      &else
                          cotacao-item.seq-cotac = rowObject.seq-cotac no-lock:                      
                      &endif    
                if rowObject.mo-codigo <> cotacao-item.mo-codigo then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" + 
                                                   string(cotacao-item.mo-codigo).
                    run utp/ut-msgs.p (input "msg",
                                       input 18846,
                                       input string(rowObject.mo-codigo) + "~~" + 
                                             string(cotacao-item.mo-codigo)).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 18846
                           tt-bo-erro.mensagem     = return-value.
                end.
            end.
        end.
        else do: 
            for first {&table-name} fields({&TABLE-NAME}.mo-codigo {&table-name}.cod-emitente-desp)
                where {&TABLE-NAME}.numero-ordem      = rowObject.numero-ordem and
                      {&TABLE-NAME}.cod-emitente      = rowObject.cod-emitente and
                      {&TABLE-NAME}.it-codigo         = rowObject.it-codigo and
                      {&TABLE-NAME}.seq-cotac         = rowObject.seq-cotac and
                      {&TABLE-NAME}.mapa-cotacao      = rowObject.mapa-cotacao and
                      {&TABLE-NAME}.cod-incoterm      = rowObject.cod-incoterm and
                      {&TABLE-NAME}.cod-itiner        = rowObject.cod-itiner and
                      {&TABLE-NAME}.cod-emitente-desp = rowObject.cod-emitente-desp and 
                      {&TABLE-NAME}.cod-desp         <> rowObject.cod-desp no-lock:
                if rowObject.mo-codigo <> {&TABLE-NAME}.mo-codigo then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" + 
                                                   string({&table-name}.mo-codigo) + "~~" +
                                                   string({&table-name}.cod-emitente-desp).            
                    run utp/ut-msgs.p (input "msg",
                                       input 18848,
                                       input string(rowObject.mo-codigo) + "~~" + 
                                             string({&table-name}.mo-codigo) + "~~" +
                                             string({&table-name}.cod-emitente-desp)).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 18848
                           tt-bo-erro.mensagem     = return-value.
                end.
            end.
        end.
    &ENDIF.
    &IF "{&TABLE-NAME}" = "desp-cot-ordem" &THEN        
        if avail cot-ordem then do:
            for first cotacao-item fields(cotacao-item.mo-codigo)
                where cotacao-item.numero-ordem     = cot-ordem.numero-ordem and
                      cotacao-item.cod-emitente     = rowObject.cod-emitente-desp and
                      &if defined(bf-mat-comex) &then                                                      
                          cotacao-item.data-cotacao = cot-ordem.data-1 no-lock:
                      &else
                          cotacao-item.seq-cotac    = cot-ordem.seq-cotac no-lock:                      
                      &endif
                if rowObject.mo-codigo <> cotacao-item.mo-codigo then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" + 
                                                   string(cotacao-item.mo-codigo).
                    run utp/ut-msgs.p (input "msg",
                                       input 18846,
                                       input string(rowObject.mo-codigo) + "~~" + 
                                             string(cotacao-item.mo-codigo)).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 18846
                           tt-bo-erro.mensagem     = return-value.
                end.
            end.
        end.
        else do: 
            for first {&TABLE-NAME} fields({&TABLE-NAME}.mo-codigo {&TABLE-NAME}.cod-emitente-desp)
                where {&TABLE-NAME}.cod-agrup         = rowObject.cod-agrup and
                      {&TABLE-NAME}.mapa-ordem        = rowObject.mapa-ordem and
                      {&TABLE-NAME}.cod-emitente-desp = rowObject.cod-emitente-desp and
                      {&TABLE-NAME}.cod-desp         <> rowObject.cod-desp no-lock:
                if rowObject.mo-codigo <> {&TABLE-NAME}.mo-codigo then do:
                    assign i-seq-erro = i-seq-erro + 1.
                    create tt-bo-erro.
                    assign tt-bo-erro.parametros = string(rowObject.mo-codigo) + "~~" + 
                                                   string({&TABLE-NAME}.mo-codigo) + "~~" +
                                                   string({&TABLE-NAME}.cod-emitente-desp).
                    run utp/ut-msgs.p (input "msg",
                                       input 18848,
                                       input string(rowObject.mo-codigo) + "~~" + 
                                             string({&TABLE-NAME}.mo-codigo) + "~~" +
                                             string({&TABLE-NAME}.cod-emitente-desp)).
                    assign tt-bo-erro.i-sequen     = i-seq-erro
                           tt-bo-erro.cd-erro      = 18848
                           tt-bo-erro.mensagem     = return-value.
                end.
            end.
        end.    
    &ENDIF
end.

/* BOCX085.I3 */
