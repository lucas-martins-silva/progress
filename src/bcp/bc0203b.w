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
{include/i-prgvrs.i BC0203B 2.00.00.019}  /*** "010019" 31/08/2023 15:08:04  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0203B MBC}
&ENDIF


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

/* Local Variable Definitions ---                                       */

DEF INPUT        PARAM cProgChamador    AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM c-cdtrans-ini    AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM c-cdtrans-fim    AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM de-trans-ini-ent AS DECIMAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM de-trans-fim-ent AS DECIMAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM da-trans-ini-ent AS DATE      NO-UNDO.
DEF INPUT-OUTPUT PARAM da-trans-fim-ent AS DATE      NO-UNDO.
DEF INPUT-OUTPUT PARAM hr-trans-ini-ent AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM hr-trans-fim-ent AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM c-usu-ini-ent    AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM c-usu-fim-ent    AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM da-atu-ini-ent   AS DATE      NO-UNDO.
DEF INPUT-OUTPUT PARAM da-atu-fim-ent   AS DATE      NO-UNDO.
DEF INPUT-OUTPUT PARAM hr-atu-ini-ent   AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM hr-atu-fim-ent   AS CHARACTER NO-UNDO.
DEF INPUT-OUTPUT PARAM l-nova           AS LOGICAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM l-atualizada     AS LOGICAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM l-erro           AS LOGICAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM l-em-proces      AS LOGICAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM l-cancelado      AS LOGICAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM l-movimento      AS LOGICAL   NO-UNDO.
DEF INPUT-OUTPUT PARAM l-etiqueta       AS LOGICAL   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE NO

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES bc-trans

/* Definitions for DIALOG-BOX D-Dialog                                  */
&Scoped-define OPEN-QUERY-D-Dialog OPEN QUERY D-Dialog FOR EACH bc-trans NO-LOCK.
&Scoped-define TABLES-IN-QUERY-D-Dialog bc-trans
&Scoped-define FIRST-TABLE-IN-QUERY-D-Dialog bc-trans


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tg-nova tg-atualizada tg-erro tg-em-proces ~
tg-cancelado c-trans-ini c-trans-fim i-trans-ini i-trans-fim da-trans-ini ~
da-trans-fim hr-trans-ini hr-trans-fim c-usu-ini c-usu-fim tg-movimento ~
tg-etiqueta bt-ok bt-cancela bt-ajuda IMAGE-1 IMAGE-10 IMAGE-11 IMAGE-12 ~
IMAGE-13 IMAGE-14 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 ~
IMAGE-9 RECT-10 RECT-11 RECT-14 rt-buttom 
&Scoped-Define DISPLAYED-OBJECTS tg-nova tg-atualizada tg-erro tg-em-proces ~
tg-cancelado c-trans-ini c-trans-fim i-trans-ini i-trans-fim da-trans-ini ~
da-trans-fim hr-trans-ini hr-trans-fim c-usu-ini c-usu-fim da-atu-ini ~
da-atu-fim hr-atu-ini hr-atu-fim tg-movimento tg-etiqueta c-texto1 c-texto2 

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

DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo de Movimento" 
      VIEW-AS TEXT 
     SIZE 23 BY .67 NO-UNDO.

DEFINE VARIABLE c-trans-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-trans-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Cod.Transa‡Æo Inicial" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-usu-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-usu-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usuario Inicial" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE da-atu-fim AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE da-atu-ini AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt.Atualiz Inicial" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE da-trans-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE da-trans-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/00 
     LABEL "Data Inicial" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE hr-atu-fim AS CHARACTER FORMAT "99:99:99":U 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE hr-atu-ini AS CHARACTER FORMAT "99:99:99":U 
     LABEL "Hora Atualiz Inicial" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE hr-trans-fim AS CHARACTER FORMAT "99:99:99":U INITIAL "999999" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE hr-trans-ini AS CHARACTER FORMAT "99:99:99":U INITIAL "000000" 
     LABEL "Hora Inicial" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-trans-fim AS DECIMAL FORMAT "9999999999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE i-trans-ini AS DECIMAL FORMAT "9999999999":U INITIAL 0 
     LABEL "Nr.Transa‡Æo Inicial" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY 7.75.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY 2.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.86 BY 1.67.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80.86 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-atualizada AS LOGICAL INITIAL YES 
     LABEL "Atualizada" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-cancelado AS LOGICAL INITIAL YES 
     LABEL "Cancelado" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-em-proces AS LOGICAL INITIAL YES 
     LABEL "Em Processo" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-erro AS LOGICAL INITIAL YES 
     LABEL "Com Erro" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-etiqueta AS LOGICAL INITIAL YES 
     LABEL "Etiqueta" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE tg-movimento AS LOGICAL INITIAL YES 
     LABEL "Transa‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .75 NO-UNDO.

DEFINE VARIABLE tg-nova AS LOGICAL INITIAL YES 
     LABEL "Nova" 
     VIEW-AS TOGGLE-BOX
     SIZE 12 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY D-Dialog FOR 
      bc-trans SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     tg-nova AT ROW 1.96 COL 4
     tg-atualizada AT ROW 1.96 COL 17
     tg-erro AT ROW 1.96 COL 34
     tg-em-proces AT ROW 1.96 COL 50
     tg-cancelado AT ROW 1.96 COL 68.14
     c-trans-ini AT ROW 4 COL 27 COLON-ALIGNED
     c-trans-fim AT ROW 4 COL 51 COLON-ALIGNED NO-LABEL
     i-trans-ini AT ROW 5 COL 27 COLON-ALIGNED
     i-trans-fim AT ROW 5 COL 51 COLON-ALIGNED NO-LABEL
     da-trans-ini AT ROW 6 COL 27 COLON-ALIGNED
     da-trans-fim AT ROW 6 COL 51 COLON-ALIGNED NO-LABEL
     hr-trans-ini AT ROW 7 COL 27 COLON-ALIGNED
     hr-trans-fim AT ROW 7 COL 51 COLON-ALIGNED NO-LABEL
     c-usu-ini AT ROW 8 COL 27 COLON-ALIGNED
     c-usu-fim AT ROW 8 COL 51 COLON-ALIGNED NO-LABEL
     da-atu-ini AT ROW 9 COL 27 COLON-ALIGNED
     da-atu-fim AT ROW 9 COL 51 COLON-ALIGNED NO-LABEL
     hr-atu-ini AT ROW 10 COL 27 COLON-ALIGNED
     hr-atu-fim AT ROW 10 COL 51 COLON-ALIGNED NO-LABEL
     tg-movimento AT ROW 12 COL 21.86
     tg-etiqueta AT ROW 12 COL 48.86
     bt-ok AT ROW 13.5 COL 3
     bt-cancela AT ROW 13.5 COL 14
     bt-ajuda AT ROW 13.5 COL 71.86
     c-texto1 AT ROW 1 COL 2 COLON-ALIGNED NO-LABEL
     c-texto2 AT ROW 11.25 COL 1.86 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 4 COL 46
     IMAGE-10 AT ROW 7 COL 50
     IMAGE-11 AT ROW 8 COL 50
     IMAGE-12 AT ROW 9 COL 50
     IMAGE-13 AT ROW 10 COL 50
     IMAGE-14 AT ROW 10 COL 46
     IMAGE-2 AT ROW 4 COL 50
     IMAGE-3 AT ROW 5 COL 46
     IMAGE-4 AT ROW 6 COL 46
     IMAGE-5 AT ROW 7 COL 46
     IMAGE-6 AT ROW 8 COL 46
     IMAGE-7 AT ROW 9 COL 46
     IMAGE-8 AT ROW 5 COL 50
     IMAGE-9 AT ROW 6 COL 50
     RECT-10 AT ROW 3.5 COL 2
     RECT-11 AT ROW 1.25 COL 2
     RECT-14 AT ROW 11.5 COL 2
     rt-buttom AT ROW 13.25 COL 2
     SPACE(0.13) SKIP(0.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Parƒmetros"
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
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-texto1 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-atu-fim IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-atu-ini IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN hr-atu-fim IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN hr-atu-ini IN FRAME D-Dialog
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Parƒmetros */
DO:  
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
   DO WITH FRAME {&FRAME-NAME}:
      ASSIGN c-cdtrans-ini    = INPUT c-trans-ini
             c-cdtrans-fim    = INPUT c-trans-fim
             de-trans-ini-ent = INPUT i-trans-ini
             de-trans-fim-ent = INPUT i-trans-fim
             da-trans-ini-ent = INPUT da-trans-ini
             da-trans-fim-ent = INPUT da-trans-fim
             hr-trans-ini-ent = hr-trans-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             hr-trans-fim-ent = hr-trans-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             c-usu-ini-ent    = INPUT c-usu-ini
             c-usu-fim-ent    = INPUT c-usu-fim
             da-atu-ini-ent   = INPUT da-atu-ini
             da-atu-fim-ent   = INPUT da-atu-fim
             hr-atu-ini-ent   = hr-atu-ini:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             hr-atu-fim-ent   = hr-atu-fim:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             l-nova           = tg-nova:CHECKED
             l-atualizada     = tg-atualizada:CHECKED
             l-erro           = tg-erro:CHECKED
             l-em-proces      = tg-em-proces:CHECKED
             l-cancelado      = tg-cancelado:CHECKED
             l-etiqueta       = tg-etiqueta:CHECKED
             l-movimento      = tg-movimento:CHECKED.
   END.
   APPLY "GO" TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-atualizada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-atualizada D-Dialog
ON VALUE-CHANGED OF tg-atualizada IN FRAME D-Dialog /* Atualizada */
DO:
   ASSIGN da-atu-ini:SENSITIVE = (tg-atualizada:CHECKED OR tg-erro:CHECKED)
          da-atu-fim:SENSITIVE = (tg-atualizada:CHECKED OR tg-erro:CHECKED)
          hr-atu-ini:SENSITIVE = (tg-atualizada:CHECKED OR tg-erro:CHECKED)
          hr-atu-fim:SENSITIVE = (tg-atualizada:CHECKED OR tg-erro:CHECKED).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
   DISPLAY tg-nova
           tg-atualizada
           tg-erro
           tg-em-proces
           tg-cancelado
           c-trans-ini 
           c-trans-fim
           i-trans-ini
           i-trans-fim
           da-trans-ini
           da-trans-fim 
           hr-trans-ini
           hr-trans-fim 
           c-usu-ini
           c-usu-fim
           da-atu-ini
           da-atu-fim 
           hr-atu-ini
           hr-atu-fim
           tg-movimento
           tg-etiqueta
           c-texto1
           c-texto2 
       WITH FRAME D-Dialog.
   
   ENABLE tg-nova
          tg-atualizada
          tg-erro
          tg-em-proces
          tg-cancelado
          c-trans-ini 
          c-trans-fim
          i-trans-ini
          i-trans-fim
          da-trans-ini
          da-trans-fim 
          hr-trans-ini
          hr-trans-fim
          c-usu-ini
          c-usu-fim
          tg-movimento
          tg-etiqueta 
          bt-ok
          bt-cancela
          bt-ajuda
          IMAGE-1
          IMAGE-10
          IMAGE-11
          IMAGE-12
          IMAGE-13 
          IMAGE-14
          IMAGE-2
          IMAGE-3
          IMAGE-4
          IMAGE-5
          IMAGE-6
          IMAGE-7
          IMAGE-8 
          IMAGE-9
          RECT-10
          RECT-11
          RECT-14
          rt-buttom 
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

   IF cProgChamador = "BC0203" THEN 
      DISABLE c-trans-ini
              c-trans-fim
         WITH FRAME {&FRAME-NAME}.

   /* Code placed here will execute AFTER standard behavior.    */
   IF tg-atualizada:CHECKED IN FRAME {&FRAME-NAME} THEN
      ENABLE da-atu-ini 
             da-atu-fim
             hr-atu-ini
             hr-atu-fim
         WITH FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN c-trans-ini    = c-cdtrans-ini
          c-trans-fim    = c-cdtrans-fim
          i-trans-ini    = de-trans-ini-ent
          i-trans-fim    = de-trans-fim-ent
          da-trans-ini   = da-trans-ini-ent
          da-trans-fim   = da-trans-fim-ent
          hr-trans-ini   = REPLACE(hr-trans-ini-ent,":","")
          hr-trans-fim   = REPLACE(hr-trans-fim-ent,":","")
          c-usu-ini      = c-usu-ini-ent
          c-usu-fim      = c-usu-fim-ent
          da-atu-ini     = da-atu-ini-ent
          da-atu-fim     = da-atu-fim-ent
          hr-atu-ini     = REPLACE(hr-atu-ini-ent,":","")
          hr-atu-fim     = REPLACE(hr-atu-fim-ent,":","")
          tg-nova        = l-nova
          tg-atualizada  = l-atualizada
          tg-erro        = l-erro
          tg-em-proces   = l-em-proces
          tg-cancelado   = l-cancelado
          tg-etiqueta    = l-etiqueta
          tg-movimento   = l-movimento.

{utp/ut9000.i "BC0203B" "2.00.00.019"} /* 31/08/2023 15:08:04 */

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
   
   {utp/ut-field.i mgcld bc-trans cd-trans         1}
   ASSIGN c-trans-ini:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-field.i mgcld bc-trans nr-trans         1}
   ASSIGN i-trans-ini :LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-field.i mgcld bc-trans data             1}
   ASSIGN da-trans-ini:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-field.i mgcld bc-trans horario          1}
   ASSIGN hr-trans-ini:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-field.i mgcld bc-trans usuario          1}
   ASSIGN c-usu-ini:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-field.i mgcld bc-trans data-atualizacao 1}
   ASSIGN da-atu-ini:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-field.i mgcld bc-trans hora-atualizacao 1}
   ASSIGN hr-atu-ini:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Tipo de Movimento" MBC R}
   ASSIGN c-texto2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Transa‡Æo" MBC R}
   ASSIGN tg-movimento:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Etiquetas" MBC R}
   ASSIGN tg-etiqueta:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Nova" MBC R}
   ASSIGN tg-Nova:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Atualizada" MBC R}
   ASSIGN tg-Atualizada:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Com Erro" MBC R}
   ASSIGN tg-erro:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).     
   {utp/ut-liter.i "Em Processo" MBC R}
   ASSIGN tg-em-proces:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Cancelado" MBC R}
   ASSIGN tg-cancelado:LABEL IN FRAME {&FRAME-NAME} = TRIM(RETURN-VALUE).
   {utp/ut-liter.i "Estado Transa‡Æo" MBC R}
   ASSIGN c-texto1 = RETURN-VALUE.
   
   DISPLAY c-texto1 WITH FRAME   {&FRAME-NAME}.
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
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
   DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.
  
   RUN pi-trata-state ( INPUT p-issuer-hdl,
                        INPUT p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
