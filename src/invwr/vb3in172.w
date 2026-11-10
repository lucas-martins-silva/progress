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
{include/i-prgvrs.i VB3IN172 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i VB3IN172 MUT}
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
def new global shared var v-row-parent as rowid no-undo.   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-classe-lista as char no-undo.
def var c-lista-politica as char no-undo.
def var c-lista-formula as char no-undo.
def var c-lista-tipo as char no-undo.
def new global shared var gr-est-prod  as rowid no-undo.
def new global shared var v-row-parent as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES est-prod item
&Scoped-define FIRST-EXTERNAL-TABLE est-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR est-prod, item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.fator-refugo item.quant-perda ~
item.tipo-est-seg item.quant-segur item.lote-multipl item.tempo-segur ~
item.lote-minimo item.lote-economi item.periodo-fixo item.res-cq-comp ~
item.res-cq-fabri 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}fator-refugo ~{&FP2}fator-refugo ~{&FP3}~
 ~{&FP1}quant-perda ~{&FP2}quant-perda ~{&FP3}~
 ~{&FP1}quant-segur ~{&FP2}quant-segur ~{&FP3}~
 ~{&FP1}lote-multipl ~{&FP2}lote-multipl ~{&FP3}~
 ~{&FP1}tempo-segur ~{&FP2}tempo-segur ~{&FP3}~
 ~{&FP1}lote-minimo ~{&FP2}lote-minimo ~{&FP3}~
 ~{&FP1}lote-economi ~{&FP2}lote-economi ~{&FP3}~
 ~{&FP1}periodo-fixo ~{&FP2}periodo-fixo ~{&FP3}~
 ~{&FP1}res-cq-comp ~{&FP2}res-cq-comp ~{&FP3}~
 ~{&FP1}res-cq-fabri ~{&FP2}res-cq-fabri ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold-2 rt-temp-qt-seg 
&Scoped-Define DISPLAYED-FIELDS item.fator-refugo item.quant-perda ~
item.tipo-est-seg item.quant-segur item.lote-multipl item.tempo-segur ~
item.lote-minimo item.lote-economi item.periodo-fixo item.res-cq-comp ~
item.res-cq-fabri 
&Scoped-Define DISPLAYED-OBJECTS c-politica c-classe-repro c-formula ~
c-tipo-con-est c-tipo-est-seg 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS item.fator-refugo item.quant-perda ~
item.tipo-est-seg item.quant-segur item.lote-multipl item.tempo-segur ~
item.lote-minimo item.lote-economi item.periodo-fixo item.res-cq-comp ~
item.res-cq-fabri 

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
DEFINE VARIABLE c-classe-repro AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-formula AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-politica AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 30.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-con-est AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 47 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-est-seg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 27 BY .63 NO-UNDO.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 10.

DEFINE RECTANGLE rt-temp-qt-seg
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 2.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.fator-refugo AT ROW 1.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     item.quant-perda AT ROW 2.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.tipo-est-seg AT ROW 3 COL 53 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Quantidade", 1,
"Tempo", 2
          SIZE 15 BY 2.17
     item.quant-segur AT ROW 3.13 COL 65.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.lote-multipl AT ROW 3.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.tempo-segur AT ROW 4.08 COL 65.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     item.lote-minimo AT ROW 4.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.lote-economi AT ROW 5.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     c-politica AT ROW 6.25 COL 47 COLON-ALIGNED
     item.periodo-fixo AT ROW 6.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-classe-repro AT ROW 7.25 COL 47 COLON-ALIGNED
     item.res-cq-comp AT ROW 7.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-formula AT ROW 8.25 COL 47 COLON-ALIGNED
     item.res-cq-fabri AT ROW 8.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-tipo-con-est AT ROW 9.5 COL 22 COLON-ALIGNED
     c-tipo-est-seg AT ROW 2.25 COL 46.86 COLON-ALIGNED NO-LABEL
     rt-mold-2 AT ROW 1 COL 1
     rt-temp-qt-seg AT ROW 2.54 COL 45
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.est-prod,mgind.item
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
         HEIGHT             = 10
         WIDTH              = 85.72.
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

/* SETTINGS FOR FILL-IN c-classe-repro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-formula IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-politica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-con-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-est-seg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.fator-refugo IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.lote-economi IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.lote-minimo IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.lote-multipl IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.periodo-fixo IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.quant-perda IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.quant-segur IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.res-cq-comp IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.res-cq-fabri IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.tempo-segur IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR RADIO-SET item.tipo-est-seg IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME c-tipo-est-seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo-est-seg V-table-Win
ON LEAVE OF c-tipo-est-seg IN FRAME f-main
DO:
    if  input frame {&frame-name} item.tipo-est-seg = {ininc/i05in122.i 04 1}
    then do with frame {&frame-name}:
        enable  item.quant-segur.
        disable item.tempo-segur.
    end.
    else do with frame {&frame-name}:
        enable  item.tempo-segur.
        disable item.quant-segur.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.lote-multipl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.lote-multipl V-table-Win
ON LEAVE OF item.lote-multipl IN FRAME f-main /* Lote M£ltiplo */
DO:
    if  input frame {&frame-name} item.lote-multipl <>  truncate(item.lote-multipl,0)
        and item.fraciona = no
    then do:
        run utp/ut-msgs.p (input "show",
                           input 907, 
                           input "").
        apply 'entry' to item.lote-multipl in frame {&frame-name}.
        return 'adm-error'.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.tipo-est-seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.tipo-est-seg V-table-Win
ON VALUE-CHANGED OF item.tipo-est-seg IN FRAME f-main /* Est Seg */
DO:
    if  input frame {&frame-name} item.tipo-est-seg = 1 then do with frame {&frame-name}:
        enable item.quant-segur.
        disable item.tempo-segur.
    end.
    else do with frame {&frame-name}:
        enable item.tempo-segur.
        disable item.quant-segur.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 assign c-classe-lista = {ininc/i06in122.i 03}.
 {utp/ut-field.i mgind item classe-repro 01}
 assign c-classe-repro:label = return-value. 
 {utp/ut-field.i mgind item politica 01}
 assign c-politica:label = return-value.
 {utp/ut-field.i mgind item cd-formula 01}
 assign c-formula:label = return-value. 
 {utp/ut-field.i mgind item tipo-con-est 01}
 assign c-tipo-con-est:label = return-value.
 &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
 &ENDIF           
/************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "est-prod"}
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "est-prod"}
  {src/adm/template/row-find.i "item"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}.
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

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
  if  available item THEN DO:
    RUN utp/ut-liter.p (trim(entry(item.classe-repro, c-classe-lista)), "*", "").
    assign c-classe-repro = RETURN-VALUE.
  END.
  else
      assign c-classe-repro = " ".

   RUN utp/ut-liter.p (trim(entry(item.politica, c-lista-politica)), "*", "").
   assign c-politica     = RETURN-VALUE.
   RUN utp/ut-liter.p (trim(entry(item.cd-formula, c-lista-formula)), "*", "").
   assign c-formula      = RETURN-VALUE.
   RUN utp/ut-liter.p (trim(entry(item.tipo-con-est, c-lista-tipo)), "*", "").
   assign c-tipo-con-est = RETURN-VALUE.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  {utp/ut-rtlbl.i mgind item tipo-est-seg c-tipo-est-seg}.

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
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

  assign c-lista-politica = {ininc/i04in122.i 03}.    
  assign c-lista-formula  = {ininc/i24in172.i 03}.
  assign c-lista-tipo     = {ininc/i01in122.i 03}.

  {utp/ut-rtlbl.i mgind item tipo-est-seg c-tipo-est-seg}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   if avail est-prod then
      assign gr-est-prod      = rowid(est-prod)
              v-row-parent = rowid(est-prod).
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
  {src/adm/template/snd-list.i "est-prod"}
  {src/adm/template/snd-list.i "item"}

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


