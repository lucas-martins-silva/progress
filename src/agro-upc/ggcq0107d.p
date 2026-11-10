/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCQ0107D 2.00.00.003 } /*** 010003 ***/



DEFINE NEW GLOBAL SHARED VAR  wh-ex-melhoria1 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-mes1 AS CHARACTER FORMAT "x(15)"  NO-UNDO.
DEFINE VARIABLE c-mes2 AS CHARACTER FORMAT "x(48)"  NO-UNDO.

IF wh-ex-melhoria1:SCREEN-VALUE <> "" THEN DO:

    {utp/ut-liter.i "Exame Inv†lido!" * R}
    assign c-mes1 = return-value.
    {utp/ut-liter.i "C¢digo de exame de umidade informado n∆o existe!" * R}
    assign c-mes2 = return-value.
    
    FIND FIRST comp-exame NO-LOCK
         WHERE comp-exame.cod-exame = int(wh-ex-melhoria1:SCREEN-VALUE) NO-ERROR.
    
    IF NOT AVAIL comp-exame THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 15825,
                           INPUT c-mes1 + "~~" + c-mes2).
                           
        APPLY 'entry' TO wh-ex-melhoria1.
        RETURN NO-APPLY.
    END.
    
END.
