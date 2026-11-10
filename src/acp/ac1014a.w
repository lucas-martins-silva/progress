&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i AC1014A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AC1014A MAC}
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

def input-output parameter c-cliente-ini   as char    no-undo.
def input-output parameter c-cliente-fim   as char    no-undo.
def input-output parameter c-repres-ini    as char    no-undo.
def input-output parameter c-repres-fim    as char    no-undo.
def input-output parameter d-dat-emis-ini  as date    no-undo.
def input-output parameter d-dat-emis-fim  as date    no-undo.
def input-output parameter d-dat-impl-ini  as date    no-undo.
def input-output parameter d-dat-impl-fim  as date    no-undo.
def input-output parameter d-dat-entr-ini  as date    no-undo.
def input-output parameter d-dat-entr-fim  as date    no-undo.
def input-output parameter c-item-prod-ini as char    no-undo.
def input-output parameter c-item-prod-fim as char    no-undo.
def input-output parameter l-ok            as logical no-undo.
def input-output parameter l-aprovado      as logical no-undo.
def input-output parameter l-reprov        as logical no-undo.
def input-output parameter l-nao-avaliado  as logical no-undo.
def input-output parameter l-susp          as logical no-undo.

def var i-mes        as int  no-undo.
def var da-dt-fim    as date no-undo.
def var da-dt-inicio as date no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDialog

&Scoped-define ADM-CONTAINER DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME D-Dialog

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 c-nome-abrev-ini IMAGE-19 IMAGE-16 ~
c-nome-abrev-fim c-no-ab-reppri-ini IMAGE-18 IMAGE-22 c-no-ab-reppri-fim ~
da-dt-emissao-ini IMAGE-17 IMAGE-23 da-dt-emissao-fim da-dt-implant-ini ~
IMAGE-15 IMAGE-24 da-dt-implant-fim da-dt-entrega-ini IMAGE-20 IMAGE-25 ~
da-dt-entrega-fim c-item-ini IMAGE-21 IMAGE-26 c-item-fim RECT-11 ~
tg-aprovado tg-nao-avaliado tg-reprov tg-susp rt-buttom bt-ok bt-cancela ~
bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev-ini c-nome-abrev-fim ~
c-no-ab-reppri-ini c-no-ab-reppri-fim da-dt-emissao-ini da-dt-emissao-fim ~
da-dt-implant-ini da-dt-implant-fim da-dt-entrega-ini da-dt-entrega-fim ~
c-item-ini c-item-fim tg-aprovado tg-nao-avaliado tg-reprov tg-susp 

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

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE avaliacao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11.43 BY .67 NO-UNDO.

DEFINE VARIABLE c-item-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item/Produto" 
     VIEW-AS FILL-IN 
     SIZE 22.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-no-ab-reppri-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-no-ab-reppri-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Representante" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-fim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-emissao-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-emissao-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data EmissÆo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-entrega-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-entrega-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Entrega" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-implant-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-implant-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/001 
     LABEL "Data Implanta‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 42.86 BY 3.17.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80.43 BY 7.83.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 81.72 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-aprovado AS LOGICAL INITIAL no 
     LABEL "Aprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE tg-nao-avaliado AS LOGICAL INITIAL no 
     LABEL "NÆo Avaliado" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.86 BY .75 NO-UNDO.

DEFINE VARIABLE tg-reprov AS LOGICAL INITIAL no 
     LABEL "Reprovado" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.43 BY .75 NO-UNDO.

DEFINE VARIABLE tg-susp AS LOGICAL INITIAL no 
     LABEL "Suspenso" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.86 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME D-Dialog
     c-nome-abrev-ini AT ROW 2.5 COL 18.29 COLON-ALIGNED
     c-nome-abrev-fim AT ROW 2.5 COL 55 COLON-ALIGNED NO-LABEL
     c-no-ab-reppri-ini AT ROW 3.5 COL 18.29 COLON-ALIGNED
     c-no-ab-reppri-fim AT ROW 3.5 COL 55 COLON-ALIGNED NO-LABEL
     da-dt-emissao-ini AT ROW 4.5 COL 18.29 COLON-ALIGNED
     da-dt-emissao-fim AT ROW 4.5 COL 55 COLON-ALIGNED NO-LABEL
     da-dt-implant-ini AT ROW 5.5 COL 18.29 COLON-ALIGNED
     da-dt-implant-fim AT ROW 5.5 COL 55 COLON-ALIGNED NO-LABEL
     da-dt-entrega-ini AT ROW 6.5 COL 18.29 COLON-ALIGNED
     da-dt-entrega-fim AT ROW 6.5 COL 55 COLON-ALIGNED NO-LABEL
     c-item-ini AT ROW 7.5 COL 18.29 COLON-ALIGNED
     c-item-fim AT ROW 7.5 COL 55 COLON-ALIGNED NO-LABEL
     tg-aprovado AT ROW 11.13 COL 20.72
     tg-nao-avaliado AT ROW 11.13 COL 40.86
     tg-reprov AT ROW 12.13 COL 20.72
     tg-susp AT ROW 12.13 COL 40.86
     bt-ok AT ROW 13.79 COL 2.43
     bt-cancela AT ROW 13.79 COL 13.14
     bt-ajuda AT ROW 13.79 COL 72.29
     avaliacao AT ROW 9.92 COL 20 NO-LABEL
     RECT-12 AT ROW 1.5 COL 2
     IMAGE-19 AT ROW 2.5 COL 44
     IMAGE-16 AT ROW 2.5 COL 53.14
     IMAGE-18 AT ROW 3.5 COL 44
     IMAGE-22 AT ROW 3.5 COL 53.14
     IMAGE-17 AT ROW 4.5 COL 44
     IMAGE-23 AT ROW 4.5 COL 53.14
     IMAGE-15 AT ROW 5.5 COL 44
     IMAGE-24 AT ROW 5.5 COL 53.14
     IMAGE-20 AT ROW 6.5 COL 44
     IMAGE-25 AT ROW 6.5 COL 53.14
     IMAGE-21 AT ROW 7.5 COL 44
     IMAGE-26 AT ROW 7.5 COL 53.14
     RECT-11 AT ROW 10.13 COL 18
     rt-buttom AT ROW 13.54 COL 1.57
     SPACE(0.00) SKIP(0.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Parƒmetros Pedido".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDialog
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX D-Dialog
                                                                        */
ASSIGN 
       FRAME D-Dialog:SCROLLABLE       = FALSE
       FRAME D-Dialog:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN avaliacao IN FRAME D-Dialog
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX D-Dialog
/* Query rebuild information for DIALOG-BOX D-Dialog
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX D-Dialog */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB D-Dialog 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-dialog.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME D-Dialog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL D-Dialog D-Dialog
ON WINDOW-CLOSE OF FRAME D-Dialog /* Parƒmetros Pedido */
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


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela D-Dialog
ON CHOOSE OF bt-cancela IN FRAME D-Dialog /* Cancelar */
DO:
    Assign l-ok = no.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok D-Dialog
ON CHOOSE OF bt-ok IN FRAME D-Dialog /* OK */
DO:
    Assign l-ok            = yes
           l-susp          = tg-susp:checked in frame {&frame-name}
           l-nao-avaliado  = tg-nao-avaliado:checked in frame {&frame-name}
           l-aprovado      = tg-aprovado:checked in frame {&frame-name}
           l-reprov        = tg-reprov:checked in frame {&frame-name}
           c-cliente-ini   = input frame {&frame-name} c-nome-abrev-ini
           c-cliente-fim   = input frame {&frame-name} c-nome-abrev-fim
           c-repres-ini    = input frame {&frame-name} c-no-ab-reppri-ini
           c-repres-fim    = input frame {&frame-name} c-no-ab-reppri-fim
           d-dat-emis-ini  = input frame {&frame-name} da-dt-emissao-ini
           d-dat-emis-fim  = input frame {&frame-name} da-dt-emissao-fim
           d-dat-impl-ini  = input frame {&frame-name} da-dt-implant-ini
           d-dat-impl-fim  = input frame {&frame-name} da-dt-implant-fim
           d-dat-entr-ini  = input frame {&frame-name} da-dt-entrega-ini
           d-dat-entr-fim  = input frame {&frame-name} da-dt-entrega-fim
           c-item-prod-ini = input frame {&frame-name} c-item-ini
           c-item-prod-fim = input frame {&frame-name} c-item-fim.
           
    if  l-susp = no and
        l-nao-avaliado = no and
        l-aprovado = no and
        l-reprov = no then do:
           run utp/ut-msgs.p (input "SHOW",
                              input 676,
                              input "").
           apply 'entry' to tg-susp.
           return no-apply.
    End.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects D-Dialog _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available D-Dialog _ADM-ROW-AVAILABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI D-Dialog _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI D-Dialog _DEFAULT-ENABLE
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
  DISPLAY c-nome-abrev-ini c-nome-abrev-fim c-no-ab-reppri-ini 
          c-no-ab-reppri-fim da-dt-emissao-ini da-dt-emissao-fim 
          da-dt-implant-ini da-dt-implant-fim da-dt-entrega-ini 
          da-dt-entrega-fim c-item-ini c-item-fim tg-aprovado tg-nao-avaliado 
          tg-reprov tg-susp 
      WITH FRAME D-Dialog.
  ENABLE RECT-12 c-nome-abrev-ini IMAGE-19 IMAGE-16 c-nome-abrev-fim 
         c-no-ab-reppri-ini IMAGE-18 IMAGE-22 c-no-ab-reppri-fim 
         da-dt-emissao-ini IMAGE-17 IMAGE-23 da-dt-emissao-fim 
         da-dt-implant-ini IMAGE-15 IMAGE-24 da-dt-implant-fim 
         da-dt-entrega-ini IMAGE-20 IMAGE-25 da-dt-entrega-fim c-item-ini 
         IMAGE-21 IMAGE-26 c-item-fim RECT-11 tg-aprovado tg-nao-avaliado 
         tg-reprov tg-susp rt-buttom bt-ok bt-cancela bt-ajuda 
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
{utp/ut9000.i "AC1014A" "2.00.00.001"}

/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
 do with frame {&frame-name} :
            
     {utp/ut-liter.i Situa‡Æo * R}
     assign avaliacao:screen-value  = return-value.
     {utp/ut-liter.i Aprovado * R}
     assign tg-aprovado:label = trim(return-value).
     {utp/ut-liter.i Reprovado * R}
     assign tg-reprov:label = trim(return-value).
     {utp/ut-liter.i NÆo_Avaliado * R}
     assign tg-nao-avaliado:label = trim(return-value).
     {utp/ut-liter.i Suspenso * R}
     assign tg-susp:label = trim(return-value)
            tg-susp:checked   = l-susp
            tg-nao-avaliado:checked = l-nao-avaliado
            tg-aprovado:checked  = l-aprovado
            tg-reprov:checked = l-reprov
            c-nome-abrev-ini:screen-value in frame {&frame-name}   = c-cliente-ini
            c-nome-abrev-fim:screen-value in frame {&frame-name}   = c-cliente-fim
            c-no-ab-reppri-ini:screen-value in frame {&frame-name} = c-repres-ini
            c-no-ab-reppri-fim:screen-value in frame {&frame-name} = c-repres-fim
            da-dt-emissao-ini:screen-value in frame {&frame-name}  = string(d-dat-emis-ini)
            da-dt-emissao-fim:screen-value in frame {&frame-name}  = string(d-dat-emis-fim)
            da-dt-implant-ini:screen-value in frame {&frame-name}  = string(d-dat-impl-ini)
            da-dt-implant-fim:screen-value in frame {&frame-name}  = string(d-dat-impl-fim)
            da-dt-entrega-ini:screen-value in frame {&frame-name}  = string(d-dat-entr-ini)
            da-dt-entrega-fim:screen-value in frame {&frame-name}  = string(d-dat-entr-fim)
            c-item-ini:screen-value in frame {&frame-name}         = c-item-prod-ini
            c-item-fim:screen-value in frame {&frame-name}         = c-item-prod-fim.
 end. 
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records D-Dialog _ADM-SEND-RECORDS
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


