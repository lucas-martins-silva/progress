&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
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
{include/i-prgvrs.i V07IN356 2.00.00.078 } /*** "010078" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07in356 MUT}
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

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}
{cnp/cnapi020.i} /* Integracao Contratos - declaracao temp-tables */
{cdp/cd0666.i} /* definiá∆o da tt-erro */

/* Multiplanta */
def var i-tipo-movto as int no-undo.
def var l-erro as logical no-undo.
def var c-msg  as char no-undo.
/* ----------- */

/* global variable definitions */
def new global shared var gr-ordem-compra as rowid no-undo.

/* Parameters Definitions ---                                           */

def buffer b-parcela for prazo-compra.
def buffer b-prazo   for prazo-compra.

/* Local Variable Definitions ---                                       */
/* def new global shared var v-row-parent as rowid no-undo. */
def var v-row-parent as rowid no-undo.

def new shared var c-cod-estabel like estabelec.cod-estabel.

def var de-qtd         as decimal   no-undo.
def var l-bt-ok        as logical   no-undo.
def var de-tot-parcela as decimal   no-undo.
def var c-mensagem     as character no-undo.
def var de-qtde        like prazo-compra.quantidade   no-undo. 
def var de-indice      as decimal   no-undo.
def var de-total-item  as decimal   no-undo.
def var de-total       as decimal   no-undo.
def var de-do-forn     like prazo-compra.qtd-do-forn.
def var de-sal-forn    like prazo-compra.qtd-sal-forn.
def var de-rec-forn    like prazo-compra.qtd-rec-forn.
def var l-erro-co      as logical   no-undo.
def var l-msg-tela     as logical   no-undo. 
DEF VAR l-integra-paradigma AS LOG NO-UNDO INITIAL NO.

def var de-quant-saldo like prazo-compra.quant-saldo no-undo.
def var de-quant-saldo-ant  like prazo-compra.quant-saldo no-undo.
def var dt-data-entr-aux like prazo-compra.data-entrega no-undo.
def var de-qt-solic-aux  like ordem-compra.qt-solic no-undo.

/* Integraá∆o CNP X INP */
{cdp/cd9731.i}
{cdp/cd9730.i "new"}

/***PTI-Status***/
&if defined (bf_mat_bloqueio_fornec) &then
    def var h-api029       as handle no-undo.
    def var i-situacao     as int    no-undo.  
    def var dt-vig-ini     as date   no-undo.  
    def var dt-vig-fim     as date   no-undo.  
    def var c-return       as char   no-undo.

    def temp-table tt-erro-2 no-undo
        field i-sequen as int             
        field cd-erro  as int
        field mensagem as char format "x(255)"
        field c-param  as char.

&endif

/* Re-planejamento MRP */
&if defined(bf_mat_importacao_mrp) &then
    def var h-bocx150 as handle  no-undo.
    def var l-acomp   as logical no-undo.
&endif

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
&Scoped-define EXTERNAL-TABLES prazo-compra
&Scoped-define FIRST-EXTERNAL-TABLE prazo-compra


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR prazo-compra.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS prazo-compra.un prazo-compra.data-entrega ~
prazo-compra.quant-saldo 
&Scoped-define ENABLED-TABLES prazo-compra
&Scoped-define FIRST-ENABLED-TABLE prazo-compra
&Scoped-Define ENABLED-OBJECTS rt-mold de-quantidade 
&Scoped-Define DISPLAYED-FIELDS prazo-compra.parcela prazo-compra.un ~
prazo-compra.data-entrega prazo-compra.quant-saldo 
&Scoped-define DISPLAYED-TABLES prazo-compra
&Scoped-define FIRST-DISPLAYED-TABLE prazo-compra
&Scoped-Define DISPLAYED-OBJECTS cb-situacao de-quantidade 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS prazo-compra.parcela 
&Scoped-define ADM-ASSIGN-FIELDS prazo-compra.parcela cb-situacao ~
de-quantidade prazo-compra.un prazo-compra.data-entrega ~
prazo-compra.quant-saldo 
&Scoped-define ADM-MODIFY-FIELDS prazo-compra.un prazo-compra.data-entrega 

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
DEFINE VARIABLE cb-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Combo 1" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE de-quantidade AS DECIMAL FORMAT ">,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57 BY 7.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     prazo-compra.parcela AT ROW 1.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     cb-situacao AT ROW 2.75 COL 22 COLON-ALIGNED
     de-quantidade AT ROW 3.75 COL 22 COLON-ALIGNED
     prazo-compra.un AT ROW 4.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     prazo-compra.data-entrega AT ROW 5.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     prazo-compra.quant-saldo AT ROW 6.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.prazo-compra
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
         HEIGHT             = 7.42
         WIDTH              = 57.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 7.42
       FRAME f-main:WIDTH            = 57.

/* SETTINGS FOR COMBO-BOX cb-situacao IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN prazo-compra.data-entrega IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN de-quantidade IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN prazo-compra.parcela IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN prazo-compra.quant-saldo IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN prazo-compra.un IN FRAME f-main
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

&Scoped-define SELF-NAME de-quantidade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-quantidade V-table-Win
ON LEAVE OF de-quantidade IN FRAME f-main
DO:
  assign prazo-compra.quant-saldo:screen-value = input frame {&frame-name} de-quantidade.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prazo-compra.parcela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prazo-compra.parcela V-table-Win
ON LEAVE OF prazo-compra.parcela IN FRAME f-main /* Parcela */
DO:
   &if defined(bf_dis_default_UN) &then      

      find param-mat no-lock no-error.
      if avail param-mat
           and param-mat.ind-sit-un = 2 then do:

          {include/leave.i &tabela=item
                           &atributo-ref=un
                           &variavel-ref=prazo-compra.un
                           &where="item.it-codigo = ordem-compra.it-codigo"}
      end.
  &endif   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME prazo-compra.quant-saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prazo-compra.quant-saldo V-table-Win
ON ENTRY OF prazo-compra.quant-saldo IN FRAME f-main /* Qtde Saldo */
DO:

assign de-quant-saldo-ant = input frame {&frame-name} prazo-compra.quant-saldo.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL prazo-compra.quant-saldo V-table-Win
ON LEAVE OF prazo-compra.quant-saldo IN FRAME f-main /* Qtde Saldo */
DO:

if de-quant-saldo-ant <> input frame {&frame-name} prazo-compra.quant-saldo then do:
    assign de-quant-saldo = prazo-compra.quant-saldo
           de-quantidade  = prazo-compra.quantidade.
    /***** N∆o altera quantidade na modificaá∆o
    assign de-quant-saldo = de-quantidade - (prazo-compra.quant-saldo - 
                            input frame {&frame-name} prazo-compra.quant-saldo) no-error.
    if  not error-status:error then 
        assign de-quantidade = de-quantidade - (prazo-compra.quant-saldo - 
                               input frame {&frame-name} prazo-compra.quant-saldo).
    disp de-quantidade with frame {&frame-name}.
    *****/
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

{utp/ut-field.i mgind prazo-compra situacao 1}
assign cb-situacao:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind prazo-compra quantidade 1}
assign de-quantidade:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "prazo-compra"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "prazo-compra"}

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

  find ordem-compra where rowid(ordem-compra) = v-row-parent no-lock no-error.

  /* calcula a quantidade da parcela */
  assign de-total-item = 0.
  for each b-parcela
     where b-parcela.numero-ordem = ordem-compra.numero-ordem 
       and b-parcela.it-codigo    = ordem-compra.it-codigo 
       no-lock:
     assign de-total-item = de-total-item + b-parcela.quantidade.
  end.

  if  avail ordem-compra
  and ordem-compra.qt-solic - de-total-item > 0 then do with frame {&frame-name}: 
      disp (ordem-compra.qt-solic - de-total-item) @ de-quantidade.
  end.

  /* calcula a pr¢xima parcela */

  /*********
  find ordem-compra where rowid(ordem-compra) = gr-ordem-compra no-lock no-error.
  **********/

  find last b-parcela 
      where b-parcela.numero-ordem = ordem-compra.numero-ordem 
        and b-parcela.it-codigo    = ordem-compra.it-codigo no-lock no-error.

  if  avail b-parcela 
  and b-parcela.parcela <> 99999 then
      assign prazo-compra.parcela:screen-value = string(b-parcela.parcela + 1).
  else  
      assign prazo-compra.parcela:screen-value = "1".

  assign prazo-compra.data-entrega:screen-value = string(today)
         cb-situacao:screen-value = {ininc/i02in274.i 04 2}.

/***** Comentado em 25/02  
  find first contrato-for 
      where contrato-for.nr-contrato = ordem-compra.nr-contrato
      no-lock no-error.
  if  avail contrato-for then do:
      find first item-contrat 
         where item-contrat.nr-contrato  = contrato-for.nr-contrato 
           and item-contrat.it-codigo    = ordem-compra.it-codigo 
           and item-contrat.num-seq-item = ordem-compra.num-seq-item 
         no-lock no-error.

      if  avail item-contrat then do:
          if  item-contrat.ind-tipo-control = 3 then
              assign cb-situacao:screen-value = {ininc/i02in274.i 04 2}.
      end.
  end.
*****/

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var de-quant-saldo like prazo-compra.quant-saldo no-undo.


/* Integracao Contratos - limpa registros temp-table integraá∆o */
{cnp/cnapi020.i4}

for each tt-erro:
    delete tt-erro.
end.

if  not avail param-global then
    find first param-global no-lock no-error.

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

find ordem-compra where rowid(ordem-compra) = v-row-parent no-lock no-error.
if avail ordem-compra and
   not avail contrato-for then
   find contrato-for where 
        contrato-for.nr-contrato = ordem-compra.nr-contrato no-lock no-error.
IF NOT avail ordem-compra THEN
    find ordem-compra where rowid(ordem-compra) = v-row-parent no-lock no-error.
&if defined(bf_mat_contratos) &then
if  param-global.modulo-mp and 
    avail ordem-compra     and
    avail contrato-for     and
    contrato-for.cod-estab-gestor <> ""
    then do:
    run ccp/ccapi199.p (input "Ordem-contrato", input rowid(ordem-compra),output l-erro).
    if  l-erro then do:
        /*Ordem somente pode ser alterado no estabelecimento Executor.*/
        {utp/ut-liter.i Ordem}
        assign c-msg = trim(return-value).
        {utp/ut-liter.i Executor}
        run utp/ut-msgs.p("show",18200,c-msg + "~~" + trim(return-value)).
        return "adm-error".
    end.
end.
&endif

if  adm-new-record then
do with frame {&frame-name}:
    if  de-quantidade:sensitive then 
        assign prazo-compra.quant-saldo:screen-value = input de-quantidade.
end.

 find ordem-compra where rowid(ordem-compra) = v-row-parent no-lock no-error.
 find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
 find item-contrat where item-contrat.nr-contrato = ordem-compra.nr-contrato
                    and item-contrat.it-codigo    = ordem-compra.it-codigo 
                    and item-contrat.num-seq-item = ordem-compra.num-seq-item
                    no-lock no-error.

 if contrato-for.ind-sit-contrat <> 2 or item-contrat.ind-sit-item <> 2 THEN DO:
    run utp/ut-msgs.p (input "show", input 28329, input "").
    return "adm-error".
 END.


 assign de-qtde = input frame {&frame-name} de-quantidade.

 {utp/ut-table.i mgind prazo-compra 1}  
 assign c-mensagem = return-value.
 if  adm-new-record then do:
     find first b-parcela 
         where b-parcela.numero-ordem = ordem-compra.numero-ordem 
           and b-parcela.parcela = input frame {&frame-name} prazo-compra.parcela
         no-lock no-error.
     if  avail b-parcela then do:
         run utp/ut-msgs.p (input "show", input 7, input c-mensagem).
         apply "entry" to prazo-compra.parcela in frame {&frame-name}.
         return "adm-error".          
     end.
 end.

 if  item.fraciona = no and de-qtde - integer(de-qtde) > 0 then do:
    run utp/ut-msgs.p (input "show", input 847, input "").
    apply "entry" to de-quantidade in frame {&frame-name}.
    return "adm-error". 
 end.
 
 if  input frame {&frame-name} de-quantidade <> 0
   and item.lote-multipl <> 0 
   and ((integer(de-qtde / item.lote-multipl)) * item.lote-multipl) <> 
   de-qtde then do:
      run utp/ut-msgs.p (input "show", input 6265, input string(item.lote-multipl)).
      if  return-value = "no" then do:
          apply "entry" to de-quantidade in frame {&frame-name}.
          return "adm-error". 
      end.
 end.
 
 if  input frame {&frame-name} de-quantidade <> 0
   and item.lote-minimo > 0 
   and input frame {&frame-name} de-quantidade < item.lote-minimo
   then do:
      run utp/ut-msgs.p (input "show", input 1558, input string(input frame {&frame-name} de-quantidade) + "~~" + string(item.lote-minimo)).
      if  return-value = "no" then do:
          apply "entry" to de-quantidade in frame {&frame-name}.
          return "adm-error".
      end.
  end.

 /* Quantidade Saldo n∆o pode ser inferior a quantidade 
     alocada no recebimento. */
 if  not adm-new-record and
     avail prazo-compra and
      input frame {&frame-name} prazo-compra.quant-saldo < prazo-compra.dec-1 
      then do with frame {&frame-name}:
      run utp/ut-msgs.p ("show",17945,"").
      apply "entry" to prazo-compra.quant-saldo.
      return 'adm-error':U.
 end.

 assign de-indice = 1.
 find item-fornec 
      where ordem-compra.it-codigo    = item-fornec.it-codigo 
      and   ordem-compra.cod-emitente = item-fornec.cod-emitente no-lock no-error.
   if not avail item-fornec then do:
       if  ordem-compra.it-codigo = ?
       or ordem-compra.it-codigo = ""
       or item.tipo-contr = 4 then do:
         find tab-unidade where 
               tab-unidade.un = input frame {&frame-name} prazo-compra.un
               no-lock no-error.  
          if  not available tab-unidade then do:
              run utp/ut-msgs.p (input "show", input 846, input "").
              return "adm-error". 
          end.
          find first b-prazo 
               where b-prazo.numero-ordem = ordem-compra.numero-ordem
               no-lock no-error.
          if  available b-prazo then do:
              if  input frame {&frame-name} prazo-compra.un <> b-prazo.un and ordem-compra.it-codigo <> "" and item.tipo-contr <> 4 then do:
                  run utp/ut-msgs.p (input "show", input 3995, input "").
                  return "adm-error". 
              end.
          end.
       end.
       else do:
           if  input frame {&frame-name} prazo-compra.un <> item.un then do:
               run utp/ut-msgs.p (input "show", input 3359, input "").
               return "adm-error". 
           end.
       end. 
    end.
    else do:
      if input frame {&frame-name} prazo-compra.un <> item.un then do:
         run utp/ut-msgs.p (input "show", input 3359, input "").
         return "adm-error". 
      end.
    end.

  /* Integraá∆o CNP X INP */
  if l-integra-cn-in and ordem-compra.num-ord-inv <> 0 and
     not adm-new-record then do:
     &if defined(bf_mat_controle_verba) &then
         run inp/inapi358.p (input rowid(prazo-compra), no).
     &endif
  end.   


 if avail item-contrat then
 run cnp/cnapi001.p (input ordem-compra.it-codigo,
                     input ordem-compra.cod-emitente,
                     input input frame {&frame-name} prazo-compra.un,
                     input item-contrat.un,
                     output de-indice).      

 if  input frame {&frame-name} prazo-compra.data-entrega < ordem-compra.data-emissao then do:
     {utp/ut-table.i mgind prazo-compra 1}
     assign c-mensagem = c-mensagem + "~~" + return-value.
     run utp/ut-msgs.p (input "show", input 322, input c-mensagem).
     apply "entry" to prazo-compra.data-entrega in frame {&frame-name}.
     return "adm-error".          
 end.  


 if avail contrato-for then do:     
     if  input frame {&frame-name} prazo-compra.data-entrega < contrato-for.dt-ini-validade or
         input frame {&frame-name} prazo-compra.data-entrega > contrato-for.dt-ter-validade then do:
         {utp/ut-table.i mgind prazo-compra 1}
         run utp/ut-msgs.p (input "show", input 17538, input "").
         apply "entry" to prazo-compra.data-entrega in frame {&frame-name}.
         return "adm-error".          
     end.
     if can-find (last b-parcela where
                       b-parcela.numero-ordem = ordem-compra.numero-ordem and 
                       b-parcela.situacao <> 4 and
                       b-parcela.situacao     <> 6 and
                       b-parcela.parcela < input frame {&frame-name} prazo-compra.parcela and
                       b-parcela.data-entrega > input frame {&FRAME-NAME} prazo-compra.data-entrega) then do:
         {utp/ut-table.i mgind prazo-compra 1}
         run utp/ut-msgs.p (input "show", input 5797, input "").
         /*apply "entry" to prazo-compra.data-entrega in frame {&frame-name}.
         return "adm-error".*/
     end.
     if can-find (first b-parcela where
                        b-parcela.numero-ordem = ordem-compra.numero-ordem and
                        b-parcela.situacao <> 4 and
                        b-parcela.parcela > input frame {&frame-name} prazo-compra.parcela and
                        b-parcela.data-entrega < input frame {&frame-name} prazo-compra.data-entrega) then do:
       {utp/ut-table.i mgind prazo-compra 1}
       run utp/ut-msgs.p (input "show", input 3996, input "").
       /*apply "entry" to prazo-compra.data-entrega in frame {&frame-name}.
       return "adm-error".*/  
    end. 
 end.   

 if adm-new-record and
    input frame {&frame-name} prazo-compra.parcela = 1 then do:

    find b-parcela where b-parcela.numero-ordem = ordem-compra.numero-ordem 
                     and b-parcela.parcela = 1 exclusive-lock no-error.
    if avail b-parcela then delete b-parcela.
 end.

 if not adm-new-record then  
    assign de-do-forn       = prazo-compra.qtd-do-forn
           de-sal-forn      = prazo-compra.qtd-sal-forn
           de-rec-forn      = prazo-compra.qtd-rec-forn
          &if "{&bf_mat_versao_ems}" >= "2.062" &then
           dt-data-entr-aux = prazo-compra.data-entrega
           de-qt-solic-aux  = ordem-compra.qt-solic
          &endif
           .
           

IF NOT adm-new-record THEN DO:
    /****In°cio validaá∆o fornecedor, PTI-Status***/

    &IF DEFINED(bf_mat_bloqueio_fornec) &THEN

        if prazo-compra.parcela:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
            prazo-compra.parcela        <> input frame {&frame-name} prazo-compra.parcela
        OR (de-quantidade:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
            de-quantidade <> INPUT FRAME {&FRAME-NAME} de-quantidade)
        OR (prazo-compra.quant-saldo:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
            prazo-compra.quant-saldo               <> input frame {&frame-name} prazo-compra.quant-saldo AND
            INPUT FRAME {&FRAME-NAME} prazo-compra.quant-saldo = 0)
        or (prazo-compra.un:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
            prazo-compra.un             <> input frame {&frame-name} prazo-compra.un )
        OR (prazo-compra.data-entrega:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
            prazo-compra.data-entrega   <> input frame {&frame-name} prazo-compra.data-entrega )
        OR (cb-situacao:SENSITIVE IN FRAME {&FRAME-NAME} = YES AND
            cb-situacao                 <> input frame {&frame-name} cb-situacao AND
              INPUT FRAME {&frame-name} cb-situacao <> "recebida"  ) THEN                          
    
            IF AVAIL contrato-for THEN DO:
                run cdp/cdapi029.p (input contrato-for.cod-comprado,
                                    input 1,
                                    input today,
                                    input contrato-for.cod-emitente,
                                    output i-situacao,
                                    output dt-vig-ini,
                                    output dt-vig-fim,
                                    output table tt-erro-2).
                assign c-return = return-value.

                if can-find (first tt-erro-2) then
                   run cdp/cd0669.w (table tt-erro-2).

                if c-return = "NOK":u then
                      return 'ADM-ERROR':U.

            END.

    &ENDIF

    /****FIM validaá∆o fornecedor, PTI-Status******/
    /* Integracao Contratos - criar registro para integraá∆o */
    {cnp/cnapi020.i1 1 2 "CN0304" " " "prazo-compra" prazo-compra}

    IF  cb-situacao <> input frame {&frame-name} cb-situacao
    AND cb-situacao =  "Recebida" THEN 
        ASSIGN de-sal-forn = 0.
END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then RETURN 'ADM-ERROR':U.


FIND CURRENT ordem-compra EXCLUSIVE-LOCK NO-ERROR.

if  adm-new-record then do:
   assign ordem-compra.qt-solic = ordem-compra.qt-solic - prazo-compra.quantidade
          prazo-compra.quantidade = input frame {&frame-name} de-quantidade
          ordem-compra.qt-solic = ordem-compra.qt-solic + prazo-compra.quantidade
          c-cod-estabel = ordem-compra.cod-estabel
          cb-situacao = input frame {&frame-name} cb-situacao
          prazo-compra.situacao = {ininc/i02in274.i 06 cb-situacao}
          prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
          prazo-compra.qtd-sal-forn = prazo-compra.quant-saldo * de-indice.
   
   &if "{&bf_mat_versao_ems}" >= "2.062" &then
   RUN cnp/cn9176.p (INPUT ordem-compra.num-pedido,
                     INPUT ordem-compra.numero-ordem,
                     INPUT prazo-compra.parcela, 
                     INPUT 1, /*Inclusao*/
                     INPUT ?, /*Preco Anterior*/
                     INPUT ?, /*Preco Atual*/
                     INPUT ?, /*Qtde Anterior*/
                     INPUT ?, /*Qtde Atual*/
                     INPUT ?, /*Data Anterior*/
                     INPUT ?, /*Data Atual*/
                     INPUT "":U /*Dados Auxiliares*/). 
   /*
   {inp/in0000.i INT(prazo-compra.parcela)
                 Incluso_parcela_n£mero
                 STRING(prazo-compra.parcela)
                 ''}
   */              
   &endif
end.
else do:   
   assign ordem-compra.qt-solic = ordem-compra.qt-solic - prazo-compra.quantidade
          prazo-compra.quantidade = input frame {&frame-name} prazo-compra.quant-saldo
                                  + prazo-compra.quant-receb
                                  - prazo-compra.quant-rejeit
          ordem-compra.qt-solic = ordem-compra.qt-solic + prazo-compra.quantidade
          c-cod-estabel = ordem-compra.cod-estabel
          cb-situacao = input frame {&frame-name} cb-situacao
          prazo-compra.situacao = {ininc/i02in274.i 06 cb-situacao}
          prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
          prazo-compra.qtd-sal-forn = prazo-compra.quant-saldo * de-indice.
   
   &if "{&bf_mat_versao_ems}" >= "2.062" &then
    IF  dt-data-entr-aux <> prazo-compra.data-entrega OR 
        de-qt-solic-aux  <> ordem-compra.qt-solic     THEN DO:
        RUN cnp/cn9176.p (INPUT ordem-compra.num-pedido,
                          INPUT ordem-compra.numero-ordem,
                          INPUT prazo-compra.parcela, 
                          INPUT 2, /*Alteracao*/
                          INPUT ?, /*Preco Anterior*/
                          INPUT ?, /*Preco Atual*/
                          INPUT de-qt-solic-aux, /*Qtde Anterior*/
                          INPUT ordem-compra.qt-solic, /*Qtde Atual*/
                          INPUT dt-data-entr-aux, /*Data Anterior*/
                          INPUT prazo-compra.data-entrega, /*Data Atual*/
                          INPUT "":U /*Dados Auxiliares*/).
        /*
        {inp/in0000.i INT(prazo-compra.parcela)
                      Alteraá∆o_da_data_de_entrega_de
                      STRING(dt-data-entr-aux)
                      STRING(prazo-compra.data-entrega)}
        */              
    END.
    /*
    IF  de-qt-solic-aux <> ordem-compra.qt-solic THEN DO:
        {inp/in0000.i INT(prazo-compra.parcela)
                      Alteraá∆o_da_quantidade_de
                      STRING(de-qt-solic-aux,'>>>,>>>,>>9.9999':U)
                      STRING(ordem-compra.qt-solic,'>>>,>>>,>>9.9999':U)}
    END.
    */
   &endif
   
end.

FIND CURRENT prazo-compra NO-LOCK NO-ERROR.

IF l-integra-paradigma THEN DO:
    RUN ccp/ccapi342.p (INPUT  "prazo-compra":U,
                        INPUT  ROWID(prazo-compra),
                        OUTPUT TABLE RowErrors).
    if RETURN-VALUE = "NOK":U then
        return 'ADM-ERROR':U.
END.

if  avail item-contrat and
    item-contrat.ind-tipo-control = 3 OR
    item-contrat.ind-tipo-control = 2 then do:
    FIND FIRST b-prazo NO-LOCK
         WHERE b-prazo.numero-ordem = ordem-compra.numero-ordem NO-ERROR.

    if  can-find (first b-prazo 
                  where b-prazo.numero-ordem = ordem-compra.numero-ordem 
                    and b-prazo.situacao = 2) then
        assign ordem-compra.situacao = 2. /*Confirmada*/
    else
        if not can-find (first b-prazo 
                         where b-prazo.numero-ordem = ordem-compra.numero-ordem 
                           and b-prazo.situacao <> 6) then
            assign ordem-compra.situacao = 6. /*Recebida*/
end.
else 
if  avail item-contrat and
    item-contrat.ind-tipo-control = 1 and 
    ordem-compra.situacao = 6 then do:
    /* Qdo controle por medicao a ordem nao devera ser encerrada.*/
    assign ordem-compra.situacao = 2.
end.
if  not adm-new-record then do:
    IF item-contrat.ind-tipo-control <> 3 THEN DO: /* Nao atualiza situacao da ordem quando for contrato programacao */
        find first b-prazo 
             where b-prazo.numero-ordem = ordem-compra.numero-ordem 
               and b-prazo.situacao = 2 no-lock no-error.
        if available b-prazo then
            assign ordem-compra.situacao = 2.
        else do:
            find first b-prazo
               where b-prazo.numero-ordem = ordem-compra.numero-ordem
                 and b-prazo.situacao = 6 no-lock no-error.
            if available b-prazo then 
                assign ordem-compra.situacao = 6.
            else
                assign ordem-compra.situacao = 4.
        end.                           
    END.
    ELSE
        assign ordem-compra.situacao = 2. /* Quando Programacao, situacao sempre devera ser 2 */	
end.

if avail item-contrat then do:
    if item-contrat.ind-tipo-control = 3 then do:
       find emitente
            where emitente.cod-emitente = ordem-compra.cod-emitente
            no-lock no-error.
       if avail emitente and emitente.prog-emit = no then do:
          find emitente
               where emitente.cod-emitente = ordem-compra.cod-emitente
               exclusive-lock no-error.
               assign emitente.prog-emit = yes.
          find emitente
               where emitente.cod-emitente = ordem-compra.cod-emitente
               no-lock no-error.
       end.
    end.

    if adm-new-record then do:
       if  prazo-compra.situacao <> 6 then
       run cnp/cnapi003.p (input rowid(item-contrat),
                           input prazo-compra.qtd-do-forn,
                           input (prazo-compra.qtd-do-forn * ordem-compra.pre-unit-for),
                           input prazo-compra.qtd-sal-forn,
                           input (prazo-compra.qtd-sal-forn * ordem-compra.pre-unit-for),
                           input prazo-compra.qtd-rec-forn,
                           input (prazo-compra.qtd-rec-forn * ordem-compra.pre-unit-for), 
                           input c-cod-estabel,
                           output l-msg-tela,
                           output l-erro-co,
                           input-output table tt-erro).
       find first tt-erro no-lock no-error. 
          if avail tt-erro then 
          run cdp/cd0666.w (input table tt-erro).                    

       if l-erro-co then undo, return "adm-error".
    end.
    else do:

        if prazo-compra.situacao = 6 then
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (prazo-compra.qtd-do-forn - de-do-forn),
                            input ((prazo-compra.qtd-do-forn - de-do-forn) * ordem-compra.pre-unit-for),
                            input (de-sal-forn) * (-1),
                            input (de-sal-forn * ordem-compra.pre-unit-for) * (-1),
                            input (prazo-compra.qtd-rec-forn - de-rec-forn),
                            input ((prazo-compra.qtd-rec-forn - de-rec-forn) * ordem-compra.pre-unit-for), 
                            input c-cod-estabel,
                            output l-msg-tela,
                            output l-erro-co,
                            input-output table tt-erro). 
        else
        run cnp/cnapi003.p (input rowid(item-contrat),
                            input (prazo-compra.qtd-do-forn - de-do-forn),
                            input ((prazo-compra.qtd-do-forn - de-do-forn) * ordem-compra.pre-unit-for),
                            input (prazo-compra.qtd-sal-forn - de-sal-forn),
                            input ((prazo-compra.qtd-sal-forn - de-sal-forn) * ordem-compra.pre-unit-for),
                            input (prazo-compra.qtd-rec-forn - de-rec-forn),
                            input ((prazo-compra.qtd-rec-forn - de-rec-forn) * ordem-compra.pre-unit-for), 
                            input c-cod-estabel,
                            output l-msg-tela,
                            output l-erro-co,
                            input-output table tt-erro). 

        find first tt-erro no-lock no-error. 

           if avail tt-erro then 
           run cdp/cd0666.w (input table tt-erro).                    

        if l-erro-co then undo, return "adm-error".
    end.  
end.

&if defined(bf_mat_contratos) &then

if  param-global.modulo-mp then do:
    for each tt-erro:
        delete tt-erro.
    end.
    if  adm-new-record 
        then assign i-tipo-movto = 1. 
        else assign i-tipo-movto = 2.
    run ccp/ccapi200.p (input "parcela-contrato", input rowid(prazo-compra),
                        input i-tipo-movto, input-output table tt-erro).
    find first tt-erro no-lock no-error. 
    if  avail tt-erro then 
        run cdp/cd0666.w (input table tt-erro).
end.
&endif


/* Integraá∆o CNP X INP */
if l-integra-cn-in and ordem-compra.num-ord-inv <> 0 then do:
   if adm-new-record then do:
      run inp/in2110a.p (input rowid(prazo-compra), "I").    
   end.
   else do:
      run inp/in2110a.p (input rowid(prazo-compra), "M").
      run inp/in2110.p (input rowid(ordem-compra) , "M").
   end.   
   run inp/in2110b.p.
   if return-value = "NOK":U then
      undo, return "adm-error":U.
end.

/* Integracao Contratos - criar registro para integraá∆o */
if adm-new-record then do:
    {cnp/cnapi020.i1 2 1 "CN0304" " " "prazo-compra" prazo-compra}
end.
else do:
    {cnp/cnapi020.i1 2 2 "CN0304" " " "prazo-compra" prazo-compra}
end.


{cnp/cnapi020.i2 "ADM-ERROR" yes}

  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

    find ordem-compra no-lock where rowid(ordem-compra) = v-row-parent no-error.
    if available ordem-compra  then do:

        /* Re-planejamento das parcelas no MRP, conforme atividade 116178 */
        &if defined(bf_mat_importacao_mrp) &then

            if connected("mgcex") then do:
               if not valid-handle (h-bocx150) then 
                  run cxbo/bocx150.p persistent set h-bocx150.

                run buscaHistorico in h-bocx150 (input ordem-compra.num-pedido, output l-acomp).

                if l-acomp then
                   assign  prazo-compra.int-2 = 2.  /* Parcela fixada (n∆o ser† re-planejada) */
            end.
        &endif

        assign prazo-compra.numero-ordem = ordem-compra.numero-ordem
               prazo-compra.it-codigo    = ordem-compra.it-codigo
               prazo-compra.nr-contrato  = ordem-compra.nr-contrato.
    end.

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
  &if defined(bf_mat_importacao_mrp) &then
      if valid-handle (h-bocx150) then do:
         delete procedure h-bocx150 no-error.
         assign h-bocx150 = ?.
      end.
  &endif


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

  assign cb-situacao = {ininc/i02in274.i 04 02}.
  if  adm-new-record = no then do:
      if  avail prazo-compra and (prazo-compra.situacao = 2 or prazo-compra.situacao = 6) 
          then do with frame {&frame-name}:
          assign cb-situacao = {ininc/i02in274.i 04 prazo-compra.situacao}
                 de-quantidade = prazo-compra.quantidade.
      end.
      else
          assign cb-situacao = {ininc/i02in274.i 04 02}
                 de-quantidade = 0.
  end.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  DISP cb-situacao WITH FRAME {&FRAME-NAME}.

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

  assign cb-situacao:sensitive in frame {&frame-name} = not adm-new-record
         de-quantidade:sensitive in frame {&frame-name} = adm-new-record
         prazo-compra.quant-saldo:sensitive in frame {&frame-name} = not adm-new-record.

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

  if  not adm-new-record then do:
      if cb-situacao:add-last({ininc/i02in274.i 04 2}) in frame {&frame-name} then.
      if cb-situacao:add-last({ininc/i02in274.i 04 6}) in frame {&frame-name} then.
  end.     
  else DO:
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao001 = {ininc/i02in274.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
          ASSIGN  cb-situacao:LIST-ITEM-PAIRS in frame {&frame-name} = cAuxTraducao001.
      &else
          ASSIGN cb-situacao:list-items in frame {&frame-name} = {ininc/i02in274.i 03}.
      &endif
END.

    FIND FIRST funcao NO-LOCK
         WHERE funcao.cd-funcao = "spp-portal-paradigma":U
           AND funcao.ativo NO-ERROR.
    
    IF AVAIL funcao THEN DO:
    
        IF NOT AVAIL param-compra THEN
            FIND FIRST param-compra NO-LOCK NO-ERROR.
    
        IF &if "{&bf_mat_versao_ems}" < "2.09" &then
               SUBSTRING(param-compra.char-2,103,1) = "S":U
           &ELSE
               param-compra.log-portal-paradigma
           &ENDIF
        THEN DO:
            ASSIGN l-integra-paradigma = YES.
        END.
    END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-inclusao V-table-Win 
PROCEDURE pi-verifica-inclusao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   def input param c-estado      as char     no-undo.

   assign adm-new-record = c-estado = "Incluir".


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
  {src/adm/template/snd-list.i "prazo-compra"}

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

