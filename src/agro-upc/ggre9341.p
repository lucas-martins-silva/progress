/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE9341 2.00.00.010 } /*** "010010" 29/05/2025 09:23:33  ***/


/**************************************************************************
**    Programa.:  GGRE9341
**    Objetivo.:  UPC para a Gera‡Æo de Duplicatas (RE9341).
**    Data.....:  Setembro/2004
***************************************************************************/
{cdp/cdcfgmat.i}
{include/i-epc200.i} /*Defini‡Æo tt-EPC*/
{utp/ut-glob.i}

DEF INPUT PARAM p-ind-event AS CHAR   NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

DEF BUFFER b-docum-est    FOR docum-est.
DEF BUFFER b-dupli-apagar FOR dupli-apagar.



IF  p-ind-event = "After-Invoice-Generation":U THEN DO:

    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "After-Invoice-Generation":U
          AND tt-epc.cod-parameter = "rowid(docum-est)":U:

        FIND b-docum-est NO-LOCK
            WHERE ROWID(b-docum-est) = TO-ROWID(tt-epc.val-parameter) NO-ERROR.
        IF  AVAIL b-docum-est THEN DO:
            FIND FIRST item-doc-est NO-LOCK 
                WHERE item-doc-est.serie-docto  = b-docum-est.serie-docto
                  AND item-doc-est.nro-docto    = b-docum-est.nro-docto
                  AND item-doc-est.cod-emitente = b-docum-est.cod-emitente
                  AND item-doc-est.nat-operacao = b-docum-est.nat-operacao NO-ERROR.
            IF  AVAIL item-doc-est THEN DO:
                FIND FIRST gg-contrato NO-LOCK
                    WHERE gg-contrato.ep-codigo      = i-ep-codigo-usuario
                        AND gg-contrato.cod-contrato = TRIM(SUBSTR(item-doc-est.char-2,540,20)) NO-ERROR.
                IF  AVAIL gg-contrato THEN DO:
                    FOR EACH b-dupli-apagar EXCLUSIVE-LOCK
                        WHERE b-dupli-apagar.serie-docto  = b-docum-est.serie-docto
                          AND b-dupli-apagar.nro-docto    = b-docum-est.nro-docto
                          AND b-dupli-apagar.cod-emitente = b-docum-est.cod-emitente  
                          AND b-dupli-apagar.nat-operacao = b-docum-est.nat-operacao:  

                        ASSIGN b-dupli-apagar.cod-esp = gg-contrato.cod-esp.

                        IF  INT(SUBSTR(b-dupli-apagar.char-2,1,5)) = 0
                        AND b-dupli-apagar.vl-a-pagar              = item-doc-est.preco-total[1] THEN
                           OVERLAY(b-dupli-apagar.char-2,1,5) = STRING(item-doc-est.sequencia,"99999").

                    END.
                END.
            END.
        END.
    END.
END.

