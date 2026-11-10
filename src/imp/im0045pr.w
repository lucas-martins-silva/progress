&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i IM0045PR 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0045PR MIM}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT-OUTPUT PARAMETER v-cod-proces-imp-f      AS CHARACTER    nO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-proces-imp-i      AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ped-compra-f      AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ped-compra-i      AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ordem-compra-f    AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-num-ordem-compra-i    AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-item-f            AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-cod-item-i            AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-dat-pedido-f          AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER v-dat-pedido-i          AS DATE         NO-UNDO.
DEFINE OUTPUT       PARAMETER v-cria                  AS LOGICAL      NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-cod-proces-imp-ini v-cod-proces-imp-fim ~
v-num-ped-compra-ini v-num-ped-compra-fim v-num-ordem-compra-ini ~
v-num-ordem-compra-fim v-cod-item-ini v-cod-item-fim v-dat-pedido-ini ~
v-dat-pedido-fim bt-ok bt-cancela IMAGE-10 IMAGE-15 IMAGE-18 IMAGE-3 ~
IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 RECT-10 RECT-11 rt-buttom 
&Scoped-Define DISPLAYED-OBJECTS v-cod-proces-imp-ini v-cod-proces-imp-fim ~
v-num-ped-compra-ini v-num-ped-compra-fim v-num-ordem-compra-ini ~
v-num-ordem-compra-fim v-cod-item-ini v-cod-item-fim v-dat-pedido-ini ~
v-dat-pedido-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE v-cod-item-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-item-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-proces-imp-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-cod-proces-imp-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-pedido-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-pedido-ini AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Pedido" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ordem-compra-fim AS INTEGER FORMAT "zzzzz9,99":U INITIAL 999 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ordem-compra-ini AS INTEGER FORMAT "zzzzz9,99":U INITIAL 0 
     LABEL "Ordem Compra" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ped-compra-fim AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE VARIABLE v-num-ped-compra-ini AS INTEGER FORMAT ">>>>>,>>9":U INITIAL 0 
     LABEL "Pedido Compra" 
     VIEW-AS FILL-IN 
     SIZE 12.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 2.25.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73 BY 5.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 73 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     v-cod-proces-imp-ini AT ROW 2 COL 22 COLON-ALIGNED HELP
          "Processo de importa‡Æo inicial"
     v-cod-proces-imp-fim AT ROW 2 COL 48.86 COLON-ALIGNED HELP
          "Processo de importa‡Æo final" NO-LABEL
     v-num-ped-compra-ini AT ROW 3 COL 22.29 COLON-ALIGNED HELP
          "Pedido de compra inicial"
     v-num-ped-compra-fim AT ROW 3 COL 49.14 COLON-ALIGNED HELP
          "Pedido de compra final" NO-LABEL
     v-num-ordem-compra-ini AT ROW 4 COL 22.29 COLON-ALIGNED HELP
          "Ordem compra inicial"
     v-num-ordem-compra-fim AT ROW 4 COL 49.14 COLON-ALIGNED HELP
          "Ordem compra inicial" NO-LABEL
     v-cod-item-ini AT ROW 5 COL 22.29 COLON-ALIGNED HELP
          "Codigo do item inicial"
     v-cod-item-fim AT ROW 5 COL 49.14 COLON-ALIGNED HELP
          "Codigo do item inicial" NO-LABEL
     v-dat-pedido-ini AT ROW 7.25 COL 22 COLON-ALIGNED HELP
          "Data de embarque inicial"
     v-dat-pedido-fim AT ROW 7.25 COL 48.86 COLON-ALIGNED HELP
          "Data de embarque inicial" NO-LABEL
     bt-ok AT ROW 9.5 COL 2
     bt-cancela AT ROW 9.5 COL 13
     IMAGE-10 AT ROW 5 COL 46.57
     IMAGE-15 AT ROW 7.25 COL 42.57
     IMAGE-18 AT ROW 7.25 COL 46.57
     IMAGE-3 AT ROW 2 COL 42.29
     IMAGE-4 AT ROW 2 COL 46.57
     IMAGE-5 AT ROW 3 COL 42.29
     IMAGE-6 AT ROW 3 COL 46.57
     IMAGE-7 AT ROW 4 COL 42.29
     IMAGE-8 AT ROW 4 COL 46.57
     IMAGE-9 AT ROW 5 COL 42.29
     RECT-10 AT ROW 6.5 COL 1
     RECT-11 AT ROW 1.25 COL 1
     rt-buttom AT ROW 9.25 COL 1
     SPACE(0.42) SKIP(0.36)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Sele‡Æo para Ordens a vincular ao Embarque"
         DEFAULT-BUTTON bt-ok.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Design Page: 1
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
   L-To-R                                                               */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Sele‡Æo para Ordens a vincular ao Embarque */
DO:  
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela D-Dialog
ON CHOOSE OF bt-cancela IN FRAME D-Dialog /* Cancelar */
DO:
  ASSIGN v-cria = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
  ASSIGN  v-cod-proces-imp-f      = INPUT FRAME {&FRAME-NAME} v-cod-proces-imp-fim
          v-cod-proces-imp-i      = INPUT FRAME {&FRAME-NAME} v-cod-proces-imp-ini
          v-num-ped-compra-f      = INPUT FRAME {&FRAME-NAME} v-num-ped-compra-fim
          v-num-ped-compra-i      = INPUT FRAME {&FRAME-NAME} v-num-ped-compra-ini
          v-num-ordem-compra-f    = INPUT FRAME {&FRAME-NAME} v-num-ordem-compra-fim
          v-num-ordem-compra-i    = INPUT FRAME {&FRAME-NAME} v-num-ordem-compra-ini
          v-cod-item-f            = INPUT FRAME {&FRAME-NAME} v-cod-item-fim
          v-cod-item-i            = INPUT FRAME {&FRAME-NAME} v-cod-item-ini
          v-dat-pedido-f          = INPUT FRAME {&FRAME-NAME} v-dat-pedido-fim
          v-dat-pedido-i          = INPUT FRAME {&FRAME-NAME} v-dat-pedido-ini
          v-cria                  = YES. 

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
  DISPLAY v-cod-proces-imp-ini v-cod-proces-imp-fim v-num-ped-compra-ini 
          v-num-ped-compra-fim v-num-ordem-compra-ini v-num-ordem-compra-fim 
          v-cod-item-ini v-cod-item-fim v-dat-pedido-ini v-dat-pedido-fim 
      WITH FRAME D-Dialog.
  ENABLE v-cod-proces-imp-ini v-cod-proces-imp-fim v-num-ped-compra-ini 
         v-num-ped-compra-fim v-num-ordem-compra-ini v-num-ordem-compra-fim 
         v-cod-item-ini v-cod-item-fim v-dat-pedido-ini v-dat-pedido-fim bt-ok 
         bt-cancela IMAGE-10 IMAGE-15 IMAGE-18 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 
         IMAGE-7 IMAGE-8 IMAGE-9 RECT-10 RECT-11 rt-buttom 
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize D-Dialog 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

{utp/ut9000.i "IM0045PR" "2.00.00.000"}

   assign v-cod-proces-imp-fim   = v-cod-proces-imp-f      
          v-cod-proces-imp-ini   = v-cod-proces-imp-i      
          v-num-ped-compra-fim   = v-num-ped-compra-f      
          v-num-ped-compra-ini   = v-num-ped-compra-i      
          v-num-ordem-compra-fim = v-num-ordem-compra-f    
          v-num-ordem-compra-ini = v-num-ordem-compra-i    
          v-cod-item-fim         = v-cod-item-f            
          v-cod-item-ini         = v-cod-item-i            
          v-dat-pedido-fim       = v-dat-pedido-f          
          v-dat-pedido-ini       = v-dat-pedido-i.          


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartDialog, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

