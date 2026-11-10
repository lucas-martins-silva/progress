
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V12IN287 2.00.00.027 } /*** 010027 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v12in287 MUT}
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

/* Centro de Custo X Estabelecimento */
{cdp/cd0110.i}

def var c-moeda1   as char.
def var c-moeda2   as char.
def var c-moeda3   as char.
def var c-lista    as char.
def var h-acomp    as handle no-undo.
def var c-mensagem as char.

def new shared var da-iniper-x    as date no-undo.
def new shared var da-fimper-x    as date no-undo.

/* DEFINICAO DE BUFFERS - USADOS PARA EVITAR LOCK TABLE OVERFLOW */
def buffer  b-movto-est   for movto-estoq.
def buffer  b-movto-mat   for movto-mat.
def buffer  b-movto-ggf   for movto-ggf.

/* DEFINICAO DE VARIAVEIS USADOS NO ZOOM DE ESTABELECIMENTO E ITEM */
def new shared var  c-cod-estabel   like estabelec.cod-estabel.
def new shared var  c-fm-codigo     like item.fm-codigo.
def new shared var  c-it-codigo     like item.it-codigo.
def new shared var  c-it-descricao  as character format "x(36)".
def new shared var  c-it-un         like item.un.
def new shared var  i-ge-codigo     like item.ge-codigo.
def new shared var  da-dt-cotacao   as date      format "99/99/9999" no-undo.
def new shared var  i-moeda         like cotacao.mo-codigo no-undo.

/* DEFINICAO DE VARIAVEIS PARTICULARES DO PROGRAMA */
def var  c-label           as character format "x(10)" extent 4 no-undo.
def var  c-moeda           as character format "x(14)" extent 3 no-undo.
def var  c-opcao           as character no-undo.
def var  c-opcao2          as character no-undo.
def var  c-opcao3          as character no-undo.
def var  c-tit-moeda       as character format "x(42)" no-undo.
def var  c-titulo          as character no-undo.
def var  c-traco           as character format "x(76)" no-undo.
def var  de-saldo          as decimal   no-undo.
def var  de-vl-convertido  as decimal   no-undo.
def var  de-vl-origem      as decimal   no-undo.
def var  i-mo-destino      like cotacao.mo-codigo no-undo.
def var  i-mo-origem       like cotacao.mo-codigo no-undo.
def var  l-corrige         as logical   init yes format "Sim/Nao" no-undo.
def var  l-resp            as logical   init no  format "Sim/Nao" no-undo.
def var  l-atu1            as logical   no-undo.
def var  l-atu2            as logical   no-undo.
def var  i-mo-fasb         as integer   no-undo.
def var  i-mo-cmi          as integer   no-undo.
def var  i-cont            as integer   no-undo.
def var da-iniper          as date format "99/99/9999"   no-undo.
def var da-fimper          as date format "99/99/9999"   no-undo.
def var da-aux             as date format "99/99/9999"   no-undo.
def var i-per-corrente     as int  format "99"           no-undo.
def var i-ano-corrente     as int  format "9999"         no-undo.
def var da-iniper-fech     as date format "99/99/9999"   no-undo.
def var da-fimper-fech     as date format "99/99/9999"   no-undo.
def var c-per              like ext-per-custo-estab.periodo    no-undo.
{cep/ce1234.i}

def var l-fech-estab       as logical init no.
def var c-estabel-aux      like estabelec.cod-estabel.

def var i-empresa like param-global.empresa-prin no-undo.

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-17 rs-moeda bt-executa1 
&Scoped-Define DISPLAYED-OBJECTS rs-moeda 

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
DEFINE BUTTON bt-executa1 
     LABEL "" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE rs-moeda AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "", 1,
"", 2,
"", 3
     SIZE 26.57 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.29 BY 4.17.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.57 BY 10.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rs-moeda AT ROW 4.08 COL 40 NO-LABEL
     bt-executa1 AT ROW 10.13 COL 78.14
     rt-mold AT ROW 1 COL 1
     RECT-17 AT ROW 3.5 COL 20.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 10.83
         WIDTH              = 89.57.
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
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-executa1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-executa1 V-table-Win
ON CHOOSE OF bt-executa1 IN FRAME f-main
DO:
   run utp/ut-msgs.p (input "show",
                       input 3764,
                       input "").
   if return-value = "yes" then do:
      assign l-corrige = yes.
   end.
   if return-value = "no" then do:
      assign l-corrige = no.
   end.

   if input frame {&frame-name} rs-moeda = 1 then do:
      assign i-moeda = 1.
   end.
   if input frame {&frame-name} rs-moeda = 2 then do:
      assign i-moeda = 2.
   end.
   if input frame {&frame-name} rs-moeda = 3 then do:
      assign i-moeda = 3.
   end.

   do on error undo,retry:
      if (i-moeda = 1 or i-moeda = 3) and not param-estoq.tem-moeda1 then do:
          run utp/ut-msgs.p (input "show",
                        input 975,
                        input "").
          return 'adm-error'.
      end.
      if (i-moeda = 2 or i-moeda = 3) and not param-estoq.tem-moeda2 then do:
          run utp/ut-msgs.p (input "show",
                             input 976,
                             input "").
          return 'adm-error'.
      end.
   end.

   run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Corrigindo_Valores_na(s)_Moeda(s)_Alternativa(s) *}
   run pi-inicializar in h-acomp (input  Return-value ).
   assign i-mo-origem = 0.

   /* ATUALIZANDO OS SALDOS DO ITEM NOS ESTABELECIMENTOS */

assign i-empresa = param-global.empresa-prin.

&if defined (bf_dis_consiste_conta) &then

    find estabelec where
         estabelec.cod-estabel = estab-mat.cod-estabel NO-LOCK no-error.

    IF AVAIL estabelec THEN
        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
&endif

    for each item-estab use-index ITEM EXCLUSIVE-LOCK:

       if l-fech-estab then do:
          &if defined(bf_mat_fech_estab) &then
          find estab-mat where estab-mat.cod-estabel = item-estab.cod-estabel
               NO-LOCK no-error.
          IF AVAIL estab-mat THEN
              run cdp/cdapi005.p (input  estab-mat.ult-per-fech,
                                  output da-iniper-x   ,
                                  output da-fimper-x   ,
                                  output i-per-corrente,
                                  output i-ano-corrente,
                                  output da-aux        ,
                                  output da-aux        ).
          &endif
       end.

       assign da-dt-cotacao = da-iniper-x - 1.
       {utp/ut-liter.i Item_X_Estab.: * C} 
       assign c-mensagem = return-value + item-estab.it-codigo.
       run pi-acompanhar in h-acomp (input c-mensagem).
       find first estab-mat where item-estab.cod-estabel = estab-mat.cod-estabel NO-LOCK no-error.
       if AVAIL estab-mat AND (i-moeda = 1 or i-moeda = 3) and param-estoq.tem-moeda1 then do:
           if estab-mat.custo-contab = 1 /* mensal */ then do:     
              {cep/ce0104.i item-estab.sald-ini-mat-m 1}
              {cep/ce0104.i item-estab.sald-ini-mob-m 1}
              {cep/ce0104.i item-estab.sald-ini-ggf-m 1}
              {cep/ce0104.i item-estab.val-unit-mat-m 1}
              {cep/ce0104.i item-estab.val-unit-mob-m 1}  
              {cep/ce0104.i item-estab.val-unit-ggf-m 1}  
           end.
           if estab-mat.usa-on-line = yes then do:     
              {cep/ce0104.i item-estab.sald-ini-mat-o 1}
              {cep/ce0104.i item-estab.sald-ini-mob-o 1}
              {cep/ce0104.i item-estab.sald-ini-ggf-o 1}
              {cep/ce0104.i item-estab.val-unit-mat-o 1}
              {cep/ce0104.i item-estab.val-unit-mob-o 1}  
              {cep/ce0104.i item-estab.val-unit-ggf-o 1}  
          end.
       end.
       if AVAIL estab-mat AND (i-moeda = 2 or i-moeda = 3) and param-estoq.tem-moeda2 then do:
          if estab-mat.custo-contab = 1 /* mensal */ then do:
             {cep/ce0104.i item-estab.sald-ini-mat-m 2}
             {cep/ce0104.i item-estab.sald-ini-mob-m 2}
             {cep/ce0104.i item-estab.sald-ini-ggf-m 2}
             {cep/ce0104.i item-estab.val-unit-mat-m 2}
             {cep/ce0104.i item-estab.val-unit-mob-m 2} 
             {cep/ce0104.i item-estab.val-unit-ggf-m 2}    
          end.
          if estab-mat.usa-on-line = yes then do:
             {cep/ce0104.i item-estab.sald-ini-mat-o 2}
             {cep/ce0104.i item-estab.sald-ini-mob-o 2}
             {cep/ce0104.i item-estab.sald-ini-ggf-o 2}
             {cep/ce0104.i item-estab.val-unit-mat-o 2}
             {cep/ce0104.i item-estab.val-unit-mob-o 2} 
             {cep/ce0104.i item-estab.val-unit-ggf-o 2}    
          end.
       end.
   end.

   run pi-finalizar in h-acomp.

   run pi-corrige.

   if not l-fech-estab then do:
      IF l-funcao-ccusto-estab THEN DO:   
          find first ext-per-custo-estab 
              where ext-per-custo-estab.periodo = c-per 
                and ext-per-custo-estab.cod-estabel = estab-mat.cod-estabel no-lock no-error.
          if avail ext-per-custo-estab then do on endkey undo, retry:
             run utp/ut-msgs.p (input "show",
                                input 3765,
                                input "").
          end.        
      END. ELSE DO:   
          find first ext-per-custo 
              where ext-per-custo.periodo = c-per no-lock no-error.
          if avail ext-per-custo then do on endkey undo, retry:
             run utp/ut-msgs.p (input "show",
                                input 3765,
                                input "").
          end.        
      END.
      

   end.

   run utp/ut-msgs.p (input "show",
                      input 6646,
                      input "").   

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

  find first param-estoq no-lock no-error.
  if not l-fech-estab then do:
     run cdp/cdapi005.p (input param-estoq.ult-per-fech,
                         output da-iniper,
                         output da-fimper,
                         output i-per-corrente,
                         output i-ano-corrente,
                         output da-iniper-fech,
                         output da-fimper-fech).
     assign c-per = string(i-ano-corrente,"9999")+ string(i-per-corrente,"99").
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  {utp/ut-liter.i Executa * C}
  assign bt-executa1:label in frame {&frame-name} = return-value.

  find first param-global no-lock no-error.
  if not avail param-global then do:
     run utp/ut-msgs.p (input "show",
                        input 16,
                        input "").
     return 'adm-error'.
  end.


  find first param-estoq NO-LOCK no-error.
  if not avail param-estoq then do:
     run utp/ut-msgs.p (input "show",
                        input 1059,
                        input "").
     return 'adm-error'.
  end.
  else {cep/ce9998.i}.

  find param-fasb where param-fasb.ep-codigo = i-empresa no-lock no-error.
  if avail param-fasb then do:
     assign i-mo-fasb = param-fasb.moeda-fasb
            i-mo-cmi  = param-fasb.moeda-cmi. 
  end.

  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     assign c-moeda1 = moeda.descricao.
  end.
  else do:
     {utp/ut-liter.i NÆo_Existe * R}
     assign c-moeda1 = return-value.
  end.

  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     assign c-moeda2 = moeda.descricao.
  end.
  else do: 
     {utp/ut-liter.i NÆo_Existe * R}
     assign c-moeda2 = return-value.
  end.

  {utp/ut-liter.i Todas * R}
  assign c-moeda3 = return-value.

  assign c-lista  = c-moeda1 + ",1," + c-moeda2 + ",2," + c-moeda3 + ",3".
  assign rs-moeda:radio-buttons in frame {&frame-name} = c-lista.

  if param-estoq.tem-moeda1 = no and param-estoq.tem-moeda2 = no then do:
     disable rs-moeda with frame {&frame-name}.
  end.
  if param-estoq.tem-moeda1 = yes or param-estoq.tem-moeda2 = yes then do:
     enable rs-moeda with frame {&frame-name}.
  end.

  &if defined(bf_mat_fech_estab) &then
     if param-estoq.tp-fech = 2 then
        assign l-fech-estab = yes.
  &endif

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-corrige V-table-Win 
PROCEDURE pi-corrige :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 if l-fech-estab then do:
    &if defined(bf_mat_fech_estab) &then
    for each estab-mat no-lock:
        assign da-iniper-x = (estab-mat.ult-fech-dia + 1).
        if month(da-iniper-x) = 12 then
            assign da-fimper-x = date(01,01,year(da-iniper-x) + 1) - 1.
        else
            assign da-fimper-x = date(month(da-iniper-x) + 1,01,year(da-iniper-x)) - 1.
        assign i-per-corrente = month(da-iniper-x)
               i-ano-corrente = year(da-iniper-x).
        assign c-estabel-aux = estab-mat.cod-estabel.
        run pi-corrige2.
    end.
    &endif
 end.
 else
    run pi-corrige2.

 if l-corrige then do:
    /* ATUALIZA EXT-ORD */
    assign da-dt-cotacao = da-iniper-x - 1.
    {utp/ut-run.i cep/ce0104c.p}  
 end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-corrige2 V-table-Win 
PROCEDURE pi-corrige2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* VERIFICA SE CORRIGE OU NAO A MOVIMENTACAO DE ESTOQUE DO ITEM */
   if l-corrige then do:

      run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Corrigindo_Valores_na(s)_Moeda(s)_Alternativa(s) *}
      run pi-inicializar in h-acomp (input  Return-value ).
      /* ATUALIZA A MOVIMENTACAO DE ESTOQUE DO ITEM */

      for each movto-estoq use-index data-item 
          where movto-estoq.dt-trans >= da-iniper-x
          and   (if l-fech-estab 
                 then movto-estoq.cod-estabel = c-estabel-aux
                 else yes) no-lock:

          if movto-estoq.esp-docto = 2 and movto-estoq.quantidade  = 0 then next.
          if movto-estoq.esp-docto = 6 and movto-estoq.serie-docto = "moe" then next.
          if movto-estoq.esp-docto = 6 and movto-estoq.quantidade  = 0 then next.

          {utp/ut-liter.i Movto_Estoque.: * C} 
          assign c-mensagem = return-value + movto-estoq.it-codigo.
          run pi-acompanhar in h-acomp (input c-mensagem).

          find b-movto-est where rowid(b-movto-est) = rowid(movto-estoq) EXCLUSIVE-LOCK.
          assign da-dt-cotacao = b-movto-est.dt-trans.
         
          find first estab-mat where b-movto-est.cod-estabel = estab-mat.cod-estabel NO-LOCK no-error.
          IF AVAIL estab-mat THEN DO:
              if param-estoq.tem-moeda1 and (i-moeda = 1 or i-moeda = 3) then do:
    
                 if estab-mat.custo-contab = 1 /* mensal */ then do:
                    {cep/ce0104.i b-movto-est.valor-mat-m 1}
                    {cep/ce0104.i b-movto-est.valor-mob-m 1}  
                    {cep/ce0104.i b-movto-est.valor-ggf-m 1}  
                 end.
                 if estab-mat.usa-on-line = yes then do:
                    {cep/ce0104.i b-movto-est.valor-mat-o 1}
                    {cep/ce0104.i b-movto-est.valor-mob-o 1}  
                    {cep/ce0104.i b-movto-est.valor-ggf-o 1}  
                 end.
              end.
              if param-estoq.tem-moeda2 and (i-moeda = 2 or i-moeda = 3) then do:
                 if estab-mat.custo-contab = 1 /* mensal */ then do:
                    {cep/ce0104.i b-movto-est.valor-mat-m 2}
                    {cep/ce0104.i b-movto-est.valor-mob-m 2}  
                    {cep/ce0104.i b-movto-est.valor-ggf-m 2}  
                 end.
                 if estab-mat.usa-on-line = yes then do:
                    {cep/ce0104.i b-movto-est.valor-mat-o 2}
                    {cep/ce0104.i b-movto-est.valor-mob-o 2}  
                    {cep/ce0104.i b-movto-est.valor-ggf-o 2}  
                 end.
              END.
          end.
      end.


      run pi-finalizar in h-acomp.

      /* ATUALIZA A MOVIMENTACAO DE MATERIAL DO ITEM */
      run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Corrigindo_Valores_na(s)_Moeda(s)_Alternativa(s) *}
      run pi-inicializar in h-acomp (input  Return-value ).
      for each movto-mat use-index data 
          where movto-mat.dt-trans >= da-iniper-x 
          and   (if l-fech-estab 
                 then movto-mat.cod-estabel = c-estabel-aux
                 else yes) no-lock:
          find b-movto-mat where rowid(b-movto-mat) = rowid(movto-mat) exclusive-lock.
          assign da-dt-cotacao = b-movto-mat.dt-trans.

          {utp/ut-liter.i Movto_Material.: * C} 
          assign c-mensagem = return-value + movto-mat.it-codigo.
          run pi-acompanhar in h-acomp (input c-mensagem).

          find first estab-mat where movto-mat.cod-estabel = estab-mat.cod-estabel no-lock no-error.

          if param-estoq.tem-moeda1 and (i-moeda = 1 or i-moeda = 3) then do:
             if estab-mat.custo-contab = 1 /* mensal */ then do:
                {cep/ce0104.i b-movto-mat.valor-mat-m 1}
                {cep/ce0104.i b-movto-mat.valor-mob-m 1}   
                {cep/ce0104.i b-movto-mat.valor-ggf-m 1}   
             end.
             if estab-mat.usa-on-line = yes then do:
                {cep/ce0104.i b-movto-mat.valor-mat-o 1}
                {cep/ce0104.i b-movto-mat.valor-mob-o 1}   
                {cep/ce0104.i b-movto-mat.valor-ggf-o 1}   
             end.
          end.
          if param-estoq.tem-moeda2 and (i-moeda = 2 or i-moeda = 3) then do:
             if estab-mat.custo-contab = 1 /* mensal */ then do:
                {cep/ce0104.i b-movto-mat.valor-mat-m 2}
                {cep/ce0104.i b-movto-mat.valor-mob-m 2} 
                {cep/ce0104.i b-movto-mat.valor-ggf-m 2}    
             end.
             if estab-mat.usa-on-line = yes then do:
                {cep/ce0104.i b-movto-mat.valor-mat-o 2}
                {cep/ce0104.i b-movto-mat.valor-mob-o 2} 
                {cep/ce0104.i b-movto-mat.valor-ggf-o 2}    
             end.
          end.
      end.
      run pi-finalizar in h-acomp.

      /* ATUALIZA A MOVIMENTACAO DE MAO DE OBRA DO ITEM */
      run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Corrigindo_Valores_na(s)_Moeda(s)_Alternativa(s) *}
      run pi-inicializar in h-acomp (input  Return-value ).
      for each movto-ggf use-index ordem 
          where movto-ggf.dt-trans >= da-iniper-x 
          and  (if l-fech-estab
                then movto-ggf.cod-estabel = c-estabel-aux
                else yes) no-lock:
          find b-movto-ggf where rowid(b-movto-ggf) = rowid(movto-ggf) exclusive-lock.
          assign da-dt-cotacao = b-movto-ggf.dt-trans.

          {utp/ut-liter.i Movto_mob.: * L} 
          assign c-mensagem = return-value + movto-ggf.it-codigo.
          run pi-acompanhar in h-acomp (input c-mensagem).

          find first estab-mat where movto-ggf.cod-estabel = estab-mat.cod-estabel no-lock no-error.

          if param-estoq.tem-moeda1 and (i-moeda = 1 or i-moeda = 3) then do:
             if estab-mat.custo-contab = 1 /* mensal */ then do:
                {cep/ce0104.i b-movto-ggf.valor-ggf-1-m 1} 
                {cep/ce0104.i b-movto-ggf.valor-ggf-2-m 1}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-3-m 1}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-4-m 1}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-5-m 1}
                {cep/ce0104.i b-movto-ggf.valor-ggf-6-m 1}      
             end.
             if estab-mat.usa-on-line = yes then do:
                {cep/ce0104.i b-movto-ggf.valor-ggf-1-o 1}
                {cep/ce0104.i b-movto-ggf.valor-ggf-2-o 1}   
                {cep/ce0104.i b-movto-ggf.valor-ggf-3-o 1}   
                {cep/ce0104.i b-movto-ggf.valor-ggf-4-o 1}   
                {cep/ce0104.i b-movto-ggf.valor-ggf-5-o 1}   
                {cep/ce0104.i b-movto-ggf.valor-ggf-6-o 1}   
             end.
          end.
          if param-estoq.tem-moeda2 and (i-moeda = 2 or i-moeda = 3) then do:
             if estab-mat.custo-contab = 1 /* mensal */ then do:
                {cep/ce0104.i b-movto-ggf.valor-ggf-1-m 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-2-m 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-3-m 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-4-m 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-5-m 2}   
                {cep/ce0104.i b-movto-ggf.valor-ggf-6-m 2}   
             end.
             if estab-mat.usa-on-line = yes then do:
                {cep/ce0104.i b-movto-ggf.valor-ggf-1-o 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-2-o 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-3-o 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-4-o 2}  
                {cep/ce0104.i b-movto-ggf.valor-ggf-5-o 2}   
                {cep/ce0104.i b-movto-ggf.valor-ggf-6-o 2}   
             end.
          end.
      end.
      run pi-finalizar in h-acomp.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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


