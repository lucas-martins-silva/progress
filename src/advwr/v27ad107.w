&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V27AD107 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v27ad107 MUT}
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

def var i-cont as integer no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.val-desp-total[3] ~
estabelec.val-desp-total[2] estabelec.val-desp-total[1] ~
estabelec.qtd-up-prod[3] estabelec.qtd-up-prod[2] estabelec.qtd-up-prod[1] ~
estabelec.val-unit-up[3] estabelec.val-unit-up[2] estabelec.val-unit-up[1] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}val-desp-total[3] ~{&FP2}val-desp-total[3] ~{&FP3}~
 ~{&FP1}val-desp-total[2] ~{&FP2}val-desp-total[2] ~{&FP3}~
 ~{&FP1}val-desp-total[1] ~{&FP2}val-desp-total[1] ~{&FP3}~
 ~{&FP1}qtd-up-prod[3] ~{&FP2}qtd-up-prod[3] ~{&FP3}~
 ~{&FP1}qtd-up-prod[2] ~{&FP2}qtd-up-prod[2] ~{&FP3}~
 ~{&FP1}qtd-up-prod[1] ~{&FP2}qtd-up-prod[1] ~{&FP3}~
 ~{&FP1}val-unit-up[3] ~{&FP2}val-unit-up[3] ~{&FP3}~
 ~{&FP1}val-unit-up[2] ~{&FP2}val-unit-up[2] ~{&FP3}~
 ~{&FP1}val-unit-up[1] ~{&FP2}val-unit-up[1] ~{&FP3}
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS estabelec.val-desp-total[3] ~
estabelec.val-desp-total[2] estabelec.val-desp-total[1] ~
estabelec.qtd-up-prod[3] estabelec.qtd-up-prod[2] estabelec.qtd-up-prod[1] ~
estabelec.val-unit-up[3] estabelec.val-unit-up[2] estabelec.val-unit-up[1] 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-3 c-descricao-2 c-descricao-1 ~
c-tex-moeda c-label-2 c-label-3 c-label-1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define List-4 estabelec.val-desp-total[2] estabelec.qtd-up-prod[2] ~
estabelec.val-unit-up[2] 
&Scoped-define List-5 estabelec.val-desp-total[3] estabelec.qtd-up-prod[3] ~
estabelec.val-unit-up[3] 

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
DEFINE VARIABLE c-descricao-1 AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-2 AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-3 AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-label-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-label-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.14 BY .67 NO-UNDO.

DEFINE VARIABLE c-tex-moeda AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.14 BY 8.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-descricao-3 AT ROW 2.5 COL 63 COLON-ALIGNED HELP
          "Descri‡Æo da moeda" NO-LABEL
     c-descricao-2 AT ROW 2.5 COL 41 COLON-ALIGNED HELP
          "Descri‡Æo da moeda" NO-LABEL
     c-descricao-1 AT ROW 2.5 COL 19 COLON-ALIGNED HELP
          "Descri‡Æo da moeda" NO-LABEL
     estabelec.val-desp-total[3] AT ROW 4.04 COL 62.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.val-desp-total[2] AT ROW 4.04 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.val-desp-total[1] AT ROW 4.04 COL 18.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.qtd-up-prod[3] AT ROW 5.33 COL 62.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.qtd-up-prod[2] AT ROW 5.33 COL 40.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.qtd-up-prod[1] AT ROW 5.33 COL 18.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.val-unit-up[3] AT ROW 6.63 COL 63 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.val-unit-up[2] AT ROW 6.63 COL 41 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     estabelec.val-unit-up[1] AT ROW 6.63 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     c-tex-moeda AT ROW 2.5 COL 1.86 COLON-ALIGNED NO-LABEL
     c-label-2 AT ROW 4.04 COL 1.86 COLON-ALIGNED NO-LABEL
     c-label-3 AT ROW 5.54 COL 1.86 COLON-ALIGNED NO-LABEL
     c-label-1 AT ROW 6.83 COL 2 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 8.33
         WIDTH              = 86.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit R-To-L, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-label-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tex-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.qtd-up-prod[2] IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR FILL-IN estabelec.qtd-up-prod[3] IN FRAME f-main
   5                                                                    */
/* SETTINGS FOR FILL-IN estabelec.val-desp-total[2] IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR FILL-IN estabelec.val-desp-total[3] IN FRAME f-main
   5                                                                    */
/* SETTINGS FOR FILL-IN estabelec.val-unit-up[2] IN FRAME f-main
   4                                                                    */
/* SETTINGS FOR FILL-IN estabelec.val-unit-up[3] IN FRAME f-main
   5                                                                    */
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME estabelec.qtd-up-prod[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.qtd-up-prod[1] V-table-Win
ON LEAVE OF estabelec.qtd-up-prod[1] IN FRAME f-main /* Qtd UP Prod[1] */
DO:
   do with frame {&frame-name}:
        if  input estabelec.qtd-up-prod[1] = 0 then
            assign estabelec.val-desp-total[1]:screen-value = "0".
        if  input estabelec.val-desp-total[1] <> 0
        and input estabelec.qtd-up-prod[1]    <> 0 then
            assign estabelec.val-unit-up[1]:screen-value = string(input estabelec.val-desp-total[1] / input estabelec.qtd-up-prod[1]).
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.qtd-up-prod[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.qtd-up-prod[2] V-table-Win
ON LEAVE OF estabelec.qtd-up-prod[2] IN FRAME f-main /* Qtd UP Prod[2] */
DO:
   do with frame {&frame-name}:
        if  input estabelec.qtd-up-prod[2] = 0 then
            assign estabelec.val-desp-total[2]:screen-value = "0".
        if  input estabelec.val-desp-total[2] <> 0
        and input estabelec.qtd-up-prod[2]    <> 0 then
            assign estabelec.val-unit-up[2]:screen-value = string(input estabelec.val-desp-total[2] / input estabelec.qtd-up-prod[2]).
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.qtd-up-prod[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.qtd-up-prod[3] V-table-Win
ON LEAVE OF estabelec.qtd-up-prod[3] IN FRAME f-main /* Qtd UP Prod[3] */
DO:
   do with frame {&frame-name}:
        if  input estabelec.qtd-up-prod[3] = 0 then
            assign estabelec.val-desp-total[3]:screen-value = "0".
        if  input estabelec.val-desp-total[3] <> 0
        and input estabelec.qtd-up-prod[3]    <> 0 then
            assign estabelec.val-unit-up[3]:screen-value = string(input estabelec.val-desp-total[3] / input estabelec.qtd-up-prod[3]).
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.val-desp-total[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.val-desp-total[1] V-table-Win
ON LEAVE OF estabelec.val-desp-total[1] IN FRAME f-main /* Val Total Desp[1] */
DO:
   do with frame {&frame-name}:
        if  input estabelec.val-desp-total[1] = 0 then
            assign estabelec.qtd-up-prod[1]:screen-value = "0".
        if  input estabelec.val-desp-total[1] <> 0
        and input estabelec.qtd-up-prod[1]    <> 0 then
            assign estabelec.val-unit-up[1]:screen-value = string(input estabelec.val-desp-total[1] / input estabelec.qtd-up-prod[1]).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.val-desp-total[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.val-desp-total[2] V-table-Win
ON LEAVE OF estabelec.val-desp-total[2] IN FRAME f-main /* Val Total Desp[2] */
DO:
   do with frame {&frame-name}:
        if  input estabelec.val-desp-total[2] = 0 then
            assign estabelec.qtd-up-prod[2]:screen-value = "0".
        if  input estabelec.val-desp-total[2] <> 0
        and input estabelec.qtd-up-prod[2]    <> 0 then
            assign estabelec.val-unit-up[2]:screen-value = string(input estabelec.val-desp-total[2] / input estabelec.qtd-up-prod[2]).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.val-desp-total[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.val-desp-total[3] V-table-Win
ON LEAVE OF estabelec.val-desp-total[3] IN FRAME f-main /* Val Total Desp[3] */
DO:
   do with frame {&frame-name}:
        if  input estabelec.val-desp-total[3] = 0 then
            assign estabelec.qtd-up-prod[3]:screen-value = "0".
        if  input estabelec.val-desp-total[3] <> 0
        and input estabelec.qtd-up-prod[3]    <> 0 then
            assign estabelec.val-unit-up[3]:screen-value = string(input estabelec.val-desp-total[3] / input estabelec.qtd-up-prod[3]).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.val-unit-up[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.val-unit-up[1] V-table-Win
ON LEAVE OF estabelec.val-unit-up[1] IN FRAME f-main /* Val Unit UP[1] */
DO:
    do with frame {&frame-name}:
        if  input estabelec.val-desp-total[1] = 0 then
            assign estabelec.qtd-up-prod[1]:screen-value = "0".
        if  input estabelec.qtd-up-prod[1] = 0 then
            assign estabelec.val-desp-total[1]:screen-value = "0".
        if  input estabelec.val-desp-total[1] <> 0
        and input estabelec.qtd-up-prod[1]    <> 0 then
            if  input estabelec.val-unit-up[1] <>
                input estabelec.val-desp-total[1] / input estabelec.qtd-up-prod[1]
            then
                assign estabelec.val-desp-total[1]:screen-value = "0"
                       estabelec.qtd-up-prod[1]:screen-value    = "0".
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.val-unit-up[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.val-unit-up[2] V-table-Win
ON LEAVE OF estabelec.val-unit-up[2] IN FRAME f-main /* Val Unit UP[2] */
DO:
    do with frame {&frame-name}:
        if  input estabelec.val-desp-total[2] = 0 then
            assign estabelec.qtd-up-prod[2]:screen-value = "0".
        if  input estabelec.qtd-up-prod[2] = 0 then
            assign estabelec.val-desp-total[2]:screen-value = "0".
        if  input estabelec.val-desp-total[2] <> 0
        and input estabelec.qtd-up-prod[2]    <> 0 then
            if  input estabelec.val-unit-up[2] <>
                input estabelec.val-desp-total[2] / input estabelec.qtd-up-prod[2]
            then
                assign estabelec.val-desp-total[2]:screen-value = "0"
                       estabelec.qtd-up-prod[2]:screen-value    = "0".
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.val-unit-up[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.val-unit-up[3] V-table-Win
ON LEAVE OF estabelec.val-unit-up[3] IN FRAME f-main /* Val Unit UP[3] */
DO:
    do with frame {&frame-name}:
        if  input estabelec.val-desp-total[3] = 0 then
            assign estabelec.qtd-up-prod[3]:screen-value = "0".
        if  input estabelec.qtd-up-prod[3] = 0 then
            assign estabelec.val-desp-total[3]:screen-value = "0".
        if  input estabelec.val-desp-total[3] <> 0
        and input estabelec.qtd-up-prod[3]    <> 0 then
            if  input estabelec.val-unit-up[3] <>
                input estabelec.val-desp-total[3] / input estabelec.qtd-up-prod[3]
            then
                assign estabelec.val-desp-total[3]:screen-value = "0"
                       estabelec.qtd-up-prod[3]:screen-value    = "0".
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-liter.i Valor_Unit rio_UP * r}
  assign c-label-1 = return-value.
  {utp/ut-liter.i Valor_Total_Despesas * r}
  assign c-label-2 = return-value.
  {utp/ut-liter.i Quantidade_UP * r}
  assign c-label-3 = return-value.
  {utp/ut-liter.i Moeda }
  assign c-tex-moeda = return-value.
  
  find first param-estoq no-lock no-error.
  if avail param-estoq then do:
     find moeda where moeda.mo-codigo = 0 no-lock no-error.
     if avail moeda then 
        assign c-descricao-1 = moeda.descricao.
     if param-estoq.tem-moeda1 then do:
        find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
        if avail moeda then 
           assign c-descricao-2 = moeda.descricao.
     end.
     else
        assign c-descricao-2 = "".
     
     if param-estoq.tem-moeda2 then do:
        find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
        if avail moeda then
           assign c-descricao-3 = moeda.descricao.
     end.
     else
        assign c-descricao-3 = "".
  end.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Valor_Unit rio_UP * r}
  assign c-label-1 = return-value.
  {utp/ut-liter.i Valor_Total_Despesas * r}
  assign c-label-2 = return-value.
  {utp/ut-liter.i Quantidade_UP * r}
  assign c-label-3 = return-value.
  
  
  find first param-estoq no-lock no-error.
  if avail param-estoq then do:
  
     find moeda where moeda.mo-codigo = 0 no-lock no-error.
     if avail moeda then
        assign c-descricao-1 = moeda.descricao.
     if param-estoq.tem-moeda1 then do:
        find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
        if avail moeda then
           assign c-descricao-2 = moeda.descricao.
     end.
     else
     assign c-descricao-2 = "".
     
     if param-estoq.tem-moeda2 then do:
        find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
        if avail moeda then
           assign c-descricao-3 = moeda.descricao.
     end.
     else
        assign c-descricao-3 = "".
 end.
 else 
    assign c-descricao-1 = ""
           c-descricao-2 = ""
           c-descricao-3 = "".
        
 disp c-label-1 c-label-2 c-label-3
      c-descricao-1 c-descricao-2 c-descricao-3
      with frame {&frame-name}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  find first param-estoq no-lock no-error.
  if avail param-estoq then do:
       
     do  i-cont = 1 to 3 :
         if i-cont = 1 and input frame {&frame-name} estabelec.val-unit-up[1] <> 0 then do:
             find first historico-up where 
                 historico-up.cod-estabel  = estabelec.cod-estabel and 
                 historico-up.mo-codigo    = 0                     and
                 historico-up.data-atualiz = today exclusive-lock no-error.
             if  not avail historico-up then
                 create historico-up.
             assign historico-up.cod-estabel     = estabelec.cod-estabel
                    historico-up.mo-codigo       = 0
                    historico-up.vl-unit-up      = input frame {&frame-name} 
                                                   estabelec.val-unit-up[i-cont]
                    historico-up.val-desp-total  = input frame {&frame-name} 
                                                   estabelec.val-desp-total[i-cont]        
                    historico-up.qtd-up-prod     = input frame {&frame-name} 
                                                   estabelec.qtd-up-prod[i-cont].
         end.
         if i-cont = 2 and input frame {&frame-name} estabelec.val-unit-up[2] <> 0 then do:
            if  param-estoq.tem-moeda1 then
                find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
            if avail moeda then do:    
               find first historico-up where 
                    historico-up.cod-estabel  = estabelec.cod-estabel and 
                    historico-up.mo-codigo    = moeda.mo-codigo       and
                    historico-up.data-atualiz = today exclusive-lock no-error.
                if  not avail historico-up then
                    create historico-up.
                assign historico-up.cod-estabel     = estabelec.cod-estabel
                       historico-up.mo-codigo       = moeda.mo-codigo
                       historico-up.vl-unit-up      = input frame {&frame-name} 
                                                      estabelec.val-unit-up[i-cont]
                       historico-up.val-desp-total  = input frame {&frame-name} 
                                                      estabelec.val-desp-total[i-cont]        
                       historico-up.qtd-up-prod     = input frame {&frame-name} 
                                                      estabelec.qtd-up-prod[i-cont].
            end.                                          
         end.
         if i-cont = 3 and input frame {&frame-name} estabelec.val-unit-up[3] <> 0 then do:
            if  param-estoq.tem-moeda2 then
                find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
            if avail moeda then do:                
               find first historico-up where 
                    historico-up.cod-estabel  = estabelec.cod-estabel and 
                    historico-up.mo-codigo    = moeda.mo-codigo       and
                    historico-up.data-atualiz = today exclusive-lock no-error.
                if  not avail historico-up then
                    create historico-up.
                assign historico-up.cod-estabel     = estabelec.cod-estabel
                       historico-up.mo-codigo       = moeda.mo-codigo
                       historico-up.vl-unit-up      = input frame {&frame-name} 
                                                      estabelec.val-unit-up[i-cont]
                       historico-up.val-desp-total  = input frame {&frame-name} 
                                                      estabelec.val-desp-total[i-cont]        
                       historico-up.qtd-up-prod     = input frame {&frame-name} 
                                                      estabelec.qtd-up-prod[i-cont].
            end.
         end.                
     end.
     assign estabelec.usa-mensal = param-estoq.log-1.
  end.
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  find first param-estoq no-lock no-error.
  if  available param-estoq then do:

      if param-estoq.tem-moeda1 = no then do:
         assign c-descricao-2:screen-value in frame {&frame-name} = ""
                estabelec.val-desp-total[2]:screen-value in frame {&frame-name} = ""
                estabelec.qtd-up-prod[2]:screen-value in frame {&frame-name} = "".
         disable {&list-4} with frame {&frame-name}.
      end.
      if param-estoq.tem-moeda2 = no then do:
         assign c-descricao-3:screen-value in frame {&frame-name} = ""
                estabelec.val-desp-total[3]:screen-value in frame {&frame-name} = ""   
                estabelec.qtd-up-prod[3]:screen-value in frame {&frame-name} = "".
         disable {&list-5} with frame {&frame-name}. 
      end.
  end.


  /* Code placed here will execute AFTER standard behavior.    */

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  find first param-estoq no-lock no-error.
  if  available param-estoq then do:
  
      if param-estoq.tem-moeda1 = no then do:
         assign c-descricao-2:screen-value in frame {&frame-name} = ""
                estabelec.val-desp-total[2]:screen-value in frame {&frame-name} = ""
                estabelec.qtd-up-prod[2]:screen-value in frame {&frame-name} = "".
         disable {&list-4} with frame {&frame-name}.
      end.
      if param-estoq.tem-moeda2 = no then do:
         assign c-descricao-3:screen-value in frame {&frame-name} = ""
                estabelec.val-desp-total[3]:screen-value in frame {&frame-name} = ""   
                estabelec.qtd-up-prod[3]:screen-value in frame {&frame-name} = "".
         disable {&list-5} with frame {&frame-name}. 
      end.
  end.
  else do:
      disable mgadm.estabelec.qtd-up-prod[1]
              mgadm.estabelec.qtd-up-prod[2]
              mgadm.estabelec.qtd-up-prod[3]
              mgadm.estabelec.val-desp-total[1]
              mgadm.estabelec.val-desp-total[2]
              mgadm.estabelec.val-desp-total[3]
              mgadm.estabelec.val-unit-up[1]
              mgadm.estabelec.val-unit-up[2]
              mgadm.estabelec.val-unit-up[3] with frame {&frame-name}.
  end.            

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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
  find first param-estoq no-lock no-error.
  if available param-estoq then do:      
     do with frame {&frame-name}:
        if estabelec.val-unit-up[1] entered
        or estabelec.val-unit-up[2] entered
        or estabelec.val-unit-up[3] entered
        or estabelec.qtd-up-prod[1] entered
        or estabelec.qtd-up-prod[2] entered
        or estabelec.qtd-up-prod[3] entered
        or estabelec.val-desp-total[1] entered
        or estabelec.val-desp-total[2] entered
        or estabelec.val-desp-total[3] entered then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 8058, /*Confirma a atualiza‡Æo da UP?*/
                           input "").
        if  return-value = "no" then 
            return "adm-error".
     end.                    
  end.
  

  if  input frame {&frame-name} estabelec.val-unit-up[1] = 0 then
      assign estabelec.val-desp-total[1]:screen-value in frame {&frame-name} = string (0)
             estabelec.qtd-up-prod[1]:screen-value in frame {&frame-name} = string (0).

  if  input frame {&frame-name} estabelec.val-unit-up[2] = 0 then
      assign estabelec.val-desp-total[2]:screen-value in frame {&frame-name} = string (0)
             estabelec.qtd-up-prod[2]:screen-value in frame {&frame-name} = string (0).
                 
  if  input frame {&frame-name} estabelec.val-unit-up[3] = 0 then
      assign estabelec.val-desp-total[3]:screen-value in frame {&frame-name} = string (0)
             estabelec.qtd-up-prod[3]:screen-value in frame {&frame-name} = string (0).      
  
  
/*  do i-cont = 1 to 3:
 *   
 *         if  input estabelec.val-desp-total[i-cont] <> 0
 *         and input estabelec.qtd-up-prod[i-cont]    <> 0 then do:
 *             if  input estabelec.val-unit-up[i-cont] <> 
 *             (input estabelec.val-desp-total[i-cont] / input estabelec.qtd-up-prod[i-cont]) then do:
 *                 if  i-cont = 1 then do:
 *                     {include/i-vldprg.i}
 *                     run utp/ut-msgs.p (input "show",
 *                                        input 8072 ,
 *                                        input c-descricao-1).
 *                     apply "entry" to estabelec.val-unit-up[1] in frame {&frame-name}.                   
 *                     return "ADM-ERROR":U.
 *                 end.
 *                 if  i-cont = 2 then do:
 *                     {include/i-vldprg.i}
 *                     if param-estoq.tem-moeda1 then do:
 *                         run utp/ut-msgs.p (input "show",
 *                                            input 8072 ,
 *                                            input c-descricao-2).
 *                         apply "entry" to estabelec.val-unit-up[2] in frame {&frame-name}.                   
 *                         return "ADM-ERROR":U.
 *                     end.
 *                 end.
 *                 if  i-cont = 3 then do:
 *                     {include/i-vldprg.i}             
 *                     if param-estoq.tem-moeda2 then do:       
 *                         run utp/ut-msgs.p (input "show",
 *                                            input 8072 ,
 *                                            input c-descricao-3).
 *                         apply "entry" to estabelec.val-unit-up[3] in frame {&frame-name}.
 *                         return "ADM-ERROR":U.
 *                     end.
 *                 end.                
 *             end.
 *             if  input estabelec.val-unit-up[i-cont] = 0 then do:
 *                 if  i-cont = 1 then do:
 *                     {include/i-vldprg.i}
 *                     run utp/ut-msgs.p (input "show",
 *                                        input 8072 ,
 *                                        input c-descricao-1).
 *                     apply "entry" to estabelec.val-unit-up[1] in frame {&frame-name}.                                       
 *                     return "ADM-ERROR":U.
 *                 end.
 *                 if  i-cont = 2 then do:
 *                     {include/i-vldprg.i}     
 *                     if param-estoq.tem-moeda1 then do:               
 *                         run utp/ut-msgs.p (input "show",
 *                                            input 8072 ,
 *                                            input c-descricao-2).
 *                         apply "entry" to estabelec.val-unit-up[2] in frame {&frame-name}.
 *                         return "ADM-ERROR":U.
 *                     end.
 *                 end.
 *                 if  i-cont = 3 then do:
 *                     {include/i-vldprg.i}     
 *                     if param-estoq.tem-moeda2 then do:                                   
 *                         run utp/ut-msgs.p (input "show",
 *                                            input 8072 ,
 *                                            input c-descricao-3).
 *                         apply "entry" to estabelec.val-unit-up[3] in frame {&frame-name}.
 *                         return "ADM-ERROR":U.
 *                     end.
 *                 end.
 *             end.
 *       
 *         end. 
 *         else do:
 *             if  (input estabelec.val-desp-total[i-cont] = 0
 *             or  input estabelec.qtd-up-prod[i-cont]    = 0)
 *             and input estabelec.val-unit-up[i-cont] = 0 then do:
 *                 if  i-cont = 1 then do:
 *                     {include/i-vldprg.i}                    
 *                     run utp/ut-msgs.p (input "show",
 *                                        input 8072 ,
 *                                        input c-descricao-1).
 *                     apply "entry" to estabelec.val-unit-up[1] in frame {&frame-name}.
 *                     return "ADM-ERROR":U.
 *                 end.
 *                 if  i-cont = 2 then do:
 *                     {include/i-vldprg.i}     
 *                     if param-estoq.tem-moeda1 then do:                                   
 *                         run utp/ut-msgs.p (input "show",
 *                                            input 8072 ,
 *                                            input c-descricao-2).
 *                         apply "entry" to estabelec.val-unit-up[2] in frame {&frame-name}.
 *                         return "ADM-ERROR":U.
 *                     end.
 *                 end.
 *                 if  i-cont = 3 then do:
 *                     {include/i-vldprg.i}                    
 *                     if param-estoq.tem-moeda2 then do:                    
 *                         run utp/ut-msgs.p (input "show",
 *                                            input 8072 ,
 *                                            input c-descricao-3).
 *                         apply "entry" to estabelec.val-unit-up[3] in frame {&frame-name}.
 *                         return "ADM-ERROR":U.
 *                     end.
 *                 end.
 *             end.
 *         end.
 *   end.*/     
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
  {src/adm/template/snd-list.i "estabelec"}

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


