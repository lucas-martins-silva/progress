&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V08IN111 2.00.00.068 } /*** "010068" 27/09/2023 12:19:54  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v08in111 MUT}
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

{cdp/cdcfgman.i}

/* Local Variable Definitions ---                                       */

def temp-table tt-item no-undo
    field seq-cont  as integer
    field sequencia as integer
    field it-codigo as char
    field es-codigo as char
    FIELD cod-lista-compon AS CHAR
    INDEX codigo IS UNIQUE PRIMARY seq-cont.

DEFINE BUFFER b-item  FOR ITEM.
DEFINE BUFFER b2-item FOR ITEM .
def var c-alt            as char format "x(1)" no-undo.

def var de-quantidade   like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999" no-undo initial 1.
def var da-data-corte   as date    no-undo initial today.
def var c-format        as char    no-undo initial "->>>>,>>9.9999999999".

def var de-quant-usada   like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999" no-undo.
def var de-quant-liquid  like estrutura.quant-liquid FORMAT "->>>>,>>9.9999999999" no-undo.

def var l-refer-incluida as logical no-undo initial no.
define var i-seq         as integer no-undo.
define var c-refer       like ref-item.cod-refer no-undo.
define var c-refer-es    like ref-item.cod-refer no-undo.
def var c-descricao      like item.desc-item no-undo.   /*format "x(25)".*/
def var i-nivel          as integer no-undo.
def var i-index          as integer no-undo.
DEF VAR c-cod-lista-ant  AS CHAR NO-UNDO.
DEF VAR i-cont-lista     AS INT  NO-UNDO.


def var i-cont     as int  no-undo.
def var l-expande  as logical init no no-undo.

def new global shared var gr-item      as rowid no-undo.
def new global shared var gr-estrutura as rowid no-undo.
def new global shared var gr-item      as rowid no-undo.

def buffer b-item-bt for item.

def var l-acabados      as logical no-undo initial yes.

def var c-aux    as char format "x(255)" no-undo.
def var c-ref    as char                 no-undo.
def var c-processo as char                  no-undo.
def var c-qt-liq as char                 no-undo.
def var c-qt-br  as char                 no-undo.
DEF VAR c-lista  AS CHAR                 NO-UNDO.

def var c-handle         as handle  no-undo.
def var c-controle-nivel as integer no-undo.

DEF VAR l-ativo          AS LOG  NO-UNDO INITIAL YES.
DEF VAR l-auto           AS LOG  NO-UNDO INITIAL YES.
DEF VAR l-todas          AS LOG  NO-UNDO INITIAL YES.
DEF VAR l-total          AS LOG  no-undo INITIAL YES.
DEF VAR i-processos      AS INT  NO-UNDO INITIAL 2.  
DEF VAR c-cod-estabel    AS CHAR NO-UNDO INITIAL "". 
DEF VAR i-nr-linha       AS INT  NO-UNDO INITIAL ?.
DEF VAR c-cod-unid-negoc AS CHAR NO-UNDO INITIAL "". 
DEF VAR h-enapi607       AS HANDLE NO-UNDO.

DEF TEMP-TABLE tt-proces-item  no-undo LIKE proces-item.
DEF TEMP-TABLE tt-proces-item-componente  no-undo LIKE proces-item.

Define Variable iSequencia      As Integer     No-undo.
Define Temp-table tt-estrutura-no No-undo
    Field iPai              As   Integer
    Field iNivel            As   Integer
    Field iNivelPai         As   Integer
    Field iSequencia        As   Integer
    Field tgTemFilhos       As   Logical
    Field tgProcessado      As   Logical
    Field cNivelPai         As   Character
    Field aux-2             As   Character
    Field it-codigo         Like estrutura.it-codigo
    Field aux               As   Character  Format "x(255)"
    Field sequencia         Like estrutura.sequencia
    Field desc-item         Like item.desc-item
    Field refer-es          Like ref-item.cod-refer 
    Field de-quant-liquid   Like estrutura.quant-liquid FORMAT "->>>>,>>9.9999999999"
    Field de-quant-usada    Like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999"
    Field un-neg            As   Character
    Field cod-lista-compon  Like estrutura.cod-lista-compon
    Field un                Like item.un
    Field es-codigo         Like estrutura.es-codigo.

DEF BUFFER bf-tt-estrutura-no FOR tt-estrutura-no.
DEF BUFFER bf-estrutura FOR estrutura.
DEF BUFFER bf1-estrutura FOR estrutura.

DEFINE VARIABLE l-usa-unid-negoc AS LOGICAL   NO-UNDO.
DEFINE VARIABLE h-cdapi024       AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-un-neg         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-unid-retornada AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-retornado      AS CHARACTER NO-UNDO.
DEF VAR l-fn-cb-ref AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-refer-aux AS CHAR NO-UNDO.


DEFINE VARIABLE c-label AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-key AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-key-pai AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-options AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-node        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lSetTreeview  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lHasChild     AS LOGICAL     NO-UNDO.
//def var chTreeView as com-handle.
{utp/ut-4gltreeview.i}

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 

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
DEFINE BUTTON bt-comp 
     LABEL "Componente" 
     SIZE 12.57 BY 1.13.

DEFINE BUTTON bt-compras 
     LABEL "Compras" 
     SIZE 12.57 BY 1.13.

DEFINE BUTTON bt-estoque 
     LABEL "Estoque" 
     SIZE 12.57 BY 1.13.

DEFINE BUTTON bt-onde 
     LABEL "Onde Se Usa" 
     SIZE 12.57 BY 1.13.

DEFINE BUTTON bt-processo 
     LABEL "&Processo" 
     SIZE 12.57 BY 1.13.

DEFINE BUTTON bt-prod 
     LABEL "Produ‡Æo" 
     SIZE 12.57 BY 1.13.

DEFINE BUTTON bt-relacao 
     LABEL "Rela‡Æo" 
     SIZE 12.57 BY 1.13.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 135 BY 17.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-relacao AT ROW 18.75 COL 1
     bt-comp AT ROW 18.75 COL 13.57
     bt-processo AT ROW 18.75 COL 26
     bt-compras AT ROW 18.75 COL 38.57
     bt-estoque AT ROW 18.75 COL 51
     bt-prod AT ROW 18.75 COL 63.57
     bt-onde AT ROW 18.75 COL 76
     RECT-3 AT ROW 1 COL 1 WIDGET-ID 4
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
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 18.88
         WIDTH              = 135.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON bt-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-compras IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-estoque IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-onde IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-processo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-prod IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-relacao IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME bt-comp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-comp V-table-Win
ON CHOOSE OF bt-comp IN FRAME f-main /* Componente */
DO:
    DEFINE VAR rwaux AS ROWID NO-UNDO.
    DEFINE VAR current-window-handle AS HANDLE.
    
    current-window-handle = this-procedure:current-window.

    assign i-index = INT(SUBSTRING(c-codigo-node, 7, 5)).
    ASSIGN rwaux = TO-ROWID(DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node)).

    find FIRST tt-item where
         tt-item.seq-cont = i-index NO-ERROR.

    IF AVAIL tt-item THEN DO:
       FIND estrutura WHERE ROWID(estrutura) = rwaux NO-LOCK NO-ERROR.
       find first b-item-bt
            where b-item-bt.it-codigo = estrutura.es-codigo no-lock no-error.
       if  available b-item-bt then do:
           assign gr-item = rowid(b-item-bt).
           assign current-window-handle:sensitive = NO. 
           if session:set-wait-state ("general") then.
           run enp/en0703.w.
           assign current-window-handle:sensitive = YES.
           assign gr-item = rowid(item).
       end.
    END.
    ELSE
       run utp/ut-msgs.p (input "show",
                          input 4888,
                          input return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-compras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-compras V-table-Win
ON CHOOSE OF bt-compras IN FRAME f-main /* Compras */
DO:
    DEFINE VAR rwaux AS ROWID NO-UNDO.
    DEFINE VAR current-window-handle AS HANDLE.
    
    current-window-handle = this-procedure:current-window.
    
    assign i-index = INT(SUBSTRING(c-codigo-node, 7, 5)).
    ASSIGN rwaux = TO-ROWID(DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node)).
    
    find FIRST tt-item where
         tt-item.seq-cont = i-index NO-ERROR.

    IF AVAIL tt-item THEN DO:
       FIND estrutura WHERE ROWID(estrutura) = rwaux NO-LOCK NO-ERROR.
       find first b-item-bt
            where b-item-bt.it-codigo = estrutura.es-codigo no-lock no-error.
       if  available estrutura then do:
           assign gr-item = rowid(b-item-bt).
           assign current-window-handle:sensitive = NO. 
           if session:set-wait-state ("general") then.
           run ccp/cc0504a.w.
           assign current-window-handle:sensitive = YES.
           assign gr-item = rowid(item).
       end.
    END.
    ELSE
       run utp/ut-msgs.p (input "show",
                          input 4888,
                          input return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-estoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estoque V-table-Win
ON CHOOSE OF bt-estoque IN FRAME f-main /* Estoque */
DO:
    DEFINE VAR rwaux AS ROWID NO-UNDO.
    DEFINE VAR current-window-handle AS HANDLE.
    current-window-handle = this-procedure:current-window.

    assign i-index = INT(SUBSTRING(c-codigo-node, 7, 5)).
    ASSIGN rwaux = TO-ROWID(DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node)).

    find FIRST tt-item where
         tt-item.seq-cont = i-index NO-ERROR.

    IF AVAIL tt-item THEN DO:
       FIND estrutura WHERE ROWID(estrutura) = rwaux NO-LOCK NO-ERROR.
       find first b-item-bt
            where b-item-bt.it-codigo = estrutura.es-codigo no-lock no-error.
       if  available estrutura then do:
           assign gr-item = rowid(b-item-bt).
           assign current-window-handle:sensitive = NO. 
           if session:set-wait-state ("general") then.
           run cep/ce0813.w.
           assign current-window-handle:sensitive = YES.
          assign gr-item = rowid(item).
       end.
    END.
    ELSE
       run utp/ut-msgs.p (input "show",
                          input 4888,
                          input return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-onde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-onde V-table-Win
ON CHOOSE OF bt-onde IN FRAME f-main /* Onde Se Usa */
DO:
    DEFINE VAR rwaux AS ROWID NO-UNDO.
    DEFINE VAR current-window-handle AS HANDLE.
    current-window-handle = this-procedure:current-window.
    assign i-index = INT(SUBSTRING(c-codigo-node, 7, 5)).
    ASSIGN rwaux = TO-ROWID(DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node)).
    find FIRST tt-item where
         tt-item.seq-cont = i-index NO-ERROR.

    IF AVAIL tt-item THEN DO:
       FIND estrutura WHERE ROWID(estrutura) = rwaux NO-LOCK NO-ERROR.
       find first b-item-bt
            where b-item-bt.it-codigo = estrutura.es-codigo no-lock no-error.
       if  available estrutura then do:
           assign gr-item = rowid(b-item-bt)
           gr-estrutura = rowid(estrutura).
           assign current-window-handle:sensitive = NO. 
           if session:set-wait-state ("general") then.
           run enp/en0813.w.
           assign current-window-handle:sensitive = YES.
           assign gr-item = rowid(item).
       end.
    END.
    ELSE
       run utp/ut-msgs.p (input "show",
                          input 4888,
                          input return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-processo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-processo V-table-Win
ON CHOOSE OF bt-processo IN FRAME f-main /* Processo */
DO:
  DEFINE VAR rwaux AS ROWID NO-UNDO.
  DEFINE VAR current-window-handle AS HANDLE.
  
  current-window-handle = this-procedure:current-window.
    assign i-index = INT(SUBSTRING(c-codigo-node, 7, 5)).
    ASSIGN rwaux = TO-ROWID(DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node)).

  find FIRST tt-item where
         tt-item.seq-cont = i-index NO-ERROR.

  IF AVAIL tt-item THEN DO:
     FIND estrutura WHERE ROWID(estrutura) = rwaux NO-LOCK NO-ERROR.
     find first b-item-bt
          where b-item-bt.it-codigo = estrutura.es-codigo no-lock no-error.
     if available b-item-bt then do:
        assign gr-item = rowid(b-item-bt).
        assign current-window-handle:sensitive = NO. 
        run enp/en0707.w.
        assign current-window-handle:sensitive = YES.
        apply "entry" to bt-processo in frame {&frame-name}.
        assign gr-item = rowid(item).
     end.
  END.
  ELSE
     run utp/ut-msgs.p (input "show",
                        input 4888,
                        input return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-prod V-table-Win
ON CHOOSE OF bt-prod IN FRAME f-main /* Produ‡Æo */
DO:
    DEFINE VAR rwaux AS ROWID NO-UNDO.
    DEFINE VAR current-window-handle AS HANDLE.
    
    current-window-handle = this-procedure:current-window.
    assign i-index = INT(SUBSTRING(c-codigo-node, 7, 5)).
    ASSIGN rwaux = TO-ROWID(DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node)).

    find FIRST tt-item where
         tt-item.seq-cont = i-index NO-ERROR.

    IF AVAIL tt-item THEN DO:
       FIND estrutura WHERE ROWID(estrutura) = rwaux NO-LOCK NO-ERROR.
       find first b-item-bt
            where b-item-bt.it-codigo = estrutura.es-codigo no-lock no-error.
       if  available estrutura then do:
           assign gr-item = rowid(b-item-bt).
           assign current-window-handle:sensitive = NO. 
           if session:set-wait-state ("general") then.
           run cpp/cp0506.w.
           assign current-window-handle:sensitive = YES.
           assign gr-item = rowid(item).
       end.
    END.
    ELSE
       run utp/ut-msgs.p (input "show",
                          input 4888,
                          input return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relacao V-table-Win
ON CHOOSE OF bt-relacao IN FRAME f-main /* Rela‡Æo */
DO:
    DEFINE VAR rwaux AS ROWID NO-UNDO.
    DEFINE VAR current-window-handle AS HANDLE.
    
    current-window-handle = this-procedure:current-window.
    assign i-index = INT(SUBSTRING(c-codigo-node, 7, 5)).
    ASSIGN rwaux = TO-ROWID(DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node)).

    find FIRST tt-item where
         tt-item.seq-cont = i-index NO-ERROR.

    IF AVAIL tt-item THEN DO:
       FIND estrutura WHERE ROWID(estrutura) = rwaux NO-LOCK NO-ERROR.
       if available estrutura then do:  
          find b-item-bt where b-item-bt.it-codigo = estrutura.it-codigo no-lock no-error.
          assign gr-estrutura = rowid(estrutura)
                 gr-item      = rowid(b-item-bt).
          assign current-window-handle:sensitive = NO. 
          if session:set-wait-state ("general") then.
          run enp/en0806.w.
          assign current-window-handle:sensitive = YES.
       end.
    END.
    ELSE
        run utp/ut-msgs.p (input "show",
                           input 4888,
                           input return-value).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

ASSIGN l-usa-unid-negoc = FALSE.

IF CAN-FIND (FIRST funcao
                WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                AND   funcao.ativo     = TRUE) THEN DO:

    ASSIGN l-usa-unid-negoc = TRUE.
END.
        
    FIND FIRST funcao
            WHERE funcao.cd-funcao = "SPP-FI-REFER" 
            AND funcao.ativo     = YES NO-LOCK NO-ERROR.
    IF AVAILABLE funcao THEN
            ASSIGN l-fn-cb-ref = YES.
            ELSE ASSIGN l-fn-cb-ref = NO.

{utp/ut-liter.i Alternativo * r}
assign c-alt = substr(return-value,1,1).

{utp/ut-liter.i Qt_Liq:} 
assign c-qt-liq = trim(return-value).

{utp/ut-liter.i Lista_Compon:} 
assign c-lista = trim(return-value).

{utp/ut-liter.i Qt_Brut:} 
assign c-qt-br = trim(return-value).

IF l-usa-unid-negoc THEN DO:
    {utp/ut-liter.i Un._Neg:}
    assign c-un-neg = trim(return-value).
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize-controls V-table-Win 
PROCEDURE initialize-controls :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     //chTreeView = chctrlframe:TreeView.
     
     

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
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF VALID-HANDLE(h-cdapi024) THEN DO:
      DELETE PROCEDURE h-cdapi024.
      ASSIGN h-cdapi024 = ?.
  END.

  IF VALID-HANDLE(h-4gltreeview) THEN DO: 
      RUN destroyObject IN h-4gltreeview.
      DELETE PROCEDURE h-4gltreeview NO-ERROR.
   END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .


  IF VALID-HANDLE(h-4gltreeview) THEN
    RUN emptyTree IN h-4gltreeview.

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

   RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT this-procedure,OUTPUT c-handle).      
  
  IF l-usa-unid-negoc THEN DO:

      RUN cdp~/cdapi024.p PERSISTENT SET h-cdapi024.
  END.


  IF NOT VALID-HANDLE(h-4gltreeview) THEN DO:
      RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.

      RUN setParentFrame IN h-4gltreeview(INPUT FRAME f-main:HANDLE).

      RUN initializeObject IN h-4gltreeview.
   
      SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.

      RUN repositionObject IN h-4gltreeview ( 1 , 1 ) NO-ERROR.  
      RUN resizeObject IN h-4gltreeview ( 17.75, 135) NO-ERROR.   

      RUN applyEntry IN h-4gltreeview(INPUT "").
  END.                                       
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 
  assign i-cont = 1.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query V-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iNivel       AS INTEGER NO-UNDO.
  DEFINE VARIABLE iNivelPai    AS INTEGER NO-UNDO.
  DEFINE VARIABLE iPai         AS INTEGER NO-UNDO.
  DEFINE VARIABLE l-gera-lista AS LOG NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN c-node = "".

  if session:set-wait-state ("general") then.

  if avail item then do:
    RUN emptyTree IN h-4gltreeview.

    IF l-fn-cb-ref = NO THEN 
     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT 'cb-ref').
       ELSE RUN Get-Field-Screen-Value IN adm-broker-hdl
           (INPUT this-procedure,
            INPUT 'fi-ref').
                      
      assign c-refer = if return-value = ? then "" else return-value
             c-refer-aux = c-refer.
  
      assign i-seq   = 1.
  
      assign c-controle-nivel = 0
             c-cod-lista-ant = "".
  
      
      IF i-processos = 2 THEN
          ASSIGN l-gera-lista = YES.
  
      IF l-usa-unid-negoc THEN DO:
          IF c-cod-unid-negoc = "" THEN
              ASSIGN c-cod-unid-negoc = ?.
      END.

      EMPTY TEMP-TABLE tt-estrutura-no.
      
      ASSIGN  iNivel          = 0
              iNivelPai       = 0
              iPai            = 0
              iSequencia      = 0.

      IF NOT VALID-HANDLE(h-enapi607) THEN
          RUN enp/enapi607.p PERSISTENT SET h-enapi607.

      RUN generateProcessList IN h-enapi607(INPUT ITEM.it-codigo,
                                            INPUT ?,
                                            INPUT c-cod-estabel,
                                            INPUT c-refer-aux,
                                            INPUT ?,
                                            INPUT i-nr-linha,
                                            INPUT l-gera-lista,
                                            INPUT c-cod-unid-negoc,
                                            INPUT-OUTPUT TABLE tt-proces-item).

      if valid-handle(h-enapi607) then
          DELETE OBJECT h-enapi607.

      for each estrutura no-lock
          Where estrutura.it-codigo = item.it-codigo:

          if ((estrutura.data-inicio  <= da-data-corte and
               estrutura.data-termino > da-data-corte) or da-data-corte = ?) 
                                   /*and estrutura.cod-lista-compon = c-processo*/ then do:

              IF CAN-FIND(FIRST tt-proces-item
                          where tt-proces-item.it-codigo = estrutura.it-codigo
                          AND   tt-proces-item.cod-lista-compon = estrutura.cod-lista-compon) THEN DO:

              
                  ASSIGN c-processo = estrutura.cod-lista-compon.
          
                  IF estrutura.cod-lista-compon <> "" THEN
                      ASSIGN c-refer = "".
                                       
                  for first b-item fields (it-codigo cod-estabel  tipo-con-est   desc-item   un   cod-obsoleto)
                      where b-item.it-codigo = estrutura.es-codigo No-lock:
                  end.

                  /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                  assign de-quant-usada =  if estrutura.log-quant-fix then estrutura.qtd-compon else ((estrutura.qtd-compon / estrutura.qtd-item) * (estrutura.proporcao / 100)) * de-quantidade 
                          de-quant-liquid = if estrutura.log-quant-fix then de-quant-usada else de-quant-usada * (1 - (estrutura.fator-perda / 100)).  

                  if l-usa-unid-negoc then do:
                      RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT  b-item.cod-estabel,
                                                               INPUT  b-item.it-codigo,
                                                               INPUT  "",
                                                               OUTPUT c-unid-retornada).
                      ASSIGN c-retornado = c-unid-retornada.
                  end.

                  if (b-item.tipo-con-est = 4 or 
                       item.tipo-con-est = 4) AND estrutura.cod-lista-compon = "" then do:

                      for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo  sequencia   cod-ref-es)
                          where ref-estrut.it-codigo  = estrutura.it-codigo and  
                                ref-estrut.es-codigo  = estrutura.es-codigo and
                                ref-estrut.sequencia  = estrutura.sequencia no-lock: end.

                      IF not avail ref-estrut THEN DO:
                           assign l-refer-incluida = yes
                                  c-refer-es       = ''.           
                      END.
                      else do:
                                              
                          for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo  sequencia   cod-ref-es)
                                                             where ref-estrut.it-codigo  = estrutura.it-codigo and  
                                                                   ref-estrut.cod-ref-it = c-refer and  
                                                                   ref-estrut.es-codigo  = estrutura.es-codigo and
                                                                   ref-estrut.sequencia  = estrutura.sequencia no-lock: end.
                          if available ref-estrut then
                              assign c-refer-es       = ref-estrut.cod-ref-es
                                     l-refer-incluida = yes.
                          else DO:
                              assign l-refer-incluida = NO.
                              
                              /*
                              FOR FIRST ref-item NO-LOCK
                                  WHERE ref-item.it-codigo = estrutura.it-codigo
                                  ASSIGN l-refer-incluida = AVAIL ref-item.
                              END.
                              */
                              
                          END.
                      end.
                  end.
                  else do:
                      assign l-refer-incluida = yes
                             c-refer-es       = ''.
                      if c-processo <> "" then
                          assign l-refer-incluida = yes.
                  end.

                  if l-refer-incluida and 
                    ((b-item.cod-obsoleto = 1 AND l-ativo = yes) or
                     (b-item.cod-obsoleto = 2 AND l-auto  = Yes) or
                     (b-item.cod-obsoleto = 3 AND l-todas = Yes) or
                     (b-item.cod-obsoleto = 4 AND l-total = Yes)) then do:
                      if estrutura.fantasma then
                          assign c-aux = '#'.
                      else
                          assign c-aux = ''.

                      if can-find (first alternativo 
                                   where alternativo.es-codigo = estrutura.es-codigo
                                     and alternativo.it-codigo = estrutura.it-codigo
                                     and alternativo.sequencia = estrutura.sequencia no-lock) then
                          assign c-aux = c-aux +  c-alt.

                      if today >= estrutura.data-termino or today < estrutura.data-inicio then
                          assign c-aux = c-aux +  '?'.

                  //end.

                  //IF l-refer-incluida = YES THEN DO:
                      /*Gera Estrutura Item.*/
                      Assign  iPai            = iPai + 1
                              iNivel          = 1
                              iNivelPai       = 1
                              iSequencia      = iSequencia + 1.
                      
                      Create  tt-estrutura-no. 
                      Assign  tt-estrutura-no.sequencia           = estrutura.sequencia
                              tt-estrutura-no.iPai                = iPai
                              tt-estrutura-no.iNivel              = iNivel
                              tt-estrutura-no.iNivelPai           = iNivelPai
                              tt-estrutura-no.iSequencia          = iSequencia
                              tt-estrutura-no.it-codigo           = estrutura.it-codigo
                              tt-estrutura-no.es-codigo           = estrutura.es-codigo
                              tt-estrutura-no.cNivelPai           = String(iPai,"99999") + String(iNivelPai,"99999")
                              tt-estrutura-no.aux-2               = "PAI"
                              tt-estrutura-no.aux                 = c-aux
                              tt-estrutura-no.desc-item           = trim(b-item.desc-item)
                              tt-estrutura-no.refer-es            = c-refer-es
                              tt-estrutura-no.de-quant-liquid     = de-quant-liquid
                              tt-estrutura-no.de-quant-usada      = de-quant-usada
                              tt-estrutura-no.un-neg              = c-retornado 
                              tt-estrutura-no.cod-lista-compon    = estrutura.cod-lista-compon
                              tt-estrutura-no.un                  = b-item.un
                              tt-estrutura-no.tgProcessado        = Yes
                              tt-estrutura-no.tgTemFilhos         = Yes.
                      
                      find tt-item where
                          tt-item.seq-cont = iSequencia no-error.
                      if not avail tt-item then do:
                          create tt-item.
                          assign tt-item.seq-cont = iSequencia.
                      end.
                      assign  tt-item.sequencia = estrutura.sequencia
                              tt-item.it-codigo = estrutura.it-codigo
                              tt-item.es-codigo = estrutura.es-codigo
                              tt-item.cod-lista-compon = estrutura.cod-lista-compon
                              .
                      
                      RUN piRecursividade (INPUT estrutura.es-codigo,
                                           INPUT iPai,
                                           INPUT iNivel,
                                           INPUT iSequencia,
                                           INPUT de-quant-usada, /*de-quant-liquid*/
                                           INPUT c-refer-es).
                                           
                  END.
             end.
          end.
      end.    /*For Each tt-proces-item*/

      for each bf-tt-estrutura-no
          Where bf-tt-estrutura-no.tgTemFilhos    = Yes
            AND bf-tt-estrutura-no.tgProcessado   = No:

          Assign bf-tt-estrutura-no.tgProcessado = Yes.

          find tt-item where
              tt-item.seq-cont = bf-tt-estrutura-no.iSequencia no-error.
          if not avail tt-item then do:
              create tt-item.
              assign tt-item.seq-cont = bf-tt-estrutura-no.iSequencia.
          end.
          assign  tt-item.sequencia = bf-tt-estrutura-no.sequencia
                  tt-item.it-codigo = bf-tt-estrutura-no.it-codigo
                  tt-item.es-codigo = bf-tt-estrutura-no.es-codigo
                  tt-item.cod-lista-compon = bf-tt-estrutura-no.cod-lista-compon
                  . 

          RUN piRecursividade (INPUT bf-tt-estrutura-no.es-codigo,
                               INPUT bf-tt-estrutura-no.iPai,
                               INPUT bf-tt-estrutura-no.iNivel,
                               INPUT bf-tt-estrutura-no.iSequencia,
                               INPUT bf-tt-estrutura-no.de-quant-usada, /*bf-tt-estrutura-no.de-quant-liquid*/
                               INPUT bf-tt-estrutura-no.refer-es ).
      end.

      Run piAtualizaTreeView.
  end. /*End IF AVAILABLE ITEM*/


  ASSIGN lHasChild = DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview).


  /*For‡ando expandir o primeiro node quando o registro */
  IF lHasChild AND l-expande THEN
      RUN expandBranch IN h-4gltreeview ("E0000100001") no-error.
  
  /*NÆo tirar abaixo - Esta procedure cria a treview no componente*/
  RUN pi-atualizaTreeview IN THIS-PROCEDURE.



   assign bt-relacao:sensitive in frame {&frame-name} = lHasChild
          bt-comp:sensitive in frame {&frame-name} = lHasChild
          bt-processo:sensitive in frame {&frame-name} = lHasChild
          bt-estoque:sensitive in frame {&frame-name} = lHasChild
          bt-compras:sensitive in frame {&frame-name} = lHasChild
          bt-prod:sensitive in frame {&frame-name} = lHasChild
          bt-onde:sensitive in frame {&frame-name} = lHasChild.

   IF lHasChild = YES THEN
        run pi-habilita-expande in c-handle(input yes).
   ELSE run pi-habilita-expande in c-handle(input NO).

  
  if session:set-wait-state ("") then.

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
  assign gr-item = rowid(item).
  RUN dispatch ("open-query").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-clickTreeView V-table-Win 
PROCEDURE pi-clickTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
//c-key   =  "E" + String(tt-estrutura-no.iPai,"99999") + STRING(tt-estrutura-no.iSequencia,"99999")

    ASSIGN c-node = c-codigo-node.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-expande V-table-Win 
PROCEDURE pi-expande :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign l-expande = not l-expande.
run local-open-query.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-filtra-query V-table-Win 
PROCEDURE pi-filtra-query :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter p-de-quantidade like estrutura.quant-usada  FORMAT "->>>>,>>9.9999999999" NO-UNDO.
define input parameter p-da-data-corte as date.
define input parameter p-c-format      as char.
define input parameter p-l-ativo       AS LOG.
define input parameter p-l-auto        AS LOG.
define input parameter p-l-todas       AS LOG.
define input parameter p-l-total       AS LOG.
define input parameter p-i-processos   AS INT.
define input parameter p-c-cod-estabel AS CHAR.
define input parameter p-i-nr-linha    AS INT.
define input parameter p-c-cod-unid-negoc AS CHAR.

assign de-quantidade    = p-de-quantidade
       da-data-corte    = p-da-data-corte
       c-format         = p-c-format
       l-ativo          = p-l-ativo
       l-auto           = p-l-auto
       l-todas          = p-l-todas
       l-total          = p-l-total
       i-processos      = p-i-processos
       c-cod-estabel    = p-c-cod-estabel
       i-nr-linha       = p-i-nr-linha
       c-cod-unid-negoc = p-c-cod-unid-negoc
       .

RUN local-open-query.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaTreeView V-table-Win 
PROCEDURE piAtualizaTreeView :
define variable v-pai as integer no-undo.

DEFINE VARIABLE l-selected AS LOGICAL     NO-UNDO.
    assign v-pai = 0.
    assign i-cont = 0.

    for each tt-estrutura-no
        by tt-estrutura-no.cNivelPai
        by tt-estrutura-no.iSequencia:

        
        FOR FIRST estrutura WHERE estrutura.it-codigo = tt-estrutura-no.it-codigo AND
                                  estrutura.sequencia = tt-estrutura-no.sequencia AND
                                  estrutura.es-codigo = tt-estrutura-no.es-codigo NO-LOCK:
        END.

        ASSIGN c-key   =  "E" + String(tt-estrutura-no.iPai,"99999") + STRING(tt-estrutura-no.iSequencia,"99999")
               c-label = String (tt-estrutura-no.sequencia) + " " + tt-estrutura-no.aux + " " 
                         + tt-estrutura-no.es-codigo      + " - " + Trim(tt-estrutura-no.desc-item) + " - " 
                         + (if tt-estrutura-no.refer-es = "" then "" else tt-estrutura-no.refer-es + " - ")
                         + c-qt-liq + " " + trim(string(tt-estrutura-no.de-quant-liquid, c-format)) + " "
                         + c-qt-br + " " + trim(string(tt-estrutura-no.de-quant-usada, c-format))
                         + " " + tt-estrutura-no.un 
                         + (If tt-estrutura-no.cod-lista-compon <> "" Then " - " + c-lista + " " + tt-estrutura-no.cod-lista-compon   
                                                                      Else " ")                                                    
                         + (IF l-usa-unid-negoc Then " - " + c-un-neg + " " + tt-estrutura-no.un-neg                                  
                                                 Else " ")
            c-options = IF l-expande = YES THEN "expanded" ELSE "".


        IF l-expande THEN
            ASSIGN c-options = "expanded".
                
        if tt-estrutura-no.aux-2 = "PAI" then do:

            RUN pi-create-node IN THIS-PROCEDURE (INPUT c-key,
                                                  INPUT "",
                                                  INPUT c-label,
                                                  INPUT "image\treeview\tvpics\separator.bmp",
                                                  INPUT c-options) No-error.
                                                                
            assign i-cont = i-cont + 1.
        end.
        else do:
            ASSIGN c-key-pai = "E" + tt-estrutura-no.cNivelPai.

            RUN pi-create-node IN THIS-PROCEDURE (INPUT c-key,
                                                  INPUT c-key-pai,
                                                  INPUT c-label,
                                                  INPUT "image\treeview\tvpics\separator.bmp",
                                                  INPUT c-options) No-error.
            assign i-cont = i-cont + 1.
        end.

        ASSIGN lSetTreeview = DYNAMIC-FUNCTION('setNodeTag' IN h-4gltreeview,
                                               c-key, STRING(ROWID(estrutura))).

        IF i-cont = 1 THEN
           ASSIGN l-selected = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview, c-key).
       
                        
                
    End.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRecursividade V-table-Win 
PROCEDURE piRecursividade :
DEFINE INPUT PARAMETER pEsCodigo        LIKE Estrutura.es-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pPai             AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pNivel           AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pNivelPai        AS INTEGER                  NO-UNDO.
    DEFINE INPUT PARAMETER pQuantidade      AS DECIMAL                  NO-UNDO.
    DEFINE INPUT PARAMETER pReferencia      LIKE ref-item.cod-refer     NO-UNDO.

    ASSIGN pNivel = pNivel + 1
           //c-refer-aux = pReferencia
        .

    IF NOT VALID-HANDLE(h-enapi607) THEN
        RUN enp/enapi607.p PERSISTENT SET h-enapi607.


    FOR  EACH bf-estrutura NO-LOCK
        WHERE bf-estrutura.it-codigo = pEsCodigo:

        if ((bf-estrutura.data-inicio  <= da-data-corte and
             bf-estrutura.data-termino > da-data-corte) or da-data-corte = ?) then do:

            IF NOT CAN-FIND(FIRST tt-proces-item-componente
                            WHERE tt-proces-item-componente.it-codigo = bf-estrutura.it-codigo
                            AND   tt-proces-item-componente.cod-lista-compon = bf-estrutura.cod-lista-compon) THEN DO:

                RUN generateProcessList IN h-enapi607(INPUT bf-estrutura.it-codigo,
                                                      INPUT ?,
                                                      INPUT c-cod-estabel,
                                                      INPUT pReferencia,
                                                      INPUT ?,
                                                      INPUT i-nr-linha,
                                                      INPUT IF i-processos = 2 THEN TRUE ELSE FALSE,
                                                      INPUT c-cod-unid-negoc,
                                                      INPUT-OUTPUT TABLE tt-proces-item-componente).
 
                //RUN getDados IN h-enapi607 (OUTPUT TABLE tt-proces-item-componente).
            END.

            IF CAN-FIND(FIRST tt-proces-item-componente
                        where tt-proces-item-componente.it-codigo = bf-estrutura.it-codigo
                        AND   tt-proces-item-componente.cod-lista-compon = bf-estrutura.cod-lista-compon) THEN DO:

                ASSIGN c-processo = bf-estrutura.cod-lista-compon.
                IF bf-estrutura.cod-lista-compon <> "" THEN
                    ASSIGN pReferencia = ''.

                /**/
                FOR FIRST b2-item FIELDS (it-codigo tipo-con-est) 
                    WHERE b2-item.it-codigo = bf-estrutura.it-codigo NO-LOCK: END.
                
                for first b-item Fields (it-codigo cod-estabel  tipo-con-est   desc-item   un   cod-obsoleto)
                    Where b-item.it-codigo = bf-estrutura.es-codigo no-lock: end.
    
                /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                assign de-quant-usada =  if bf-estrutura.log-quant-fix then bf-estrutura.qtd-compon else ((bf-estrutura.qtd-compon / bf-estrutura.qtd-item) * (bf-estrutura.proporcao / 100)) * pQuantidade 
                        de-quant-liquid = if bf-estrutura.log-quant-fix then de-quant-usada else de-quant-usada * (1 - (bf-estrutura.fator-perda / 100)).  
    
                if l-usa-unid-negoc then do:
                    RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT  b-item.cod-estabel,
                                                             INPUT  b-item.it-codigo,
                                                             INPUT  "",
                                                             OUTPUT c-unid-retornada).
                    ASSIGN c-retornado = c-unid-retornada.
                end.
    
                if b-item.tipo-con-est = 4 or b2-item.tipo-con-est = 4 then do:
                    for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo sequencia   cod-ref-es)
                        where ref-estrut.it-codigo  = bf-estrutura.it-codigo
                          And ref-estrut.es-codigo  = bf-estrutura.es-codigo
                          And ref-estrut.sequencia  = bf-estrutura.sequencia 
                        no-lock: 
                    end.
                        
                    if  not avail ref-estrut then do:
                        assign l-refer-incluida = Yes 
                               c-refer-es       = ''.
                    end.
                    else do:
                        for first ref-estrut fields (it-codigo   cod-ref-it   es-codigo sequencia   cod-ref-es)
                                where ref-estrut.it-codigo  = bf-estrutura.it-codigo
                                  and ref-estrut.cod-ref-it = pReferencia 
                                  and ref-estrut.es-codigo  = bf-estrutura.es-codigo 
                                  And ref-estrut.sequencia  = bf-estrutura.sequencia no-lock:
                        end.
                        if available ref-estrut then 
                                assign c-refer-es       = ref-estrut.cod-ref-es
                                       l-refer-incluida = yes.
                        else 
                                 assign l-refer-incluida = No.           
                    end.
                end.
                else do:
                    assign l-refer-incluida = yes
                           c-refer-es       = ''.
                    if c-processo <> "" then
                        assign l-refer-incluida = yes.
                end.
    
                if  l-refer-incluida and
                    ((b-item.cod-obsoleto = 1 AND l-ativo = Yes) or
                    (b-item.cod-obsoleto = 2 AND l-auto = Yes) or
                    (b-item.cod-obsoleto = 3 AND l-todas = Yes) or
                    (b-item.cod-obsoleto = 4 AND l-total = Yes)) then do:
                    if bf-estrutura.fantasma then
                        assign c-aux = '#'.
                    else
                        assign c-aux = ''.
    
                    if can-find (first alternativo 
                                 where alternativo.es-codigo = bf-estrutura.es-codigo
                                   and alternativo.it-codigo = bf-estrutura.it-codigo
                                   and alternativo.sequencia = bf-estrutura.sequencia no-lock) then
                        assign c-aux = c-aux +  c-alt.
    
                    if today >= bf-estrutura.data-termino or today < bf-estrutura.data-inicio then
                        assign c-aux = c-aux +  '?'.
    
                //end.
    
                //IF l-refer-incluida = YES THEN DO:
                    assign  iSequencia = iSequencia + 1.
                    create  tt-estrutura-no. 
                    assign  tt-estrutura-no.sequencia           = bf-estrutura.sequencia
                            tt-estrutura-no.iPai                = pPai
                            tt-estrutura-no.iNivel              = pNivel
                            tt-estrutura-no.iNivelPai           = pNivelPai
                            tt-estrutura-no.iSequencia          = iSequencia
                            tt-estrutura-no.it-codigo           = bf-estrutura.it-codigo
                            tt-estrutura-no.es-codigo           = bf-estrutura.es-codigo
                            tt-estrutura-no.tgTemFilhos         = Can-find(First bf1-estrutura Where bf1-estrutura.it-codigo = bf-estrutura.es-codigo)
                            tt-estrutura-no.tgProcessado        = No
                            tt-estrutura-no.cNivelPai           = String(pPai,"99999") + String(pNivelPai,"99999")
                            tt-estrutura-no.aux-2               = "FILHO"
                            tt-estrutura-no.aux                 = c-aux
                            tt-estrutura-no.desc-item           = trim(b-item.desc-item)
                            tt-estrutura-no.refer-es            = c-refer-es
                            tt-estrutura-no.de-quant-liquid     = de-quant-liquid
                            tt-estrutura-no.de-quant-usada      = de-quant-usada
                            tt-estrutura-no.un-neg              = c-retornado 
                            tt-estrutura-no.cod-lista-compon    = bf-estrutura.cod-lista-compon
                            tt-estrutura-no.un                  = b-item.un.
        
                    find tt-item where
                        tt-item.seq-cont = iSequencia no-error.
                    if not avail tt-item then do:
                        create tt-item.
                        assign tt-item.seq-cont = iSequencia.
                    end.
                    assign  tt-item.sequencia = bf-estrutura.sequencia
                            tt-item.it-codigo = bf-estrutura.it-codigo
                            tt-item.es-codigo = bf-estrutura.es-codigo
                            tt-item.cod-lista-compon = bf-estrutura.cod-lista-compon
                            . 
                END.
            END.
        End.
    End.
    IF VALID-HANDLE(h-enapi607) THEN
        DELETE OBJECT h-enapi607.

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

