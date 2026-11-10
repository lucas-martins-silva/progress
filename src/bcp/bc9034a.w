&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS D-Dialog 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9034A 2.00.00.006 } /*** "010006" 31/08/2023 15:08:06  ***/

/*------------------------------------------------------------------------

  File: 

  Description: from cntnrdlg.w - ADM SmartDialog Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER h-handleParam    AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER h-handleSon      AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER ipdeNrTrans      AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER iopcDetail       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER ioprTransContent AS RAW        NO-UNDO.
DEFINE INPUT PARAMETER ioplDelete       AS LOGICAL    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-cod-var-ems AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-valor-var   AS CHARACTER  NO-UNDO.

/* Temp-table Definitions ---                                           */
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD i-nr-trans       AS INT 
    FIELD i-sequencia      AS INT 
    FIELD c-cod-var-ems    AS CHAR             
    FIELD c-valor-var      AS CHAR
    INDEX ind-cod IS UNIQUE PRIMARY i-nr-trans i-sequencia.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog
&Scoped-define BROWSE-NAME br-variaveis

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-digita

/* Definitions for BROWSE br-variaveis                                   */
&Scoped-define FIELDS-IN-QUERY-br-variaveis tt-digita.c-cod-var-ems tt-digita.c-valor-var
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-variaveis tt-digita.c-valor-var
&Scoped-define QUERY-STRING-br-variaveis FOR EACH tt-digita EXCLUSIVE-LOCK
&Scoped-define OPEN-QUERY-br-variaveis OPEN QUERY br-variaveis FOR EACH tt-digita EXCLUSIVE-LOCK
&Scoped-define TABLES-IN-QUERY-br-variaveis tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-br-variaveis tt-digita

/* Definitions for DIALOG-BOX D-Dialog                                  
&Scoped-define OPEN-BROWSERS-IN-QUERY-D-Dialog ~
    ~{&OPEN-QUERY-br-variaveis}
&Scoped-define QUERY-STRING-D-Dialog FOR EACH tt-digita NO-LOCK
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH tt-digita NO-LOCK
&Scoped-define TABLES-IN-QUERY-D-Dialog tt-digita
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog tt-digita                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-10 RECT-11 rt-buttom c-cod-trans ~
c-estado i-nr-trans d-data c-cod-equipamento c-hora br-variaveis bt-ok ~
bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-cod-trans c-estado i-nr-trans d-data ~
c-cod-equipamento c-hora c-texto-detalhes c-texto-variaveis 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-trans AS CHARACTER FORMAT "x(8)" 
     LABEL "C¢digo Transa‡Æo":R20 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .96 NO-UNDO.

DEFINE VARIABLE i-nr-trans AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Nr Transa‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .96 NO-UNDO.

DEFINE VARIABLE c-cod-equipamento AS CHARACTER FORMAT "x(256)" 
     LABEL "Equipamento":R20 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .96 NO-UNDO.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "x(8)" 
     LABEL "Estado":R20 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .96 NO-UNDO.

DEFINE VARIABLE c-hora AS CHARACTER FORMAT "x(08)" 
     LABEL "Hora Atualiza‡Æo":R18 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .96 NO-UNDO.

DEFINE VARIABLE d-data AS DATE FORMAT "99/99/9999" 
     LABEL "Data Atualiza‡Æo":R20 
     VIEW-AS FILL-IN 
     SIZE 12.29 BY .96 NO-UNDO.

DEFINE VARIABLE c-texto-detalhes AS CHARACTER FORMAT "X(256)":U INITIAL "Detalhes da Transa‡Æo" 
     VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto-variaveis AS CHARACTER FORMAT "X(256)":U INITIAL "Vari veis da Transa‡Æo" 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 9.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.14 BY 4.17.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80.86 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND    
DEFINE QUERY br-variaveis FOR 
      tt-digita SCROLLING.

/*DEFINE QUERY D-Dialog FOR 
      tt-digita SCROLLING.
&ANALYZE-RESUME*/

/* Browse definitions                                                   */
DEFINE BROWSE br-variaveis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-variaveis D-Dialog _STRUCTURED
  QUERY br-variaveis NO-LOCK DISPLAY
        tt-digita.c-cod-var-ems FORMAT "X(256)":U WIDTH 20.43
        tt-digita.c-valor-var   FORMAT "X(256)":U WIDTH 53.72
    ENABLE
        tt-digita.c-valor-var 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 78 BY 8 ROW-HEIGHT-CHARS .67 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-cod-trans AT ROW 2.17 COL 23.57 COLON-ALIGNED
     c-estado AT ROW 2.21 COL 59.43 COLON-ALIGNED
     i-nr-trans AT ROW 3.29 COL 23.57 COLON-ALIGNED
     d-data AT ROW 3.38 COL 59.57 COLON-ALIGNED
     c-cod-equipamento AT ROW 4.46 COL 23.57 COLON-ALIGNED NO-TAB-STOP 
     c-hora AT ROW 4.54 COL 59.57 COLON-ALIGNED
     br-variaveis AT ROW 7 COL 3
     bt-ok AT ROW 15.79 COL 2.72
     bt-cancela AT ROW 15.79 COL 13.72
     bt-ajuda AT ROW 15.79 COL 71.57
     c-texto-detalhes AT ROW 1.21 COL 1 COLON-ALIGNED NO-LABEL
     c-texto-variaveis AT ROW 5.92 COL 1 COLON-ALIGNED NO-LABEL
     RECT-10 AT ROW 6.25 COL 2
     RECT-11 AT ROW 1.58 COL 1.86
     rt-buttom AT ROW 15.54 COL 1.72
     SPACE(0.41) SKIP(0.32)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Detalhes do Equipamento"
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
/* BROWSE-TAB br-variaveis c-hora D-Dialog */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

ASSIGN 
       c-cod-trans:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       c-estado:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       c-cod-equipamento:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       c-hora:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* SETTINGS FOR FILL-IN c-texto-detalhes IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto-variaveis IN FRAME D-Dialog
   NO-ENABLE                                                            */
ASSIGN 
       d-data:READ-ONLY IN FRAME D-Dialog        = TRUE.

ASSIGN 
       i-nr-trans:AUTO-RESIZE IN FRAME D-Dialog      = TRUE
       i-nr-trans:READ-ONLY IN FRAME D-Dialog        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-variaveis
/* Query rebuild information for BROWSE br-variaveis
     _TblList          = "mgcld.bc-trans-filho OF mgcld.bc-trans"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > mgcld.bc-trans-filho.conteudo-trans
"bc-trans-filho.conteudo-trans" ? ? "character" ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" ""
     _FldNameList[2]   > mgcld.bc-trans-filho.nr-trans
"bc-trans-filho.nr-trans" ? ? "decimal" ? ? ? ? ? ? no ? no no "53.72" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE br-variaveis */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _TblList          = "mgcld.bc-trans"
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 
/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Detalhes do Equipamento */
DO:  
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR.
   /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
   APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda D-Dialog
ON CHOOSE OF bt-ajuda IN FRAME D-Dialog /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
   DO WITH FRAME {&frame-name}:
      RUN SalvarAlteracoes.        
   END.
   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piLibWindow IN h-handleParam NO-ERROR. 
   APPLY "GO" TO FRAME {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-variaveis D-Dialog
ON ENTER OF br-variaveis IN FRAME D-Dialog
ANYWHERE
DO:
  
END.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-variaveis D-Dialog
ON ROW-LEAVE OF br-variaveis IN FRAME D-Dialog
DO:

END.


&Scoped-define BROWSE-NAME br-variaveis
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK D-Dialog 


/* ***************************  Main Block  *************************** */

{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

   /* Define variables needed by this internal procedure.             */
   {src/adm/template/row-head.i}

   /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
   {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
   /* Hide all frames. */
   HIDE FRAME D-Dialog.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
   DISPLAY c-cod-trans c-estado i-nr-trans d-data c-cod-equipamento c-hora 
           c-texto-detalhes c-texto-variaveis 
      WITH FRAME D-Dialog.
   ENABLE RECT-10 RECT-11 rt-buttom c-cod-trans c-estado i-nr-trans d-data 
          c-cod-equipamento c-hora br-variaveis bt-ok bt-cancela bt-ajuda 
      WITH FRAME D-Dialog.
   VIEW FRAME D-Dialog.
   {&OPEN-BROWSERS-IN-QUERY-D-Dialog}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy D-Dialog 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */
   IF VALID-HANDLE(gh-bofn068) THEN DO:
      DELETE PROCEDURE gh-bofn068 NO-ERROR.
      ASSIGN gh-bofn068 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn088) THEN DO:
      DELETE PROCEDURE gh-bofn088 NO-ERROR.
      ASSIGN gh-bofn088 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn116) THEN DO:
      DELETE PROCEDURE gh-bofn116 NO-ERROR.
      ASSIGN gh-bofn116 = ?.
   END.
   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable D-Dialog 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   IF VALID-HANDLE(h-handleParam) AND STRING(h-handleParam) <> "0" THEN
      RUN piBloqWindow IN h-handleParam NO-ERROR. 

   IF ioplDelete = YES THEN DO:
      FOR EACH  bc-trans-erros EXCLUSIVE-LOCK
          WHERE bc-trans-erros.nr-trans = ipdeNrTrans:
         DELETE bc-trans-erros.
      END.
   END.

   ASSIGN i-nr-trans = ipdeNrTrans.
    
{utp/ut9000.i "BC9034A" "2.00.00.006"} /* 31/08/2023 15:08:06 */

   {utp/ut-field.i mgcld bc-trans cd-trans         1}
   ASSIGN c-cod-trans:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).

   {utp/ut-field.i mgcld bc-trans nr-trans         1}
   ASSIGN i-nr-trans:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
   
   {utp/ut-field.i mgcld bc-trans data-atualizacao 1}
   ASSIGN d-data:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).

   {utp/ut-field.i mgcld bc-trans hora-atualizacao 1}
   ASSIGN c-hora:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).

   {utp/ut-liter.i "Equipamento" MBC R}
   ASSIGN c-cod-equipamento:LABEL IN FRAME {&frame-name} = TRIM(RETURN-VALUE).

   {utp/ut-liter.i "Vari veis do Equipamento" MBC R}
   ASSIGN c-texto-variaveis:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).
    
   {utp/ut-liter.i "Detalhes do Equipamento" MBC R}
   ASSIGN c-texto-detalhes:SCREEN-VALUE IN FRAME {&frame-name} = TRIM(RETURN-VALUE).

   RUN CarregarVariaveis IN THIS-PROCEDURE.

   OPEN QUERY br-variaveis
      FOR EACH tt-digita EXCLUSIVE-LOCK.

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

   /* Define variables needed by this internal procedure.               */
   {src/adm/template/snd-head.i}

   /* For each requested table, put it's ROWID in the output list.      */
   {src/adm/template/snd-list.i "bc-trans-filho"}
   {src/adm/template/snd-list.i "bc-trans"}

   /* Deal with any unexpected table requests before closing.           */
   {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed D-Dialog 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
  
   RUN pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


PROCEDURE CarregarVariaveis :

   FIND FIRST bc-trans NO-LOCK
        WHERE bc-trans.nr-trans = ipdeNrTrans NO-ERROR.
   IF AVAILABLE bc-trans THEN DO:
      ASSIGN c-cod-trans = bc-trans.cd-trans
             d-data      = (IF bc-trans.data-atualizacao = ? THEN bc-trans.data ELSE bc-trans.data-atualizacao)
             c-hora      = (IF bc-trans.hora-atualizacao = "":U OR bc-trans.hora-atualizacao = ? THEN bc-trans.horario ELSE bc-trans.hora-atualizacao)
             c-estado    = ENTRY(bc-trans.estado-trans,{clinc/i01cl012.i 03}).

      IF bc-trans.estado-trans = 2 THEN
         br-variaveis:READ-ONLY IN FRAME D-Dialog = YES.

      FOR EACH  bc-trans-filho NO-LOCK
          WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans:

         ASSIGN c-cod-equipamento = ENTRY(1,bc-trans-filho.conteudo-trans,CHR(30))
                c-cod-var-ems     = ENTRY(2,bc-trans-filho.conteudo-trans,CHR(30))
                c-valor-var       = ENTRY(3,bc-trans-filho.conteudo-trans,CHR(30)).

         CREATE tt-digita.

         FIND FIRST tt-digita NO-ERROR.
            ASSIGN tt-digita.i-nr-trans    = bc-trans.nr-trans
                   tt-digita.i-sequencia   = bc-trans-filho.sequencia
                   tt-digita.c-cod-var-ems = c-cod-var-ems
                   tt-digita.c-valor-var   = c-valor-var.
      END.
   END.

END PROCEDURE.

                
PROCEDURE SalvarAlteracoes :

   DEFINE VARIABLE c-cod-equipamento-aux AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE c-cod-var-ems-aux     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE c-valor-var-aux       AS CHARACTER  NO-UNDO.

   FOR EACH tt-digita:    
      FOR EACH bc-trans-filho WHERE bc-trans-filho.nr-trans = tt-digita.i-nr-trans EXCLUSIVE-LOCK:
         ASSIGN c-cod-equipamento-aux = ENTRY(1,bc-trans-filho.conteudo-trans,CHR(30))
                c-cod-var-ems-aux     = ENTRY(2,bc-trans-filho.conteudo-trans,CHR(30)) 
                c-valor-var-aux       = ENTRY(3,bc-trans-filho.conteudo-trans,CHR(30)).
             
         IF tt-digita.c-cod-var-ems = c-cod-var-ems-aux THEN DO:                
            ASSIGN bc-trans-filho.conteudo-trans = c-cod-equipamento-aux + CHR(30) + c-cod-var-ems-aux + CHR(30) + tt-digita.c-valor-var.
         END.
            
      END.
   END.
  
END PROCEDURE.
