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
{include/i-prgvrs.i V05IN172 2.00.00.060 } /*** 010060 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v05in172 MUT}
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
def temp-table tt-item-2 like item use-index codigo.
def var i-politica  as integer no-undo.
def var i-lista-mrp as integer init 1 no-undo.

{cdp/cdcfgman.i}

{database/tgin/twp/twin172.i1 item tt-item-2 "not avail"}

/**************************MULTIPLANTA*********************************/
{utp/ut-glob.i}
{cdp/cd7300.i1}
{cdp/cdapi244.i}
{mcinc/mcapi003.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.
/************************FIM MULTIPLANTA*******************************/

&IF DEFINED (bf_man_203) &THEN   
    def temp-table tt-estabel no-undo
        field cod-estabel as char
        field log-exporta as log format "*/ "
        index codigo is primary unique cod-estabel
        index exporta log-exporta.  

    def temp-table tt-old-item no-undo like item
        use-index codigo.    

    def var l-cancelar as logical no-undo. 
    def var l-modific  as logical no-undo.   
    def var l-anterior as logical no-undo.

&ENDIF

define variable c-resultado as char no-undo.

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.tipo-est-seg 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-26 RECT-27 RECT-33 rt-temp-qt-seg 
&Scoped-Define DISPLAYED-FIELDS item.lote-multipl item.lote-minimo ~
item.fator-refugo item.quant-perda item.lote-economi item.periodo-fixo ~
item.tipo-est-seg item.quant-segur item.tempo-segur 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-pto-repos cb-politica cb-demanda ~
tb-conv-tempo-seg cb-reab-estoq c-liter-estoq 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-pto-repos cb-politica cb-demanda ~
item.lote-multipl item.lote-minimo item.fator-refugo item.quant-perda ~
item.lote-economi item.periodo-fixo item.quant-segur item.tempo-segur ~
tb-conv-tempo-seg cb-reab-estoq 
&Scoped-define ADM-MODIFY-FIELDS c-pto-repos cb-politica cb-demanda ~
item.lote-multipl item.lote-minimo item.fator-refugo item.quant-perda ~
item.lote-economi item.periodo-fixo item.tipo-est-seg item.quant-segur ~
item.tempo-segur tb-conv-tempo-seg cb-reab-estoq 

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
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-demanda AS CHARACTER FORMAT "X(15)" INITIAL "1" 
     LABEL "":R18 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-politica AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE cb-reab-estoq AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-liter-estoq AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE c-pto-repos AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "Ponto Reposi‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE VARIABLE c-tipo-est-seg AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-26
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43 BY 8.88.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 3.29.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 2.33.

DEFINE RECTANGLE rt-temp-qt-seg
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41 BY 2.46.

DEFINE VARIABLE tb-conv-tempo-seg AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .79 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-pto-repos AT ROW 3.21 COL 62 COLON-ALIGNED
     cb-politica AT ROW 1.5 COL 19 COLON-ALIGNED
     cb-demanda AT ROW 2.67 COL 19 COLON-ALIGNED HELP
          "Tipo de Demanda do Item"
     item.lote-multipl AT ROW 3.83 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.lote-minimo AT ROW 4.83 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.fator-refugo AT ROW 5.83 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     item.quant-perda AT ROW 6.83 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.lote-economi AT ROW 1.21 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.periodo-fixo AT ROW 2.21 COL 62 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     item.tipo-est-seg AT ROW 5.08 COL 47 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Quantidade", 1,
"Tempo", 2
          SIZE 14.14 BY 1.75
     item.quant-segur AT ROW 4.96 COL 63 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     item.tempo-segur AT ROW 5.96 COL 63 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     tb-conv-tempo-seg AT ROW 7.92 COL 46
     cb-reab-estoq AT ROW 8.67 COL 66 COLON-ALIGNED
     c-tipo-est-seg AT ROW 4.46 COL 44 COLON-ALIGNED NO-LABEL
     c-liter-estoq AT ROW 7.29 COL 47 NO-LABEL
     RECT-26 AT ROW 1 COL 1
     RECT-27 AT ROW 1 COL 44
     RECT-33 AT ROW 7.54 COL 44
     rt-temp-qt-seg AT ROW 4.67 COL 44
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 8.88
         WIDTH              = 84.72.
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

/* SETTINGS FOR FILL-IN c-liter-estoq IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-pto-repos IN FRAME f-main
   NO-ENABLE 2 3                                                        */
ASSIGN 
       c-pto-repos:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-tipo-est-seg IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX cb-demanda IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-politica IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-reab-estoq IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.fator-refugo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.lote-economi IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.lote-minimo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.lote-multipl IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.periodo-fixo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.quant-perda IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.quant-segur IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX tb-conv-tempo-seg IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.tempo-segur IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-tipo-est-seg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tipo-est-seg V-table-Win
ON LEAVE OF c-tipo-est-seg IN FRAME f-main
DO:
    if  input frame {&frame-name} item.tipo-est-seg = 1
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


&Scoped-define SELF-NAME cb-politica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-politica V-table-Win
ON VALUE-CHANGED OF cb-politica IN FRAME f-main
DO:
    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 then do  with frame {&frame-name}:
        enable  item.periodo-fixo.
    end.
    else do  with frame {&frame-name}:
        disable item.periodo-fixo.
    end.        

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2 then do:
        enable item.lote-economi 
               with frame {&frame-name}.
    end.
    else do with frame {&frame-name}:
        disable item.lote-economi.
    end.

    &IF DEFINED (bf_man_ponto_repos) &THEN  
        if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 7 then 
            enable  c-pto-repos 
            item.lote-economi with frame {&frame-name} .
        else  
        disable c-pto-repos  with frame {&frame-name}.

     if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 7 then  
        assign c-pto-repos:sensitive in frame {&frame-name} = yes
               item.lote-economi:sensitive in frame {&frame-name} = yes.
    else
        assign c-pto-repos:sensitive in frame {&frame-name} = no.
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.lote-multipl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.lote-multipl V-table-Win
ON LEAVE OF item.lote-multipl IN FRAME f-main /* Lote Mœltiplo */
DO:

    if  input frame {&frame-name} item.lote-multipl <>  
        truncate(input frame {&frame-name} item.lote-multipl,0) and
        item.fraciona = no
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

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-field.i mgind item politica 1}
  assign cb-politica:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item demanda 1}
  assign cb-demanda:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgind item conv-tempo-seg 01}
  assign tb-conv-tempo-seg:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Reabastecimento MPL r}
  assign cb-reab-estoq:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Estoque_de_Seguran‡a * r}
  assign c-liter-estoq = trim(return-value).



 {utp/ut-rtlbl.i mgind item tipo-est-seg c-tipo-est-seg}

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
  {utp/ut-rtlbl.i mgind item tipo-est-seg c-tipo-est-seg}
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    &IF DEFINED (bf_man_203) &THEN
        for each tt-old-item:
            delete tt-old-item.
        end.

        create tt-old-item.
        buffer-copy item to tt-old-item.
    &ENDIF

    def var c-aux as char no-undo.
    for each tt-item-2:
        delete tt-item-2.
    end.
    create tt-item-2.
    buffer-copy item to tt-item-2.

     do with frame {&frame-name}:
        assign cb-politica               
               cb-demanda
               cb-reab-estoq.               
     end.
      /* Code placed here will execute PRIOR to standard behavior. */
     {include/i-valid.i}

         &if defined (bf_man_sfc_lc) &then
         FIND FIRST item-man WHERE item-man.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL item-man THEN
                ASSIGN c-aux                  = f-retorna-campo ("cb-ind-lista-mrp")
                       item-man.ind-lista-mrp = {ininc/i03in180.i 06 c-aux}
         &else
         ASSIGN
         &endif

                   tt-item-2.politica     = {ininc/i04in122.i 06 cb-politica}
                   tt-item-2.demanda      = {ininc/i02in122.i 06 cb-demanda}
                   tt-item-2.periodo-fixo = int(item.periodo-fixo:screen-value in frame {&frame-name})
                   tt-item-2.lote-economi = dec(input frame {&frame-name} item.lote-economi)
                   c-aux = f-retorna-campo ("cb-cd-origem")     
                   tt-item-2.cd-origem    = {ininc/i14in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-cod-obsoleto")     
                   tt-item-2.cod-obsoleto = {ininc/i17in172.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-tipo-con-est")
                   tt-item-2.tipo-con-est = {ininc/i01in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-tipo-requis")
                   tt-item-2.tipo-requis  = {ininc/i08in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-ind-calc-meta")
                   tt-item-2.ind-calc-meta = {ininc/i19in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-classe-repro")
                   tt-item-2.classe-repro  = {ininc/i06in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-div-ordem") 
                   tt-item-2.div-ordem     = {ininc/i12in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-cd-formula")
                   tt-item-2.cd-formula    = {ininc/i24in172.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-emissao-ord")
                   tt-item-2.emissao-ord   = {ininc/i03in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-contr-plan")
                   tt-item-2.contr-plan    = {ininc/i15in172.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-tipo-contr")
                   tt-item-2.tipo-contr   = {ininc/i09in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("cb-tipo-sched")
                   tt-item-2.tipo-sched   = {ininc/i16in122.i 06 c-aux}
                   c-aux = f-retorna-campo ("ressup-fabri")     
                   tt-item-2.ressup-fabri = integer(c-aux).

           run pi-validate-item. 

           if return-value <> 'ok' and return-value <> '' then do:
               run pi-apresenta-erros.
               return "ADM-ERROR":U.
           end.




         /* Dispatch standard ADM method.                             */
         RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .       
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

        /* Code placed here will execute AFTER standard behavior.    */
        BUFFER-COMPARE item TO tt-item-2 save RESULT IN c-resultado.

        buffer-copy tt-item-2 using politica
                                    cd-origem        demanda 
                                    cod-obsoleto     tipo-con-est
                                    tipo-requis      ind-calc-meta
                                    classe-repro     div-ordem
                                    cd-formula       emissao-ord
                                    contr-plan       tipo-contr
                                    tipo-sched
                    to item.            
            if not(c-resultado = '') then
               if param-global.modulo-pl or param-global.modulo-pi then
                  run cdp/cd7000.p( input 0,
                                    input item.it-codigo,
                                    input '').


            if param-global.modulo-pl = yes then do:
               find first pend-item where 
                          pend-item.it-codigo = item.it-codigo and 
                          pend-item.modulo    = "MPL":U exclusive-lock no-error. 
               if avail pend-item then
                  delete pend-item.
            end.      

            /*** Pasar para viewer MPS ***/
            if param-global.modulo-pm = yes then do:
               find first pend-item where 
                          pend-item.it-codigo = item.it-codigo and
                          pend-item.modulo    = "MPM":U exclusive-lock no-error. 
                if avail pend-item then
                  delete pend-item.
            end.   

            /*** Pasar para viewer MRPII ***/
            if param-global.modulo-pc = yes then do:
               find first pend-item where 
                          pend-item.it-codigo = item.it-codigo and
                          pend-item.modulo    = "MPC":U exclusive-lock no-error. 
                if avail pend-item then
                  delete pend-item.
            end.   

    assign item.conv-tempo-seg      = input frame {&frame-name} tb-conv-tempo-seg
           input frame {&frame-name} cb-reab-estoq
           substr(item.char-1,10,1) = string({ininc/i26in172.i 06 cb-reab-estoq}).      

    &IF DEFINED (bf_man_ponto_repos) &THEN   
    assign item.pto-repos = input frame {&frame-name} c-pto-repos.
    &ENDIF

    /** Atualiza»’o da tabela Item-man - Release 2.02 **/
    /*{cdp/cd1107.i1} - Atualiza‡Æo adicionada na trigger*/

    &IF DEFINED (bf_man_sfc_lc) &THEN
        release item-man.
    &ENDIF        


    /*----------------------MULTIPLANTA------------------------*/

    if param-global.modulo-mp = yes then do:
       assign c-transacao = "MAN003".

       {cdp/cd7300.i5 "001" c-transacao}

       if tt-replica-msg.log-replica-msg = yes then do:
          create tt-item-aux.
          buffer-copy item to tt-item-aux.
          create tt-dados-env.
          assign tt-dados-env.num-sequencia  = i-seq
                 tt-dados-env.cod-tipo-reg   = 3  /*tabela Item*/
                 tt-dados-env.ind-tipo-movto = 2 /*modifica*/
                 tt-dados-env.identif-msg    = item.it-codigo.
          raw-transfer tt-item-aux to tt-dados-env.conteudo-msg.
          assign i-seq = i-seq + 1.
       end.
       {cdp/cd7300.i6 "001" c-transacao}
    end.     

    /*-------------------FIM MULTIPLANTA-------------------------*/

    /*----------------------MULTIPLANTA-SMC------------------------*/

    if param-global.modulo-mp = yes then do:

       for each tt-smc-item:
          delete tt-smc-item.
       end.

       assign c-transacao = "SMC015".
       {cdp/cd7300.i5 "001" c-transacao "-SMC"}

       if tt-replica-msg-SMC.log-replica-msg = yes then do:
          create tt-smc-item.
          buffer-copy item to tt-smc-item.
          create tt-dados-env-SMC.
          assign tt-dados-env-SMC.num-sequencia  = i-seq
                 tt-dados-env-SMC.cod-tipo-reg   = 3  /*tabela Item*/
                 tt-dados-env-SMC.ind-tipo-movto = 2 /*modifica*/
                 tt-dados-env-SMC.identif-msg    = item.it-codigo.
          raw-transfer tt-smc-item to tt-dados-env-SMC.conteudo-msg.
          assign i-seq = i-seq + 1.
       end.
       {cdp/cd7300.i6 "001" c-transacao "-SMC"}
    end.     

    /*-------------------FIM MULTIPLANTA-SMC-------------------------*/


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
  if avail item then do with frame {&frame-name}: 
     assign cb-politica     = {ininc/i04in122.i 04 item.politica}
            cb-demanda      = {ininc/i02in122.i 04 item.demanda}
            cb-reab-estoq   = if substr(item.char-1,10,1) = "" then 
                                       {ininc/i26in172.i 04 1} 
                              else {ininc/i26in172.i 04 int(substr(item.char-1,10,1))}
            cb-politica:screen-value   = cb-politica.
    assign  cb-demanda:screen-value    = cb-demanda
            cb-reab-estoq:screen-value = cb-reab-estoq
            tb-conv-tempo-seg          = item.conv-tempo-seg.



    &IF DEFINED (bf_man_ponto_repos) &THEN   
    assign c-pto-repos = item.pto-repos.                     
    &ENDIF

   end.         
   else do:
       assign cb-politica     = {ininc/i04in122.i 04 1}
              cb-demanda      = {ininc/i02in122.i 04 1}
              cb-reab-estoq   = {ininc/i26in172.i 04 1}.
   end.         

   display tb-conv-tempo-seg with frame {&frame-name}.
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

    if  input frame {&frame-name} item.tipo-est-seg = 1 then do with frame {&frame-name}:
        enable  item.quant-segur.
        disable item.tempo-segur. 
    end.
    else do with frame {&frame-name}:
        enable  item.tempo-segur.
        disable item.quant-segur.
    end.


    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 then do  with frame {&frame-name}:
        enable  item.periodo-fixo.
    end.
    else do  with frame {&frame-name}:
        disable item.periodo-fixo.
    end.        

    if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2 then do:
        enable item.lote-ec 
               with frame {&frame-name}.
    end.
    else do with frame {&frame-name}:
        disable item.lote-ec.
    end.

   &IF DEFINED (bf_man_ponto_repos) &THEN   
       assign c-pto-repos:hidden in frame {&frame-name} = no.
  &ELSE
      assign c-pto-repos:hidden in frame {&frame-name} = yes.
             
  &ENDIF



    enable cb-reab-estoq with frame {&frame-name}.

    apply 'value-changed' to cb-politica in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &IF DEFINED (bf_man_203) &THEN              
      if can-find (first fam-uni-estab
                   where fam-uni-estab.fm-codigo = item.fm-codigo no-lock) then do:

         assign l-modific  = yes
                l-anterior = yes.          
         run cdp/cd0204k1.w (input        item.it-codigo,
                             input-output l-modific,
                             input-output l-anterior,
                             output       l-cancelar,
                             output table tt-estabel).

         run cdp/cd0204k.p (input item.it-codigo,
                            input "M", /* Modifica»’o */
                            input l-modific,
                            input l-anterior,
                            input (not l-cancelar),
                            input table tt-estabel,
                            input table tt-old-item).
      end. 
  &ENDIF 

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

    &IF DEFINED (bf_man_ponto_repos) &THEN   
  assign c-pto-repos:hidden in frame {&frame-name} = no.
  &ELSE
  assign c-pto-repos:hidden in frame {&frame-name} = yes.
  &ENDIF


  /* Code placed here will execute AFTER standard behavior.    */
  find first param-global no-lock no-error.

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

&if defined (bf_man_sfc_lc) &then
    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT "cb-ind-lista-mrp").


    assign i-lista-mrp = {ininc/i03in180.i 06 return-value}.     
&endif

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */

   /* if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 1 
        and input frame {&frame-name} item.periodo-fixo = 0 then do:
        {utp/ut-field.i mgind item periodo-fixo 1}
        {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input 4570,
                          input return-value).
       apply 'entry' to item.periodo-fixo in frame {&frame-name}.
       return 'adm-error':U. 
    end.
    - Colocado em comentÿrio a pedido da FO 315.805 da TCA, alegaram que usam per­odo fixo zero */
  if  {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} = 2
       and  dec(input frame {&frame-name} item.lote-economi) = 0 then do:
      {utp/ut-field.i mgind item lote-economi 1}
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show",
                         input 4570,
                         input return-value).
      apply 'entry' to item.lote-economi in frame {&frame-name}.
      return 'adm-error':U. 
   end.

  if {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}} <> 6 then do:
     FIND FIRST prod-composto WHERE prod-composto.it-codigo-pai = ITEM.it-codigo NO-LOCK NO-ERROR.
     IF AVAIL prod-composto THEN DO:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 52218,
                           input return-value).
        IF RETURN-VALUE = "no" THEN DO:
            apply 'entry' to cb-politica in frame {&frame-name}.
            return 'adm-error':U. 
        END.
        ELSE
            FOR EACH prod-composto WHERE prod-composto.it-codigo-pai = ITEM.it-codigo EXCLUSIVE-LOCK:
                DELETE prod-composto.
            END.
        END.
  end.

  if  input frame {&frame-name} item.lote-multipl <> 
      truncate(input frame {&frame-name} item.lote-multipl,0)
  and item.fraciona = no
  then do:
     {include/i-vldprg.i} 
     run utp/ut-msgs.p (input "show",
                         input 907, 
                         input "").
      apply 'entry' to item.lote-multipl in frame {&frame-name}.
      return 'adm-error'.
  end.

  if  {ininc/i26in172.i 06 cb-reab-estoq:screen-value in frame {&frame-name}} = 2 then do:
       assign i-politica = {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}}.
     if i-politica = 3 or i-politica = 4 then do:
         {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */  
          run utp/ut-msgs.p ("Show",
                            16490,
                            "").
          apply "entry" to cb-reab-estoq.
          return "adm-error".
      end.
  end. 


  &IF DEFINED (bf_man_ponto_repos) &THEN
   assign i-politica = {ininc/i04in122.i 06 cb-politica:screen-value in frame {&frame-name}}.

   if  i-politica = 7 then do :   

     if  input frame {&frame-name} item.quant-segur >=
         input frame {&frame-name} c-pto-repos then do:
         {utp/ut-field.i mgind item quant-segur 1}
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show",
                            input 26786,
                            input return-value).
         apply 'entry' to item.quant-segur in frame {&frame-name}.
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


