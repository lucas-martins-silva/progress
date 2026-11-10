/********************************************************************************
** Copyright DATASUL S.A. (2023)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPIIMP 2.00.00.002 } /*** "010002" 03/07/2023 10:43:21  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPIIMP MUT}
&ENDIF

PROCEDURE piSelecionaImpressora:

   DEFINE INPUT PARAMETER pCodUsuario LIKE usuario-scm.usuario NO-UNDO.
   DEFINE VARIABLE cPrintTmp AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cPrint    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE lstPrint  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE ix        AS INTEGER   NO-UNDO.

   FIND FIRST usuario-scm 
        WHERE usuario-scm.usuario = pCodUsuario NO-LOCK NO-ERROR.
   IF AVAIL usuario-scm THEN DO:
      /* pega a lista de impressoras */
      ASSIGN lstPrint = SESSION:GET-PRINTERS().
   
      /* pega a 1a. impressora que nao for FAX, PDF ou OneNote */    
      DO  ix = 1 TO NUM-ENTRIES(lstPrint):
         ASSIGN cPrintTmp = ENTRY(ix, lstPrint).
         IF cPrintTmp = usuario-scm.impressora THEN DO:
            ASSIGN cPrint = cPrintTmp.
            LEAVE.
         END.
      END.
      IF  cPrint <> ? AND cPrint <> "" THEN
         SESSION:PRINTER-NAME = cPrint NO-ERROR. 
   END.
   RETURN "OK":U.
END PROCEDURE.
       
