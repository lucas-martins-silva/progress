&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V04IN686 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN686 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgman.i}

def var v-row-parent as rowid no-undo.
def var i-politica as integer no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES fam-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE fam-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR fam-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS fam-uni-estab.lote-multipl ~
fam-uni-estab.lote-minimo fam-uni-estab.fator-refugo ~
fam-uni-estab.quant-perda fam-uni-estab.lote-economi ~
fam-uni-estab.periodo-fixo fam-uni-estab.tipo-est-seg ~
fam-uni-estab.quant-segur fam-uni-estab.tempo-segur 
&Scoped-define ENABLED-TABLES fam-uni-estab
&Scoped-define FIRST-ENABLED-TABLE fam-uni-estab
&Scoped-define DISPLAYED-TABLES fam-uni-estab
&Scoped-define FIRST-DISPLAYED-TABLE fam-uni-estab
&Scoped-Define ENABLED-OBJECTS RECT-27 RECT-28 RECT-36 rt-temp-qt-seg 
&Scoped-Define DISPLAYED-FIELDS fam-uni-estab.lote-multipl ~
fam-uni-estab.lote-minimo fam-uni-estab.fator-refugo ~
fam-uni-estab.quant-perda fam-uni-estab.lote-economi ~
fam-uni-estab.periodo-fixo fam-uni-estab.tipo-est-seg ~
fam-uni-estab.quant-segur fam-uni-estab.tempo-segur 
&Scoped-Define DISPLAYED-OBJECTS cb-politica cb-demanda c-pto-repos ~
cb-reab-estoq tb-conv-tempo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-politica cb-demanda c-pto-repos ~
cb-reab-estoq tb-conv-tempo 
&Scoped-define ADM-MODIFY-FIELDS cb-politica cb-demanda c-pto-repos ~
cb-reab-estoq tb-conv-tempo 

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
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-politica AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reab-estoq AS CHARACTER FORMAT "X(10)":U 
     LABEL "Reabastecimento" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-pto-repos AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Ponto Reposiá∆o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-tipo-est-seg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.72 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.14 BY 3.17.

DEFINE RECTANGLE RECT-28
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.43 BY 8.29.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.72 BY 2.25.

DEFINE RECTANGLE rt-temp-qt-seg
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40.29 BY 2.46.

DEFINE VARIABLE tb-conv-tempo AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-politica AT ROW 1.54 COL 20 COLON-ALIGNED
     cb-demanda AT ROW 2.54 COL 20 COLON-ALIGNED HELP
          "Tipo de Demanda do Item"
     fam-uni-estab.lote-multipl AT ROW 3.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fam-uni-estab.lote-minimo AT ROW 4.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fam-uni-estab.fator-refugo AT ROW 5.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     fam-uni-estab.quant-perda AT ROW 6.54 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fam-uni-estab.lote-economi AT ROW 1.21 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fam-uni-estab.periodo-fixo AT ROW 2.21 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-pto-repos AT ROW 3.21 COL 65 COLON-ALIGNED
     fam-uni-estab.tipo-est-seg AT ROW 5.04 COL 48 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Quantidade", 1,
"Tempo", 2
          SIZE 14 BY 1.75
     fam-uni-estab.quant-segur AT ROW 4.96 COL 65 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fam-uni-estab.tempo-segur AT ROW 5.96 COL 65 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cb-reab-estoq AT ROW 7.29 COL 64.72 COLON-ALIGNED
     tb-conv-tempo AT ROW 8.33 COL 52.72
     c-tipo-est-seg AT ROW 4.25 COL 43.72 COLON-ALIGNED NO-LABEL
     RECT-27 AT ROW 1.04 COL 45
     RECT-28 AT ROW 1.04 COL 1.14
     RECT-36 AT ROW 7.08 COL 44.72
     rt-temp-qt-seg AT ROW 4.54 COL 44.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.fam-uni-estab
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.33
         WIDTH              = 84.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

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
/* SETTINGS FOR TOGGLE-BOX tb-conv-tempo IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-tipo-est-seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo-est-seg V-table-Win
ON LEAVE OF c-tipo-est-seg IN FRAME f-main
DO:
    if  input frame {&frame-name} fam-uni-estab.tipo-est-seg = 1
    then do with frame {&frame-name}:
        enable  fam-uni-estab.quant-segur.
        disable fam-uni-estab.tempo-segur.
    end.
    else do with frame {&frame-name}:
        enable  fam-uni-estab.tempo-segur.
        disable fam-uni-estab.quant-segur.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-politica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-politica V-table-Win
ON VALUE-CHANGED OF cb-politica IN FRAME f-main
DO:
    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 then do  with frame {&frame-name}:
        enable  fam-uni-estab.periodo-fixo.
    end.
    else do  with frame {&frame-name}:
        disable fam-uni-estab.periodo-fixo.
    end.        

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2 then do:
        enable fam-uni-estab.lote-ec 
               with frame {&frame-name}.
    end.
    else do with frame {&frame-name}:
        disable fam-uni-estab.lote-ec.
    end.

    &IF DEFINED (bf_man_ponto_repos) &THEN   
    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 7 then do with frame {&frame-name}:
        enable c-pto-repos.
      /*  assign c-pto-repos:sensitive in frame {&frame-name} = yes. */
    end.
    else do with frame {&frame-name}:
       disable c-pto-repos.
    end.
       /* assign c-pto-repos:sensitive in frame {&frame-name} = no. */
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fam-uni-estab.tipo-est-seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fam-uni-estab.tipo-est-seg V-table-Win
ON VALUE-CHANGED OF fam-uni-estab.tipo-est-seg IN FRAME f-main /* Est Seg */
DO:
    if  input frame {&frame-name} fam-uni-estab.tipo-est-seg = 1 then do with frame {&frame-name}:
        enable fam-uni-estab.quant-segur.
        disable fam-uni-estab.tempo-segur.
    end.
    else do with frame {&frame-name}:
        enable fam-uni-estab.tempo-segur.
        disable fam-uni-estab.quant-segur.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  {utp/ut-rtlbl.i mgind fam-uni-estab tipo-est-seg c-tipo-est-seg}

  {utp/ut-field.i mgind fam-uni-estab politica 1}
  assign cb-politica:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind fam-uni-estab demanda 1}
  assign cb-demanda:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Reabastecimento MPL r}
  assign cb-reab-estoq:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind fam-uni-estab conv-tempo-seg 01}
  assign tb-conv-tempo:label in frame {&frame-name} = return-value.


  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "fam-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "fam-uni-estab"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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

    {utp/ut-rtlbl.i mgind fam-uni-estab tipo-est-seg c-tipo-est-seg}

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    assign fam-uni-estab.politica       = {ininc/i04in122.i 06 cb-politica}
           fam-uni-estab.demanda        = {ininc/i02in122.i 06 cb-demanda}
           fam-uni-estab.conv-tempo-seg = input frame {&frame-name} tb-conv-tempo
    substr(fam-uni-estab.char-1,10,1)   = string({ininc/i26in172.i 06 cb-reab-estoq}).

    &IF DEFINED (bf_man_ponto_repos) &THEN   
    assign fam-uni-estab.pto-repos = input frame {&frame-name} c-pto-repos.
    &ENDIF

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

    if  avail fam-uni-estab then do with frame {&frame-name}: 
        assign cb-politica     = {ininc/i04in122.i 04 fam-uni-estab.politica}
               cb-demanda      = {ininc/i02in122.i 04 fam-uni-estab.demanda}
               cb-reab-estoq   = if substr(fam-uni-estab.char-1,10,1) = "" 
                                 then {ininc/i26in172.i 04 1} 
                                 else {ininc/i26in172.i 04 int(substr(fam-uni-estab.char-1,10,1))} 
               tb-conv-tempo   = fam-uni-estab.conv-tempo-seg.

        &IF DEFINED (bf_man_ponto_repos) &THEN   
        assign c-pto-repos = fam-uni-estab.pto-repos.                     
        &ENDIF

    end.         
    else do:
        assign cb-politica     = {ininc/i04in122.i 04 1}
               cb-demanda      = {ininc/i02in122.i 04 1}
               cb-reab-estoq   = {ininc/i26in172.i 04 1}.
    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if  input frame {&frame-name} fam-uni-estab.tipo-est-seg = 1 then do with frame {&frame-name}:
        enable  fam-uni-estab.quant-segur.
        disable fam-uni-estab.tempo-segur. 
    end.
    else do with frame {&frame-name}:
        enable  fam-uni-estab.tempo-segur.
        disable fam-uni-estab.quant-segur.
    end.    

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 then do with frame {&frame-name}:
        enable  fam-uni-estab.periodo-fixo.
    end.
    else do  with frame {&frame-name}:
        disable fam-uni-estab.periodo-fixo.
    end.        

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2 then do:
        enable fam-uni-estab.lote-ec with frame {&frame-name}.
    end.
    else do with frame {&frame-name}:
        disable fam-uni-estab.lote-ec.
    end.

    &IF DEFINED (bf_man_ponto_repos) &THEN   
    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 7 then do with frame {&frame-name}:
        enable  c-pto-repos.
    end.
    else do with frame {&frame-name}:
        disable c-pto-repos.
    end.
    &ENDIF

   &IF DEFINED (bf_man_ponto_repos) &THEN   
       assign c-pto-repos:hidden in frame {&frame-name} = no.
  &ELSE
       assign c-pto-repos:hidden in frame {&frame-name} = yes.
  &ENDIF

    apply 'value-changed' to cb-politica in frame {&frame-name}.

    enable cb-reab-estoq with frame {&frame-name}.



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

 find first param-global no-lock no-error. 

    do  with frame {&frame-name}:
        assign cb-politica:list-items     = {ininc/i04in122.i 03}
               cb-demanda:list-items      = {ininc/i02in122.i 03}
               cb-reab-estoq:list-items   = {ininc/i26in172.i 03}.
    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF DEFINED (bf_man_ponto_repos) &THEN   
  assign c-pto-repos:hidden in frame {&frame-name} = no.
  &ELSE
  assign c-pto-repos:hidden in frame {&frame-name} = yes.
  &ENDIF

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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 
       and input frame {&frame-name} fam-uni-estab.periodo-fixo = 0 then do:
      {utp/ut-field.i mgind fam-uni-estab periodo-fixo 1}
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 4570,
                         input return-value).
      apply 'entry' to fam-uni-estab.periodo-fixo in frame {&frame-name}.
      return 'adm-error':U. 
  end.

  if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2
      and input frame {&frame-name} fam-uni-estab.lote-economi = 0 then do:
     {utp/ut-field.i mgind fam-uni-estab lote-economi 1}
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show",
                        input 4570,
                        input return-value).
     apply 'entry' to fam-uni-estab.lote-economi in frame {&frame-name}.
     return 'adm-error':U. 
  end.

  find familia
      where familia.fm-codigo = fam-uni-estab.fm-codigo no-lock no-error.

  if  input frame {&frame-name} fam-uni-estab.lote-multipl <> 
      truncate(input frame {&frame-name} fam-uni-estab.lote-multipl,0)
  and familia.fraciona = no
  then do:
     {include/i-vldprg.i} 
     run utp/ut-msgs.p (input "show",
                         input 907, 
                         input "").
      apply 'entry' to fam-uni-estab.lote-multipl in frame {&frame-name}.
      return 'adm-error'.
  end.

  if {ininc/i26in172.i 06 cb-reab-estoq:screen-value in frame {&frame-name}} = 2 then do:
      assign i-politica = {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}}.
      if i-politica = 3 or i-politica = 4 then do:
          {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */   
          run utp/ut-msgs.p ("Show",
                             16490,
                             "").
           apply "entry" to cb-reab-estoq.
           return "adm-error":U.
      end.
  end.     

  &IF DEFINED (bf_man_ponto_repos) &THEN   
  assign i-politica = {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}}.

   if  i-politica = 7 then do :   

     if  input frame {&frame-name} fam-uni-estab.quant-segur >= 
         input frame {&frame-name} c-pto-repos then do:
         {utp/ut-field.i mgind fam-uni-estab quant-segur 1} 
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show",
                            input 26786,
                            input return-value).
         apply 'entry' to fam-uni-estab.quant-segur in frame {&frame-name}.
         return 'adm-error':U. 
     end.
  end.
  &ENDIF


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "fam-uni-estab"}

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

