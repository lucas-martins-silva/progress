/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9100 2.00.00.006 } /*** "010006" 05/03/2025 10:57:57  ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9100 MIM}
&ENDIF

{imp/im9100.i}
{imp/imapi009.i}
{imp/imapi009.i2}
{imp/imapi009.i4}
{cdp/cd4300.i3}     /* definicoes busca valores cotacao-item.char-1 */
{ccp/cc9019.i50}    /* definicoes busca valores cotacao-item.char-1 */


/*{cdp/cdcfgmat.i}*/

DEFINE INPUT  PARAMETER TABLE FOR tt-param.
DEFINE OUTPUT PARAMETER TABLE FOR tt-documentos-impressos.
DEFINE OUTPUT PARAMETER TABLE FOR tt-documentos-erros.
    
DEFINE VARIABLE h-acomp                           AS HANDLE                                NO-UNDO.
DEFINE VARIABLE h-imapi009                        AS HANDLE                                NO-UNDO.
DEFINE VARIABLE c-acomp                           AS CHARACTER FORMAT "x(15)":U            NO-UNDO.
                                                                                          
DEFINE VARIABLE lProximoEmbarque                  AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE lGravado                          AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-erro                            AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE l-ordem-embarque                  AS LOGICAL                               NO-UNDO.

DEFINE VARIABLE iSequenciaNacionalizacao          AS INTEGER                               NO-UNDO.
DEFINE VARIABLE de-valor-descto-conv              LIKE ordem-compra.valor-descto           NO-UNDO.
DEFINE VARIABLE de-quantidade	                  LIKE ordens-embarque.quantidade          NO-UNDO.  
DEFINE VARIABLE de-qt-do-forn	                  LIKE ordens-embarque.qt-do-forn          NO-UNDO.  
DEFINE VARIABLE de-qt-estatistica                 LIKE ordens-embarque.quantidade          NO-UNDO.  
DEFINE VARIABLE c-desc-item-traduzido             AS CHARACTER                             NO-UNDO. 
DEFINE VARIABLE de-valor-preco-fornec-liq         as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-valor-preco-interno-liq        as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-valor-preco-fornec-bru         as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-valor-preco-interno-bru        as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-valor-preco-fornec-liq-total   as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-valor-preco-interno-liq-total  as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-valor-preco-fornec-bru-total   as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-valor-preco-interno-bru-total  as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 

DEFINE VARIABLE de-peso-liq-total-ncm             as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-peso-bruto-total-ncm           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-fornec-liq-total-ncm     as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-interno-liq-total-ncm    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-fornec-bru-total-ncm     as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-interno-bru-total-ncm    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-ocupacao-total-ncm             as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-quantidade-total-ncm           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-qt-do-forn-total-ncm           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-qt-estatistica-total-ncm       as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-peso-liq-total-fabr            as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-peso-bruto-total-fabr          as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-fornec-liq-total-fabr    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-interno-liq-total-fabr   as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-fornec-bru-total-fabr    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-ocupacao-total-fabr            as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-quantidade-total-fabr          as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-qt-do-forn-total-fabr          as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-qt-estatistica-total-fabr      as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-preco-interno-bru-total-fabr   as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO. 
DEFINE VARIABLE de-peso-liq-total-ped             as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-peso-bruto-total-ped           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-fornec-liq-total-ped     as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-interno-liq-total-ped    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-fornec-bru-total-ped     as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-interno-bru-total-ped    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-ocupacao-total-ped             as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-quantidade-total-ped           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-qt-do-forn-total-ped           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-qt-estatistica-total-ped       as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-peso-liq-total-emb             as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-peso-bruto-total-emb           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-fornec-liq-total-emb     as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-interno-liq-total-emb    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-fornec-bru-total-emb     as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-preco-interno-bru-total-emb    as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-ocupacao-total-emb             as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-quantidade-total-emb           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-qt-do-forn-total-emb           as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-qt-estatistica-total-emb       as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-val-desp-mo-corren             as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.
DEFINE VARIABLE de-val-desp-mo-ordem              as decimal format ">>>>>,>>>,>>9.99999"  NO-UNDO.


/*DEFINE VARIABLE de-valor-descto-conv        like cotacao-item-cex.val-desp  NO-UNDO. */

DEFINE BUFFER bf-processo-imp             FOR processo-imp.
DEFINE BUFFER bf-embarque-imp                FOR embarque-imp.
    

FIND FIRST tt-param NO-ERROR.

IF tt-param.indDocto = 1 THEN DO:
    {utp/ut-liter.i Solicita‡Æo_de_Autoriza‡Æo_de_Importa‡Æo * r}.
    ASSIGN c-acomp = RETURN-VALUE.
END.
ELSE DO:
    {utp/ut-liter.i Pr‚-Licen‡a_de_Importa‡Æo * r}.
    ASSIGN c-acomp = RETURN-VALUE.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp(INPUT c-acomp).

IF NOT VALID-HANDLE(h-imapi009) THEN
    RUN imp/imapi009.p PERSISTENT SET h-imapi009.


IF tt-param.iSeleciona = 2 THEN DO: /*** EMBARQUE ***/
    
     FOR EACH embarque-imp FIELDS (situacao cod-estabel embarque cdn-pto-desembar)
        WHERE embarque-imp.cod-estabel >= tt-param.cCodEstabelIni
        AND   embarque-imp.cod-estabel <= tt-param.cCodEstabelFim
        AND   embarque-imp.embarque    >= tt-param.cEmbarqueIni
        AND   embarque-imp.embarque    <= tt-param.cEmbarqueFim NO-LOCK:

        IF  NOT tt-param.lEmbEncerrado 
        AND embarque-imp.situacao = 2 THEN
            NEXT.

        ASSIGN lProximoEmbarque = YES.

        empty temp-table tt-emb.
        empty temp-table tt-pedido-compr-emb.
        empty temp-table tt-pedido-compr-emb-aux.
        empty temp-table tt-pedido-compr-emb-aux2.
        empty temp-table tt-pedido-compr-emb-aux3.
        empty temp-table tt-fabr-ped-compr-emb.
        empty temp-table tt-ncm-fabr-ped-compr-emb.
        empty temp-table tt-ordem-ncm-fabr-ped-compr-emb.
        empty temp-table tt-desp-embarque.

        FOR EACH  ordens-embarque FIELDS(numero-ordem)
            WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
            AND   ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK,
            FIRST ordem-compra FIELDS(numero-ordem num-pedido cod-emitente it-codigo qt-solic)
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem
            AND   ordem-compra.situacao <> 4 /*Eliminada*/
            AND   ordem-compra.situacao <> 6 /*Recebida*/ NO-LOCK,
            FIRST ITEM FIELDS (log-necessita-li class-fiscal tipo-contr)
            WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK:

            IF NOT item.log-necessita-li
            AND tt-param.lItensLi THEN
                NEXT.
            
            ASSIGN lProximoEmbarque = NO.

            FOR FIRST pedido-compr FIELDS (num-pedido)
                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.
            IF AVAIL pedido-compr
            AND NOT CAN-FIND (FIRST tt-pedido-compr-emb
                                WHERE tt-pedido-compr-emb.cod-estabel = embarque-imp.cod-estabel
                                AND   tt-pedido-compr-emb.embarque    = embarque-imp.embarque
                                AND   tt-pedido-compr-emb.num-pedido  = pedido-compr.num-pedido) THEN DO:

                CREATE tt-pedido-compr-emb.
                ASSIGN tt-pedido-compr-emb.cod-estabel = embarque-imp.cod-estabel
                       tt-pedido-compr-emb.embarque    = embarque-imp.embarque
                       tt-pedido-compr-emb.num-pedido  = pedido-compr.num-pedido
                       tt-pedido-compr-emb.r-rowid     = ROWID(pedido-compr).
            END.

            FOR FIRST cotacao-item FIELDS (numero-ordem cod-emitente it-codigo seq-cotac data-cotacao char-1 char-2)
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                AND   cotacao-item.cot-aprovada NO-LOCK: END.
            IF AVAIL cotacao-item THEN DO:
                
                IF NOT CAN-FIND (FIRST tt-fabr-ped-compr-emb
                                     WHERE tt-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel
                                     AND   tt-fabr-ped-compr-emb.embarque       = embarque-imp.embarque   
                                     AND   tt-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido 
                                     AND   tt-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))) THEN DO:                  
                                    
                    CREATE tt-fabr-ped-compr-emb.
                    ASSIGN tt-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel
                           tt-fabr-ped-compr-emb.embarque       = embarque-imp.embarque   
                           tt-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido 
                           tt-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                           tt-fabr-ped-compr-emb.cod-emitente   = cotacao-item.cod-emitente.
                END.

                IF  item.tipo-contr = 4 /*Debito Direto*/ THEN DO:
                
                    IF NOT CAN-FIND (FIRST tt-ncm-fabr-ped-compr-emb
                                        WHERE tt-ncm-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel
                                        AND   tt-ncm-fabr-ped-compr-emb.embarque       = embarque-imp.embarque
                                        AND   tt-ncm-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido
                                        AND   tt-ncm-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20)) 
                                        AND   tt-ncm-fabr-ped-compr-emb.cod-ncm        = SUBSTR(cotacao-item.char-1,81,20)) THEN DO: 

                        CREATE tt-ncm-fabr-ped-compr-emb.
                        ASSIGN tt-ncm-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel
                               tt-ncm-fabr-ped-compr-emb.embarque       = embarque-imp.embarque   
                               tt-ncm-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido 
                               tt-ncm-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                               tt-ncm-fabr-ped-compr-emb.cod-ncm        = SUBSTR(cotacao-item.char-1,81,20)
                               tt-ncm-fabr-ped-compr-emb.cod-emitente   = cotacao-item.cod-emitente.
                    END.

                    IF NOT CAN-FIND(FIRST tt-ordem-ncm-fabr-ped-compr-emb
                                        WHERE tt-ordem-ncm-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel              
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.embarque       = embarque-imp.embarque                 
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido               
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))     
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.ncm            = SUBSTR(cotacao-item.char-1,81,20)     
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.numero-ordem   = ordem-compra.numero-ordem) THEN DO:  

                        CREATE tt-ordem-ncm-fabr-ped-compr-emb.
                        ASSIGN tt-ordem-ncm-fabr-ped-compr-emb.cod-estabel          = embarque-imp.cod-estabel              
                               tt-ordem-ncm-fabr-ped-compr-emb.embarque             = embarque-imp.embarque                 
                               tt-ordem-ncm-fabr-ped-compr-emb.num-pedido           = ordem-compra.num-pedido               
                               tt-ordem-ncm-fabr-ped-compr-emb.cod-fabricante       = INT(SUBSTR(cotacao-item.char-2,41,20))     
                               tt-ordem-ncm-fabr-ped-compr-emb.ncm                  = SUBSTR(cotacao-item.char-1,81,20)     
                               tt-ordem-ncm-fabr-ped-compr-emb.numero-ordem         = ordem-compra.numero-ordem
                               tt-ordem-ncm-fabr-ped-compr-emb.r-rowid-ordens-emb   = ROWID(ordens-embarque)
                               tt-ordem-ncm-fabr-ped-compr-emb.r-rowid-ordem-compra = ROWID(ordem-compra)
                               tt-ordem-ncm-fabr-ped-compr-emb.cod-emitente         = cotacao-item.cod-emitente.
                    END.
                END.
                ELSE DO:
                    IF NOT CAN-FIND (FIRST tt-ncm-fabr-ped-compr-emb
                                        WHERE tt-ncm-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel
                                        AND   tt-ncm-fabr-ped-compr-emb.embarque       = embarque-imp.embarque
                                        AND   tt-ncm-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido
                                        AND   tt-ncm-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20)) 
                                        AND   tt-ncm-fabr-ped-compr-emb.cod-ncm        = item.class-fiscal) THEN DO: 
                        CREATE tt-ncm-fabr-ped-compr-emb.
                        ASSIGN tt-ncm-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel
                               tt-ncm-fabr-ped-compr-emb.embarque       = embarque-imp.embarque   
                               tt-ncm-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido 
                               tt-ncm-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                               tt-ncm-fabr-ped-compr-emb.cod-ncm        = item.class-fiscal.
                    END.

                    IF NOT CAN-FIND(FIRST tt-ordem-ncm-fabr-ped-compr-emb
                                        WHERE tt-ordem-ncm-fabr-ped-compr-emb.cod-estabel    = embarque-imp.cod-estabel              
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.embarque       = embarque-imp.embarque                 
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.num-pedido     = ordem-compra.num-pedido               
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))     
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.ncm            = item.class-fiscal
                                        AND   tt-ordem-ncm-fabr-ped-compr-emb.numero-ordem   = ordem-compra.numero-ordem) THEN DO:  

                        CREATE tt-ordem-ncm-fabr-ped-compr-emb.
                        ASSIGN tt-ordem-ncm-fabr-ped-compr-emb.cod-estabel          = embarque-imp.cod-estabel              
                               tt-ordem-ncm-fabr-ped-compr-emb.embarque             = embarque-imp.embarque                 
                               tt-ordem-ncm-fabr-ped-compr-emb.num-pedido           = ordem-compra.num-pedido               
                               tt-ordem-ncm-fabr-ped-compr-emb.cod-fabricante       = INT(SUBSTR(cotacao-item.char-2,41,20))     
                               tt-ordem-ncm-fabr-ped-compr-emb.ncm                  = item.class-fiscal
                               tt-ordem-ncm-fabr-ped-compr-emb.numero-ordem         = ordem-compra.numero-ordem
                               tt-ordem-ncm-fabr-ped-compr-emb.r-rowid-ordens-emb   = ROWID(ordens-embarque)
                               tt-ordem-ncm-fabr-ped-compr-emb.r-rowid-ordem-compra = ROWID(ordem-compra).
                    END.
                END.    
                IF lProximoEmbarque THEN
                NEXT.

                /*Encotra a sequencia do Pto de Nacionalizacao*/
                FOR FIRST historico-embarque FIELDS (cod-itiner)
                    WHERE historico-embarque.cod-estabel = embarque-imp.cod-estabel
                    AND   historico-embarque.embarque    = embarque-imp.embarque NO-LOCK: END.
                IF  NOT AVAIL historico-embarque THEN
                    NEXT.
            
                FOR FIRST itinerario FIELDS (cod-itiner pto-desembarque)
                    WHERE  itinerario.cod-itiner = historico-embarque.cod-itiner NO-LOCK: END.
            
                FOR FIRST historico-embarque FIELDS (sequencia)
                    WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                    AND   historico-embarque.embarque      = embarque-imp.embarque
                    AND   historico-embarque.cod-itiner    = itinerario.cod-itiner
                    AND   historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK: END.
                IF  AVAIL historico-embarque  THEN
                    ASSIGN iSequenciaNacionalizacao  = historico-embarque.sequencia.

                {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                {ccp/cc9019.i51 "yes"}
            
                /*Despesas do Embarque*/
                for EACH  desp-incoterm no-lock
                    where desp-incoterm.cod-incoterm = c-cod-incoterm-i50
                    break by desp-incoterm.cod-incoterm:

                    find desp-imp
                    where desp-imp.cod-desp = desp-incoterm.cod-desp no-lock no-error.
                    if  avail desp-imp then do:

                        IF  NOT desp-imp.inc-val-seguro 
                        AND NOT desp-imp.inc-val-frete
                        AND NOT desp-imp.inc-val-embal
                        AND NOT desp-imp.inc-val-outras-desp THEN
                            NEXT.

                        FIND FIRST cotacao-item-cex 
                             where cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem 
                             and   cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente 
                             and   cotacao-item-cex.it-codigo         = cotacao-item.it-codigo    
                             and   cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac    
                             and   cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao 
                             and   cotacao-item-cex.mapa-cotacao      = i-mapa-cotacao-i50        
                             and   cotacao-item-cex.cod-incoterm      = desp-incoterm.cod-incoterm
                             and   cotacao-item-cex.cod-emitente-desp = cotacao-item.cod-emitente
                             and   cotacao-item-cex.cod-desp          = desp-incoterm.cod-desp no-lock no-error.
                        if  avail cotacao-item-cex then do:
                            
                            /*Cria temp-table quando pto contr da despesa for menor/igual ao pto de nacionalizacao*/
                            FOR first historico-embarque FIELDS (sequencia)
                                WHERE historico-embarque.cod-estabel   = embarque-imp.cod-estabel
                                AND   historico-embarque.embarque      = embarque-imp.embarque
                                AND   historico-embarque.cod-itiner    = cotacao-item-cex.cod-itiner   
                                AND   historico-embarque.cod-pto-contr = cotacao-item-cex.cod-pto-contr no-lock: end.
                            IF  AVAIL historico-embarque 
                            AND historico-embarque.sequencia <= iSequenciaNacionalizacao THEN DO:

                                run setConstraintCotacaoItemCex in h-imapi009 (input rowid(cotacao-item-cex)).
                        
                                run getCotacaoItemCex in h-imapi009 (output table tt-cotacao-item-cex).
            
                                find first tt-cotacao-item-cex no-error.

                                FIND FIRST tt-desp-embarque
                                     WHERE tt-desp-embarque.cod-estabel = embarque-imp.cod-estabel  
                                       AND tt-desp-embarque.embarque    = embarque-imp.embarque     
                                       AND tt-desp-embarque.cod-desp    = cotacao-item-cex.cod-desp NO-ERROR. 
                                IF NOT AVAIL tt-desp-embarque THEN DO:
                                
                                    CREATE tt-desp-embarque.
                                    ASSIGN tt-desp-embarque.cod-estabel       = embarque-imp.cod-estabel
                                           tt-desp-embarque.embarque          = embarque-imp.embarque
                                           tt-desp-embarque.cod-desp          = cotacao-item-cex.cod-desp
                                           tt-desp-embarque.cod-emitente-desp = cotacao-item-cex.cod-emitente
                                           tt-desp-embarque.mo-codigo         = tt-cotacao-item-cex.mo-codigo    
                                           tt-desp-embarque.cod-pto-contr     = tt-cotacao-item-cex.cod-pto-contr
                                           tt-desp-embarque.r-cotacao-it-cex  = ROWID(cotacao-item-cex).
                                END.
                                ASSIGN tt-desp-embarque.val-desp = tt-desp-embarque.val-desp + (tt-cotacao-item-cex.val-desp * ordem-compra.qt-solic).
                            END.
                        END.
                    END.
                END.
            END.
        END.
        
        
        CREATE tt-emb.
        ASSIGN tt-emb.cod-estabel = embarque-imp.cod-estabel
               tt-emb.embarque    = embarque-imp.embarque
               tt-emb.r-rowid     = ROWID(embarque-imp).

        RUN geraEmbarque.
    END.

    for each tt-documentos-erros where tt-documentos-erros.cod-erro = 5455:
        delete tt-documentos-erros.
    end.

    for each tt-doc-erros-tmp:
        create tt-documentos-erros.
        buffer-copy tt-doc-erros-tmp to tt-documentos-erros.    
    end.
    
END.
ELSE DO: /*Processo de Importacao*/

    FOR EACH  processo-imp FIELDS (cod-estabel nr-proc-imp num-pedido cod-itiner)
        WHERE processo-imp.cod-estabel >= tt-param.cCodEstabelIni
        AND   processo-imp.cod-estabel <= tt-param.cCodEstabelFim
        AND   processo-imp.nr-proc-imp >= tt-param.cNrProcImpIni
        AND   processo-imp.nr-proc-imp <= tt-param.cNrProcImpFim no-lock:

        find first param-imp where param-imp.cod-estabel = processo-imp.cod-estabel no-lock no-error.

        empty temp-table tt-processo-imp.
        empty temp-table tt-processo-imp.                 
        empty temp-table tt-processo-imp-aux.            
        empty temp-table tt-processo-imp-aux2.            
        empty temp-table tt-processo-imp-aux3.            
        empty temp-table tt-fabr-processo-imp.            
        empty temp-table tt-ncm-fabr-processo-imp.  
        empty temp-table tt-ordem-ncm-fabr-processo-imp.

        CREATE tt-processo-imp.
        ASSIGN tt-processo-imp.cod-estabel    = processo-imp.cod-estabel
               tt-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp
               tt-processo-imp.r-rowid        = ROWID(processo-imp).
        
        FOR FIRST pedido-compr FIELDS (num-pedido)
            WHERE pedido-compr.num-pedido = processo-imp.num-pedido NO-LOCK: END.
        IF  AVAIL pedido-compr THEN  DO:

            assign tt-processo-imp.num-pedido     = pedido-compr.num-pedido
                   tt-processo-imp.r-rowid-pedido = ROWID(pedido-compr).
            
            FOR EACH  ordem-compra FIELDS (numero-ordem num-pedido cod-emitente qt-solic)
                WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
                AND   ordem-compra.situacao <> 4 /*Eliminada*/
                AND   ordem-compra.situacao <> 6 /*Recebida*/ NO-LOCK,
                FIRST ITEM FIELD(ITEM.class-fiscal tipo-contr log-necessita-li)
                WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK:

                IF NOT item.log-necessita-li
                AND tt-param.lItensLi THEN
                    NEXT.
                
                FOR FIRST cotacao-item FIELDS(cod-emitente it-codigo seq-cotac data-cotacao cod-incoterm numero-ordem char-1 char-2)
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                    AND   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                    AND   cotacao-item.cot-aprovada NO-LOCK : END.
                IF  AVAIL cotacao-item THEN DO:

                    IF  NOT CAN-FIND (FIRST tt-fabr-processo-imp                                                      
                                      WHERE tt-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel            
                                      AND   tt-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp            
                                      AND   tt-fabr-processo-imp.num-pedido     = pedido-compr.num-pedido             
                                      AND   tt-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))) THEN DO:
                        CREATE tt-fabr-processo-imp.
                        ASSIGN tt-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel            
                               tt-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp            
                               tt-fabr-processo-imp.num-pedido     = pedido-compr.num-pedido             
                               tt-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                               tt-fabr-processo-imp.cod-emitente   = cotacao-item.cod-emitente.
                    END.

                    IF  NOT CAN-FIND (FIRST tt-ord-compr-fabr-proc-imp                                                      
                                      WHERE tt-ord-compr-fabr-proc-imp.cod-estabel    = processo-imp.cod-estabel            
                                      AND   tt-ord-compr-fabr-proc-imp.nr-proc-imp    = processo-imp.nr-proc-imp            
                                      AND   tt-ord-compr-fabr-proc-imp.num-pedido     = pedido-compr.num-pedido             
                                      AND   tt-ord-compr-fabr-proc-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                                      AND   tt-ord-compr-fabr-proc-imp.numero-ordem   = ordem-compra.numero-ordem) THEN DO:
                        CREATE tt-ord-compr-fabr-proc-imp.
                        ASSIGN tt-ord-compr-fabr-proc-imp.cod-estabel    = processo-imp.cod-estabel            
                               tt-ord-compr-fabr-proc-imp.nr-proc-imp    = processo-imp.nr-proc-imp            
                               tt-ord-compr-fabr-proc-imp.num-pedido     = pedido-compr.num-pedido             
                               tt-ord-compr-fabr-proc-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                               tt-ord-compr-fabr-proc-imp.numero-ordem   = ordem-compra.numero-ordem.
                    END.

                    IF  item.tipo-contr = 4 /*Debito Direto*/ THEN DO:
                        IF NOT CAN-FIND (FIRST tt-ncm-fabr-processo-imp
                                            WHERE tt-ncm-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel
                                            AND   tt-ncm-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp
                                            AND   tt-ncm-fabr-processo-imp.num-pedido     = ordem-compra.num-pedido
                                            AND   tt-ncm-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20)) 
                                            AND   tt-ncm-fabr-processo-imp.cod-ncm        = SUBSTR(cotacao-item.char-1,81,20)) THEN DO: 

                            
                            CREATE tt-ncm-fabr-processo-imp.
                            ASSIGN tt-ncm-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel
                                   tt-ncm-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp
                                   tt-ncm-fabr-processo-imp.num-pedido     = ordem-compra.num-pedido 
                                   tt-ncm-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                                   tt-ncm-fabr-processo-imp.cod-ncm        = SUBSTR(cotacao-item.char-1,81,20)
                                   tt-ncm-fabr-processo-imp.cod-emitente   = cotacao-item.cod-emitente.
                        END.
                        IF NOT CAN-FIND(FIRST tt-ordem-ncm-fabr-processo-imp
                                           WHERE tt-ordem-ncm-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel              
                                           AND   tt-ordem-ncm-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp
                                           AND   tt-ordem-ncm-fabr-processo-imp.num-pedido     = ordem-compra.num-pedido               
                                           AND   tt-ordem-ncm-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))     
                                           AND   tt-ordem-ncm-fabr-processo-imp.ncm            = SUBSTR(cotacao-item.char-1,81,20)     
                                           AND   tt-ordem-ncm-fabr-processo-imp.numero-ordem   = ordem-compra.numero-ordem) THEN DO:  

                            CREATE tt-ordem-ncm-fabr-processo-imp.
                            ASSIGN tt-ordem-ncm-fabr-processo-imp.cod-estabel          = processo-imp.cod-estabel              
                                   tt-ordem-ncm-fabr-processo-imp.nr-proc-imp          = processo-imp.nr-proc-imp                 
                                   tt-ordem-ncm-fabr-processo-imp.num-pedido           = ordem-compra.num-pedido               
                                   tt-ordem-ncm-fabr-processo-imp.cod-fabricante       = INT(SUBSTR(cotacao-item.char-2,41,20))     
                                   tt-ordem-ncm-fabr-processo-imp.ncm                  = SUBSTR(cotacao-item.char-1,81,20)     
                                   tt-ordem-ncm-fabr-processo-imp.numero-ordem         = ordem-compra.numero-ordem
                                   tt-ordem-ncm-fabr-processo-imp.r-rowid-ordem-compra = ROWID(ordem-compra)
                                   tt-ordem-ncm-fabr-processo-imp.cod-emitente         = cotacao-item.cod-emitente.
                        END.
                    END.
                    ELSE DO:
                        IF NOT CAN-FIND (FIRST tt-ncm-fabr-processo-imp
                                            WHERE tt-ncm-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel
                                            AND   tt-ncm-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp
                                            AND   tt-ncm-fabr-processo-imp.num-pedido     = ordem-compra.num-pedido
                                            AND   tt-ncm-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20)) 
                                            AND   tt-ncm-fabr-processo-imp.cod-ncm        = item.class-fiscal) THEN DO: 

                            
                            CREATE tt-ncm-fabr-processo-imp.
                            ASSIGN tt-ncm-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel
                                   tt-ncm-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp
                                   tt-ncm-fabr-processo-imp.num-pedido     = ordem-compra.num-pedido 
                                   tt-ncm-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))
                                   tt-ncm-fabr-processo-imp.cod-ncm        = item.class-fiscal.
                        END.
                        IF NOT CAN-FIND(FIRST tt-ordem-ncm-fabr-processo-imp
                                           WHERE tt-ordem-ncm-fabr-processo-imp.cod-estabel    = processo-imp.cod-estabel              
                                           AND   tt-ordem-ncm-fabr-processo-imp.nr-proc-imp    = processo-imp.nr-proc-imp
                                           AND   tt-ordem-ncm-fabr-processo-imp.num-pedido     = ordem-compra.num-pedido               
                                           AND   tt-ordem-ncm-fabr-processo-imp.cod-fabricante = INT(SUBSTR(cotacao-item.char-2,41,20))     
                                           AND   tt-ordem-ncm-fabr-processo-imp.ncm            = item.class-fiscal     
                                           AND   tt-ordem-ncm-fabr-processo-imp.numero-ordem   = ordem-compra.numero-ordem) THEN DO:  

                            
                            CREATE tt-ordem-ncm-fabr-processo-imp.
                            ASSIGN tt-ordem-ncm-fabr-processo-imp.cod-estabel          = processo-imp.cod-estabel 
                                   tt-ordem-ncm-fabr-processo-imp.Nr-proc-imp          = processo-imp.nr-proc-imp 
                                   tt-ordem-ncm-fabr-processo-imp.num-pedido           = ordem-compra.num-pedido               
                                   tt-ordem-ncm-fabr-processo-imp.cod-fabricante       = INT(SUBSTR(cotacao-item.char-2,41,20))     
                                   tt-ordem-ncm-fabr-processo-imp.ncm                  = item.class-fiscal
                                   tt-ordem-ncm-fabr-processo-imp.numero-ordem         = ordem-compra.numero-ordem
                                   tt-ordem-ncm-fabr-processo-imp.r-rowid-ordem-compra = ROWID(ordem-compra).
                        END.
                    END.
                                                                 
                    if avail param-imp and param-imp.hist-processo = YES then do:
                        
                        /*Encotra a sequencia do Pto de Nacionalizacao*/
                        FOR FIRST historico-proc-imp FIELDS (cod-itiner)
                            WHERE historico-proc-imp.cod-estabel = processo-imp.cod-estabel
                            AND   historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp 
                            and   historico-proc-imp.cod-itiner  = processo-imp.cod-itiner  NO-LOCK: END.
                        IF  NOT AVAIL historico-proc-imp THEN
                            NEXT.
    
                        FOR FIRST itinerario FIELDS (cod-itiner pto-desembarque)
                            WHERE  itinerario.cod-itiner = historico-proc-imp.cod-itiner NO-LOCK: END.
                    
                        FOR FIRST historico-proc-imp FIELDS (sequencia)
                            WHERE historico-proc-imp.cod-estabel   = processo-imp.cod-estabel
                            AND   historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp
                            AND   historico-proc-imp.cod-itiner    = itinerario.cod-itiner
                            AND   historico-proc-imp.cod-pto-contr = itinerario.pto-desembarque NO-LOCK: END.
                        IF  AVAIL historico-proc-imp  THEN
                            ASSIGN iSequenciaNacionalizacao  = historico-proc-imp.sequencia.

                        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                        {ccp/cc9019.i51 "yes"}

                        find emitente-cex
                            where emitente-cex.cod-emitente = cotacao-item.cod-emitente no-lock no-error.
                        if  not avail emitente-cex
                        or  (    avail emitente-cex
                             and not emitente-cex.log-1) then
                        
                            for each desp-incoterm no-lock
                                where desp-incoterm.cod-incoterm = c-cod-incoterm-i50
                                break by desp-incoterm.cod-incoterm:

                                find desp-imp
                                    where desp-imp.cod-desp = desp-incoterm.cod-desp no-lock no-error.
                                if  avail desp-imp then do:

                                    if  not desp-imp.inc-val-seguro      
                                    and not desp-imp.inc-val-frete       
                                    and not desp-imp.inc-val-embal       
                                    and not desp-imp.inc-val-outras-desp then
                                        next.

                                    find cotacao-item-cex 
                                        where cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem 
                                        and   cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente 
                                        and   cotacao-item-cex.it-codigo         = cotacao-item.it-codigo    
                                        and   cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac    
                                        and   cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao 
                                        and   cotacao-item-cex.mapa-cotacao      = i-mapa-cotacao-i50        
                                        and   cotacao-item-cex.cod-incoterm      = desp-incoterm.cod-incoterm
                                        and   cotacao-item-cex.cod-emitente-desp = cotacao-item.cod-emitente
                                        and   cotacao-item-cex.cod-desp          = desp-incoterm.cod-desp no-lock no-error.
                                    if  avail cotacao-item-cex then do:

                                        FOR FIRST historico-proc-imp FIELDS (sequencia)
                                            WHERE historico-proc-imp.cod-estabel   = processo-imp.cod-estabel
                                            AND   historico-proc-imp.nr-proc-imp   = processo-imp.nr-proc-imp
                                            AND   historico-proc-imp.cod-itiner    = cotacao-item-cex.cod-itiner
                                            AND   historico-proc-imp.cod-pto-contr = cotacao-item-cex.cod-pto-contr NO-LOCK: END.
                                        IF  AVAIL historico-proc-imp 
                                        AND historico-proc-imp.sequencia <= iSequenciaNacionalizacao THEN DO:

                                            run setConstraintCotacaoItemCex in h-imapi009 (input rowid(cotacao-item-cex)).
                        
                                            run getCotacaoItemCex in h-imapi009 (output table tt-cotacao-item-cex).
                        
                                            find first tt-cotacao-item-cex no-error.
                                            
                                            for first tt-desp-pedido
                                                where tt-desp-pedido.mo-codigo     = tt-cotacao-item-cex.mo-codigo
                                                and   tt-desp-pedido.cod-cond-pag  = tt-cotacao-item-cex.cod-cond-pag
                                                and   tt-desp-pedido.cod-pto-contr = tt-cotacao-item-cex.cod-pto-contr
                                                and   tt-desp-pedido.cod-desp      = tt-cotacao-item-cex.cod-desp no-lock: end.
                                            if  not avail tt-desp-pedido then do:
    
                                                create tt-desp-pedido.
                                                ASSIGN tt-desp-pedido.num-pedido        = pedido-compr.num-pedido
                                                       tt-desp-pedido.cod-desp          = cotacao-item-cex.cod-desp
                                                       tt-desp-pedido.cod-cond-pagto    = tt-cotacao-item-cex.cod-cond-pag
                                                       tt-desp-pedido.cod-emitente-desp = cotacao-item-cex.cod-emitente
                                                       tt-desp-pedido.mo-codigo         = tt-cotacao-item-cex.mo-codigo        
                                                       tt-desp-pedido.cod-pto-contr     = tt-cotacao-item-cex.cod-pto-contr    
                                                       tt-desp-pedido.numero-ordem      = cotacao-item-cex.numero-ordem
                                                       tt-desp-pedido.r-cotacao-it-cex  = rowid(cotacao-item-cex).
                        
                                            end.
                                            ASSIGN tt-desp-pedido.val-desp = tt-desp-pedido.val-desp + (tt-cotacao-item-cex.val-desp * ordem-compra.qt-solic).                                            
                                        end.
                                    end.
                                end.
                            end.
                    end.
                    else do:
                        
                        {cdp/cd4300.i4 "yes" cotacao-item.char-1}
                        {ccp/cc9019.i51 "yes"}

                        find emitente-cex
                            where emitente-cex.cod-emitente = cotacao-item.cod-emitente no-lock no-error.
                        if  not avail emitente-cex
                        or  (    avail emitente-cex
                             and not emitente-cex.log-1) then
                        
                            for each desp-incoterm no-lock
                                where desp-incoterm.cod-incoterm = c-cod-incoterm-i50
                                break by desp-incoterm.cod-incoterm:

                                find desp-imp
                                    where desp-imp.cod-desp = desp-incoterm.cod-desp no-lock no-error.
                                if  avail desp-imp then do:

                                    if  not desp-imp.inc-val-seguro      
                                    and not desp-imp.inc-val-frete       
                                    and not desp-imp.inc-val-embal       
                                    and not desp-imp.inc-val-outras-desp then
                                        next.

                                    find cotacao-item-cex 
                                        where cotacao-item-cex.numero-ordem      = cotacao-item.numero-ordem 
                                        and   cotacao-item-cex.cod-emitente      = cotacao-item.cod-emitente 
                                        and   cotacao-item-cex.it-codigo         = cotacao-item.it-codigo    
                                        and   cotacao-item-cex.seq-cotac         = cotacao-item.seq-cotac    
                                        and   cotacao-item-cex.data-cotacao      = cotacao-item.data-cotacao 
                                        and   cotacao-item-cex.mapa-cotacao      = i-mapa-cotacao-i50        
                                        and   cotacao-item-cex.cod-incoterm      = desp-incoterm.cod-incoterm
                                        and   cotacao-item-cex.cod-emitente-desp = cotacao-item.cod-emitente
                                        and   cotacao-item-cex.cod-desp          = desp-incoterm.cod-desp no-lock no-error.
                                    if  avail cotacao-item-cex then do:

                                        run setConstraintCotacaoItemCex in h-imapi009 (input rowid(cotacao-item-cex)).
                    
                                        run getCotacaoItemCex in h-imapi009 (output table tt-cotacao-item-cex).
                    
                                        find first tt-cotacao-item-cex no-error.

                                        for first tt-desp-pedido
                                            where tt-desp-pedido.mo-codigo     = tt-cotacao-item-cex.mo-codigo
                                            and   tt-desp-pedido.cod-cond-pag  = tt-cotacao-item-cex.cod-cond-pag
                                            and   tt-desp-pedido.cod-pto-contr = tt-cotacao-item-cex.cod-pto-contr
                                            and   tt-desp-pedido.cod-desp      = tt-cotacao-item-cex.cod-desp no-lock: end.
                                        if  not avail tt-desp-pedido then do:

                                            create tt-desp-pedido.
                                            ASSIGN tt-desp-pedido.num-pedido        = pedido-compr.num-pedido
                                                   tt-desp-pedido.cod-desp          = cotacao-item-cex.cod-desp
                                                   tt-desp-pedido.cod-cond-pagto    = tt-cotacao-item-cex.cod-cond-pag
                                                   tt-desp-pedido.cod-emitente-desp = cotacao-item-cex.cod-emitente
                                                   tt-desp-pedido.mo-codigo         = tt-cotacao-item-cex.mo-codigo        
                                                   tt-desp-pedido.cod-pto-contr     = tt-cotacao-item-cex.cod-pto-contr    
                                                   tt-desp-pedido.numero-ordem      = cotacao-item-cex.numero-ordem
                                                   tt-desp-pedido.r-cotacao-it-cex  = rowid(cotacao-item-cex).
                                        end.
                                        
                                        ASSIGN tt-desp-pedido.val-desp = tt-desp-pedido.val-desp + (tt-cotacao-item-cex.val-desp * ordem-compra.qt-solic).
                                        
                                    end.
                                end.
                            end.
                    end.
                END.
            END.
        END.
        RUN piCarregaProcesso.
    END.

    for each tt-documentos-erros where tt-documentos-erros.cod-erro = 5455:
        delete tt-documentos-erros.
    end.

    for each tt-doc-erros-tmp:
        create tt-documentos-erros.
        buffer-copy tt-doc-erros-tmp to tt-documentos-erros.    
    end.


END.

RUN pi-finalizar IN h-acomp.

PROCEDURE geraEmbarque:
    
    RUN setConstraintEmbarqueImp IN h-imapi009 (INPUT ROWID(embarque-imp)).

    /*** Devolve temp-table contendo o embarque ***/
    RUN getEmbarqueImportacao IN h-imapi009 (OUTPUT TABLE tt-embarque).
    FIND FIRST tt-embarque NO-ERROR.
    if avail tt-embarque then do:

        ASSIGN tt-emb.cod-despachante            = tt-embarque.cod-despachante           
               tt-emb.cod-transportador          = tt-embarque.cod-transportador         
               tt-emb.desc-via-transp            = {adinc/i01ad268.i 4 tt-embarque.cod-via-transp}
               tt-emb.cod-incoterm               = tt-embarque.cod-incoterm              
               tt-emb.declaracao-import          = tt-embarque.declaracao-import         
               tt-emb.nr-rof                     = tt-embarque.nr-rof                    
               tt-emb.cod-banco                  = tt-embarque.cod-banco                 
               tt-emb.contabilizado              = string(tt-embarque.contabilizado, "Sim/NÆo")
               tt-emb.carta-credito              = tt-embarque.carta-credito             
               tt-emb.narrativa                  = tt-embarque.narrativa                 
               tt-emb.desc-situacao              = {cxinc/i01cx220.i 4 tt-embarque.situacao} 
               tt-emb.id-meio-transp             = tt-embarque.id-meio-transp            
               tt-emb.val-perc-ir                = tt-embarque.val-perc-ir               
               tt-emb.val-perc-juros             = tt-embarque.val-perc-juros            
               tt-emb.cod-conhecto-master        = tt-embarque.cod-conhecto-master        
               tt-emb.cod-conhecto-house         = tt-embarque.cod-conhecto-house        
               tt-emb.cdn-corretor-cambio-import = tt-embarque.cdn-corretor-cambio-import
               tt-emb.cdn-despa-exter-import     = tt-embarque.cdn-despa-exter-import    
               tt-emb.cdn-segurad-import         = tt-embarque.cdn-segurad-import        
               tt-emb.cdn-corretor-import        = tt-embarque.cdn-corretor-import.
                
    end.

    /*** Devolve temp-table contendo o importador ***/
    RUN getImportador IN h-imapi009 (OUTPUT TABLE tt-estabelec).
    FIND FIRST tt-estabelec NO-ERROR.
    if avail tt-estabelec then
        ASSIGN tt-emb.nome-import          = tt-estabelec.nome
               tt-emb.endereco-import      = tt-estabelec.endereco             
               tt-emb.bairro-import        = tt-estabelec.bairro               
               tt-emb.cidade-import        = tt-estabelec.cidade               
               tt-emb.pais-import          = tt-estabelec.pais                     
               tt-emb.cep-import           = tt-estabelec.cep                      
               tt-emb.cgc-import           = tt-estabelec.cgc                      
               tt-emb.estado-import        = tt-estabelec.estado               
               tt-emb.ins-estadual-import  = tt-estabelec.ins-estadual     
               tt-emb.ins-municipal-import = tt-estabelec.ins-municipal    
               tt-emb.cod-suframa-import   = tt-estabelec.cod-suframa      
               tt-emb.cod-emit-import      = tt-estabelec.cod-emitente.         

    /*** Devolve temp-table contendo o emitente ***/
    RUN getEmitenteImportador IN h-imapi009 (OUTPUT TABLE tt-emitente).
    FIND FIRST tt-emitente NO-ERROR.
    if avail tt-emitente then
        ASSIGN tt-emb.nome-emit-import	         = tt-emitente.nome-emit
               tt-emb.endereco-emit-import	     = tt-emitente.endereco
               tt-emb.bairro-emit-import	     = tt-emitente.bairro
               tt-emb.cidade-emit-import	     = tt-emitente.cidade
               tt-emb.pais-emit-import	         = tt-emitente.pais
               tt-emb.cep-emit-import	         = tt-emitente.cep
               tt-emb.cgc-emit-import	         = tt-emitente.cgc
               tt-emb.estado-emit-import	     = tt-emitente.estado
               tt-emb.ins-estadual-emit-import	 = tt-emitente.ins-estadual
               tt-emb.ins-municipal-emit-import	 = tt-emitente.ins-municipal
               tt-emb.caixa-postal-emit-import	 = tt-emitente.caixa-postal
               tt-emb.e-mail-emit-import	     = tt-emitente.e-mail
               tt-emb.cod-aba-emit-import        = tt-emitente.cod-aba
               tt-emb.telefone1-emit-import	     = tt-emitente.telefone[1]
               tt-emb.telefone2-emit-import	     = tt-emitente.telefone[2]
               tt-emb.ramal1-emit-import	     = tt-emitente.ramal[1]
               tt-emb.ramal2-emit-import         = tt-emitente.ramal[2]
               tt-emb.home-page-emit-import   	 = tt-emitente.home-page
               tt-emb.telefax-emit-import        = tt-emitente.telefax
               tt-emb.ramal-fax-emit-import    	 = tt-emitente.ramal-fax
               tt-emb.telef-fac-emit-import    	 = tt-emitente.telef-fac
               tt-emb.ramal-fac-emit-import    	 = tt-emitente.ramal-fac
               tt-emb.telef-modem-emit-import 	 = tt-emitente.telef-modem
               tt-emb.ramal-modem-emit-import 	 = tt-emitente.ramal-modem.

    /*** Devolve temp-table contendo o Despachante ***/
    RUN getDespachante IN h-imapi009 (OUTPUT TABLE tt-emitente).
    FIND FIRST tt-emitente NO-ERROR.
    if avail tt-emitente then
        ASSIGN tt-emb.nome-despach	        = tt-emitente.nome-emit
               tt-emb.endereco-despach      = tt-emitente.endereco
               tt-emb.bairro-despach        = tt-emitente.bairro
               tt-emb.cidade-despach        = tt-emitente.cidade
               tt-emb.pais-despach	        = tt-emitente.pais
               tt-emb.cep-despach	        = tt-emitente.cep
               tt-emb.cgc-despach	        = tt-emitente.cgc
               tt-emb.estado-despach	    = tt-emitente.estado
               tt-emb.ins-estadual-despach	= tt-emitente.ins-estadual
               tt-emb.ins-municipal-despach	= tt-emitente.ins-municipal
               tt-emb.caixa-postal-despach	= tt-emitente.caixa-postal
               tt-emb.e-mail-despach        = tt-emitente.e-mail
               tt-emb.cod-aba-despach	    = tt-emitente.cod-aba
               tt-emb.telefone1-despach	    = tt-emitente.telefone[1]
               tt-emb.telefone2-despach	    = tt-emitente.telefone[2]
               tt-emb.ramal1-despach	    = tt-emitente.ramal[1]
               tt-emb.ramal2-despach	    = tt-emitente.ramal[2]
               tt-emb.home-page-despach	    = tt-emitente.home-page
               tt-emb.telefax-despach	    = tt-emitente.telefax
               tt-emb.ramal-fax-despach	    = tt-emitente.ramal-fax
               tt-emb.telef-fac-despach	    = tt-emitente.telef-fac
               tt-emb.ramal-fac-despach	    = tt-emitente.ramal-fac
               tt-emb.telef-modem-despach	= tt-emitente.telef-modem
               tt-emb.ramal-modem-despach	= tt-emitente.ramal-modem.

    /*** Devolve temp-table contendo o Corretor Cambio ***/
    RUN getCorretorCambio IN h-imapi009 (OUTPUT TABLE tt-emitente).
    FIND FIRST tt-emitente NO-ERROR.
    if avail tt-emitente then
        ASSIGN tt-emb.nome-corretor-cam	         = tt-emitente.nome-emit
               tt-emb.endereco-corretor-cam      = tt-emitente.endereco
               tt-emb.bairro-corretor-cam        = tt-emitente.bairro
               tt-emb.cidade-corretor-cam        = tt-emitente.cidade
               tt-emb.pais-corretor-cam	         = tt-emitente.pais
               tt-emb.cep-corretor-cam	         = tt-emitente.cep
               tt-emb.cgc-corretor-cam	         = tt-emitente.cgc
               tt-emb.estado-corretor-cam        = tt-emitente.estado
               tt-emb.ins-estadual-corretor-cam	 = tt-emitente.ins-estadual
               tt-emb.ins-municipal-corretor-cam = tt-emitente.ins-municipal
               tt-emb.caixa-postal-corretor-cam	 = tt-emitente.caixa-postal
               tt-emb.e-mail-corretor-cam	     = tt-emitente.e-mail
               tt-emb.cod-aba-corretor-cam	     = tt-emitente.cod-aba
               tt-emb.telefone1-corretor-cam     = tt-emitente.telefone[1]
               tt-emb.telefone2-corretor-cam     = tt-emitente.telefone[2]
               tt-emb.ramal1-corretor-cam	     = tt-emitente.ramal[1]
               tt-emb.ramal2-corretor-cam	     = tt-emitente.ramal[2]
               tt-emb.home-page-corretor-cam     = tt-emitente.home-page
               tt-emb.telefax-corretor-cam	     = tt-emitente.telefax
               tt-emb.ramal-fax-corretor-cam     = tt-emitente.ramal-fax
               tt-emb.telef-fac-corretor-cam     = tt-emitente.telef-fac
               tt-emb.ramal-fac-corretor-cam     = tt-emitente.ramal-fac
               tt-emb.telef-modem-corretor-cam   = tt-emitente.telef-modem
               tt-emb.ramal-modem-corretor-cam   = tt-emitente.ramal-modem.

    /*** Devolve temp-table contendo o Despachante Externo ***/
    RUN getDespachExterno IN h-imapi009 (OUTPUT TABLE tt-emitente).
    FIND FIRST tt-emitente NO-ERROR.
    if avail tt-emitente then
        ASSIGN tt-emb.nome-despach-ext	        = tt-emitente.nome-emit
               tt-emb.endereco-despach-ext      = tt-emitente.endereco
               tt-emb.bairro-despach-ext        = tt-emitente.bairro
               tt-emb.cidade-despach-ext        = tt-emitente.cidade
               tt-emb.pais-despach-ext	        = tt-emitente.pais
               tt-emb.cep-despach-ext	        = tt-emitente.cep
               tt-emb.cgc-despach-ext	        = tt-emitente.cgc
               tt-emb.estado-despach-ext	    = tt-emitente.estado
               tt-emb.ins-estadual-despach-ext	= tt-emitente.ins-estadual
               tt-emb.ins-municipal-despach-ext	= tt-emitente.ins-municipal
               tt-emb.caixa-postal-despach-ext	= tt-emitente.caixa-postal
               tt-emb.e-mail-despach-ext        = tt-emitente.e-mail
               tt-emb.cod-aba-despach-ext       = tt-emitente.cod-aba
               tt-emb.telefone1-despach-ext    	= tt-emitente.telefone[1]
               tt-emb.telefone2-despach-ext    	= tt-emitente.telefone[2]
               tt-emb.ramal1-despach-ext        = tt-emitente.ramal[1]
               tt-emb.ramal2-despach-ext        = tt-emitente.ramal[2]
               tt-emb.home-page-despach-ext    	= tt-emitente.home-page
               tt-emb.telefax-despach-ext       = tt-emitente.telefax
               tt-emb.ramal-fax-despach-ext    	= tt-emitente.ramal-fax
               tt-emb.telef-fac-despach-ext    	= tt-emitente.telef-fac
               tt-emb.ramal-fac-despach-ext  	= tt-emitente.ramal-fac
               tt-emb.telef-modem-despach-ext	= tt-emitente.telef-modem
               tt-emb.ramal-modem-despach-ext	= tt-emitente.ramal-modem.

    /*** Devolve temp-table contendo a Seguradora ***/
    RUN getSeguradora IN h-imapi009 (OUTPUT TABLE tt-emitente).
    FIND FIRST tt-emitente NO-ERROR.
    if avail tt-emitente then
        ASSIGN tt-emb.nome-segurad	        = tt-emitente.nome-emit
               tt-emb.endereco-segurad	    = tt-emitente.endereco
               tt-emb.bairro-segurad	    = tt-emitente.bairro
               tt-emb.cidade-segurad	    = tt-emitente.cidade
               tt-emb.pais-segurad	        = tt-emitente.pais
               tt-emb.cep-segurad	        = tt-emitente.cep
               tt-emb.cgc-segurad	        = tt-emitente.cgc
               tt-emb.estado-segurad	    = tt-emitente.estado
               tt-emb.ins-estadual-segurad	= tt-emitente.ins-estadual
               tt-emb.ins-municipal-segurad	= tt-emitente.ins-municipal
               tt-emb.caixa-postal-segurad	= tt-emitente.caixa-postal
               tt-emb.e-mail-segurad	    = tt-emitente.e-mail
               tt-emb.cod-aba-segurad	    = tt-emitente.cod-aba
               tt-emb.telefone1-segurad	    = tt-emitente.telefone[1]
               tt-emb.telefone2-segurad	    = tt-emitente.telefone[2]
               tt-emb.ramal1-segurad	    = tt-emitente.ramal[1]
               tt-emb.ramal2-segurad	    = tt-emitente.ramal[2]
               tt-emb.home-page-segurad	    = tt-emitente.home-page
               tt-emb.telefax-segurad	    = tt-emitente.telefax
               tt-emb.ramal-fax-segurad	    = tt-emitente.ramal-fax
               tt-emb.telef-fac-segurad	    = tt-emitente.telef-fac
               tt-emb.ramal-fac-segurad	    = tt-emitente.ramal-fac
               tt-emb.telef-modem-segurad	= tt-emitente.telef-modem
               tt-emb.ramal-modem-segurad	= tt-emitente.ramal-modem.

    /*** Devolve temp-table contendo o Corretor de Importacao ***/
    RUN getCorretorImport IN h-imapi009 (OUTPUT TABLE tt-emitente).
    FIND FIRST tt-emitente NO-ERROR.
    if avail tt-emitente then
        ASSIGN tt-emb.nome-corretor-imp	         = tt-emitente.nome-emit
               tt-emb.endereco-corretor-imp	     = tt-emitente.endereco
               tt-emb.bairro-corretor-imp	     = tt-emitente.bairro
               tt-emb.cidade-corretor-imp	     = tt-emitente.cidade
               tt-emb.pais-corretor-imp	         = tt-emitente.pais
               tt-emb.cep-corretor-imp	         = tt-emitente.cep
               tt-emb.cgc-corretor-imp	         = tt-emitente.cgc
               tt-emb.estado-corretor-imp	     = tt-emitente.estado
               tt-emb.ins-estadual-corretor-imp	 = tt-emitente.ins-estadual
               tt-emb.ins-municipal-corretor-imp = tt-emitente.ins-municipal
               tt-emb.caixa-postal-corretor-imp	 = tt-emitente.caixa-postal
               tt-emb.e-mail-corretor-imp	     = tt-emitente.e-mail
               tt-emb.cod-aba-corretor-imp	     = tt-emitente.cod-aba
               tt-emb.telefone1-corretor-imp	 = tt-emitente.telefone[1]
               tt-emb.telefone2-corretor-imp	 = tt-emitente.telefone[2]
               tt-emb.ramal1-corretor-imp	     = tt-emitente.ramal[1]
               tt-emb.ramal2-corretor-imp	     = tt-emitente.ramal[2]
               tt-emb.home-page-corretor-imp	 = tt-emitente.home-page
               tt-emb.telefax-corretor-imp	     = tt-emitente.telefax
               tt-emb.ramal-fax-corretor-imp	 = tt-emitente.ramal-fax
               tt-emb.telef-fac-corretor-imp	 = tt-emitente.telef-fac
               tt-emb.ramal-fac-corretor-imp	 = tt-emitente.ramal-fac
               tt-emb.telef-modem-corretor-imp	 = tt-emitente.telef-modem
               tt-emb.ramal-modem-corretor-imp	 = tt-emitente.ramal-modem.

    /*** Devolve temp-table contendo o transportador ***/
    RUN getTransportador IN h-imapi009 (OUTPUT TABLE tt-transporte).
    FIND FIRST tt-transporte NO-ERROR.        
    if avail tt-transporte then
        ASSIGN tt-emb.nome-transp	       = tt-transporte.nome
               tt-emb.nome-abrev-transp	   = tt-transporte.nome-abrev
               tt-emb.endereco-transp	   = tt-transporte.endereco
               tt-emb.bairro-transp	       = tt-transporte.bairro
               tt-emb.cidade-transp	       = tt-transporte.cidade
               tt-emb.pais-transp	       = tt-transporte.pais
               tt-emb.cep-transp	       = tt-transporte.cep
               tt-emb.cgc-transp	       = tt-transporte.cgc
               tt-emb.estado-transp	       = tt-transporte.estado
               tt-emb.ins-estadual-transp  = tt-transporte.ins-estadual
               tt-emb.caixa-postal-transp  = tt-transporte.cx-postal
               tt-emb.contato-transp	   = tt-transporte.contato
               tt-emb.telefone-transp	   = tt-transporte.telefone
               tt-emb.ramal-transp	       = tt-transporte.ramal
               tt-emb.telefax-transp	   = tt-transporte.telefax
               tt-emb.telex-transp	       = tt-transporte.telex
               tt-emb.ins-municipal-transp = tt-transporte.ins-municipal
               tt-emb.zip-code-transp	   = tt-transporte.zip-code
               tt-emb.e-mail-transp	       = tt-transporte.e-mail
               tt-emb.telef-modem-transp   = tt-transporte.telef-modem
               tt-emb.home-page-transp	   = tt-transporte.home-page
               tt-emb.ramal-modem-transp   = tt-transporte.ramal-modem
               tt-emb.ramal-fax-transp	   = tt-transporte.ramal-fax.

    /*** Devolve temp-table contendo o Incoterm ***/
    RUN getIncoterm IN h-imapi009 (OUTPUT TABLE tt-inco-cx).
    FIND FIRST tt-inco-cx NO-ERROR.
    if avail tt-inco-cx then
        ASSIGN tt-emb.desc-incoterm	= tt-inco-cx.descricao.

    /*** Devolve temp-table contendo do Banco ***/
    RUN getBanco IN h-imapi009 (OUTPUT TABLE tt-banco).
    FIND FIRST tt-banco NO-ERROR.
    if avail tt-banco then
        ASSIGN tt-emb.desc-banco = tt-banco.nome-banco
               tt-emb.ag-banco	 = tt-banco.ag-padrao.

    /*** Devolve temp-table contendo a Agencia do Banco ***/
    RUN getAgenciaBanco IN h-imapi009 (OUTPUT TABLE tt-agencia).
    FIND FIRST tt-agencia NO-ERROR.
    if avail tt-agencia then
        ASSIGN tt-emb.desc-agencia = tt-agencia.nome.

    /*** Devolve temp-table contendo o Itinerario ***/
    RUN getItinerario IN h-imapi009 (OUTPUT TABLE tt-itinerario).
    FIND FIRST tt-itinerario NO-ERROR.
    if avail tt-itinerario then
        ASSIGN tt-emb.desc-itner	= tt-itinerario.descricao
               tt-emb.distancia	    = tt-itinerario.distancia
               tt-emb.nr-dias	    = tt-itinerario.nr-dias
               tt-emb.narrat-itiner	= tt-itinerario.narrativa.

    /*** Devolve temp-table contendo os Pontos de controle do itinerario ***/
    RUN getPontosControleItiner IN h-imapi009 (OUTPUT TABLE tt-emb-pto-contr).
    FOR EACH tt-emb-pto-contr:                       
        CASE tt-emb-pto-contr.tp-pto-contr:
            WHEN 1 THEN DO:
                ASSIGN tt-emb.pto-despacho	         = tt-emb-pto-contr.pto-contr               
                       tt-emb.desc-pto-despacho	     = tt-emb-pto-contr.desc-pto-contr          
                       tt-emb.data-prev-despacho     = tt-emb-pto-contr.data-prev-pto-contr     
                       tt-emb.data-efet-despacho     = tt-emb-pto-contr.data-efet-pto-contr     
                       tt-emb.data-ult-prev-despacho = tt-emb-pto-contr.data-ult-prev-pto-contr 
                       tt-emb.ufr-despacho	         = tt-emb-pto-contr.unid-referencial.
            END.
            WHEN 2 THEN DO:
                ASSIGN tt-emb.pto-embarque	         = tt-emb-pto-contr.pto-contr               
                       tt-emb.desc-pto-embarque	     = tt-emb-pto-contr.desc-pto-contr          
                       tt-emb.data-prev-embarque     = tt-emb-pto-contr.data-prev-pto-contr     
                       tt-emb.data-efet-embarque     = tt-emb-pto-contr.data-efet-pto-contr     
                       tt-emb.data-ult-prev-embarque = tt-emb-pto-contr.data-ult-prev-pto-contr 
                       tt-emb.ufr-embarque	         = tt-emb-pto-contr.unid-referencial.
            END.
            WHEN 3 THEN DO:
                ASSIGN tt-emb.pto-nacionaliz	       = tt-emb-pto-contr.pto-contr                
                       tt-emb.desc-pto-nacionaliz      = tt-emb-pto-contr.desc-pto-contr           
                       tt-emb.data-prev-nacionaliz     = tt-emb-pto-contr.data-prev-pto-contr      
                       tt-emb.data-efet-nacionaliz     = tt-emb-pto-contr.data-efet-pto-contr      
                       tt-emb.data-ult-prev-nacionaliz = tt-emb-pto-contr.data-ult-prev-pto-contr  
                       tt-emb.ufr-nacionaliz	       = tt-emb-pto-contr.unid-referencial.
            END.
            WHEN 5 THEN DO:
                ASSIGN tt-emb.pto-chegada	        = tt-emb-pto-contr.pto-contr               
                       tt-emb.desc-pto-chegada	    = tt-emb-pto-contr.desc-pto-contr          
                       tt-emb.data-prev-chegada	    = tt-emb-pto-contr.data-prev-pto-contr     
                       tt-emb.data-efet-chegada     = tt-emb-pto-contr.data-efet-pto-contr     
                       tt-emb.data-ult-prev-chegada = tt-emb-pto-contr.data-ult-prev-pto-contr 
                       tt-emb.ufr-chegada	        = tt-emb-pto-contr.unid-referencial.  
            END.                                                            
        END CASE.
    END.         
    RUN piCarregaEmbarque.
END PROCEDURE.         

PROCEDURE piCarregaProcesso:

    RUN setConstraintPedidoCompr IN h-imapi009 (INPUT tt-processo-imp.r-rowid-pedido).
    {imp/im9100.i2 tt-processo-imp}

    run piCarregaProcesso-2.

    find first tt-documentos-erros where tt-documentos-erros.cod-erro = 27066 no-lock no-error.
    if avail tt-documentos-erros then
        next.

    find first tt-documentos-erros where tt-documentos-erros.cod-erro <> 5455 no-lock no-error.
    if not avail tt-documentos-erros then do:
        RUN imp/im9100a.p (INPUT  TABLE tt-emb,
                           INPUT  TABLE tt-pedido-compr-emb,
                           INPUT  table tt-pedido-compr-emb-aux,
                           INPUT  table tt-pedido-compr-emb-aux2,
                           INPUT  table tt-pedido-compr-emb-aux3,
                           INPUT  TABLE tt-fabr-ped-compr-emb,
                           INPUT  TABLE tt-ncm-fabr-ped-compr-emb,
                           INPUT  TABLE tt-ordem-ncm-fabr-ped-compr-emb,
                           INPUT  TABLE tt-desp-embarque,
                           INPUT  TABLE tt-processo-imp,
                           INPUT  TABLE tt-processo-imp-aux,
                           INPUT  TABLE tt-processo-imp-aux2,
                           INPUT  TABLE tt-processo-imp-aux3,
                           INPUT  TABLE tt-fabr-processo-imp,
                           INPUT  TABLE tt-ncm-fabr-processo-imp,
                           INPUT  TABLE tt-ordem-ncm-fabr-processo-imp,
                           INPUT  TABLE tt-desp-pedido,
                           INPUT  TABLE tt-param,
                           INPUT  h-acomp,
                           INPUT-OUTPUT TABLE tt-documentos-impressos,
                           OUTPUT TABLE tt-documentos-erros).

        find first tt-documentos-erros where tt-documentos-erros.cod-erro = 5455 no-error.
        if avail tt-documentos-erros then do:
            create tt-doc-erros-tmp.
            buffer-copy tt-documentos-erros to tt-doc-erros-tmp.
        end.
    end.
    

END PROCEDURE.

procedure piCarregaProcesso-2:

    FOR EACH tt-fabr-processo-imp:
        {imp/im9100.i1 tt-fabr-processo-imp}
    END.

    FOR EACH tt-ncm-fabr-processo-imp:
        {imp/im9100.i1 tt-ncm-fabr-processo-imp}
    END.

    FOR EACH tt-ordem-ncm-fabr-processo-imp:
        {imp/im9100.i1 tt-ordem-ncm-fabr-processo-imp}
    END.

    FOR EACH tt-ordem-ncm-fabr-processo-imp
        break by tt-ordem-ncm-fabr-processo-imp.ncm
              by tt-ordem-ncm-fabr-processo-imp.cod-fabricante
              by tt-ordem-ncm-fabr-processo-imp.num-pedido
              by tt-ordem-ncm-fabr-processo-imp.nr-proc-imp:
        {imp/im9100.i1 total tt-ordem-ncm-fabr-processo-imp}
    END.

    for each tt-desp-pedido:
        {imp/im9100.i1 tt-desp-pedido}
    end.
    
end.

PROCEDURE piCarregaEmbarque:
    
    for each tt-pedido-compr-emb:
        RUN setConstraintPedidoCompr IN h-imapi009 (INPUT tt-pedido-compr-emb.r-rowid).
        {imp/im9100.i2 tt-pedido-compr-emb}
    end.

    run piCarregaEmbarque-2.

    find first tt-documentos-erros where tt-documentos-erros.cod-erro = 27066 no-lock no-error.
    if avail tt-documentos-erros then
        next.

    find first tt-documentos-erros where tt-documentos-erros.cod-erro <> 5455 no-lock no-error.
    if not avail tt-documentos-erros then do:
        RUN imp/im9100a.p (INPUT  TABLE tt-emb,
                           INPUT  TABLE tt-pedido-compr-emb,
                           INPUT  table tt-pedido-compr-emb-aux,
                           INPUT  table tt-pedido-compr-emb-aux2,
                           INPUT  table tt-pedido-compr-emb-aux3,
                           INPUT  TABLE tt-fabr-ped-compr-emb,
                           INPUT  TABLE tt-ncm-fabr-ped-compr-emb,
                           INPUT  TABLE tt-ordem-ncm-fabr-ped-compr-emb,
                           INPUT  TABLE tt-desp-embarque,
                           INPUT  TABLE tt-processo-imp,
                           INPUT  TABLE tt-processo-imp-aux,
                           INPUT  TABLE tt-processo-imp-aux2,
                           INPUT  TABLE tt-processo-imp-aux3,
                           INPUT  TABLE tt-fabr-processo-imp,
                           INPUT  TABLE tt-ncm-fabr-processo-imp,
                           INPUT  TABLE tt-ordem-ncm-fabr-processo-imp,
                           INPUT  TABLE tt-desp-pedido,
                           INPUT  TABLE tt-param,
                           INPUT  h-acomp,
                           INPUT-OUTPUT TABLE tt-documentos-impressos,
                           OUTPUT TABLE tt-documentos-erros).

        find first tt-documentos-erros where tt-documentos-erros.cod-erro = 5455 no-error.
        if avail tt-documentos-erros then do:
            create tt-doc-erros-tmp.
            buffer-copy tt-documentos-erros to tt-doc-erros-tmp.
        end.
    end.
    
END.

procedure piCarregaEmbarque-2:

    FOR EACH tt-fabr-ped-compr-emb:
        {imp/im9100.i1 tt-fabr-ped-compr-emb}
    END.  

    FOR EACH tt-ncm-fabr-ped-compr-emb:
        {imp/im9100.i1 tt-ncm-fabr-ped-compr-emb}
    END.  
    
    FOR EACH tt-ordem-ncm-fabr-ped-compr-emb:
        {imp/im9100.i1 tt-ordem-ncm-fabr-ped-compr-emb}
    END.

    FOR EACH tt-ordem-ncm-fabr-ped-compr-emb break
          by tt-ordem-ncm-fabr-ped-compr-emb.ncm
          by tt-ordem-ncm-fabr-ped-compr-emb.cod-fabricante
          by tt-ordem-ncm-fabr-ped-compr-emb.num-pedido
          by tt-ordem-ncm-fabr-ped-compr-emb.embarque:
        {imp/im9100.i1 total tt-ordem-ncm-fabr-ped-compr-emb}
    END.
    
    FOR EACH tt-desp-embarque:
        {imp/im9100.i1 tt-desp-embarque}
    END.

end procedure.

IF VALID-HANDLE(h-imapi009) THEN DO:
    DELETE PROCEDURE h-imapi009.
    ASSIGN h-imapi009 = ?.
END.
