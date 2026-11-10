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
{include/i-prgvrs.i V04IN223 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN223 MUT}
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
def var l-inclui        as logical no-undo.
def var i-pedido        as integer no-undo.
def var i-ordem         as integer no-undo.
def var de-lim-inferior as decimal no-undo.
def var de-lim-superior as decimal no-undo.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 
 
/* ********************  Preprocessor Definitions  ******************** */
 
&Scoped-define PROCEDURE-TYPE SmartViewer
 
&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target
 
/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main
 
/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-pend
&Scoped-define FIRST-EXTERNAL-TABLE movto-pend
 
 
/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-pend.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-pend.quantidade movto-pend.un ~
movto-pend.vl-mat-agreg[1] movto-pend.desconto-agreg ~
movto-pend.valor-mob[1] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}~
 ~{&FP1}vl-mat-agreg[1] ~{&FP2}vl-mat-agreg[1] ~{&FP3}~
 ~{&FP1}desconto-agreg ~{&FP2}desconto-agreg ~{&FP3}~
 ~{&FP1}valor-mob[1] ~{&FP2}valor-mob[1] ~{&FP3}
&Scoped-define ENABLED-TABLES movto-pend
&Scoped-define FIRST-ENABLED-TABLE movto-pend
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS movto-pend.num-pedido ~
movto-pend.numero-ordem movto-pend.it-codigo movto-pend.parcela ~
movto-pend.quantidade movto-pend.un movto-pend.vl-mat-agreg[1] ~
movto-pend.desconto-agreg movto-pend.valor-mob[1] 
&Scoped-Define DISPLAYED-OBJECTS fi-descricao de-unit-mat de-perc-mat ~
de-perc-mob 
 
/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS movto-pend.num-pedido ~
movto-pend.numero-ordem movto-pend.parcela 
 
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
DEFINE VARIABLE de-perc-mat AS DECIMAL FORMAT ">>9.99999":U INITIAL 0 
     LABEL "Fill 2" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.
 
DEFINE VARIABLE de-perc-mob AS DECIMAL FORMAT ">>9.99999":U INITIAL 0 
     LABEL "Fill 3" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.
 
DEFINE VARIABLE de-unit-mat AS DECIMAL FORMAT ">>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Fill 1" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.
 
DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.57 BY .88 NO-UNDO.
 
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.72 BY 12.75.
 
 
/* ************************  Frame Definitions  *********************** */
 
DEFINE FRAME f-main
     movto-pend.num-pedido AT ROW 1.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     movto-pend.numero-ordem AT ROW 2.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     fi-descricao AT ROW 3.46 COL 49 COLON-ALIGNED NO-LABEL
     movto-pend.it-codigo AT ROW 3.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     movto-pend.parcela AT ROW 4.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     movto-pend.quantidade AT ROW 5.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     movto-pend.un AT ROW 6.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     de-unit-mat AT ROW 7.5 COL 31.14 COLON-ALIGNED
     de-perc-mat AT ROW 8.5 COL 31.14 COLON-ALIGNED
     de-perc-mob AT ROW 9.5 COL 31.14 COLON-ALIGNED
     movto-pend.vl-mat-agreg[1] AT ROW 10.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.desconto-agreg AT ROW 11.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     movto-pend.valor-mob[1] AT ROW 12.5 COL 31.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .
 
 
/* *********************** Procedure Settings ************************ */
 
&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-pend
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
         HEIGHT             = 13.21
         WIDTH              = 85.43.
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
 
/* SETTINGS FOR FILL-IN de-perc-mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-unit-mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.num-pedido IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN movto-pend.numero-ordem IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN movto-pend.parcela IN FRAME f-main
   NO-ENABLE 1                                                          */
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
 
&Scoped-define SELF-NAME de-perc-mat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-perc-mat V-table-Win
ON LEAVE OF de-perc-mat IN FRAME f-main /* Fill 2 */
DO:
    assign input frame {&frame-name} de-unit-mat
           input frame {&frame-name} de-perc-mat.
    display ( round(de-unit-mat * input frame {&frame-name} movto-pend.quantidade,2)
              * de-perc-mat / 100 ) 
            @ movto-pend.vl-mat-agreg[1] with frame {&frame-name}.
END.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&Scoped-define SELF-NAME de-perc-mob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-perc-mob V-table-Win
ON LEAVE OF de-perc-mob IN FRAME f-main /* Fill 3 */
DO:
    assign input frame {&frame-name} de-unit-mat
           input frame {&frame-name} de-perc-mob.
    display ( round(de-unit-mat * input frame {&frame-name} movto-pend.quantidade,2)
            * de-perc-mob / 100 ) @ movto-pend.valor-mob[1] with frame {&frame-name}.
END.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&Scoped-define SELF-NAME movto-pend.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.it-codigo V-table-Win
ON F5 OF movto-pend.it-codigo IN FRAME f-main /* Item */
OR  MOUSE-SELECT-DBLCLICK OF movto-pend.it-codigo IN FRAME {&FRAME-NAME} DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                       &campo=movto-pend.it-codigo
                       &campozoom=it-codigo}
END.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.it-codigo V-table-Win
ON LEAVE OF movto-pend.it-codigo IN FRAME f-main /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-descricao
                     &where="item.it-codigo = input frame {&frame-name}
                             movto-pend.it-codigo"}
END.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&Scoped-define SELF-NAME movto-pend.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.numero-ordem V-table-Win
ON LEAVE OF movto-pend.numero-ordem IN FRAME f-main /* Ordem */
DO:
    assign i-ordem = input frame {&frame-name} movto-pend.numero-ordem.
    find ordem-compra where ordem-compra.numero-ordem = i-ordem no-lock no-error.
    if  avail ordem-compra then do with frame {&frame-name}:
        find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
        display item.it-codigo @ movto-pend.it-codigo
                item.desc-item @ fi-descricao
                ordem-compra.preco-unit @ de-unit-mat. 
    end.
END.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&Scoped-define SELF-NAME movto-pend.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.parcela V-table-Win
ON LEAVE OF movto-pend.parcela IN FRAME f-main /* Parcela */
DO:
    find prazo-compra where 
         prazo-compra.numero-ordem = input frame {&frame-name} 
           movto-pend.numero-ordem and
         prazo-compra.parcela = input frame {&frame-name} movto-pend.parcela 
         no-lock no-error.
    assign movto-pend.quantidade:screen-value in frame {&frame-name} =
        if avail prazo-compra then string(prazo-compra.quant-saldo) else "0"
           movto-pend.un:screen-value in frame {&frame-name} = 
        if avail prazo-compra then string(prazo-compra.quant-saldo) else "".
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
 
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.
  find first param-global no-lock no-error.
  find first param-estoq no-lock no-error.
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.
 
  {utp/ut-field.i mgind item-doc-est preco-unit 1}
  assign de-unit-mat:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind movto-pend valor-mat 1}
  assign de-perc-mat:label in frame {&frame-name} = "% " + return-value.  
  {utp/ut-field.i mgind movto-pend valor-mob 1}
  assign de-perc-mob:label in frame {&frame-name} = "% " + return-value.
  if  param-re.preco-unit then 
      enable de-unit-mat
             de-perc-mat
             de-perc-mob
             with frame {&frame-name}.
 
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
  {src/adm/template/row-list.i "movto-pend"}
 
  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}
 
  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-pend"}
 
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
  assign l-inclui = yes.
 
END PROCEDURE.
 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
 
 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  def buffer b-movto-pend for movto-pend.
 
  def var de-preco-total as decimal no-undo.
 
  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
 
  assign i-pedido = input frame {&frame-name} movto-pend.num-pedido
         i-ordem  = input frame {&frame-name} movto-pend.numero-ordem.
  find pedido-compr where pedido-compr.num-pedido = i-pedido no-lock no-error.
  if  not avail pedido-compr then do:
      {utp/ut-table.i mgind pedido-compr 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  pedido-compr.situacao = 3 then do:
      run utp/ut-msgs.p (input "show":U, input 1813, input "").
      apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.     
  if  pedido-compr.natureza <> 3 then do:
      run utp/ut-msgs.p (input "show":U, input 6412, input "").
      apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  pedido-compr.cod-emitente <> docum-est.cod-emitente then do:
      run utp/ut-msgs.p (input "show":U, input 5696, input "").
      if  return-value = "no" then do:
          apply "entry" to movto-pend.num-pedido in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.    
  end.
  find ordem-compra no-lock where 
       ordem-compra.numero-ordem = i-ordem no-error.
  if  not available ordem-compra then do:
      {utp/ut-table.i mgind ordem-compra 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  ordem-compra.num-pedido <> pedido-compr.num-pedido then do:
      run utp/ut-msgs.p (input "show":U, input 5701, input "").
      apply "entry" to movto-pend.numero-ordem in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.     
  find first prazo-compra 
       where prazo-compra.numero-ordem = ordem-compra.numero-ordem
         and prazo-compra.parcela      = input frame {&frame-name}
             movto-pend.parcela no-lock no-error.
  if  not avail prazo-compra then do:
      {utp/ut-table.i mgind prazo-compra 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to movto-pend.parcela in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.       
  if  prazo-compra.situacao <> 2 then do:
      run utp/ut-msgs.p (input "show":U, input 6359, input "").
      apply "entry" to movto-pend.parcela in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  input frame {&frame-name} movto-pend.quantidade = 0 then do:
      run utp/ut-msgs.p (input "show":U, input 2920, input "").
      apply "entry" to movto-pend.quantidade in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.  
  find item where item.it-codigo = input frame {&frame-name} movto-pend.it-codigo
       no-lock no-error.
  find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
  assign de-lim-inferior = prazo-compra.quantidade * familia.var-qtd-perm / 100
         de-lim-superior = prazo-compra.quant-saldo + de-lim-inferior
         de-lim-inferior = prazo-compra.quant-saldo - de-lim-inferior.
  if  input frame {&frame-name} movto-pend.quantidade > de-lim-inferior then do:
      run utp/ut-msgs.p (input "show":U, input 5517, input "").
      if  param-re.aceita-var then do:
          {utp/ut-liter.i Quantidade MRE R}      
          run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
          if  return-value = "no" then do:
              apply "entry" to movto-pend.quantidade in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.    
      end.
      run rep/re9997.p (input v-row-parent,
                        input (de-lim-inferior + de-lim-superior) / 2,
                        input input frame {&frame-name} movto-pend.quantidade,
                        input 5517, input no).  
  end.
  else 
      run rep/re9997.p (input v-row-parent,
                        input (de-lim-inferior + de-lim-superior) / 2,
                        input input frame {&frame-name} movto-pend.quantidade,
                        input 5517, input yes).  
  if  input frame {&frame-name} movto-pend.un <> item.un 
  and item.tipo-contr <> 4 then do:
      run utp/ut-msgs.p (input "show":U, input 1225, input "").
      apply "entry" to movto-pend.quantidade in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  assign de-preco-total = ordem-compra.preco-unit *
                          (input frame {&frame-name} movto-pend.quantidade +
                   integer(input frame {&frame-name} movto-pend.quantidade = 0) ).
  if  ordem-compra.mo-codigo <> 0 then
      run cdp/cd0812.p (input ordem-compra.mo-codigo, input 0, input de-preco-total,
                        input docum-est.dt-emissao, output de-preco-total).
  assign de-preco-total  = de-preco-total /
                           (ordem-compra.aliquota-ipi / 100 + 1)
         de-lim-inferior = de-preco-total * familia.var-pre-perm / 100
         de-lim-superior = de-preco-total + de-lim-inferior
         de-lim-inferior = de-preco-total - de-lim-inferior.
  if  input frame {&frame-name} movto-pend.vl-mat-agreg[1] -
     (input frame {&frame-name} movto-pend.vl-mat-agreg[1] *
      input frame {&frame-name} movto-pend.desconto-agreg / 100) <= 0 
  and input frame {&frame-name} movto-pend.valor-mob[1]    <= 0 then do:
      run utp/ut-msgs.p (input "show":U, input 3263, input "").
      apply "entry" to movto-pend.quantidade in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  assign de-preco-total = (input frame {&frame-name} movto-pend.vl-mat-agreg[1] -
                          (input frame {&frame-name} movto-pend.vl-mat-agreg[1] *
                           input frame {&frame-name} movto-pend.desconto-agreg
                           / 100)) +
                           input frame {&frame-name} movto-pend.valor-mob[1].
  if  de-preco-total > de-lim-inferior 
  or  de-preco-total < de-lim-superior then do:
      run utp/ut-msgs.p (input "show":U, input 5518, input "").
      if  param-re.aceita-var then do:
          {utp/ut-liter.i Pre‡o_Total MRE R}      
          run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
          if  return-value = "no" then do:
              apply "entry" to movto-pend.vl-mat-agreg[1] in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.    
      end.
      run rep/re9997.p (input v-row-parent,
                        input (de-lim-inferior + de-lim-superior) / 2,
                        input de-preco-total, input 5518, input no).  
  end.
  else 
      run rep/re9997.p (input v-row-parent,
                        input (de-lim-inferior + de-lim-superior) / 2,
                        input de-preco-total, input 5518, input yes).  
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  if  l-inclui then do:    /*  chave primaria e nao unica  */
      find first b-movto-pend no-lock
           where b-movto-pend.cod-emitente = docum-est.cod-emitente
             and b-movto-pend.nat-operacao = docum-est.nat-operacao
             and b-movto-pend.serie-docto  = docum-est.serie-docto
             and b-movto-pend.nro-docto    = docum-est.nro-docto
             and b-movto-pend.tipo         = 2 no-error.
      assign movto-pend.cod-emitente = docum-est.cod-emitente
             movto-pend.nat-operacao = docum-est.nat-operacao
             movto-pend.serie-docto  = docum-est.serie-docto
             movto-pend.nro-docto    = docum-est.nro-docto
             movto-pend.tipo         = 2
             movto-pend.sequencia    = if not avail b-movto-pend then 1
                                       else b-movto-pend.sequencia + 1.
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
  if  avail movto-pend then do:
      find item where item.it-codigo = movto-pend.it-codigo no-lock no-error.
      assign fi-descricao = if avail item then item.desc-item else "".
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
  {src/adm/template/snd-list.i "movto-pend"}
 
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
 
 
