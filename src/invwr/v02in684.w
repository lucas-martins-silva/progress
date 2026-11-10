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
{include/i-prgvrs.i V02IN684 2.00.00.030 } /*** 010030 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in684 MUT}
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
{cdp/cdcfgmat.i}
{cdp/cd9043.i} 


def var v-row-parent as rowid no-undo.

def temp-table tt-item-2 like item-uni-estab.

def var i-politica  as integer no-undo.
def var i-lista-mrp as integer init 1 no-undo.

{inbo/boin684.i1 item-uni-estab tt-item-2 "not avail"}

def var h_02  as handle no-undo.
def var h_win as handle no-undo.
def var c-win as char   no-undo.

def temp-table tt-old-item-uni-estab no-undo like item-uni-estab.

define variable c-resultado as character no-undo.

DEFINE VARIABLE l-mudancas-sfc AS LOGICAL    NO-UNDO.

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /* Integraá∆o EMS EAI2.0 Mensagem unica */
    DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.    
    DEFINE VARIABLE h-cdapi998 AS HANDLE NO-UNDO. 
    DEFINE VARIABLE hShowMsg   AS HANDLE NO-UNDO.
&ENDIF    


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-uni-estab.lote-multipl ~
item-uni-estab.lote-minimo item-uni-estab.fator-refugo ~
item-uni-estab.quant-perda item-uni-estab.tipo-est-seg ~
item-uni-estab.lote-economi item-uni-estab.periodo-fixo ~
item-uni-estab.quant-segur item-uni-estab.tempo-segur 
&Scoped-define ENABLED-TABLES item-uni-estab
&Scoped-define FIRST-ENABLED-TABLE item-uni-estab
&Scoped-Define ENABLED-OBJECTS rt-mold rt-key RECT-33 rt-temp-qt-seg 
&Scoped-Define DISPLAYED-FIELDS item-uni-estab.lote-multipl ~
item-uni-estab.lote-minimo item-uni-estab.fator-refugo ~
item-uni-estab.quant-perda item-uni-estab.tipo-est-seg ~
item-uni-estab.lote-economi item-uni-estab.periodo-fixo ~
item-uni-estab.quant-segur item-uni-estab.tempo-segur 
&Scoped-define DISPLAYED-TABLES item-uni-estab
&Scoped-define FIRST-DISPLAYED-TABLE item-uni-estab
&Scoped-Define DISPLAYED-OBJECTS cb-politica cb-demanda tb-conv-tempo-seg ~
c-pto-repos cb-reab-estoq c-liter-estoq 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-politica cb-demanda ~
item-uni-estab.lote-multipl item-uni-estab.lote-minimo ~
item-uni-estab.fator-refugo item-uni-estab.quant-perda ~
item-uni-estab.tipo-est-seg tb-conv-tempo-seg item-uni-estab.lote-economi ~
item-uni-estab.periodo-fixo c-pto-repos item-uni-estab.quant-segur ~
item-uni-estab.tempo-segur cb-reab-estoq 
&Scoped-define ADM-MODIFY-FIELDS cb-politica cb-demanda ~
item-uni-estab.lote-multipl item-uni-estab.lote-minimo ~
item-uni-estab.fator-refugo item-uni-estab.quant-perda ~
item-uni-estab.tipo-est-seg tb-conv-tempo-seg item-uni-estab.lote-economi ~
item-uni-estab.periodo-fixo c-pto-repos item-uni-estab.quant-segur ~
item-uni-estab.tempo-segur cb-reab-estoq 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
(input c-campo as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-demanda AS CHARACTER FORMAT "X(15)" INITIAL "1" 
     LABEL "Demanda":R18 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-politica AS CHARACTER FORMAT "X(20)":U 
     LABEL "Pol°tica" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reab-estoq AS CHARACTER FORMAT "X(10)":U 
     LABEL "Reabastecimento" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-liter-estoq AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 19.86 BY .67 NO-UNDO.

DEFINE VARIABLE c-pto-repos AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Ponto Reposiá∆o" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-tipo-est-seg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 2.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 8.42.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 3.25.

DEFINE RECTANGLE rt-temp-qt-seg
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 2.46.

DEFINE VARIABLE tb-conv-tempo-seg AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .79 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-politica AT ROW 1.5 COL 19 COLON-ALIGNED
     cb-demanda AT ROW 2.58 COL 19 COLON-ALIGNED HELP
          "Tipo de Demanda do Item"
     item-uni-estab.lote-multipl AT ROW 3.67 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-uni-estab.lote-minimo AT ROW 4.67 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-uni-estab.fator-refugo AT ROW 5.67 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     item-uni-estab.quant-perda AT ROW 6.67 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-uni-estab.tipo-est-seg AT ROW 5.08 COL 46.14 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Quantidade", 1,
"Tempo", 2
          SIZE 14.72 BY 1.54
     tb-conv-tempo-seg AT ROW 7.54 COL 46
     item-uni-estab.lote-economi AT ROW 1.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-uni-estab.periodo-fixo AT ROW 2.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-pto-repos AT ROW 3.17 COL 61 COLON-ALIGNED
     item-uni-estab.quant-segur AT ROW 4.71 COL 65.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-uni-estab.tempo-segur AT ROW 5.71 COL 65.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cb-reab-estoq AT ROW 8.17 COL 66 COLON-ALIGNED
     c-tipo-est-seg AT ROW 4.29 COL 43 COLON-ALIGNED NO-LABEL
     c-liter-estoq AT ROW 6.92 COL 45 NO-LABEL
     rt-mold AT ROW 1 COL 44
     rt-key AT ROW 1 COL 1
     RECT-33 AT ROW 7.17 COL 44
     rt-temp-qt-seg AT ROW 4.42 COL 44
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-uni-estab
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
         HEIGHT             = 8.5
         WIDTH              = 84.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R,COLUMNS                    */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 8.5
       FRAME f-main:WIDTH            = 84.

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
/* SETTINGS FOR FILL-IN item-uni-estab.fator-refugo IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.lote-economi IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.lote-minimo IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.lote-multipl IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.periodo-fixo IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.quant-perda IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.quant-segur IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX tb-conv-tempo-seg IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item-uni-estab.tempo-segur IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET item-uni-estab.tipo-est-seg IN FRAME f-main
   2 3                                                                  */
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
    if  input frame {&frame-name} item-uni-estab.tipo-est-seg = 1 then do with frame {&frame-name}:
        assign item-uni-estab.quant-segur:sensitive = yes
               item-uni-estab.tempo-segur:sensitive = no.
    end.
    else do with frame {&frame-name}:
        assign item-uni-estab.tempo-segur:sensitive = yes
               item-uni-estab.quant-segur:sensitive = no.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-politica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-politica V-table-Win
ON VALUE-CHANGED OF cb-politica IN FRAME f-main /* Pol°tica */
DO:
    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 then 
        assign item-uni-estab.periodo-fixo:sensitive in frame {&frame-name} = yes.
    else
        assign item-uni-estab.periodo-fixo:sensitive in frame {&frame-name} = no.

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2 
        &IF DEFINED (bf_man_ponto_repos) &THEN  
            OR {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 7
        &endif
        then
        assign item-uni-estab.lote-economi:sensitive in frame {&frame-name} = yes.
    else
        assign item-uni-estab.lote-economi:sensitive in frame {&frame-name} = no.

    &IF DEFINED (bf_man_ponto_repos) &THEN   
    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 7 then  
        assign c-pto-repos:sensitive in frame {&frame-name} = yes.
    else
        assign c-pto-repos:sensitive in frame {&frame-name} = no.
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-uni-estab.lote-multipl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.lote-multipl V-table-Win
ON LEAVE OF item-uni-estab.lote-multipl IN FRAME f-main /* Lote M£ltiplo */
DO:
    FOR FIRST ITEM FIELDS (fraciona) WHERE ITEM.it-codigo = item-uni-estab.it-codigo NO-LOCK:
        if  input frame {&frame-name} item-uni-estab.lote-multipl <> truncate(input frame {&frame-name} item-uni-estab.lote-multipl,0)
            and not item.fraciona then do:
            run utp/ut-msgs.p (input "show",
                               input 907, 
                               input "").
            apply 'entry' to item-uni-estab.lote-multipl in frame {&frame-name}.
            return 'adm-error'.
        end.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-uni-estab.tipo-est-seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.tipo-est-seg V-table-Win
ON VALUE-CHANGED OF item-uni-estab.tipo-est-seg IN FRAME f-main /* Est Seg */
DO:
    if  input frame {&frame-name} item-uni-estab.tipo-est-seg = 1 then do with frame {&frame-name}:
        enable item-uni-estab.quant-segur.
        disable item-uni-estab.tempo-segur.
    end.
    else do with frame {&frame-name}:
        enable item-uni-estab.tempo-segur.
        disable item-uni-estab.quant-segur.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-field.i mgind item-uni-estab politica 1} 
assign cb-politica:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind item-uni-estab demanda 1}  
assign cb-demanda:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind item-uni-estab conv-tempo-seg 01} 
assign tb-conv-tempo-seg:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Reabastecimento MPL r} 
assign cb-reab-estoq:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Estoque_de_Seguranáa * r} 
assign c-liter-estoq = trim(return-value).

{utp/ut-rtlbl.i mgind item tipo-est-seg c-tipo-est-seg}

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
  {src/adm/template/row-list.i "item-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-uni-estab"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var c-aux-1 as char no-undo.
DEFINE VARIABLE de-aux AS DECIMAL    NO-UNDO.
    /* Code placed here will execute PRIOR to standard behavior. */

    if avail item-uni-estab then do:
       for each tt-old-item-uni-estab no-lock:
           delete tt-old-item-uni-estab.
       end.
       create tt-old-item-uni-estab.
       buffer-copy item-uni-estab to tt-old-item-uni-estab.
    end.            

    for each tt-item-2:
        delete tt-item-2.
    end.
    create tt-item-2.
    buffer-copy item-uni-estab to tt-item-2.

     do with frame {&frame-name}:
        assign cb-politica               
               cb-demanda
               cb-reab-estoq.
     end.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i} 

    assign tt-item-2.politica      = {ininc/i04in122.i 06 cb-politica}
           tt-item-2.demanda       = {ininc/i02in122.i 06 cb-demanda}
           substr(tt-item-2.char-1,10,1) = string({ininc/i26in172.i 06 cb-reab-estoq})
           tt-item-2.periodo-fixo  = int(item-uni-estab.periodo-fixo:screen-value in frame {&frame-name})
           c-aux-1                 = f-retorna-campo ("cb-tipo-requis":U)
           tt-item-2.tipo-requis   = {ininc/i08in122.i 06 c-aux-1}
           c-aux-1                 = f-retorna-campo ("cb-ind-calc-meta":U)
           tt-item-2.ind-calc-meta = {ininc/i19in122.i 06 c-aux-1}
           c-aux-1                 = f-retorna-campo ("cb-classe-repro":U)
           tt-item-2.classe-repro  = {ininc/i06in122.i 06 c-aux-1}
           c-aux-1                 = f-retorna-campo ("cb-div-ordem":U) 
           tt-item-2.div-ordem     = {ininc/i12in122.i 06 c-aux-1}
           c-aux-1                 = f-retorna-campo ("cb-emissao-ord":U)
           tt-item-2.emissao-ord   = {ininc/i03in122.i 06 c-aux-1}
           c-aux-1                 = f-retorna-campo ("cb-tipo-sched":U)
           tt-item-2.tipo-sched    = {ininc/i16in122.i 06 c-aux-1}
           tt-item-2.lote-economi  = input frame {&frame-name} item-uni-estab.lote-economi
           OVERLAY(tt-item-2.char-1,129,3) = IF string(f-retorna-campo ("i-horiz-lib":U),"999") = "?" THEN "" ELSE string(f-retorna-campo ("i-horiz-lib":U),"999")
           OVERLAY(tt-item-2.char-1,132,1) = if f-retorna-campo ("l-demanda-item":U) = "yes":U then "1" else "2".

    IF l-mudancas-sfc THEN DO:
        ASSIGN de-aux =  DEC(f-retorna-campo("fi-perc-overlap":U)).
        IF de-aux = ? THEN
            ASSIGN de-aux = 0.

        &IF DEFINED(bf_man_207) &THEN
            ASSIGN tt-item-2.log-consid-aloc-ativid = IF f-retorna-campo("tg-consid-aloc-ativid":U) = "yes":U THEN YES ELSE NO
                   tt-item-2.log-programac-sfc      = IF f-retorna-campo("tg-log-programac-sfc":U)  = "yes":U THEN YES ELSE NO
                   tt-item-2.val-overlap            = de-aux.
        &ELSE
            ASSIGN OVERLAY(tt-item-2.char-1,134,1) = IF f-retorna-campo("tg-consid-aloc-ativid":U) = "yes":U THEN "S":U ELSE "N":U
                   OVERLAY(tt-item-2.char-1,140,1) = IF f-retorna-campo("tg-log-programac-sfc":U) = "yes":U  THEN "S":U ELSE "N":U
                   OVERLAY(tt-item-2.char-1,135,5) = STRING(de-aux * 100,"99999":U).
        &ENDIF
    END.

    run pi-validate-item.

    if return-value <> 'ok' and return-value <> '' then do:
        run pi-apresenta-erros.
        return "ADM-ERROR":U.
    end.
    
    run pi-atualiza-planejamento.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    buffer-copy tt-item-2 using politica      demanda 
                                tipo-requis  ind-calc-meta
                                classe-repro div-ordem   char-1
                                emissao-ord  contr-plan  tipo-sched
                                &IF DEFINED(bf_man_207) &THEN
                                log-consid-aloc-ativid log-programac-sfc val-overlap
                                &ENDIF
                to item-uni-estab.            

    /*atualizaá∆o da pl-it-calc.replaneja*/

    if param-global.modulo-pl or param-global.modulo-pi then
       run cdp/cd7000.p(input 0,
                        item-uni-estab.it-codigo,
                        item-uni-estab.cod-estabel).

    if param-global.modulo-pl then do:
       find first pend-item where 
                  pend-item.it-codigo = item-uni-estab.it-codigo and 
                  pend-item.modulo    = "MPL":U EXCLUSIVE-LOCK no-error. 
       if avail pend-item then
          delete pend-item.
    end.      

    /*** Pasar para viewer MPS ***/
    if param-global.modulo-pm then do:
       find first pend-item where 
                  pend-item.it-codigo = item-uni-estab.it-codigo and
                  pend-item.modulo    = "MPM":U EXCLUSIVE-LOCK no-error. 
       if avail pend-item then
          delete pend-item.
    end.   

    /*** Pasar para viewer MRPII ***/
    if param-global.modulo-pc  then do:
       find first pend-item where 
                  pend-item.it-codigo = item-uni-estab.it-codigo and
                  pend-item.modulo    = "MPC":U EXCLUSIVE-LOCK no-error. 
       if avail pend-item then
          delete pend-item.
    end.   

    assign item-uni-estab.conv-tempo-seg = input frame {&frame-name} tb-conv-tempo-seg.

    &IF DEFINED (bf_man_ponto_repos) &THEN   
    assign item-uni-estab.pto-repos = input frame {&frame-name} c-pto-repos.
    &ENDIF

    run cdp/cd1112a.p (input table tt-old-item-uni-estab).
    
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        /** Integraá∆o EAI2 **/
        
        IF  v_log_eai2_ativado THEN DO:  
           IF NOT VALID-HANDLE(h-cdapi998) OR
              h-cdapi998:TYPE <> "PROCEDURE":U OR
              h-cdapi998:FILE-NAME <> "cdp/cdapi998.p":U THEN DO:
              RUN cdp/cdapi998.p PERSISTENT SET h-cdapi998. 
           END.
               
           RUN pi-sendUpsert IN h-cdapi998 (INPUT ROWID(item-uni-estab), INPUT "Async":U, OUTPUT TABLE RowErrors).                
           
           IF VALID-HANDLE(h-cdapi998) AND
              h-cdapi998:TYPE = "PROCEDURE":U AND
              h-cdapi998:FILE-NAME = "cdp/cdapi998.p":U THEN DO:
              DELETE PROCEDURE h-cdapi998 NO-ERROR.
              ASSIGN h-cdapi998 = ?.
           END.
              
           IF CAN-FIND(FIRST RowErrors) THEN DO:
              {method/showmessage.i1}
              {method/showmessage.i2}
              {method/showmessage.i3}
              RETURN "ADM-ERROR".
           END.                     
        END.           
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

    &IF DEFINED (bf_man_203) &THEN   
       if h_win <> ? then
          run pi-ativa-desativa-exporta in h_win(input yes).
    &ENDIF

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
    if not(h_win = ?) then
       run pi-ativa-desativa-exporta in h_win(input yes).

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    do with frame {&frame-name}:
       if  avail item-uni-estab then do:
           assign cb-politica                = {ininc/i04in122.i 04 item-uni-estab.politica}
                  cb-demanda                 = {ininc/i02in122.i 04 item-uni-estab.demanda}
                  cb-reab-estoq              = if substr(item-uni-estab.char-1,10,1) = "" 
                                               then {ininc/i26in172.i 04 1} 
                                               else {ininc/i26in172.i 04 int(substr(item-uni-estab.char-1,10,1))}

                  cb-politica:screen-value   = cb-politica
                  cb-demanda:screen-value    = cb-demanda
                  tb-conv-tempo-seg          = item-uni-estab.conv-tempo-seg
                  cb-reab-estoq:screen-value = cb-reab-estoq.

           &IF DEFINED (bf_man_ponto_repos) &THEN   
           assign c-pto-repos = item-uni-estab.pto-repos.                     
           &ENDIF
       end.
       else
           assign cb-politica                = {ininc/i04in122.i 04 1}
                  cb-demanda                 = {ininc/i02in122.i 04 1}
                  cb-reab-estoq:screen-value = {ininc/i26in172.i 04 1}.

       display tb-conv-tempo-seg cb-politica cb-demanda cb-reab-estoq.

       &IF DEFINED (bf_man_ponto_repos) &THEN   
       disp c-pto-repos.
       &ENDIF

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
    &if  defined(ADM-MODIFY-FIELDS) &then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if  input frame {&frame-name} item-uni-estab.tipo-est-seg = 1 then do with frame {&frame-name}:
        enable  item-uni-estab.quant-segur.
        disable item-uni-estab.tempo-segur. 
    end.
    else do with frame {&frame-name}:
        enable  item-uni-estab.tempo-segur.
        disable item-uni-estab.quant-segur.
    end.

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 then 
        enable  item-uni-estab.periodo-fixo with frame {&frame-name}.
    else 
        disable item-uni-estab.periodo-fixo with frame {&frame-name}.

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2 then 
        enable item-uni-estab.lote-ec  with frame {&frame-name}.
    else 
        disable item-uni-estab.lote-ec with frame {&frame-name}.

    &IF DEFINED (bf_man_ponto_repos) &THEN   
    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 7 then 
        enable  c-pto-repos with frame {&frame-name}.
    else 
        disable c-pto-repos with frame {&frame-name}.
    &ENDIF


   &IF DEFINED (bf_man_ponto_repos) &THEN   
       assign c-pto-repos:hidden in frame {&frame-name} = no.
  &ELSE
       assign c-pto-repos:hidden in frame {&frame-name} = yes.
  &ENDIF



    if h_win <> ? then
       run pi-ativa-desativa-exporta in h_win(input no).

    enable cb-reab-estoq with frame {&frame-name}.

    apply 'value-changed' to cb-politica in frame {&frame-name}.

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
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
  DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
  ASSIGN cAuxTraducao001 = {ininc/i04in122.i 03}.
  RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
  ASSIGN cb-politica:LIST-ITEM-PAIRS     = cAuxTraducao001.
&else
  ASSIGN cb-politica:list-items     = {ininc/i04in122.i 03}.
&endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao002 = {ininc/i02in122.i 03}.
         RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
         ASSIGN cb-demanda:LIST-ITEM-PAIRS      = cAuxTraducao002.
     &else
         ASSIGN cb-demanda:list-items      = {ininc/i02in122.i 03}.
     &endif
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
         ASSIGN cAuxTraducao003 = {ininc/i26in172.i 03}.
         RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao003).
         ASSIGN cb-reab-estoq:LIST-ITEM-PAIRS   = cAuxTraducao003.
     &else
         ASSIGN cb-reab-estoq:list-items   = {ininc/i26in172.i 03}.
     &endif
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
      /* Carrega a vari†vel global v_log_eai2_ativado */
      RUN cdp/cd0101i.p. 
  &ENDIF  

  &IF DEFINED (bf_man_ponto_repos) &THEN   
  assign c-pto-repos:hidden in frame {&frame-name} = no.
  &ELSE
  assign c-pto-repos:hidden in frame {&frame-name} = yes.
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global no-lock no-error.

  RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apresenta-erros V-table-Win 
PROCEDURE pi-apresenta-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 {database/tgin/twp/twin172.i 'show':U}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT "cb-ind-lista-mrp").

    assign i-lista-mrp = {ininc/i03in180.i 06 return-value}.     

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-planejamento V-table-Win 
PROCEDURE pi-atualiza-planejamento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var c-classe-repro as char no-undo.
def var c-contr-plan   as char no-undo.
def var c-res-int-comp as char no-undo.
def var c-res-for-comp as char no-undo.
def var c-res-cq-comp  as char no-undo.
def var c-ressup-fabri as char no-undo.
def var c-res-cq-fabri as char no-undo.
def var c-int-1        as char no-undo.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cb-classe-repro").
    assign c-classe-repro = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cb-contr-plan").
    assign c-contr-plan = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "res-int-comp").
    assign c-res-int-comp = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "res-for-comp").
    assign c-res-for-comp = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "res-cq-comp").
    assign c-res-cq-comp = return-value.    

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "ressup-fabri").
    assign c-ressup-fabri = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "res-cq-fabri").
    assign c-res-cq-fabri = return-value.

RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "int-1").
    assign c-int-1 = return-value.

if not(item-uni-estab.politica     = {ininc/i04in122.i 06 cb-politica})                                    or
   not(item-uni-estab.demanda      = {ininc/i02in122.i 06 cb-demanda})                                     or
   not(item-uni-estab.lote-multipl = dec(item-uni-estab.lote-multipl:screen-value in frame {&frame-name})) or
   not(item-uni-estab.lote-minimo  = dec(item-uni-estab.lote-minimo:screen-value  in frame {&frame-name})) or
   not(item-uni-estab.fator-refugo = dec(item-uni-estab.fator-refugo:screen-value in frame {&frame-name})) or
   not(item-uni-estab.quant-perda  = dec(item-uni-estab.quant-perda:screen-value  in frame {&frame-name})) or
   not(item-uni-estab.lote-economi = dec(item-uni-estab.lote-economi:screen-value in frame {&frame-name})) or
   not(item-uni-estab.periodo-fixo = int(item-uni-estab.periodo-fixo:screen-value in frame {&frame-name})) or
   not(item-uni-estab.tipo-est-seg = int(item-uni-estab.tipo-est-seg:screen-value in frame {&frame-name})) or
   not(item-uni-estab.quant-segur  = dec(item-uni-estab.quant-segur:screen-value  in frame {&frame-name})) or
   not(item-uni-estab.tempo-segur  = int(item-uni-estab.tempo-segur:screen-value  in frame {&frame-name})) or
   not(item-uni-estab.classe-repro = {ininc/i06in122.i 06 c-classe-repro})                                 or
   not(item-uni-estab.contr-plan   = {ininc/i15in172.i 06 c-contr-plan})                                   or
   not(item-uni-estab.res-int-comp = int(c-res-int-comp))                                                  or
   not(item-uni-estab.res-for-comp = int(c-res-for-comp))                                                  or
   not(item-uni-estab.res-cq-comp  = int(c-res-cq-comp) )                                                  or
   not(item-uni-estab.ressup-fabri = int(c-ressup-fabri))                                                  or
   not(item-uni-estab.res-cq-fabri = int(c-res-cq-fabri))                                                  or
   not(item-uni-estab.int-1        = int(c-int-1))                                                         or   
   not(int(substr(item-uni-estab.char-1,10,1)) = {ininc/i26in172.i 06 cb-reab-estoq}) then
   run cdp/cd7000.p(input 0,
                    input item-uni-estab.it-codigo,
                    input item-uni-estab.cod-estabel).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-handle V-table-Win 
PROCEDURE pi-carrega-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p_handle as handle no-undo.

assign h_02 = p_handle.

RUN Who-Is-The-Container IN adm-broker-hdl(INPUT  h_02,
                                           OUTPUT c-win).
assign h_win = widget-handle(c-win).


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

  IF NOT AVAIL ITEM 
     OR (AVAIL ITEM AND item.it-codigo <> item-uni-estab.it-codigo) THEN
     FOR FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = item-uni-estab.it-codigo. END. 

  if {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2 and 
     input frame {&frame-name} item-uni-estab.lote-economi = 0 then do:
     {utp/ut-field.i mgind item lote-economi 1}
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show",
                        input 4570,
                        input return-value).
     apply 'entry' to item-uni-estab.lote-economi in frame {&frame-name}.
     return 'adm-error':U. 
  end.


  if  input frame {&frame-name} item-uni-estab.lote-multipl <> 
      truncate(input frame {&frame-name} item-uni-estab.lote-multipl,0) and 
      not item.fraciona  then do:
     {include/i-vldprg.i} 
     run utp/ut-msgs.p (input "show",
                         input 907, 
                         input "").
      apply 'entry' to item-uni-estab.lote-multipl in frame {&frame-name}.
      return 'adm-error'.
  end.

  if {ininc/i26in172.i 06 cb-reab-estoq:screen-value in frame {&frame-name}} = 2 then do:
     assign i-politica = {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}}.
     if i-politica = 3 or i-politica = 4 then do:
         {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */  
         run utp/ut-msgs.p ("Show", 16490, "").
         apply "entry" to cb-reab-estoq.
         return "adm-error".
     end.
  end. 

  &IF DEFINED (bf_man_ponto_repos) &THEN

  assign i-politica = {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}}.
  if  i-politica = 7 then do :   

     if  input frame {&frame-name} item-uni-estab.quant-segur >=
          input frame {&frame-name} c-pto-repos then do:
          {utp/ut-field.i mgind item-uni-estab quant-segur 1}
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show",
                             input 26786,
                             input return-value).
          apply 'entry' to item-uni-estab.quant-segur in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "item-uni-estab"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
(input c-campo as char) :

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                INPUT c-campo).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

