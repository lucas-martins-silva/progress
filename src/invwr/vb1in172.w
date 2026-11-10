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
{include/i-prgvrs.i VB1IN172 2.00.01.002}  /*** 010102 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i VB1IN172 MUT}
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
&IF "{&mguni_version}" >= "2.071" &THEN
def new global shared var c-cod-estabel as character format "x(05)" no-undo.
&ELSE
def new global shared var c-cod-estabel as character format "x(3)" no-undo.
&ENDIF

{cdp/cdcfgman.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-26 RECT-33 rt-temp-qt-seg RECT-27 
&Scoped-Define DISPLAYED-OBJECTS fi-lote-economi cb-politica ~
fi-periodo-fixo cb-demanda c-pto-repos fi-lote-multipl fi-quant-segur ~
fi-lote-minimo r-tipo-est-seg fi-tempo-segur tb-conv-tempo-seg ~
cb-reab-estoq c-liter-estoq 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fi-lote-economi cb-politica ~
fi-periodo-fixo cb-demanda c-pto-repos fi-lote-multipl fi-quant-segur ~
fi-lote-minimo r-tipo-est-seg fi-tempo-segur tb-conv-tempo-seg ~
cb-reab-estoq 
&Scoped-define ADM-MODIFY-FIELDS fi-lote-economi cb-politica ~
fi-periodo-fixo cb-demanda c-pto-repos fi-lote-multipl fi-quant-segur ~
fi-lote-minimo r-tipo-est-seg fi-tempo-segur tb-conv-tempo-seg ~
cb-reab-estoq 

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
DEFINE VARIABLE cb-demanda AS CHARACTER FORMAT "X(15)" INITIAL "1" 
     LABEL "":R18 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS " "
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-politica AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reab-estoq AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS " "
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-liter-estoq AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE c-pto-repos AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0.00 
     LABEL "Ponto Reposi‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-est-seg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .63 NO-UNDO.

DEFINE VARIABLE fi-lote-economi AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote-minimo AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-lote-multipl AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-fixo AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quant-segur AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tempo-segur AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE r-tipo-est-seg AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Quantidade", 1,
"Tempo", 2
     SIZE 14.14 BY 1.75 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 8.71.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 3.3.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 2.49.

DEFINE RECTANGLE rt-temp-qt-seg
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 2.4.

DEFINE VARIABLE tb-conv-tempo-seg AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .79 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-lote-economi AT ROW 1.21 COL 62 COLON-ALIGNED
     cb-politica AT ROW 1.5 COL 19 COLON-ALIGNED
     fi-periodo-fixo AT ROW 2.21 COL 62 COLON-ALIGNED
     cb-demanda AT ROW 2.67 COL 19 COLON-ALIGNED HELP
          "Tipo de Demanda do Item"
     c-pto-repos AT ROW 3.21 COL 62 COLON-ALIGNED
     fi-lote-multipl AT ROW 3.83 COL 19 COLON-ALIGNED
     fi-quant-segur AT ROW 4.8 COL 63 COLON-ALIGNED NO-LABEL
     fi-lote-minimo AT ROW 4.83 COL 19 COLON-ALIGNED
     r-tipo-est-seg AT ROW 5 COL 47 NO-LABEL
     fi-tempo-segur AT ROW 5.8 COL 63 COLON-ALIGNED NO-LABEL
     tb-conv-tempo-seg AT ROW 7.8 COL 46
     cb-reab-estoq AT ROW 8.54 COL 66 COLON-ALIGNED
     c-tipo-est-seg AT ROW 4.35 COL 44 COLON-ALIGNED NO-LABEL
     c-liter-estoq AT ROW 7.05 COL 47 NO-LABEL
     RECT-26 AT ROW 1 COL 1
     RECT-33 AT ROW 7.2 COL 44
     rt-temp-qt-seg AT ROW 4.5 COL 44
     RECT-27 AT ROW 1 COL 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 8.71
         WIDTH              = 84.72.
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

/* SETTINGS FOR FILL-IN c-liter-estoq IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-pto-repos IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-tipo-est-seg IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX cb-demanda IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-politica IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-reab-estoq IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-lote-economi IN FRAME f-main
   NO-ENABLE 2 3 DEF-LABEL                                              */
/* SETTINGS FOR FILL-IN fi-lote-minimo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-lote-multipl IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-periodo-fixo IN FRAME f-main
   NO-ENABLE 2 3 DEF-LABEL                                              */
/* SETTINGS FOR FILL-IN fi-quant-segur IN FRAME f-main
   NO-ENABLE 2 3 DEF-LABEL                                              */
/* SETTINGS FOR FILL-IN fi-tempo-segur IN FRAME f-main
   NO-ENABLE 2 3 DEF-LABEL                                              */
/* SETTINGS FOR RADIO-SET r-tipo-est-seg IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX tb-conv-tempo-seg IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

    &IF DEFINED (bf_man_203) &THEN
      {utp/ut-field.i mgind item-uni-estab politica 1}
      assign cb-politica:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-uni-estab demanda 1}
      assign cb-demanda:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-uni-estab conv-tempo-seg 01}
      assign tb-conv-tempo-seg:label in frame {&frame-name} = return-value.
      {utp/ut-liter.i Reabastecimento MPL r}
      assign cb-reab-estoq:label in frame {&frame-name} = return-value.
      {utp/ut-liter.i Estoque_de_Segurança * r}
      assign c-liter-estoq = trim(return-value).
      {utp/ut-field.i mgind item-uni-estab lote-multipl 1}
      assign fi-lote-multipl:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-uni-estab lote-minimo 1}
      assign fi-lote-minimo:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-uni-estab lote-economi 1}
      assign fi-lote-economi:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-uni-estab periodo-fixo 1}
      assign fi-periodo-fixo:label in frame {&frame-name} = return-value.
/*
      {utp/ut-field.i mgind item-uni-estab quant-segur 1}
      assign fi-quant-segur:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item-uni-estab tempo-segur 1}
      assign fi-tempo-segur:label in frame {&frame-name} = return-value.
*/

      {utp/ut-rtlbl.i mgind item-uni-estab tipo-est-seg c-tipo-est-seg}
    &ELSE
      {utp/ut-field.i mgind item politica 1}
      assign cb-politica:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item demanda 1}
      assign cb-demanda:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item conv-tempo-seg 01}
      assign tb-conv-tempo-seg:label in frame {&frame-name} = return-value.
      {utp/ut-liter.i Reabastecimento MPL r}
      assign cb-reab-estoq:label in frame {&frame-name} = return-value.
      {utp/ut-liter.i Estoque_de_Segurança * r}
      assign c-liter-estoq = trim(return-value).
      {utp/ut-field.i mgind item lote-multipl 1}
      assign fi-lote-multipl:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item lote-minimo 1}
      assign fi-lote-minimo:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item lote-economi 1}
      assign fi-lote-economi:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item periodo-fixo 1}
      assign fi-periodo-fixo:label in frame {&frame-name} = return-value.
/*
      {utp/ut-field.i mgind item quant-segur 1}
      assign fi-quant-segur:label in frame {&frame-name} = return-value.
      {utp/ut-field.i mgind item tempo-segur 1}
      assign fi-tempo-segur:label in frame {&frame-name} = return-value.
*/
      {utp/ut-rtlbl.i mgind item tipo-est-seg c-tipo-est-seg}
    &ENDIF

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
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
      disable cb-reab-estoq  with frame {&frame-name}.
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

  &IF DEFINED (bf_man_203) &THEN
  find first item-uni-estab
       where item-uni-estab.cod-estabel = c-cod-estabel
         and item-uni-estab.it-codigo   = item.it-codigo no-lock no-error.
    if  avail item-uni-estab then do with frame {&frame-name}:
          assign cb-politica     = {ininc/i04in122.i 04 item-uni-estab.politica}
                 cb-demanda      = {ininc/i02in122.i 04 item-uni-estab.demanda}
                 cb-reab-estoq   = if substr(item-uni-estab.char-1,10,1) = "" then 
                                            {ininc/i26in172.i 04 1} 
                                   else {ininc/i26in172.i 04 int(substr(item-uni-estab.char-1,10,1))}
                 cb-politica:screen-value   = cb-politica.
         assign  cb-demanda:screen-value    = cb-demanda
                 cb-reab-estoq:screen-value = cb-reab-estoq
                 tb-conv-tempo-seg          = item-uni-estab.conv-tempo-seg
                 fi-lote-multipl            = item-uni-estab.lote-multipl
                 fi-lote-minimo             = item-uni-estab.lote-minimo
                 fi-lote-economi            = item-uni-estab.lote-economi
                 fi-periodo-fixo            = item-uni-estab.periodo-fixo
                 r-tipo-est-seg             = item-uni-estab.tipo-est-seg
                 fi-quant-segur             = item-uni-estab.quant-segur
                 fi-tempo-segur             = item-uni-estab.tempo-segur.
    end.
    else do:
        if avail item then do with frame {&frame-name}: 
          assign cb-politica     = {ininc/i04in122.i 04 item.politica}
                 cb-demanda      = {ininc/i02in122.i 04 item.demanda}
                 cb-reab-estoq   = if substr(item.char-1,10,1) = "" then 
                                            {ininc/i26in172.i 04 1} 
                                   else {ininc/i26in172.i 04 int(substr(item.char-1,10,1))}
                 cb-politica:screen-value   = cb-politica.
         assign  cb-demanda:screen-value    = cb-demanda
                 cb-reab-estoq:screen-value = cb-reab-estoq
                 tb-conv-tempo-seg          = item.conv-tempo-seg
                 fi-lote-multipl            = item.lote-multipl
                 fi-lote-minimo             = item.lote-minimo
                 fi-lote-economi            = item.lote-economi
                 fi-periodo-fixo            = item.periodo-fixo
                 r-tipo-est-seg             = item.tipo-est-seg
                 fi-quant-segur             = item.quant-segur
                 fi-tempo-segur             = item.tempo-segur.
        end.
        else do:
             assign cb-politica     = {ininc/i04in122.i 04 1}
                    cb-demanda      = {ininc/i02in122.i 04 1}
                    cb-reab-estoq   = {ininc/i26in172.i 04 1}
                    fi-lote-multipl = 0
                    fi-lote-minimo  = 0
                    fi-lote-economi = 0
                    fi-periodo-fixo = 0
                    r-tipo-est-seg  = 1
                    fi-quant-segur  = 0
                    fi-tempo-segur  = 0.
        end.         
    end.
    &ELSE
      if avail item then do with frame {&frame-name}: 
         assign cb-politica     = {ininc/i04in122.i 04 item.politica}
                cb-demanda      = {ininc/i02in122.i 04 item.demanda}
                cb-reab-estoq   = if substr(item.char-1,10,1) = "" then 
                                            {ininc/i26in172.i 04 1}
                                   else {ininc/i26in172.i 04 int(substr(item.char-1,10,1))}
                 cb-politica:screen-value   = cb-politica.

         assign  cb-demanda:screen-value    = cb-demanda
                 cb-reab-estoq:screen-value = cb-reab-estoq
                 tb-conv-tempo-seg          = item.conv-tempo-seg
                 fi-lote-multipl            = item.lote-multipl
                 fi-lote-minimo             = item.lote-minimo
                 fi-lote-economi            = item.lote-economi
                 fi-periodo-fixo            = item.periodo-fixo
                 r-tipo-est-seg             = item.tipo-est-seg
                 fi-quant-segur             = item.quant-segur
                 fi-tempo-segur             = item.tempo-segur.
      end.
      else do:
           assign cb-politica       = {ininc/i04in122.i 04 1}
                  cb-demanda        = {ininc/i02in122.i 04 1}
                  cb-reab-estoq     = {ininc/i26in172.i 04 1}
                  tb-conv-tempo-seg = no
                  fi-lote-multipl   = 0
                  fi-lote-minimo    = 0
                  fi-lote-economi   = 0
                  fi-periodo-fixo   = 0
                  r-tipo-est-seg    = 1
                  fi-quant-segur    = 0
                  fi-tempo-segur    = 0.
      end.
  &ENDIF.

  &IF DEFINED (bf_man_ponto_repos) &THEN   
  assign c-pto-repos = item.pto-repos.
  &ENDIF



  display cb-politica
          cb-demanda
          cb-reab-estoq
          fi-lote-multipl
          fi-lote-minimo
          fi-lote-economi
          fi-periodo-fixo
          r-tipo-est-seg
          fi-quant-segur
          fi-tempo-segur
          tb-conv-tempo-seg with frame {&frame-name}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */

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
  do with frame {&frame-name}:
     assign cb-politica:list-items     = {ininc/i04in122.i 03}
            cb-demanda:list-items      = {ininc/i02in122.i 03}
            cb-reab-estoq:list-items   = {ininc/i26in172.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &IF DEFINED (bf_man_ponto_repos) &THEN   
  assign c-pto-repos:hidden in frame {&frame-name} = no.
  &ELSE
  assign c-pto-repos:hidden in frame {&frame-name} = yes.
  &ENDIF


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


