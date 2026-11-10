PROCEDURE geraLiterais_Embarque:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Embarque" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    

    ASSIGN hTable  = BUFFER embarque-imp:HANDLE
           prefixo = "#lit-emb-".
           
    RUN substitui-label (INPUT "mgcex",
                         INPUT "embarque-imp").    
END PROCEDURE.

PROCEDURE geraLiterais_Processo:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Processo" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).        

    ASSIGN hTable  = BUFFER processo-imp:HANDLE
           prefixo = "#lit-proc-".
           
    RUN substitui-label (INPUT "mgcex",
                         INPUT "processo-imp").        
END PROCEDURE.

PROCEDURE geraLiterais_Pedido:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Pedido" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    

    ASSIGN hTable  = BUFFER pedido-compr:HANDLE
           prefixo = "#lit-ped-".
           
    RUN substitui-label (INPUT "movind",
                         INPUT "pedido-compr").        
END PROCEDURE.

PROCEDURE geraLiterais_CondPagto:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Condi‡Æo_Pagamento" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    

    ASSIGN hTable  = BUFFER cond-pagto:HANDLE
           prefixo = "#lit-cond-pagto-".
           
    RUN substitui-label (INPUT "mgadm",
                         INPUT "cond-pagto").        
END PROCEDURE.


PROCEDURE geraLiterais_Banco:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Banco" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    
    ASSIGN hTable  = BUFFER banco:HANDLE
           prefixo = "#lit-bco-".
           
    RUN substitui-label (INPUT "mgadm",
                         INPUT "banco").           
END PROCEDURE.

PROCEDURE geraLiterais_Bco-exp:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Bco-Exp" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    
    ASSIGN hTable  = BUFFER banco:HANDLE
           prefixo = "#lit-bco-exp-".
           
    RUN substitui-label (INPUT "mgadm",
                         INPUT "banco").    
END PROCEDURE.

PROCEDURE geraLiterais_Ag-exp:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Ag-Exp" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    
    ASSIGN hTable  = BUFFER agencia:HANDLE
           prefixo = "#lit-ag-exp-".
           
    RUN substitui-label (INPUT "mgadm",
                         INPUT "agencia").    
END PROCEDURE.

PROCEDURE geraLiterais_Importador:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Importador" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    
    ASSIGN hTable  = BUFFER estabelec:HANDLE
           prefixo = "#lit-imp-".
    
    RUN substitui-label (INPUT "mgadm",
                         INPUT "estabelec").    
END PROCEDURE.

PROCEDURE geraLiterais_Exportador:
    define variable c-label   as character no-undo.
    
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Exportador" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    
    ASSIGN hTable  = BUFFER emitente:HANDLE
           prefixo = "#lit-exp-"
           c-label = "Ramal".
           
    if  tt-param.i-traducao <> 1 then 
        RUN pi-Traducao (INPUT-OUTPUT c-label).

    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-exp-' + '*'):

        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-exp-ramal-modem*') THEN
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-exp-ramal-modem', c-label).

        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-exp-ramal-fac*') THEN
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-exp-ramal-fac', c-label).

        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-exp-ramal-fax*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-exp-ramal-fax', c-label).
    END.
            
    RUN substitui-label (INPUT "mgadm",
                         INPUT "emitente").        

    ASSIGN hTable = BUFFER emitente-cex:HANDLE
          prefixo = "#lit-exp-".
           
    RUN substitui-label (INPUT "mgcex",
                         INPUT "emitente-cex").        
END PROCEDURE.

PROCEDURE geraLiterais_Corretor:
    define variable c-label   as character no-undo.
           
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Corretor" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    
    ASSIGN hTable  = BUFFER emitente:HANDLE
           prefixo = "#lit-corret-"
           c-label = "Ramal".

    if  tt-param.i-traducao <> 1 then 
        RUN pi-Traducao (INPUT-OUTPUT c-label).

    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-corret-' + '*'):
        
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-corret-ramal-modem*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-corret-ramal-modem', c-label).

        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-corret-ramal-fac*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-corret-ramal-fac', c-label).

        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-corret-ramal-fax*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-corret-ramal-fax', c-label).
                
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-corret-cod-aba*') THEN do:
        
            if tt-param.i-traducao <> 1 then 
                 RUN pi-Traducao (INPUT-OUTPUT c-lit-cod-aba).  
        
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-corret-cod-aba', c-lit-cod-aba).    
        end.
            
            
    END.
    
    RUN substitui-label (INPUT "mgadm",
                         INPUT "emitente").    
    
    ASSIGN hTable  = BUFFER emitente-cex:HANDLE
           prefixo = "#lit-exp-".
           
    RUN substitui-label (INPUT "mgcex",
                         INPUT "emitente-cex").    
END PROCEDURE.

PROCEDURE geraLiterais_Comprador:
    define variable c-label   as character no-undo.

    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Comprador" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    

    ASSIGN hTable  = BUFFER comprador:HANDLE
           prefixo = "#lit-comp-"
           c-label = "Ramal".
           
    if  tt-param.i-traducao <> 1 then 
        RUN pi-Traducao (INPUT-OUTPUT c-label).

    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-comp-' + '*'):
        
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-comp-telefax*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-comp-telefax', c-label).
        
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-comp-ramal-modem*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-comp-ramal-modem', c-label).

        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-comp-ramal-fac*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-comp-ramal-fac', c-label).
        
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-comp-ramal-fax*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-comp-ramal-fax', c-label).
    END.

    RUN substitui-label (INPUT "mgind",
                         INPUT "comprador").    
END PROCEDURE.

PROCEDURE geraLiterais_Invoice:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Invoice" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    
    ASSIGN hTable  = BUFFER invoice-emb-imp:HANDLE
           prefixo = "#lit-inv-".
           
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + prefixo + '*'):
        
        DO i-cont = 1 TO hTable:NUM-FIELDS:
        
            ASSIGN hField = hTable:BUFFER-FIELD(i-cont).
            ASSIGN searchStr = prefixo + hField:NAME.
            
            IF tt-matriz-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN DO:
                RUN utp/ut-field.p (INPUT "mgcex",
                                    INPUT "invoice-emb-imp",
                                    INPUT hField:NAME,
                                    INPUT 1).

                ASSIGN c-label = RETURN-VALUE.
                if tt-param.i-traducao <> 1 then 
                    RUN pi-Traducao (INPUT-OUTPUT c-label).
            
                ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, searchStr, c-label).
            END.
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-inv-mo-desc*') THEN DO:
            if tt-param.i-traducao <> 1 then 
                RUN pi-Traducao (INPUT-OUTPUT c-lit-mo-desc-inv).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-inv-mo-desc', c-lit-mo-desc-inv).
        END.
    END.        
END PROCEDURE.

PROCEDURE geraLiterais_pd-fecha-camb:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Fec-Cambio" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    

    if tt-param.i-traducao <> 1 then 
        RUN pi-traduz-literais-pd-fecha-camb.
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-feccambio-' + '*'):
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-cod-estabel*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-cod-estabel', c-lit-cod-estabel-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-embarque*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-embarque', c-lit-embarque-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-nr-invoice*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-nr-invoice', c-lit-nr-invoice-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-parcela*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-parcela', c-lit-parcela-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-mo-desc*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-mo-desc', c-lit-mo-desc-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-vl-desp*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-vl-desp', c-lit-vl-desp-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-des-meio-transporte*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-des-meio-transporte', c-lit-des-meio-transp-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-vl-merc*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-vl-merc', c-lit-vl-merc-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-vl-total*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-vl-total', c-lit-vl-total-fecCambio).
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-dt-nacionaliz*') THEN
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-dt-nacionaliz', c-lit-dt-nacionaliz-fecCambio).    
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-feccambio-dt-embarque*') THEN 
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-feccambio-dt-embarque', c-lit-dt-embarque-fecCambio).
    END.
    
    find first tt-matriz-ficha
         WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#LIT-COTACAO-PARA-FECHAMENTO-DE-CAMBIO' + '*') no-lock no-error.
    if avail tt-matriz-ficha then
        ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#LIT-COTACAO-PARA-FECHAMENTO-DE-CAMBIO', c-lit-cotacao-ped-fecCambio).
    
    find first tt-matriz-ficha
         WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#LIT-PEDIDO-DE-FECHAMENTO-DE-CAMBIO' + '*') no-lock no-error.
    if avail tt-matriz-ficha then
        ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#LIT-PEDIDO-DE-FECHAMENTO-DE-CAMBIO', c-lit-ped-fecCambio).
    
    find first tt-matriz-ficha
         WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-Corretor-Cambio' + '*') no-lock no-error.
    if avail tt-matriz-ficha then
        ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-Corretor-Cambio', c-lit-corretor-cambio).
        
    find first tt-matriz-ficha
         WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-Condicao-de-Pagamento' + '*') no-lock no-error.
    if avail tt-matriz-ficha then
        ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-Condicao-de-Pagamento', c-lit-condicao-pagamento).
        
    find first tt-matriz-ficha
         WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-dados-deposito' + '*') no-lock no-error.
    if avail tt-matriz-ficha then
        ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-dados-deposito', c-lit-dados-deposito).
        
    find first tt-matriz-ficha
         WHERE tt-matriz-ficha.c-linha MATCHES ('*' + '#lit-Agencia' + '*') no-lock no-error.
    if avail tt-matriz-ficha then
        ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-Agencia', c-lit-agencia).
    
END PROCEDURE.

PROCEDURE substitui-label:
    DEFINE INPUT PARAMETER c-banco  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER c-tabela AS CHARACTER NO-UNDO.
    
    FOR EACH tt-matriz-ficha
        WHERE tt-matriz-ficha.c-linha MATCHES ('*' + prefixo + '*'):
        
        DO i-cont = 1 TO hTable:NUM-FIELDS:
            
            ASSIGN hField = hTable:BUFFER-FIELD(i-cont).        
        
            IF hField:EXTENT > 0 THEN DO:
                 DO i-cont-2 = 1 TO hField:EXTENT:
                     ASSIGN searchStr = prefixo + hField:NAME + "-" + STRING(i-cont-2).
                     
                     IF tt-matriz-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN DO:                       
                         RUN utp/ut-field.p (INPUT c-banco,
                                             INPUT c-tabela,
                                             INPUT hField:NAME,
                                             INPUT 1).
        
                         ASSIGN c-label = RETURN-VALUE.
                         if tt-param.i-traducao <> 1 then 
                             RUN pi-Traducao (INPUT-OUTPUT c-label).
                     
                         ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, searchStr, c-label).
                         
                     end.     
                 END.
            END.    
            else do:
                
                ASSIGN searchStr = prefixo + hField:NAME.
                    
                IF tt-matriz-ficha.c-linha MATCHES ('*' + searchStr + '*') THEN DO:                       
                     RUN utp/ut-field.p (INPUT c-banco,
                                         INPUT c-tabela,
                                         INPUT hField:NAME,
                                         INPUT 1).
        
                     ASSIGN c-label = RETURN-VALUE.
                     if tt-param.i-traducao <> 1 then 
                         RUN pi-Traducao (INPUT-OUTPUT c-label).
                     ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, searchStr, c-label).
                END.
            end.           
        END.
    END.
END PROCEDURE.

PROCEDURE geraLiterais_Espec:
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gera_Literais_Espec" *}
    RUN pi-acompanhar in h-acomp (RETURN-VALUE).    
    /*Abertura para Customiza‡Æo */
    DO  i-cont = 1 TO 20:
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-cabec-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-cabec-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-cabec-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-pedidos-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-pedidos-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-pedidos-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-valores-inv-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-valores-env-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-valores-inv-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-valores-emb-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-valores-emb-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-valores-emb-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-depos-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-depos-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-depos-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-doctos-inv-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-doctos-inv-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-doctos-inv-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-doctos-emb-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-doctos-emb-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-doctos-emb-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-invoice-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-invoice-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-invoice-' + trim(string(i-cont)), c-literal).
        END.
        IF  tt-matriz-ficha.c-linha MATCHES('*#lit-var-espec-cotacao-' + trim(string(i-cont)) + '*') THEN DO:
            RUN LiteraisEspec IN h-im0660b (INPUT "#lit-var-espec-cotacao-" + trim(string(i-cont)),
                                            OUTPUT c-literal).
            ASSIGN tt-matriz-ficha.c-linha = REPLACE(tt-matriz-ficha.c-linha, '#lit-var-espec-cotacao-' + trim(string(i-cont)), c-literal).
        END.
    END.
END PROCEDURE.





