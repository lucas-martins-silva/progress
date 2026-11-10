/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IMAPI009 2.00.00.018 } /*** "010018" 26/10/2023 11:58:12  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i imapi009 MIM}
&ENDIF

/*******************************************************************************
**  Programa: IMAPI006.P
**  Objetivo:
**  Autor...: Datasul Logistica ITS0076  
**  Data....: 04.03.2005 09:01
*******************************************************************************/
{cdp/cdcfgmat.i}
{imp/imapi009.i}
{imp/imapi009.i1}
{imp/imapi009.i2}
{imp/imapi009.i3}
{imp/imapi009.i4}
{utp/ut-glob.i}

DEFINE VARIABLE r-processo               AS ROWID   NO-UNDO.
DEFINE VARIABLE r-embarque               AS ROWID   NO-UNDO.
DEFINE VARIABLE r-pedido                 AS ROWID   NO-UNDO.
DEFINE VARIABLE r-ordem                  AS ROWID   NO-UNDO.
DEFINE VARIABLE r-prazo-compra           AS ROWID   NO-UNDO.
DEFINE VARIABLE r-cotacao-item-cex       AS ROWID   NO-UNDO.
DEFINE VARIABLE r-desp-embarque          AS ROWID   NO-UNDO.
DEFINE VARIABLE i-traducao               AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE i-moeda                  AS INTEGER NO-UNDO.
DEFINE VARIABLE l-itiner                 AS LOGICAL NO-UNDO.
DEFINE VARIABLE h-bocx220                AS HANDLE  NO-UNDO.
DEFINE VARIABLE dt-emb-ini               AS DATE    INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF  NO-UNDO.
DEFINE VARIABLE dt-emb-fim               AS DATE    INITIAL 12/31/9999 NO-UNDO.
DEFINE VARIABLE de-aliq-ipi              LIKE item-doc-est.aliquota-ipi  NO-UNDO.
DEFINE VARIABLE i-trib-ipi               LIKE item-doc-est.cd-trib-ipi   NO-UNDO.
DEFINE VARIABLE c-trib-icm               LIKE item-doc-est.cd-trib-icm   NO-UNDO.
DEFINE VARIABLE de-aliq-icm              LIKE item-doc-est.aliquota-ipi  NO-UNDO.
DEFINE VARIABLE i-trib-pis               AS INT                          NO-UNDO.
DEFINE VARIABLE de-aliq-pis              AS DEC                          NO-UNDO.
DEFINE VARIABLE de-valor-un-pis          AS DEC                          NO-UNDO.
DEFINE VARIABLE de-valor-vol-pis         AS DEC                          NO-UNDO.
DEFINE VARIABLE de-red-pis               AS DEC FORMAT ">>9.99"          NO-UNDO. /* Valor Reducao PIS          */
DEFINE VARIABLE de-red-cofins            AS DEC FORMAT ">>9.99"          NO-UNDO. /* Valor Reducao COFINS       */
DEFINE VARIABLE l-ordens-embarque        AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE i-trib-ii                AS INT                          NO-UNDO.
DEFINE VARIABLE de-aliq-ii               AS DEC                          NO-UNDO.
DEFINE VARIABLE i-trib-cofins            AS INT                          NO-UNDO.
DEFINE VARIABLE de-aliq-cofins           AS DEC                          NO-UNDO.
DEFINE VARIABLE de-valor-un-cofins       AS DEC                          NO-UNDO.
DEFINE VARIABLE de-valor-vol-cofins      AS DEC                          NO-UNDO.
define variable h-im9042                 as handle                       no-undo.
DEFINE VARIABLE d-qtd-embal              AS DEC NO-UNDO.
DEFINE BUFFER b-emit-estab FOR emitente.

DEFINE VARIABLE h-boin356ab AS HANDLE NO-UNDO.
DEFINE VARIABLE h-im9048    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bodi425   AS HANDLE NO-UNDO.

PROCEDURE emptyTempTables:

    EMPTY TEMP-TABLE tt-estabelec.
    EMPTY TEMP-TABLE tt-embarque.
    EMPTY TEMP-TABLE tt-processo.
    EMPTY TEMP-TABLE tt-pedido.
    EMPTY TEMP-TABLE tt-ordens-embarque.
    EMPTY TEMP-TABLE tt-banco.
    EMPTY TEMP-TABLE tt-banco.
    EMPTY TEMP-TABLE tt-agencia.
    EMPTY TEMP-TABLE tt-emitente.
    EMPTY TEMP-TABLE tt-comprador.
    EMPTY TEMP-TABLE tt-invoice.
    EMPTY TEMP-TABLE tt-pd-fecha-camb.
    EMPTY TEMP-TABLE tt-desp-embarque.
    empty temp-table tt-ordens.
    empty temp-table tt-cotacao-item.
    empty temp-table tt-pto-contr.
    empty temp-table tt-pais.
    empty temp-table tt-moeda.
    empty temp-table tt-item.
    empty temp-table tt-narrativa.
    empty temp-table tt-grup-estoq.
    empty temp-table tt-familia.
    empty temp-table tt-fam-comerc.
    empty temp-table tt-item-fornec.
    empty temp-table tt-un.
    empty temp-table tt-embalag.
    empty temp-table tt-parcelas.
    empty temp-table tt-cotacao-item-cex.
    empty temp-table tt-desp.
    empty temp-table tt-mensagens.
    empty temp-table tt-inco-cx.
    empty temp-table tt-itinerario.
    empty temp-table tt-transporte.
    empty temp-table tt-assinaturas.
    empty temp-table tt-pontos-controle-pedido.    
    empty temp-table tt-classif-fisc.  
    EMPTY TEMP-TABLE tt-calculos-ordem-compra-emb.

END PROCEDURE.

PROCEDURE setConstraintProcessoImp:
    DEFINE INPUT PARAMETER p-processo AS ROWID NO-UNDO.
    ASSIGN r-processo = p-processo
           r-embarque = ?
           r-pedido   = ?
           r-ordem    = ?
           r-prazo-compra = ?
           r-desp-embarque = ?
           r-cotacao-item-cex = ?.
END PROCEDURE.

PROCEDURE setConstraintEmbarqueImp:
    DEFINE INPUT PARAMETER p-embarque AS ROWID NO-UNDO.
    ASSIGN r-embarque = p-embarque
           r-processo = ?
           r-pedido   = ?
           r-ordem    = ?
           r-prazo-compra = ?
           r-desp-embarque = ?
           r-cotacao-item-cex = ?.
END PROCEDURE.

PROCEDURE setConstraintPedidoCompr:
    DEFINE INPUT PARAMETER p-pedido AS ROWID NO-UNDO.
    ASSIGN r-pedido   = p-pedido
           r-processo = ?
           r-embarque = ?
           r-ordem    = ?
           r-prazo-compra = ?
           r-desp-embarque = ?
           r-cotacao-item-cex = ?.
END PROCEDURE.

procedure setConstraintOrdensCompra:
    DEFINE INPUT PARAMETER p-ordem AS ROWID NO-UNDO.
    ASSIGN r-ordem    = p-ordem
           r-pedido   = ?
           r-processo = ?
           r-embarque = ?
           r-prazo-compra = ?
           r-desp-embarque = ?
           r-cotacao-item-cex = ?.
end procedure.

procedure setConstraintCotacaoItemCex:
    DEFINE INPUT PARAMETER p-cotacao-item-cex AS ROWID NO-UNDO.
    ASSIGN r-ordem    = ?
           r-pedido   = ?
           r-processo = ?
           r-embarque = ?
           r-prazo-compra = ?
           r-desp-embarque = ?
           r-cotacao-item-cex = p-cotacao-item-cex.
end procedure.

procedure setConstraintPrazoCompra:
    DEFINE INPUT PARAMETER p-prazo-compra AS ROWID NO-UNDO.
    ASSIGN r-ordem    = ?
           r-pedido   = ?
           r-processo = ?
           r-embarque = ?
           r-prazo-compra = p-prazo-compra
           r-desp-embarque = ?
           r-cotacao-item-cex = ?.
end procedure.

procedure setConstraintDespEmbarque:
    DEFINE INPUT PARAMETER p-desp-embarque AS ROWID NO-UNDO.
    ASSIGN r-ordem    = ?
           r-pedido   = ?
           r-processo = ?
           r-embarque = ?
           r-prazo-compra = ?
           r-desp-embarque = p-desp-embarque
           r-cotacao-item-cex = ?.
end procedure.

PROCEDURE setDataEmbarqueInicial:
    DEFINE INPUT PARAMETER pDt-emb-ini AS DATE NO-UNDO.
    ASSIGN dt-emb-ini = pDt-emb-ini.
END PROCEDURE.

PROCEDURE setDataEmbarqueFinal:
    DEFINE INPUT PARAMETER pDt-emb-fim AS DATE NO-UNDO.
    ASSIGN dt-emb-fim = pDt-emb-fim.
END PROCEDURE.

PROCEDURE setTraducao:
    DEFINE INPUT PARAMETER p-traducao AS INTEGER NO-UNDO.
    ASSIGN i-traducao = p-traducao. /* 1 - Nao efetua tradu‡äes automaticas             */
                                    /* 2 - Traduzir para o idioma do corretor de cƒmbio */
                                    /* 3 - Traduzir para o idioma do exportador         */
END PROCEDURE.

PROCEDURE getImportador:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-estabelec.

    empty temp-table tt-estabelec.

    IF r-processo <> ? THEN DO:
        FIND FIRST processo-imp
            WHERE ROWID(processo-imp) = r-processo NO-LOCK NO-ERROR.
        IF AVAIL processo-imp THEN
            FIND FIRST estabelec
                WHERE estabelec.cod-estabel = processo-imp.cod-estabel NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        IF r-embarque <> ? THEN DO:
            FIND FIRST embarque-imp
                WHERE ROWID(embarque-imp) = r-embarque NO-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN
                FIND FIRST estabelec
                    WHERE estabelec.cod-estabel = embarque-imp.cod-estabel NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            IF r-pedido <> ? THEN DO:
                FIND FIRST pedido-compr
                    WHERE ROWID(pedido-compr) = r-pedido NO-LOCK NO-ERROR.
                IF AVAIL pedido-compr THEN
                    FIND FIRST estabelec
                        WHERE estabelec.cod-estabel = pedido-compr.cod-estabel NO-LOCK NO-ERROR.
            END.
            ELSE 
                RETURN "NOK".
        END.
    END.
    IF AVAIL estabelec THEN DO:
        FIND FIRST tt-estabelec
            WHERE  tt-estabelec.cod-estabel = estabelec.cod-estabel NO-ERROR.
        IF NOT AVAIL tt-estabelec THEN
            CREATE tt-estabelec.
        BUFFER-COPY estabelec TO tt-estabelec.
    END.
    ELSE 
        RETURN "NOK".

END PROCEDURE.

PROCEDURE getEmbarqueImportacao:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-embarque.

    empty temp-table tt-embarque.

    IF r-processo <> ? THEN DO:
        RUN GetOrdensEmbarque (OUTPUT TABLE tt-ordens-embarque).
        FOR EACH tt-ordens-embarque NO-LOCK BREAK BY tt-ordens-embarque.embarque:
            IF FIRST-OF(tt-ordens-embarque.embarque) THEN DO:
                FIND FIRST embarque-imp
                    WHERE embarque-imp.embarque = tt-ordens-embarque.embarque NO-LOCK NO-ERROR.
                IF AVAIL embarque-imp THEN DO:
                    FIND FIRST tt-embarque
                        WHERE  tt-embarque.embarque = embarque-imp.embarque NO-ERROR.
                    IF NOT AVAIL tt-embarque THEN
                        CREATE tt-embarque.
                    BUFFER-COPY embarque-imp TO tt-embarque.
                END.
            END.                                                                               
        END.                                                                                   
    END.
    ELSE DO:
        IF r-embarque <> ? THEN DO:
            FIND FIRST embarque-imp
                WHERE ROWID(embarque-imp) = r-embarque NO-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN DO:
                FIND FIRST tt-embarque
                    WHERE  tt-embarque.embarque = embarque-imp.embarque NO-ERROR.
                IF NOT AVAIL tt-embarque THEN
                    CREATE tt-embarque.
                BUFFER-COPY embarque-imp TO tt-embarque.
            END.
        END.
        ELSE DO:
            IF r-pedido <> ? THEN DO:
                RUN GetOrdensEmbarque (OUTPUT TABLE tt-ordens-embarque).
                FOR EACH tt-ordens-embarque NO-LOCK BREAK BY tt-ordens-embarque.embarque:
                    IF FIRST-OF(tt-ordens-embarque.embarque) THEN DO:
                        FIND FIRST embarque-imp
                            WHERE embarque-imp.embarque = tt-ordens-embarque.embarque NO-LOCK NO-ERROR.
                        IF AVAIL embarque-imp THEN DO:
                            FIND FIRST tt-embarque
                                WHERE  tt-embarque.embarque = embarque-imp.embarque NO-ERROR.
                            IF NOT AVAIL tt-embarque THEN
                                CREATE tt-embarque.
                            BUFFER-COPY embarque-imp TO tt-embarque.
                        END.
                    END.                                                                               
                END.                                                                                   
            END.
            ELSE 
                RETURN "NOK".
        END.
    END.
    IF NOT CAN-FIND(FIRST tt-embarque) THEN
        RETURN "NOK".

    FOR EACH tt-embarque:
        FIND LAST historico-embarque 
            WHERE historico-embarque.cod-estabel = tt-embarque.cod-estabel 
            AND   historico-embarque.embarque    = tt-embarque.embarque
            AND   historico-embarque.dt-efetiva <> ? NO-LOCK NO-ERROR.
        IF NOT AVAIL historico-embarque THEN
            FOR EACH historico-embarque FIELDS (cod-estabel embarque id-meio-transp) 
                WHERE historico-embarque.cod-estabel = tt-embarque.cod-estabel  
                AND   historico-embarque.embarque    = tt-embarque.embarque NO-LOCK:

                IF historico-embarque.id-meio-transp <> "" THEN DO:
                    ASSIGN OVERLAY(tt-embarque.char-1,1,20) = historico-embarque.id-meio-transp.
                    LEAVE.
                END.
            END.
        ELSE
            ASSIGN OVERLAY(tt-embarque.char-1,1,20) = historico-embarque.id-meio-transp.
    END.
END PROCEDURE.

PROCEDURE getProcessoImportacao:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-processo.

    empty temp-table tt-processo.

    IF r-processo <> ? THEN DO:
        FIND FIRST processo-imp
            WHERE ROWID(processo-imp) = r-processo NO-LOCK NO-ERROR.
        IF AVAIL processo-imp THEN DO:
            FIND FIRST tt-processo
                WHERE tt-processo.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.
            IF NOT AVAIL tt-processo THEN
                CREATE tt-processo.
            BUFFER-COPY processo-imp TO tt-processo.
            assign tt-processo.destino-documentacao = substr(processo-imp.char-1,1,40).
        END.
    END.
    ELSE 
        IF r-embarque <> ? THEN DO:
            RUN GetOrdensEmbarque (OUTPUT TABLE tt-ordens-embarque).
            FOR EACH tt-ordens-embarque NO-LOCK BREAK BY tt-ordens-embarque.nr-proc-imp:
                IF FIRST-OF(tt-ordens-embarque.nr-proc-imp) THEN DO:
                    FIND FIRST processo-imp
                        WHERE processo-imp.nr-proc-imp = tt-ordens-embarque.nr-proc-imp NO-LOCK NO-ERROR.
                    IF AVAIL processo-imp THEN DO:
                        FIND FIRST tt-processo
                            WHERE tt-processo.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.
                        IF NOT AVAIL tt-processo THEN
                            CREATE tt-processo.
                        BUFFER-COPY processo-imp TO tt-processo.
                        assign tt-processo.destino-documentacao = substr(processo-imp.char-1,1,40).
                    END.
                END.                                                                               
            END.
        END.
        ELSE 
            IF r-pedido <> ? THEN DO:
                FIND FIRST pedido-compr
                    WHERE ROWID(pedido-compr) = r-pedido NO-LOCK NO-ERROR.
                IF AVAIL pedido-compr THEN DO:
                    FIND FIRST processo-imp
                        WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-LOCK NO-ERROR.
                    IF AVAIL processo-imp THEN DO:
                        FIND FIRST tt-processo
                            WHERE tt-processo.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.
                        IF NOT AVAIL tt-processo THEN
                            CREATE tt-processo.
                        BUFFER-COPY processo-imp TO tt-processo.
                        assign tt-processo.destino-documentacao = substr(processo-imp.char-1,1,40).
                    END.                                            
                END.    
            END.
            ELSE 
                IF  r-ordem <> ? THEN DO:

                    FIND ordem-compra
                        WHERE rowid(ordem-compra) = r-ordem NO-LOCK NO-ERROR.
                    IF  AVAIL ordem-compra THEN DO:

                        FIND pedido-compr
                            WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
                        IF  AVAIL pedido-compr THEN DO:

                            FIND FIRST processo-imp
                                WHERE processo-imp.num-pedido = pedido-compr.num-pedido NO-LOCK NO-ERROR.
                            IF  AVAIL processo-imp THEN DO:

                                FIND FIRST tt-processo
                                    WHERE  tt-processo.nr-proc-imp = processo-imp.nr-proc-imp NO-ERROR.
                                IF  NOT AVAIL tt-processo THEN
                                    CREATE tt-processo.

                                BUFFER-COPY processo-imp TO tt-processo.
                                assign tt-processo.destino-documentacao = substr(processo-imp.char-1,1,40).
                            END.                                            
                        END.    
                    END.
                END.
                ELSE 
                    RETURN "NOK".
    
    IF NOT CAN-FIND(FIRST tt-processo) THEN
        RETURN "NOK".
    
    return "OK".
END PROCEDURE.

PROCEDURE getPedidoCompra:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-pedido.

    empty temp-table tt-pedido.

    IF r-processo <> ? THEN DO:
        FIND FIRST processo-imp
            WHERE ROWID(processo-imp) = r-processo NO-LOCK NO-ERROR.
        IF AVAIL processo-imp THEN DO:
            FIND FIRST pedido-compr
                WHERE pedido-compr.num-pedido = processo-imp.num-pedido NO-LOCK NO-ERROR.
            IF AVAIL pedido-compr THEN DO:
                FIND FIRST tt-pedido
                    WHERE tt-pedido.num-pedido = pedido-compr.num-pedido NO-ERROR.
                IF NOT AVAIL tt-pedido THEN
                    CREATE tt-pedido.
                BUFFER-COPY pedido-compr TO tt-pedido.
                FIND FIRST cond-pagto
                    WHERE  cond-pagto.cod-cond-pag = tt-pedido.cod-cond-pag NO-LOCK NO-ERROR.
                IF AVAIL cond-pagto THEN
                    ASSIGN tt-pedido.desc-cond-pagto = cond-pagto.descricao.
            END.
        END.
    END.
    ELSE DO:
        IF r-embarque <> ? THEN DO:
            RUN GetOrdensEmbarque (OUTPUT TABLE tt-ordens-embarque).
            FOR EACH tt-ordens-embarque NO-LOCK BREAK BY tt-ordens-embarque.nr-proc-imp:
                IF FIRST-OF(tt-ordens-embarque.nr-proc-imp) THEN DO:
                    FIND FIRST processo-imp
                        WHERE processo-imp.nr-proc-imp = tt-ordens-embarque.nr-proc-imp NO-LOCK NO-ERROR.
                    IF AVAIL processo-imp THEN DO:
                        FIND FIRST pedido-compr
                            WHERE pedido-compr.num-pedido = processo-imp.num-pedido NO-LOCK NO-ERROR.
                        IF AVAIL pedido-compr THEN DO:
                            FIND FIRST tt-pedido
                                WHERE tt-pedido.num-pedido = pedido-compr.num-pedido NO-ERROR.
                            IF NOT AVAIL tt-pedido THEN
                                CREATE tt-pedido.
                            BUFFER-COPY pedido-compr TO tt-pedido.
                            FIND FIRST cond-pagto
                                WHERE  cond-pagto.cod-cond-pag = tt-pedido.cod-cond-pag NO-LOCK NO-ERROR.
                            IF AVAIL cond-pagto THEN
                                ASSIGN tt-pedido.desc-cond-pagto = cond-pagto.descricao.
                        END.
                    END.
                END.                                                                               
            END.
        END.
        ELSE DO:
            IF r-pedido <> ? THEN DO:
                FIND FIRST pedido-compr
                    WHERE ROWID(pedido-compr) = r-pedido NO-LOCK NO-ERROR.
                IF AVAIL pedido-compr THEN DO:
                    FIND FIRST tt-pedido
                        WHERE tt-pedido.num-pedido = pedido-compr.num-pedido NO-ERROR.
                    IF NOT AVAIL tt-pedido THEN
                        CREATE tt-pedido.
                    BUFFER-COPY pedido-compr TO tt-pedido.
                    FIND FIRST cond-pagto
                        WHERE  cond-pagto.cod-cond-pag = tt-pedido.cod-cond-pag NO-LOCK NO-ERROR.
                    IF AVAIL cond-pagto THEN
                        ASSIGN tt-pedido.desc-cond-pagto = cond-pagto.descricao.
                END.    
            END.
            ELSE 
                RETURN "NOK".
        END.
    END.
    IF NOT CAN-FIND(FIRST tt-pedido) THEN
        RETURN "NOK".
        
    return "OK".
END PROCEDURE.

PROCEDURE getOrdensEmbarque:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordens-embarque.

    empty temp-table tt-ordens-embarque.

    IF r-processo <> ? THEN DO:
        FIND FIRST processo-imp
            WHERE ROWID(processo-imp) = r-processo NO-LOCK NO-ERROR.
        IF AVAIL processo-imp THEN
            FOR EACH ordens-embarque
                WHERE ordens-embarque.cod-estabel = processo-imp.cod-estabel 
                AND   ordens-embarque.nr-proc-imp = processo-imp.nr-proc-imp NO-LOCK:
                FIND FIRST tt-ordens-embarque
                    WHERE tt-ordens-embarque.cod-estabel =  ordens-embarque.cod-estabel
                    AND   tt-ordens-embarque.embarque    =  ordens-embarque.embarque NO-ERROR.
                IF NOT AVAIL tt-ordens-embarque THEN
                    CREATE tt-ordens-embarque.
                BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
            END.
    END.
    ELSE DO:
        IF r-embarque <> ? THEN DO:
            FIND FIRST embarque-imp
                WHERE ROWID(embarque-imp) = r-embarque NO-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN
                FOR EACH ordens-embarque
                    WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel 
                    AND   ordens-embarque.embarque    = embarque-imp.embarque NO-LOCK:
                    FIND FIRST tt-ordens-embarque
                        WHERE tt-ordens-embarque.cod-estabel  =  ordens-embarque.cod-estabel
                        AND   tt-ordens-embarque.embarque     =  ordens-embarque.embarque 
                        AND   tt-ordens-embarque.numero-ordem = ordens-embarque.numero-ordem
                        AND   tt-ordens-embarque.parcela      = ordens-embarque.parcela NO-ERROR.
                    IF NOT AVAIL tt-ordens-embarque THEN
                        CREATE tt-ordens-embarque.
                    BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
                END.
        END.
        ELSE DO:
            IF r-pedido <> ? THEN DO:
                RUN GetProcessoImportacao (OUTPUT TABLE tt-processo).
                FOR EACH tt-processo:
                    FOR EACH ordens-embarque
                        WHERE ordens-embarque.cod-estabel = tt-processo.cod-estabel
                        AND   ordens-embarque.nr-proc-imp = tt-processo.nr-proc-imp NO-LOCK:
                        FIND FIRST tt-ordens-embarque
                            WHERE tt-ordens-embarque.cod-estabel = ordens-embarque.cod-estabel
                            AND   tt-ordens-embarque.embarque    = ordens-embarque.embarque NO-ERROR.
                        IF NOT AVAIL tt-ordens-embarque THEN
                            CREATE tt-ordens-embarque.
                        BUFFER-COPY ordens-embarque TO tt-ordens-embarque.
                    END.
                END.
            END.
            ELSE 
                RETURN "NOK".
        END.
    END.
    IF NOT CAN-FIND(FIRST tt-ordens-embarque) THEN
        RETURN "NOK".
        
    return "OK".
END PROCEDURE.

PROCEDURE getExportador:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-emitente.

    empty temp-table tt-emitente.

    RUN GetProcessoImportacao (OUTPUT TABLE tt-processo).

    FOR EACH  tt-processo:

        FIND FIRST emitente
            WHERE emitente.cod-emitente = tt-processo.cod-exportador NO-LOCK NO-ERROR.
        IF  AVAIL emitente THEN DO:
    
            FIND FIRST tt-emitente
                WHERE tt-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
            IF  NOT AVAIL tt-emitente THEN
                CREATE tt-emitente.
    
            if  tt-processo.cod-exportador > 0 then do:

                BUFFER-COPY emitente TO tt-emitente.
    
                FIND FIRST emitente-cex
                    WHERE emitente-cex.cod-emitente = tt-processo.cod-exportador NO-LOCK NO-ERROR.
                IF  AVAIL emitente-cex THEN DO:
        
                    ASSIGN tt-emitente.cod-itiner-exp                   = emitente-cex.cod-itiner-exp
                           tt-emitente.cod-idioma                       = emitente-cex.cod-idioma
                           tt-emitente.cod-aba                          = emitente-cex.cod-aba
                           tt-emitente.cod-repres                       = emitente-cex.cod-repres
                           tt-emitente.cod-incoterm-exp                 = emitente-cex.cod-incoterm-exp
                           tt-emitente.cod-itiner-imp                   = emitente-cex.cod-itiner-imp
                           tt-emitente.cod-incoterm-imp                 = emitente-cex.cod-incoterm-imp
                           tt-emitente.log-desp-inclusas                = emitente-cex.log-desp-inclusas
                           tt-emitente.nr-tab                           = emitente-cex.nr-tab
                           tt-emitente.cod-pto-contr                    = emitente-cex.cod-pto-contr
                           tt-emitente.des-layout-origin-comerc-        = emitente-cex.des-layout-origin-comerc-
                           tt-emitente.des-layout-origin-packing        = emitente-cex.des-layout-origin-packing
                           tt-emitente.des-layout-origin-proform        = emitente-cex.des-layout-origin-proform
                           tt-emitente.des-layout-origin-ped-cambio     = emitente-cex.des-layout-origin-ped-cambio    
                           tt-emitente.des-layout-origin-instruc-embarq = emitente-cex.des-layout-origin-instruc-embarq
                           tt-emitente.cdn-despa-import                 = emitente-cex.cdn-despa-import
                           tt-emitente.cdn-despa-exter-import           = emitente-cex.cdn-despa-exter-import
                           tt-emitente.cdn-segurad-import               = emitente-cex.cdn-segurad-import
                           tt-emitente.cdn-corretor-cambio-impor        = emitente-cex.cdn-corretor-cambio-impor
                           tt-emitente.cdn-corretor-import              = emitente-cex.cdn-corretor-import
                           tt-emitente.marca-1                          = emitente-cex.marca-1
                           tt-emitente.marca-2                          = emitente-cex.marca-2
                           tt-emitente.marca-3                          = emitente-cex.marca-3
                           tt-emitente.marca-4                          = emitente-cex.marca-4
                           tt-emitente.marca-5                          = emitente-cex.marca-5.
                end.
            END.            
        END.
        ELSE
            RETURN "NOK".
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.

    return "OK".
END PROCEDURE.

PROCEDURE getBanco:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-banco.

    empty temp-table tt-banco.

    IF r-processo <> ? THEN DO:
        FIND FIRST processo-imp
            WHERE ROWID(processo-imp) = r-processo NO-LOCK NO-ERROR.
        IF AVAIL processo-imp THEN DO:
            FIND FIRST banco
                WHERE banco.cod-banco = processo-imp.cod-banco NO-LOCK NO-ERROR.
            IF AVAIL banco THEN DO:
                FIND FIRST tt-banco
                    WHERE tt-banco.cod-banco = banco.cod-banco NO-ERROR.
                IF NOT AVAIL tt-banco THEN
                    CREATE tt-banco.
                BUFFER-COPY banco TO tt-banco.
            END.
        END.
    END.
    ELSE DO:
        IF r-embarque <> ? THEN DO:
            FIND FIRST embarque-imp
                WHERE ROWID(embarque-imp) = r-embarque NO-LOCK NO-ERROR.
            IF AVAIL embarque-imp THEN DO:
                FIND FIRST banco
                    WHERE banco.cod-banco = embarque-imp.cod-banco NO-LOCK NO-ERROR.
                IF AVAIL banco THEN DO:
                    FIND FIRST tt-banco
                        WHERE tt-banco.cod-banco = banco.cod-banco NO-ERROR.
                    IF NOT AVAIL tt-banco THEN
                        CREATE tt-banco.
                    BUFFER-COPY banco TO tt-banco.
                END.
            END.
        END.
        ELSE DO:
            IF r-pedido <> ? THEN DO:
                RUN GetProcessoImportacao (OUTPUT TABLE tt-processo).
                FOR EACH tt-processo:
                    FIND FIRST banco
                        WHERE  banco.cod-banco = tt-processo.cod-banco NO-LOCK NO-ERROR.
                    IF AVAIL banco THEN DO:
                        FIND FIRST tt-banco
                            WHERE tt-banco.cod-banco = banco.cod-banco NO-ERROR.
                        IF NOT AVAIL tt-banco THEN
                            CREATE tt-banco.
                        BUFFER-COPY banco TO tt-banco.
                    END.
                END.
            END.
        END.
    END.
    IF NOT CAN-FIND(FIRST tt-banco) THEN
        RETURN "NOK".

    return "OK".
END PROCEDURE.

PROCEDURE getBancoExportador:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-banco.

    empty temp-table tt-banco.

    RUN GetExportador (OUTPUT TABLE tt-emitente).

    FIND FIRST tt-emitente NO-ERROR.
    IF AVAIL tt-emitente THEN DO:
        FIND FIRST banco 
            WHERE banco.cod-banco = tt-emitente.cod-banco NO-LOCK NO-ERROR.
        IF AVAIL banco THEN DO:
            FIND FIRST tt-banco
                WHERE tt-banco.cod-banco = banco.cod-banco NO-ERROR.
            IF NOT AVAIL tt-banco THEN
                CREATE tt-banco.
            BUFFER-COPY banco TO tt-banco.
            return "OK".
        END.
        ELSE 
            RETURN "NOK".
    END.
END PROCEDURE.

PROCEDURE getAgenciaExportador:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-agencia.

    empty temp-table tt-agencia.

    RUN GetExportador (OUTPUT TABLE tt-emitente).

    FIND FIRST tt-emitente NO-ERROR.
    IF AVAIL tt-emitente THEN DO:
        FIND FIRST agencia 
            WHERE agencia.cod-banco = tt-emitente.cod-banco 
            &IF DEFINED(BF_MAT_COMEX) &THEN
                AND agencia.agencia = tt-emitente.agencia
            &ENDIF
            NO-LOCK NO-ERROR.
        IF AVAIL agencia THEN DO:
            FIND FIRST tt-agencia
                WHERE tt-agencia.cod-banco = agencia.cod-banco 
                AND   tt-agencia.agencia   = agencia.agencia NO-ERROR.
            IF NOT AVAIL tt-agencia THEN
                CREATE tt-agencia.
            BUFFER-COPY agencia TO tt-agencia.
            return "OK".
        END.
        ELSE 
            RETURN "NOK".
    END.
END PROCEDURE.

PROCEDURE getCorretorCambio:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-emitente.

    empty temp-table tt-emitente.

    IF r-processo <> ? THEN DO:

        FIND FIRST processo-imp
            WHERE ROWID(processo-imp) = r-processo NO-LOCK NO-ERROR.
        IF  AVAIL processo-imp then do:

            FIND FIRST emitente
                WHERE emitente.cod-emitente = processo-imp.cdn-corretor-cambio-import NO-LOCK NO-ERROR.
            IF  AVAIL emitente THEN DO:
    
                FIND FIRST tt-emitente
                    WHERE tt-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
                IF  NOT AVAIL tt-emitente THEN
                    CREATE tt-emitente.
    
                if  processo-imp.cdn-corretor-cambio-import > 0 THEN DO:

                    BUFFER-COPY emitente TO tt-emitente.
        
                    FIND FIRST emitente-cex
                        WHERE emitente-cex.cod-emitente = processo-imp.cdn-corretor-cambio-import NO-LOCK NO-ERROR.
                    IF  AVAIL emitente-cex THEN DO:
        
                        ASSIGN tt-emitente.cod-itiner-exp                   = emitente-cex.cod-itiner-exp
                               tt-emitente.cod-idioma                       = emitente-cex.cod-idioma
                               tt-emitente.cod-aba                          = emitente-cex.cod-aba
                               tt-emitente.cod-repres                       = emitente-cex.cod-repres
                               tt-emitente.cod-incoterm-exp                 = emitente-cex.cod-incoterm-exp
                               tt-emitente.cod-itiner-imp                   = emitente-cex.cod-itiner-imp
                               tt-emitente.cod-incoterm-imp                 = emitente-cex.cod-incoterm-imp
                               tt-emitente.log-desp-inclusas                = emitente-cex.log-desp-inclusas
                               tt-emitente.nr-tab                           = emitente-cex.nr-tab
                               tt-emitente.cod-pto-contr                    = emitente-cex.cod-pto-contr
                               tt-emitente.des-layout-origin-comerc-        = emitente-cex.des-layout-origin-comerc-
                               tt-emitente.des-layout-origin-packing        = emitente-cex.des-layout-origin-packing
                               tt-emitente.des-layout-origin-proform        = emitente-cex.des-layout-origin-proform
                               tt-emitente.des-layout-origin-ped-cambio     = emitente-cex.des-layout-origin-ped-cambio
                               tt-emitente.des-layout-origin-instruc-embarq = emitente-cex.des-layout-origin-instruc-embarq
                               tt-emitente.cdn-despa-import                 = emitente-cex.cdn-despa-import
                               tt-emitente.cdn-despa-exter-import           = emitente-cex.cdn-despa-exter-import
                               tt-emitente.cdn-segurad-import               = emitente-cex.cdn-segurad-import
                               tt-emitente.cdn-corretor-cambio-impor        = emitente-cex.cdn-corretor-cambio-impor
                               tt-emitente.cdn-corretor-import              = emitente-cex.cdn-corretor-import
                               tt-emitente.marca-1                          = emitente-cex.marca-1
                               tt-emitente.marca-2                          = emitente-cex.marca-2
                               tt-emitente.marca-3                          = emitente-cex.marca-3
                               tt-emitente.marca-4                          = emitente-cex.marca-4
                               tt-emitente.marca-5                          = emitente-cex.marca-5.
                    end.
                END.       
            END.    
        END.
    END.
    ELSE DO:
        IF  r-embarque <> ? THEN DO:

            FIND FIRST embarque-imp
                WHERE ROWID(embarque-imp) = r-embarque NO-LOCK NO-ERROR.
            IF  AVAIL embarque-imp then do:
        
                FIND FIRST emitente
                    WHERE emitente.cod-emitente = embarque-imp.cdn-corretor-cambio-import NO-LOCK NO-ERROR.
                IF  AVAIL emitente THEN DO:
    
                    FIND FIRST tt-emitente
                        WHERE tt-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
                    IF  NOT AVAIL tt-emitente THEN
                        CREATE tt-emitente.
    
                    if  embarque-imp.cdn-corretor-cambio-import > 0 THEN DO:

                        BUFFER-COPY emitente TO tt-emitente.
        
                        FIND FIRST emitente-cex
                            WHERE emitente-cex.cod-emitente = embarque-imp.cdn-corretor-cambio-import NO-LOCK NO-ERROR.
                        IF  AVAIL emitente-cex THEN DO:
        
                            ASSIGN tt-emitente.cod-itiner-exp                   = emitente-cex.cod-itiner-exp
                                   tt-emitente.cod-idioma                       = emitente-cex.cod-idioma
                                   tt-emitente.cod-aba                          = emitente-cex.cod-aba
                                   tt-emitente.cod-repres                       = emitente-cex.cod-repres
                                   tt-emitente.cod-incoterm-exp                 = emitente-cex.cod-incoterm-exp
                                   tt-emitente.cod-itiner-imp                   = emitente-cex.cod-itiner-imp
                                   tt-emitente.cod-incoterm-imp                 = emitente-cex.cod-incoterm-imp
                                   tt-emitente.log-desp-inclusas                = emitente-cex.log-desp-inclusas
                                   tt-emitente.nr-tab                           = emitente-cex.nr-tab
                                   tt-emitente.cod-pto-contr                    = emitente-cex.cod-pto-contr
                                   tt-emitente.des-layout-origin-comerc-        = emitente-cex.des-layout-origin-comerc-
                                   tt-emitente.des-layout-origin-packing        = emitente-cex.des-layout-origin-packing
                                   tt-emitente.des-layout-origin-proform        = emitente-cex.des-layout-origin-proform
                                   tt-emitente.des-layout-origin-ped-cambio     = emitente-cex.des-layout-origin-ped-cambio
                                   tt-emitente.des-layout-origin-instruc-embarq = emitente-cex.des-layout-origin-instruc-embarq
                                   tt-emitente.cdn-despa-import                 = emitente-cex.cdn-despa-import
                                   tt-emitente.cdn-despa-exter-import           = emitente-cex.cdn-despa-exter-import
                                   tt-emitente.cdn-segurad-import               = emitente-cex.cdn-segurad-import
                                   tt-emitente.cdn-corretor-cambio-impor        = emitente-cex.cdn-corretor-cambio-impor
                                   tt-emitente.cdn-corretor-import              = emitente-cex.cdn-corretor-import
                                   tt-emitente.marca-1                          = emitente-cex.marca-1
                                   tt-emitente.marca-2                          = emitente-cex.marca-2
                                   tt-emitente.marca-3                          = emitente-cex.marca-3
                                   tt-emitente.marca-4                          = emitente-cex.marca-4
                                   tt-emitente.marca-5                          = emitente-cex.marca-5.
                        end.
                    END.       
                END.
            end.
        END.
        ELSE DO:
            IF  r-pedido <> ? THEN DO:

                RUN GetProcessoImportacao (OUTPUT TABLE tt-processo).

                FOR EACH tt-processo:

                    FIND FIRST emitente
                        WHERE emitente.cod-emitente = tt-processo.cdn-corretor-cambio-import NO-LOCK NO-ERROR.
                    IF  AVAIL emitente THEN DO:
    
                        FIND FIRST tt-emitente
                            WHERE tt-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
                        IF  NOT AVAIL tt-emitente THEN
                            CREATE tt-emitente.
    
                        if  tt-processo.cdn-corretor-cambio-import > 0 then do:

                            BUFFER-COPY emitente TO tt-emitente.
        
                            FIND FIRST emitente-cex
                                WHERE emitente-cex.cod-emitente = tt-processo.cdn-corretor-cambio-import NO-LOCK NO-ERROR.
                            IF  AVAIL emitente-cex THEN DO:
        
                                ASSIGN tt-emitente.cod-itiner-exp                   = emitente-cex.cod-itiner-exp
                                       tt-emitente.cod-idioma                       = emitente-cex.cod-idioma
                                       tt-emitente.cod-aba                          = emitente-cex.cod-aba
                                       tt-emitente.cod-repres                       = emitente-cex.cod-repres
                                       tt-emitente.cod-incoterm-exp                 = emitente-cex.cod-incoterm-exp
                                       tt-emitente.cod-itiner-imp                   = emitente-cex.cod-itiner-imp
                                       tt-emitente.cod-incoterm-imp                 = emitente-cex.cod-incoterm-imp
                                       tt-emitente.log-desp-inclusas                = emitente-cex.log-desp-inclusas
                                       tt-emitente.nr-tab                           = emitente-cex.nr-tab
                                       tt-emitente.cod-pto-contr                    = emitente-cex.cod-pto-contr
                                       tt-emitente.des-layout-origin-comerc-        = emitente-cex.des-layout-origin-comerc-
                                       tt-emitente.des-layout-origin-packing        = emitente-cex.des-layout-origin-packing
                                       tt-emitente.des-layout-origin-proform        = emitente-cex.des-layout-origin-proform
                                       tt-emitente.des-layout-origin-ped-cambio     = emitente-cex.des-layout-origin-ped-cambio
                                       tt-emitente.des-layout-origin-instruc-embarq = emitente-cex.des-layout-origin-instruc-embarq
                                       tt-emitente.cdn-despa-import                 = emitente-cex.cdn-despa-import
                                       tt-emitente.cdn-despa-exter-import           = emitente-cex.cdn-despa-exter-import
                                       tt-emitente.cdn-segurad-import               = emitente-cex.cdn-segurad-import
                                       tt-emitente.cdn-corretor-cambio-impor        = emitente-cex.cdn-corretor-cambio-impor
                                       tt-emitente.cdn-corretor-import              = emitente-cex.cdn-corretor-import
                                       tt-emitente.marca-1                          = emitente-cex.marca-1
                                       tt-emitente.marca-2                          = emitente-cex.marca-2
                                       tt-emitente.marca-3                          = emitente-cex.marca-3
                                       tt-emitente.marca-4                          = emitente-cex.marca-4
                                       tt-emitente.marca-5                          = emitente-cex.marca-5.
                            end.
                        END.
                    END.
                END.
            END.
        END.
    END.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
END PROCEDURE.

PROCEDURE getComprador:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-comprador.

   empty temp-table tt-comprador.

    RUN GetOrdensEmbarque (OUTPUT TABLE tt-ordens-embarque).

    FIND FIRST tt-ordens-embarque NO-ERROR.
    IF AVAIL tt-ordens-embarque THEN DO:
        FIND FIRST ordem-compra 
            WHERE ordem-compra.numero-ordem = tt-ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
            FIND FIRST comprador
                WHERE comprador.cod-comprado = ordem-compra.cod-comprado NO-LOCK NO-ERROR.
            IF AVAIL comprador THEN DO:
                FIND FIRST tt-comprador
                    WHERE tt-comprador.cod-comprado = comprador.cod-comprado NO-ERROR.
                IF NOT AVAIL tt-comprador THEN
                    CREATE tt-comprador.
                BUFFER-COPY comprador TO tt-comprador.
            END.
        END.
    END.
    IF NOT CAN-FIND(FIRST tt-comprador) THEN
        RETURN "NOK".
    ELSE
        return "OK".
END PROCEDURE.

PROCEDURE getPedFechaCambio:
    DEFINE INPUT  PARAMETER nr-invoice-ini LIKE invoice-emb-imp.nr-invoice.
    DEFINE INPUT  PARAMETER nr-invoice-fim LIKE invoice-emb-imp.nr-invoice.
    DEFINE INPUT  PARAMETER dt-vencim-ini  LIKE invoice-emb-imp.dt-vencim.
    DEFINE INPUT  PARAMETER dt-vencim-fim  LIKE invoice-emb-imp.dt-vencim.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-invoice.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-pd-fecha-camb.
    
    empty temp-table tt-invoice.
    empty temp-table tt-pd-fecha-camb.

    RUN GetEmbarqueImportacao (OUTPUT TABLE tt-embarque).

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.

    FOR EACH tt-embarque:

        FOR EACH invoice-emb-imp
            WHERE invoice-emb-imp.cod-estabel = tt-embarque.cod-estabel
            AND   invoice-emb-imp.embarque    = tt-embarque.embarque
            AND   invoice-emb-imp.nr-invoice >= nr-invoice-ini
            AND   invoice-emb-imp.nr-invoice <= nr-invoice-fim
            AND   invoice-emb-imp.dt-vencim  >= dt-vencim-ini 
            AND   invoice-emb-imp.dt-vencim  <= dt-vencim-fim NO-LOCK:
            
            CREATE tt-invoice.
            BUFFER-COPY invoice-emb-imp TO tt-invoice.

            CREATE tt-pd-fecha-camb.
            ASSIGN tt-pd-fecha-camb.cod-estabel = invoice-emb-imp.cod-estabel
                   tt-pd-fecha-camb.embarque    = invoice-emb-imp.embarque   
                   tt-pd-fecha-camb.nr-invoice  = invoice-emb-imp.nr-invoice 
                   tt-pd-fecha-camb.parcela     = invoice-emb-imp.parcela.    

            FIND FIRST moeda
                WHERE moeda.mo-codigo = invoice-emb-imp.mo-codigo NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN tt-invoice.mo-desc   = moeda.descricao
                       tt-pd-fecha-camb.mo-desc = moeda.descricao.

            ASSIGN l-itiner = NO.

            empty temp-table tt-desp-embarque.

            bloco-A: 
            FOR EACH historico-embarque
                WHERE historico-embarque.embarque    = tt-embarque.embarque
                AND   historico-embarque.cod-estabel = tt-embarque.cod-estabel NO-LOCK 
                BY historico-embarque.sequencia:

                IF l-itiner = NO THEN DO:
                    FOR FIRST itinerario FIELDS(pto-desembarque) NO-LOCK
                        WHERE itinerario.cod-itiner = historico-embarque.cod-itiner: END.
                    FOR FIRST embarque-imp FIELDS(cdn-pto-desembar) NO-LOCK
                        WHERE embarque-imp.cod-estab = tt-embarque.embarque
                          AND embarque-imp.embarque = tt-embarque.cod-estabel: END.
                    ASSIGN l-itiner = YES.
                END.

                IF ((embarque-imp.cdn-pto-desembar > 0 AND historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar) OR 
                   (embarque-imp.cdn-pto-desembar <= 0 AND historico-embarque.cod-pto-contr = itinerario.pto-desembarque)) THEN DO:
                    LEAVE bloco-A.
                END.
                ELSE DO:
                    CREATE tt-desp-embarque.
                    ASSIGN tt-desp-embarque.embarque      = tt-embarque.embarque   
                           tt-desp-embarque.cod-estabel   = tt-embarque.cod-estabel
                           tt-desp-embarque.cod-pto-contr = historico-embarque.cod-pto-contr.
                END.
            END.
            for each tt-desp-embarque:
                 for each desp-embarque
                    WHERE desp-embarque.embarque      = tt-desp-embarque.embarque     
                    AND   desp-embarque.cod-estabel   = tt-desp-embarque.cod-estabel  
                    AND   desp-embarque.cod-pto-contr = tt-desp-embarque.cod-pto-contr no-lock:
                    ASSIGN tt-pd-fecha-camb.vl-desp = tt-pd-fecha-camb.vl-desp + desp-embarque.val-desp. 
                 end.
            END.

            ASSIGN tt-pd-fecha-camb.des-meio-transporte = SUBSTR(tt-embarque.char-1,1,20).             

            RUN retornaMoedaValor IN h-bocx220 (INPUT tt-embarque.embarque,
                                                INPUT tt-embarque.cod-estabel,
                                                OUTPUT tt-pd-fecha-camb.vl-merc,
                                                OUTPUT i-moeda).                          

            ASSIGN tt-pd-fecha-camb.vl-total = tt-pd-fecha-camb.vl-merc + tt-pd-fecha-camb.vl-desp.

            FOR EACH historico-embarque NO-LOCK
               WHERE historico-embarque.cod-estabel = tt-embarque.cod-estabel
                 AND historico-embarque.embarque    = tt-embarque.embarque:
                
                IF historico-embarque.cod-pto-contr = tt-embarque.cdn-pto-embarq THEN DO:
                    IF historico-embarque.dt-efetiva <> ? THEN
                        ASSIGN tt-pd-fecha-camb.dt-embarque = historico-embarque.dt-efetiva.
                    ELSE 
                        ASSIGN tt-pd-fecha-camb.dt-embarque = historico-embarque.dt-ult-previsao.
                END.
                IF historico-embarque.cod-pto-contr = tt-embarque.cdn-pto-desembar THEN DO:
                    IF historico-embarque.dt-efetiva <> ? THEN
                        ASSIGN tt-pd-fecha-camb.dt-nacionaliz = historico-embarque.dt-efetiva.
                    ELSE 
                        ASSIGN tt-pd-fecha-camb.dt-nacionaliz = historico-embarque.dt-ult-previsao.
                END.
            END.
        END.                                                                    
    END. 

    IF VALID-HANDLE(h-bocx220) THEN DO:
        DELETE PROCEDURE h-bocx220.
        ASSIGN h-bocx220 = ?.
    END.
END PROCEDURE.

PROCEDURE getCondicaoPagamento:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-cond-pagto.

    empty temp-table tt-cond-pagto.

    if  r-cotacao-item-cex <> ? then do:

        run getCotacaoItemCex (output table tt-cotacao-item-cex).

        find first tt-cotacao-item-cex no-error.
        if  avail tt-cotacao-item-cex then do:

            find cond-pagto
                where cond-pagto.cod-cond-pag = tt-cotacao-item-cex.cod-cond-pag no-lock no-error.
            if  avail cond-pagto 
            and not can-find (first tt-cond-pagto
                              where tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag) then do:

                create tt-cond-pagto.
                buffer-copy cond-pagto to tt-cond-pagto.
            end.
        end.
    end.
    else if r-desp-embarque <> ? then do:

        run getDespEmbarque (output table tt-despesa-emb).
    
        find first tt-despesa-emb no-error.
        if  avail tt-despesa-emb then do:
    
            find cond-pagto
            where cond-pagto.cod-cond-pag = tt-despesa-emb.cod-cond-pag no-lock no-error.
            if  avail cond-pagto 
            and not can-find (first tt-cond-pagto
                              where tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag) then do:

                create tt-cond-pagto.
                buffer-copy cond-pagto to tt-cond-pagto.
            end.            
        end.        
    end.
    ELSE do:
        RUN GetPedidoCompra (OUTPUT TABLE tt-pedido).

        FOR EACH tt-pedido:
            FIND FIRST cond-pagto 
                WHERE cond-pagto.cod-cond-pag = tt-pedido.cod-cond-pag NO-LOCK NO-ERROR.
            IF AVAIL cond-pagto THEN DO:
                FIND FIRST tt-cond-pagto
                    WHERE tt-cond-pagto.cod-cond-pag = cond-pagto.cod-cond-pag NO-ERROR.
                IF NOT AVAIL tt-cond-pagto THEN
                    CREATE tt-cond-pagto.
                BUFFER-COPY cond-pagto TO tt-cond-pagto.

            END.                                        
        END.
    END.

    IF NOT CAN-FIND(FIRST tt-cond-pagto) THEN
        RETURN "NOK".
    ELSE 
        if  i-traducao > 1 then DO:
            FOR EACH tt-cond-pagto:
                IF i-traducao = 2 THEN DO:
                    RUN getCorretorCambio (OUTPUT TABLE tt-emitente).
                    
                    FIND FIRST tt-emitente NO-ERROR.
                    
                    IF AVAIL tt-emitente THEN DO:
                        FIND FIRST trad-cond-pagto
                            WHERE trad-cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag
                            AND   trad-cond-pagto.cod-idioma   = tt-emitente.cod-idioma NO-LOCK NO-ERROR.
                        IF AVAIL trad-cond-pagto THEN
                            ASSIGN tt-cond-pagto.descricao = trad-cond-pagto.tr-descricao
                                   tt-cond-pagto.narrativa = trad-cond-pagto.narrativa.
                    END.                                                                
                END.
                ELSE IF i-traducao = 3 THEN DO:
                    RUN getExportador (OUTPUT TABLE tt-emitente).
                    FIND FIRST tt-emitente NO-ERROR.
                    IF AVAIL tt-emitente THEN DO:
                        FIND FIRST trad-cond-pagto
                            WHERE trad-cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag
                            AND   trad-cond-pagto.cod-idioma   = tt-emitente.cod-idioma NO-LOCK NO-ERROR.
                        IF AVAIL trad-cond-pagto THEN
                            ASSIGN tt-cond-pagto.descricao = trad-cond-pagto.tr-descricao
                                   tt-cond-pagto.narrativa = trad-cond-pagto.narrativa.
                    END.                                                                
                END.
                ELSE DO:
    
                    run getProcessoImportacao (output table tt-processo).
                    FIND FIRST tt-processo NO-ERROR.
                    IF  AVAIL tt-processo THEN DO:
                        FIND FIRST trad-cond-pagto
                            WHERE trad-cond-pagto.cod-cond-pag = tt-cond-pagto.cod-cond-pag
                            AND   trad-cond-pagto.cod-idioma   = tt-processo.cod-idioma NO-LOCK NO-ERROR.
                        IF  AVAIL trad-cond-pagto THEN
                            ASSIGN tt-cond-pagto.descricao = trad-cond-pagto.tr-descricao
                                   tt-cond-pagto.narrativa = trad-cond-pagto.narrativa.
                    END.                                                               
                END.
            END.
        END.

    if  not can-find (first tt-cond-pagto) then 
        return "NOK":U.                       

    return "OK".
END PROCEDURE.

procedure getOrdensCompra:
    define output parameter table for tt-ordens.

    empty temp-table tt-ordens.

    if  r-ordem <> ? then do:

        find ordem-compra
            where rowid(ordem-compra) = r-ordem no-lock no-error.
        if  avail ordem-compra 
        and not can-find (first tt-ordens
                          where tt-ordens.numero-ordem = ordem-compra.numero-ordem) then do:

            create tt-ordens.
            buffer-copy ordem-compra to tt-ordens.
        end.
    end.

    if  not can-find (first tt-ordens) then
        return "NOK":U.
    else do:

        if  i-traducao > 1 then do:

            run getProcessoImportacao (output table tt-processo).

            find first tt-processo no-error.
            if  avail tt-processo  then do:

                find first cotacao-item
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                    and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                    and   cotacao-item.cot-aprovada no-lock no-error.
                if  avail cotacao-item then do:

                    /* Procura pelo fabricante da cotacao aprovada da ordem */
                    find traduc-item
                        where traduc-item.it-codigo    = ordem-compra.it-codigo
                        and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                        and   traduc-item.cod-emitente = int(substr(cotacao-item.char-2,41,20)) no-lock no-error.
                    if  avail traduc-item then
                        assign tt-ordens.it-codigo = traduc-item.tr-it-codigo.
                end.

                if  not avail traduc-item then do:

                    find traduc-item
                        where traduc-item.it-codigo    = ordem-compra.it-codigo
                        and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                        and   traduc-item.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
                    if  avail traduc-item then
                        assign tt-ordens.it-codigo = traduc-item.tr-it-codigo.
                    else do:

                        find traduc-item
                            where traduc-item.it-codigo    = ordem-compra.it-codigo
                            and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                            and   traduc-item.cod-emitente = 0 no-lock no-error.
                        if  avail traduc-item then
                            assign tt-ordens.it-codigo = traduc-item.tr-it-codigo.
                    end.
                end.
            end.
        end.
    end.

end procedure.

procedure getCotacaoItem:
    define output parameter table for tt-cotacao-item.

    empty temp-table tt-cotacao-item.

    if  r-ordem <> ? then do:

        run getOrdensCompra (output table tt-ordens).

        find first tt-ordens no-error.
        if  avail tt-ordens then do:

            find first cotacao-item
                where cotacao-item.numero-ordem = tt-ordens.numero-ordem
                and   cotacao-item.cod-emitente = tt-ordens.cod-emitente
                and   cotacao-item.cot-aprovada no-lock no-error.
            if  avail cotacao-item 
            and not can-find (first tt-cotacao-item
                              where tt-cotacao-item.numero-ordem = cotacao-item.numero-ordem
                              and   tt-cotacao-item.cod-emitente = cotacao-item.cod-emitente
                              and   tt-cotacao-item.it-codigo    = cotacao-item.it-codigo
                              and   tt-cotacao-item.seq-cotac    = cotacao-item.seq-cotac) then do:

                create tt-cotacao-item.
                buffer-copy cotacao-item to tt-cotacao-item.
            end.
        end.
    end.

    if  not can-find (first tt-cotacao-item) then
        return "NOK":U.
    else do:

        if  i-traducao > 1 then do:

            run getProcessoImportacao (output table tt-processo).

            find first tt-processo no-error.
            if  avail tt-processo then do:

                find trad-tab-unidade
                    where trad-tab-unidade.un         = cotacao-item.un
                    and   trad-tab-unidade.cod-idioma = tt-processo.cod-idioma no-lock no-error.
                if  avail trad-tab-unidade then
                    assign tt-cotacao-item.un = trad-tab-unidade.tr-un.
            end.
        end.
    end.

end procedure.

procedure getFabricante:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-ordem <> ? then do:

        run getCotacaoItem (output table tt-cotacao-item).

        find first tt-cotacao-item no-error.
        if  avail tt-cotacao-item then do:

            find emitente
                where emitente.cod-emitente = int(substr(tt-cotacao-item.char-2,41,20)) no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente 
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:
    
                create tt-emitente.

                if  int(substr(tt-cotacao-item.char-2,41,20)) > 0 then do:

                    buffer-copy emitente to tt-emitente.
        
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getPtoControle:
    define output parameter table for tt-pto-contr.

    empty temp-table tt-pto-contr.

    if  r-ordem <> ? then do:

        run getCotacaoItem (output table tt-cotacao-item).

        find first tt-cotacao-item no-error.
        if  avail tt-cotacao-item then do:

            find pto-contr
                where pto-contr.cod-pto-contr = int(substr(tt-cotacao-item.char-1,41,20)) no-lock no-error.
            if  avail pto-contr 
            and not can-find (first tt-pto-contr
                              where tt-pto-contr.cod-pto-contr = pto-contr.cod-pto-contr) then do:

                create tt-pto-contr.
                buffer-copy pto-contr to tt-pto-contr.
            end.
        end.
    end.
    else 
        if  r-cotacao-item-cex <> ? then do:

            run getCotacaoItemCex (output table tt-cotacao-item-cex).

            find first tt-cotacao-item-cex no-error.
            if  avail tt-cotacao-item-cex then do:

                find pto-contr
                    where pto-contr.cod-pto-contr = tt-cotacao-item-cex.cod-pto-contr no-lock no-error.
                if  avail pto-contr 
                and not can-find (first tt-pto-contr
                                  where tt-pto-contr.cod-pto-contr = pto-contr.cod-pto-contr) then do:

                    create tt-pto-contr.
                    buffer-copy pto-contr to tt-pto-contr.
                end.
            end.
        end.
    else do:
        if r-desp-embarque <> ? then do:

            run getDespEmbarque (output table tt-despesa-emb).
        
            find first tt-despesa-emb no-error.
            if  avail tt-despesa-emb then do:
        
                find pto-contr
                where pto-contr.cod-pto-contr = tt-despesa-emb.cod-pto-contr no-lock no-error.
                if  avail pto-contr 
                and not can-find (first tt-pto-contr
                                  where tt-pto-contr.cod-pto-contr = pto-contr.cod-pto-contr) then do:
    
                    create tt-pto-contr.
                    buffer-copy pto-contr to tt-pto-contr.
                end.            
            end.
        end.
    end.

    if  not can-find (first tt-pto-contr) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getPais:
    define output parameter table for tt-pais.

    empty temp-table tt-pais.

    if  r-ordem <> ? then do:

        run getCotacaoItem (output table tt-cotacao-item).

        find first tt-cotacao-item no-error.
        if  avail tt-cotacao-item then do:

            find pais
                where pais.cod-pais = tt-cotacao-item.cdn-pais-orig no-lock no-error.
            if  avail pais 
            and not can-find (first tt-pais 
                              where tt-pais.cod-pais = pais.cod-pais) then do:

                create tt-pais.
                buffer-copy pais to tt-pais.
            end.
        end.
    end.

    if  not can-find (first tt-pais) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getItem:
    define output parameter table for tt-item.

    empty temp-table tt-item.

    if  r-ordem <> ? then do:

        run getOrdensCompra (output table tt-ordens).

        find first tt-ordens no-error.
        if  avail tt-ordens then do:

            find item
                where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
            if  avail item
            and not can-find(first tt-item
                             where tt-item.it-codigo = item.it-codigo) then do:

                create tt-item.
                buffer-copy item to tt-item.
            end.
        end.
    end.

    if  not can-find (first tt-item) then 
        return "NOK":U.

    else do:

        if  i-traducao > 1 then do:

            run getProcessoImportacao (output table tt-processo).

            find first tt-processo no-error.
            if  avail tt-processo then do:

                find trad-tab-unidade
                    where trad-tab-unidade.un         = item.un
                    and   trad-tab-unidade.cod-idioma = tt-processo.cod-idioma no-lock no-error.
                if  avail trad-tab-unidade then
                    assign tt-item.un = trad-tab-unidade.tr-un.

                run getCotacaoItem (output table tt-cotacao-item).

                find first tt-cotacao-item no-error.
                if  avail tt-cotacao-item then do:

                    find traduc-item
                        where traduc-item.it-codigo    = item.it-codigo                           
                        and   traduc-item.cod-idioma   = tt-processo.cod-idioma                   
                        and   traduc-item.cod-emitente = int(substr(tt-cotacao-item.char-2,41,20)) no-lock no-error.
                    if  avail traduc-item then
                        assign tt-item.desc-item = traduc-item.tr-desc-item.
                end.

                if  not avail traduc-item then do:

                    find traduc-item
                        where traduc-item.it-codigo    = item.it-codigo           
                        and   traduc-item.cod-idioma   = tt-processo.cod-idioma   
                        and   traduc-item.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
                    if  avail traduc-item then
                        assign tt-item.desc-item = traduc-item.tr-desc-item.
                    else do:

                        find traduc-item
                            where traduc-item.it-codigo    = item.it-codigo
                            and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                            and   traduc-item.cod-emitente = 0 no-lock no-error.
                        if  avail traduc-item then
                            assign tt-item.desc-item = traduc-item.tr-desc-item.
                    end.
                end.
            end.
        end.
    end.

end procedure.

procedure getNarrativa:
    define output parameter table for tt-narrativa.

    empty temp-table tt-narrativa.

    if  r-ordem <> ? then do:

        run getOrdensCompra (output table tt-ordens).

        find first tt-ordens no-error.
        if  avail tt-ordens then do:

            find narrativa
                where narrativa.it-codigo = ordem-compra.it-codigo no-lock no-error.
            if  avail narrativa 
            and not can-find(first tt-narrativa
                             where tt-narrativa.it-codigo = narrativa.it-codigo) then do:

                create tt-narrativa.
                buffer-copy narrativa to tt-narrativa.
            end.
        end.
    end.

    if  not can-find (first tt-narrativa) then
        return "NOK":U.
    else do:

        if  i-traducao > 1 then do:

            run getProcessoImportacao (output table tt-processo).

            find first tt-processo no-error.
            if  avail tt-processo then do:

                run getCotacaoItem (output table tt-cotacao-item).

                find first tt-cotacao-item no-error.
                if  avail tt-cotacao-item then do:

                    find traduc-item
                        where traduc-item.it-codigo    = narrativa.it-codigo
                        and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                        and   traduc-item.cod-emitente = int(substr(tt-cotacao-item.char-2,41,20)) no-lock no-error.
                    if  avail traduc-item then
                        assign tt-narrativa.descricao = traduc-item.tr-narrativa.
                end.

                if  not avail traduc-item then do:

                    find traduc-item
                        where traduc-item.it-codigo    = narrativa.it-codigo
                        and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                        and   traduc-item.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
                    if  avail traduc-item then
                        assign tt-narrativa.descricao = traduc-item.tr-narrativa.
                    else do:

                        find traduc-item
                            where traduc-item.it-codigo    = narrativa.it-codigo
                            and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                            and   traduc-item.cod-emitente = 0 no-lock no-error.
                        if  avail traduc-item then
                            assign tt-narrativa.descricao = traduc-item.tr-narrativa.
                    end.
                end.
            end.
        end.
    end.

end procedure.

procedure getGrupoEstoque:
    define output parameter table for tt-grup-estoq.

   empty temp-table tt-grup-estoq.

    if  r-ordem <> ? then do:

        run getItem (output table tt-item).

        find first tt-item no-error.
        if  avail tt-item then do:

            find grup-estoque
                where grup-estoque.ge-codigo = tt-item.ge-codigo no-lock no-error.
            if  avail grup-estoque 
            and not can-find(first tt-grup-estoq
                             where tt-grup-estoq.ge-codigo = grup-estoque.ge-codigo) then do:

                create tt-grup-estoq.
                buffer-copy grup-estoque to tt-grup-estoq.
            end.
        end.
    end.

    find first tt-grup-estoq no-error. 
    if not avail tt-grup-estoq then
        return "NOK":U.
    ELSE
        RETURN "OK".
end procedure.

procedure getFamilia:
    define output parameter table for tt-familia.

    empty temp-table tt-familia.

    if  r-ordem <> ? then do:

        run getItem (output table tt-item).

        find first tt-item no-error.
        if  avail tt-item then do:

            find familia
                where familia.fm-codigo = tt-item.fm-codigo no-lock no-error.
            if  avail familia
            and not can-find (first tt-familia
                              where tt-familia.fm-codigo = familia.fm-codigo) then do:

                create tt-familia.
                buffer-copy familia to tt-familia.
            end.
        end.
    end.

    if  not can-find (first tt-familia) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getFamComerc:
    define output parameter table for tt-fam-comerc.

    empty temp-table tt-fam-comerc.

    if  r-ordem <> ? then do:

        run getItem (output table tt-item).

        find first tt-item no-error.
        if  avail tt-item then do:

            find fam-comerc
                where fam-comerc.fm-cod-com = tt-item.fm-cod-com no-lock no-error.
            if  avail fam-comerc 
            and not can-find (first tt-fam-comerc
                              where tt-fam-comerc.fm-cod-com = fam-comerc.fm-cod-com) then do:

                create tt-fam-comerc.
                buffer-copy fam-comerc to tt-fam-comerc.
            end.
        end.
    end.

    if  not can-find (first tt-fam-comerc) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getItemFornec:
    define output parameter table for tt-item-fornec.

    empty temp-table tt-item-fornec.

    if  r-ordem <> ? then do:

        run getOrdensCompra (output table tt-ordens).

        find first tt-ordens no-error.
        if  avail tt-ordens then do:

            find item-fornec
                where item-fornec.it-codigo    = ordem-compra.it-codigo
                and   item-fornec.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
            if  avail item-fornec
            and not can-find (first tt-item-fornec
                              where tt-item-fornec.it-codigo    = item-fornec.it-codigo
                              and   tt-item-fornec.cod-emitente = item-fornec.cod-emitente) then do:

                create tt-item-fornec.
                buffer-copy item-fornec to tt-item-fornec.
            end.
        end.
    end.

    if  not can-find (first tt-item-fornec) then 
        return "NOK":U.
    else do:

        if  i-traducao > 1 then do:

            run getProcessoImportacao (output table tt-processo).

            find first tt-processo no-error.
            if  avail tt-processo then do:

                run getCotacaoItem (output table tt-cotacao-item).

                if  item-fornec.item-do-forn <> "" then do:

                    find first tt-cotacao-item no-error.
                    if  avail tt-cotacao-item then do:

                        find traduc-item
                            where traduc-item.it-codigo    = item-fornec.item-do-forn
                            and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                            and   traduc-item.cod-emitente = int(substr(tt-cotacao-item.char-2,41,20)) no-lock no-error.
                        if  avail traduc-item then
                            assign tt-item-fornec.item-do-forn = traduc-item.tr-it-codigo
                                   tt-item-fornec.narrativa    = traduc-item.tr-narrativa.
                    end.

                    if  not avail traduc-item then do:
        
                        find traduc-item
                            where traduc-item.it-codigo    = item-fornec.item-do-forn
                            and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                            and   traduc-item.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
                        if  avail traduc-item then
                            assign tt-item-fornec.item-do-forn = traduc-item.tr-it-codigo
                                   tt-item-fornec.narrativa    = traduc-item.tr-narrativa.
                        else do:
        
                            find traduc-item
                                where traduc-item.it-codigo    = item-fornec.item-do-forn
                                and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                                and   traduc-item.cod-emitente = 0 no-lock no-error.
                            if  avail traduc-item then
                                assign tt-item-fornec.item-do-forn = traduc-item.tr-it-codigo
                                       tt-item-fornec.narrativa    = traduc-item.tr-narrativa.
                        end.
                    end.
                end.
                else do:

                    find first tt-cotacao-item no-error.
                    if  avail tt-cotacao-item then do:

                        find traduc-item
                            where traduc-item.it-codigo    = item-fornec.it-codigo
                            and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                            and   traduc-item.cod-emitente = int(substr(tt-cotacao-item.char-2,41,20)) no-lock no-error.
                        if  avail traduc-item then
                            assign tt-item-fornec.item-do-forn = traduc-item.tr-it-codigo
                                   tt-item-fornec.narrativa    = traduc-item.tr-narrativa.
                
                    end.

                    if  not avail traduc-item then do:
        
                        find traduc-item
                            where traduc-item.it-codigo    = item-fornec.it-codigo
                            and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                            and   traduc-item.cod-emitente = ordem-compra.cod-emitente no-lock no-error.
                        if  avail traduc-item then
                            assign tt-item-fornec.item-do-forn = traduc-item.tr-it-codigo
                                   tt-item-fornec.narrativa    = traduc-item.tr-narrativa.
                        else do:
        
                            find traduc-item
                                where traduc-item.it-codigo    = item-fornec.it-codigo
                                and   traduc-item.cod-idioma   = tt-processo.cod-idioma
                                and   traduc-item.cod-emitente = 0 no-lock no-error.
                            if  avail traduc-item then
                                assign tt-item-fornec.item-do-forn = traduc-item.tr-it-codigo
                                       tt-item-fornec.narrativa    = traduc-item.tr-narrativa.
                        end.
                    end.
                end.

                find trad-embalag
                    where trad-embalag.embalagem  = item-fornec.cod-embal 
                    and   trad-embalag.cod-idioma = tt-processo.cod-idioma no-lock no-error.
                if  avail trad-embalag then 
                    assign tt-item-fornec.cod-embal = trad-embalag.tr-embalagem.
            end.
        end.
    end.

end procedure.

procedure getUn:
    define output parameter table for tt-un.

    empty temp-table tt-un.

    if  r-ordem <> ? then do:

        run getCotacaoItem (output table tt-cotacao-item).

        find first tt-cotacao-item no-error.
        if  avail tt-cotacao-item then do:

            find tab-unidade
                where tab-unidade.un = cotacao-item.un no-lock no-error.
            if  avail tab-unidade 
            and not can-find (first tt-un
                              where tt-un.un = tab-unidade.un) then do:

                create tt-un.
                buffer-copy tab-unidade to tt-un.
                assign tt-un.desc-un-fornec = tab-unidade.descricao.
            end.
        end.

        find first tt-un no-error.
        if  avail tt-un then do:

            run getItem (output table tt-item).

            find first tt-item no-error.
            if  avail tt-item then do:
    
                find tab-unidade
                    where tab-unidade.un = tt-item.un no-lock no-error.
                if  avail tab-unidade then 
                    assign tt-un.desc-un-interno = tab-unidade.descricao.
            end.
        end.
    end.

    if  not can-find (first tt-un) then 
        return "NOK":U.
    else do:

        if  i-traducao > 1 then do:

            find first tt-un no-error.

            run getProcessoImportacao (output table tt-processo).

            find first tt-processo no-error.
            if  avail tt-processo  then do:

                find trad-tab-unidade
                    where trad-tab-unidade.un         = cotacao-item.un
                    and   trad-tab-unidade.cod-idioma = tt-processo.cod-idioma no-lock no-error.
                if  avail trad-tab-unidade then 
                    assign tt-un.desc-un-fornec = trad-tab-unidade.tr-descricao.

                find trad-tab-unidade
                    where trad-tab-unidade.un         = item.un
                    and   trad-tab-unidade.cod-idioma = tt-processo.cod-idioma no-lock no-error.
                if  avail trad-tab-unidade then 
                    assign tt-un.desc-un-interno = trad-tab-unidade.tr-descricao.
            end.
        end.
    end.

end procedure.

procedure getEmbalag:
    define output parameter table for tt-embalag.

    empty temp-table tt-embalag.

    if  r-ordem <> ? then do:

        run getItemFornec (output table tt-item-fornec).

        find tt-item-fornec no-error.
        if  avail tt-item-fornec then do:

            find embalag
                where embalag.embalagem = item-fornec.cod-embal no-lock no-error.
            if  avail embalag
            and not can-find (first tt-embalag
                              where tt-embalag.embalagem = embalag.embalagem) then do:

                create tt-embalag.
                buffer-copy embalag to tt-embalag.
            end.
        end.
    end.

    if  not can-find (first tt-embalag) then
        return "NOK":U.
    else do:

        if  i-traducao > 1 then do:

            run getProcessoImportacao (output table tt-processo).

            find first tt-processo no-error.
            if  avail tt-processo then do:

                find trad-embalag
                    where trad-embalag.embalagem  = embalag.embalagem 
                    and   trad-embalag.cod-idioma = tt-processo.cod-idioma no-lock no-error.
                if  avail trad-embalag then 
                    assign tt-embalag.sigla-emb = trad-embalag.tr-sigla-emb
                           tt-embalag.descricao = trad-embalag.tr-descricao.
            end.
        end.
    end.

end procedure.

procedure getCalculosOrdemCompra:
    define output parameter table for tt-calculos-ordem.

    define variable de-tot-quantidade  like prazo-compra.quantidade no-undo.
    define variable de-tot-qtd-do-forn like prazo-compra.quantidade no-undo.
    define variable de-tot-peso-bruto  like item.peso-bruto         no-undo.
    define variable de-peso-bruto      like item.peso-bruto         no-undo.
    define variable de-volume          like item.volume             no-undo.
    define variable de-tot-volume      like item.volume             no-undo.

    if  not valid-handle(h-boin356ab) THEN DO:
        run inbo/boin356ab.p persistent set h-boin356ab.
    END.

    IF NOT VALID-HANDLE(h-bodi425) THEN DO:
        RUN dibo/bodi425.p   PERSISTENT SET h-bodi425.
    END.

    empty temp-table tt-calculos-ordem.

    if  r-ordem <> ? then do:

        run getOrdensCompra (output table tt-ordens).

        find first tt-ordens no-error.
        if  avail tt-ordens then do:

            create tt-calculos-ordem.
            assign tt-calculos-ordem.numero-ordem = tt-ordens.numero-ordem.

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = tt-ordens-embarque.numero-ordem NO-LOCK NO-ERROR.

            for each prazo-compra
                fields (quantidade qtd-do-forn quant-saldo it-codigo)
                where prazo-compra.numero-ordem = tt-ordens.numero-ordem 
                and   prazo-compra.situacao    <> 4
                and   prazo-compra.situacao    <> 6 no-lock:

                IF VALID-HANDLE(h-bodi425) AND AVAIL ordem-compra THEN
                    RUN piRetornaQtdeEmbalagem IN h-bodi425(INPUT prazo-compra.quant-saldo, 
                                                            INPUT prazo-compra.it-codigo, 
                                                            INPUT ordem-compra.cod-emitente,
                                                            OUTPUT d-qtd-embal).

                run retornaPesoTotal in h-boin356ab (input rowid(prazo-compra),
                                                     input prazo-compra.quantidade,
                                                     INPUT d-qtd-embal,
                                                     output de-peso-bruto).

                run retornaVolumeTotal in h-boin356ab (input rowid(prazo-compra),
                                                       input prazo-compra.quantidade,
                                                       output de-volume).

                assign de-tot-peso-bruto  = de-tot-peso-bruto  + de-peso-bruto
                       de-tot-volume      = de-tot-volume      + de-volume
                       de-tot-quantidade  = de-tot-quantidade  + prazo-compra.quantidade
                       de-tot-qtd-do-forn = de-tot-qtd-do-forn + prazo-compra.qtd-do-forn.
            end.

            assign tt-calculos-ordem.peso-bruto-total = de-tot-peso-bruto
                   tt-calculos-ordem.ocupacao-total   = de-tot-volume.

            run getItem (output table tt-item).

            find first tt-item no-error.
            if  avail tt-item then 
                assign tt-calculos-ordem.peso-liquido-total = de-tot-quantidade * tt-item.peso-liquido.

            run getCotacaoItem (output table tt-cotacao-item).

            find first tt-cotacao-item no-error.
            if  avail tt-cotacao-item then
                assign tt-calculos-ordem.preco-fornec-liq = (tt-cotacao-item.pre-unit-for * 100)
                                                          / (100 + tt-cotacao-item.aliquota-ipi).

            assign tt-calculos-ordem.preco-interno-liq = (tt-cotacao-item.preco-unit * 100)
                                                       / (100 + tt-cotacao-item.aliquota-ipi).

            assign tt-calculos-ordem.preco-fornec-bru        = (tt-calculos-ordem.preco-fornec-liq * 100)
                                                             / (100 - tt-cotacao-item.perc-descto)
                   tt-calculos-ordem.preco-interno-bru       = (tt-calculos-ordem.preco-interno-liq * 100)
                                                             / (100 - tt-cotacao-item.perc-descto)
                   tt-calculos-ordem.preco-fornec-liq-total  = (tt-calculos-ordem.preco-fornec-liq  * de-tot-qtd-do-forn)
                   tt-calculos-ordem.preco-fornec-bru-total  = (tt-calculos-ordem.preco-fornec-bru  * de-tot-qtd-do-forn)
                   tt-calculos-ordem.preco-interno-liq-total = (tt-calculos-ordem.preco-interno-liq * de-tot-quantidade)
                   tt-calculos-ordem.preco-interno-bru-total = (tt-calculos-ordem.preco-interno-bru * de-tot-quantidade).
        end.
    end.

    if  valid-handle (h-boin356ab) then do:
        delete procedure h-boin356ab.
        assign h-boin356ab = ?.
    end.

    if  valid-handle (h-bodi425) then do:
        delete procedure h-bodi425.
        assign h-bodi425 = ?.
    end.

    ASSIGN d-qtd-embal = 0.

end procedure.

procedure getCalculosPrazoCompra:
    define output parameter table for tt-calculos-parcela.

    define variable h-boin356ab           as handle               no-undo.
    define variable de-peso-bruto         like item.peso-bruto    no-undo.
    define variable de-preco-interno-liq  like cotacao-item.preco-unit no-undo.
    define variable de-preco-fornec-liq   like cotacao-item.preco-unit no-undo.
    define variable de-volume             like item.volume        no-undo.

    if  not valid-handle (h-boin356ab) then
        run inbo/boin356ab.p persistent set h-boin356ab.

    IF NOT VALID-HANDLE(h-bodi425) THEN 
    RUN dibo/bodi425.p   PERSISTENT SET h-bodi425.

    empty temp-table tt-calculos-parcela.

    if  r-prazo-compra <> ? then do:

        run getPrazoCompra (output table tt-parcelas).

        find first tt-parcelas no-error.
        if  avail tt-parcelas then do:

            create tt-calculos-parcela.
            assign tt-calculos-parcela.numero-ordem = tt-parcelas.numero-ordem
                   tt-calculos-parcela.parcela      = tt-parcelas.parcela.

            run getItem (output table tt-item).

            find first tt-item no-error.
            if  avail tt-item then
                assign tt-calculos-parcela.peso-liquido-total = (tt-parcelas.quantidade * tt-item.peso-liquido).

            FIND FIRST ordem-compra
                 WHERE ordem-compra.numero-ordem = tt-parcelas.numero-ordem NO-LOCK NO-ERROR.

            IF VALID-HANDLE(h-bodi425) AND AVAIL ordem-compra THEN
                RUN piRetornaQtdeEmbalagem IN h-bodi425(INPUT prazo-compra.quant-saldo, 
                                                        INPUT prazo-compra.it-codigo, 
                                                        INPUT ordem-compra.cod-emitente,
                                                        OUTPUT d-qtd-embal).

            run retornaPesoTotal in h-boin356ab (input  r-prazo-compra,
                                                 input  tt-parcelas.quantidade,
                                                 INPUT  d-qtd-embal,
                                                 output de-peso-bruto).

            run retornaVolumeTotal in h-boin356ab (input r-prazo-compra,
                                                   input tt-parcelas.quantidade,
                                                   output de-volume).

            assign tt-calculos-parcela.peso-bruto-total = de-peso-bruto
                   tt-calculos-parcela.ocupacao-total   = de-volume.

            for first ordem-compra fields (cod-emitente perc-descto)
                where ordem-compra.numero-ordem = tt-parcelas.numero-ordem no-lock: end.
            if  avail ordem-compra then do:

                find first item 
                    where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
                if  avail item then
                    assign tt-calculos-parcela.peso-liquido-total = (tt-parcelas.quantidade * item.peso-liquido).
                
                for first cotacao-item fields (pre-unit-for preco-unit aliquota-ipi perc-descto)
                    where cotacao-item.numero-ordem = tt-parcelas.numero-ordem
                    and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                    and   cotacao-item.cot-aprovada no-lock: end. 
                if  avail cotacao-item then do:

                    assign de-preco-fornec-liq = (cotacao-item.pre-unit-for * 100)
                                                 / (100 + cotacao-item.aliquota-ipi).

                    assign de-preco-interno-liq = (cotacao-item.preco-unit * 100)
                                                / (100 + cotacao-item.aliquota-ipi).


                    assign tt-calculos-parcela.preco-fornec-liq-total  = de-preco-fornec-liq * tt-parcelas.qtd-do-forn
                           tt-calculos-parcela.preco-fornec-bru-total  = ( (de-preco-fornec-liq * 100)
                                                                         / (100 - cotacao-item.perc-descto)) * tt-parcelas.qtd-do-forn
                           tt-calculos-parcela.preco-interno-liq-total = de-preco-interno-liq * tt-parcelas.quantidade
                           tt-calculos-parcela.preco-interno-bru-total = ( (de-preco-interno-liq * 100)
                                                                         / (100 - cotacao-item.perc-descto)) * tt-parcelas.quantidade.
                end.
            end.
        end.
    end.

    if  valid-handle (h-boin356ab) then do:
        delete procedure h-boin356ab.
        assign h-boin356ab = ?.
    end.

    if  valid-handle (h-bodi425) then do:
        delete procedure h-bodi425.
        assign h-bodi425 = ?.
    end.

    ASSIGN d-qtd-embal = 0.

end procedure.

procedure getCotacaoItemCex:
    define output parameter table for tt-cotacao-item-cex.

    empty temp-table tt-cotacao-item-cex.

    if  r-cotacao-item-cex <> ? then do:

        find cotacao-item-cex
            where rowid(cotacao-item-cex) = r-cotacao-item-cex no-lock no-error.
        if  avail cotacao-item-cex 
        and not can-find (first tt-cotacao-item-cex
                          where tt-cotacao-item-cex.numero-ordem      = cotacao-item-cex.numero-ordem     
                          and   tt-cotacao-item-cex.cod-emitente      = cotacao-item-cex.cod-emitente     
                          and   tt-cotacao-item-cex.it-codigo         = cotacao-item-cex.it-codigo        
                          and   tt-cotacao-item-cex.seq-cotac         = cotacao-item-cex.seq-cotac        
                          and   tt-cotacao-item-cex.data-cotacao      = cotacao-item-cex.data-cotacao     
                          and   tt-cotacao-item-cex.mapa-cotacao      = cotacao-item-cex.mapa-cotacao     
                          and   tt-cotacao-item-cex.cod-incoterm      = cotacao-item-cex.cod-incoterm     
                          and   tt-cotacao-item-cex.cod-itiner        = cotacao-item-cex.cod-itiner       
                          and   tt-cotacao-item-cex.sequencia         = cotacao-item-cex.sequencia        
                          and   tt-cotacao-item-cex.cod-emitente-desp = cotacao-item-cex.cod-emitente-desp
                          and   tt-cotacao-item-cex.cod-desp          = cotacao-item-cex.cod-desp) then do:    

            create tt-cotacao-item-cex.
            buffer-copy cotacao-item-cex to tt-cotacao-item-cex.
        end.
    end.

    if  not can-find (first tt-cotacao-item-cex) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getMoeda:
    define output parameter table for tt-moeda.

    empty temp-table tt-moeda.

    if  r-ordem <> ? then do:

        run getOrdensCompra (output table tt-ordens).

        find first tt-ordens no-error.
        if  avail tt-ordens then do:

            find moeda
                where moeda.mo-codigo = tt-ordens.mo-codigo no-lock no-error.
            if  avail moeda
            and not can-find (first tt-moeda 
                              where tt-moeda.mo-codigo = moeda.mo-codigo) then do:

                create tt-moeda.
                buffer-copy moeda to tt-moeda.
            end.
        end.
    end.
    else 
        if  r-cotacao-item-cex <> ? then do:

            run getCotacaoItemCex (output table tt-cotacao-item-cex).

            find first tt-cotacao-item-cex no-error.
            if  avail tt-cotacao-item-cex then do:

                find moeda
                    where moeda.mo-codigo = tt-cotacao-item-cex.mo-codigo no-lock no-error.
                if  avail moeda
                and not can-find (first tt-moeda
                                  where tt-moeda.mo-codigo = moeda.mo-codigo) then do:

                    create tt-moeda.
                    buffer-copy moeda to tt-moeda.
                end.
            end.
        end.
    else do:
        if r-desp-embarque <> ? then do:

            run getDespEmbarque (output table tt-despesa-emb).
        
            find first tt-despesa-emb no-error.
            if  avail tt-despesa-emb then do:
        
                find moeda
                where moeda.mo-codigo = tt-despesa-emb.mo-codigo no-lock no-error.
                if  avail moeda
                and not can-find (first tt-moeda 
                                  where tt-moeda.mo-codigo = moeda.mo-codigo) then do:
    
                    create tt-moeda.
                    buffer-copy moeda to tt-moeda.
                end.                
            end.
        end.
    end.

    if  not can-find (first tt-moeda) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getEmitenteDesp:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-cotacao-item-cex <> ? then do:

        run getCotacaoItemCex (output table tt-cotacao-item-cex).

        find first tt-cotacao-item-cex no-error.
        if  avail tt-cotacao-item-cex then do:

            find emitente
                where emitente.cod-emitente = tt-cotacao-item-cex.cod-emitente-desp no-lock no-error.
            if  avail emitente 
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:
    
                create tt-emitente.

                if  tt-cotacao-item-cex.cod-emitente-desp > 0 then do:

                    buffer-copy emitente to tt-emitente.
        
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.
    else do:
        if r-desp-embarque <> ? then do:

            run getDespEmbarque (output table tt-despesa-emb).

            find first tt-despesa-emb no-error.
            if  avail tt-despesa-emb then do:

                find emitente
                    where emitente.cod-emitente = tt-despesa-emb.cod-emitente-desp no-lock no-error.
                if  avail emitente 
                and not can-find (first tt-emitente
                                  where tt-emitente.cod-emitente = emitente.cod-emitente) then do:
        
                    create tt-emitente.
                    buffer-copy emitente to tt-emitente.
        
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.
    if  not can-find (first tt-emitente) then
        return "NOK":U.
    ELSE
        RETURN "OK".
end procedure.
procedure GetDespEmbarque:
    define output parameter table for tt-despesa-emb.

    empty temp-table tt-despesa-emb.

    if  r-desp-embarque <> ? then do:

       find first desp-embarque
            where rowid(desp-embarque) = r-desp-embarque no-lock no-error.
       if  avail desp-embarque then do:

           create tt-despesa-emb.
           buffer-copy desp-embarque to tt-despesa-emb.
       end.
    end.
    else do:

        run GetEmbarqueImportacao (output table tt-embarque).

        for each tt-embarque:

            for each desp-embarque 
               where desp-embarque.cod-estabel = tt-embarque.cod-estabel
               and   desp-embarque.embarque    = tt-embarque.embarque no-lock:

                create tt-despesa-emb.
                buffer-copy desp-embarque to tt-despesa-emb.
            end.
        end.
    end.

    if  not can-find (first tt-despesa-emb) then
        return "NOK":U.

    return "OK".
end procedure.

procedure getDespImp:
    define output parameter table for tt-desp.

    empty temp-table tt-desp.

    if  r-cotacao-item-cex <> ? then do:

        run getCotacaoItemCex (output table tt-cotacao-item-cex).

        find first tt-cotacao-item-cex no-error.
        if  avail tt-cotacao-item-cex then do:

            find desp-imp
                where desp-imp.cod-desp = tt-cotacao-item-cex.cod-desp no-lock no-error.
            if  avail desp-imp
            and not can-find(first tt-desp
                             where tt-desp.cod-desp = desp-imp.cod-desp) then do:

                create tt-desp.
                buffer-copy desp-imp to tt-desp.
            end.
        end.
    end.
    else do:
        if r-desp-embarque <> ? then do:

            run getDespEmbarque (output table tt-despesa-emb).
        
            find first tt-despesa-emb no-error.
            if  avail tt-despesa-emb then do:
        
                find desp-imp
                where desp-imp.cod-desp = tt-despesa-emb.cod-desp no-lock no-error.
                if  avail desp-imp
                and not can-find(first tt-desp
                                 where tt-desp.cod-desp = desp-imp.cod-desp) then do:
    
                    create tt-desp.
                    buffer-copy desp-imp to tt-desp.
                end.            
            end.
        end.
    end.

    if  not can-find (first tt-desp) then 
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getPrazoCompra:
    define output parameter table for tt-parcelas.

    empty temp-table tt-parcelas.

    if  r-prazo-compra <> ? then do:

        find prazo-compra
            where rowid(prazo-compra) = r-prazo-compra no-lock no-error.
        if  avail prazo-compra
        and not can-find (first tt-parcelas
                          where tt-parcelas.numero-ordem = prazo-compra.numero-ordem
                          and   tt-parcelas.parcela      = prazo-compra.parcela) then do:

            create tt-parcelas.
            buffer-copy prazo-compra to tt-parcelas.
        end.
    end.

    ELSE DO:
        IF r-ordem <> ? THEN DO:
            RUN getOrdensCompra (OUTPUT TABLE tt-ordens) .
            FOR EACH tt-ordens:
                FOR EACH prazo-compra 
                   WHERE prazo-compra.numero-ordem = tt-ordens.numero-ordem NO-LOCK:
                    IF not can-find (first tt-parcelas
                                     where tt-parcelas.numero-ordem = prazo-compra.numero-ordem
                                       and tt-parcelas.parcela      = prazo-compra.parcela) then do:
                        create tt-parcelas.
                        buffer-copy prazo-compra to tt-parcelas.
                    END.
                END.
            END.
        END.
    END.
    if  not can-find (first tt-parcelas) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getAssinaturas:
    define output parameter table for tt-assinaturas.

    define variable de-valor-ipi      as decimal format ">>>>>,>>>,>>9.99999":U no-undo.
    define variable de-val-orig       as decimal format ">>>>>,>>>,>>9.99999":U no-undo.
    define variable de-preco-unit     as decimal format ">>>>>,>>>,>>9.99999":U no-undo.
    define variable de-preco-tot-aux  as decimal format ">>>>>,>>>,>>9.99999":U no-undo. 
    define variable de-desc-total     as decimal format ">>>>>,>>>,>>9.99999":U no-undo. 
    define variable de-preco-total    as decimal format ">>>>>,>>>,>>9.99999":U no-undo. 
    define variable de-acumulado      as decimal format ">>>>>,>>>,>>9.99999":U no-undo. 
    define variable de-total-pedido   as decimal format ">>>>>,>>>,>>9.99999":U no-undo. 
    define variable de-preco-conv     as decimal format ">>>>>,>>>,>>9.99999":U no-undo. 

    find first param-compra no-lock no-error.
    if  avail param-compra then do:

        create tt-assinaturas.
        assign tt-assinaturas.nome-ass1  = param-compra.nome-ass[1]
               tt-assinaturas.cargo-ass1 = param-compra.cargo-ass[1].

        run getPedidoCompra (output table tt-pedido).

        find first tt-pedido no-error.
        if  avail tt-pedido then do:

            for each  ordem-compra fields (numero-ordem perc-descto taxa-financ preco-fornec cod-emitente)
                where ordem-compra.num-pedido = tt-pedido.num-pedido
                and   ordem-compra.situacao  <> 4
                and   ordem-compra.situacao  <> 6 no-lock:

                find first cotacao-item
                    where  cotacao-item.numero-ordem = ordem-compra.numero-ordem
                    and    cotacao-item.cod-emitente = ordem-compra.cod-emitente
                    and    cotacao-item.cot-aprovada no-lock no-error.
                if  not avail cotacao-item then
                    next.

                /* preco bruto*/                                    
                if  param-compra.ipi-sobre-preco <> 1 then
                    assign de-valor-ipi = (cotacao-item.pre-unit-for * cotacao-item.aliquota-ipi)
                                        / (100 + cotacao-item.aliquota-ipi).
                else do:
                    if  cotacao-item.perc-descto > 0 then
                        assign de-val-orig = (cotacao-item.pre-unit-for * 100)
                                           / (100 - cotacao-item.perc-descto).
                    else
                        assign de-val-orig = cotacao-item.pre-unit-for.

                    assign de-valor-ipi = (de-val-orig * cotacao-item.aliquota-ipi)
                                        / (100 + cotacao-item.aliquota-ipi).
                end.

                assign de-preco-unit = cotacao-item.pre-unit-for - de-valor-ipi
                       de-preco-conv = ordem-compra.preco-fornec.

                for each  prazo-compra fields (qtd-sal-forn)
                    where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                    and   prazo-compra.situacao    <> 4
                    and   prazo-compra.situacao    <> 6 no-lock:

                    assign de-preco-tot-aux = de-preco-conv * prazo-compra.qtd-sal-forn.
                           de-desc-total    = de-preco-tot-aux *
                                              ordem-compra.perc-descto / 100 .            
                    if  ordem-compra.taxa-financ then
                        assign de-preco-total = de-preco-tot-aux - de-desc-total
                               de-acumulado   = de-acumulado + de-preco-total.
                    else
                       assign de-preco-total = de-preco-unit * prazo-compra.qtd-sal-forn
                              de-acumulado   = de-acumulado + de-preco-total.
                end.      

                assign de-total-pedido = de-total-pedido + de-acumulado.       
            end.
        end.

        if  de-total-pedido > param-compra.limite[1] then
            assign tt-assinaturas.nome-ass2  = param-compra.nome-ass[2]
                   tt-assinaturas.cargo-ass2 = param-compra.cargo-ass[2].

        if  de-total-pedido > param-compra.limite[2] then
            assign tt-assinaturas.nome-ass3  = param-compra.nome-ass[3]
                   tt-assinaturas.cargo-ass3 = param-compra.cargo-ass[3].
    end.

    if  not can-find (first tt-assinaturas) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getEmitenteEntrega:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getPedidoCompra (output table tt-pedido).

        find first tt-pedido no-error.
        if  avail tt-pedido then do:

            find emitente
                where emitente.cod-emitente = tt-pedido.cod-emit-terc no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:
    
                create tt-emitente.

                if  tt-pedido.cod-emit-terc > 0 then do:

                    buffer-copy emitente to tt-emitente.
        
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getEstabelecimentoEntrega:
    define output parameter table for tt-estabelec.

    empty temp-table tt-estabelec.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getPedidoCompra (output table tt-pedido).

        find first tt-pedido no-lock no-error.
        if  avail tt-pedido  then do:

            find estabelec
                where estabelec.cod-estabel = tt-pedido.end-entrega no-lock no-error.
            if  avail estabelec
            and not can-find (first tt-estabelec
                              where tt-estabelec.cod-estabel = estabelec.cod-estabel) then do:

                create tt-estabelec.
                buffer-copy estabelec to tt-estabelec.
            end.
        end.
    end.

    if  not can-find (first tt-estabelec) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getEmitenteEstabEntrega:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getEstabelecimentoEntrega (output table tt-estabelec).

        find first tt-estabelec no-error.
        if  avail tt-estabelec then do:

            find emitente
                where emitente.cod-emitente = tt-estabelec.cod-emitente no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:
    
                create tt-emitente.

                if  tt-estabelec.cod-emitente > 0 then do:

                    buffer-copy emitente to tt-emitente.
        
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getEstabelecimentoCobranca:
    define output parameter table for tt-estabelec.

    empty temp-table tt-estabelec.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getPedidoCompra (output table tt-pedido).

        find first tt-pedido no-lock no-error.
        if  avail tt-pedido  then do:

            find estabelec
                where estabelec.cod-estabel = tt-pedido.end-cobranca no-lock no-error.
            if  avail estabelec
            and not can-find (first tt-estabelec
                              where tt-estabelec.cod-estabel = estabelec.cod-estabel) then do:

                create tt-estabelec.
                buffer-copy estabelec to tt-estabelec.
            end.
        end.
    end.

    if  not can-find (first tt-estabelec) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getEmitenteEstabCobr:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getEstabelecimentoCobranca (output table tt-estabelec).

        find first tt-estabelec no-error.
        if  avail tt-estabelec then do:
        
            find emitente
                where emitente.cod-emitente = tt-estabelec.cod-emitente no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-estabelec.cod-emitente > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getEstabelecimentoGestor:
    define output parameter table for tt-estabelec.

    empty temp-table tt-estabelec.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getPedidoCompra (output table tt-pedido).

        find first tt-pedido no-lock no-error.
        if  avail tt-pedido  then do:

            find estabelec
                where estabelec.cod-estabel = tt-pedido.cod-estab-gestor no-lock no-error.
            if  avail estabelec
            and not can-find (first tt-estabelec
                              where tt-estabelec.cod-estabel = estabelec.cod-estabel) then do:

                create tt-estabelec.
                buffer-copy estabelec to tt-estabelec.
            end.
        end.
    end.

    if  not can-find (first tt-estabelec) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getEmitenteEstabGest:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getEstabelecimentoGestor (output table tt-estabelec).

        find first tt-estabelec no-error.
        if  avail tt-estabelec then do:
                
            find emitente
                where emitente.cod-emitente = tt-estabelec.cod-emitente no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-estabelec.cod-emitente > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getMensagem:
    define output parameter table for tt-mensagens.

    empty temp-table tt-mensagens.

    if  r-processo <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:

            find mensagem
                where mensagem.cod-mensagem = tt-processo.cod-mensagem no-lock no-error.
            if  avail mensagem
            and not can-find(first tt-mensagens
                             where tt-mensagens.cod-mensagem = mensagem.cod-mensagem) then do:

                create tt-mensagens.
                buffer-copy mensagem to tt-mensagens.
            end.
        end.
    end.
    else
        if  r-pedido <> ? then do:

            run getPedidoCompra (output table tt-pedido).

            find first tt-pedido no-error.
            if  avail tt-pedido then do:

                find mensagem
                    where mensagem.cod-mensagem = tt-pedido.cod-mensagem no-lock no-error.
                if  avail mensagem
                and not can-find(first tt-mensagens
                                 where tt-mensagens.cod-mensagem = mensagem.cod-mensagem) then do:

                    create tt-mensagens.
                    buffer-copy mensagem to tt-mensagens.
                end.
            end.
        end.

    if  not can-find (first tt-mensagens) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getEmitenteImportador:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ?
    or  r-pedido   <> ?
    or  r-embarque <> ? then do:

        run getImportador (output table tt-estabelec).

        find first tt-estabelec no-error.
        if  avail tt-estabelec then do:
        
            find emitente
                where emitente.cod-emitente = tt-estabelec.cod-emitente no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-estabelec.cod-emitente > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getIncoterm:
    define output parameter table for tt-inco-cx.

    empty temp-table tt-inco-cx.

    if  r-processo <> ? 
    or  r-pedido   <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:

            find first ordem-compra 
                where ordem-compra.num-pedido = tt-processo.num-pedido no-lock no-error.
            if  avail ordem-compra then do:

                find first cotacao-item
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                    and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                    and   cotacao-item.cot-aprovada no-lock no-error.
                if  avail cotacao-item then do:

                    find inco-cx 
                        where inco-cx.cod-incoterm = substr(cotacao-item.char-1,21,20) no-lock no-error.
                    if  avail inco-cx
                    and not can-find (first tt-inco-cx
                                      where tt-inco-cx.cod-incoterm = inco-cx.cod-incoterm) then do:

                        create tt-inco-cx.
                        buffer-copy inco-cx to tt-inco-cx.
                    end.
                end.
            end.
        end.
    end.
    else 
        if  r-embarque <> ? then do:

            run getEmbarqueImportacao (output table tt-embarque).

            find first tt-embarque no-error.
            if  avail tt-embarque then do:

                find inco-cx 
                    where inco-cx.cod-incoterm = tt-embarque.cod-incoterm no-lock no-error.
                if  avail inco-cx
                and not can-find (first tt-inco-cx
                                  where tt-inco-cx.cod-incoterm = inco-cx.cod-incoterm) then do:

                    create tt-inco-cx.
                    buffer-copy inco-cx to tt-inco-cx.
                end.
            end.
        end.

    if  not can-find (first tt-inco-cx) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getItinerario:
    define output parameter table for tt-itinerario.

    empty temp-table tt-itinerario.

    if  r-processo <> ? 
    or  r-pedido   <> ?
    or  r-embarque <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:

            find itinerario
                where itinerario.cod-itiner = tt-processo.cod-itiner no-lock no-error.
            if  avail itinerario 
            and not can-find(first tt-itinerario
                             where tt-itinerario.cod-itiner = itinerario.cod-itiner) then do:

                create tt-itinerario.
                buffer-copy itinerario to tt-itinerario.
            end.
        end.
    end.

    if  not can-find (first tt-itinerario) then
        return "NOK":U.
        
    return "OK".
end procedure.

procedure getTransportador:
    define output parameter table for tt-transporte.

    empty temp-table tt-transporte.

    if  r-processo <> ? 
    or  r-pedido   <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:
        
            find transporte
                where transporte.cod-transp = tt-processo.cod-transportador no-lock no-error.
            if  avail transporte
            and not can-find (first tt-transporte
                              where tt-transporte.cod-transp = transporte.cod-transp) then do:

                create tt-transporte.

                if  tt-processo.cod-transportador > 0 then 
                    buffer-copy transporte to tt-transporte.
                else
                    assign tt-transporte.pais = "".
            end.
        end.
    end.
    else 
        if r-embarque <> ? then do:

            run getEmbarqueImportacao (output table tt-embarque).

            find first tt-embarque no-error.
            if  avail tt-embarque then do: 
            
                find transporte
                    where transporte.cod-transp = tt-embarque.cod-transportador no-lock no-error.
                if  avail transporte
                and not can-find (first tt-transporte
                                  where tt-transporte.cod-transp = transporte.cod-transp) then do:

                    create tt-transporte.

                    if  tt-embarque.cod-transportador > 0 then
                        buffer-copy transporte to tt-transporte.
                    else
                        assign tt-transporte.pais = "".
                    
                end.
            end.
        end.

    find first tt-transporte no-error.
    if  not avail tt-transporte then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getDespachante:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ? 
    or  r-pedido   <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:
                
            find emitente
                where emitente.cod-emitente = tt-processo.cod-despachante no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-processo.cod-despachante > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.
    else 
        if r-embarque <> ? then do:

            run getEmbarqueImportacao (output table tt-embarque).

            find first tt-embarque no-error.
            if  avail tt-embarque then do:
            
                find emitente
                    where emitente.cod-emitente = tt-embarque.cod-despachante no-lock no-error.
                if  avail emitente
                and not can-find (first tt-emitente
                                  where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                    create tt-emitente.

                    if  tt-embarque.cod-despachante > 0 then do:

                        buffer-copy emitente to tt-emitente.
    
                        for first emitente-cex fields (cod-aba)
                            where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                        if  avail emitente-cex then
                            assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                    end.
                end.
            end.
        end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getAgenteCargas:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ?
    or  r-pedido   <> ? 
    OR  r-embarque <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:
        
            find emitente
                where emitente.cod-emitente = tt-processo.cod-agente no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-processo.cod-agente > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getDespachExterno:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ? 
    or  r-pedido   <> ?    then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:
                
            find emitente
                where emitente.cod-emitente = tt-processo.cdn-despa-exter-import no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-processo.cdn-despa-exter-import > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.
    else 
        if r-embarque <> ? then do:

            run getEmbarqueImportacao (output table tt-embarque).

            find first tt-embarque no-error.
            if  avail tt-embarque then do:
            
                find emitente
                    where emitente.cod-emitente = tt-embarque.cdn-despa-exter-import no-lock no-error.
                if  avail emitente
                and not can-find (first tt-emitente
                                  where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                    create tt-emitente.

                    if  tt-embarque.cdn-despa-exter-import > 0 then do:

                        buffer-copy emitente to tt-emitente.
    
                        for first emitente-cex fields (cod-aba)
                            where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                        if  avail emitente-cex then
                            assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                    end.
                end.
            end.
        end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getSeguradora:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ?
    or  r-pedido   <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:
        
            find emitente
                where emitente.cod-emitente = tt-processo.cdn-segurad-import no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-processo.cdn-segurad-import > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex fields (cod-aba)
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.
    else 
        if r-embarque <> ? then do:

            run getEmbarqueImportacao (output table tt-embarque).

            find first tt-embarque no-error.
            if  avail tt-embarque then do:
            
                find emitente
                    where emitente.cod-emitente = tt-embarque.cdn-segurad-import no-lock no-error.
                if  avail emitente
                and not can-find (first tt-emitente
                                  where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                    create tt-emitente.

                    if  tt-embarque.cdn-segurad-import > 0 then do:

                        buffer-copy emitente to tt-emitente.
    
                        for first emitente-cex fields (cod-aba)
                            where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                        if  avail emitente-cex then
                            assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                    end.
                end.
            end.
        end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getCorretorImport:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ? 
    or  r-pedido   <> ? then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:
        
            find emitente
                where emitente.cod-emitente = tt-processo.cdn-corretor-import no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-processo.cdn-corretor-import > 0 then do:

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.
    else 
        if r-embarque <> ? then do:

            run getEmbarqueImportacao (output table tt-embarque).

            find first tt-embarque no-error.
            if  avail tt-embarque then do:
                        
                find emitente
                    where emitente.cod-emitente = tt-embarque.cdn-corretor-import no-lock no-error.
                if  avail emitente
                and not can-find (first tt-emitente
                                  where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                    create tt-emitente.

                    if  tt-embarque.cdn-corretor-import > 0 then do:

                        buffer-copy emitente to tt-emitente.
    
                        for first emitente-cex
                            where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                        if  avail emitente-cex then
                            assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                    end.
                end.
            end.
        end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getPontosControleProcesso:
    define output parameter table for tt-pontos-controle-pedido.

    define variable i-dias           as integer                     no-undo.
    define variable i-pto-emb        as integer                     no-undo.

    empty temp-table tt-pontos-controle-pedido.

    if  r-processo <> ?
    or  r-pedido <> ? then do:
        /* 
        ** C lculo data prevista de embarque do material. Carrega descricao embarque e desembarque 
        */

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:

            create tt-pontos-controle-pedido.

            assign i-pto-emb = 0.

            find itinerario 
                where itinerario.cod-itiner = tt-processo.cod-itiner no-lock no-error.
            if  avail itinerario then do:

                assign i-dias    = 0
                       i-pto-emb = itinerario.pto-embarque.

                for each pto-itiner 
                    where pto-itiner.cod-itiner = itinerario.cod-itiner no-lock:

                    assign i-dias = i-dias + pto-itiner.nr-dias.

                    if  pto-itiner.cod-pto-contr = itinerario.pto-embarque then
                        leave.
                end.    

                find pto-contr
                    where pto-contr.cod-pto-contr = itinerario.pto-embarque no-lock no-error.
                if  avail pto-contr then
                    assign tt-pontos-controle-pedido.desc-pto-embarque = pto-contr.descricao
                           tt-pontos-controle-pedido.pto-embarque      = pto-contr.cod-pto-contr.

                find pto-contr
                    where pto-contr.cod-pto-contr = itinerario.pto-desembarque no-lock no-error.
                if  avail pto-contr then 
                    assign tt-pontos-controle-pedido.desc-pto-desembarque = pto-contr.descricao         
                           tt-pontos-controle-pedido.pto-desembarque      = pto-contr.cod-pto-contr.
            end.

            find first param-imp 
                where param-imp.cod-estabel = tt-processo.cod-estabel no-lock no-error.
            if  avail param-imp then do:

                if  param-imp.hist-processo then do:

                    find historico-proc-imp 
                        where historico-proc-imp.cod-estabel   = tt-processo.cod-estabel 
                        and   historico-proc-imp.nr-proc-imp   = tt-processo.nr-proc-imp 
                        and   historico-proc-imp.cod-itiner    = tt-processo.cod-itiner  
                        and   historico-proc-imp.cod-pto-contr = i-pto-emb no-lock no-error.
                    if  avail historico-proc-imp then do:

                        if  historico-proc-imp.dt-efetiva <> ? then 
                            assign tt-pontos-controle-pedido.data-prev-embarque = historico-proc-imp.dt-efetiva.
                        else
                             assign tt-pontos-controle-pedido.data-prev-embarque = historico-proc-imp.dt-ult-previsao.
                    end.
                end.           
                else 
                    assign tt-pontos-controle-pedido.data-prev-embarque = processo-imp.dt-emissao + i-dias.
            end.
        end.
    end.

end procedure.

procedure GetAgenciaBanco:
    define output parameter table for tt-agencia.

    empty temp-table tt-agencia.



    if  r-processo <> ?
    or  r-embarque <> ?
    or  r-pedido   <> ? then do:

        run getBanco (output table tt-banco).

        find first tt-banco no-error.
        if  avail tt-banco then do:

            find agencia
                where agencia.cod-banco = tt-banco.cod-banco
                and   agencia.agencia   = tt-banco.ag-padrao no-lock no-error.
            if  avail agencia
            and not can-find (first tt-agencia
                              where tt-agencia.cod-banco = agencia.cod-banco
                              and   tt-agencia.agencia   = agencia.agencia)  then do:

                create tt-agencia.
                buffer-copy agencia to tt-agencia.
            end.
        end.
    end.

    if  not can-find (first tt-agencia) then 
        return "NOK":U.

    return "OK".

end procedure.

procedure getEstabelecimentoFiscal:
    define output parameter table for tt-estabelec.

    empty temp-table tt-estabelec. 

    if  r-processo <> ? 
    or  r-pedido   <> ?    then do:

        run getProcessoImportacao (output table tt-processo).

        find first tt-processo no-error.
        if  avail tt-processo then do:

            find estabelec
                where estabelec.cod-estabel = tt-processo.estab-fisc no-lock no-error.
            if  avail estabelec
            and not can-find (first tt-estabelec
                              where tt-estabelec.cod-estabel = estabelec.cod-estabel) then do:

                create tt-estabelec.
                buffer-copy estabelec to tt-estabelec.
            end.
        end.
    end.

    if  not can-find (first tt-estabelec) then
        return "NOK":U.

    return "OK".

end procedure.

procedure getEmitenteEstabFis:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    if  r-processo <> ? 
    or  r-pedido   <> ?    then do:

        run getEstabelecimentoFiscal (output table tt-estabelec).

        find first tt-estabelec no-error.
        if  avail tt-estabelec then do:
                
            find emitente
                where emitente.cod-emitente = tt-estabelec.cod-emitente no-lock no-error.
            if  avail emitente
            and not can-find (first tt-emitente
                              where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

                create tt-emitente.

                if  tt-estabelec.cod-emitente > 0 then do: 

                    buffer-copy emitente to tt-emitente.
    
                    for first emitente-cex
                        where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                    if  avail emitente-cex then
                        assign tt-emitente.cod-aba = emitente-cex.cod-aba.
                end.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

procedure getConsignatario:
    define output parameter table for tt-emitente.

    empty temp-table tt-emitente.

    run getProcessoImportacao (output table tt-processo).

    find first tt-processo no-error.
    if  avail tt-processo then do:
        
        find emitente
            where emitente.cod-emitente = tt-processo.cod-consignatario no-lock no-error.
        if  avail emitente
        and not can-find (first tt-emitente
                          where tt-emitente.cod-emitente = emitente.cod-emitente) then do:

            create tt-emitente.

            if  tt-processo.cod-consignatario > 0 then do:

                buffer-copy emitente to tt-emitente.
    
                for first emitente-cex fields (cod-aba)
                    where emitente-cex.cod-emitente = emitente.cod-emitente no-lock: end.
                if  avail emitente-cex then
                    assign tt-emitente.cod-aba = emitente-cex.cod-aba.
            end.
        end.
    end.

    find first tt-emitente no-error.
    if  not avail tt-emitente then
        return "NOK":U.
    
    return "OK".
end procedure.

PROCEDURE getPontosControleItiner:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-emb-pto-contr.
    EMPTY TEMP-TABLE tt-emb-pto-contr.

    IF  r-embarque <> ? THEN DO:

        run getEmbarqueImportacao (output table tt-embarque).

        find first tt-embarque no-error.
        if  avail tt-embarque then do:
    
            FIND FIRST ordens-embarque
                WHERE  ordens-embarque.embarque = tt-embarque.embarque NO-LOCK NO-ERROR.
            IF  AVAIL ordens-embarque THEN DO:

                FIND FIRST processo-imp
                    WHERE  processo-imp.nr-proc-imp = ordens-embarque.nr-proc-imp NO-LOCK NO-ERROR.
                IF  AVAIL processo-imp THEN DO:
                
                    FIND FIRST itinerario
                        WHERE  itinerario.cod-itiner = processo-imp.cod-itiner NO-LOCK NO-ERROR.
                    IF  AVAIL itinerario THEN DO:
                
                        FOR EACH  historico-embarque 
                            WHERE historico-embarque.cod-estabel = tt-embarque.cod-estabel
                            AND   historico-embarque.embarque    = tt-embarque.embarque NO-LOCK:
                        
                            CREATE tt-emb-pto-contr.
                            ASSIGN tt-emb-pto-contr.pto-contr               = historico-embarque.cod-pto-contr
                                   tt-emb-pto-contr.data-prev-pto-contr     = historico-embarque.dt-previsao
                                   tt-emb-pto-contr.data-ult-prev-pto-contr = historico-embarque.dt-ult-previsao
                                   tt-emb-pto-contr.data-efet-pto-contr     = historico-embarque.dt-efetiva
                                   tt-emb-pto-contr.desc-pto-contr          = historico-embarque.descricao.
                            FIND FIRST pto-contr
                                WHERE  pto-contr.cod-pto-contr = tt-emb-pto-contr.pto-contr NO-LOCK NO-ERROR.
                            IF AVAIL pto-contr THEN
                                ASSIGN tt-emb-pto-contr.desc-pto-contr   = IF tt-emb-pto-contr.desc-pto-contr = "" THEN pto-contr.descricao ELSE tt-emb-pto-contr.desc-pto-contr
                                       tt-emb-pto-contr.unid-referencial = pto-contr.unid-referencial.
    
                            IF tt-embarque.cdn-pto-despch > 0 AND historico-embarque.cod-pto-contr = tt-embarque.cdn-pto-despch THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 1.
                            ELSE IF tt-embarque.cdn-pto-despch <= 0 AND historico-embarque.cod-pto-contr = itinerario.pto-despacho THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 1.
                            
                            ELSE IF tt-embarque.cdn-pto-embarq > 0 AND historico-embarque.cod-pto-contr = tt-embarque.cdn-pto-embarq THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 2.
                            ELSE IF tt-embarque.cdn-pto-embarq <= 0 AND historico-embarque.cod-pto-contr = itinerario.pto-embarque THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 2.
                            
                            ELSE IF tt-embarque.cdn-pto-desembar > 0 AND historico-embarque.cod-pto-contr = tt-embarque.cdn-pto-desembar THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 3.
                            ELSE IF tt-embarque.cdn-pto-desembar <= 0 AND historico-embarque.cod-pto-contr = itinerario.pto-desembarque THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 3.

                            ELSE IF historico-embarque.cod-pto-contr = INTEGER(TRIM(SUBSTRING(tt-embarque.char-1,81,5))) THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 4.
                            
                            ELSE IF tt-embarque.cdn-pto-chegad > 0 AND historico-embarque.cod-pto-contr = tt-embarque.cdn-pto-chegad THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 5.
                            ELSE IF tt-embarque.cdn-pto-chegad <= 0 AND historico-embarque.cod-pto-contr = itinerario.pto-chegada THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 5.
                        END.
                    END.    
                END.
            END.
        end.
    END.
    ELSE DO:
        IF r-processo <> ? THEN DO:
            FIND FIRST param-imp 
                WHERE  param-imp.cod-estabel   = tt-processo.cod-estabel 
                AND    param-imp.hist-processo = YES NO-LOCK NO-ERROR.
            IF AVAIL param-imp THEN DO:
                FIND FIRST itinerario
                    WHERE  itinerario.cod-itiner = tt-processo.cod-itiner NO-LOCK NO-ERROR.
                IF AVAIL itinerario THEN DO:
                    FOR EACH  historico-proc-imp
                        WHERE historico-proc-imp.cod-estabel = tt-processo.cod-estabel
                        AND   historico-proc-imp.nr-proc-imp = tt-processo.nr-proc-imp NO-LOCK:

                        CREATE tt-emb-pto-contr.
                        ASSIGN tt-emb-pto-contr.pto-contr               = historico-proc-imp.cod-pto-contr
                               tt-emb-pto-contr.data-prev-pto-contr     = historico-proc-imp.dt-previsao
                               tt-emb-pto-contr.data-ult-prev-pto-contr = historico-proc-imp.dt-ult-previsao
                               tt-emb-pto-contr.data-efet-pto-contr     = historico-proc-imp.dt-efetiva.
                        FIND FIRST pto-contr
                            WHERE  pto-contr.cod-pto-contr = tt-emb-pto-contr.pto-contr NO-LOCK NO-ERROR.
                        IF AVAIL pto-contr THEN
                            ASSIGN tt-emb-pto-contr.desc-pto-contr   = pto-contr.descricao
                                   tt-emb-pto-contr.unid-referencial = pto-contr.unid-referencial.

                        IF historico-proc-imp.cod-pto-contr = itinerario.pto-despacho THEN
                            ASSIGN tt-emb-pto-contr.tp-pto-contr = 1.
                        ELSE DO:
                            IF historico-proc-imp.cod-pto-contr = itinerario.pto-embarque THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 2.
                            ELSE DO:
                                IF historico-proc-imp.cod-pto-contr = itinerario.pto-desembarque THEN
                                    ASSIGN tt-emb-pto-contr.tp-pto-contr = 3.
                                ELSE DO:
                                    IF historico-proc-imp.cod-pto-contr = itinerario.int-1 THEN
                                        ASSIGN tt-emb-pto-contr.tp-pto-contr = 4.
                                    ELSE DO:
                                        IF historico-proc-imp.cod-pto-contr = itinerario.pto-chegada THEN
                                            ASSIGN tt-emb-pto-contr.tp-pto-contr = 5.
                                    END.
                                END.
                            END.
                        END.

                    END.    
                END.
            END.
            ELSE DO:
               FIND FIRST itinerario 
                   WHERE  itinerario.cod-itiner = tt-processo.cod-itiner NO-LOCK NO-ERROR.
               IF AVAIL itinerario THEN DO:     
                   FOR EACH   pto-itiner 
                       WHERE pto-itiner.cod-itiner = itinerario.cod-itiner NO-LOCK:

                        CREATE tt-emb-pto-contr.
                        ASSIGN tt-emb-pto-contr.pto-contr               = pto-itiner.cod-pto-contr
                               tt-emb-pto-contr.data-prev-pto-contr     = tt-processo.dt-emissao + pto-itiner.nr-dias
                               tt-emb-pto-contr.data-ult-prev-pto-contr = tt-emb-pto-contr.data-prev-pto-contr
                               tt-emb-pto-contr.data-efet-pto-contr     = ?.
                        FIND FIRST pto-contr
                            WHERE  pto-contr.cod-pto-contr = tt-emb-pto-contr.pto-contr NO-LOCK NO-ERROR.
                        IF AVAIL pto-contr THEN
                            ASSIGN tt-emb-pto-contr.desc-pto-contr   = pto-contr.descricao
                                   tt-emb-pto-contr.unid-referencial = pto-contr.unid-referencial.

                        IF pto-itiner.cod-pto-contr = itinerario.pto-despacho THEN
                            ASSIGN tt-emb-pto-contr.tp-pto-contr = 1.
                        ELSE DO:
                            IF pto-itiner.cod-pto-contr = itinerario.pto-embarque THEN
                                ASSIGN tt-emb-pto-contr.tp-pto-contr = 2.
                            ELSE DO:
                                IF pto-itiner.cod-pto-contr = itinerario.pto-desembarque THEN
                                    ASSIGN tt-emb-pto-contr.tp-pto-contr = 3.
                                ELSE DO:
                                    IF pto-itiner.cod-pto-contr = itinerario.int-1 THEN
                                        ASSIGN tt-emb-pto-contr.tp-pto-contr = 4.
                                    ELSE DO:
                                        IF pto-itiner.cod-pto-contr = itinerario.pto-chegada THEN
                                            ASSIGN tt-emb-pto-contr.tp-pto-contr = 5.
                                    END.
                                END.
                            END.
                        END.
                   END.
               END.

            END.    
        END.
    END.
END PROCEDURE.

PROCEDURE getTraducaoItemFornecedor:

    DEFINE INPUT  PARAMETER p-it-codigo AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-item AS CHAR NO-UNDO.


    RUN GetOrdensCompra (OUTPUT TABLE tt-ordens).


    find first tt-ordens no-error.
    if  avail tt-ordens then do:

        FIND FIRST usuar_mestre
             WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.

        FIND FIRST ITEM
             WHERE ITEM.it-codigo = p-it-codigo NO-LOCK NO-ERROR.
        IF  AVAIL ITEM 
        AND AVAIL usuar_mestre THEN DO:
        
            FIND FIRST traduc-item
                 WHERE traduc-item.it-codigo    = p-it-codigo
                   AND traduc-item.cod-idioma   = usuar_mestre.cod_idiom_orig
                   AND traduc-item.cod-emitente = ordem-compra.cod-emitente NO-LOCK  NO-ERROR.
            IF AVAIL traduc-item THEN  
                ASSIGN p-desc-item = traduc-item.tr-desc-item.
            ELSE
                ASSIGN p-desc-item = ITEM.desc-item.
        END.
    END.
    return "OK":U.

END PROCEDURE.
PROCEDURE getFabricantePedido:

    DEFINE INPUT PARAMETER p-cod-emitente AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-emitente.

    empty temp-table tt-emitente.

    FIND FIRST emitente WHERE emitente.cod-emitente = p-cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:

       FIND FIRST tt-emitente
             WHERE tt-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
       IF NOT AVAIL tt-emitente THEN DO:
           CREATE tt-emitente.
           BUFFER-COPY emitente TO tt-emitente.
           
           FIND FIRST emitente-cex 
                WHERE emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
           IF AVAIL emitente-cex THEN DO:
               
               ASSIGN tt-emitente.cod-itiner-exp                   = emitente-cex.cod-itiner-exp
                      tt-emitente.cod-idioma                       = emitente-cex.cod-idioma
                      tt-emitente.cod-aba                          = emitente-cex.cod-aba
                      tt-emitente.cod-repres                       = emitente-cex.cod-repres
                      tt-emitente.cod-incoterm-exp                 = emitente-cex.cod-incoterm-exp
                      tt-emitente.cod-itiner-imp                   = emitente-cex.cod-itiner-imp
                      tt-emitente.cod-incoterm-imp                 = emitente-cex.cod-incoterm-imp
                      tt-emitente.log-desp-inclusas                = emitente-cex.log-desp-inclusas
                      tt-emitente.nr-tab                           = emitente-cex.nr-tab
                      tt-emitente.cod-pto-contr                    = emitente-cex.cod-pto-contr
                      tt-emitente.des-layout-origin-comerc-        = emitente-cex.des-layout-origin-comerc-
                      tt-emitente.des-layout-origin-packing        = emitente-cex.des-layout-origin-packing
                      tt-emitente.des-layout-origin-proform        = emitente-cex.des-layout-origin-proform
                      tt-emitente.des-layout-origin-ped-cambio     = emitente-cex.des-layout-origin-ped-cambio
                      tt-emitente.des-layout-origin-instruc-embarq = emitente-cex.des-layout-origin-instruc-embarq
                      tt-emitente.cdn-despa-import                 = emitente-cex.cdn-despa-import
                      tt-emitente.cdn-despa-exter-import           = emitente-cex.cdn-despa-exter-import
                      tt-emitente.cdn-segurad-import               = emitente-cex.cdn-segurad-import
                      tt-emitente.cdn-corretor-cambio-impor        = emitente-cex.cdn-corretor-cambio-impor
                      tt-emitente.cdn-corretor-import              = emitente-cex.cdn-corretor-import
                      tt-emitente.marca-1                          = emitente-cex.marca-1
                      tt-emitente.marca-2                          = emitente-cex.marca-2
                      tt-emitente.marca-3                          = emitente-cex.marca-3
                      tt-emitente.marca-4                          = emitente-cex.marca-4
                      tt-emitente.marca-5                          = emitente-cex.marca-5.
           END.
       END.
    END.
    ELSE
        RETURN "NOK":U.
END PROCEDURE.
PROCEDURE getNCMFabricantePedido:

    DEFINE INPUT  PARAMETER p-class-fiscal LIKE classif-fisc.class-fiscal.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-classif-fisc.

    empty temp-table tt-classif-fisc.

    FIND FIRST classif-fisc 
         WHERE classif-fisc.class-fiscal = p-class-fiscal NO-LOCK NO-ERROR.
    IF AVAIL  classif-fisc THEN DO:
        CREATE tt-classif-fisc.
        BUFFER-COPY classif-fisc TO tt-classif-fisc.
    END.
    IF NOT CAN-FIND(FIRST tt-classif-fisc) THEN
        RETURN "NOK".
    RETURN "OK".
END PROCEDURE.

PROCEDURE getAliquotasImpostos:

    DEFINE OUTPUT PARAMETER TABLE FOR tt-ord-aliquotas.
    EMPTY TEMP-TABLE tt-ord-aliquotas.

    RUN GetOrdensCompra (OUTPUT TABLE tt-ordens).
    find first tt-ordens no-error.
    if avail tt-ordens then do:
        FIND FIRST ordem-compra
             WHERE ordem-compra.numero-ordem = tt-ordens.numero-ordem NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
            FIND FIRST ITEM 
                 WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:
                FIND FIRST cotacao-item 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                       AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                       AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                       AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
                IF AVAIL cotacao-item THEN DO:
                    FIND FIRST param-imp
                         WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                    IF AVAIL param-imp THEN DO:
                        FIND FIRST natur-oper 
                             WHERE natur-oper.nat-operacao = param-imp.cod-natur-operac-padr NO-LOCK NO-ERROR.
                        IF AVAIL natur-oper THEN DO:

                            CREATE tt-ord-aliquotas.
                            ASSIGN tt-ord-aliquotas.numero-ordem = tt-ordens.numero-ordem.

                            /** Determina tributacao e aliquota do IPI
                             ** carrega nas variaveis de-aliq-ipi e i-trib-ipi
                            ---*/
                            
                            {imp/im0091.i5}
                            IF  i-trib-ipi = 2 /* isento */ THEN
                                ASSIGN de-aliq-ipi = 0.           

                            /*--- aplica reducao do IPI ---*/
                            IF  i-trib-ipi = 4 /* reduzido */ THEN
                                ASSIGN de-aliq-ipi = de-aliq-ipi - (de-aliq-ipi * natur-oper.perc-red-ipi / 100).

                            ASSIGN tt-ord-aliquotas.aliquota-ipi = de-aliq-ipi
                                   tt-ord-aliquotas.trib-ipi     = if natur-oper.cd-trib-ipi <> 0 then {ininc/i10in172.i 04 natur-oper.cd-trib-ipi} else {ininc/i10in172.i 04 2}.
                            /*--- Calcula a tributacao do ICMS ---*/
                            RUN cdp/cd4302.p (item.cd-trib-icm,
                                              natur-oper.cd-trib-icm,
                                              output c-trib-icm).
                            /*--- Calcula a aliquota do ICMS ---*/
                            IF  c-trib-icm <> 2 THEN DO:
                                FIND FIRST estabelec
                                     WHERE estabelec.cod-estabel = ordem-compra.cod-estabel NO-LOCK NO-ERROR.
                                IF AVAIL estabelec THEN DO:
                                    FOR FIRST b-emit-estab FIELDS(contrib-icms natureza)
                                        WHERE b-emit-estab.cod-emitente = estabelec.cod-emitente NO-LOCK: END.
                                    RUN cdp/cd4301.p ( (IF  AVAIL b-emit-estab THEN
                                                            b-emit-estab.contrib-icms
                                                        ELSE
                                                            YES),
                                                       (IF  AVAIL b-emit-estab THEN
                                                            b-emit-estab.natureza
                                                        ELSE 2 /*"J"*/),
                                                        estabelec.estado /*estabelec.estado*/,
                                                        estabelec.pais,
                                                        estabelec.estado,
                                                        ordem-compra.it-codigo,
                                                        natur-oper.aliquota-icm,
                                                        OUTPUT de-aliq-icm ).
                                    /*--- aplica reducao do ICMS ---*/
                                    IF  c-trib-icm = 4 /* reduzido */ THEN
                                        ASSIGN de-aliq-icm = de-aliq-icm - (de-aliq-icm * natur-oper.perc-red-icm / 100).
                                END.
                            END.
                            ELSE
                                ASSIGN de-aliq-icm = 0. /* item isento */

                            ASSIGN tt-ord-aliquotas.aliquota-icm = de-aliq-icm
                                   tt-ord-aliquotas.trib-icm     = if natur-oper.cd-trib-icm <> 0 then {ininc/i01in245.i 04 natur-oper.cd-trib-icm} else {ininc/i01in245.i 04 2}.

                            IF NOT VALID-HANDLE(h-im9048) THEN
                                RUN imp/im9048.p PERSISTENT SET h-im9048.
                            /*--- busca tributacao e aliquota do PIS ---*/
                            RUN pi-tributa-aliquota-pis-importacao IN h-im9048 (BUFFER natur-oper,
                                                                                BUFFER ITEM,
                                                                                INPUT  ordem-compra.cod-estabel,
                                                                                INPUT  TODAY,
                                                                                INPUT  NO,
                                                                                INPUT  ?,
                                                                                INPUT  ?,
                                                                                INPUT  ?,
                                                                                OUTPUT i-trib-pis,
                                                                                OUTPUT de-aliq-pis,
                                                                                OUTPUT de-valor-un-pis,
                                                                                OUTPUT de-valor-vol-pis,
                                                                                OUTPUT de-red-pis /* Valor Reducao PIS */).

                            ASSIGN tt-ord-aliquotas.aliquota-pis = de-aliq-pis
                                   tt-ord-aliquotas.trib-pis     = if i-trib-pis <> 0 then {ininc/i11in172.i 04 i-trib-pis} else {ininc/i11in172.i 04 2}. 

                            /*--- busca tributacao e aliquota do COFINS ---*/
                            RUN pi-tributa-aliquota-cofins-importacao IN h-im9048 (BUFFER natur-oper,
                                                                                   BUFFER ITEM,
                                                                                   INPUT  ordem-compra.cod-estabel,
                                                                                   INPUT  TODAY,
                                                                                   INPUT  NO,
                                                                                   INPUT  ?,
                                                                                   INPUT  ?,
                                                                                   INPUT  ?,
                                                                                   OUTPUT i-trib-cofins,
                                                                                   OUTPUT de-aliq-cofins,
                                                                                   OUTPUT de-valor-un-cofins,
                                                                                   OUTPUT de-valor-vol-cofins, 
                                                                                   OUTPUT de-red-cofins /* Valor Reducao COFINS */).
                            ASSIGN tt-ord-aliquotas.aliquota-cofins = de-aliq-cofins
                                   tt-ord-aliquotas.trib-cofins     = if i-trib-cofins <> 0 then {ininc/i11in172.i 04 i-trib-cofins} else {ininc/i11in172.i 04 2}.


                            DELETE PROCEDURE h-im9048.

                            /*--- busca a tributacao do II ---*/
                            RUN imp/im9041.p (INT(SUBSTR(item.char-2,20,2)),
                                              INT(SUBSTR(natur-oper.char-1,10,2)),
                                              OUTPUT i-trib-ii). 
                            ASSIGN tt-ord-aliquotas.trib-ii = if i-trib-ii <> 0 then {ininc/i10in172.i 04 i-trib-ii} else {ininc/i10in172.i 04 2}. 
                            /*--- busca aliquota do II ---*/
                            IF  i-trib-ii = 2 /* isento */ THEN
                                ASSIGN de-aliq-ii = 0.
                            ELSE DO:
                                RUN imp/im9042.p PERSISTENT SET h-im9042(INPUT cotacao-item.numero-ordem,
                                                                         OUTPUT de-aliq-ii).
                                RUN pi-retorna-aliquota-ii IN h-im9042(INPUT ROWID(cotacao-item),
                                                                       OUTPUT de-aliq-ii).
                                DELETE PROCEDURE h-im9042 NO-ERROR.
                                ASSIGN h-im9042 = ?.
                            END.

                            assign tt-ord-aliquotas.aliquota-ii = de-aliq-ii.
                            
                        END.
                    END.
                END.
            END.
        END.
    END.
    
END PROCEDURE.

PROCEDURE getCalculosOrdemCompraEmbarque:

    DEFINE INPUT PARAMETER p-ordens-embarque AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-calculos-ordem-compra-emb.

    define var de-tot-quantidade  like prazo-compra.quantidade      no-undo.
    define var de-tot-qtd-do-forn like prazo-compra.quantidade      no-undo.
    define var de-tot-peso-bruto  like item.peso-bruto              no-undo.
    define var de-peso-bruto      like item.peso-bruto              no-undo.
    define var de-volume          like item.volume                  no-undo.
    define var de-tot-volume      like item.volume                  no-undo.
    define var de-peso-liquido    like ordens-embarque.peso-liquido no-undo.

    
    if  not valid-handle (h-boin356ab) then
        run inbo/boin356ab.p persistent set h-boin356ab.

    IF NOT VALID-HANDLE(h-bodi425) THEN 
        RUN dibo/bodi425.p   PERSISTENT SET h-bodi425.
    
    EMPTY TEMP-TABLE tt-calculos-ordem-compra-emb.

    FIND FIRST ordens-embarque
         WHERE ROWID(ordens-embarque) = p-ordens-embarque NO-LOCK NO-ERROR.
    IF AVAIL ordens-embarque THEN DO:
        FIND FIRST ordem-compra 
             WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:
            FIND FIRST ITEM
                WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

            for each prazo-compra
                fields (quantidade qtd-do-forn quant-saldo it-codigo)
                where prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                and   prazo-compra.situacao    <> 4
                and   prazo-compra.situacao    <> 6 no-lock:


               IF VALID-HANDLE(h-bodi425) THEN
                    RUN piRetornaQtdeEmbalagem IN h-bodi425(INPUT prazo-compra.quant-saldo, 
                                                            INPUT prazo-compra.it-codigo, 
                                                            INPUT ordem-compra.cod-emitente,
                                                            OUTPUT d-qtd-embal).

               run retornaPesoTotal in h-boin356ab (input rowid(prazo-compra),
                                                    input prazo-compra.quantidade,
                                                    INPUT d-qtd-embal,
                                                    output de-peso-bruto).

               run retornaVolumeTotal in h-boin356ab (input rowid(prazo-compra),
                                                       input prazo-compra.quantidade,
                                                       output de-volume).

               assign de-tot-peso-bruto  = de-tot-peso-bruto  + de-peso-bruto
                      de-tot-volume      = de-tot-volume      + de-volume
                      de-tot-quantidade  = de-tot-quantidade  + prazo-compra.quantidade
                      de-tot-qtd-do-forn = de-tot-qtd-do-forn + prazo-compra.qtd-do-forn.
               
            end.

            if ordens-embarque.peso-liquido <> 0 then
                assign de-peso-liquido = ordens-embarque.peso-liquido.
            else 
                assign de-peso-liquido = IF AVAIL ITEM THEN ITEM.peso-liquido ELSE 1.

            CREATE tt-calculos-ordem-compra-emb.
            ASSIGN tt-calculos-ordem-compra-emb.cod-estabel        = ordens-embarque.cod-estabel
                   tt-calculos-ordem-compra-emb.numero-ordem       = ordens-embarque.numero-ordem
                   tt-calculos-ordem-compra-emb.peso-liquido-total = de-tot-quantidade * de-peso-liquido
                   tt-calculos-ordem-compra-emb.peso-bruto-total   = de-tot-peso-bruto
                   tt-calculos-ordem-compra-emb.ocupacao-total     = de-tot-volume.

            FIND FIRST cotacao-item
                 WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                   AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                   AND cotacao-item.cot-aprovada NO-LOCK NO-ERROR.
            IF AVAIL cotacao-item THEN DO:

                ASSIGN tt-calculos-ordem-compra-emb.preco-fornec-liq = (cotacao-item.pre-unit-for * 100) / (100 + cotacao-item.aliquota-ipi)
                       tt-calculos-ordem-compra-emb.preco-fornec-bru = (tt-calculos-ordem-compra-emb.preco-fornec-liq * 100) / (100 - cotacao-item.perc-descto)
                       tt-calculos-ordem-compra-emb.preco-interno-liq = (cotacao-item.preco-unit * 100) / (100 + cotacao-item.aliquota-ipi)
                       tt-calculos-ordem-compra-emb.preco-interno-bru = (tt-calculos-ordem-compra-emb.preco-interno-liq * 100) / (100 - cotacao-item.perc-descto).
                
                ASSIGN tt-calculos-ordem-compra-emb.preco-fornec-liq-total  = tt-calculos-ordem-compra-emb.preco-fornec-liq  * de-tot-qtd-do-forn
                       tt-calculos-ordem-compra-emb.preco-fornec-bru-total  = tt-calculos-ordem-compra-emb.preco-fornec-bru  * de-tot-qtd-do-forn
                       tt-calculos-ordem-compra-emb.preco-interno-liq-total = tt-calculos-ordem-compra-emb.preco-interno-liq * de-tot-quantidade
                       tt-calculos-ordem-compra-emb.preco-interno-bru-total = tt-calculos-ordem-compra-emb.preco-interno-bru * de-tot-quantidade.
            END.
        END.
    END.

    if  valid-handle (h-boin356ab) then do:
        delete procedure h-boin356ab.
        assign h-boin356ab = ?.
    end.
    if  valid-handle (h-bodi425) then do:
        delete procedure h-bodi425.
        assign h-bodi425 = ?.
    end.

    ASSIGN d-qtd-embal = 0.

END PROCEDURE.
