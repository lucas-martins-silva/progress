/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9054 2.00.00.001}  /*** 010001 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9054 MIM}
&ENDIF

{cdp/cdcfgmat.i}


    DEFINE INPUT  PARAMETER pr-rowid    AS   ROWID                 NO-UNDO.
    DEFINE INPUT  PARAMETER pc-embarque LIKE embarque-imp.embarque NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-titulo   AS   LOGICAL               NO-UNDO.

    DEFINE VARIABLE l-tit-ap AS LOGICAL NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    ASSIGN l-tit-ap = NO.

    FIND FIRST dupli-apagar
        WHERE ROWID(dupli-apagar) = pr-rowid NO-LOCK NO-ERROR.

    IF AVAIL dupli-apagar THEN DO:
        IF CAN-FIND(FIRST tit-ap
                    WHERE tit-ap.ep-codigo   = param-global.empresa-prin
                      AND tit-ap.cod-estabel = dupli-apagar.cod-estabel
                      AND tit-ap.cod-esp     = dupli-apagar.cod-esp
                      AND tit-ap.nr-docto    = pc-embarque
                      AND tit-ap.parcela     = dupli-apagar.parcela
                      AND tit-ap.serie       = dupli-apagar.serie
                      AND tit-ap.cod-fornec  = dupli-apagar.cod-emitente) THEN DO:
            ASSIGN l-tit-ap = YES.
        END.
        ELSE 
            ASSIGN l-tit-ap = NO.
    END.

    ASSIGN pl-titulo = l-tit-ap.

RETURN "OK":U.

