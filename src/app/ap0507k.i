/*******************************************************************************
**
**  PROGRAMA: AP0507K.I
**
**  Atualiza‡Æo da altera‡Æo de cheques.
**
********************************************************************************/

find first mov-ap
     where mov-ap.ep-codigo    = b-che-emit.ep-codigo
     and   mov-ap.cod-estabel  = b-che-emit.cod-estabel
     and   mov-ap.cod-esp      = b-che-emit.cod-esp
     and   mov-ap.serie        = b-che-emit.serie
     and   mov-ap.nr-docto     = b-che-emit.nr-docto
     and   mov-ap.parcela      = b-che-emit.parcela
     and   mov-ap.cod-fornec   = b-che-emit.cod-fornec
     and   mov-ap.portador     = b-che-emit.portador
     and   mov-ap.nr-cheque    = b-che-emit.nr-cheque
     and   mov-ap.transacao    = b-che-emit.transacao exclusive-lock no-error.
                    
if  avail mov-ap then do:
    /*---- INTEGRA€åES - ELIMINA€ÇO ----*/     
    {app/ap9100.i2}
    assign tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
           tt-integ-ap.tt-cb0201a     = yes 
           tt-integ-ap.tt-ge0102b     = yes
           tt-integ-ap.tt-ge0102g     = yes
           tt-integ-ap.tt-op-cb0201a  = 6
           tt-integ-ap.tt-op-ge0102b  = 6
           tt-integ-ap.tt-op-ge0102g  = 6.
    raw-transfer tt-integ-ap to raw-integracao.
    run app/ap9100.p (Input raw-integracao, input-output table tt-erro).
                
    assign mov-ap.nr-cheque    = i-nr-cheque-nov-atz
           mov-ap.nr-docto-emp = string(mov-ap.nr-cheque).
   
    /******************** Multiplanta ***********************/  
    run pi-cria-tt-dados (input 2).
    /****************** Fim-Multiplanta ********************/        
end.
    
ASSIGN l-cheque = NO.

find first portador 
     where portador.ep-codigo    = b-che-emit.ep-codigo
     and   portador.cod-portador = b-che-emit.portador
     and   portador.modalidade   = 1 no-lock no-error.
            
if  avail portador then do:
    if  l-substituiu = yes then do:
        
        find first cheque
             where cheque.cod-banco        = portador.cod-banco
             and   cheque.agencia          = portador.agencia
             and   cheque.conta-corren     = portador.conta-corren
             and   cheque.nr-cheque        = i-nr-cheque-nov-atz EXCLUSIVE-LOCK no-error.
             
        if  avail cheque then do:                        
            /******************** Multiplanta ***********************/  
             run pi-cria-tt-dados-cheque (input 3).
            /****************** Fim-Multiplanta ********************/ 
            
            IF l-alt-pag = YES THEN DO:
                find first b-cheque
                     where b-cheque.cod-banco        = portador.cod-banco
                     and   b-cheque.agencia          = portador.agencia
                     and   b-cheque.conta-corren     = portador.conta-corren
                     and   b-cheque.nr-cheque        = b-che-emit.nr-cheque EXCLUSIVE-LOCK no-error.
                IF AVAIL b-cheque THEN DO:
                    ASSIGN l-cheque         = YES 
                           cheque.vl-cheque = cheque.vl-cheque + b-che-emit.valor-docto.
                           
                    IF b-cheque.vl-cheque = b-che-emit.valor-docto THEN
                        DELETE b-cheque.
                    ELSE 
                        ASSIGN b-cheque.vl-cheque = b-cheque.vl-cheque - b-che-emit.valor-docto. 
                END.
            END.
            ELSE DO:               
                find first b-cheque
                     where b-cheque.cod-banco        = portador.cod-banco
                     and   b-cheque.agencia          = portador.agencia
                     and   b-cheque.conta-corren     = portador.conta-corren
                     and   b-cheque.nr-cheque        = b-che-emit.nr-cheque EXCLUSIVE-LOCK no-error.
                IF AVAIL b-cheque THEN DO:              
                    ASSIGN b-cheque.vl-cheque = b-cheque.vl-cheque + cheque.vl-cheque.
                    delete cheque.                    
                END.                
            END.
        end.
    end.    
    IF l-cheque = NO THEN DO:    
        find first cheque
             where cheque.cod-banco        = portador.cod-banco
             and   cheque.agencia          = portador.agencia
             and   cheque.conta-corren     = portador.conta-corren
             and   cheque.nr-cheque        = b-che-emit.nr-cheque EXCLUSIVE-LOCK no-error.
                
        if  avail cheque then do:        
            IF l-alt-pag = NO THEN DO:                       
                find first b-cheque
                     where b-cheque.cod-banco        = portador.cod-banco
                     and   b-cheque.agencia          = portador.agencia
                     and   b-cheque.conta-corren     = portador.conta-corren
                     and   b-cheque.nr-cheque        = i-nr-cheque-nov-atz NO-LOCK no-error.

                IF  NOT AVAIL b-cheque THEN
                   assign cheque.nr-cheque = i-nr-cheque-nov-atz.                            
            END.
            ELSE DO:
                IF b-che-emit.valor-docto = cheque.vl-cheque THEN DO:

                    find first b-cheque
                         where b-cheque.cod-banco        = portador.cod-banco
                         and   b-cheque.agencia          = portador.agencia
                         and   b-cheque.conta-corren     = portador.conta-corren
                         and   b-cheque.nr-cheque        = i-nr-cheque-nov-atz NO-LOCK no-error.

                    IF  NOT AVAIL b-cheque THEN
                       assign cheque.nr-cheque = i-nr-cheque-nov-atz. 
                END.   
                ELSE DO:
                    assign cheque.vl-cheque = cheque.vl-cheque - b-che-emit.valor-docto. 
                        
                    find first b-cheque
                         where b-cheque.cod-banco        = portador.cod-banco
                         and   b-cheque.agencia          = portador.agencia
                         and   b-cheque.conta-corren     = portador.conta-corren
                         and   b-cheque.nr-cheque        = i-nr-cheque-nov-atz exclusive-lock no-error.

                    IF  NOT AVAIL b-cheque THEN DO:

                        CREATE b-cheque.
                        BUFFER-COPY cheque EXCEPT cheque.nr-cheque
                                              cheque.num-id-cheque TO b-cheque.

                        ASSIGN b-cheque.nr-cheque = i-nr-cheque-nov-atz.
                        
                    END.

                    ASSIGN b-cheque.vl-cheque     = b-che-emit.valor-docto
                           b-cheque.num-id-cheque = NEXT-VALUE(seq-cheque). 
                END.
            END.
            
            /******************** Multiplanta ***********************/  
            run pi-cria-tt-dados-cheque (input 2).
            /****************** Fim-Multiplanta ********************/        
        end.
    END.
end.

/* Localizacao Argentina */
if v-log-func-utiliz-man-chq = yes and
  (i-pais-impto-usuario = 2 or i-pais-impto-usuario = 6) then do:
    run utp/ut-msgs.p (input "show":U,
                       input 27250,
                       input "").

    if  return-value = "yes" then do:
        create b2-che-emit.
        buffer-copy b-che-emit except num-id-che-emit to b2-che-emit.
        assign b2-che-emit.cancelado  = yes
               b2-che-emit.dt-cancela = today.
    end.
end.

assign b-che-emit.nr-cheque = i-nr-cheque-nov-atz.
        
/******************** Multiplanta ***********************/  
run pi-cria-tt-dados-b-che (input 2).
/****************** Fim-Multiplanta ********************/
                    
if  avail mov-ap then do:
    /*---- INTEGRA€åES - INCLUSÇO ----*/     
    {app/ap9100.i2}
    assign tt-integ-ap.tt-row-mov-ap  = rowid(mov-ap)
           tt-integ-ap.tt-cb0201a     = yes
           tt-integ-ap.tt-ge0102b     = yes
           tt-integ-ap.tt-ge0102g     = yes
           tt-integ-ap.tt-op-cb0201a  = 16
           tt-integ-ap.tt-op-ge0102b  = 16
           tt-integ-ap.tt-op-ge0102g  = 16.
    raw-transfer tt-integ-ap to raw-integracao.
    run app/ap9100.p (Input raw-integracao, input-output table tt-erro).
end.

/* app/ap0507k.i */
