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
{include/i-prgvrs.i V09IN111 2.00.00.047 } /*** "010047" 16/12/2024 15:42:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v09in111 MUT}
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
    &if defined (bf_man_sfc_lc) &then
        FIELD cod-lista-compon AS CHAR
    &endif
    INDEX codigo IS UNIQUE PRIMARY seq-cont.    

DEF TEMP-TABLE tt-proces-item NO-UNDO
    LIKE proces-item.

def var i-cont     as int  no-undo.
def var i-seq      as integer no-undo.
def var de-quantidade   as decimal no-undo initial 1.
def var da-data-corte   as date    no-undo initial today.
def var l-acabados      as logical no-undo initial yes.
def var c-format        as char    no-undo initial "->>>>,>>9.9999999999".
DEF VAR l-ativo         AS LOG     NO-UNDO INITIAL YES.
DEF VAR l-auto          AS LOG     NO-UNDO INITIAL YES.
DEF VAR l-todas         AS LOG     NO-UNDO INITIAL YES.
DEF VAR l-total         AS LOG     NO-UNDO INITIAL YES.
DEF VAR i-processos     AS INTEGER NO-UNDO INITIAL 2.
DEF VAR c-cod-estabel   AS CHAR    NO-UNDO INITIAL "".
DEF VAR i-nr-linha      AS INTEGER NO-UNDO INITIAL ?.
DEF VAR c-cod-unid-negoc AS CHAR   NO-UNDO INITIAL "".
def var wh-handle       as widget-handle no-undo.

DEF VAR c-it-codigo-old  AS CHARACTER NO-UNDO.
DEF VAR c-ref-old        AS CHARACTER NO-UNDO.

DEFINE VARIABLE h-enapi607       AS HANDLE  NO-UNDO.

def new global shared var gr-item      as rowid no-undo.
def new global shared var gr-estrutura as rowid no-undo.

def buffer b-item-bt for item.

def buffer b-item   for item.

def var c-alt            as char format "x(1)" no-undo.
def var de-quant-usada   like estrutura.quant-usada no-undo.
def var de-quant-gerada  like estrutura.quant-usada no-undo.
def var l-refer-incluida as logical no-undo initial no.
define var c-refer      like ref-item.cod-refer no-undo.
define var c-refer-it   like ref-item.cod-refer no-undo.
def var c-descricao     like item.desc-item no-undo.
def var i-nivel         as integer no-undo.
def var i-index         as integer no-undo.

def var c-aux as char format "x(255)" no-undo.
def var c-ref      as char            no-undo.
def var l-expande  as logical init no no-undo.

def var c-handle         as handle  no-undo.
def var c-controle-nivel as integer no-undo.
DEF VAR c-lista          AS CHAR    NO-UNDO.
DEF VAR l-fn-cb-ref AS LOGICAL NO-UNDO.


DEFINE VARIABLE c-label AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-key AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-key-pai AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-options AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-node        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lSetTreeview  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lHasChild     AS LOGICAL     NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS RECT-1 

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
DEFINE BUTTON bt-compras 
     LABEL "&Compras" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-estoque 
     LABEL "Estoque" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-estrut 
     LABEL "&Estrutura" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-item 
     LABEL "&Item" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-processo 
     LABEL "&Processo" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-prod 
     LABEL "Pro&du‡Æo" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-relacao 
     LABEL "&Rela‡Æo" 
     SIZE 12 BY 1.13.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 134 BY 18.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-relacao AT ROW 18.5 COL 1
     bt-item AT ROW 18.5 COL 13
     bt-processo AT ROW 18.5 COL 25
     bt-compras AT ROW 18.5 COL 37
     bt-estoque AT ROW 18.5 COL 49
     bt-prod AT ROW 18.5 COL 61
     bt-estrut AT ROW 18.5 COL 73
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 2
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
         HEIGHT             = 18.75
         WIDTH              = 134.
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

/* SETTINGS FOR BUTTON bt-compras IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-estoque IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-estrut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-item IN FRAME f-main
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

&Scoped-define SELF-NAME bt-compras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-compras V-table-Win
ON CHOOSE OF bt-compras IN FRAME f-main /* Compras */
DO:
    assign i-index = INT(SUBSTRING(c-codigo-node, 2, 5)).
    find tt-item where
         tt-item.seq-cont = i-index.
    find first b-item-bt
         where b-item-bt.it-codigo = tt-item.it-codigo no-lock no-error.
    if avail b-item-bt then do:
       assign gr-item = rowid(b-item-bt).
       assign wh-handle = THIS-PROCEDURE:current-window
              wh-handle:sensitive = no.     
       if session:set-wait-state ("general") then.
       run ccp/cc0504a.w.
       assign wh-handle:sensitive = yes.
       assign gr-item = rowid(item).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-estoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estoque V-table-Win
ON CHOOSE OF bt-estoque IN FRAME f-main /* Estoque */
DO:
    assign i-index = INT(SUBSTRING(c-codigo-node, 2, 5)).
    find tt-item where
         tt-item.seq-cont = i-index.
    find first b-item-bt
         where b-item-bt.it-codigo = tt-item.it-codigo no-lock no-error.
    if avail b-item-bt then do:
       assign gr-item = rowid(b-item-bt).
       assign wh-handle = THIS-PROCEDURE:current-window
              wh-handle:sensitive = no.     
       if session:set-wait-state ("general") then.
       run cep/ce0813.w.
       assign wh-handle:sensitive = yes.
       assign gr-item = rowid(item).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-estrut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-estrut V-table-Win
ON CHOOSE OF bt-estrut IN FRAME f-main /* Estrutura */
DO:
    assign i-index = INT(SUBSTRING(c-codigo-node, 2, 5)).
    find tt-item where
         tt-item.seq-cont = i-index.
    find first estrutura
         where estrutura.sequencia = tt-item.sequencia
           and estrutura.it-codigo = tt-item.it-codigo
           and estrutura.es-codigo = tt-item.es-codigo no-lock no-error.
    find first b-item-bt
         where b-item-bt.it-codigo = tt-item.it-codigo no-lock no-error. 
    if  available estrutura then do:
        assign gr-item = rowid(b-item-bt)
               gr-estrutura = rowid(estrutura).
        assign wh-handle = THIS-PROCEDURE:current-window
               wh-handle:sensitive = no.     
        if session:set-wait-state ("general") then.      
        run enp/en0812.w.
        assign wh-handle:sensitive = yes.   
        assign gr-item = rowid(item).
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-item V-table-Win
ON CHOOSE OF bt-item IN FRAME f-main /* Item */
DO:
   assign i-index = INT(SUBSTRING(c-codigo-node, 2, 5)).
   find tt-item where
        tt-item.seq-cont = i-index.
   find first b-item-bt
        where b-item-bt.it-codigo = tt-item.it-codigo no-lock no-error.
   if available b-item-bt then do:
      assign gr-item = rowid(b-item-bt).
      assign wh-handle = THIS-PROCEDURE:current-window
             wh-handle:sensitive = no.     
      run enp/en0703.w.
      assign wh-handle:sensitive = yes.
      assign gr-item = rowid(item).
      apply "entry" to bt-item in frame {&frame-name}.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-processo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-processo V-table-Win
ON CHOOSE OF bt-processo IN FRAME f-main /* Processo */
DO:
  assign i-index = INT(SUBSTRING(c-codigo-node, 2, 5)).
  find tt-item where
       tt-item.seq-cont = i-index.
  find first b-item-bt
       where b-item-bt.it-codigo = tt-item.it-codigo no-lock no-error.
  if available b-item-bt then do:
     assign gr-item = rowid(b-item-bt).
     assign wh-handle = THIS-PROCEDURE:current-window
            wh-handle:sensitive = no.     
     run enp/en0707.w.
     assign wh-handle:sensitive = yes.
     apply "entry" to bt-processo in frame {&frame-name}.
     assign gr-item = rowid(item).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-prod V-table-Win
ON CHOOSE OF bt-prod IN FRAME f-main /* Produ‡Æo */
DO:
    assign i-index = INT(SUBSTRING(c-codigo-node, 2, 5)).
    find tt-item where
         tt-item.seq-cont = i-index.
    find first b-item-bt
         where b-item-bt.it-codigo = tt-item.it-codigo no-lock no-error.
    if  available b-item-bt then do:
        assign gr-item = rowid(b-item-bt).
        assign wh-handle = THIS-PROCEDURE:current-window
               wh-handle:sensitive = no.     
        if session:set-wait-state ("general") then.
        run cpp/cp0506.w.
        assign wh-handle:sensitive = yes.
        assign gr-item = rowid(item).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-relacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-relacao V-table-Win
ON CHOOSE OF bt-relacao IN FRAME f-main /* Rela‡Æo */
DO:

   assign i-index = INT(SUBSTRING(c-codigo-node, 2, 5)).
   find tt-item where
        tt-item.seq-cont = i-index.
   find first estrutura
        where estrutura.sequencia = tt-item.sequencia
          and estrutura.it-codigo = tt-item.it-codigo
          and estrutura.es-codigo = tt-item.es-codigo no-lock no-error.
   if available estrutura then do:
      find b-item-bt where b-item-bt.it-codigo = estrutura.es-codigo no-lock no-error.
      assign gr-estrutura = rowid (estrutura)
             gr-item      = rowid (b-item-bt).
      assign wh-handle = THIS-PROCEDURE:current-window
             wh-handle:sensitive = no.     
      run enp/en0807.w.
      assign wh-handle:sensitive = yes.
      assign gr-item = rowid(item).
      apply "entry" to bt-relacao in frame {&frame-name}.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  {utp/ut-liter.i Alternativo * r}
  assign c-alt = substr(return-value,1,1).

  {utp/ut-liter.i Lista_Compon:} 
  assign c-lista = trim(return-value).

        FIND FIRST funcao
                WHERE funcao.cd-funcao = "SPP-FI-REFER" 
                AND funcao.ativo     = YES NO-LOCK NO-ERROR.
        IF AVAILABLE funcao THEN
                ASSIGN l-fn-cb-ref = YES.
                ELSE ASSIGN l-fn-cb-ref = NO.


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


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */ 
  assign i-cont = 1.

  IF NOT VALID-HANDLE(h-4gltreeview) THEN DO:
      RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.
    
      RUN setParentFrame IN h-4gltreeview(INPUT FRAME f-main:HANDLE).
    
      RUN initializeObject IN h-4gltreeview.
    
      SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.
    
      RUN repositionObject IN h-4gltreeview ( 1 , 1 ) NO-ERROR.  
      RUN resizeObject IN h-4gltreeview ( 17.5, 133) NO-ERROR.   
    
      RUN applyEntry IN h-4gltreeview(INPUT "").
  END.                                       


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query V-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lOk AS LOGICAL     NO-UNDO.
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if session:set-wait-state ("general") then.

  def var i-pai      as int             no-undo.
  def var c-fantasma as char format "X" no-undo.
  def buffer b-item for item.

  if avail item then do:
       IF VALID-HANDLE(h-4gltreeview) THEN
           RUN emptyTree IN h-4gltreeview.

       IF l-fn-cb-ref = NO THEN
       RUN Get-Field-Screen-Value IN adm-broker-hdl
          (INPUT this-procedure,
           INPUT 'cb-ref').
         ELSE RUN Get-Field-Screen-Value IN adm-broker-hdl
             (INPUT this-procedure,
              INPUT 'fi-ref').
     assign c-ref = if return-value = ? then "" else return-value.

     assign i-cont = 1
            i-seq  = 1.

     assign c-controle-nivel = 0.


     IF NOT VALID-HANDLE(h-enapi607) THEN
        RUN enp/enapi607.p PERSISTEN SET h-enapi607.

         run pi-gera-estrutura-pai(buffer item,
                                   c-ref, 
                                   de-quantidade,
                                   0,
                                   1).
				   
     IF c-it-codigo-old <> ITEM.it-codigo OR
        c-ref-old       <> c-ref THEN DO:

        ASSIGN lHasChild = DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview).

        /*For‡ando expandir o primeiro node quando o registro */
        IF lHasChild AND l-expande THEN
             RUN expandBranch IN h-4gltreeview ("E1") no-error.
      
        /*NÆo tirar abaixo - Esta procedure cria a treview no componente*/
        RUN pi-atualizaTreeview IN THIS-PROCEDURE.

     END.
     
     ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview, "E1") NO-ERROR.

     if c-controle-nivel >= 2 then
         run pi-habilita-expande in c-handle(input yes).
     else 
         run pi-habilita-expande in c-handle(input no).
            
     find first param-global no-lock no-error.

     assign bt-relacao:sensitive in frame {&frame-name}  = lHasChild
            bt-item:sensitive in frame {&frame-name}     = lHasChild
            bt-processo:sensitive in frame {&frame-name} = lHasChild
            bt-estoque:sensitive in frame {&frame-name}  = lHasChild and param-global.modulo-ce
            bt-compras:sensitive in frame {&frame-name}  = lHasChild and param-global.modulo-cc
            bt-prod:sensitive in frame {&frame-name}     = lHasChild and param-global.modulo-cp
            bt-estrut:sensitive in frame {&frame-name}   = lHasChild
            c-it-codigo-old = ITEM.it-codigo
            c-ref-old       = c-ref                     
            .
  end.

  IF VALID-HANDLE(h-enapi607) THEN DO:
       DELETE OBJECT h-enapi607 NO-ERROR.
       ASSIGN h-enapi607 = ?.
  END.
    
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

  run dispatch ('open-query').

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
define input parameter p-de-quantidade    LIKE estrutura.quant-usada.
define input parameter p-da-data-corte    AS date.
define input parameter p-c-format         AS char.
define input parameter p-l-ativo          AS logical.
define input parameter p-l-auto           AS logical.
define input parameter p-l-todas          AS logical.
define input parameter p-l-total          AS logical.
define input parameter p-i-processos      AS INT.
define input parameter p-c-cod-estabel    AS CHAR.
define input parameter p-i-nr-linha       AS INT.
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
       c-cod-unid-negoc = p-c-cod-unid-negoc.

RUN local-open-query.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-estrutura V-table-Win 
PROCEDURE pi-gera-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define parameter buffer b-item      for item.
   define parameter buffer b-estrutura for estrutura.
   define input parameter p-nivel as integer.
   define input parameter p-pai   as integer.

   if p-nivel > c-controle-nivel then 
   assign c-controle-nivel = p-nivel.

   if b-estrutura.fantasma then 
      assign c-aux = '#'.
   else
       assign c-aux = ''.

   if can-find (first alternativo
                where alternativo.es-codigo = b-estrutura.es-codigo
                  and alternativo.it-codigo = b-estrutura.it-codigo
                  and alternativo.sequencia = b-estrutura.sequencia no-lock) then
      assign c-aux = c-aux +  c-alt.

   if today >= b-estrutura.data-termino or today < b-estrutura.data-inicio then
      assign c-aux = c-aux +  '?'.      

   ASSIGN c-options = IF l-expande = YES THEN "expanded" ELSE "".

   if p-nivel = 1 THEN DO:
       ASSIGN c-key   =  "e" + string (i-cont)
              c-label =   c-aux + " " + 
                         b-item.it-codigo + " - " +
                         trim(b-item.desc-item) + " - " +
                         (if c-refer-it = "" then "" else c-refer-it + " - ") +
                         (IF de-quant-usada <> ? THEN
                             trim(string(de-quant-gerada,c-format)) 
                         ELSE
                             trim(string(de-quant-gerada,c-format)))
                         + " " + b-item.un +
                            (IF b-estrutura.cod-lista-compon <> "" THEN
                                  " - " + c-lista + " " + b-estrutura.cod-lista-compon
                             ELSE " ")
                             .
             



        RUN pi-create-node IN THIS-PROCEDURE (INPUT c-key,
                                              INPUT "",
                                              INPUT c-label,
                                              INPUT "image\treeview\tvpics\separator.bmp",
                                              INPUT c-options) No-error.
   END.
   ELSE DO:

      ASSIGN c-key-pai =   "e" + string (p-pai)
             c-key     =   "e" + string (i-cont)
             c-label   =    c-aux + " " +
                            b-item.it-codigo + " - " +
                            trim(b-item.desc-item) + " - " + 
                           (if c-refer-it = "" then "" else c-refer-it + " - ") +
                           (IF de-quant-usada <> ? THEN
                              trim(string(de-quant-gerada,c-format)) 
                           ELSE
                              trim(string(de-quant-gerada,c-format)))
                            + " " + b-item.un +
                                (IF b-estrutura.cod-lista-compon <> "" THEN
                                    " - " + c-lista + " " + b-estrutura.cod-lista-compon
                                 ELSE
                                    " ").

        RUN pi-create-node IN THIS-PROCEDURE (INPUT c-key,
                                              INPUT c-key-pai,
                                              INPUT c-label,
                                              INPUT "image\treeview\tvpics\separator.bmp",
                                              INPUT c-options) No-error.

   END.

   find tt-item where
        tt-item.seq-cont = i-cont no-error.
   if not avail tt-item then do:
      create tt-item.
      assign tt-item.seq-cont = i-cont.
   end.
   assign tt-item.sequencia = b-estrutura.sequencia
          tt-item.it-codigo = b-estrutura.it-codigo
          tt-item.es-codigo = b-estrutura.es-codigo
          &if defined (bf_man_sfc_lc) &then
              tt-item.cod-lista-compon = b-estrutura.cod-lista-compon
          &endif
          . 

   assign i-cont = i-cont + 1.
   if p-nivel < item.niv-mais-bai then do:
        run pi-gera-estrutura-pai(buffer b-item, 
                                  c-refer-it, 
                                  de-quant-usada, 
                                  p-nivel,
                                  i-cont - 1).
   end.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-estrutura-pai V-table-Win 
PROCEDURE pi-gera-estrutura-pai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define parameter buffer b1-item for item.
define input parameter p-refer      as char no-undo.
define input parameter p-quantidade as decimal no-undo.
define input parameter p-nivel      as integer no-undo.
define input parameter p-pai        as integer no-undo.

define buffer b2-item      for item.
define buffer b-estrutura  for estrutura.
define buffer b-ref-estrut for ref-estrut.

DEF VAR l-gera-lista AS LOG INITIAL NO NO-UNDO.

IF i-processos = 2 THEN
    ASSIGN l-gera-lista = YES.

&if defined(bf_man_206b) &then  
    IF c-cod-unid-negoc = "" THEN
        ASSIGN c-cod-unid-negoc = ?.
&endif
assign p-nivel = p-nivel + 1.

carga-estrutura:
for each  b-estrutura 
    where b-estrutura.es-codigo = b1-item.it-codigo no-lock,
    first b2-item fields (it-codigo   tipo-con-est
                          desc-item   un)
    where b2-item.it-codigo = b-estrutura.it-codigo 
    and (   (b2-item.cod-obsoleto = 1 and l-ativo = yes)                          
         or (b2-item.cod-obsoleto = 2 and l-auto = yes)                          
         or (b2-item.cod-obsoleto = 3 and l-todas = yes)                          
         or (b2-item.cod-obsoleto = 4 and l-total = yes)) no-lock:   

   if (b-estrutura.data-inicio  <= da-data-corte and
       b-estrutura.data-termino >  da-data-corte) or da-data-corte = ? then do:       
       
       IF b-estrutura.cod-lista-compon <> "" THEN DO:
           if b2-item.tipo-con-est = 4 then do:
               if not can-find(first ref-estrut
                               where ref-estrut.es-codigo = b-estrutura.es-codigo
                                 and ref-estrut.it-codigo = b-estrutura.it-codigo)
               then do:
                       for each ref-item
                          where ref-item.it-codigo = b-estrutura.it-codigo:   
                               if valid-handle(h-enapi607) then
                                   RUN generateProcessList IN h-enapi607 (  INPUT b-estrutura.it-codigo,  /*  item pai   */                 
                                                                            INPUT ?,                    /*  quantidade   */
                                                                            INPUT c-cod-estabel,              /*  estabelecimento   */
                                                                            INPUT ref-item.cod-refer,                   /*  referencia   */
                                                                            INPUT ?,                    /*  data inicio   */
                                                                            INPUT i-nr-linha,           /*  linha de produ‡Æo   */      
                                                                            INPUT l-gera-lista,                 /*  gera lista ou principal   */    
                                                                            INPUT c-cod-unid-negoc,           /*  unidade de negocio   */              
                                                                            INPUT-OUTPUT TABLE tt-proces-item).
                       end.
               end.
               else do:
                       for each ref-estrut
                          where ref-estrut.es-codigo = b-estrutura.es-codigo
                            and ref-estrut.it-codigo = b-estrutura.it-codigo:   
                               if valid-handle(h-enapi607) then
                                   RUN generateProcessList IN h-enapi607 (  INPUT b-estrutura.it-codigo,  /*  item pai   */                 
                                                                            INPUT ?,                    /*  quantidade   */
                                                                            INPUT c-cod-estabel,              /*  estabelecimento   */
                                                                            INPUT ref-estrut.cod-ref-it,                   /*  referencia   */
                                                                            INPUT ?,                    /*  data inicio   */
                                                                            INPUT i-nr-linha,           /*  linha de produ‡Æo   */      
                                                                            INPUT l-gera-lista,                 /*  gera lista ou principal   */    
                                                                            INPUT c-cod-unid-negoc,           /*  unidade de negocio   */              
                                                                            INPUT-OUTPUT TABLE tt-proces-item).
                       end.
               end.
           end.   
           else do:
                 RUN generateProcessList IN h-enapi607 (INPUT b-estrutura.it-codigo,  /*  item pai   */
                                                        INPUT ?,                    /*  quantidade   */
                                                        INPUT c-cod-estabel,              /*  estabelecimento   */
                                                        INPUT c-refer,                   /*  referencia   */
                                                        INPUT ?,                    /*  data inicio   */
                                                        INPUT i-nr-linha,           /*  linha de produ‡Æo   */      
                                                        INPUT l-gera-lista,                 /*  gera lista ou principal   */    
                                                        INPUT c-cod-unid-negoc,           /*  unidade de negocio   */              
                                                        INPUT-OUTPUT TABLE tt-proces-item).
    
           END.
           RUN getDados IN h-enapi607 (output table tt-proces-item).
           RUN deleteDados IN h-enapi607.
           
           FOR FIRST tt-proces-item
               WHERE tt-proces-item.it-codigo = b-estrutura.it-codigo
                 AND tt-proces-item.cod-lista-compon = b-estrutura.cod-lista-compon NO-LOCK:
           END.

           IF NOT AVAIL tt-proces-item THEN
               NEXT carga-estrutura.

               
       END.

       /*** Quanto do item pai pode ser feito com a quantidade parametrizada do item filho ***/

       &IF DEFINED (bf_man_sfc_lc) &THEN
       /* D_MAN002 - Quantidade fixa para componentes de engenharia */
       assign de-quant-usada  = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                else p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item *
                                     (b-estrutura.proporcao / 100)
              de-quant-gerada = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                else p-quantidade * b-estrutura.qtd-compon / b-estrutura.qtd-item *
                                     (b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).
       &ELSE
       assign de-quant-usada  = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                else p-quantidade * b-estrutura.quant-usada *
                                     (b-estrutura.proporcao / 100)
              de-quant-gerada = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                else p-quantidade * b-estrutura.quant-usada *
                                     (b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).       
       &ENDIF

       if /*b2-item.tipo-con-est  = 4 or */
          b1-item.tipo-con-est = 4 then do:
           /*ALterado devido a Fo. 1369.266*/
           IF NOT CAN-FIND(FIRST b-ref-estrut WHERE b-ref-estrut.it-codigo = b-estrutura.it-codigo 
                                         AND b-ref-estrut.es-codigo = b-estrutura.es-codigo
                                         AND b-ref-estrut.sequencia = b-estrutura.sequencia) 
                OR p-refer = "" THEN DO:
                run pi-gera-estrutura(buffer b2-item, 
                                      buffer b-estrutura, 
                                      p-nivel,
                                      p-pai).
                /*assign tt-estrutura.refer = c-refer.*/

            END.
            ELSE DO:
               for each  b-ref-estrut fields (it-codigo   es-codigo   cod-ref-es
                                              sequencia   cod-ref-it)
                   where b-ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                         b-ref-estrut.es-codigo  = b-estrutura.es-codigo and
                         b-ref-estrut.cod-ref-es = p-refer               AND
                         b-ref-estrut.sequencia  = b-estrutura.sequencia no-lock:
                    assign c-refer-it = b-ref-estrut.cod-ref-it.
                    run pi-gera-estrutura(buffer b2-item, 
                                          buffer b-estrutura, 
                                          p-nivel,
                                          p-pai).
               end.          
            END.

       end.
       else do:
             assign c-refer-it = "".
             run pi-gera-estrutura(buffer b2-item, 
                                   buffer b-estrutura, 
                                   p-nivel,
                                   p-pai).
       end.
   end.
end.   


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

