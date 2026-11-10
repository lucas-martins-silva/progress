&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : bc0103.i
    Purpose     : Manipulaá∆o dos campos de impress∆o da tabela tipo-etiqueta

    Description : ContÇm piÔs para leitura, validaá∆o e gravaá∆o dos campos:
                  - ind-tipo-destino
                  - cod-layout-impres   entry(1, char-1, chr(10))
                  - nom-impressora      entry(2, char-1, chr(10))
                  - documento-layout    entry(1, char-2, chr(10))
                  - impressora-windows  entry(2, char-2, chr(10))

    Author(s)   : Alcides Schulz
    Created     : Nov/2000
    Notes       : - Na vers∆o 2.02, 2.03 e 2.04 os campos est∆o em 
                    char-1 e char-2
                  - Na 2.05 em diante s∆o usados campos pr¢prios
                  - nom-impressora pode estar como '' para manter 
                    compatibilidade com vers∆o antiga.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* variaveis de trabalho para o programa que usa o include -------------*/
DEF VAR i-tipo-destino  AS INTEGER   NO-UNDO.
DEF VAR c-layout-ems    AS CHARACTER NO-UNDO.
DEF VAR c-impres-ems    AS CHARACTER NO-UNDO.
DEF VAR c-doc-msword    AS CHARACTER NO-UNDO.
DEF VAR c-imp-windows   AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-obtem-campos-impressao Include 
PROCEDURE pi-obtem-campos-impressao :
/*------------------------------------------------------------------------------
  Purpose:     Le no parametro buffer os campos referentes a impressao. 
  Parameters:  buffer do tipo-etiqueta
               output tipo-destino (1-Arquivo, 2-ImpressoraEMS, 3-msword
               output impressora-ems (pode ser branco)
               output layout-ems
               output doc-msword
               output impressora-windows
  Notes:       No EMS 2.02 e 2.03 Ç preciso ler os campos char-1 e char-2
               No EMS 2.04 em diante tem campos pr¢prios
------------------------------------------------------------------------------*/
    
   DEF PARAM BUFFER b-tipo-etiq    FOR tipo-etiqueta.
   DEF OUTPUT PARAM p-tipo-destino AS INTEGER   NO-UNDO.
   DEF OUTPUT PARAM p-impres-ems   AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM p-layout-ems   AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM p-doc-msword   AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM p-imp-windows  AS CHARACTER NO-UNDO.

   /* Se n∆o tiver buffer definido retorna valores default ------------------*/
   IF NOT AVAIL b-tipo-etiq THEN DO:
      p-tipo-destino = 1.
      p-layout-ems   = '':U.
      p-impres-ems   = '':U.
      p-doc-msword   = '':U.
      p-imp-windows  = '':U.
      RETURN.
   END.
    
   p-tipo-destino = b-tipo-etiq.ind-tipo-destino.
   p-layout-ems   = b-tipo-etiq.cod-layout-impres.
   p-impres-ems   = b-tipo-etiq.cod-impressora.
   p-doc-msword   = b-tipo-etiq.documento-layout.
   p-imp-windows  = b-tipo-etiq.impressora-windows.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salva-campos-impressao Include 
PROCEDURE pi-salva-campos-impressao :
/*------------------------------------------------------------------------------
  Purpose:     Salva no parametro buffer os campos referentes a impressao.
  Parameters:  Buffer de tipo-etiqueta para ser gravado
               tipo-destino: 1-arquivo, 2-impressora ems, 3-msword
               impress-ems
               layout-ems
               doc-msword
               imp-windows
  Notes:       No EMS 2.02 e 2.03 s∆o usados os campos char-1 e char-2
               No EMS 2.04 em diante tem campos pr¢prios
------------------------------------------------------------------------------*/

   DEF PARAM BUFFER b-tipo-etiq   FOR tipo-etiqueta.
   DEF INPUT PARAM p-tipo-destino AS INTEGER   NO-UNDO.
   DEF INPUT PARAM p-impres-ems   AS CHARACTER NO-UNDO.
   DEF INPUT PARAM p-layout-ems   AS CHARACTER NO-UNDO.
   DEF INPUT PARAM p-doc-msword   AS CHARACTER NO-UNDO.
   DEF INPUT PARAM p-imp-windows  AS CHARACTER NO-UNDO.

   b-tipo-etiq.ind-tipo-destino = p-tipo-destino.
   CASE p-tipo-destino:
      WHEN 1 THEN DO: /* Arquivo */
         b-tipo-etiq.cod-layout-impres  = '':U.
         b-tipo-etiq.cod-impressora     = '':U.
         b-tipo-etiq.documento-layout   = '':U.
         b-tipo-etiq.impressora-windows = '':U.
      END.
      WHEN 2 THEN DO: /* Impress∆o EMS */
         b-tipo-etiq.cod-layout-impres  = p-layout-ems.
         b-tipo-etiq.cod-impressora     = p-impres-ems.
         b-tipo-etiq.documento-layout   = '':U.
         b-tipo-etiq.impressora-windows = '':U.
      END.
      WHEN 3 THEN DO: /* MSWord */
         b-tipo-etiq.cod-layout-impres  = '':U.
         b-tipo-etiq.cod-impressora     = '':U.
         b-tipo-etiq.documento-layout   = p-doc-msword.
         b-tipo-etiq.impressora-windows = p-imp-windows.
      END.
      WHEN 4 THEN DO: /* Libre */
         b-tipo-etiq.cod-layout-impres  = '':U.
         b-tipo-etiq.cod-impressora     = '':U.
         b-tipo-etiq.documento-layout   = p-doc-msword.
         b-tipo-etiq.impressora-windows = p-imp-windows.
      END.
      END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-impressao-ems Include 
PROCEDURE pi-valida-impressao-ems :
/*------------------------------------------------------------------------------
  Purpose:     Valida os campos impressora-ems e layout-impress
  Parameters:  <none>
  Notes:       Retorna 'ok' ou 'nok'. Mostra mensagem em caso de erro.
------------------------------------------------------------------------------*/

   DEF INPUT PARAM p-impres-ems  AS CHARACTER NO-UNDO.
   DEF INPUT PARAM p-layout-ems  AS CHARACTER NO-UNDO.
            
   /* Aceita impressora em branco (comportamento antigo), valida layout. */
   IF p-impres-ems = '':U THEN DO:        
      FIND FIRST layout_impres
           WHERE layout_impres.cod_layout_impres = p-layout-ems NO-LOCK NO-ERROR.
      IF NOT AVAIL layout_impres THEN DO:
         {utp/ut-table.i mguni layout_impres 1}
         RUN utp/ut-msgs.p ("SHOW":U, 2, TRIM(RETURN-VALUE)).
         RETURN "NOK":U.
      END.
   END.
   ELSE DO:
      /* Valida impressora e layout juntos --------------------------------*/
      FIND FIRST layout_impres
           WHERE layout_impres.nom_impressora    = p-impres-ems
             AND layout_impres.cod_layout_impres = p-layout-ems NO-LOCK NO-ERROR.
      IF NOT AVAIL layout_impres THEN DO:
         {utp/ut-table.i mguni layout_impres 1}
         RUN utp/ut-msgs.p ("SHOW":U, 2, TRIM(RETURN-VALUE)).
         RETURN "NOK":U.
      END.
   END.
    
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-msword Include 
PROCEDURE pi-valida-msword :
/*------------------------------------------------------------------------------
  Purpose:     Valida os campos para impress∆o via msword
  Parameters:  <none>
  Notes:       Verifica se o arquivo existe. 
               Em caso de erro mostra mensagem e retorna 'nok'
------------------------------------------------------------------------------*/

   DEF INPUT PARAM p-doc-msword  AS CHARACTER NO-UNDO.
   DEF INPUT PARAM p-imp-windows AS CHARACTER NO-UNDO.

   DEF VAR h-merge AS HANDLE    NO-UNDO.
   DEF VAR c-dir   AS CHARACTER NO-UNDO.

   /* N∆o pode ser branco ---------------------------------------------------*/
   IF p-doc-msword = "":U THEN DO:
      {utp/ut-liter.i "Documento Layout"}
      RUN utp/ut-msgs.p ("SHOW":U, 164, TRIM(RETURN-VALUE)).
      RETURN "NOK":U.
   END.
    
   /* Deve informar diret¢rio v†lido ----------------------------------------*/
   IF INDEX(REPLACE(p-doc-msword, "~\":U, "/":U), "/") = 0 THEN DO:
      RUN utp/ut-msgs.p ("show":U, 25879, "":U).
      RETURN "NOK":U.
   END.
   c-dir = SUBSTR(p-doc-msword, 1, R-INDEX(REPLACE(p-doc-msword, "~\":U, "/":U), "/") - 1).
   FILE-INFO:FILE-NAME = c-dir.
   IF FILE-INFO:FULL-PATHNAME = ?
   OR INDEX(FILE-INFO:FILE-TYPE, "d":U) = 0 
   OR INDEX(FILE-INFO:FILE-TYPE, "w":U) = 0 THEN DO:
      RUN utp/ut-msgs.p ("show":U, 25879, c-dir).
      RETURN "NOK":U.
   END.
    
   /* verifica se documento word existe -------------------------------------*/
   FILE-INFO:FILE-NAME = p-doc-msword.
   IF FILE-INFO:FULL-PATHNAME = ?
   OR INDEX(FILE-INFO:FILE-TYPE, 'f') = 0 THEN DO:

      /* pergunta se deseja criar o documento ------------------------------*/
      RUN utp/ut-msgs.p ('show':U, 25733, p-doc-msword).
      IF RETURN-VALUE = "NO":U THEN
         RETURN "NOK":U.
        
      /* cria novo documento -----------------------------------------------*/
      RUN utp/utapi020.p PERSISTENT SET h-merge.
      RUN iniciaMerge IN h-merge.
      IF RETURN-VALUE = "NOK":U THEN DO:
         DELETE PROCEDURE h-merge.
         RETURN RETURN-VALUE.
      END.
      RUN defineAcompanhamento in h-merge (yes).
      RUN defineMostraErro in h-merge (yes).
      RUN criaDocumento in h-merge (p-doc-msword).
      IF RETURN-VALUE = "NOK":U THEN DO:
         DELETE PROCEDURE h-merge.
         RETURN RETURN-VALUE.
      END.
      RUN encerraAutomation IN h-merge (YES).
      DELETE PROCEDURE h-merge.
   END.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-libre Include 
PROCEDURE pi-valida-libre :
/*------------------------------------------------------------------------------
  Purpose:     Valida os campos para impress∆o via msword
  Parameters:  <none>
  Notes:       Verifica se o arquivo existe. 
               Em caso de erro mostra mensagem e retorna 'nok'
------------------------------------------------------------------------------*/

   DEF INPUT PARAM p-doc-msword  AS CHARACTER NO-UNDO.
   DEF INPUT PARAM p-imp-windows AS CHARACTER NO-UNDO.

   DEF VAR h-merge AS HANDLE    NO-UNDO.
   DEF VAR c-dir   AS CHARACTER NO-UNDO.

   /* N∆o pode ser branco ---------------------------------------------------*/
   IF p-doc-msword = "":U THEN DO:
      {utp/ut-liter.i "Documento Layout"}
      RUN utp/ut-msgs.p ("SHOW":U, 164, TRIM(RETURN-VALUE)).
      RETURN "NOK":U.
   END.
    
    /* Deve informar diret¢rio v†lido ----------------------------------------*/
   IF INDEX(REPLACE(p-doc-msword, "~\":U, "/":U), "/") = 0 THEN DO:
      RUN utp/ut-msgs.p ("show":U, 25879, "":U).
      RETURN "NOK":U.
   END.
   c-dir = SUBSTR(p-doc-msword, 1, R-INDEX(REPLACE(p-doc-msword, "~\":U, "/":U), "/") - 1).
   FILE-INFO:FILE-NAME = c-dir.
   IF FILE-INFO:FULL-PATHNAME = ?
   OR INDEX(FILE-INFO:FILE-TYPE, "d":U) = 0 
   OR INDEX(FILE-INFO:FILE-TYPE, "w":U) = 0 THEN DO:
      RUN utp/ut-msgs.p ("show":U, 25879, c-dir).
      RETURN "NOK":U.
   END.
    
   /* verifica se documento word existe -------------------------------------*/
   FILE-INFO:FILE-NAME = p-doc-msword.
   IF FILE-INFO:FULL-PATHNAME = ?
   OR INDEX(FILE-INFO:FILE-TYPE, 'f') = 0 THEN DO:
      {utp/ut-liter.i "Documento_LibreOffice" *}
      RUN utp/ut-msgs.p ('show':U, 56, RETURN-VALUE).
      RETURN "NOK":U.
   END.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


