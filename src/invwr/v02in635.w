&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V02IN635 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN635 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.



def var de-fxa-processo-ini as decimal no-undo.
def var de-fxa-processo-fim as decimal no-undo.
def var de-fxa-contrato-ini as decimal no-undo.
def var de-fxa-contrato-fim as decimal no-undo.
def var de-fxa-manut-ini    as decimal no-undo.
def var de-fxa-manut-fim    as decimal no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES faixa-aprov
&Scoped-define FIRST-EXTERNAL-TABLE faixa-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR faixa-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS faixa-aprov.lim-solic-ini ~
faixa-aprov.lim-solic-fim faixa-aprov.lim-requis-ini ~
faixa-aprov.lim-requis-fim faixa-aprov.lim-cotac-ini ~
faixa-aprov.lim-cotac-fim faixa-aprov.lim-pedido-ini ~
faixa-aprov.lim-pedido-fim 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}lim-solic-ini ~{&FP2}lim-solic-ini ~{&FP3}~
 ~{&FP1}lim-solic-fim ~{&FP2}lim-solic-fim ~{&FP3}~
 ~{&FP1}lim-requis-ini ~{&FP2}lim-requis-ini ~{&FP3}~
 ~{&FP1}lim-requis-fim ~{&FP2}lim-requis-fim ~{&FP3}~
 ~{&FP1}lim-cotac-ini ~{&FP2}lim-cotac-ini ~{&FP3}~
 ~{&FP1}lim-cotac-fim ~{&FP2}lim-cotac-fim ~{&FP3}~
 ~{&FP1}lim-pedido-ini ~{&FP2}lim-pedido-ini ~{&FP3}~
 ~{&FP1}lim-pedido-fim ~{&FP2}lim-pedido-fim ~{&FP3}
&Scoped-define ENABLED-TABLES faixa-aprov
&Scoped-define FIRST-ENABLED-TABLE faixa-aprov
&Scoped-Define ENABLED-OBJECTS rt-mold IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 ~
IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 fxa-processo-ini IMAGE-9 IMAGE-10 ~
fxa-processo-fim fxa-contrato-ini IMAGE-11 IMAGE-12 fxa-contrato-fim ~
fxa-manut-ini IMAGE-13 IMAGE-14 fxa-manut-fim c-inicial c-final 
&Scoped-Define DISPLAYED-FIELDS faixa-aprov.lim-solic-ini ~
faixa-aprov.lim-solic-fim faixa-aprov.lim-requis-ini ~
faixa-aprov.lim-requis-fim faixa-aprov.lim-cotac-ini ~
faixa-aprov.lim-cotac-fim faixa-aprov.lim-pedido-ini ~
faixa-aprov.lim-pedido-fim 
&Scoped-Define DISPLAYED-OBJECTS fxa-processo-ini fxa-processo-fim ~
fxa-contrato-ini fxa-contrato-fim fxa-manut-ini fxa-manut-fim c-inicial ~
c-final 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-final AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-inicial AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fxa-contrato-fim AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE VARIABLE fxa-contrato-ini AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Contrato" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE VARIABLE fxa-manut-fim AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE VARIABLE fxa-manut-ini AS DECIMAL FORMAT "->>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Manuten‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE VARIABLE fxa-processo-fim AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE fxa-processo-ini AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-10
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-11
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-12
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-13
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-14
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-2
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-3
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-4
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-5
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-6
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-7
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-8
     FILENAME "image\ii-las":U
     SIZE 2.86 BY 1.

DEFINE IMAGE IMAGE-9
     FILENAME "image\ii-fir":U
     SIZE 2.86 BY 1.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     faixa-aprov.lim-solic-ini AT ROW 2 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     faixa-aprov.lim-solic-fim AT ROW 2 COL 54.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     faixa-aprov.lim-requis-ini AT ROW 3 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     faixa-aprov.lim-requis-fim AT ROW 3 COL 54.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     faixa-aprov.lim-cotac-ini AT ROW 4 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     faixa-aprov.lim-cotac-fim AT ROW 4 COL 54.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     faixa-aprov.lim-pedido-ini AT ROW 5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     faixa-aprov.lim-pedido-fim AT ROW 5 COL 54.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     fxa-processo-ini AT ROW 6 COL 25 COLON-ALIGNED
     fxa-processo-fim AT ROW 6 COL 54 COLON-ALIGNED NO-LABEL
     fxa-contrato-ini AT ROW 7 COL 25 COLON-ALIGNED
     fxa-contrato-fim AT ROW 7 COL 54 COLON-ALIGNED NO-LABEL
     fxa-manut-ini AT ROW 8 COL 25 COLON-ALIGNED
     fxa-manut-fim AT ROW 8 COL 54 COLON-ALIGNED NO-LABEL
     c-inicial AT ROW 1.17 COL 24.72 COLON-ALIGNED NO-LABEL
     c-final AT ROW 1.17 COL 53.86 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     IMAGE-1 AT ROW 2 COL 46.14
     IMAGE-2 AT ROW 2 COL 53
     IMAGE-3 AT ROW 3 COL 46
     IMAGE-4 AT ROW 3 COL 52.86
     IMAGE-5 AT ROW 4 COL 46
     IMAGE-6 AT ROW 4 COL 52.86
     IMAGE-7 AT ROW 5 COL 46
     IMAGE-8 AT ROW 5 COL 52.86
     IMAGE-9 AT ROW 6 COL 46
     IMAGE-10 AT ROW 6 COL 52.86
     IMAGE-11 AT ROW 7 COL 46
     IMAGE-12 AT ROW 7 COL 52.86
     IMAGE-13 AT ROW 8 COL 46
     IMAGE-14 AT ROW 8 COL 52.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.faixa-aprov
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.5
         WIDTH              = 86.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/


    {utp/ut-liter.i Inicial * L}
    assign c-inicial:screen-value in frame {&frame-name} = return-value.
    {utp/ut-liter.i Final * L}
    assign c-final:screen-value in frame {&frame-name} = return-value.    
    {utp/ut-liter.i Solicita‡Æo * L}
    assign faixa-aprov.lim-solic-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Requisi‡Æo * L}
    assign faixa-aprov.lim-requis-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Cota‡Æo * L}
    assign faixa-aprov.lim-cotac-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Pedido * L}
    assign faixa-aprov.lim-pedido-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Processo * L}
    assign fxa-processo-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Contrato * L}
    assign fxa-contrato-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Manuten‡Æo * L}
    assign fxa-manut-ini:label in frame {&frame-name} = return-value.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "faixa-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "faixa-aprov"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    {utp/ut-liter.i Inicial * L}
    assign c-inicial:screen-value in frame {&frame-name} = return-value.
    {utp/ut-liter.i Final * L}
    assign c-final:screen-value in frame {&frame-name} = return-value.    
    {utp/ut-liter.i Solicita‡Æo * L}
    assign faixa-aprov.lim-solic-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Requisi‡Æo * L}
    assign faixa-aprov.lim-requis-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Cota‡Æo * L}
    assign faixa-aprov.lim-cotac-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Pedido * L}
    assign faixa-aprov.lim-pedido-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Processo * L}
    assign fxa-processo-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Contrato * L}
    assign fxa-contrato-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Manuten‡Æo * L}
    assign fxa-manut-ini:label in frame {&frame-name} = return-value.

    enable fxa-processo-ini
           fxa-processo-fim
           fxa-contrato-ini
           fxa-contrato-fim
           fxa-manut-ini
           fxa-manut-fim
           with frame {&FRAME-NAME}.
    assign fxa-processo-ini:screen-value in frame {&FRAME-NAME} = string(0)
           fxa-processo-fim:screen-value in frame {&FRAME-NAME} = string(0)
           fxa-contrato-ini:screen-value in frame {&FRAME-NAME} = string(0)
           fxa-contrato-fim:screen-value in frame {&FRAME-NAME} = string(0)
           fxa-manut-ini:screen-value    in frame {&FRAME-NAME} = string(0)
           fxa-manut-fim:screen-value    in frame {&FRAME-NAME} = string(0).
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    def buffer b-faixa for faixa-aprov.
    def var i-erro as int init 0.
    def var c-sc-codigo like faixa-aprov.sc-codigo no-undo.
    def var i-num-faixa like faixa-aprov.num-faixa no-undo.
    
     
    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "num-faixa").
    assign i-num-faixa = int(trim(return-value)).

    RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "sc-codigo").
    assign c-sc-codigo = trim(return-value).
   
   assign i-erro = 0.
   for each b-faixa no-lock
      where b-faixa.sc-codigo  = c-sc-codigo
        and b-faixa.num-faixa <> i-num-faixa:
        
        if  b-faixa.lim-solic-ini LE input frame {&frame-name} faixa-aprov.lim-solic-ini
        and b-faixa.lim-solic-fim GE input frame {&frame-name} faixa-aprov.lim-solic-ini
        and input frame {&frame-name} faixa-aprov.lim-solic-fim <> 0
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 1.
            leave.
        end. 
        if b-faixa.lim-solic-ini LE input frame {&frame-name} faixa-aprov.lim-solic-fim
        and b-faixa.lim-solic-fim GE input frame {&frame-name} faixa-aprov.lim-solic-fim 
        and input frame {&frame-name} faixa-aprov.lim-solic-fim <> 0
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 2.
            leave.
        end.
        if  b-faixa.lim-requis-ini LE input frame {&frame-name} faixa-aprov.lim-requis-ini
        and b-faixa.lim-requis-fim GE input frame {&frame-name} faixa-aprov.lim-requis-ini 
        and input frame {&frame-name} faixa-aprov.lim-requis-fim <> 0 
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 3.        
            leave.
        end.
        if b-faixa.lim-requis-ini LE input frame {&frame-name} faixa-aprov.lim-requis-fim
        and b-faixa.lim-requis-fim GE input frame {&frame-name} faixa-aprov.lim-requis-fim
        and input frame {&frame-name} faixa-aprov.lim-requis-fim <> 0
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 4.
            leave.
        end.
        if b-faixa.lim-cotac-ini LE input frame {&frame-name} faixa-aprov.lim-cotac-ini
        and b-faixa.lim-cotac-fim GE input frame {&frame-name} faixa-aprov.lim-cotac-ini
        and input frame {&frame-name} faixa-aprov.lim-cotac-fim <> 0 
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 5.
            leave.
        end.
     
        if b-faixa.lim-cotac-ini LE input frame {&frame-name} faixa-aprov.lim-cotac-fim
        and b-faixa.lim-cotac-fim GE input frame {&frame-name} faixa-aprov.lim-cotac-fim
        and input frame {&frame-name} faixa-aprov.lim-cotac-fim <> 0
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 6.
            leave.
        end.
    
        if b-faixa.lim-pedido-ini LE input frame {&frame-name} faixa-aprov.lim-pedido-ini
        and b-faixa.lim-pedido-fim GE input frame {&frame-name} faixa-aprov.lim-pedido-ini
        and input frame {&frame-name} faixa-aprov.lim-pedido-fim <> 0
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 7.
            leave.
        end.
        if b-faixa.lim-pedido-ini LE input frame {&frame-name} faixa-aprov.lim-pedido-fim
        and b-faixa.lim-pedido-fim GE input frame {&frame-name} faixa-aprov.lim-pedido-fim
        and input frame {&frame-name} faixa-aprov.lim-pedido-fim <> 0
        then do:
             run utp/ut-msgs.p (input "show", input 16603, input "").
             assign i-erro = 8.
             leave.
        end.
     
        if dec(substr(b-faixa.char-1,01,20)) LE input frame {&frame-name} fxa-processo-ini
        and dec(substr(b-faixa.char-2,01,20)) GE input frame {&frame-name} fxa-processo-ini
        and input frame {&frame-name} fxa-processo-fim <> 0
        then do:
             run utp/ut-msgs.p (input "show", input 16603, input "").
             assign i-erro = 9.
             leave.
        end.
        if dec(substr(b-faixa.char-1,01,20)) LE input frame {&frame-name} fxa-processo-fim
        and dec(substr(b-faixa.char-2,01,20)) GE input frame {&frame-name} fxa-processo-fim
        and input frame {&frame-name} fxa-processo-fim <> 0
        then do:
            run utp/ut-msgs.p (input "show", input 16603, input "").
            assign i-erro = 10.
            leave.
        end.
     
        if dec(substr(b-faixa.char-1,21,20)) LE input frame {&frame-name} fxa-contrato-ini
        and dec(substr(b-faixa.char-2,21,20)) GE input frame {&frame-name} fxa-contrato-ini
        and input frame {&frame-name} fxa-contrato-fim <> 0
        then do:
             run utp/ut-msgs.p (input "show", input 16603, input "").
             assign i-erro = 11.
             leave.
        end.
        if dec(substr(b-faixa.char-1,21,20)) LE input frame {&frame-name} fxa-contrato-fim
        and dec(substr(b-faixa.char-2,21,20)) GE input frame {&frame-name} fxa-contrato-fim
        and input frame {&frame-name} fxa-contrato-fim <> 0
        then do:
             run utp/ut-msgs.p (input "show", input 16603, input "").
             assign i-erro = 12.
             leave.
        end.

        if dec(substr(b-faixa.char-1,41,20)) LE input frame {&frame-name} fxa-manut-ini
        and dec(substr(b-faixa.char-2,41,20)) GE input frame {&frame-name} fxa-manut-ini
        and input frame {&frame-name} fxa-manut-fim <> 0
        then do:
             run utp/ut-msgs.p (input "show", input 16603, input "").
             assign i-erro = 14.
             leave.
        end.
        if dec(substr(b-faixa.char-1,41,20)) LE input frame {&frame-name} fxa-manut-fim
        and dec(substr(b-faixa.char-2,41,20)) GE input frame {&frame-name} fxa-manut-fim
        and input frame {&frame-name} fxa-manut-fim <> 0
        then do:
             run utp/ut-msgs.p (input "show", input 16603, input "").
             assign i-erro = 13.
             leave.
        end.
   end.
   
   if i-erro <> 0 then do with frame {&frame-name}:
        CASE i-erro:
        when 1 then
            apply "entry" to faixa-aprov.lim-solic-ini.
        when 2 then
            apply "entry" to faixa-aprov.lim-solic-fim.
        when 3 then
            apply "entry" to faixa-aprov.lim-requis-ini.
        when 4 then
            apply "entry" to faixa-aprov.lim-requis-fim.
        when 5 then
            apply "entry" to faixa-aprov.lim-cotac-ini.
        when 6 then
            apply "entry" to faixa-aprov.lim-cotac-fim.
        when 7 then
            apply "entry" to faixa-aprov.lim-pedido-ini.
        when 8 then
            apply "entry" to faixa-aprov.lim-pedido-fim.
        when 10 then 
            apply "entry" to fxa-processo-ini.
        when 11 then 
            apply "entry" to fxa-contrato-ini.
        when 12 then 
            apply "entry" to fxa-contrato-fim.
        when 13 then 
            apply "entry" to fxa-manut-ini.
        when 14 then 
            apply "entry" to fxa-manut-fim.
        END CASE.
        return "adm-error".
    end.

    assign de-fxa-processo-ini = input frame {&FRAME-NAME} fxa-processo-ini
           de-fxa-processo-fim = input frame {&FRAME-NAME} fxa-processo-fim
           de-fxa-contrato-ini = input frame {&FRAME-NAME} fxa-contrato-ini
           de-fxa-contrato-fim = input frame {&FRAME-NAME} fxa-contrato-fim
           de-fxa-manut-ini    = input frame {&FRAME-NAME} fxa-manut-ini
           de-fxa-manut-fim    = input frame {&FRAME-NAME} fxa-manut-fim.
        
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    
    if avail faixa-aprov then
    assign faixa-aprov.char-1 = ""                  /* nao se atreva a mexer aqui */
           faixa-aprov.char-2 = "" 
           substr(faixa-aprov.char-1,01,20) = string(de-fxa-processo-ini)
           substr(faixa-aprov.char-2,01,20) = string(de-fxa-processo-fim)
           substr(faixa-aprov.char-1,21,20) = string(de-fxa-contrato-ini)
           substr(faixa-aprov.char-2,21,20) = string(de-fxa-contrato-fim)
           substr(faixa-aprov.char-1,41,20) = string(de-fxa-manut-ini)
           substr(faixa-aprov.char-2,41,20) = string(de-fxa-manut-fim).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    disable fxa-processo-ini
            fxa-processo-fim
            fxa-contrato-ini
            fxa-contrato-fim
            fxa-manut-ini
            fxa-manut-fim
            with frame {&FRAME-NAME}.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if avail faixa-aprov then
  assign fxa-processo-ini  = dec(substr(faixa-aprov.char-1,01,20))
         fxa-processo-fim  = dec(substr(faixa-aprov.char-2,01,20))
         fxa-contrato-ini  = dec(substr(faixa-aprov.char-1,21,20))
         fxa-contrato-fim  = dec(substr(faixa-aprov.char-2,21,20))
         fxa-manut-ini     = dec(substr(faixa-aprov.char-1,41,20))
         fxa-manut-fim     = dec(substr(faixa-aprov.char-2,41,20)).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    {utp/ut-liter.i Inicial * L}
    assign c-inicial:screen-value in frame {&frame-name} = return-value.
    {utp/ut-liter.i Final * L}
    assign c-final:screen-value in frame {&frame-name} = return-value.    
    {utp/ut-liter.i Solicita‡Æo * L}
    assign faixa-aprov.lim-solic-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Requisi‡Æo * L}
    assign faixa-aprov.lim-requis-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Cota‡Æo * L}
    assign faixa-aprov.lim-cotac-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Pedido * L}
    assign faixa-aprov.lim-pedido-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Processo * L}
    assign fxa-processo-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Contrato * L}
    assign fxa-contrato-ini:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Manuten‡Æo * L}
    assign fxa-manut-ini:label in frame {&frame-name} = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    enable fxa-processo-ini
           fxa-processo-fim
           fxa-contrato-ini
           fxa-contrato-fim
           fxa-manut-ini
           fxa-manut-fim
           with frame {&FRAME-NAME}.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  disable fxa-processo-ini
          fxa-processo-fim
          fxa-contrato-ini
          fxa-contrato-fim
          fxa-manut-ini
          fxa-manut-fim
          with frame {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

    if input frame {&FRAME-NAME} faixa-aprov.lim-cotac-ini >
       input frame {&FRAME-NAME} faixa-aprov.lim-cotac-fim
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4733,
                           input "").
        apply "entry" to faixa-aprov.lim-cotac-ini in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if input frame {&FRAME-NAME} faixa-aprov.lim-pedido-ini >
       input frame {&FRAME-NAME} faixa-aprov.lim-pedido-fim
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4733,
                           input "").
        apply "entry" to faixa-aprov.lim-pedido-ini in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if input frame {&FRAME-NAME} faixa-aprov.lim-requis-ini >
       input frame {&FRAME-NAME} faixa-aprov.lim-requis-fim
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4733,
                           input "").
        apply "entry" to faixa-aprov.lim-requis-ini in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if input frame {&FRAME-NAME} faixa-aprov.lim-solic-ini >
       input frame {&FRAME-NAME} faixa-aprov.lim-solic-fim
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4733,
                           input "").
        apply "entry" to faixa-aprov.lim-solic-ini in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if input frame {&FRAME-NAME} fxa-processo-ini >
       input frame {&FRAME-NAME} fxa-processo-fim
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4733,
                           input "").
        apply "entry" to fxa-processo-ini in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if input frame {&FRAME-NAME} fxa-contrato-ini >
       input frame {&FRAME-NAME} fxa-contrato-fim
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4733,
                           input "").
        apply "entry" to fxa-contrato-ini in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.

    if input frame {&FRAME-NAME} fxa-manut-ini >
       input frame {&FRAME-NAME} fxa-manut-fim
    then do:
        run utp/ut-msgs.p (input "show",
                           input 4733,
                           input "").
        apply "entry" to fxa-manut-ini in frame {&FRAME-NAME}.
        return 'adm-error'.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "faixa-aprov"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


