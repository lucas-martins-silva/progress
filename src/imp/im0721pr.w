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
{include/i-prgvrs.i IM0721PR 2.00.00.000 } /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0721PR MIM}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pc-cod-refer-ini        AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-refer-fim        AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-espec-docto-ini  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-espec-docto-fim  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-ser-docto-ini    AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-ser-docto-fim    AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-tit-ap-ini       AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-tit-ap-fim       AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-parcela-ini      AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-parcela-fim      AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-emissao-ini     AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-emissao-fim     AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-vencto-ini      AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-vencto-fim      AS DATE         NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pde-val-adiant-moed-ini AS DECIMAL      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pde-val-adiant-moed-fim AS DECIMAL      NO-UNDO.
DEFINE OUTPUT       PARAMETER l-usou-filtro           AS LOGICAL      NO-UNDO.



/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-10 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 ~
IMAGE-7 IMAGE-8 IMAGE-9 RECT-11 rt-buttom IMAGE-20 IMAGE-21 IMAGE-22 ~
IMAGE-23 IMAGE-24 IMAGE-25 IMAGE-28 IMAGE-29 c-cod-refer-ini ~
c-cod-refer-fim c-cod-espec-docto-ini c-cod-espec-docto-fim ~
c-cod-ser-docto-ini c-cod-ser-docto-fim c-cod-tit-ap-ini c-cod-tit-ap-fim ~
c-cod-parcela-ini c-cod-parcela-fim dt-dat-emissao-ini dt-dat-emissao-fim ~
dt-dat-vencto-ini dt-dat-vencto-fim de-val-adiant-moed-ini ~
de-val-adiant-moed-fim bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS c-cod-refer-ini c-cod-refer-fim ~
c-cod-espec-docto-ini c-cod-espec-docto-fim c-cod-ser-docto-ini ~
c-cod-ser-docto-fim c-cod-tit-ap-ini c-cod-tit-ap-fim c-cod-parcela-ini ~
c-cod-parcela-fim dt-dat-emissao-ini dt-dat-emissao-fim dt-dat-vencto-ini ~
dt-dat-vencto-fim de-val-adiant-moed-ini de-val-adiant-moed-fim 

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

DEFINE VARIABLE c-cod-espec-docto-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-espec-docto-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "EspÇcie" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-parcela-fim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-parcela-ini AS CHARACTER FORMAT "X(2)":U 
     LABEL "Parcela" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer-fim AS CHARACTER FORMAT "X(10)" INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-refer-ini AS CHARACTER FORMAT "X(10)" 
     LABEL "Referància" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ser-docto-fim AS CHARACTER FORMAT "X(5)":U INITIAL "ZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ser-docto-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "SÇrie Documento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-ap-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tit-ap-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "T°tulo" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-adiant-moed-fim AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99":U INITIAL 999999999999999.99 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-adiant-moed-ini AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Adiantamento" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-emissao-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-emissao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-vencto-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE VARIABLE dt-dat-vencto-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "IMAGE\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "IMAGE\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
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

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 73 BY 8.88.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 73 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-cod-refer-ini AT ROW 1.75 COL 25.86 COLON-ALIGNED HELP
          "C¢digo da referància Inicial"
     c-cod-refer-fim AT ROW 1.75 COL 44.57 COLON-ALIGNED HELP
          "C¢digo da referància Final" NO-LABEL
     c-cod-espec-docto-ini AT ROW 2.75 COL 32.86 COLON-ALIGNED HELP
          "C¢digo da EspÇcie do documento Inicial"
     c-cod-espec-docto-fim AT ROW 2.75 COL 44.57 COLON-ALIGNED HELP
          "C¢digo da EspÇcie do Documento Final" NO-LABEL
     c-cod-ser-docto-ini AT ROW 3.75 COL 30.86 COLON-ALIGNED HELP
          "SÇrie do Documento Inicial"
     c-cod-ser-docto-fim AT ROW 3.75 COL 44.57 COLON-ALIGNED HELP
          "SÇrie do Documento Final" NO-LABEL
     c-cod-tit-ap-ini AT ROW 4.75 COL 19.86 COLON-ALIGNED HELP
          "Codigo do t°tulo inicial" WIDGET-ID 46
     c-cod-tit-ap-fim AT ROW 4.75 COL 44.57 COLON-ALIGNED HELP
          "Codigo do t°tulo final" NO-LABEL
     c-cod-parcela-ini AT ROW 5.75 COL 33.86 COLON-ALIGNED HELP
          "Parcela Inicial" WIDGET-ID 2
     c-cod-parcela-fim AT ROW 5.75 COL 44.57 COLON-ALIGNED HELP
          "Parcela Final" NO-LABEL WIDGET-ID 12
     dt-dat-emissao-ini AT ROW 6.75 COL 27.29 COLON-ALIGNED HELP
          "Data emiss∆o inicial" WIDGET-ID 14
     dt-dat-emissao-fim AT ROW 6.75 COL 44.57 COLON-ALIGNED HELP
          "Data emiss∆o final" NO-LABEL WIDGET-ID 20
     dt-dat-vencto-ini AT ROW 7.75 COL 27.29 COLON-ALIGNED HELP
          "Data vencimento inicial" WIDGET-ID 22
     dt-dat-vencto-fim AT ROW 7.75 COL 44.57 COLON-ALIGNED HELP
          "Data vencimento final" NO-LABEL WIDGET-ID 24
     de-val-adiant-moed-ini AT ROW 8.75 COL 18 COLON-ALIGNED HELP
          "Valor adiantamento Inicial" WIDGET-ID 38
     de-val-adiant-moed-fim AT ROW 8.75 COL 44.43 COLON-ALIGNED HELP
          "Valor adiantamento Final" NO-LABEL WIDGET-ID 40
     bt-ok AT ROW 10.58 COL 3.29
     bt-cancela AT ROW 10.58 COL 14.29
     IMAGE-10 AT ROW 4.71 COL 43.43
     IMAGE-3 AT ROW 1.75 COL 39.14
     IMAGE-4 AT ROW 1.75 COL 43.43
     IMAGE-5 AT ROW 2.75 COL 39.14
     IMAGE-6 AT ROW 2.75 COL 43.43
     IMAGE-7 AT ROW 3.75 COL 39.14
     IMAGE-8 AT ROW 3.75 COL 43.43
     IMAGE-9 AT ROW 4.75 COL 39.14
     RECT-11 AT ROW 1.25 COL 2
     rt-buttom AT ROW 10.38 COL 2
     IMAGE-20 AT ROW 5.75 COL 39.14 WIDGET-ID 8
     IMAGE-21 AT ROW 5.75 COL 43.43 WIDGET-ID 10
     IMAGE-22 AT ROW 6.75 COL 39.14 WIDGET-ID 16
     IMAGE-23 AT ROW 6.75 COL 43.43 WIDGET-ID 18
     IMAGE-24 AT ROW 7.75 COL 39.14 WIDGET-ID 26
     IMAGE-25 AT ROW 7.75 COL 43.43 WIDGET-ID 28
     IMAGE-28 AT ROW 8.75 COL 39.14 WIDGET-ID 42
     IMAGE-29 AT ROW 8.75 COL 43.43 WIDGET-ID 44
     SPACE(29.13) SKIP(2.40)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Filtro de Antecipaá‰es"
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
   FRAME-NAME L-To-R                                                    */
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
ON WINDOW-CLOSE OF FRAME D-Dialog /* Filtro de Antecipaá‰es */
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
  /*ASSIGN v-cria = NO.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO: 
    
    ASSIGN pc-cod-parcela-ini       = input frame {&frame-name} c-cod-parcela-ini
           pc-cod-parcela-fim       = input frame {&frame-name} c-cod-parcela-fim
           pc-cod-espec-docto-ini   = input frame {&frame-name} c-cod-espec-docto-ini
           pc-cod-espec-docto-fim   = input frame {&frame-name} c-cod-espec-docto-fim
           pc-cod-ser-docto-ini     = input frame {&frame-name} c-cod-ser-docto-ini
           pc-cod-ser-docto-fim     = input frame {&frame-name} c-cod-ser-docto-fim
           pdt-dat-emissao-ini      = input frame {&frame-name} dt-dat-emissao-ini
           pdt-dat-emissao-fim      = input frame {&frame-name} dt-dat-emissao-fim
           pdt-dat-vencto-ini       = input frame {&frame-name} dt-dat-vencto-ini
           pdt-dat-vencto-fim       = input frame {&frame-name} dt-dat-vencto-fim
           pc-cod-refer-ini         = input frame {&frame-name} c-cod-refer-ini
           pc-cod-refer-fim         = input frame {&frame-name} c-cod-refer-fim
           pc-cod-tit-ap-ini        = input frame {&frame-name} c-cod-tit-ap-ini
           pc-cod-tit-ap-fim        = input frame {&frame-name} c-cod-tit-ap-fim
           pde-val-adiant-moed-ini  = input frame {&frame-name} de-val-adiant-moed-ini
           pde-val-adiant-moed-fim  = input frame {&frame-name} de-val-adiant-moed-fim
           l-usou-filtro            = YES.

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
  DISPLAY c-cod-refer-ini c-cod-refer-fim c-cod-espec-docto-ini 
          c-cod-espec-docto-fim c-cod-ser-docto-ini c-cod-ser-docto-fim 
          c-cod-tit-ap-ini c-cod-tit-ap-fim c-cod-parcela-ini c-cod-parcela-fim 
          dt-dat-emissao-ini dt-dat-emissao-fim dt-dat-vencto-ini 
          dt-dat-vencto-fim de-val-adiant-moed-ini de-val-adiant-moed-fim 
      WITH FRAME D-Dialog.
  ENABLE IMAGE-10 IMAGE-3 IMAGE-4 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 
         RECT-11 rt-buttom IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 
         IMAGE-25 IMAGE-28 IMAGE-29 c-cod-refer-ini c-cod-refer-fim 
         c-cod-espec-docto-ini c-cod-espec-docto-fim c-cod-ser-docto-ini 
         c-cod-ser-docto-fim c-cod-tit-ap-ini c-cod-tit-ap-fim 
         c-cod-parcela-ini c-cod-parcela-fim dt-dat-emissao-ini 
         dt-dat-emissao-fim dt-dat-vencto-ini dt-dat-vencto-fim 
         de-val-adiant-moed-ini de-val-adiant-moed-fim bt-ok bt-cancela 
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

{utp/ut9000.i "IM00721PR" "2.00.00.000"}

    ASSIGN c-cod-parcela-ini      =  pc-cod-parcela-ini      
           c-cod-parcela-fim      =  pc-cod-parcela-fim      
           c-cod-espec-docto-ini  =  pc-cod-espec-docto-ini  
           c-cod-espec-docto-fim  =  pc-cod-espec-docto-fim  
           c-cod-ser-docto-ini    =  pc-cod-ser-docto-ini    
           c-cod-ser-docto-fim    =  pc-cod-ser-docto-fim    
           dt-dat-emissao-ini     =  pdt-dat-emissao-ini     
           dt-dat-emissao-fim     =  pdt-dat-emissao-fim     
           dt-dat-vencto-ini      =  pdt-dat-vencto-ini      
           dt-dat-vencto-fim      =  pdt-dat-vencto-fim      
           c-cod-refer-ini        =  pc-cod-refer-ini        
           c-cod-refer-fim        =  pc-cod-refer-fim        
           c-cod-tit-ap-ini       =  pc-cod-tit-ap-ini       
           c-cod-tit-ap-fim       =  pc-cod-tit-ap-fim       
           de-val-adiant-moed-ini =  pde-val-adiant-moed-ini 
           de-val-adiant-moed-fim =  pde-val-adiant-moed-fim. 
              





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

