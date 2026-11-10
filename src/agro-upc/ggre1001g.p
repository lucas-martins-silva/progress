/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE1001G 2.00.00.004 } /*** 010004 ***/


/*************************************************************************
**    Programa.:  GGre1001g
**    Objetivo.:  UPC Classifica‡Æo
**    Data.....:  Agosto/2003
*************************************************************************/
DEFINE NEW GLOBAL SHARED VAR p-row-table2-re1001        as rowid no-undo.
DEFINE NEW GLOBAL SHARED VAR wh-ggre1001-BrItem         AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE h-field     AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
IF  VALID-HANDLE(wh-ggre1001-BrItem) THEN DO:
    
    ASSIGN  h-field     = wh-ggre1001-BrItem:QUERY
            h-field     = h-field:GET-BUFFER-HANDLE()
            h-field     = h-field:BUFFER-FIELD('sequencia':U) 
            i-sequencia = INTEGER(h-field:BUFFER-VALUE) NO-ERROR.
    
    IF  i-sequencia > 0 THEN DO:
        FIND FIRST docum-est NO-LOCK
             WHERE ROWID(docum-est) = p-row-table2-re1001 NO-ERROR.
        FIND FIRST item-doc-est OF docum-est NO-LOCK
             WHERE item-doc-est.sequencia   = i-sequencia NO-ERROR.
        IF  AVAIL item-doc-est THEN DO:
            run agro-upc/ggft4003f.w (INPUT "item-doc-est":U,
                                      INPUT YES,
                                      INPUT ROWID(item-doc-est)) .
        END.
    END.
END.
RETURN 'OK':U.
