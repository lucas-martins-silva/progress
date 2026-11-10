/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0017B1 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0017b1 MIM}
&ENDIF

/*******************************************************************************
**  Programa: imp~\im0017b.p
**  Objetivo:
**  Autor...: Datasul Logistica log973  
**  Data....: 17.04.2005 
*******************************************************************************/
DEFINE TEMP-TABLE tt-param NO-UNDO
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel                    AS CHARACTER format "x(05)"
&ELSE
    FIELD cod-estabel                    AS CHARACTER FORMAT "x(03)"
&ENDIF
    FIELD num-pedido-ini                 AS INTEGER   FORMAT ">>>>>,>>9"
    FIELD num-pedido-fim                 AS INTEGER   FORMAT ">>>>>,>>9"
    FIELD data-pedido-ini                AS DATE      FORMAT "99/99/9999"
    FIELD data-pedido-fim                AS DATE      FORMAT "99/99/9999"
    FIELD via-transp-ini                 AS INTEGER   FORMAT "9"
    FIELD via-transp-fim                 AS INTEGER   FORMAT "9"
    FIELD cod-transp-ini                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-transp-fim                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-emitente-ini               AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-emitente-fim               AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD nr-proc-imp-ini                AS CHARACTER FORMAT "x(12)"
    FIELD nr-proc-imp-fim                AS CHARACTER FORMAT "x(12)"
    FIELD incoterm-ini                   AS CHARACTER FORMAT "x(03)"
    FIELD incoterm-fim                   AS CHARACTER FORMAT "x(03)"
    FIELD cod-itiner-ini                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-itiner-fim                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-despachante-ini            AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-despachante-fim            AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-despa-exter-import-ini     AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-despa-exter-import-fim     AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-cambio-import-ini AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-cambio-import-fim AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-agente-ini                 AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-agente-fim                 AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-segurad-import-ini         AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-segurad-import-fim         AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-import-ini        AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-import-fim        AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD it-codigo-ini                  AS CHARACTER FORMAT "x(16)"
    FIELD it-codigo-fim                  AS CHARACTER FORMAT "x(16)".

DEFINE TEMP-TABLE tt-pedido NO-UNDO
    FIELD marca           AS LOGICAL
    FIELD num-pedido      LIKE pedido-compr.num-pedido
    FIELD cod-emitente    LIKE pedido-compr.cod-emitente
    FIELD nome-abrev      LIKE emitente.nome-abrev
    FIELD data-pedido     LIKE pedido-compr.data-pedido
    FIELD nr-proc-imp     LIKE processo-imp.nr-proc-imp
    FIELD incoterm        AS CHARACTER
    FIELD cod-itiner      LIKE itinerario.cod-itiner
    FIELD desc-itiner     LIKE itinerario.descricao
    FIELD val-desp        LIKE despes-ped-compra.val-desp
    FIELD log-execucao-OK AS LOGICAL
    FIELD r-rowid         AS ROWID.

DEFINE INPUT        PARAMETER TABLE FOR tt-param.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-pedido.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-pedido:
    ASSIGN tt-pedido.marca = NO.
END.

FOR EACH pedido-compr
    WHERE pedido-compr.cod-estabel   = tt-param.cod-estabel
    AND   pedido-compr.num-pedido   >= tt-param.num-pedido-ini
    AND   pedido-compr.num-pedido   <= tt-param.num-pedido-fim
    AND   pedido-compr.data-pedido  >= tt-param.data-pedido-ini
    AND   pedido-compr.data-pedido  <= tt-param.data-pedido-fim
    AND   pedido-compr.cod-transp   >= tt-param.cod-transp-ini
    AND   pedido-compr.cod-transp   <= tt-param.cod-transp-fim
    AND   pedido-compr.cod-emitente >= tt-param.cod-emitente-ini
    AND   pedido-compr.cod-emitente <= tt-param.cod-emitente-fim 
    AND   pedido-compr.situacao     <> 3 NO-LOCK:
    FIND FIRST emitente
        WHERE emitente.cod-emitente  = pedido-compr.cod-emitente
        AND   emitente.natureza     >= 3
        AND   emitente.natureza     <= 4 NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        FIND FIRST processo-imp
            WHERE  processo-imp.num-pedido                  = pedido-compr.num-pedido
            AND    processo-imp.nr-proc-imp                >= tt-param.nr-proc-imp-ini
            AND    processo-imp.nr-proc-imp                <= tt-param.nr-proc-imp-fim
            AND    processo-imp.via-transp                 >= tt-param.via-transp-ini
            AND    processo-imp.via-transp                 <= tt-param.via-transp-fim 
            AND    processo-imp.cod-itiner                 >= tt-param.cod-itiner-ini 
            AND    processo-imp.cod-itiner                 <= tt-param.cod-itiner-fim 
            AND    processo-imp.cod-despachante            >= tt-param.cod-despachante-ini 
            AND    processo-imp.cod-despachante            <= tt-param.cod-despachante-fim 
            AND    processo-imp.cdn-despa-exter-import     >= tt-param.cdn-despa-exter-import-ini 
            AND    processo-imp.cdn-despa-exter-import     <= tt-param.cdn-despa-exter-import-fim 
            AND    processo-imp.cdn-corretor-cambio-import >= tt-param.cdn-corretor-cambio-import-ini 
            AND    processo-imp.cdn-corretor-cambio-import <= tt-param.cdn-corretor-cambio-import-fim 
            AND    processo-imp.cod-agente                 >= tt-param.cod-agente-ini
            AND    processo-imp.cod-agente                 <= tt-param.cod-agente-fim
            AND    processo-imp.cdn-segurad-import         >= tt-param.cdn-segurad-import-ini
            AND    processo-imp.cdn-segurad-import         <= tt-param.cdn-segurad-import-fim 
            AND    processo-imp.cdn-corretor-import        >= tt-param.cdn-corretor-import-ini 
            AND    processo-imp.cdn-corretor-import        <= tt-param.cdn-corretor-import-fim 
            NO-LOCK NO-ERROR.
        IF AVAIL processo-imp THEN DO:
            FIND FIRST ordem-compra
                WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
                AND   ordem-compra.it-codigo  >= tt-param.it-codigo-ini 
                AND   ordem-compra.it-codigo  <= tt-param.it-codigo-fim NO-LOCK NO-ERROR.
            IF AVAIL ordem-compra THEN DO:
                FIND FIRST cotacao-item
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                    AND   cotacao-item.it-codigo    = ordem-compra.it-codigo
                    AND   cotacao-item.cot-aprovada = YES
                    AND   SUBSTRING(cotacao-item.char-1,21,20) >= tt-param.incoterm-ini
                    AND   SUBSTRING(cotacao-item.char-1,21,20) <= tt-param.incoterm-fim NO-LOCK NO-ERROR.
                IF AVAIL cotacao-item THEN DO:
                    FIND FIRST tt-pedido 
                        WHERE tt-pedido.num-pedido = pedido-compr.num-pedido NO-ERROR.
                    IF NOT AVAIL tt-pedido THEN
                        CREATE tt-pedido.
                    ASSIGN tt-pedido.marca        = YES
                           tt-pedido.num-pedido   = pedido-compr.num-pedido
                           tt-pedido.cod-emitente = pedido-compr.cod-emitente
                           tt-pedido.nome-abrev   = emitente.nome-abrev
                           tt-pedido.data-pedido  = pedido-compr.data-pedido
                           tt-pedido.nr-proc-imp  = processo-imp.nr-proc-imp
                           tt-pedido.incoterm     = SUBSTRING(cotacao-item.char-1,21,20)
                           tt-pedido.cod-itiner   = processo-imp.cod-itiner
                           tt-pedido.r-rowid      = ROWID(pedido-compr).
                    FIND FIRST itiner
                        WHERE itiner.cod-itiner = processo-imp.cod-itiner NO-LOCK NO-ERROR.
                    IF AVAIL itiner THEN
                        ASSIGN tt-pedido.desc-itiner  = itiner.descricao.
                    ELSE
                        ASSIGN tt-pedido.desc-itiner  = "".
                END.
            END.    
        END.
    END.    
END.

