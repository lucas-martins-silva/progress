
    RUN verificaFiscalFisico(INPUT pr-nota).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    DEFINE VARIABLE c-liter-erro-tipo-operac  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-liter-nf-cred-deb    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cnpj-destino         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-modelo               AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cod-depos            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cod-localiz          AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cod-refer            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-fat-consig AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-rateio     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lbl-liter-reaj-preco AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg-estab-cnpj-dest  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg-cgc-dif-cnpj     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-msg-aux              AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-lista-naturezas      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-saldo-ok             AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-erro-saldo           AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-altera-dt-trans      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-bloq-item-branco     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-devol-cli            AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-desconto-item        AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-outros-item          AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-voutro-it            AS LOGICAL   NO-UNDO.  
    DEFINE VARIABLE l-seguro-item          AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-vseg-it              AS LOGICAL   NO-UNDO.  
    DEFINE VARIABLE l-frete-item           AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-vfrete-it            AS LOGICAL   NO-UNDO.  
    DEFINE VARIABLE l-sem-pedido           AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-existe-ret-benef     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-existe-mat-agreg     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE i-seq-item-maior-valor AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-ctrl-quebra          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-nr-ord-produ         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-cont-aux             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE de-total-frete         AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-total-seguro        AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-total-outros        AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-maior-valor-item    AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-desconto-item       AS DECIMAL   NO-UNDO. /* Armazena o desconto do item corrente.     */
    DEFINE VARIABLE de-seguro-item         AS DECIMAL   NO-UNDO. /* Armazena o seguro do item corrente.       */
    DEFINE VARIABLE de-outros-item         AS DECIMAL   NO-UNDO. /* Armazena outros valores do item corrente. */
    DEFINE VARIABLE de-total-desconto      AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-total-fifo          AS DECIMAL   NO-UNDO. /* Totaliza quantidade selecionada por FIFO para o item.       */
    DEFINE VARIABLE de-total-fifo-emit     AS DECIMAL   NO-UNDO. /* Totaliza quantidade selecionada por FIFO na UN do emitente. */
    DEFINE VARIABLE de-soma-fifo           AS DECIMAL   NO-UNDO. /* Somatorio quantidades FIFO Manual.                          */
    DEFINE VARIABLE de-soma-fifo-emit      AS DECIMAL   NO-UNDO. /* Somatorio quantidades FIFO Manual na UN do emitente.        */
    DEFINE VARIABLE de-soma-outros-fifo    AS DECIMAL   NO-UNDO. /* Variavel utilizada no calculo dos valores do FIFO Manual.   */
    DEFINE VARIABLE de-soma-seguro-fifo    AS DECIMAL   NO-UNDO. /* Variavel utilizada no calculo dos valores do FIFO Manual.   */
    DEFINE VARIABLE de-soma-desconto-fifo  AS DECIMAL   NO-UNDO. /* Variavel utilizada no calculo dos valores do FIFO Manual.   */
    DEFINE VARIABLE de-soma-frete-fifo     AS DECIMAL   NO-UNDO. /* Variavel utilizada no calculo dos valores do FIFO Manual.   */
    DEFINE VARIABLE de-frete-unit          AS DECIMAL   NO-UNDO. /* Variavel utilizada no calculo dos valores do FIFO Manual.   */
    DEFINE VARIABLE de-outros-unit         AS DECIMAL   NO-UNDO. /* Variavel utilizada no calculo dos valores do FIFO Manual.   */
    DEFINE VARIABLE de-seguro-unit         AS DECIMAL   NO-UNDO. /* Variavel utilizada no calculo dos valores do FIFO Manual.   */
    DEFINE VARIABLE de-soma-total-outros   AS DECIMAL   NO-UNDO. /* Soma o total "Outros" de todas as naturezas do conversor.   */
    DEFINE VARIABLE de-soma-total-seguro   AS DECIMAL   NO-UNDO. /* Soma o total "Seguro" de todas as naturezas do conversor.   */
    DEFINE VARIABLE de-soma-total-frete    AS DECIMAL   NO-UNDO. /* Soma o total "Frete" de todas as naturezas do conversor.    */
    DEFINE VARIABLE de-soma-total-desconto AS DECIMAL   NO-UNDO. /* Soma o total "Desconto" de todas as naturezas do conversor. */        
    DEFINE VARIABLE de-desconto-unit       AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE de-total-desp-docto    AS DECIMAL   NO-UNDO.
    define variable l-ok                   as log       no-undo.
    DEFINE VARIABLE c-nat-oper-aux         LIKE natur-oper.nat-operacao     NO-UNDO.
    DEFINE VARIABLE de-seq-item-ant        LIKE rat-lote-medic-nfe.seq-item NO-UNDO.
    DEFINE VARIABLE c-liter-1              AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE c-liter-2              AS CHARACTER                     NO-UNDO.
    DEFINE VARIABLE c-liter-3              AS CHARACTER                     NO-UNDO.
    
    EMPTY TEMP-TABLE tt-rat-ordem.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-seq-saldo-terc.
    EMPTY TEMP-TABLE tt-rat-ordem-orig-nfe-aux.
    
    DEFINE BUFFER b-natur-oper-doc FOR natur-oper.
    
    ASSIGN l-erro-doc-proc-fis    = NO
           l-erro-item-proc-fis   = NO
           l-erro-rat-proc-fis    = NO
           l-warning              = NO
           l-erro-saldo           = NO
           de-total-desp-docto    = 0
           de-total-frete         = 0
           de-total-seguro        = 0   
           de-total-outros        = 0
           i-tipo-nota            = 0
           i-seq-item-maior-valor = 0
           de-maior-valor-item    = 0.

    {utp/ut-liter.i "Fatura_Consig" *}
    ASSIGN c-lbl-liter-fat-consig = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Rateio" *}
    ASSIGN c-lbl-liter-rateio = TRIM(RETURN-VALUE).
    {utp/ut-liter.i "Reajuste_de_Preáo" *}
    ASSIGN c-lbl-liter-reaj-preco = TRIM(RETURN-VALUE).

    /* --------->> Busca ParÉmetros */
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF  NOT AVAIL param-global THEN
        RETURN "NOK":U.

    FIND FIRST param-re NO-LOCK
        WHERE param-re.usuario = c-seg-usuario NO-ERROR.
    IF NOT VALID-HANDLE(h-boin01109) THEN
        RUN inbo/boin01109.p PERSISTENT SET h-boin01109.    

    IF NOT VALID-HANDLE(h-boin862) /* BO param-convrsr-nfe */
        OR h-boin862:TYPE      <> "PROCEDURE":U
        OR h-boin862:FILE-NAME <> "inbo/boin862.p":U THEN
        RUN inbo/boin862.p PERSISTENT SET h-boin862.
    
    RUN openQueryStatic IN h-boin862 (INPUT "Main":U) NO-ERROR.
    RUN getFirst IN h-boin862.

    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    ELSE DO:
        RUN getLogField IN h-boin862 (INPUT "log-altera-dat-trans":U, OUTPUT l-altera-dt-trans).
        RUN getLogField IN h-boin862 (INPUT "log-bloq-item-branco":U, OUTPUT l-bloq-item-branco).
    END.
    /* ----->> FIM Busca ParÉmetros */
    

    /* ----->> TRADUÄÂES */
    {utp/ut-liter.i "N∆o_existe_estabelecimento_para_o_CNPJ_destino._A_nota_deve_ser_cancelada." *}
    ASSIGN c-msg-estab-cnpj-dest = TRIM(RETURN-VALUE).

    {utp/ut-liter.i "CGC_do_Estabelecimento_difere_do_CNPJ/CPF_de_destino_da_nota." *}
    ASSIGN c-msg-cgc-dif-cnpj = TRIM(RETURN-VALUE).
    
    /* ----->> FIM TRADUÄÂES */
    
    /****** PONTO UPC COFCO *******/
    if  c-nom-prog-upc-mg97 <> "" then do:
       for each  tt-epc
           where tt-epc.cod-event = "inicioProcessaFisico":
           delete tt-epc.
       end.
        
       create tt-epc.
       assign tt-epc.cod-event     = "inicioProcessaFisico"
              tt-epc.cod-parameter = "doc-orig-nfe-rowid"
              tt-epc.val-parameter = string(pr-nota).
              
       {include/i-epc201.i "inicioProcessaFisico"}
        
       for first tt-epc
           where tt-epc.cod-event     = "inicioProcessaFisico"
           and   tt-epc.cod-parameter = "erro":
           assign l-erro-doc-proc-fis = YES.
           return "NOK":U.
       end.
    end.
    /*****************************/

    FOR FIRST bf{&TableName} exclusive-lock
        WHERE ROWID(bf{&TableName}) = pr-nota:

        FOR FIRST estabelec FIELDS(ep-codigo)
            WHERE estabelec.cod-estabel = bf{&TableName}.cod-estabel NO-LOCK:
            ASSIGN i-empresa = estabelec.ep-codigo.
        END.
        
        FOR EACH bfmsg-ret-nfe EXCLUSIVE-LOCK
           WHERE bfmsg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
             AND bfmsg-ret-nfe.idi-orig-trad      = 2
             AND bfmsg-ret-nfe.log-ativo          = YES:

            ASSIGN bfmsg-ret-nfe.log-ativo = NO.
        END.
        RELEASE bfmsg-ret-nfe.
        
        IF  NOT AVAIL param-re THEN DO:
            RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe, 
                             INPUT 2,
                             INPUT "O usu†rio que est† gerando o documento (" + c-seg-usuario + ") n∆o possui cadastro no recebimento (RE0101)",
                             INPUT 0).
            ASSIGN l-erro-doc-proc-fis  = YES
                   l-erro-item-proc-fis = YES
                   l-erro-rat-proc-fis  = YES.
            RELEASE msg-ret-nfe.
            RETURN.
        END.
        
        /*Comparativo - Bloqueia geraá∆o NF com divergància*/
        
        RUN emptyRowErrors  IN h-boin01109.
        RUN bloqueiaEntradaNfeComDivergencia IN h-boin01109 (INPUT bf{&TableName}.ch-acesso-comp-nfe).
        RUN getRowErrors    IN h-boin01109 (OUTPUT TABLE RowErrors).
        IF can-find (first RowErrors
                     where RowErrors.ErrorType <> "INTERNAL":U) THEN DO:
        
           RUN rowErrorsToMsgRetNFe (bf{&TableName}.ch-acesso-comp-nfe, YES, INPUT TABLE RowErrors).
           ASSIGN l-erro-doc-proc-fis  = YES
                  l-erro-item-proc-fis = YES
                  l-erro-rat-proc-fis  = YES.
           RETURN.       
        END.
       
        /***************************************************/

        /* ê Necess†rio estar dentro de um transaá∆o, pois caso contr†rio   **
        ** aparecer† um alerta em tempo de execuá∆o.                        */
        DO  TRANS:
            IF bf{&TableName}.cnpj-destino <> "99999999000191" THEN 
                ASSIGN c-cnpj-destino = bf{&TableName}.cnpj-destino.
            ELSE
                ASSIGN c-cnpj-destino = bf{&TableName}.cnpj.
                
            FIND FIRST estabelec NO-LOCK WHERE estabelec.cgc = c-cnpj-destino NO-ERROR.
            
            IF  NOT AVAIL estabelec THEN DO:
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe, 
                                 INPUT 17567,
                                 INPUT c-msg-estab-cnpj-dest,
                                 INPUT 0).
                ASSIGN l-erro-doc-proc-fis  = YES
                       l-erro-item-proc-fis = YES
                       l-erro-rat-proc-fis  = YES.
                RELEASE msg-ret-nfe.
                RETURN.
            END.
            ELSE DO:
                /* Alterado para validar o estabelecimento de acordo com o CNPJ de destino */
                IF  NOT CAN-FIND(FIRST estabelec
                                 WHERE estabelec.cod-estabel = bf{&TableName}.cod-estabel
                                 AND ( (c-cnpj-destino <> ? AND estabelec.cgc = c-cnpj-destino)
                                       OR (bf{&TableName}.cpf-destino <> ? AND estabelec.cgc = bf{&TableName}.cpf-destino)) ) THEN DO:
                    
                    RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe, 
                                     INPUT 17567,
                                     INPUT c-msg-cgc-dif-cnpj,
                                     INPUT 0).
                    ASSIGN l-erro-doc-proc-fis  = YES
                           l-erro-item-proc-fis = YES
                           l-erro-rat-proc-fis  = YES.
                    RELEASE msg-ret-nfe.
                    RETURN.
                END.
            END.
        END.
        
        /* ê Necess†rio estar dentro de um transaá∆o, pois caso contr†rio   **
        ** aparecer† um alerta em tempo de execuá∆o.                        */
        DO  TRANS:
            IF  NOT CAN-FIND(FIRST emitente
                             WHERE emitente.cod-emitente = bf{&TableName}.cod-emitente
                             AND ( (bf{&TableName}.cnpj <> ? AND SUBSTRING(emitente.cgc,1,8) = SUBSTRING(bf{&TableName}.cnpj,1,8))
                                   OR (bf{&TableName}.cpf <> ? AND emitente.cgc = bf{&TableName}.cpf))) THEN DO:
                
                {utp/ut-liter.i "CGC_do_Emitente" *}
                ASSIGN c-msg-aux = RETURN-VALUE + " " + STRING(bf{&TableName}.cod-emitente) + " ".
                {utp/ut-liter.i "difere_do_CNPJ/CPF_de_origem_da_nota." *}
                ASSIGN c-msg-aux = c-msg-aux + RETURN-VALUE.
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                 INPUT 17006,
                                 INPUT c-msg-aux,
                                 INPUT 0).
                ASSIGN l-erro-doc-proc-fis  = YES
                       l-erro-item-proc-fis = YES
                       l-erro-rat-proc-fis  = YES.
                RELEASE msg-ret-nfe.
                RETURN.
            END.
        END.

        /* Fornecedor Emite Documento Eletronico */
        IF CAN-FIND(FIRST emitente 
                    WHERE emitente.cod-emitente = bf{&TableName}.cod-emitente
                      AND ((NOT emitente.log-nf-eletro        AND emitente.identific <> 2) OR
                           (NOT emitente.log-possui-nf-eletro AND emitente.identific <> 1))) THEN DO:
            FOR FIRST emitente EXCLUSIVE-LOCK
                WHERE emitente.cod-emitente = bf{&TableName}.cod-emitente:
                ASSIGN emitente.log-nf-eletro        = YES WHEN emitente.identific <> 2
                       emitente.log-possui-nf-eletro = YES WHEN emitente.identific <> 1.
            END.
            RELEASE emitente.
        END.
        
        FOR EACH tt-doc-fisico EXCLUSIVE-LOCK:
            DELETE tt-doc-fisico.
        END.
        FOR EACH tt-it-doc-fisico EXCLUSIVE-LOCK:
            DELETE tt-it-doc-fisico.
        END.

        IF  NOT VALID-HANDLE(h-boin857)
            OR h-boin857:TYPE      <> "PROCEDURE":U
            OR h-boin857:FILE-NAME <> "inbo/boin857.p":U THEN
            RUN inbo/boin857.p PERSISTENT SET h-boin857.

      /* Esta procedure deve ser executada para garantir que notas antigas,
         que tenham natureza de operacao em algum item, tenham o tipo de operacao 
         gravado no campo int-1 ao processar fisico no conversor. */
        RUN atualizaTipoOperPelaNatur IN h-boin857(INPUT bf{&TableName}.ch-acesso-comp-nfe).

        DO  TRANS:
            RUN validaDevolSimbolica.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                {utp/ut-liter.i "Devoluá∆o_simb¢lica_de_consignaá∆o" *}
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 52045,
                                   INPUT RETURN-VALUE).
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                 INPUT 52045,
                                 INPUT RETURN-VALUE,
                                 INPUT 0).
                ASSIGN l-erro-doc-proc-fis  = YES
                       l-erro-item-proc-fis = YES
                       l-erro-rat-proc-fis  = YES.
                RELEASE msg-ret-nfe.
                RETURN.
            END.
        END.
        
        /* CONSISTENCIAS */
        FOR EACH item-doc-orig-nfe OF bf{&TableName} EXCLUSIVE-LOCK:
          
            IF  item-doc-orig-nfe.int-2 = 0  THEN DO:  /* Nao definido */
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 54499, /* Tipo de Operacao nao definido. */
                                   INPUT item-doc-orig-nfe.seq-item).
                ASSIGN c-liter-erro-tipo-operac = RETURN-VALUE.
                RUN utp/ut-msgs.p (INPUT "HELP":U,
                                   INPUT 54499,
                                   INPUT item-doc-orig-nfe.seq-item).               
                ASSIGN c-liter-erro-tipo-operac = c-liter-erro-tipo-operac + " " + RETURN-VALUE.
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                 INPUT 54499,
                                 INPUT c-liter-erro-tipo-operac,
                                 INPUT 1).              
                ASSIGN l-erro-doc-proc-fis  = YES
                       l-erro-item-proc-fis = YES
                       l-erro-rat-proc-fis  = YES.
                RELEASE msg-ret-nfe.
                RETURN.
            END.
            ELSE IF  item-doc-orig-nfe.int-2 = 2 THEN DO: /* Devolucao de cliente */
                IF  NOT CAN-FIND(FIRST item-ref-nfe NO-LOCK
                                 WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                                   AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item) THEN DO:
                    
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                                       INPUT 52356, /* Item &1 nao possui nota de sa°da vinculada */
                                       INPUT item-doc-orig-nfe.it-codigo).
                    RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                     INPUT 52356,
                                     INPUT RETURN-VALUE,
                                     INPUT 2).
                    RELEASE msg-ret-nfe.                   
                END.
            END.
            ELSE IF (item-doc-orig-nfe.int-2 = 5  /* Retorno Beneficiamento  */	
                 OR  item-doc-orig-nfe.int-2 = 8  /* Devoluc∆o Consignacao   */
                 OR  item-doc-orig-nfe.int-2 = 19 /* Retorno Dep Fechado */
                 OR  item-doc-orig-nfe.int-2 = 21) THEN DO: /*Retorno Armaz Geral*/
                    
                IF  NOT CAN-FIND(FIRST item-ref-nfe NO-LOCK
                                 WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                                   AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item) THEN DO:

                    {utp/ut-liter.i "Vincular_nota_de_sa°da" *}
                    RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 52312, /* Item &1 nao possui saldo em poder de terceiro vinculado. &2 */
                               INPUT item-doc-orig-nfe.it-codigo + "~~" + RETURN-VALUE).
                    RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                         INPUT 52312,
                                         INPUT RETURN-VALUE,
                                         INPUT 0).
                    ASSIGN l-erro-doc-proc-fis  = YES
                           l-erro-item-proc-fis = YES
                           l-erro-rat-proc-fis  = YES.
                    RELEASE msg-ret-nfe.
                    RETURN.
                END.
            END.
            ELSE IF item-doc-orig-nfe.int-2 = 7  OR /* Fatura Consig. */
                    item-doc-orig-nfe.int-2 = 10 OR /* Nota Rateio */ 
                    item-doc-orig-nfe.int-2 = 12    /* Reajuste de Preco */  THEN DO:                
                    
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 52045, /* Notas de &1 devem entrar pelo recebimento fiscal */
                                   INPUT IF item-doc-orig-nfe.int-2 = 7 THEN c-lbl-liter-fat-consig  
                                         ELSE IF item-doc-orig-nfe.int-2 = 10 THEN c-lbl-liter-rateio
                                         ELSE c-lbl-liter-reaj-preco). 
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                 INPUT 52045,
                                 INPUT RETURN-VALUE,
                                 INPUT 0).
                ASSIGN l-erro-doc-proc-fis  = YES
                       l-erro-item-proc-fis = YES
                       l-erro-rat-proc-fis  = YES.
               RELEASE msg-ret-nfe.
               RETURN.
            
            END.
        
            /* Valida se a natureza de operaá∆o est† ATIVA */
            FOR FIRST natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao
                  AND natur-oper.nat-ativa    = NO:
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 26759,  /*Natureza de operaá∆o invalida*/  
                                   INPUT "").
                         
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                 INPUT 26759,
                                 INPUT RETURN-VALUE,
                                 INPUT 1).
                ASSIGN l-erro-item-proc-fis = YES.
                RELEASE msg-ret-nfe.
                RETURN.
            END.    
            
            IF  item-doc-orig-nfe.cod-depos   = ""
            AND item-doc-orig-nfe.cod-localiz = ""
            AND item-doc-orig-nfe.int-2      <> 3  /* Transferencia */
            AND NOT CAN-FIND(FIRST item-ref-nfe
                             WHERE item-ref-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                               AND item-ref-nfe.seq-item           = item-doc-orig-nfe.seq-item) THEN DO:
                RUN findOrdemCompra     IN h-boin857 (INPUT item-doc-orig-nfe.numero-ordem).
                RUN retornaDeposLocaliz IN h-boin857 (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                      INPUT item-doc-orig-nfe.it-codigo,
                                                      INPUT item-doc-orig-nfe.nat-operacao,
                                                      INPUT-OUTPUT item-doc-orig-nfe.cod-depos,
                                                      INPUT-OUTPUT item-doc-orig-nfe.cod-localiz).
                RUN alteraItemAnterior  IN h-boin857 (INPUT "?").
            END.

        END. /* ...for each */

            
        EMPTY TEMP-TABLE  tt-tipo-operacao NO-ERROR.
        FOR EACH item-doc-orig-nfe FIELDS(it-codigo ch-acesso-comp-nfe seq-item nat-operacao int-2 cod-cfop) OF bf{&TableName} NO-LOCK:

            IF item-doc-orig-nfe.nat-operacao <> "" THEN
                FOR FIRST natur-oper 
                    WHERE natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao NO-LOCK:
                    IF  natur-oper.cod-model-nf-eletro <> "55" 
                    AND natur-oper.cod-model-nf-eletro <> "65" THEN DO:
                        RUN utp/ut-msgs.p(INPUT "msg":U,
                                          INPUT 55197,  /* Natureza de operacao  nao possui Modelo Eletronico! */
                                          INPUT natur-oper.nat-operacao).
                        RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                         INPUT 55197,
                                         INPUT RETURN-VALUE,
                                         INPUT 1).
                        ASSIGN l-erro-doc-proc-fis  = YES
                               l-erro-item-proc-fis = YES
                               l-erro-rat-proc-fis  = YES.
                        RELEASE msg-ret-nfe.
                        RETURN.
                    END.
                    
                    
                    IF natur-oper.tipo-compra = 9 THEN DO: /*Nota CrÇdito/DÇbito*/
                    
                       {utp/ut-liter.i pelo_recebimento_f°sico * r }
                       ASSIGN c-liter-nf-cred-deb = TRIM(RETURN-VALUE).
                       RUN utp/ut-msgs.p (INPUT "msg":U,
                                          INPUT 58157, /* Tipo de operaá∆o Nota CrÇdito/DÇbito inv†lida*/
                                          INPUT "").
                    
                       RUN utp/ut-msgs.p (INPUT "HELP":U,
                                          INPUT 58157, /* Existem itens com o primeiro digito do CFOP diferentes. */
                                          INPUT c-liter-nf-cred-deb). 
                       ASSIGN c-liter-nf-cred-deb = c-liter-erro-tipo-operac + " ":U + RETURN-VALUE. 
                       
                    
                       RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                        INPUT 58157,
                                        INPUT c-liter-nf-cred-deb,
                                        INPUT 1).
                       ASSIGN l-erro-doc-proc-fis  = YES
                              l-erro-item-proc-fis = YES
                              l-erro-rat-proc-fis  = YES.                 
                       RELEASE msg-ret-nfe.
                       RETURN.                     
                    END.   
                    IF  (   bf{&TableName}.cod-finalidade = '5'   /*finalidade crÇdito*/
                         OR bf{&TableName}.cod-finalidade = '6')  /*finalidade dÇbito*/
                    AND natur-oper.tipo-compra <> 9 /*nota crÇdito/dÇbito*/ THEN DO:
                            IF bf{&TableName}.cod-finalidade = '5' THEN DO:
                                {utp/ut-liter.i 5(CrÇdito) * r }
                            END.            
                            ELSE DO: 
                               {utp/ut-liter.i 6(DÇbito) * r }
                            END.
                            ASSIGN c-liter-1 = TRIM(RETURN-VALUE).
                            
                            {utp/ut-liter.i natureza_de_operaá∆o_com_o_tipo_compra  * r }
                            ASSIGN c-liter-2 = TRIM(RETURN-VALUE).
                            
                            {utp/ut-liter.i Nota_de_CrÇdito/DÇbito * r }
                            ASSIGN c-liter-3 = TRIM(RETURN-VALUE).
                            
                            RUN utp/ut-msgs.p (INPUT "help":U,
                                               INPUT 58158, /*Documento com finalidade &1, somente ser† permitido informar &2 igual a &3*/ 
                                               INPUT trim(c-liter-1) + "~~":U + trim(c-liter-2) + "~~":U + trim(c-liter-3) ).
                                               
                            RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe, 
                                             INPUT 58158, /*Documento com finalidade &1, somente ser† permitido informar &2 igual a &3*/
                                             INPUT RETURN-VALUE,
                                             INPUT 1). /*erro*/
                           ASSIGN l-erro-doc-proc-fis  = YES
                                  l-erro-item-proc-fis = YES
                                  l-erro-rat-proc-fis  = YES.                                                               
                           RELEASE msg-ret-nfe.
                           RETURN.   
                    END.
                    
                    IF  bf{&TableName}.cod-finalidade <> '5'   //finalidade crÇdito
                    AND bf{&TableName}.cod-finalidade <> '6'  //finalidade dÇbito
                    AND natur-oper.tipo-compra = 9 /*nota de credito/debito*/ THEN DO:
                        {utp/ut-liter.i Natureza_de_operaá∆o_com_o_tipo_compra_igual_Nota_crÇdito/dÇbito * r }
                        ASSIGN c-liter-1 = TRIM(RETURN-VALUE).
                        
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 58159, /*Documento com finalidade &1 no XML. &2 , somente ser† permitido para documentos com finalidade 5(crÇdito) ou 6(dÇbito)*/ 
                                           INPUT string(bf{&TableName}.cod-finalidade) + "~~":U + trim(c-liter-1)). 
                        
                        RUN utp/ut-msgs.p (INPUT "help":U,
                                           INPUT 58159, /*Documento com finalidade &1 no XML. &2 , somente ser† permitido para documentos com finalidade 5(crÇdito) ou 6(dÇbito)*/ 
                                           INPUT string(bf{&TableName}.cod-finalidade) + "~~":U + trim(c-liter-1)).                     
                                           
                        RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe, 
                                           INPUT 58159, /*Documento com finalidade &1 no XML. &2 , somente ser† permitido para documentos com finalidade 5(crÇdito) ou 6(dÇbito)*/ 
                                           INPUT RETURN-VALUE,
                                           INPUT 1). /*erro*/     
                        ASSIGN l-erro-doc-proc-fis  = YES
                               l-erro-item-proc-fis = YES
                               l-erro-rat-proc-fis  = YES.                                                                                                          
                        
                        RELEASE msg-ret-nfe.
                        RETURN.   
                    END.
                
                      
                    IF  natur-oper.imp-nota = YES THEN DO:
                        RUN utp/ut-msgs.p(INPUT "msg":U,
                                          INPUT 7207,  /* Natureza de operacao  nao possui Modelo Eletronico! */
                                          INPUT natur-oper.nat-operacao).
                        RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                         INPUT 7207,
                                         INPUT RETURN-VALUE,
                                         INPUT 1).
                        ASSIGN l-erro-doc-proc-fis  = YES
                               l-erro-item-proc-fis = YES
                               l-erro-rat-proc-fis  = YES.
                        RELEASE msg-ret-nfe.
                        RETURN.
                    END.
                END.

            IF  item-doc-orig-nfe.int-2 = 11 THEN /* Existe ao menos um item que Ç material agregado */
                ASSIGN l-existe-mat-agreg = YES.
            ELSE IF item-doc-orig-nfe.int-2 = 5 THEN /* Existe ao menos um item que Ç retorno de beneficiamento */
                ASSIGN l-existe-ret-benef = YES.

            
            IF item-doc-orig-nfe.int-2 = 23 THEN DO: /*Nota CrÇdito/DÇbito*/
                    
               {utp/ut-liter.i pelo_recebimento_f°sico * r }
               ASSIGN c-liter-nf-cred-deb = TRIM(RETURN-VALUE).
               RUN utp/ut-msgs.p (INPUT "msg":U,
                                  INPUT 58157, /* Tipo de operaá∆o Nota CrÇdito/DÇbito inv†lida*/
                                  INPUT "").
            
               RUN utp/ut-msgs.p (INPUT "HELP":U,
                                  INPUT 58157, /* Existem itens com o primeiro digito do CFOP diferentes. */
                                  INPUT c-liter-nf-cred-deb). 
               ASSIGN c-liter-nf-cred-deb = c-liter-erro-tipo-operac + " ":U + RETURN-VALUE. 
               
            
               RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                INPUT 58157,
                                INPUT c-liter-nf-cred-deb,
                                INPUT 1).
               ASSIGN l-erro-doc-proc-fis  = YES
                      l-erro-item-proc-fis = YES
                      l-erro-rat-proc-fis  = YES.                 
               RELEASE msg-ret-nfe.
               RETURN.                     
            END. 
            IF (   bf{&TableName}.cod-finalidade = '5'   //finalidade crÇdito
                OR bf{&TableName}.cod-finalidade = '6')  //finalidade dÇbito
            and item-doc-orig-nfe.int-2 <> 23 /*nota de credito/debito*/ THEN DO:
                    IF doc-orig-nfe.cod-finalidade = '5' THEN DO:
                        {utp/ut-liter.i 5(CrÇdito) * r }
                    END.            
                    ELSE DO: 
                       {utp/ut-liter.i 6(DÇbito) * r }
                    END.
                    ASSIGN c-liter-1 = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i tipo_de_operaá∆o  * r }
                    ASSIGN c-liter-2 = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i Nota_de_CrÇdito/DÇbito * r }
                    ASSIGN c-liter-3 = TRIM(RETURN-VALUE).
                    
                    RUN utp/ut-msgs.p (INPUT "help":U,
                                       INPUT 58158, /*Documento com finalidade &1, somente ser† permitido informar &2 igual a &3*/ 
                                       INPUT trim(c-liter-1) + "~~":U + trim(c-liter-2) + "~~":U + trim(c-liter-3) ).
                                       
                     RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe, 
                                     INPUT 58158, /*Documento com finalidade &1, somente ser† permitido informar &2 igual a &3*/
                                     INPUT RETURN-VALUE,
                                     INPUT 1). /*erro*/
                   ASSIGN l-erro-doc-proc-fis  = YES
                          l-erro-item-proc-fis = YES
                          l-erro-rat-proc-fis  = YES.                                                               
                   RELEASE msg-ret-nfe.
                   RETURN.   
                    
            END.
            IF  bf{&TableName}.cod-finalidade <> '5'   //finalidade crÇdito
            AND bf{&TableName}.cod-finalidade <> '6'   //finalidade dÇbito
            AND item-doc-orig-nfe.int-2 = 23 /*nota de credito/debito*/ THEN DO:
                {utp/ut-liter.i Tipo_de_operaá∆o_de_Nota_de_crÇdito/dÇbito * r }
                ASSIGN c-liter-1 = TRIM(RETURN-VALUE).
                
                RUN utp/ut-msgs.p (INPUT "msg":U,
                                   INPUT 58159, /*Documento com finalidade &1 no XML. &2 , somente ser† permitido para documentos com finalidade 5(crÇdito) ou 6(dÇbito)*/ 
                                   INPUT string(bf{&TableName}.cod-finalidade) + "~~":U + trim(c-liter-1)). 
                
                RUN utp/ut-msgs.p (INPUT "help":U,
                                   INPUT 58159, /*Documento com finalidade &1 no XML. &2 , somente ser† permitido para documentos com finalidade 5(crÇdito) ou 6(dÇbito)*/ 
                                   INPUT string(bf{&TableName}.cod-finalidade) + "~~":U + trim(c-liter-1)).                     
                                   
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe, 
                                   INPUT 58159, /*Documento com finalidade &1 no XML. &2 , somente ser† permitido para documentos com finalidade 5(crÇdito) ou 6(dÇbito)*/ 
                                   INPUT RETURN-VALUE,
                                   INPUT 1). /*erro*/     
                ASSIGN l-erro-doc-proc-fis  = YES
                       l-erro-item-proc-fis = YES
                       l-erro-rat-proc-fis  = YES.                                                                                                          
                
                RELEASE msg-ret-nfe.
                RETURN.   
            END.
            
            IF NOT CAN-FIND(FIRST tt-tipo-operacao WHERE tt-tipo-operacao.cod-cfop = item-doc-orig-nfe.cod-cfop) THEN DO:
                FOR EACH tt-tipo-operacao:
                    IF SUBSTR(item-doc-orig-nfe.cod-cfop,1,1) <> SUBSTR(tt-tipo-operacao.cod-cfop,1,1) THEN DO: 
                        IF NOT (l-existe-mat-agreg AND l-existe-ret-benef) THEN DO:
                            RUN utp/ut-msgs.p (INPUT "msg":U,
                                               INPUT 54500, /* Existem itens com o primeiro digito do CFOP diferentes. */
                                               INPUT STRING(item-doc-orig-nfe.seq-item) + "~~":U + STRING(tt-tipo-operacao.seq-item)).
                            ASSIGN c-liter-erro-tipo-operac = RETURN-VALUE.
                            RUN utp/ut-msgs.p (INPUT "HELP":U,
                                               INPUT 54500, /* Existem itens com o primeiro digito do CFOP diferentes. */
                                               INPUT STRING(item-doc-orig-nfe.seq-item) + "~~":U + STRING(tt-tipo-operacao.seq-item)). 
                            ASSIGN c-liter-erro-tipo-operac = c-liter-erro-tipo-operac + " ":U + RETURN-VALUE.
                            RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                             INPUT 54500, /* Existem itens com o primeiro digito do CFOP diferentes. */
                                             INPUT c-liter-erro-tipo-operac,
                                             INPUT 1).              
                            ASSIGN l-erro-doc-proc-fis  = YES
                                   l-erro-item-proc-fis = YES
                                   l-erro-rat-proc-fis  = YES.
                            RELEASE msg-ret-nfe.
                            RETURN.
                        END.
                    END.

                    IF item-doc-orig-nfe.int-2 <> tt-tipo-operacao.tipo-operac THEN DO:                  
                        /* Somente pode haver tipos de operacao diferentes se for material aregado. */
                        IF NOT (l-existe-mat-agreg AND l-existe-ret-benef) THEN DO: 
                            RUN utp/ut-msgs.p (INPUT "msg":U,
                                               INPUT 54501,  /* Existem itens com tipo de operacao incompativeis. */  
                                               INPUT STRING(item-doc-orig-nfe.seq-item) + "~~":U + STRING(tt-tipo-operacao.seq-item)).
                            ASSIGN c-liter-erro-tipo-operac = RETURN-VALUE.
                            RUN utp/ut-msgs.p (INPUT "HELP":U,
                                               INPUT 54501,
                                               INPUT STRING(item-doc-orig-nfe.seq-item) + "~~":U + STRING(tt-tipo-operacao.seq-item)). 
                            ASSIGN c-liter-erro-tipo-operac = c-liter-erro-tipo-operac + " ":U + RETURN-VALUE.
                            RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                             INPUT 54501,
                                             INPUT c-liter-erro-tipo-operac,
                                             INPUT 1).              
                            ASSIGN l-erro-doc-proc-fis  = YES
                                   l-erro-item-proc-fis = YES
                                   l-erro-rat-proc-fis  = YES.
                            RELEASE msg-ret-nfe.
                            RETURN.
                        END.
                    END.
                END. /* .. for each tt-operac */
            END. /* .. IF NOT CAN-FIND(FIRST tt-tipo-operacao */

            CREATE tt-tipo-operacao.
            ASSIGN tt-tipo-operacao.cod-cfop    = item-doc-orig-nfe.cod-cfop
                   tt-tipo-operacao.tipo-operac = item-doc-orig-nfe.int-2
                   tt-tipo-operacao.seq-item    = item-doc-orig-nfe.seq-item.
        END.
                
        /* Validar se existe deposito informado quando houver rastro */
        
        assign de-seq-item-ant = 0.
        
        for each item-doc-orig-nfe NO-LOCK
           where item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
             and item-doc-orig-nfe.idi-orig-trad      = 2
             and item-doc-orig-nfe.int-2              = 1: /*compra*/
            
            for each rat-lote-medic-nfe no-lock 
                where rat-lote-medic-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                  and rat-lote-medic-nfe.seq-item           = item-doc-orig-nfe.seq-item
                 and rat-lote-medic-nfe.idi-orig-trad       = 2:
                
                if (not can-find(first deposito where deposito.cod-depos = rat-lote-medic-nfe.cod-depos) or
                    not can-find(first localizacao 
                                 where localizacao.cod-estabel = bf{&TableName}.cod-estabel /*doc-orig-nfe.cod-estabel*/
                                   and localizacao.cod-depos   = rat-lote-medic-nfe.cod-depos
                                   and localizacao.cod-localiz = rat-lote-medic-nfe.cod-localiz )) then do:
                                   
                    if de-seq-item-ant <> rat-lote-medic-nfe.seq-item then do:
                        
                        assign de-seq-item-ant = rat-lote-medic-nfe.seq-item.
                        
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 28636,  /*N∆o foi encontrado &1 para &2.*/  
                                           INPUT "deposito/localizaá∆o" + "~~":U + "o item de sequencia " + string(rat-lote-medic-nfe.seq-item)).
                         
                        RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                         INPUT 28636,
                                         INPUT RETURN-VALUE,
                                         INPUT 1).
                        
                        release msg-ret-nfe.
                    end.
                end.          
            end.
        end.
        
        if de-seq-item-ant <> 0 then do:
            ASSIGN l-erro-doc-proc-fis  = YES
                   l-erro-item-proc-fis = YES
                   l-erro-rat-proc-fis  = YES. 
            RETURN.
        end.

        FOR EACH item-doc-orig-nfe FIELDS (ch-acesso-comp-nfe seq-item vl-outros vl-seguro vl-frete)
           WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
             AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
             
            /* Chamado TTPVPS - Verifica se existe algum item com outras despesas, frete ou seguro informado */
            IF  not l-voutro-it AND item-doc-orig-nfe.vl-outros <> 0 AND item-doc-orig-nfe.vl-outros <> ? THEN    
                ASSIGN l-voutro-it = YES.         
            IF  not l-vseg-it AND item-doc-orig-nfe.vl-seguro <> 0 AND item-doc-orig-nfe.vl-seguro <> ? THEN        
                ASSIGN l-vseg-it   = YES.
            IF  not l-vfrete-it AND item-doc-orig-nfe.vl-frete <> 0 AND item-doc-orig-nfe.vl-frete <> ? THEN            
                ASSIGN l-vfrete-it = YES.
             
            /************ GERACAO TEMP-TABLE PARA QUEBRA DOS ITENS POR FIFO *************/
            IF  CAN-FIND(FIRST rat-ordem-orig-nfe
                         WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                           AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item) THEN DO:                          
            
                FOR EACH  rat-ordem-orig-nfe NO-LOCK
                    WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                      AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item:
                      
                    /* Copia a tt-rat-ordem-orig-nfe-aux para a tt-rat-ordem-orig-nfe-aux-aux. */
                    CREATE tt-rat-ordem-orig-nfe-aux.
                    BUFFER-COPY rat-ordem-orig-nfe TO tt-rat-ordem-orig-nfe-aux.
                    
                    ASSIGN tt-rat-ordem-orig-nfe-aux.r-rowid = ROWID(rat-ordem-orig-nfe). 
                    
                    /* Atribuicao dos demais campos. */
                    FOR FIRST ordem-compra NO-LOCK /* Busca campos da ordem conforme a REAPI400. */
                        WHERE ordem-compra.numero-ordem = rat-ordem-orig-nfe.numero-ordem:
                        
                        ASSIGN tt-rat-ordem-orig-nfe-aux.ordem-servic = ordem-compra.ordem-servic
                               tt-rat-ordem-orig-nfe-aux.num-ord-inv  = ordem-compra.num-ord-inv /* Sem medicao por contrato. */
                               tt-rat-ordem-orig-nfe-aux.ct-codigo    = ordem-compra.ct-codigo
                               tt-rat-ordem-orig-nfe-aux.cod-unid-neg = IF CAN-FIND(FIRST unid-neg-ordem 
                                                                                    WHERE unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem) THEN "":U
                                                                        ELSE ordem-compra.cod-unid-negoc.
                        /*--- Busca referencia da parcela conforme a REAPI400. ---*/
                        FOR FIRST prazo-compra FIELDS(cod-refer) NO-LOCK 
                            WHERE prazo-compra.numero-ordem = rat-ordem-ext.numero-ordem
                              AND prazo-compra.parcela      = rat-ordem-ext.parcela:
                            ASSIGN tt-rat-ordem-orig-nfe-aux.cod-refer = prazo-compra.cod-refer.
                        END.
                    END.
                END.
            END.
        end.
        
        /******************************************************************************/
        
        /************************** CONTROLE DE QUEBRA FIFO OC ***************************/
        /* APOS CRIAR OS REGISTROS DA TT-RAT-ORDEM-ORIG-NFE-AUX PARA OS ITENS, SIMULA A QUEBRA. */

        /* Executa a quebra para cada item individualmente devido a uma exceá∆o que **
        ** ocorre na quebra por unidade de negocio quando um item esta marcado para **
        ** considerar a unidade de negocio e o outro nao. Caso considere todas as   **
        ** ordens da temp-table de uma vez, os blocos do for each serao executados  **
        ** por ordem de compra, nao por sequencia, assim uma ordem selecionada para **
        ** outra sequencia pode "atravessar" a execucao do bloco e acabar causando  **
        ** uma quebra indevida, principalmente se as ordens selecionadas estiverem  **
        ** em ordem numerica crescente ou decrescente.                              **
        ** Ex: para a sequencia 10 foram selecionadas as ordens 1236.00 e 1238.00 e **
        ** para a sequencia 20 foi selecionada a ordem 1237.00. Executando o bloco  **
        ** para todos os registros a temp-table sera lida pela ordem numerica das   **
        ** ordens de compra, assim o registro da sequencia 20 sera processado entre **
        ** os dois registros da sequencia 10, causando uma quebra indevida no FIFO. */
        FOR EACH  item-doc-orig-nfe
            WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
              AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
                        
            /* O break by quebra o for each em blocos. Cada bloco executado **
            ** ativa a condicao first-of para todos os blocos abaixo dele.  */
            FOR EACH  tt-rat-ordem-orig-nfe-aux
                WHERE tt-rat-ordem-orig-nfe-aux.seq-item = item-doc-orig-nfe.seq-item
                BREAK BY tt-rat-ordem-orig-nfe-aux.ordem-servic
                      BY tt-rat-ordem-orig-nfe-aux.num-ord-inv
                      BY tt-rat-ordem-orig-nfe-aux.cod-refer
                      BY tt-rat-ordem-orig-nfe-aux.ct-codigo
                      BY tt-rat-ordem-orig-nfe-aux.sc-codigo
                      BY tt-rat-ordem-orig-nfe-aux.numero-ordem:

                if tt-rat-ordem-orig-nfe-aux.nr-contrato <> 0 then do:
                   run pi-valida-contrato (input tt-rat-ordem-orig-nfe-aux.numero-ordem, 
                                           input tt-rat-ordem-orig-nfe-aux.nr-contrato, 
                                           input tt-rat-ordem-orig-nfe-aux.num-seq-item, 
                                           input item-doc-orig-nfe.seq-item ).
                          
                   if return-value = "NOK":U then do:                 
                      ASSIGN l-erro-doc-proc-fis  = YES
                             l-erro-item-proc-fis = YES
                             l-erro-rat-proc-fis  = YES.
                          release msg-ret-nfe.
                      RETURN.        
                   end.
                end.
                IF  (    FIRST-OF(tt-rat-ordem-orig-nfe-aux.ct-codigo)
                     OR  FIRST-OF(tt-rat-ordem-orig-nfe-aux.sc-codigo))
                OR  (    FIRST-OF(tt-rat-ordem-orig-nfe-aux.numero-ordem)
                     AND tt-rat-ordem-orig-nfe-aux.num-ord-inv <> 0 )
                THEN DO:
                    
                    /* A variavel i-ctrl-quebra mantem o seu valor mesmo que seja feita quebra de **
                    ** documento por natureza. Cada vez que a quebra de FIFO for feita, ela sera  **
                    ** incrementada. Os registros com mesmo controle pertencerao a mesma quebra.  */
                    ASSIGN i-ctrl-quebra = i-ctrl-quebra + 1.
                END.
                ASSIGN tt-rat-ordem-orig-nfe-aux.ctrl-quebra = i-ctrl-quebra.
            END.
        END.
        /********************************************************************************/
        
        DO  TRANS:
            IF  l-altera-dt-trans THEN DO:
                ASSIGN bf{&TableName}.dt-transacao = TODAY.
            END.
            ELSE DO:
                /* Data nao pode ser Inferior ao Ultimo Medio */
                IF  NOT AVAIL param-estoq THEN
                    FIND FIRST param-estoq NO-LOCK NO-ERROR.
                IF  param-estoq.tp-fech = 2 THEN DO:
                    FIND FIRST estab-mat NO-LOCK WHERE estab-mat.cod-estabel = bf{&TableName}.cod-estabel NO-ERROR.
                    IF  AVAIL estab-mat AND bf{&TableName}.dt-transacao <= estab-mat.mensal-ate THEN DO:
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 1586,
                                           INPUT "").
                        RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                         INPUT 1586,
                                         INPUT RETURN-VALUE,
                                         INPUT 0).
                        ASSIGN l-erro-doc-proc-fis  = YES
                               l-erro-item-proc-fis = YES
                               l-erro-rat-proc-fis  = YES.
                        RELEASE msg-ret-nfe.
                        RETURN.
                    END.
                END.
                ELSE
                    IF  param-estoq.log-1 AND bf{&TableName}.dt-transacao <= param-estoq.mensal-ate THEN DO:
                        RUN utp/ut-msgs.p (INPUT "msg":U,
                                           INPUT 1586,
                                           INPUT "").
                        RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                         INPUT 1586,
                                         INPUT RETURN-VALUE,
                                         INPUT 0).
                        ASSIGN l-erro-doc-proc-fis  = YES
                               l-erro-item-proc-fis = YES
                               l-erro-rat-proc-fis  = YES.
                        RELEASE msg-ret-nfe.
                        RETURN.
                    END.
            END.
        END. /* END DO TRANS */
 
        /* Identificar quantos documentos fisicos deverao ser criados */
        FOR EACH tt-tipo-operacao BREAK BY tt-tipo-operacao.tipo-operac:
            IF LAST-OF(tt-tipo-operacao.tipo-operac) THEN DO:
                ASSIGN i-tipo-nota =  IF   tt-tipo-operacao.tipo-operac = 11 THEN 1  /* se for material agregado (CFOP de compra e retorno de beneficiamento), */
                                      ELSE tt-tipo-operacao.tipo-operac .            /*o tipo nota fica como compra  sen„o usa o tipo operacao para definir o tipo nota */               
                                      
                IF tt-tipo-operacao.tipo-operac >= 18 AND tt-tipo-operacao.tipo-operac <= 21 THEN DO:
                    IF tt-tipo-operacao.tipo-operac = 18 THEN /*Ent_Dep_Fechado*/
                        ASSIGN i-tipo-nota = 12.
                    IF tt-tipo-operacao.tipo-operac = 19 THEN /*Ret_Dep_Fechado*/
                        ASSIGN i-tipo-nota = 13.
                    IF tt-tipo-operacao.tipo-operac = 20 THEN /*Ent_Armaz_Geral*/
                        ASSIGN i-tipo-nota = 14.
                    IF tt-tipo-operacao.tipo-operac = 21 THEN /*Ret_Armaz_Geral*/
                        ASSIGN i-tipo-nota = 15.
                END.
                
                FOR EACH tt-doc-fisico EXCLUSIVE-LOCK:
                    DELETE tt-doc-fisico.
                END.
                FOR EACH tt-it-doc-fisico EXCLUSIVE-LOCK:
                   DELETE tt-it-doc-fisico.
                END.
                
                {inbo/boin847.m3} /* Para cada tipo de operacao criar· um documento fÌsico */
                
                DELETE tt-tipo-operacao.
            END.
        END.

        IF  CAN-FIND(FIRST tt-erros) THEN DO:
            FOR EACH tt-erros NO-LOCK:
                /* Valida se existem warnings. */
                IF  tt-erros.tipo-msg = 2 THEN
                    ASSIGN l-warning = YES.

                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                 INPUT tt-erros.cd-erro,
                                 INPUT tt-erros.mensagem,
                                 INPUT tt-erros.tipo-msg).
                release msg-ret-nfe.
            END.
        END.
        
        /* Criacao de erro de validacao de saldo. */
        FOR EACH tt-erro WHERE tt-erro.cd-erro = 5934:
            RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                             INPUT tt-erro.cd-erro,
                             INPUT tt-erro.desc-erro,
                             INPUT 0).
            ASSIGN l-erro-doc-proc-fis  = YES
                   l-erro-item-proc-fis = YES
                   l-erro-rat-proc-fis  = YES.
            release msg-ret-nfe.
        END.
        
        /*SE ESTA TUDO OK GERA RAT-LOTE COM BASE NA ABA LOTES DO RE0118*/    
        if can-find(first rat-lote-medic-nfe
                    where rat-lote-medic-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                    and   rat-lote-medic-nfe.idi-orig-trad      = 2) then do:
              RUN geraLoteMedic (INPUT rowid(bf{&TableName}),
                                 input 2, /*1 -Fiscal 2-Fisico*/
                                 OUTPUT l-ok, 
                                 OUTPUT TABLE tt-erro).
        end.
        else do:
            assign l-ok = yes. 
        end.    
        
        IF not l-ok THEN DO:
            FOR EACH tt-erro:
                RUN implantaErro(INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                 INPUT tt-erro.cd-erro,
                                 INPUT tt-erro.desc-erro,
                                 INPUT 0).
                ASSIGN l-erro-doc-proc-fis  = YES
                       l-erro-item-proc-fis = YES
                       l-erro-rat-proc-fis  = YES.
                release msg-ret-nfe.
            END.
            RETURN.
        end.
    END. /* END FOR FIRST bf{&TableName} */

    FOR FIRST bf{&TableName} FIELDS (idi-situacao)
        WHERE ROWID(bf{&TableName}) = pr-nota EXCLUSIVE-LOCK:
        IF l-erro-doc-proc-fis   = NO AND
           l-erro-item-proc-fis  = NO AND
           l-erro-rat-proc-fis   = NO THEN
            ASSIGN bf{&TableName}.idi-situacao = 6. /* Digitada no Recebimento F°sico */
        ELSE
            ASSIGN bf{&TableName}.idi-situacao = 2 /* Com erro de neg¢cio */ .
    END.
    RELEASE bf{&TableName}.

    FOR FIRST doc-orig-nfe WHERE ROWID(doc-orig-nfe) = pr-nota NO-LOCK:
        IF NOT doc-orig-nfe.log-metric-env-ls AND doc-orig-nfe.idi-situacao = 6 /* Digitada Recebimento fisico */ THEN
            RUN enviaMetricasAdicionais.
    END.

    RELEASE natur-oper.

    RETURN "OK":U.

    FINALLY:
        FOR FIRST bf{&TableName} NO-LOCK
            WHERE ROWID(bf{&TableName}) = pr-nota:  
            RUN setProcessamento (INPUT bf{&TableName}.ch-acesso-comp-nfe, INPUT false).
        END.
        
        DELETE PROCEDURE h-boin857 NO-ERROR.
        ASSIGN h-boin857 = ?.

        DELETE PROCEDURE h-boin862 NO-ERROR.
        ASSIGN h-boin862 = ?.
        
        DELETE PROCEDURE h-boin01109 NO-ERROR.
        ASSIGN h-boin01109 = ?.
        
    END FINALLY.
