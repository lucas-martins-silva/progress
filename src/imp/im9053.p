/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9053 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9053 MIM}
&ENDIF


{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

DEFINE INPUT  PARAMETER pi-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
DEFINE OUTPUT PARAMETER pl-ok           AS   LOGICAL   INITIAL YES NO-UNDO.

DEFINE VARIABLE c-table-label AS CHARACTER FORMAT "x(40)":U NO-UNDO.
DEFINE VARIABLE c-table-relac AS CHARACTER FORMAT "x(40)":U NO-UNDO.

    {utp/ut-table.i mgadm emitente 1}
    ASSIGN c-table-label = TRIM(RETURN-VALUE).

    IF CAN-FIND(FIRST param-imp 
                WHERE INT(SUBSTRING(param-imp.char-1,1,20)) = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex param-imp 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST desp-imp
                WHERE &IF DEFINED(BF_DIS_VERSAO_EMS) &THEN                
                         &IF '{&bf_dis_versao_ems}' >= '2.05' &THEN
                             desp-imp.cod-emitente = pi-cod-emitente)
                         &ELSE
                             INT(SUBSTRING(desp-imp.char-1,1,9)) = pi-cod-emitente)
                         &ENDIF
                     &ENDIF THEN DO:
       {utp/ut-table.i mgcex desp-imp 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST tb-pr-cex
                WHERE tb-pr-cex.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex tb-pr-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END. 

    &IF '{&bf_dis_versao_ems}' >= '2.04' &THEN
        IF CAN-FIND(FIRST movto-ato
                    WHERE movto-ato.cod-emitente = pi-cod-emitente) THEN DO:
           {utp/ut-table.i mgcex movto-ato 1} 
           ASSIGN c-table-relac = TRIM(RETURN-VALUE).
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 5,
                              INPUT c-table-label + "~~" + c-table-relac).
           ASSIGN pl-ok = NO.
           RETURN 'ADM-ERROR':U.
        END.
    
        IF CAN-FIND(FIRST componente-cex
                    WHERE componente-cex.cod-emitente = pi-cod-emitente) THEN DO:
           {utp/ut-table.i mgcex componente-cex 1} 
           ASSIGN c-table-relac = TRIM(RETURN-VALUE).
           RUN utp/ut-msgs.p (INPUT "show":U,
                              INPUT 5,
                              INPUT c-table-label + "~~" + c-table-relac).
           ASSIGN pl-ok = NO.
           RETURN 'ADM-ERROR':U.
        END.
    &ENDIF

    IF CAN-FIND(FIRST cot-ordem
                WHERE cot-ordem.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex cot-ordem 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST cotacao-item-cex
                WHERE cotacao-item-cex.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex cotacao-item-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST cotacao-item-cex
                WHERE cotacao-item-cex.cod-emitente-desp = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex cotacao-item-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST decl-cliente
                WHERE decl-cliente.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex decl-cliente 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST desp-embarque
                WHERE desp-embarque.cod-emitente-desp = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex desp-embarque 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST desp-tb-pr-cex
                WHERE desp-tb-pr-cex.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex desp-tb-pr-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST docum-est-cex
                WHERE docum-est-cex.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex docum-est-cex 1}
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST docum-est-cex
                WHERE docum-est-cex.cod-emitente-desp = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex docum-est-cex 1}
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST dupli-apagar-cex
                WHERE dupli-apagar-cex.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex dupli-apagar-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST dupli-apagar-cex
                WHERE dupli-apagar-cex.cod-emitente-desp = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex dupli-apagar-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST item-doc-est
                WHERE item-doc-est.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i movind item-doc-est 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST item-doc-est-cex
                WHERE item-doc-est-cex.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex item-doc-est-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST item-doc-est-cex
                WHERE item-doc-est-cex.cod-emitente-desp = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex item-doc-est-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST desp-cot-ordem
                WHERE desp-cot-ordem.cod-emitente-desp = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex desp-cot-ordem 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

    IF CAN-FIND(FIRST emitente-cex
                WHERE emitente-cex.cod-emitente = pi-cod-emitente) THEN DO:
       {utp/ut-table.i mgcex emitente-cex 1} 
       ASSIGN c-table-relac = TRIM(RETURN-VALUE).
       RUN utp/ut-msgs.p (INPUT "show":U,
                          INPUT 5,
                          INPUT c-table-label + "~~" + c-table-relac).
       ASSIGN pl-ok = NO.
       RETURN 'ADM-ERROR':U.
    END.

RETURN "":U.

