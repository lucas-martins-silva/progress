/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-IT-NOTA-FISC-W 2.00.00.050 } /*** "010050" 11/12/2023 14:09:54  ***/

{cdp/cdcfgmat.i}

/* trigger write do item da nota fiscal
  funá‰es: 1. criar movimento de entrega no contrato de vendas MI
           2. excluir movimento de entrega no contrato de vendas MI, quando nota cancelada 
           3. verificar se completou cadància e mandar e-mail para grupo de usu†rios para alertar sobre o faturamento 
           4. Atualizar devoluá∆o compras
           5. Volta a pendencia de devolucao por pendencia de quantidade: Compra ou Armazenagem 
 */

DEFINE PARAM BUFFER b-it-nota-fisc     FOR it-nota-fisc.
DEFINE PARAM BUFFER b-old-it-nota-fisc FOR it-nota-fisc.

DEFINE VARIABLE i-empresa-estab     LIKE empresa.ep-codigo      NO-UNDO.
DEFINE VARIABLE h-ggapi112          AS HANDLE                   NO-UNDO.
DEFINE VARIABLE c-contrato-item     AS CHARACTER                NO-UNDO.
DEFINE VARIABLE i-seq               AS INTEGER                  NO-UNDO.
DEFINE VARIABLE l-dev-valor         AS LOG INIT NO              NO-UNDO.

/*buscar os status*/
DEFINE VARIABLE i-ctr-ep-codigo     AS CHAR      NO-UNDO.
DEFINE VARIABLE c-ctr-cod-contrato  AS CHAR      NO-UNDO.
DEFINE VARIABLE l-cancelamento      AS LOG       NO-UNDO.
DEFINE VARIABLE l-entegou           AS LOG       NO-UNDO.
DEFINE VARIABLE l-atu-ctr           AS LOGICAL     NO-UNDO.
DEFINE BUFFER   b-gg-contrato-prod FOR gg-contrato-prod.

{ggp/tt-erro.i}
{utp/ut-glob.i}
{ggp/ggapi074.i} 

IF  NOT CAN-FIND( FIRST param-global WHERE param-global.log-modul-gg = YES) THEN
    RETURN "OK":U.

FIND FIRST nota-fiscal OF b-it-nota-fisc NO-LOCK NO-ERROR.
IF NOT AVAIL nota-fiscal THEN
    RETURN "OK":U.

RUN agro-upc/gg-cria-ext-nota-fiscal.p (INPUT b-it-nota-fisc.cod-estabel,
                                        INPUT b-it-nota-fisc.serie,
                                        INPUT b-it-nota-fisc.nr-nota-fis,
                                        INPUT b-it-nota-fisc.nat-operacao).

FIND FIRST gg-ext-nota-fiscal NO-LOCK
     WHERE gg-ext-nota-fiscal.cod-estabel = b-it-nota-fisc.cod-estabel 
       AND gg-ext-nota-fiscal.serie       = b-it-nota-fisc.serie 
       AND gg-ext-nota-fiscal.nr-nota-fis = b-it-nota-fisc.nr-nota-fis NO-ERROR.

FOR FIRST estabelec FIELDS(ep-codigo) NO-LOCK 
    WHERE estabelec.cod-estabel = b-it-nota-fisc.cod-estabel:
    ASSIGN i-empresa-estab = estabelec.ep-codigo.
END.

IF NOT VALID-HANDLE(h-ggapi112) THEN
    RUN ggp/ggapi112.p PERSISTENT SET h-ggapi112.

IF nota-fiscal.ind-tip-nota <> 8 /* Diferente de Recebimento */ THEN DO: /* Saidas */
    IF b-it-nota-fisc.nr-pedcli <> "" THEN DO: /* somente saidas com pedido */
        ASSIGN i-ctr-ep-codigo    = ""  l-cancelamento = NO 
               c-ctr-cod-contrato = ""  l-atu-ctr      = NO.
        
        RUN piAtualVendas (INPUT b-it-nota-fisc.nr-seq-ped,
                           INPUT "",
                           INPUT "",
                           INPUT 0). 
        
        /* pedido */
        FOR FIRST gg-ext-ped-venda NO-LOCK 
            WHERE gg-ext-ped-venda.nome-abrev = b-it-nota-fisc.nome-ab-cli 
              AND gg-ext-ped-venda.nr-pedcli  = b-it-nota-fisc.nr-pedcli:
    
               IF  gg-ext-ped-venda.cod-contrato <> "" THEN DO: 
                   ASSIGN OVERLAY(b-it-nota-fisc.char-2,247,20) = gg-ext-ped-venda.cod-contrato.

                   IF  l-atu-ctr = NO THEN DO:  /* n∆o atualizou o contrato, pois n∆o achou gg-contrato-prod, pode ser item controlado por lote e CTL */
                       
                       FIND FIRST gg-contrato NO-LOCK
                            WHERE gg-contrato.ep-codigo    = gg-ext-ped-venda.ep-codigo
                              AND gg-contrato.cod-contrato = gg-ext-ped-venda.cod-contrato NO-ERROR.
                       IF AVAIL gg-contrato
                       AND gg-contrato.log-utiliza-caract-lote = YES THEN DO:
                           
                           /* itens controlados por Lote e caracter°sticas n∆o possui a sequencia do item do pedido relacionada na gg-contrato-prod, precisa da gg-lote */
                           /* basta o 1o lote para localizar o produto do contrato */
                           FOR FIRST fat-ser-lote OF b-it-nota-fisc NO-LOCK: 
                               
                               FOR FIRST gg-lote NO-LOCK 
                                   WHERE gg-lote.cod-lote       = fat-ser-lote.nr-serlote
                                     AND gg-lote.it-codigo      = fat-ser-lote.it-codigo 
                                     AND gg-lote.cod-refer-item = fat-ser-lote.cod-refer
                                     AND gg-lote.nr-pedcli      = b-it-nota-fisc.nr-pedcli
                                     AND gg-lote.nom-abrev      = b-it-nota-fisc.nome-ab-cli: 
                                   
                                   RUN piAtualVendas (INPUT 0,
                                                      INPUT gg-ext-ped-venda.ep-codigo,    
                                                      INPUT gg-ext-ped-venda.cod-contrato, 
                                                      INPUT gg-lote.num-seq-prod). 
                               END.
                           END.
                       END.
                   END.
               END.
               
               FOR FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK 
                   WHERE gg-ext-nota-fiscal.cod-estabel = b-it-nota-fisc.cod-estabel 
                     AND gg-ext-nota-fiscal.serie       = b-it-nota-fisc.serie 
                     AND gg-ext-nota-fiscal.nr-nota-fis = b-it-nota-fisc.nr-nota-fis:
                  ASSIGN gg-ext-nota-fiscal.ep-codigo    = gg-ext-ped-venda.ep-codigo     
                         gg-ext-nota-fiscal.cod-contrato = gg-ext-ped-venda.cod-contrato.  
               END.

               FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.
        END.
        IF AVAIL gg-contrato-prod THEN
            FIND CURRENT gg-contrato-prod NO-LOCK NO-ERROR.

        /*verifica se precisa mudar a situacao do contrato*/
        IF i-ctr-ep-codigo <> "" AND c-ctr-cod-contrato <> "" THEN DO:
            FIND FIRST gg-contrato NO-LOCK
                 WHERE gg-contrato.ep-codigo    = i-ctr-ep-codigo
                   AND gg-contrato.cod-contrato = c-ctr-cod-contrato NO-ERROR.
               
            IF AVAIL gg-contrato THEN DO:
    
                IF  CAN-FIND(FIRST b-gg-contrato-prod OF gg-contrato)
                AND gg-contrato.ind-tip-preco = 1 /*Fixo*/ THEN DO:
                   ASSIGN l-entegou = YES.
                   
                   blLocalProd:
                   FOR EACH b-gg-contrato-prod OF gg-contrato NO-LOCK:
                       IF b-gg-contrato-prod.qtd-entrega < b-gg-contrato-prod.qtd-contrato /*n∆o entrego tudo*/ THEN DO:
                           ASSIGN l-entegou = NO.
                           LEAVE blLocalProd.
                       END.
                   END.
    
                   IF  NOT l-entegou
                   AND l-cancelamento 
                   AND gg-contrato.ind-situacao = 9 /*encerrado*/ THEN DO: /*reabrir o contrato*/
                        FIND CURRENT gg-contrato EXCLUSIVE-LOCK NO-ERROR.
                        ASSIGN gg-contrato.ind-situacao = 2. /*fechado*/
                        FIND CURRENT gg-contrato NO-LOCK        NO-ERROR. 
                   END.
                END.
                
            END.
        END.

    END.
    
    IF b-it-nota-fisc.dt-cancela <> ? THEN DO:
       RUN pi-altera-status-romaneio.
    END.
    ELSE DO:
        FOR EACH gg-mov-contr NO-LOCK
           WHERE gg-mov-contr.cod-estabel   = b-it-nota-fisc.cod-estabel 
           AND   gg-mov-contr.num-romaneio  = INT(SUBSTR(b-it-nota-fisc.char-2,232,9))
           AND   gg-mov-contr.num-seq       = INT(SUBSTR(b-it-nota-fisc.char-2,241,6))
           AND   gg-mov-contr.ind-situacao <> 3 /*Confirmado*/ :

            IF VALID-HANDLE(h-ggapi112) THEN
                RUN piAtualizaOpeLogistica IN h-ggapi112 (INPUT gg-mov-contr.cod-estabel,
                                                          INPUT gg-mov-contr.num-romaneio,
                                                          INPUT gg-mov-contr.num-seq,
                                                          INPUT gg-mov-contr.qtd-fiscal,
                                                          INPUT 1 /* Atualizacao NF */ ).
        END.
    END.

    FOR FIRST natur-oper FIELDS (char-2) NO-LOCK 
        WHERE natur-oper.nat-operacao = b-it-nota-fisc.nat-operacao: 
        ASSIGN l-dev-valor = substr(natur-oper.char-2,88,5) = "1".
    END.
    
    IF  nota-fiscal.esp-docto  = 20 /* NFD */ AND l-dev-valor = NO /*n∆o considerar devoluá∆o somente de valor*/ THEN DO: 
        RUN pi-devolucao-compra.
    END.

    IF  b-it-nota-fisc.dt-cancela <> ? THEN DO: /* Devolucao de compra */

        /* Volta a pendencia de devolucao por pendencia de quantidade: Compra ou Armazenagem */
        FIND FIRST gg-pendencia EXCLUSIVE-LOCK
             WHERE gg-pendencia.serie-docto-rec  = b-it-nota-fisc.serie
               AND gg-pendencia.nr-docto-rec     = b-it-nota-fisc.nr-nota-fis
               AND gg-pendencia.cod-emitente-rec = nota-fiscal.cod-emitente
               AND gg-pendencia.nat-operacao-rec = b-it-nota-fisc.nat-operacao
               AND gg-pendencia.cod-estabel      = b-it-nota-fisc.cod-estabel NO-ERROR.
        IF  AVAIL gg-pendencia THEN DO:
            ASSIGN gg-pendencia.nr-docto-ap      = ""
                   gg-pendencia.log-pendente     = YES.

            FIND CURRENT gg-pendencia NO-LOCK NO-ERROR.
        END.
        /* Volta a pendencia de devoluá∆o por pendencia de quantidade: Compra ou Armazenagem */
    END.

    FOR FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK 
        WHERE gg-ext-nota-fiscal.cod-estabel = b-it-nota-fisc.cod-estabel 
          AND gg-ext-nota-fiscal.serie       = b-it-nota-fisc.serie 
          AND gg-ext-nota-fiscal.nr-nota-fis = b-it-nota-fisc.nr-nota-fis:
    
        IF TRIM(gg-ext-nota-fiscal.cod-contrato) = "" AND TRIM(SUBSTR(b-it-nota-fisc.char-2,247,20)) <> "" THEN
            ASSIGN gg-ext-nota-fiscal.cod-contrato = TRIM(SUBSTR(b-it-nota-fisc.char-2,247,20)).
    END.
    FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.

END.
ELSE DO:  /* Recebimento */
    
    IF nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-ant  THEN DO:

        FIND FIRST item-doc-est NO-LOCK
             WHERE item-doc-est.serie-docto  = b-it-nota-fisc.serie
               AND item-doc-est.nro-docto    = b-it-nota-fisc.nr-nota-fis
               AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
               AND item-doc-est.nat-operacao = b-it-nota-fisc.nat-operacao
               AND item-doc-est.sequencia    = b-it-nota-fisc.nr-seq-fat NO-ERROR.  
        
    END.
    ELSE DO:

        FIND FIRST item-doc-est NO-LOCK
             WHERE item-doc-est.serie-docto  = b-it-nota-fisc.serie
               AND item-doc-est.nro-docto    = nota-fiscal.nr-nota-ant
               AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
               AND item-doc-est.nat-operacao = b-it-nota-fisc.nat-operacao
               AND item-doc-est.sequencia    = b-it-nota-fisc.nr-seq-fat NO-ERROR.  
        
    END.

    IF  AVAIL item-doc-est THEN DO:
        IF  b-it-nota-fisc.dt-cancela = ? THEN DO:        

            ASSIGN OVERLAY(b-it-nota-fisc.char-2,232,9)  = TRIM(SUBSTR(item-doc-est.char-2,525,09))  /* Romaneio */
                   OVERLAY(b-it-nota-fisc.char-2,241,6)  = TRIM(SUBSTR(item-doc-est.char-2,534,06))  /* Sequenc  */
                   OVERLAY(b-it-nota-fisc.char-2,247,20) = TRIM(SUBSTR(item-doc-est.char-2,540,20)). /* Contrato */

        END.
    END.
    ELSE DO:

        FIND FIRST item-doc-est NO-LOCK
         WHERE item-doc-est.serie-docto  = b-it-nota-fisc.serie
           AND item-doc-est.nro-docto    = b-it-nota-fisc.nr-nota-fis
           AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
           AND item-doc-est.nat-operacao = b-it-nota-fisc.nat-operacao NO-ERROR.  

    END.
END.

IF VALID-HANDLE(h-ggapi112) THEN DO:
    DELETE PROCEDURE h-ggapi112.
    ASSIGN h-ggapi112 = ?.
END.



/*--------------------------------------------------------------------------------------------------------------------*/
PROCEDURE piAtualVendas: 
    DEF INPUT PARAM i-nr-seq-ped   AS INT  NO-UNDO. 
    DEF INPUT PARAM c-ep-codigo    AS CHAR NO-UNDO. 
    DEF INPUT PARAM c-cod-contrato AS CHAR NO-UNDO. 
    DEF INPUT PARAM i-num-seq-prod AS INT  NO-UNDO. 

    IF  i-nr-seq-ped > 0  THEN DO:
        FOR FIRST gg-contrato-prod EXCLUSIVE-LOCK
            WHERE gg-contrato-prod.nome-abrev   = b-it-nota-fisc.nome-ab-cli 
              AND gg-contrato-prod.nr-pedcli    = b-it-nota-fisc.nr-pedcli
              AND gg-contrato-prod.nr-sequencia = i-nr-seq-ped
              AND gg-contrato-prod.it-codigo    = b-it-nota-fisc.it-codigo: 
        
            /* itens controlados por Lote e caracter°sticas n∆o possui a sequencia do item do pedido relacionada na gg-contrato-prod, precisa da gg-lote */
    
            /* tratar cancelamento de uma nota vendas MI */
            IF b-it-nota-fisc.dt-cancela <> ? THEN DO:
               RUN pi-cancela-vendas-mi.
            END.
            ELSE DO: 
            /* tratar nota vendas MI */
               RUN pi-cria-entrega-vendas-mi.
            END.
    
            ASSIGN i-ctr-ep-codigo    = gg-contrato-prod.ep-codigo
                   c-ctr-cod-contrato = gg-contrato-prod.cod-contrato
                   l-cancelamento     = IF b-it-nota-fisc.dt-cancela <> ? THEN YES ELSE NO
                   l-atu-ctr          = YES.
        END.
    END.
    ELSE DO: 
        FOR FIRST gg-contrato-prod EXCLUSIVE-LOCK
            WHERE gg-contrato-prod.ep-codigo    = c-ep-codigo   
              AND gg-contrato-prod.cod-contrato = c-cod-contrato
              AND gg-contrato-prod.num-seq-prod = i-num-seq-prod:
        
            /* tratar cancelamento de uma nota vendas MI */
            IF b-it-nota-fisc.dt-cancela <> ? THEN DO:
               RUN pi-cancela-vendas-mi.
            END.
            ELSE DO: 
            /* tratar nota vendas MI */
               RUN pi-cria-entrega-vendas-mi.
            END.
    
            ASSIGN i-ctr-ep-codigo    = gg-contrato-prod.ep-codigo
                   c-ctr-cod-contrato = gg-contrato-prod.cod-contrato
                   l-cancelamento     = IF b-it-nota-fisc.dt-cancela <> ? THEN YES ELSE NO
                   l-atu-ctr          = YES.
        END.

    END.

    RETURN "OK":U.
END PROCEDURE. 

PROCEDURE pi-cria-entrega-vendas-mi:

DEF VAR c-seq                       AS CHAR NO-UNDO. 
DEF VAR de-qt-entrega-ant           AS DEC  NO-UNDO.
DEF VAR c-tipo-nota                 AS CHAR NO-UNDO. 
DEF VAR c-mes1                      AS CHAR NO-UNDO FORMAT "x(43)".

{utp/ut-liter.i "Entrega atravÇs de Faturamento Pedido nr." * R}
ASSIGN c-mes1 = RETURN-VALUE.

/* verificar se e entrega futura, apenas a nota global */ 

ASSIGN c-tipo-nota = "".
FOR FIRST natur-oper FIELDS (char-1 ind-entfut ind-est-qtd) NO-LOCK 
    WHERE natur-oper.nat-operacao = b-it-nota-fisc.nat-operacao: 
    IF  SUBSTR(natur-oper.char-1,1,5) <> "1    "   /* 0 - Faturamento Entrega Futura */
    AND natur-oper.ind-entfut  = YES
    AND natur-oper.ind-est-qtd = NO THEN 
       ASSIGN c-tipo-nota = "FFU":U.
    ELSE
        IF  SUBSTR(natur-oper.char-1,1,5) = "1"  /* 1 - Faturamento Antecipado */
        AND natur-oper.ind-entfut         = YES
        AND natur-oper.ind-est-qtd        = NO THEN
            ASSIGN c-tipo-nota = "FFU":U.
END.
IF c-tipo-nota = "FFU":U THEN NEXT. /* nao deve criar entrega global como entrega no contrato, apenas as remessas */

IF nota-fiscal.ind-tip-nota <> 3 THEN DO:

    ASSIGN c-seq = string(b-it-nota-fisc.nr-seq-fat).

    FIND FIRST gg-contrato-mov NO-LOCK 
         WHERE gg-contrato-mov.serie-docto  = b-it-nota-fisc.serie
           AND gg-contrato-mov.nro-docto    = b-it-nota-fisc.nr-nota-fis
           AND gg-contrato-mov.cod-emitente = nota-fiscal.cod-emitente
           AND gg-contrato-mov.nat-operacao = b-it-nota-fisc.nat-operacao 
           AND gg-contrato-mov.cod-estabel  = b-it-nota-fisc.cod-estabel
           AND gg-contrato-mov.num-seq-prod = gg-contrato-prod.num-seq-prod
           AND gg-contrato-mov.it-codigo    = b-it-nota-fisc.it-codigo 
           AND gg-contrato-mov.referencia   = c-seq NO-ERROR.
    
    IF  NOT AVAIL gg-contrato-mov THEN DO:
        FIND LAST gg-contrato-mov EXCLUSIVE-LOCK 
            WHERE gg-contrato-mov.ep-codigo    = gg-contrato-prod.ep-codigo 
              AND gg-contrato-mov.cod-contrato = gg-contrato-prod.cod-contrato NO-ERROR. 

        IF AVAIL gg-contrato-mov THEN
            ASSIGN i-seq = gg-contrato-mov.num-seq + 1.
        ELSE 
            ASSIGN i-seq = 1. 

        FIND FIRST gg-mov-contr NO-LOCK
             WHERE gg-mov-contr.cod-estabel  = b-it-nota-fisc.cod-estabel 
               AND gg-mov-contr.num-romaneio = INT(SUBSTR(b-it-nota-fisc.char-2,232,9))
               AND gg-mov-contr.num-seq      = INT(SUBSTR(b-it-nota-fisc.char-2,241,6)) NO-ERROR.

        CREATE gg-contrato-mov. 
        ASSIGN gg-contrato-mov.ep-codigo        = gg-contrato-prod.ep-codigo
               gg-contrato-mov.cod-contrato     = gg-contrato-prod.cod-contrato
               gg-contrato-mov.num-seq          = i-seq
               gg-contrato-mov.cod-estabel      = b-it-nota-fisc.cod-estabel
               gg-contrato-mov.num-romaneio     = IF AVAIL gg-mov-contr THEN gg-mov-contr.num-romaneio ELSE 0
               gg-contrato-mov.num-seq-fix      = 0 /* no primeiro momento ser† 0 */
               gg-contrato-mov.referencia       = c-seq
               gg-contrato-mov.int-1            = b-it-nota-fisc.nr-seq-fat
               gg-contrato-mov.num-seq-prod     = gg-contrato-prod.num-seq-prod
               gg-contrato-mov.it-codigo        = gg-contrato-prod.it-codigo
               gg-contrato-mov.cod-refer        = b-it-nota-fisc.cod-refer
               gg-contrato-mov.serie-docto      = b-it-nota-fisc.serie              
               gg-contrato-mov.nro-docto        = b-it-nota-fisc.nr-nota-fis       
               gg-contrato-mov.cod-emitente     = nota-fiscal.cod-emitente          
               gg-contrato-mov.nat-operacao     = b-it-nota-fisc.nat-operacao      
               gg-contrato-mov.dat-mov          = b-it-nota-fisc.dt-emis-nota
               gg-contrato-mov.ind-transacao    = 1 /* entrega vendas MI */
               gg-contrato-mov.qtd-peso         = b-it-nota-fisc.qt-faturada[1]
               gg-contrato-mov.val-total        = b-it-nota-fisc.vl-tot-item     
               gg-contrato-mov.des-observa      = c-mes1 + b-it-nota-fisc.nr-pedcli
               gg-contrato-mov.cod-usuario      = c-seg-usuario.

        ASSIGN de-qt-entrega-ant            = gg-contrato-prod.qtd-entrega
               gg-contrato-prod.qtd-entrega = gg-contrato-prod.qtd-entrega  + gg-contrato-mov.qtd-peso
               gg-contrato-prod.qtd-saldo   = gg-contrato-prod.qtd-contrato - gg-contrato-prod.qtd-entrega.

        ASSIGN OVERLAY(b-it-nota-fisc.char-2,247,20) = gg-contrato-prod.cod-contrato.

        /* atualizar as entregas das fixacoes */ 
        RUN ggp/ggapi096.p (INPUT "it-nota-fisc",
                            INPUT ROWID(b-it-nota-fisc),
                            INPUT 1,
                            INPUT YES,
                            OUTPUT TABLE tt-erro).
    END.
    ELSE DO: 
       FIND CURRENT gg-contrato-mov EXCLUSIVE-LOCK NO-ERROR. 
       FIND FIRST gg-mov-contr NO-LOCK
           WHERE gg-mov-contr.cod-estabel  = b-it-nota-fisc.cod-estabel 
             AND gg-mov-contr.num-romaneio = INT(SUBSTR(b-it-nota-fisc.char-2,232,9))
             AND gg-mov-contr.num-seq      = INT(SUBSTR(b-it-nota-fisc.char-2,241,6)) NO-ERROR.
       IF  AVAIL gg-mov-contr THEN DO: 
          ASSIGN gg-contrato-mov.num-romaneio = gg-mov-contr.num-romaneio.
       END.
    END.
END.

FOR FIRST gg-ext-nota-fiscal EXCLUSIVE-LOCK 
    WHERE gg-ext-nota-fiscal.cod-estabel = b-it-nota-fisc.cod-estabel 
      AND gg-ext-nota-fiscal.serie       = b-it-nota-fisc.serie 
      AND gg-ext-nota-fiscal.nr-nota-fis = b-it-nota-fisc.nr-nota-fis:
   ASSIGN gg-ext-nota-fiscal.ep-codigo    = gg-contrato-prod.ep-codigo     
          gg-ext-nota-fiscal.cod-contrato = gg-contrato-prod.cod-contrato.  
END.
FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.

RETURN "OK":U.

END PROCEDURE.

/*--------------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-cancela-vendas-mi:
    DEF VAR c-seq AS CHAR NO-UNDO. 

    ASSIGN c-seq = string(b-it-nota-fisc.nr-seq-fat).

    FOR FIRST gg-contrato-mov EXCLUSIVE-LOCK 
        WHERE gg-contrato-mov.serie-docto  = b-it-nota-fisc.serie
          AND gg-contrato-mov.nro-docto    = b-it-nota-fisc.nr-nota-fis
          AND gg-contrato-mov.cod-emitente = nota-fiscal.cod-emitente
          AND gg-contrato-mov.nat-operacao = b-it-nota-fisc.nat-operacao 
          AND gg-contrato-mov.cod-estabel  = b-it-nota-fisc.cod-estabel
          AND gg-contrato-mov.num-seq-prod = gg-contrato-prod.num-seq-prod
          AND gg-contrato-mov.it-codigo    = b-it-nota-fisc.it-codigo 
          AND gg-contrato-mov.referencia   = c-seq:

        ASSIGN gg-contrato-prod.qtd-entrega = gg-contrato-prod.qtd-entrega  - gg-contrato-mov.qtd-peso
               gg-contrato-prod.qtd-saldo   = gg-contrato-prod.qtd-contrato - gg-contrato-prod.qtd-entrega.

        /* cancelar as entregas das fixacoes */ 
        RUN ggp/ggapi096.p (INPUT "it-nota-fisc",
                            INPUT ROWID(b-it-nota-fisc),
                            INPUT 2,
                            INPUT YES,
                            OUTPUT TABLE tt-erro).
        DELETE gg-contrato-mov.
    END.

    RETURN "OK":U.

END PROCEDURE. 

PROCEDURE pi-devolucao-compra:

    DEF VAR l-global-entrega-futura AS LOGICAL   NO-UNDO INITIAL NO.
    DEF VAR c-mes6                  AS CHARACTER NO-UNDO FORMAT "x(38)".
    DEF VAR c-nr                    AS CHARACTER NO-UNDO FORMAT "x(4)".
    DEF VAR c-forn                  AS CHARACTER NO-UNDO FORMAT "x(6)".
    DEF VAR c-nat                   AS CHARACTER NO-UNDO FORMAT "x(5)".
    DEF VAR de-qtd-pago             AS DECIMAL   NO-UNDO.
    DEF VAR de-qtd-devol            AS DECIMAL   NO-UNDO.
    DEF VAR de-qtd-entrega          AS DECIMAL   NO-UNDO.
    DEF VAR de-qtd-saldo            AS DECIMAL   NO-UNDO.
    DEF VAR h-ggapi074              AS HANDLE    NO-UNDO. 

    {utp/ut-liter.i "Devolucao de Produto. Nota Origem: Ser " * R}
    ASSIGN c-mes6 = RETURN-VALUE.
    {utp/ut-liter.i " Nr " * R}
    ASSIGN c-nr =   RETURN-VALUE.
    {utp/ut-liter.i " Forn " * R}
    ASSIGN c-forn = RETURN-VALUE.
    {utp/ut-liter.i " Nat " * R}
    ASSIGN c-nat =  RETURN-VALUE.

    ASSIGN c-contrato-item = TRIM(SUBSTR(b-it-nota-fisc.char-2,247,20)).

    RUN ggp/ggapi074.p PERSISTENT SET h-ggapi074.

    IF  b-it-nota-fisc.dt-cancela = ? THEN DO: /* Devoluá∆o de compra */
        IF c-contrato-item = "" THEN DO:

           /* Atualizar no item da devoluá∆o o contrato de origem */
           FIND FIRST item-doc-est NO-LOCK
                 WHERE item-doc-est.serie-docto  = b-it-nota-fisc.serie-docum
                 AND   item-doc-est.nro-docto    = b-it-nota-fisc.nr-docum
                 AND   item-doc-est.cod-emitente = b-it-nota-fisc.cd-emitente
                 AND   item-doc-est.nat-operacao = b-it-nota-fisc.nat-docum
                 AND   item-doc-est.sequencia    = b-it-nota-fisc.int-1 NO-ERROR.
           IF  AVAIL item-doc-est THEN DO:
               ASSIGN OVERLAY(b-it-nota-fisc.char-2,247,20) = TRIM(SUBSTR(item-doc-est.char-2,540,20))
                      c-contrato-item = TRIM(SUBSTR(item-doc-est.char-2,540,20)).

                  /*Verificar se a nota de origem da devolucao nao tem romaneio,*/
                  /*e neste caso pode ser global de entrega futura e n∆o pode atualizar*/
                  /*o contrato*/

               IF INT(SUBSTR(item-doc-est.char-2,525,9)) = 0  THEN
                  ASSIGN l-global-entrega-futura = YES.
           END.

           EMPTY TEMP-TABLE tt-entrega-rom NO-ERROR.
           CREATE tt-entrega-rom.
           ASSIGN tt-entrega-rom.serie-docto   = b-it-nota-fisc.serie-docum
                  tt-entrega-rom.nro-docto     = b-it-nota-fisc.nr-docum
                  tt-entrega-rom.nat-operacao  = b-it-nota-fisc.nat-docum
                  tt-entrega-rom.cod-emitente  = b-it-nota-fisc.cd-emitente
                  tt-entrega-rom.sequencia     = b-it-nota-fisc.int-1
                  tt-entrega-rom.cod-refer     = b-it-nota-fisc.cod-refer
                  tt-entrega-rom.it-codigo     = b-it-nota-fisc.it-codigo.             

           RUN pi-busca-entrega-rom IN h-ggapi074 (INPUT-OUTPUT TABLE tt-entrega-rom).

           FIND FIRST tt-entrega-rom NO-LOCK NO-ERROR.
           ASSIGN de-qtd-pago    = tt-entrega-rom.qt-pago
                  de-qtd-devol   = tt-entrega-rom.qt-devolvida.

           IF  tt-entrega-rom.log-devolucao AND tt-entrega-rom.qt-fisico < tt-entrega-rom.qt-fiscal THEN
               ASSIGN de-qtd-entrega = tt-entrega-rom.qt-fisico.
           ELSE
               ASSIGN de-qtd-entrega = tt-entrega-rom.qt-fiscal.

           /* Atualizar a devoluá∆o no contrato de originaá∆o */
           IF  c-contrato-item            <> "" 
           AND l-global-entrega-futura     = NO
           AND tt-entrega-rom.num-romaneio > 0  THEN DO:  /*  tratamento para DAGROOGD-2844 - devoluá∆o de entrada que n∆o seja compra mas que tenha o contrato para rastreabilidade */
               /* descontar a pr¢pria devoluá∆o que est† sendo atualizada nesta pr¢pria nota, 
                  h† uma funá∆o/parÉmetro no faturamento que atualiza a nota antes no estoque, 
                  e pode ser que esteja ligada no ambiente e assim descontar a pr¢pria devoluá∆o, por isso que n∆o foi simulado antes 
                  o objetivo Ç que na de-qtd-devol fiquem apenas devoluá‰es anteriores, 
                  pois na h-ggapi074 conforme essa funá∆o do faturamento estar ligada j† retorna inclusive a pr¢pria nota, ent∆o vamos por garantia descontar aqui */
               FOR EACH devol-forn FIELDS(qt-devol) NO-LOCK
                  WHERE devol-forn.serie-docto  = b-it-nota-fisc.serie-docum
                    AND devol-forn.nro-docto    = b-it-nota-fisc.nr-docum
                    AND devol-forn.cod-emitente = b-it-nota-fisc.cd-emitente
                    AND devol-forn.nat-operacao = b-it-nota-fisc.nat-docum
                    AND devol-forn.sequencia    = b-it-nota-fisc.int-1
                    AND devol-forn.cod-estabel  = b-it-nota-fisc.cod-estabel
                    AND devol-forn.serie        = b-it-nota-fisc.serie
                    AND devol-forn.nr-nota-fis  = b-it-nota-fisc.nr-nota-fis:
                  ASSIGN de-qtd-devol   = de-qtd-devol - devol-forn.qt-devol.
                  IF  de-qtd-devol < 0 THEN
                      ASSIGN de-qtd-devol = 0.  /* so por desencargo */
               END.

               /* verificar se j† foi atualizado a devoluá∆o */
               FIND FIRST gg-contrato-mov NO-LOCK 
                    WHERE gg-contrato-mov.serie-docto   = b-it-nota-fisc.serie 
                    AND   gg-contrato-mov.nro-docto     = b-it-nota-fisc.nr-nota-fis
                    AND   gg-contrato-mov.cod-emitente  = nota-fiscal.cod-emitente
                    AND   gg-contrato-mov.nat-operacao  = b-it-nota-fisc.nat-operacao
                    AND   gg-contrato-mov.cod-estabel   = b-it-nota-fisc.cod-estabel 
                    AND   gg-contrato-mov.ind-transacao = 9 /* devolucao */
                    AND   gg-contrato-mov.referencia    = TRIM(STRING(b-it-nota-fisc.nr-seq-fat)) NO-ERROR. 

               /* se n∆o foi atualizado ainda, entao atualizar */
               IF  NOT AVAIL gg-contrato-mov THEN DO:
                   FIND FIRST gg-contrato EXCLUSIVE-LOCK
                        WHERE gg-contrato.ep-codigo    = i-empresa-estab
                        AND   gg-contrato.cod-contrato = c-contrato-item NO-ERROR.
                   /**** cria historico do contrato ****/
                   {utp/ut-liter.i "Atualizado Nota de Devoluá∆o Compra" * R}
                   IF AVAIL gg-contrato THEN
                       RUN ggp/ggapi003.p (INPUT ROWID(gg-contrato), INPUT RETURN-VALUE + b-it-nota-fisc.nr-nota-fis + "/" + b-it-nota-fisc.serie + "/" + " Nota de origem: " + b-it-nota-fisc.nr-docum + "/" + b-it-nota-fisc.serie-docum). 

                   /** criar o movimento de devolucao **/
                   FIND LAST  gg-contrato-mov NO-LOCK 
                        WHERE gg-contrato-mov.ep-codigo    =  i-empresa-estab
                        AND   gg-contrato-mov.cod-contrato =  c-contrato-item NO-ERROR. 

                   IF AVAIL gg-contrato-mov THEN
                       ASSIGN i-seq = gg-contrato-mov.num-seq + 1.
                   ELSE 
                       ASSIGN i-seq = 1. 

                   ASSIGN de-qtd-saldo = de-qtd-entrega - (IF  tt-entrega-rom.log-devolucao THEN tt-entrega-rom.qt-fisico ELSE de-qtd-pago)
                          de-qtd-saldo = IF de-qtd-saldo > de-qtd-devol THEN  de-qtd-saldo - de-qtd-devol ELSE 0
                          de-qtd-saldo = IF de-qtd-saldo > b-it-nota-fisc.qt-faturada[1] THEN b-it-nota-fisc.qt-faturada[1] ELSE IF de-qtd-saldo > 0 THEN de-qtd-saldo ELSE b-it-nota-fisc.qt-faturada[1].

                   CREATE gg-contrato-mov. 
                   ASSIGN gg-contrato-mov.serie-docto     = b-it-nota-fisc.serie 
                          gg-contrato-mov.nro-docto       = b-it-nota-fisc.nr-nota-fis
                          gg-contrato-mov.cod-emitente    = nota-fiscal.cod-emitente
                          gg-contrato-mov.nat-operacao    = b-it-nota-fisc.nat-operacao
                          gg-contrato-mov.cod-estabel     = b-it-nota-fisc.cod-estabel 
                          gg-contrato-mov.ind-transacao   = 9 /* devolucao */
                          gg-contrato-mov.cod-contrato    = c-contrato-item
                          gg-contrato-mov.ep-codigo       = i-empresa-estab
                          gg-contrato-mov.referencia      = TRIM(STRING(b-it-nota-fisc.nr-seq-fat))
                          gg-contrato-mov.int-1           = b-it-nota-fisc.nr-seq-fat
                          gg-contrato-mov.num-seq         = i-seq
                          gg-contrato-mov.dat-mov         = b-it-nota-fisc.dt-emis-nota
                          gg-contrato-mov.dec-1           = b-it-nota-fisc.qt-faturada[1]   /* qtd-entreg-fisc (entrega fiscal) */
                          gg-contrato-mov.des-observa     = c-mes6
                                                            + b-it-nota-fisc.serie-docum         + c-nr 
                                                            + b-it-nota-fisc.nr-docum            + c-forn    
                                                            + STRING(b-it-nota-fisc.cd-emitente) + c-nat
                                                            + b-it-nota-fisc.nat-docum           + " " + STRING(de-qtd-saldo)    
                          gg-contrato-mov.mo-codigo       = 0
                          gg-contrato-mov.val-total       = b-it-nota-fisc.vl-tot-item
                          gg-contrato-mov.num-seq-fix     = 0
                          gg-contrato-mov.it-codigo       = b-it-nota-fisc.it-codigo
                          gg-contrato-mov.cod-refer       = b-it-nota-fisc.cod-refer
                          gg-contrato-mov.num-seq-prod    = tt-entrega-rom.num-seq-prod.

                   FIND FIRST gg-mov-contr  NO-LOCK
                       WHERE gg-mov-contr.cod-estabel  = b-it-nota-fisc.cod-estabel 
                       AND   gg-mov-contr.num-romaneio = INT(SUBSTR(b-it-nota-fisc.char-2,232,9))
                       AND   gg-mov-contr.num-seq      = INT(SUBSTR(b-it-nota-fisc.char-2,241,6)) NO-ERROR.
                                                         
                   IF  AVAIL gg-mov-contr THEN DO:
                       ASSIGN gg-contrato-mov.num-romaneio     = gg-mov-contr.num-romaneio
                              gg-contrato-mov.dec-2            = IF gg-mov-contr.dec-2 > 0 THEN  /* qtd-entreg-fisic (entrega f≠sica) / qtd-fisic (quantidade f≠sica) */
                                                                    de-qtd-saldo
                                                                 ELSE 0
                              gg-contrato-mov.qtd-peso         = IF gg-mov-contr.qtd-peso > 0 THEN
                                                                    de-qtd-saldo
                                                                 ELSE 0.
                   END.
                   ELSE DO:
                       ASSIGN gg-contrato-mov.num-romaneio     = 0
                              gg-contrato-mov.dec-2            = de-qtd-saldo   /* qtd-entreg-fisic (entrega f≠sica) */
                              gg-contrato-mov.qtd-peso         = de-qtd-saldo.
                   END.

                   /** voltar saldo do contrato **/
                   IF  AVAIL gg-contrato THEN DO:

                       IF  gg-contrato.log-multi-produt = NO THEN DO:
                           ASSIGN gg-contrato.qtd-entrega = gg-contrato.qtd-entrega - gg-contrato-mov.qtd-peso
                                  gg-contrato.val-livre-3 = gg-contrato.val-livre-3 - de-qtd-saldo.      /* qtd-entreg-fisc (entrega fiscal) */

                           RUN pi-atualiza-saldo-contrato-compra.

                           IF  gg-contrato.ind-situacao = 9    /* Encerrado */
                           AND gg-contrato.log-saldo    = YES
                           THEN DO:

                               //Verificar devoluá∆o est† vinculada em uma entrega marcada como permite devolver
                               FIND FIRST gg-contrato-mov NO-LOCK
                                    WHERE gg-contrato-mov.cod-estabel   = b-it-nota-fisc.cod-estabel
                                      AND gg-contrato-mov.serie-docto   = b-it-nota-fisc.serie-docum
                                      AND gg-contrato-mov.nro-docto     = b-it-nota-fisc.nr-docum
                                      AND gg-contrato-mov.nat-operacao  = b-it-nota-fisc.nat-docum
                                      AND gg-contrato-mov.cod-emitente  = b-it-nota-fisc.cd-emitente 
                                      AND gg-contrato-mov.ind-transacao = 1 /*Entrega*/ NO-ERROR.
                               IF  AVAIL gg-contrato-mov AND gg-contrato-mov.log-livre-3 /*Permite Devoluá∆o*/ THEN DO:
                                   ASSIGN gg-contrato.ind-situacao = 2. /* fechado */
                               END.
                           END.
                       END. 
                       ELSE DO: 
                           FIND FIRST gg-contrato-prod EXCLUSIVE-LOCK OF gg-contrato 
                                WHERE gg-contrato-prod.num-seq-prod = gg-contrato-mov.num-seq-prod NO-ERROR. 
                           IF AVAIL gg-contrato-prod THEN DO:
                              ASSIGN gg-contrato-prod.qtd-entrega = gg-contrato-prod.qtd-entrega   - gg-contrato-mov.qtd-peso
                                     gg-contrato-prod.qtd-saldo   = gg-contrato-prod.qtd-contrato  - gg-contrato-prod.qtd-entrega
                                     gg-contrato.log-saldo        = YES.
                              FIND CURRENT gg-contrato-prod NO-LOCK NO-ERROR.
                           END.
                       END.

                       FIND CURRENT gg-contrato NO-LOCK NO-ERROR.
                   END.
               END.
           END.
        END.
        ELSE DO: 
           /* verificar se j† foi atualizado a devoluá∆o */
           FIND FIRST gg-contrato-mov NO-LOCK 
                WHERE gg-contrato-mov.serie-docto   = b-it-nota-fisc.serie 
                AND   gg-contrato-mov.nro-docto     = b-it-nota-fisc.nr-nota-fis
                AND   gg-contrato-mov.cod-emitente  = nota-fiscal.cod-emitente
                AND   gg-contrato-mov.nat-operacao  = b-it-nota-fisc.nat-operacao
                AND   gg-contrato-mov.cod-estabel   = b-it-nota-fisc.cod-estabel 
                AND   gg-contrato-mov.ind-transacao = 9 /* devolucao */
                AND   gg-contrato-mov.referencia    = TRIM(STRING(b-it-nota-fisc.nr-seq-fat)) NO-ERROR. 

           IF AVAIL gg-contrato-mov THEN DO:
               IF gg-contrato-mov.num-romaneio = 0 THEN DO: /* devido a atualizacao dos dados do romaneio ocorrem depois da criacao da it-nota-fis */
                   FIND FIRST gg-mov-contr NO-LOCK
                        WHERE gg-mov-contr.cod-estabel  = b-it-nota-fisc.cod-estabel 
                          AND gg-mov-contr.num-romaneio = INT(SUBSTR(b-it-nota-fisc.char-2,232,9))
                          AND gg-mov-contr.num-seq      = INT(SUBSTR(b-it-nota-fisc.char-2,241,6)) NO-ERROR.

                   IF AVAIL gg-mov-contr THEN DO:
                       FIND CURRENT gg-contrato-mov EXCLUSIVE-LOCK NO-ERROR. 
                       ASSIGN gg-contrato-mov.num-romaneio  = gg-mov-contr.num-romaneio.

                       IF  gg-mov-contr.qtd-peso = 0 OR gg-mov-contr.dec-2 = 0 THEN DO:   /* qtd-fisic (quantidade f≠sica) */

                           /* Neste caso atualizou a entrega e saldo do contrato, porem o romaneio 
                            * pode indicar que nao deve atualizar.
                            * Obs.: Esta situacao ocorre quando utilizar controle de entrega no contrato
                            *       pelo fisico e for efetuada uma devolucao de quantidade apenas pelo
                            *       fiscal no gg2074 */

                           FIND FIRST gg-contrato EXCLUSIVE-LOCK
                                WHERE gg-contrato.ep-codigo    = gg-contrato-mov.ep-codigo
                                  AND gg-contrato.cod-contrato = gg-contrato-mov.cod-contrato NO-ERROR.
                           IF  AVAIL gg-contrato THEN DO: 

                               IF  gg-contrato.log-multi-produt = NO THEN DO:

                                   IF gg-mov-contr.qtd-peso = 0 THEN DO:
                                      ASSIGN gg-contrato.qtd-entrega      = gg-contrato.qtd-entrega  + gg-contrato-mov.qtd-peso
                                             gg-contrato-mov.qtd-peso     = 0.
                                   END.
    
                                   IF gg-mov-contr.dec-2 = 0 THEN        /* qtd-fisic (quantidade f°sica) */
                                      ASSIGN gg-contrato-mov.dec-2 = 0.  /* qtd-entreg-fisic (entrega f°sica) */
        
                                   RUN pi-atualiza-saldo-contrato-compra.
                               END.
                               ELSE DO: 
                                   FIND FIRST gg-contrato-prod EXCLUSIVE-LOCK OF gg-contrato 
                                        WHERE gg-contrato-prod.num-seq-prod = gg-contrato-mov.num-seq-prod NO-ERROR. 
                                   IF AVAIL gg-contrato-prod THEN DO:
                                      IF gg-mov-contr.qtd-peso = 0 THEN DO:
                                         ASSIGN gg-contrato-prod.qtd-entrega = gg-contrato-prod.qtd-entrega   + gg-contrato-mov.qtd-peso
                                                gg-contrato-prod.qtd-saldo   = gg-contrato-prod.qtd-contrato  - gg-contrato-prod.qtd-entrega
                                                gg-contrato.log-saldo        = YES.
                                      END.
                                      IF  gg-mov-contr.dec-2 = 0 THEN        /* qtd-fisic (quantidade f°sica) */
                                          ASSIGN gg-contrato-mov.dec-2 = 0.  /* qtd-entreg-fisic (entrega f°sica) */

                                      FIND CURRENT gg-contrato-prod NO-LOCK NO-ERROR.
                                   END.
                               END.

                               FIND CURRENT gg-contrato NO-LOCK NO-ERROR.

                           END.
                       END.

                       FIND CURRENT gg-contrato-mov NO-LOCK NO-ERROR. 
                   END.

               END.
           END.
        END.
    END.
    ELSE DO:  /* Devoluá∆o de compra cancelada */

        /** cancelamento de notas de devolucao **/
        IF c-contrato-item <> "" THEN DO: /* NFD */
            /* verificar se j† foi atualizado a devoluá∆o */
            FIND FIRST gg-contrato-mov NO-LOCK 
                 WHERE gg-contrato-mov.serie-docto   = b-it-nota-fisc.serie         
                 AND   gg-contrato-mov.nro-docto     = b-it-nota-fisc.nr-nota-fis   
                 AND   gg-contrato-mov.cod-emitente  = nota-fiscal.cod-emitente
                 AND   gg-contrato-mov.nat-operacao  = b-it-nota-fisc.nat-operacao  
                 AND   gg-contrato-mov.cod-estabel   = b-it-nota-fisc.cod-estabel   
                 AND   gg-contrato-mov.ind-transacao = 9 /* devolucao */
                 AND   gg-contrato-mov.referencia    = TRIM(STRING(b-it-nota-fisc.nr-seq-fat)) NO-ERROR.
            /* se encontrou devolucao no contrato, eliminar movimento */
            IF AVAIL gg-contrato-mov THEN DO:
                FIND FIRST gg-contrato EXCLUSIVE-LOCK
                     WHERE gg-contrato.ep-codigo    = gg-contrato-mov.ep-codigo
                     AND   gg-contrato.cod-contrato = gg-contrato-mov.cod-contrato NO-ERROR.
        
                /**** cria historico do contrato ****/
                {utp/ut-liter.i "Cancelado Nota de Devoluá∆o " * R}
                IF AVAIL gg-contrato THEN
                    RUN ggp/ggapi003.p (INPUT ROWID(gg-contrato), 
                                        INPUT RETURN-VALUE + b-it-nota-fisc.nr-nota-fis + "/" + b-it-nota-fisc.serie + "/" + " Nota de origem: " + b-it-nota-fisc.nr-docum + "/" + b-it-nota-fisc.serie-docum). 

                /* eliminar movimento por item da nota/fixacao */
                FOR EACH  gg-contrato-mov EXCLUSIVE-LOCK
                    WHERE gg-contrato-mov.serie-docto   = b-it-nota-fisc.serie           
                    AND   gg-contrato-mov.nro-docto     = b-it-nota-fisc.nr-nota-fis     
                    AND   gg-contrato-mov.cod-emitente  = nota-fiscal.cod-emitente       
                    AND   gg-contrato-mov.nat-operacao  = b-it-nota-fisc.nat-operacao    
                    AND   gg-contrato-mov.cod-estabel   = b-it-nota-fisc.cod-estabel     
                    AND   gg-contrato-mov.ind-transacao = 9 /* devolucao */
                    AND   gg-contrato-mov.referencia    = TRIM(STRING(b-it-nota-fisc.nr-seq-fat)):

                    /** voltar saldo do contrato **/
                    IF  AVAIL gg-contrato THEN DO:
                        EMPTY TEMP-TABLE tt-entrega-rom NO-ERROR.
                        CREATE tt-entrega-rom.
                        ASSIGN tt-entrega-rom.serie-docto   = b-it-nota-fisc.serie-docum
                               tt-entrega-rom.nro-docto     = b-it-nota-fisc.nr-docum
                               tt-entrega-rom.nat-operacao  = b-it-nota-fisc.nat-docum
                               tt-entrega-rom.cod-emitente  = b-it-nota-fisc.cd-emitente
                               tt-entrega-rom.sequencia     = b-it-nota-fisc.int-1
                               tt-entrega-rom.cod-refer     = b-it-nota-fisc.cod-refer
                               tt-entrega-rom.it-codigo     = b-it-nota-fisc.it-codigo.
                        
                        RUN pi-busca-entrega-rom IN h-ggapi074 (INPUT-OUTPUT TABLE tt-entrega-rom). 
                        FIND FIRST tt-entrega-rom NO-LOCK NO-ERROR. 

                        IF (tt-entrega-rom.log-devolucao = YES /* log-devolucao permite devolver nota j† paga na originaá∆o */
                        AND tt-entrega-rom.qt-pago       > 0)
                        
                        OR (tt-entrega-rom.log-devolucao = NO /* log-devolucao permite devolver nota j† paga na originaá∆o */                        
                        AND tt-entrega-rom.qt-pago       > 0
                        AND gg-contrato-mov.qtd-peso     = 0    
                        AND gg-contrato-mov.dec-1        > 0)

                         OR tt-entrega-rom.qt-pago       = 0 THEN DO:

                            IF  gg-contrato.log-multi-produt = NO THEN DO:
                                ASSIGN gg-contrato.qtd-entrega = gg-contrato.qtd-entrega + gg-contrato-mov.qtd-peso
                                       gg-contrato.val-livre-3 = gg-contrato.val-livre-3 + gg-contrato-mov.dec-1.     /* qtd-entreg-fisc (entrega fiscal) */
                               
                                RUN pi-atualiza-saldo-contrato-compra. 
                            END.
                            ELSE DO: 
                                FIND FIRST gg-contrato-prod EXCLUSIVE-LOCK OF gg-contrato 
                                     WHERE gg-contrato-prod.num-seq-prod = gg-contrato-mov.num-seq-prod NO-ERROR. 
                                IF AVAIL gg-contrato-prod THEN DO:
                                   ASSIGN gg-contrato-prod.qtd-entrega = gg-contrato-prod.qtd-entrega   + gg-contrato-mov.qtd-peso
                                          gg-contrato-prod.qtd-saldo   = gg-contrato-prod.qtd-contrato  - gg-contrato-prod.qtd-entrega
                                          gg-contrato.log-saldo        = IF gg-contrato.log-saldo = YES OR (gg-contrato-prod.qtd-saldo > 0) THEN YES ELSE NO. 
                                          
                                   FIND CURRENT gg-contrato-prod NO-LOCK NO-ERROR.
                                END.
                            END.
                        END.
                    END.
        
                    delete gg-contrato-mov. 
                END. /* for each mov */
                FIND CURRENT gg-contrato NO-LOCK NO-ERROR.    
            END.
        END.

    END.
    IF  VALID-HANDLE(h-ggapi074) THEN DO:
        DELETE PROCEDURE h-ggapi074.     
    END.                                 

    RETURN "OK":U.
END PROCEDURE.
/*--------------------------------------------------------------------------------------------------------------------*/
PROCEDURE pi-altera-status-romaneio:

    /**** Volta situaá∆o do romaneio para atualizado ****/
    FOR EACH gg-mov-contr EXCLUSIVE-LOCK
        WHERE gg-mov-contr.cod-estabel  = b-it-nota-fisc.cod-estabel 
          AND gg-mov-contr.num-romaneio = INT(SUBSTR(b-it-nota-fisc.char-2,232,9))
          AND gg-mov-contr.num-seq      = INT(SUBSTR(b-it-nota-fisc.char-2,241,6)):

        /* apenas voltar a situacao do romaneio, caso seja a mesma nota fiscal, 
           pois podem reaproveitar um nr de nota ap¢s o cancelamento da nota e no romaneio pode estar outra nota-fiscal */
        IF  b-it-nota-fisc.cod-estabel = gg-mov-contr.cod-estabel
        AND b-it-nota-fisc.serie       = gg-mov-contr.serie-docto
        AND b-it-nota-fisc.nr-nota-fis = gg-mov-contr.nro-docto
        AND nota-fiscal.cod-emitente   = gg-mov-contr.cod-emitente THEN DO:

            ASSIGN gg-mov-contr.ind-situacao = 2.

            /* somente zerar o n£mero da nota se a forma de emiss∆o da sÇrie for autom†tica */
            FOR FIRST serie FIELDS (forma-emis) NO-LOCK 
                WHERE serie.serie      = b-it-nota-fisc.serie
                  and serie.forma-emis = 1 /* automatica */:
                ASSIGN gg-mov-contr.nro-docto    = "":U. 
            END.

            For FIRST gg-mov EXCLUSIVE-LOCK OF gg-mov-contr:
                ASSIGN gg-mov.ind-situacao       = 2.
            END.

            IF AVAIL gg-mov THEN
                FIND CURRENT gg-mov NO-LOCK NO-ERROR.

            /**** cria historico do movimento ****/
            {utp/ut-liter.i "Cancelamento de Nota Fiscal " * R}
            RUN ggp/ggapi001.p(INPUT rowid(gg-mov),
                               INPUT RETURN-VALUE 
                                     + b-it-nota-fisc.cod-estabel 
                                     + " " 
                                     + b-it-nota-fisc.serie 
                                     + " " 
                                     + b-it-nota-fisc.nr-nota-fis
                                     + " " 
                                     + b-it-nota-fisc.nat-operacao 
                                     + " " 
                                     + string(nota-fiscal.cod-emitente) 
                                     + " " 
                                     + gg-mov-contr.cod-contrato, 
                               INPUT YES).

            IF VALID-HANDLE(h-ggapi112) THEN
                RUN piAtualizaOpeLogistica IN h-ggapi112 (INPUT gg-mov-contr.cod-estabel,
                                                          INPUT gg-mov-contr.num-romaneio,
                                                          INPUT gg-mov-contr.num-seq,
                                                          INPUT gg-mov-contr.qtd-fiscal,
                                                          INPUT 2 /* cancela NF */ ).

            IF  AVAIL gg-ext-nota-fiscal AND gg-ext-nota-fiscal.log-transito THEN DO:
                FIND CURRENT gg-ext-nota-fiscal EXCLUSIVE-LOCK NO-ERROR. 
                ASSIGN gg-ext-nota-fiscal.log-transito = NO. /* na trigger da gg-ext-nota-fiscal ir† chamar o lgapi002 para eliminar os registros de transito */
                FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR. 
            END.

        END.
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-atualiza-saldo-contrato-compra:

    IF  gg-contrato.log-balcao = YES THEN DO:
        ASSIGN gg-contrato.qtd-contrato = gg-contrato.qtd-entrega
               gg-contrato.qtd-orig     = gg-contrato.qtd-contrato. /* balcao Ç sempre igual */
    END.

    ASSIGN gg-contrato.qtd-saldo   = gg-contrato.qtd-contrato    - gg-contrato.qtd-entrega
           gg-contrato.val-livre-4 = gg-contrato.qtd-contrato    - gg-contrato.val-livre-3 /* qtd-sdo-fisc (saldo fiscal) / qtd-entreg-fisc (entrega fiscal) */ .



    IF  gg-contrato.log-multi-produt = NO THEN
          ASSIGN gg-contrato.log-saldo    = IF  gg-contrato.log-balcao = YES OR  gg-contrato.qtd-saldo  > 0 THEN YES ELSE NO.
    ELSE 
          ASSIGN gg-contrato.log-saldo    = CAN-FIND (FIRST gg-contrato-pre NO-LOCK 
                                                      WHERE gg-contrato-pre.ep-codigo    = gg-contrato.ep-codigo  
                                                        AND gg-contrato-pre.cod-contrato = gg-contrato.cod-contrato
                                                        AND gg-contrato-pre.qtd-saldo    > 0).


    RETURN "OK":U.
END PROCEDURE. 


/*--- FIM ------------------------------------------------------------------------------------------------------------*/
