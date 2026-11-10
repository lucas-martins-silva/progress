&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compara-ped-xml-nfe DBOProgram 
PROCEDURE compara-ped-xml-nfe :
/*------------------------------------------------------------------------------
  Purpose: Compara o pedido/ordem/parcela de compra com o XML da NFe e gera as 
  divergencias conforme os parametros do comparativo.
  Parameters: pch-acesso-comp-nfe: Chave de acesso do documento 
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pch-acesso-comp-nfe LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-pedido  LIKE item-doc-orig-nfe.num-pedido   NO-UNDO.
    DEFINE VARIABLE i-ordem   LIKE item-doc-orig-nfe.numero-ordem NO-UNDO.
    DEFINE VARIABLE i-parcela LIKE item-doc-orig-nfe.parcela      NO-UNDO.
    DEFINE VARIABLE c-sit-txt AS CHAR NO-UNDO.

    DEFINE VARIABLE rotinaMetricAdic         AS Routine  NO-UNDO.
    DEFINE VARIABLE subRotinaMetricAdic      AS Metric   NO-UNDO.
    DEFINE VARIABLE iUltimaSeqItem           AS INTEGER  NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe = pch-acesso-comp-nfe
          AND bf{&TableName}.idi-orig-trad      = 2: /*traduzido*/

        /* valida situacoes que nao pode ser executado o processamento */
        RUN validacaoSituacaoNfe.
        IF RETURN-VALUE = "NOK":U THEN DO:
            assign c-sit-txt = {ininc/i01in847.i 04 bf{&TableName}.idi-situacao}.
            {method/svc/errors/inserr.i &ErrorNumber="57071"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="c-sit-txt"}
            RETURN "NOK":U.
        END.

        /*Verifica se o estabelecimento do documento est† com o comparativo ativo*/
        FOR FIRST param-compar-xml NO-LOCK
            WHERE param-compar-xml.cod-estabel = bf{&TableName}.cod-estabel 
              AND param-compar-xml.idi-tip-docto = 1 /*NFe*/ : END.
        IF NOT AVAIL param-compar-xml THEN DO:
            {utp/ut-liter.i Paramàtros_do_comparativo * R}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="RETURN-VALUE"}
            RETURN "NOK".
        END.
        ELSE DO:
            IF NOT param-compar-xml.log-ativo THEN DO:
                {utp/ut-liter.i Paramàtros_do_comparativo * R}
                {method/svc/errors/inserr.i &ErrorNumber="469"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U 
                                            &ErrorParameters="RETURN-VALUE"}
                RETURN "NOK".
            END.
        END.

        RUN pi-valida-nota-composta (INPUT bf{&TableName}.ch-acesso-comp-nfe,
                                     OUTPUT l-nota-composta).
        
        ASSIGN rotinaMetricAdic    = new Routine("Comparativo_XML":U, "MRE":U)
               subRotinaMetricAdic = new Metric("Estab: ":U + bf{&TableName}.cod-estabel).
        rotinaMetricAdic:addMetric(subRotinaMetricAdic).

        IF NOT VALID-HANDLE (h-boin01109) THEN
            RUN inbo/boin01109.p PERSISTENT SET h-boin01109.

        RUN openQueryStatic IN h-boin01109 (INPUT "Main").

        RUN verifica-param-compar (INPUT bf{&TableName}.ch-acesso-comp-nfe).

        FOR EACH item-doc-orig-nfe NO-LOCK
           WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
             AND item-doc-orig-nfe.idi-orig-trad      = bf{&TableName}.idi-orig-trad
              BY item-doc-orig-nfe.seq-item:

            EMPTY TEMP-TABLE tt-doc-xml-compar.
            EMPTY TEMP-TABLE tt-doc-xml-compar-old.

            FOR EACH doc-xml-compar NO-LOCK
               WHERE doc-xml-compar.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                 AND doc-xml-compar.seq-item           = item-doc-orig-nfe.seq-item
                 AND doc-xml-compar.idi-sit-compar     = 1: /*Pendente*/
                CREATE tt-doc-xml-compar-old.
                BUFFER-COPY doc-xml-compar TO tt-doc-xml-compar-old. 
            END.

            /*Somente considerar notas que caracterizam uma compra*/ 
            IF (item-doc-orig-nfe.int-2 = 1   OR  /*Compra*/
                item-doc-orig-nfe.int-2 = 6   OR  /*Entrada Consignaá∆o*/
                item-doc-orig-nfe.int-2 = 11) AND /*Material agregado*/
                NOT l-nota-composta           THEN DO: 
               
               ASSIGN i-pedido  = 0
                      i-ordem   = 0
                      i-parcela = 0.

                /*Compras Simplificado - Pedido unico informado a nivel de item*/
                IF item-doc-orig-nfe.num-pedido <> 0 THEN DO:
                
                    /*Armazenar o primeiro pedido do documento para validar condiá∆o de pagamento*/
                    IF i-pedido = 0 THEN
                        ASSIGN i-pedido  = item-doc-orig-nfe.num-pedido
                               i-ordem   = item-doc-orig-nfe.numero-ordem
                               i-parcela = item-doc-orig-nfe.parcela.
                        
                    RUN pi-compara-pedido (INPUT item-doc-orig-nfe.num-pedido,
                                           INPUT item-doc-orig-nfe.numero-ordem,
                                           INPUT item-doc-orig-nfe.parcela,
                                           INPUT item-doc-orig-nfe.qtd-interna).
                                           
                END. /*IF item-doc-orig-nfe.num-pedido*/
                /*Compras FIFO - Multiplos pedidos/ordens*/
                ELSE IF CAN-FIND (FIRST rat-ordem-orig-nfe NO-LOCK
                                  WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                                    AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item) THEN DO: /*FIFO*/
                    FOR EACH rat-ordem-orig-nfe NO-LOCK
                       WHERE rat-ordem-orig-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                         AND rat-ordem-orig-nfe.seq-item           = item-doc-orig-nfe.seq-item:
                         
                        /*Armazenar o primeiro pedido do documento para validar condiá∆o de pagamento*/ 
                        IF i-pedido = 0 THEN 
                            ASSIGN i-pedido  = rat-ordem-orig-nfe.num-pedido
                                   i-ordem   = rat-ordem-orig-nfe.numero-ordem
                                   i-parcela = rat-ordem-orig-nfe.parcela.
                            
                        RUN pi-compara-pedido (INPUT rat-ordem-orig-nfe.num-pedido,
                                               INPUT rat-ordem-orig-nfe.numero-ordem,
                                               INPUT rat-ordem-orig-nfe.parcela,
                                               INPUT rat-ordem-orig-nfe.qtd-interna).
                                               
                    END. /*FOR EACH rat-ordem-orig-nfe*/
                END. /*ELSE IF CAN-FIND (FIRST rat-ordem-orig-nfe*/
                ELSE DO:    
                   IF param-compar-xml.log-recebe-sem-ped THEN DO:
                       /*Recebimento sem pedido*/
                       RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                INPUT 10, /*Sem pedido*/
                                                INPUT item-doc-orig-nfe.seq-item,
                                                INPUT item-doc-orig-nfe.num-pedido,  
                                                INPUT item-doc-orig-nfe.numero-ordem,
                                                INPUT item-doc-orig-nfe.parcela,     
                                                INPUT 0,  
                                                INPUT 0).                    
                   END. /*IF param-compar-xml.log-recebe-sem-ped*/
                END.
                
                IF param-compar-xml.log-cond-pagto THEN
                    RUN pi-compara-condpagto (INPUT i-pedido,
                                              INPUT i-ordem,  
                                              INPUT i-parcela).

            END. /*IF item-doc-orig-nfe.int-2*/   
            ELSE DO: /*N∆o Ç compra nem entrada de consignaá∆o*/
                ASSIGN bf{&TableName}.idi-sit-diverg = 4. /*N∆o se aplica*/

                RUN setaSitHistorico IN h-boin01109 (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                     INPUT 0,
                                                     INPUT item-doc-orig-nfe.seq-item).
            END.

            RUN pi-cria-doc-xml-compar (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                        INPUT item-doc-orig-nfe.seq-item).

            ASSIGN iUltimaSeqItem = item-doc-orig-nfe.seq-item.
        END. /*FOR EACH item-doc-orig-nfe*/
        
        /*Atualizar o documento para com divergencias, caso novas divergencias tenham sido geradas*/
        IF CAN-FIND (FIRST doc-xml-compar NO-LOCK
                     WHERE doc-xml-compar.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                       AND doc-xml-compar.idi-sit-compar = 1) THEN DO: /*Pendente*/ 
            ASSIGN bf{&TableName}.idi-sit-diverg = 1. /*Pendente*/
        END.    
        /*Passa o documento para sem divergencias, quando n∆o h† pendencias e n∆o h† nenhuma liberada manualmente*/
        ELSE DO:
           IF NOT CAN-FIND (FIRST doc-xml-compar NO-LOCK
                            WHERE doc-xml-compar.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                            AND doc-xml-compar.idi-sit-compar = 2) THEN /*Liberada*/ 
               ASSIGN bf{&TableName}.idi-sit-diverg = 2. /*Sem divergància*/
           ELSE IF CAN-FIND (FIRST doc-xml-compar NO-LOCK
                             WHERE doc-xml-compar.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
                               AND doc-xml-compar.idi-sit-compar = 2) THEN /*Liberada*/ 
               ASSIGN bf{&TableName}.idi-sit-diverg = 3. /*Resolvida*/
        END.
            
        IF VALID-HANDLE(h-boin01109) THEN DO:
            DELETE PROCEDURE h-boin01109 NO-ERROR.
            ASSIGN h-boin01109 = ?.
        END.

        subRotinaMetricAdic:stopLaptime(). //para a contagem de tempo da execucao geral do docto
        subRotinaMetricAdic:addDetail("recebimento-datasul_tempo-processamento-validacao-xmls_seconds":U, iUltimaSeqItem).

        IF rotinaMetricAdic:sendMetrics() THEN DO:
            LOG-MANAGER:WRITE-MESSAGE("***Metricas comparativo (tempo) enviadas com sucesso!") NO-ERROR.
        END.
        ELSE DO:
            LOG-MANAGER:WRITE-MESSAGE("***Erro envio metricas comparativo (tempo): " + STRING(rotinaMetricAdic:getMsgError())) NO-ERROR.
            LOG-MANAGER:WRITE-MESSAGE("***JSON metricas: " + STRING(rotinaMetricAdic:getJsonAsText())) NO-ERROR.
        END.
    END. /*FOR FIRST doc-orig-nfe*/
    FIND CURRENT bf{&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
    FINALLY:
        DELETE OBJECT rotinaMetricAdic NO-ERROR.
        DELETE OBJECT subRotinaMetricAdic NO-ERROR.
    END FINALLY.
END PROCEDURE.

PROCEDURE pi-compara-pedido PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: Compara o pedido/ordem/parcela de compra com o XML da NFe e gera as 
  divergencias conforme os parametros do comparativo.
  Parameters:  p-num-pedido: numero do pedido de compra
               p-num-ordem: numero da ordem de compra
               p-num-parcela: numero da parcela de compra
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-pedido  LIKE item-doc-orig-nfe.num-pedido   NO-UNDO.
    DEFINE INPUT PARAMETER p-num-ordem   LIKE item-doc-orig-nfe.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER p-num-parcela LIKE item-doc-orig-nfe.parcela      NO-UNDO.
    DEFINE INPUT PARAMETER p-qtd-interna LIKE item-doc-orig-nfe.qtd-interna  NO-UNDO.
    
    DEFINE VARIABLE l-pendente          AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE c-transp-cgc        AS CHAR FORMAT "X(14)" NO-UNDO.
    
    DEFINE VARIABLE l-erro-variac-pre   AS LOGICAL INITIAL NO                   NO-UNDO.
    DEFINE VARIABLE de-vl-merc-liq-aux  AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-preco-cc         AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-desconto-cc      AS DECIMAL FORMAT ">>>,>>>,>>9.9999"    NO-UNDO.
    DEFINE VARIABLE de-taxa             AS DECIMAL                              NO-UNDO.
    DEFINE VARIABLE de-vl-merc-liq      AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-vl-aux           AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-max-perc-vl      AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-max-lim-vl       AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-var-max-perc     AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.
    DEFINE VARIABLE de-var-max-lim      AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" NO-UNDO.

    DEFINE VARIABLE l-erro-variac-qtd  AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE de-qtd-saldo       AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE de-qtd-aux         AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE de-qtd-var         AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE de-var-perc-qt     AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE de-var-lim-qt      AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE de-qtd-max-perc    AS DECIMAL            NO-UNDO.
    DEFINE VARIABLE de-qtd-max-lim     AS DECIMAL            NO-UNDO.    
    
    FOR FIRST pedido-compr NO-LOCK
        WHERE pedido-compr.num-pedido = p-num-pedido: 
        
        IF param-compar-xml.log-validac-estab AND
           pedido-compr.end-entrega <> bf{&TableName}.cod-estabel THEN DO:
           
            /*Estabelecimento de entrega do pedido diferente do estabelecimento do documento*/
            RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                     INPUT 9, /*Estab Entrega*/
                                     INPUT item-doc-orig-nfe.seq-item,
                                     INPUT p-num-pedido,
                                     INPUT p-num-ordem,
                                     INPUT p-num-parcela,
                                     INPUT bf{&TableName}.cod-estabel,  
                                     INPUT pedido-compr.end-entrega).             
        END. /*IF param-compar-xml.log-validac-estab*/
        
        IF param-compar-xml.idi-validac-fornec > 1 AND /*1-N∆o valida, 2-Valida (c¢d igual), 3-Valida mesma matriz*/
           pedido-compr.cod-emitente <> bf{&TableName}.cod-emitente THEN DO:
           
            IF param-compar-xml.idi-validac-fornec = 2 THEN DO:
            
                /*Fornecedor da nota difere do pedido*/
                RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                         INPUT 7, /*Fornecedor*/
                                         INPUT item-doc-orig-nfe.seq-item,
                                         INPUT p-num-pedido,
                                         INPUT p-num-ordem,
                                         INPUT p-num-parcela,
                                         INPUT bf{&TableName}.cod-emitente,  
                                         INPUT pedido-compr.cod-emitente).                 
            END.
            ELSE DO:
                FOR FIRST emitente NO-LOCK
                    WHERE emitente.cod-emitente = pedido-compr.cod-emitente: END.
                FOR FIRST bf-emitente NO-LOCK
                    WHERE bf-emitente.cod-emitente = bf{&TableName}.cod-emitente: END.
                
                IF param-compar-xml.idi-validac-fornec = 3 AND /*Valida mesma matriz*/
                   AVAIL emitente AND AVAIL bf-emitente AND
                   emitente.nome-matriz <> bf-emitente.nome-matriz THEN DO:
                       
                        /*Fornecedor da nota difere do pedido e n∆o Ç da mesma matriz*/
                        RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                 INPUT 7, /*Fornecedor*/
                                                 INPUT item-doc-orig-nfe.seq-item,
                                                 INPUT p-num-pedido,
                                                 INPUT p-num-ordem,
                                                 INPUT p-num-parcela,
                                                 INPUT bf{&TableName}.cod-emitente,  
                                                 INPUT pedido-compr.cod-emitente).
                END. /*IF param-compar-xml.idi-validac-fornec = 3*/
            END.
        END. /*IF param-compar-xml.idi-validac-fornec > 1*/

        IF param-compar-xml.log-validac-transpdor and can-do(param-compar-xml.list-modal-frete-transp,doc-orig-nfe.mod-frete) THEN DO:
            IF TRIM(doc-orig-nfe.cnpj-transp) <> "" AND doc-orig-nfe.cnpj-transp <> ? THEN
                ASSIGN c-transp-cgc = bf{&TableName}.cnpj-transp.
            ELSE IF TRIM(doc-orig-nfe.cpf-transp) <> "" AND doc-orig-nfe.cpf-transp <> ? THEN    
                ASSIGN c-transp-cgc = bf{&TableName}.cpf-transp.
            ELSE ASSIGN c-transp-cgc = "".
            
            IF c-transp-cgc <> "" THEN DO:
                FOR FIRST transporte NO-LOCK
                    WHERE transporte.cgc = TRIM(c-transp-cgc): END.
                    
                IF (AVAIL transporte AND
                    pedido-compr.cod-transp <> transporte.cod-transp) OR
                    NOT AVAIL transporte THEN DO:
                        /*Transportador da nota difere do pedido*/
                        RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                                 INPUT 6, /*Transportador*/
                                                 INPUT item-doc-orig-nfe.seq-item,
                                                 INPUT p-num-pedido,
                                                 INPUT p-num-ordem,
                                                 INPUT p-num-parcela,
                                                 INPUT (IF avail transporte THEN string(transporte.cod-transp) ELSE ""),
                                                 INPUT pedido-compr.cod-transp).                  
                END.
            END.
        END. /*IF param-compar-xml.log-validac-transpdor*/
        
        IF param-compar-xml.log-pend-aprovac THEN DO:
            FOR FIRST ordem-compra NO-LOCK
                WHERE ordem-compra.numero-ordem = p-num-ordem: 
                
                /*Verifica se a ordem ou o pedido est∆o pendentes de aprovaá∆o*/
                RUN cdp/cdapi172.p (INPUT 4, INPUT ROWID(ordem-compra), OUTPUT l-pendente).
                IF NOT l-pendente THEN
                    RUN cdp/cdapi172.p (INPUT 6, INPUT ROWID(ordem-compra), OUTPUT l-pendente).
                IF l-pendente THEN DO: 
                    /*Documento esta pendente de aprovaá∆o*/
                    RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                             INPUT 8, /*Pend aprovaá∆o*/
                                             INPUT item-doc-orig-nfe.seq-item,
                                             INPUT p-num-pedido,
                                             INPUT p-num-ordem,
                                             INPUT p-num-parcela,
                                             INPUT "",   
                                             INPUT "").               
                END.
            END. /*FOR FIRST ordem-compra*/
        END. /*IF param-compar-xml.log-pend-aprov */
        
        FOR FIRST prazo-compra NO-LOCK
            WHERE prazo-compra.numero-ordem = p-num-ordem  
              AND prazo-compra.parcela      = p-num-parcela:
        
            IF  param-compar-xml.log-dat-entreg AND
               (prazo-compra.data-entrega > date(bf{&TableName}.dt-emissao + param-compar-xml.num-dias-variac-dat-entreg)  OR 
                prazo-compra.data-entrega < date(bf{&TableName}.dt-emissao - param-compar-xml.num-dias-variac-dat-entreg)) THEN DO:
                    
                /*Data de entrega da parcela esta fora da variaá∆o*/
                RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                         INPUT 3, /*Data Entrega*/
                                         INPUT item-doc-orig-nfe.seq-item,
                                         INPUT p-num-pedido,
                                         INPUT p-num-ordem,
                                         INPUT p-num-parcela,
                                         INPUT bf{&TableName}.dt-emissao,    
                                         INPUT prazo-compra.data-entrega).                     
                
            END. /*IF param-compar-xml.log-dat-entreg*/
            
            /********************************************************************************************************/

            FOR FIRST item-uni-estab FIELDS(it-codigo cod-estabel lim-var-valor var-val-re-maior var-qtd-re lim-var-qtd)
                WHERE item-uni-estab.it-codigo   = item-doc-orig-nfe.it-codigo
                  AND item-uni-estab.cod-estabel = bf{&TableName}.cod-estabel NO-LOCK: END.
            
            IF NOT AVAIL item-uni-estab OR 
               (AVAIL item-uni-estab AND 
                (item-uni-estab.var-val-re-maior = 0 OR item-uni-estab.lim-var-valor = 0 OR 
                 item-uni-estab.var-qtd-re       = 0 OR item-uni-estab.lim-var-qtd   = 0)) THEN DO:
                FOR FIRST item-mat FIELDS(it-codigo var-val-re-maior lim-var-valor var-qtd-re lim-var-qtd) 
                    WHERE item-mat.it-codigo = item-doc-orig-nfe.it-codigo NO-LOCK:  END.
            END.
            
            ASSIGN de-max-perc-vl = IF AVAIL item-uni-estab AND item-uni-estab.var-val-re-maior > 0 THEN 
                                        item-uni-estab.var-val-re-maior
                                    ELSE IF AVAIL item-mat THEN item-mat.var-val-re-maior ELSE 0
                   de-max-lim-vl  = IF AVAIL item-uni-estab AND item-uni-estab.lim-var-valor > 0 THEN 
                                        item-uni-estab.lim-var-valor
                                    ELSE IF AVAIL item-mat THEN item-mat.lim-var-valor ELSE 0.
            
            ASSIGN de-var-perc-qt  = IF AVAIL item-uni-estab AND item-uni-estab.var-qtd-re > 0 THEN 
                                         item-uni-estab.var-qtd-re
                                     ELSE IF AVAIL item-mat THEN item-mat.var-qtd-re ELSE 0
                   de-var-lim-qt   = IF AVAIL item-uni-estab AND item-uni-estab.lim-var-qtd > 0 THEN 
                                         item-uni-estab.lim-var-qtd
                                     ELSE IF AVAIL item-mat THEN item-mat.lim-var-qtd ELSE 0. 
                                     
            /********************************************************************************************************/

            IF param-compar-xml.idi-variac-preco > 1 THEN DO: /*1-N∆o valida, 2-Valida, 3-Valida com variaá∆o*/
                       
                ASSIGN de-vl-merc-liq-aux = ROUND((item-doc-orig-nfe.preco-total - item-doc-orig-nfe.vl-desconto) / item-doc-orig-nfe.qtd-comercial, 5).
                
                FOR FIRST ordem-compra NO-LOCK
                    WHERE ordem-compra.numero-ordem = p-num-ordem:
                
                    RUN rep/re1908.p(INPUT  ROWID(ordem-compra),
                                     INPUT  bf{&TableName}.dt-emissao,
                                     OUTPUT de-preco-cc,
                                     OUTPUT de-desconto-cc,
                                     OUTPUT de-taxa).
                
                    ASSIGN de-vl-merc-liq = de-preco-cc - de-desconto-cc.
                END.
                
                ASSIGN de-vl-aux = ROUND(de-vl-merc-liq, 5).
                
                IF param-compar-xml.idi-variac-preco = 3 THEN /*com variaá∆o*/
                    ASSIGN de-var-max-perc = ROUND(de-vl-aux + (de-vl-aux * de-max-perc-vl / 100), 5)
                           de-var-max-lim  = ROUND(de-vl-aux + de-max-lim-vl,5).
                ELSE 
                    ASSIGN de-var-max-perc = ROUND(de-vl-aux, 5)
                           de-var-max-lim  = ROUND(de-vl-aux, 5).
            
                ASSIGN l-erro-variac-pre = no.          
                
                IF de-max-perc-vl = 0 AND de-max-lim-vl = 0 THEN DO:
                    IF de-vl-merc-liq-aux > de-var-max-perc OR 
                       de-vl-merc-liq-aux > de-var-max-lim THEN 
                        ASSIGN l-erro-variac-pre = YES.
                END.
                ELSE 
                    IF de-vl-merc-liq-aux <= de-var-max-perc OR 
                       de-max-perc-vl = 0 THEN  
                        IF de-vl-merc-liq-aux > de-var-max-lim AND 
                           de-max-lim-vl <> 0 THEN  
                            ASSIGN l-erro-variac-pre = YES.
                        ELSE  
                            ASSIGN l-erro-variac-pre = NO. 
                    ELSE 
                        ASSIGN l-erro-variac-pre = YES.
                
                IF l-erro-variac-pre THEN DO:
                    /*Preáo unit†rio do item Ç diferente/fora da variaá∆o da ordem*/
                    RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                             INPUT 1, /*Preáo*/
                                             INPUT item-doc-orig-nfe.seq-item,
                                             INPUT p-num-pedido,
                                             INPUT p-num-ordem,
                                             INPUT p-num-parcela,
                                             INPUT de-vl-merc-liq-aux, 
                                             INPUT de-vl-aux). 
                END.
            END. /*IF tt-param-compar-xml.ind-preco > 1*/
            
            /********************************************************************************************************/
            
            IF param-compar-xml.idi-variac-quant > 1 THEN DO: /*1-N∆o valida, 2-Valida, 3-Valida com variaá∆o*/
                                        
                /*Como a alocaá∆o da parcela j† foi realizada na importaá∆o do xml ou na modificaá∆o do item do documento,*/
                /*deve-se abater a quantidade do item da quantidade alocada, para que a quantidade alocada considerada no */
                /*calculo abaixo n∆o considere a alocaá∆o do proprio item do documento que est† sendo validado            */

               
                ASSIGN de-qtd-saldo = prazo-compra.quant-saldo - ((prazo-compra.dec-1 - p-qtd-interna) - prazo-compra.quant-rejeit).
                
                ASSIGN de-qtd-aux = ROUND(de-qtd-saldo * de-var-perc-qt / 100 , 4).                
                ASSIGN de-qtd-aux = IF de-qtd-aux < 0 THEN 0 ELSE de-qtd-aux.
                
                IF param-compar-xml.idi-variac-quant = 3 THEN /*com variaá∆o*/
                    ASSIGN de-qtd-max-perc = de-qtd-saldo + de-qtd-aux
                           de-qtd-max-lim  = de-qtd-saldo + de-var-lim-qt.
                ELSE 
                    ASSIGN de-qtd-max-perc = de-qtd-saldo
                           de-qtd-max-lim  = de-qtd-saldo.
                ASSIGN l-erro-variac-qtd = NO.
                
                IF de-var-perc-qt = 0 AND de-var-lim-qt = 0 THEN DO:
                    IF p-qtd-interna > de-qtd-max-perc OR 
                       p-qtd-interna > de-qtd-max-lim THEN 
                        ASSIGN l-erro-variac-qtd = YES.
                END.
                ELSE 
                    IF p-qtd-interna <= de-qtd-max-perc OR 
                       de-var-perc-qt = 0 THEN
                        IF p-qtd-interna > de-qtd-max-lim AND 
                           de-var-lim-qt <> 0 THEN  
                            ASSIGN l-erro-variac-qtd = YES. 
                        ELSE
                            ASSIGN l-erro-variac-qtd = NO. 
                    ELSE  
                        ASSIGN l-erro-variac-qtd = YES. 
                
                IF l-erro-variac-qtd THEN DO:
                    /*Quantidade recebida no item da nota Ç superior ao saldo/variaá∆o da parcela de compra*/
                    RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                             INPUT 2, /*Quantidade*/
                                             INPUT item-doc-orig-nfe.seq-item,
                                             INPUT p-num-pedido,
                                             INPUT p-num-ordem,
                                             INPUT p-num-parcela,
                                             INPUT p-qtd-interna, 
                                             INPUT de-qtd-saldo). 
                END. 
            END. /*IF tt-param-compar-xml.ind-quant > 1 */
            /********************************************************************************************************/
            
        END. /*FOR FIRST prazo-compra*/    
        
    END. /*FOR FIRST pedido-compr*/

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-compara-condpagto PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: Compara a condiá∆o de pagamento do pedido ou fornecedor com o XML da NFe e gera as 
  divergencias conforme os parametros do comparativo.
  Parameters:  p-num-pedido: numero do pedido de compra
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-pedido   LIKE item-doc-orig-nfe.num-pedido   NO-UNDO.
    DEFINE INPUT PARAMETER p-numero-ordem LIKE item-doc-orig-nfe.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER p-parcela      LIKE item-doc-orig-nfe.parcela      NO-UNDO.

    DEF VAR de-valor-total AS DECIMAL DECIMALS 2                  NO-UNDO.
    DEF VAR de-valor       AS DECIMAL DECIMALS 2        EXTENT 12 NO-UNDO.
    DEF VAR da-data        AS DATE FORMAT "99/99/9999"  EXTENT 12 NO-UNDO.
    DEF VAR i-cont         AS INTEGER                             NO-UNDO.
    DEF VAR da-partida     AS DATE FORMAT "99/99/9999"            NO-UNDO.
    DEF VAR i-cond         LIKE cond-pagto.cod-cond-pag EXTENT 6  NO-UNDO.
    DEF VAR i-num-parc     AS INTEGER                             NO-UNDO.
    DEF VAR i-ind          AS INTEGER                             NO-UNDO.
    DEF VAR dat-tipo-dia   LIKE calen-coml.tipo-dia               NO-UNDO.
    DEF VAR i-cod-cond-pag LIKE cond-pagto.cod-cond-pag           NO-UNDO.
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    /*Gravar a condiá∆o de pagamento do fornecedor*/
    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = bf{&TableName}.cod-emitente: 
        ASSIGN i-cod-cond-pag = emitente.cod-cond-pag.
    END.

    /*Se tiver pedido, deve-se pegar a condiá∆o de pagamento do pedido*/
    IF p-num-pedido <> 0 THEN DO:
        FOR FIRST pedido-compr NO-LOCK
            WHERE pedido-compr.num-pedido = p-num-pedido: 

            ASSIGN i-cod-cond-pag = pedido-compr.cod-cond-pag.

            IF pedido-compr.cod-cond-pag = 0 THEN DO:
                FOR FIRST cond-especif NO-LOCK
                    WHERE cond-especif.num-pedido = pedido-compr.num-pedido:
                    DO i-cont = 1 TO 12:
                        IF cond-especif.data-pagto[i-cont] <> ? THEN 
                            ASSIGN da-data[i-cont]  = cond-especif.data-pagto[i-cont]
                                   de-valor[i-cont] = bf{&TableName}.valor-total * cond-especif.perc-pagto[i-cont] / 100
                                   de-valor-total   = de-valor-total + de-valor[i-cont].
                    END.
                END.
                ASSIGN de-valor[1] = de-valor[1] + bf{&TableName}.valor-total - de-valor-total.
            END.
        END. /*FOR FIRST pedido-compr*/
    END. /*IF p-num-pedido <> 0*/

    /*Logica para a geraá∆o das parcelas de acordo com o cadastro da condiá∆o de pagamento*/
    IF i-cod-cond-pag <> 0 THEN DO:
        FOR FIRST cond-pagto NO-LOCK 
            WHERE cond-pagto.cod-cond-pag = i-cod-cond-pag:
        
            ASSIGN da-partida   = bf{&TableName}.dt-emissao
                   i-cond       = cond-pagto.cod-vencto
                   i-num-parc   = cond-pagto.num-parcelas.
        
            DO i-cont = 1 TO i-num-parc:
                ASSIGN de-valor[i-cont] = (bf{&TableName}.valor-total * cond-pagto.per-pg-dup[i-cont] / 100).
                {cdp/cd9020.i7 doc-orig-nfe.cod-estabel}
            END.
        END.
    END. /*IF i-cod-cond-pag <> 0*/

    ASSIGN i-cont = 0.

    /*Tabela do monitor que armazena as parcelas da condiá∆o de pagamento do XML da nota*/
    FOR EACH doc-orig-duplic-nfe NO-LOCK
        WHERE doc-orig-duplic-nfe.ch-acesso-comp-nfe = bf{&TableName}.ch-acesso-comp-nfe
          AND doc-orig-duplic-nfe.idi-orig-trad      = bf{&TableName}.idi-orig-trad 
        BREAK BY doc-orig-duplic-nfe.dt-vencim:

        ASSIGN i-cont = i-cont + 1.

        IF i-cont <= 12 THEN DO:
            IF doc-orig-duplic-nfe.dt-vencim <> da-data[i-cont] THEN DO:
            
                /*Data de vencimento da parcela do XML Ç diferente da calculada conforme cadastro da cond pagto*/
                RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                         INPUT 5, /*Cond Pagto Data*/
                                         INPUT item-doc-orig-nfe.seq-item,
                                         INPUT p-num-pedido,
                                         INPUT p-numero-ordem,
                                         INPUT p-parcela,
                                         INPUT doc-orig-duplic-nfe.dt-vencim,  
                                         INPUT da-data[i-cont]). 
            END.

            IF doc-orig-duplic-nfe.vl-duplicata > (de-valor[i-cont] + param-compar-xml.val-variac-dupl) OR
               doc-orig-duplic-nfe.vl-duplicata < (de-valor[i-cont] - param-compar-xml.val-variac-dupl) THEN DO:
               
                /*Valor da parcela do XML Ç diferente da calculada conforme cadastro da cond pagto*/
                RUN pi-cria-divergencia (INPUT item-doc-orig-nfe.ch-acesso-comp-nfe,
                                         INPUT 4, /*Cond Pagto Valor*/
                                         INPUT item-doc-orig-nfe.seq-item,
                                         INPUT p-num-pedido,
                                         INPUT p-numero-ordem,
                                         INPUT p-parcela,
                                         INPUT doc-orig-duplic-nfe.vl-duplicata,  
                                         INPUT de-valor[i-cont]). 
            END.
        END. 
    END. /*FOR EACH doc-orig-duplic-nfe*/    

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-divergencia PRIVATE:
/*------------------------------------------------------------------------------
  Purpose: Cria as divergencias na tabela doc-xml-compar.
  Parameters:  pch-acesso-comp-nfe : chave de acesso do documento
               pidi-tip-compar     : tipo de divergencia (preáo, quantidade, fornecedor, etc)
               pidi-tip-docto      : tipo de documento (NFe) 
               pseq-item           : sequencia do item do documento 
               pnum-pedido         : numero do pedido de compra
               pnumero-ordem       : numero da ordem de compra 
               pparcela            : numero da parcela de compra 
               pdes-contdo-orig-xml: dados do xml/documento
               pdes-contdo-erp     : dados do sistema 
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pch-acesso-comp-nfe  LIKE doc-xml-compar.ch-acesso-comp-nfe  NO-UNDO.   
    DEFINE INPUT PARAMETER pidi-tip-compar      LIKE doc-xml-compar.idi-tip-compar      NO-UNDO.   
    DEFINE INPUT PARAMETER pseq-item            LIKE doc-xml-compar.seq-item            NO-UNDO.   
    DEFINE INPUT PARAMETER pnum-pedido          LIKE doc-xml-compar.num-pedido          NO-UNDO.   
    DEFINE INPUT PARAMETER pnumero-ordem        LIKE doc-xml-compar.numero-ordem        NO-UNDO.   
    DEFINE INPUT PARAMETER pparcela             LIKE doc-xml-compar.parcela             NO-UNDO.
    DEFINE INPUT PARAMETER pdes-contdo-orig-xml LIKE doc-xml-compar.des-contdo-orig-xml NO-UNDO.   
    DEFINE INPUT PARAMETER pdes-contdo-erp      LIKE doc-xml-compar.des-contdo-erp      NO-UNDO.   
    
    DEFINE VARIABLE i-num-seq-aux LIKE doc-xml-compar.num-seq NO-UNDO.

    FOR LAST tt-doc-xml-compar
       WHERE tt-doc-xml-compar.ch-acesso-comp-nfe = pch-acesso-comp-nfe
         AND tt-doc-xml-compar.seq-item           = pseq-item NO-LOCK: END.
         
    ASSIGN i-num-seq-aux = IF AVAIL tt-doc-xml-compar THEN (tt-doc-xml-compar.num-seq + 1) ELSE 1.     

    CREATE tt-doc-xml-compar.
    ASSIGN tt-doc-xml-compar.ch-acesso-comp-nfe  = pch-acesso-comp-nfe
           tt-doc-xml-compar.seq-item            = pseq-item
           tt-doc-xml-compar.idi-tip-compar      = pidi-tip-compar
           tt-doc-xml-compar.idi-sit-compar      = 1 /*Pendente*/
           tt-doc-xml-compar.idi-tip-docto       = 1 /*NFe*/
           tt-doc-xml-compar.num-pedido          = pnum-pedido
           tt-doc-xml-compar.numero-ordem        = pnumero-ordem
           tt-doc-xml-compar.parcela             = pparcela
           tt-doc-xml-compar.des-contdo-orig-xml = pdes-contdo-orig-xml
           tt-doc-xml-compar.des-contdo-erp      = pdes-contdo-erp            
           tt-doc-xml-compar.cod-usuar-gerac     = c-seg-usuario
           tt-doc-xml-compar.dtm-gerac           = NOW
           tt-doc-xml-compar.num-seq             = i-num-seq-aux.
           
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-cria-doc-xml-compar PRIVATE:

    DEFINE INPUT PARAMETER pch-acesso-comp-nfe  LIKE doc-xml-compar.ch-acesso-comp-nfe  NO-UNDO.   
    DEFINE INPUT PARAMETER pseq-item            LIKE doc-xml-compar.seq-item            NO-UNDO.   
    
    DEFINE VARIABLE l-tip-divergente AS LOGICAL NO-UNDO.
    
    FOR EACH tt-doc-xml-compar-old NO-LOCK
        WHERE tt-doc-xml-compar-old.ch-acesso-comp-nfe = pch-acesso-comp-nfe 
          AND tt-doc-xml-compar-old.seq-item           = pseq-item:
                
        IF NOT CAN-FIND (FIRST tt-doc-xml-compar NO-LOCK
                         WHERE tt-doc-xml-compar.ch-acesso-comp-nfe = tt-doc-xml-compar-old.ch-acesso-comp-nfe 
                           AND tt-doc-xml-compar.idi-tip-compar     = tt-doc-xml-compar-old.idi-tip-compar
                           AND tt-doc-xml-compar.idi-tip-docto      = tt-doc-xml-compar-old.idi-tip-docto      
                           AND tt-doc-xml-compar.seq-item           = tt-doc-xml-compar-old.seq-item
                           AND tt-doc-xml-compar.num-pedido         = tt-doc-xml-compar-old.num-pedido         
                           AND tt-doc-xml-compar.numero-ordem       = tt-doc-xml-compar-old.numero-ordem       
                           AND tt-doc-xml-compar.parcela            = tt-doc-xml-compar-old.parcela) THEN DO:
                           
            EMPTY TEMP-TABLE tt-doc-xml-compar-aux.
            CREATE tt-doc-xml-compar-aux.
            BUFFER-COPY tt-doc-xml-compar-old TO tt-doc-xml-compar-aux.
            ASSIGN tt-doc-xml-compar-aux.idi-sit-compar = 3. /*3-Hist¢rico*/

            RUN emptyRowErrors   IN h-boin01109.
            RUN emptyRowObject   IN h-boin01109.
            RUN gotokey          IN h-boin01109 (INPUT tt-doc-xml-compar-old.ch-acesso-comp-nfe,
                                                 INPUT tt-doc-xml-compar-old.seq-item,
                                                 INPUT tt-doc-xml-compar-old.num-seq).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN setRecord        IN h-boin01109 (INPUT TABLE tt-doc-xml-compar-aux).
                RUN updateRecord     IN h-boin01109.
                RUN getRowErrors     IN h-boin01109 (OUTPUT TABLE RowErrors).
            END.
        END.
    END.     

    FOR EACH tt-doc-xml-compar NO-LOCK
        WHERE tt-doc-xml-compar.ch-acesso-comp-nfe  = pch-acesso-comp-nfe 
          AND tt-doc-xml-compar.seq-item            = pseq-item
           BREAK BY tt-doc-xml-compar.idi-tip-compar:
           
        IF FIRST-OF(tt-doc-xml-compar.idi-tip-compar) THEN DO:
            EMPTY TEMP-TABLE tt-doc-xml-compar-aux.
            ASSIGN l-tip-divergente = NO.
        END.    
            
        IF NOT CAN-FIND (FIRST doc-xml-compar NO-LOCK
                         WHERE doc-xml-compar.ch-acesso-comp-nfe  = tt-doc-xml-compar.ch-acesso-comp-nfe 
                           AND doc-xml-compar.idi-tip-compar      = tt-doc-xml-compar.idi-tip-compar
                           AND doc-xml-compar.idi-tip-docto       = tt-doc-xml-compar.idi-tip-docto      
                           AND doc-xml-compar.seq-item            = tt-doc-xml-compar.seq-item           
                           AND doc-xml-compar.num-pedido          = tt-doc-xml-compar.num-pedido         
                           AND doc-xml-compar.numero-ordem        = tt-doc-xml-compar.numero-ordem       
                           AND doc-xml-compar.parcela             = tt-doc-xml-compar.parcela            
                           AND doc-xml-compar.des-contdo-orig-xml = tt-doc-xml-compar.des-contdo-orig-xml
                           AND doc-xml-compar.des-contdo-erp      = tt-doc-xml-compar.des-contdo-erp     
                           AND doc-xml-compar.idi-sit-compar      <> 3) THEN /*1-Pendente, 2-Liberada, 3-Hist¢rico, 4-Recusada*/
            ASSIGN l-tip-divergente = YES.
        
        CREATE tt-doc-xml-compar-aux.
        BUFFER-COPY tt-doc-xml-compar TO tt-doc-xml-compar-aux.
        
        IF LAST-OF(tt-doc-xml-compar.idi-tip-compar) THEN DO:
            IF l-tip-divergente AND VALID-HANDLE(h-boin01109) THEN DO:
                RUN setaSitHistorico IN h-boin01109 (INPUT tt-doc-xml-compar.ch-acesso-comp-nfe,
                                                     INPUT tt-doc-xml-compar.idi-tip-compar,
                                                     INPUT tt-doc-xml-compar.seq-item).
                                                     
                FOR EACH tt-doc-xml-compar-aux NO-LOCK:
                    EMPTY TEMP-TABLE tt-doc-xml-compar-add.
                    CREATE tt-doc-xml-compar-add.
                    BUFFER-COPY tt-doc-xml-compar-aux TO tt-doc-xml-compar-add.

                    RUN emptyRowErrors   IN h-boin01109.
                    RUN emptyRowObject   IN h-boin01109.
                    RUN setRecord        IN h-boin01109 (INPUT TABLE tt-doc-xml-compar-add).
                    RUN createRecord     IN h-boin01109.
                    RUN getRowErrors     IN h-boin01109 (OUTPUT TABLE RowErrors).
                END.
            END.
        END.
    END.
    
END PROCEDURE.


PROCEDURE verifica-param-compar PRIVATE:

    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE doc-xml-compar.ch-acesso-comp-nfe NO-UNDO.   
    
    IF param-compar-xml.idi-variac-preco = 1 THEN /*1-N∆o valida*/
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 1). /*Preáo*/
    
    IF param-compar-xml.idi-variac-quant = 1 THEN /*1-N∆o valida*/
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 2). /*Quantidade*/
    
    IF NOT param-compar-xml.log-dat-entreg THEN
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 3). /*Data Entrega*/

    IF NOT param-compar-xml.log-cond-pagto THEN DO:
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 4). /*Cond Pagto Valor*/
                                             
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 5). /*Cond Pagto Data*/
    END.
    
    IF NOT param-compar-xml.log-validac-transpdor THEN
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 6). /*Transportador*/

    IF param-compar-xml.idi-validac-fornec = 1 THEN /*1-N∆o valida*/
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 7). /*Fornecedor*/

    IF NOT param-compar-xml.log-pend-aprovac THEN
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 8). /*Pend aprovaá∆o*/
    
    IF NOT param-compar-xml.log-validac-estab THEN
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 9). /*Estab Entrega*/

    IF NOT param-compar-xml.log-recebe-sem-ped THEN
        RUN setaSitHistTpDiv IN h-boin01109 (INPUT pch-acesso-comp-nfe,
                                             INPUT 10). /*Sem pedido*/
END PROCEDURE.

PROCEDURE pi-valida-nota-composta PRIVATE:
    DEFINE INPUT    PARAMETER pch-acesso-comp-nfe LIKE doc-xml-compar.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT   PARAMETER p-nota-composta     AS LOGICAL   INITIAL NO                NO-UNDO.

    DEFINE VARIABLE i-tipo-oper AS INTEGER NO-UNDO.

    FOR FIRST item-doc-orig-nfe NO-LOCK
        WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  = pch-acesso-comp-nfe
          AND item-doc-orig-nfe.idi-orig-trad         = 2: /* Traduzido */
        ASSIGN i-tipo-oper = item-doc-orig-nfe.int-2.          
    END.

    IF CAN-FIND (FIRST item-doc-orig-nfe NO-LOCK
                 WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  =  pch-acesso-comp-nfe
                   AND item-doc-orig-nfe.idi-orig-trad       =  2
                   AND item-doc-orig-nfe.int-2               <> i-tipo-oper) THEN
        ASSIGN p-nota-composta = YES.    

END PROCEDURE.
