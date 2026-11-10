/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GG-CRIA-EXT-NOTA-FISCAL 2.00.00.003 } /*** 010003 ***/


DEFINE INPUT  PARAMETER pcod-estabel  LIKE nota-fiscal.cod-estabel  NO-UNDO.
DEFINE INPUT  PARAMETER pserie        LIKE nota-fiscal.serie        NO-UNDO.
DEFINE INPUT  PARAMETER pnr-nota-fis  LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
DEFINE INPUT  PARAMETER pnat-operacao LIKE nota-fiscal.nat-operacao NO-UNDO.

FIND FIRST gg-ext-nota-fiscal NO-LOCK
     WHERE gg-ext-nota-fiscal.cod-estabel = pcod-estabel 
       AND gg-ext-nota-fiscal.serie       = pserie
       AND gg-ext-nota-fiscal.nr-nota-fis = pnr-nota-fis NO-ERROR.
IF NOT AVAIL gg-ext-nota-fiscal THEN DO:
   
    CREATE gg-ext-nota-fiscal.
    ASSIGN gg-ext-nota-fiscal.cod-estabel    = pcod-estabel 
           gg-ext-nota-fiscal.serie          = pserie
           gg-ext-nota-fiscal.nr-nota-fis    = pnr-nota-fis.

    FOR FIRST estabelec FIELDS (ep-codigo cod-emitente) NO-LOCK 
        WHERE estabelec.cod-estabel = gg-ext-nota-fiscal.cod-estabel:
        ASSIGN gg-ext-nota-fiscal.ep-codigo      = estabelec.ep-codigo 
               gg-ext-nota-fiscal.cod-emissor    = estabelec.cod-emitente. 
    END.

    ASSIGN gg-ext-nota-fiscal.log-transito = NO. /* para entrar na trigger da gg-ext-nota-fiscal */

    IF pnat-operacao BEGINS "3" THEN
        ASSIGN gg-ext-nota-fiscal.ind-tipo = 1. /* importacao */

    RELEASE gg-ext-nota-fiscal. 

    IF AVAIL gg-ext-nota-fiscal THEN
       FIND CURRENT gg-ext-nota-fiscal NO-LOCK NO-ERROR.
END.

RETURN "OK":U.
