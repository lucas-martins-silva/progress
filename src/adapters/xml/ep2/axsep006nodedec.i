/* IMPORTANTE: toda alteraá∆o efetuada nessa include ser† reaproveitada   */
/* pela nova include do layout 2.00 da NF-e. Caso a alteraá∆o compreenda  */
/* apenas o novo layout 2.00, solicitamos que seja observado o coment†rio */
/* da include criada para o novo layout.                                  */

/*---------------------------------------------------------------------------------

PAR∂METROS

{1} NOME DA TAG
{2} VALOR DA TAG
{3} ê TAG OBRIGAT‡RIA ?
{4} QTDE DE CASAS DECIMAIS

---------------------------------------------------------------------------------*/
    
IF ("{3}" = "NO" /* Se a TAG n∆o for obrigat¢ria, s¢ imprimir se tiver valor */
AND {2} <> 0
AND {2} <> ?)
OR  "{3}"  = "YES" THEN DO: /* Se a TAG for obrigat¢rio, imprimir sempre */

    ASSIGN cValue = (IF "{4}" = "2"
                     THEN STRING({2},">>>>>>>>>>>>9.99")
                     ELSE IF "{4}" = "3"
                          THEN STRING({2},">>>>>>>>>>>>9.999")
			  ELSE IF "{4}" = "10"
	                       THEN STRING({2},">>>>>>>>>>>>9.99999")	
                               ELSE STRING({2},">>>>>>>>>>>>9.9999")).

    IF  SESSION:NUMERIC-FORMAT = "EUROPEAN" THEN
        ASSIGN cValue = REPLACE(cValue, ",", ".").

    ASSIGN cValue = TRIM(cValue).

    /* OPCAO DE IMPRIMIR LAYOUT XML OU EM TXT */
    IF  lLayoutXML THEN
        RUN addNode  IN hGenXml (getStack(), "{1}", cValue, OUTPUT iId).
    ELSE
    IF  lLayoutTXT THEN DO:

        ASSIGN cValue = (IF {2} = ?
                         THEN " "
                         ELSE cValue).

        PUT UNFORMATTED cValue "|".
    END.

END.
