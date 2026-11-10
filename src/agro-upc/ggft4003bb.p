/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003BB 2.00.00.008 } /*** 010008 ***/



/****************************************************************************
 * Nome.....: ggft4003bb.p
 * Objetivo.: Programa para efetuar o leave no campo Codigo do Contrato
 *            da upc ggft4003bb.p.
 * Data.....: Agosto/2003
 ***************************************************************************/
{utp/ut-glob.i}
{ggp/tt-erro.i}

DEF NEW GLOBAL SHARED VAR wh-cod-contrato-ft4003b   AS WIDGET-HANDLE NO-UNDO.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

FOR EACH tt-erro NO-LOCK.
    DELETE tt-erro.
END.

IF  VALID-HANDLE(wh-cod-contrato-ft4003b) AND wh-cod-contrato-ft4003b:SCREEN-VALUE <> "":U THEN DO:
    FIND FIRST gg-contrato NO-LOCK
         WHERE gg-contrato.ep-codigo    = i-ep-codigo-usuario
           AND gg-contrato.cod-contrato = wh-cod-contrato-ft4003b:SCREEN-VALUE NO-ERROR.
    IF NOT AVAIL gg-contrato THEN DO:
       {utp/ut-liter.i "Contrato n∆o Encontrado." * R}
       RUN pi-tt-erro(INPUT RETURN-VALUE).
    END.
    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF  AVAIL tt-erro THEN DO:
        run cdp/cd0666.w (INPUT TABLE tt-erro).
        APPLY "ENTRY":U TO wh-cod-contrato-ft4003b.
        RETURN ERROR.
    END.
END.

