/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT0904BB 2.00.00.003 } /*** 010003 ***/



{cdp/cdcfgmat.i}

DEFINE INPUT PARAM p-query     AS HANDLE NO-UNDO.
DEFINE INPUT PARAM p-column    AS HANDLE NO-UNDO.
DEFINE INPUT PARAM p-column2   AS HANDLE NO-UNDO.
DEFINE VARIABLE    h-buffer    AS HANDLE NO-UNDO.
DEFINE VARIABLE    h-field     AS HANDLE NO-UNDO.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

ASSIGN h-buffer = p-query:GET-BUFFER-HANDLE(1).

FIND FIRST it-nota-fisc NO-LOCK WHERE
    ROWID(it-nota-fisc) = h-buffer:ROWID NO-ERROR.

IF AVAIL it-nota-fisc THEN DO:
        ASSIGN p-column:SCREEN-VALUE   = &IF '{&bf_mat_versao_ems}' >= "2.09" &THEN it-nota-fisc.cod-contrat-comerc
                                         &ELSE SUBSTRING(it-nota-fisc.char-2,247,20) &ENDIF
               p-column2:SCREEN-VALUE  = &IF '{&bf_mat_versao_ems}' >= "2.09" &THEN it-nota-fisc.num-romaneio-rel
                                         &ELSE SUBSTRING(it-nota-fisc.char-2,232,9) &ENDIF.
END.
