Atualiza_Block:
DO  ON ERROR  UNDO Atualiza_Block, LEAVE Atualiza_Block
    ON QUIT   UNDO Atualiza_Block, LEAVE Atualiza_Block
    ON STOP   UNDO Atualiza_Block, LEAVE Atualiza_Block
    ON ENDKEY UNDO Atualiza_Block, LEAVE Atualiza_Block TRANSACTION:
    
    DO  ON STOP UNDO, LEAVE:
        &IF "{&mgadm_version}" >= "2.04" &THEN
            if  l-execucao-orcamentaria = yes then do:

                {cdp/cd1202.i3 empresa.ep-codigo}
    
                IF NOT l-conec-bas OR
                   NOT l-conec-fin OR
                   NOT l-conec-uni THEN DO:
    
                   run utp/ut-msgs.p (input "show",
                                      input 30648,
                                      input "":U).

                    UNDO Atualiza_Block, LEAVE Atualiza_Block.
    
                END.
            END.
        &ENDIF
    END.

    FOR EACH lin-i-ap FIELDS(ep-codigo  
                             cod-estabel
                             cod-fornec 
                             cod-esp    
                             serie      
                             nr-docto   
                             parcela    
                             referencia) NO-LOCK
        WHERE lin-i-ap.ep-codigo  = doc-i-ap.ep-codigo
        AND   lin-i-ap.referencia = doc-i-ap.referencia:
        {app/ap6001.i1 lin-i-ap
                       lin-i-ap.referencia
                       doc-i-ap.data-movto
                       0}
    END.
        
    run app/ap0501db.p (input rowid(doc-i-ap)).
    run app/ap0501e.p  (input rowid(doc-i-ap)).
        
    RUN app/ap6001.p (INPUT  TABLE tt-consiste-bloqueio-ap,
                      OUTPUT TABLE tt-retorno-bloqueio-ap).
    
    FIND FIRST tt-retorno-bloqueio-ap NO-ERROR.
    IF  AVAIL tt-retorno-bloqueio-ap THEN DO:   
        RUN app/ap6001a.w (INPUT TABLE tt-retorno-bloqueio-ap).
        UNDO Atualiza_Block, LEAVE Atualiza_Block.
    END.

END.
