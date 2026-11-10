/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGRE0701AA 2.00.00.002 } /*** 010002 ***/

{cdp/cdcfgmat.i}

DEFINE INPUT PARAM p-query         AS HANDLE NO-UNDO.
DEFINE INPUT PARAM p-column        AS HANDLE NO-UNDO.
DEFINE INPUT PARAM p-column-2      AS HANDLE NO-UNDO.
DEFINE VARIABLE    h-buffer        AS HANDLE NO-UNDO.
DEFINE VARIABLE    h-field         AS HANDLE NO-UNDO.

ASSIGN h-buffer = p-query:GET-BUFFER-HANDLE(1).

FIND FIRST item-doc-est NO-LOCK WHERE
    ROWID(item-doc-est) = h-buffer:ROWID NO-ERROR.

IF AVAIL item-doc-est THEN DO:
        ASSIGN p-column:SCREEN-VALUE   = &IF '{&bf_mat_versao_ems}' >= "2.09" &THEN item-doc-est.cod-contrat-comerc
                                         &ELSE SUBSTRING(item-doc-est.char-2, 540,20) &ENDIF
               p-column-2:SCREEN-VALUE = &IF '{&bf_mat_versao_ems}' >= "2.09" &THEN  item-doc-est.num-romaneio-rel
                                         &ELSE SUBSTRING(item-doc-est.char-2, 525,9) &ENDIF.
END.
