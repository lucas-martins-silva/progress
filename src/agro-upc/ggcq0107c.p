/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0107C 2.00.00.004 } /*** 010004 ***/


DEFINE NEW GLOBAL SHARED VAR  wh-ex-melhoria AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-mes1 AS CHARACTER FORMAT "x(18)"  NO-UNDO.
DEFINE VARIABLE c-mes2 AS CHARACTER FORMAT "x(49)"  NO-UNDO.

IF wh-ex-melhoria:SCREEN-VALUE <> "":U AND wh-ex-melhoria:SCREEN-VALUE <> "0":U THEN DO:

    {utp/ut-liter.i "Exame Inv†lido!" * R}
    assign c-mes1 = return-value.
    {utp/ut-liter.i "C¢digo de exame de melhoria informado n∆o existe!" * R}
    assign c-mes2 = return-value.
    
    FIND FIRST comp-exame NO-LOCK
         WHERE comp-exame.cod-exame = int(wh-ex-melhoria:SCREEN-VALUE) NO-ERROR.
    
    IF NOT AVAIL comp-exame THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT c-mes1 + "~~" + c-mes2).

        APPLY 'entry':U TO wh-ex-melhoria.
        RETURN NO-APPLY.
    END.
    
END.
