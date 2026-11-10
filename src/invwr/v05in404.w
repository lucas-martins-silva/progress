&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V05IN404 2.00.00.025}  /*** 010025 ***/
 
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05in404 MUT}
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
 
def var rw-saldo-terc  as rowid                      no-undo.
def new global shared var r-componente   as rowid    no-undo.
 
def buffer b-saldo-terc for saldo-terc.
 
def var i-sequencia like saldo-terc.sequencia        no-undo.
 
def var c-handle as char no-undo.
def var it-codigo-aux like saldo-terc.it-codigo init ",".
 
def buffer b-componente for componente.
 
{cdp/cdcfgdis.i}

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.
/************************* Defini‡Æo de vari veis trazidas de outras viewers ******************/
 
def var c-ct-codigo-aux         like componente.ct-codigo     no-undo.
def var c-sc-codigo-aux         like componente.sc-codigo     no-undo.
def var c-class-fiscal-aux      like componente.class-fiscal  no-undo.
def var l-baixa-estoque-aux     as logical                    no-undo.
 
def var c-serie-docto-aux       like saldo-terc.serie-docto   no-undo.
def var c-nro-docto-aux         like saldo-terc.nro-docto     no-undo.
def var i-cod-emitente-aux      like saldo-terc.cod-emitente  no-undo.
def var c-nat-operacao-aux      like saldo-terc.nat-operacao  no-undo.
 
def var c-nat-operacao-ant      like saldo-terc.nat-operacao  no-undo.

def var i-mo-origem        like cotacao.mo-codigo             no-undo.
def var i-mo-destino       like cotacao.mo-codigo             no-undo.
def var de-vl-mat          like item-estab.val-unit-mat-m     no-undo.
def var de-vl-mob          like item-estab.val-unit-mat-m     no-undo.
def var de-vl-convertido   like pr-it-per.val-unit-mob-m[2]   no-undo. 
def var de-vl-origem       like pr-it-per.val-unit-mob-m[1]   no-undo.
def var da-dt-cotacao      like saldo-terc.dt-retorno         no-undo.
 
def var h_v08in053           as handle                        no-undo.
def var h_v06in404           as handle                        no-undo.

def var l-chave-modificada   as logical                       no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES saldo-terc
&Scoped-define FIRST-EXTERNAL-TABLE saldo-terc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-terc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS saldo-terc.it-codigo saldo-terc.sequencia ~
saldo-terc.cod-estabel saldo-terc.nr-ord-prod saldo-terc.dt-retorno ~
saldo-terc.quantidade 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}~
 ~{&FP1}sequencia ~{&FP2}sequencia ~{&FP3}~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}nr-ord-prod ~{&FP2}nr-ord-prod ~{&FP3}~
 ~{&FP1}dt-retorno ~{&FP2}dt-retorno ~{&FP3}~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}
&Scoped-define ENABLED-TABLES saldo-terc
&Scoped-define FIRST-ENABLED-TABLE saldo-terc
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS saldo-terc.it-codigo saldo-terc.sequencia ~
saldo-terc.cod-estabel saldo-terc.nr-ord-prod saldo-terc.dt-retorno ~
saldo-terc.quantidade 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-1 c-nome-estab de-preco-total 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS de-preco-total 
&Scoped-define ADM-ASSIGN-FIELDS de-preco-total 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
cod-depos||y|movind.saldo-terc.cod-depos
it-codigo||y|movind.saldo-terc.it-codigo
sequencia||y|movind.saldo-terc.sequencia
nat-operacao||y|movind.saldo-terc.nat-operacao
cod-emitente||y|movind.saldo-terc.cod-emitente
cod-refer||y|movind.saldo-terc.cod-refer
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-depos,it-codigo,sequencia,nat-operacao,cod-emitente,cod-refer"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-descricao-1 AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 47.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estab AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE de-preco-total AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.14 BY 7.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     saldo-terc.it-codigo AT ROW 1.13 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-1 AT ROW 1.13 COL 35 COLON-ALIGNED NO-LABEL
     saldo-terc.sequencia AT ROW 2.13 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     saldo-terc.cod-estabel AT ROW 3.13 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-nome-estab AT ROW 3.13 COL 25 COLON-ALIGNED HELP
          "Nome Estabelecimento" NO-LABEL
     saldo-terc.nr-ord-prod AT ROW 4.13 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     saldo-terc.dt-retorno AT ROW 5.13 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     de-preco-total AT ROW 6.13 COL 17.29 COLON-ALIGNED
     saldo-terc.quantidade AT ROW 7.13 COL 17.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.saldo-terc
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
         HEIGHT             = 7.42
         WIDTH              = 84.57.
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
       FRAME f-main:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN c-descricao-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-preco-total IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME saldo-terc.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-estabel V-table-Win
ON F5 OF saldo-terc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta=yes.
  {include/zoomvar.i &prog-zoom = adzoom/z01ad107.w
                      &campo = saldo-terc.cod-estabel
                      &campozoom = cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-estabel V-table-Win
ON LEAVE OF saldo-terc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   {include/leave.i &tabela = estabelec
                     &atributo-ref = nome
                     &variavel-ref = c-nome-estab
                     &where = "estabelec.cod-estabel = input frame {&frame-name} saldo-terc.cod-estabel"}
  
   run pi-habilita-valores in h_v06in404.                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply "F5".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.dt-retorno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.dt-retorno V-table-Win
ON LEAVE OF saldo-terc.dt-retorno IN FRAME f-main /* Data Retorno */
DO:

  run pi-habilita-valores in h_v06in404.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.it-codigo V-table-Win
ON F5 OF saldo-terc.it-codigo IN FRAME f-main /* Item */
DO:
   assign l-implanta=yes.
   {include/zoomvar.i &prog-zoom = inzoom/z02in172.w
                      &campo = saldo-terc.it-codigo
                      &campozoom = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.it-codigo V-table-Win
ON LEAVE OF saldo-terc.it-codigo IN FRAME f-main /* Item */
DO: 


assign l-chave-modificada = no.

RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-emitente").
if i-cod-emitente-aux <> int(return-value) then
    assign l-chave-modificada = yes.
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "serie-docto").
if c-serie-docto-aux <> return-value then
    assign l-chave-modificada = yes.
     
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nro-docto").
if c-nro-docto-aux <> return-value then
    assign l-chave-modificada = yes.
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nat-operacao").
assign c-nat-operacao-ant = return-value.
assign c-nat-operacao-ant = replace(c-nat-operacao-ant,".","").
assign c-nat-operacao-ant = replace(c-nat-operacao-ant,"-","").
if c-nat-operacao-ant <> c-nat-operacao-aux then
    assign l-chave-modificada = yes.

if it-codigo-aux <> input frame {&frame-name} saldo-terc.it-codigo or
   l-chave-modificada then do:
 
    RUN pi-pega-chave IN THIS-PROCEDURE.
 
    if valid-handle(h_v08in053) then
        run pi-class-fiscal in h_v08in053.
 
    assign i-sequencia = 0.
 
    for each  b-saldo-terc where b-saldo-terc.serie-docto  = c-serie-docto-aux       and
                                 b-saldo-terc.nro-docto    = c-nro-docto-aux         and
                                 b-saldo-terc.cod-emitente = i-cod-emitente-aux      and                       
                                 b-saldo-terc.nat-operacao = c-nat-operacao-aux     
                                 no-lock break by b-saldo-terc.sequencia:
 
       if i-sequencia <= b-saldo-terc.sequencia then    assign i-sequencia = b-saldo-terc.sequencia.       
    end.
 
    assign saldo-terc.sequencia:screen-value in frame {&frame-name} = string(i-sequencia + 1).
  end.           
  {include/leave.i &tabela = item
                   &atributo-ref = desc-item
                   &variavel-ref = c-descricao-1
                   &where = "item.it-codigo = input frame {&frame-name} saldo-terc.it-codigo"}


assign it-codigo-aux = saldo-terc.it-codigo:screen-value in frame {&frame-name}.
run pi-habilita-valores in h_v06in404.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.it-codigo IN FRAME f-main /* Item */
DO:
  apply "F5".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.nr-ord-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.nr-ord-prod V-table-Win
ON F5 OF saldo-terc.nr-ord-prod IN FRAME f-main /* Ordem Produ‡Æo */
DO:
   assign l-implanta=yes.
  {include/zoomvar.i &prog-zoom = inzoom/z01in271.w
                     &campo = saldo-terc.nr-ord-prod
                     &campozoom = nr-ord-produ}
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.nr-ord-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.nr-ord-prod IN FRAME f-main /* Ordem Produ‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
 
  if saldo-terc.it-codigo:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
 
  if saldo-terc.cod-estabel:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
 
  if saldo-terc.nr-ord-prod:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
 
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  {src/adm/template/row-list.i "saldo-terc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-terc"}

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
 
find first param-estoq no-lock no-error.
   
if avail param-estoq then do:
    ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

    /* Funcao Super/Minas */
    &IF DEFINED(Bf_dis_usuario_estab) &THEN
        IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                             AND funcao.ativo     = YES) THEN DO:
           RUN cdp/cd8702.p (INPUT c-seg-usuario,
                                  INPUT-OUTPUT c-cod-estabel-usuar).
        END.
    &ENDIF

    assign saldo-terc.cod-estabel:screen-value in frame {&frame-name} = string(c-cod-estabel-usuar).
    if param-estoq.estab-uni = yes then
        disable saldo-terc.cod-estabel with frame {&frame-name}.
    apply "leave" to saldo-terc.cod-estabel in frame {&frame-name}.
end.    
else 
    enable saldo-terc.cod-estabel with frame {&frame-name}.     
   
find first param-global no-lock no-error.
 
if param-global.modulo-cp = yes then
    enable saldo-terc.nr-ord-prod with frame {&frame-name}.
else do:
    display "" @ saldo-terc.nr-ord-prod with frame {&frame-name}.
    disable saldo-terc.nr-ord-prod with frame {&frame-name}.
end.

assign i-cod-emitente-aux = 0
       c-serie-docto-aux  = ""
       c-nro-docto-aux    = ""
       c-nat-operacao-ant = ""
       it-codigo-aux      = "".

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

  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.
 
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
 /*********************** Grava Tabela Saldo-terc  **************************/  
 
  if  saldo-terc.nr-ord-prod:sensitive in frame {&frame-name}  = yes then
      assign saldo-terc.nr-ord-prod = input frame {&frame-name} saldo-terc.nr-ord-prod.      
  else
      assign saldo-terc.nr-ord-prod = 0.
 
  find first param-estoq no-lock no-error.
 
  if input frame {&frame-name} saldo-terc.dt-retorno <= param-estoq.ult-fech-dia then
      assign saldo-terc.qtd-ini = input frame {&frame-name} saldo-terc.quantidade.
  else
      assign saldo-terc.qtd-ini = 0.    
 
  assign saldo-terc.cod-depos   = item.deposito-pad
         saldo-terc.cod-localiz = item.cod-localiz.
 
 /*********************** Grava Tabela Componente  **************************/
 
find b-componente where rowid(b-componente) = r-componente EXCLUSIVE-LOCK. 
 
run pi-pega-atributo in this-procedure. 
 
find item-fornec where item-fornec.it-codigo    =  saldo-terc.it-codigo     and
                       item-fornec.cod-emitente =  saldo-terc.cod-emitente  no-lock no-error.
 
find item where item.it-codigo = saldo-terc.it-codigo no-lock no-error. 
 
find natur-oper where natur-oper.nat-operacao = saldo-terc.nat-operacao no-lock no-error. 
 
if avail b-componente then do:
    assign b-componente.dt-retorno     = saldo-terc.dt-retorno
           b-componente.quantidade     = saldo-terc.quantidade
           b-componente.un             = if avail item-fornec then item-fornec.unid-med-for
                                         else item.un 
           b-componente.cod-depos      = saldo-terc.cod-depos
           b-componente.cod-localiz    = saldo-terc.cod-localiz
           b-componente.lote           = saldo-terc.lote
           b-componente.componente     = 1
           b-componente.nr-ord-prod    = saldo-terc.nr-ord-prod
           b-componente.qt-do-forn     = saldo-terc.quantidade
           b-componente.sequencia      = saldo-terc.sequencia.
 
    assign b-componente.preco-total[1] = input frame {&frame-name} de-preco-total
           b-componente.base-ipi[1]    = input frame {&frame-name} de-preco-total
           b-componente.base-icm[1]    = input frame {&frame-name} de-preco-total
           b-componente.preco-total[1] = input frame {&frame-name} de-preco-total
           b-componente.aliquota-ipi   = item.aliquota-ipi
           b-componente.aliquota-icm   = natur-oper.aliquota-icm
           b-componente.ct-codigo      = c-ct-codigo-aux
           b-componente.sc-codigo      = c-sc-codigo-aux
           b-componente.baixa-ce       = l-baixa-estoque-aux. 
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
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
  find b-saldo-terc where rowid(b-saldo-terc) = v-row-parent no-lock no-error.
  
  if avail saldo-terc then do with frame {&frame-name}:
      find item where item.it-codigo = saldo-terc.it-codigo no-lock no-error.
      assign c-descricao-1:screen-value = if  avail item then item.desc-item else "":U.
        
      find estabelec where estabelec.cod-estabel = saldo-terc.cod-estabel no-lock no-error.
      assign c-nome-estab:screen-value = if avail estabelec then estabelec.nome else "":U.  
      
      if not adm-new-record then do:
        find b-componente where
             b-componente.serie-docto  = saldo-terc.serie-docto  and
             b-componente.nro-docto    = saldo-terc.nro-docto    and
             b-componente.cod-emitente = saldo-terc.cod-emitente and
             b-componente.nat-operacao = saldo-terc.nat-operacao and
             b-componente.it-codigo    = saldo-terc.it-codigo    and
             b-componente.cod-refer    = saldo-terc.cod-refer    and
             b-componente.sequencia    = saldo-terc.sequencia 
        no-lock no-error.
            
        if avail b-componente then 
            assign de-preco-total = b-componente.preco-total[1].
        disp de-preco-total with frame {&frame-name}.
      end.
  end.
 
  {utp/ut-liter.i Data_EmissÆo}
  assign saldo-terc.dt-retorno:label in frame {&frame-name} = trim(return-value).
 
 
 
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
 
 
  {utp/ut-field.i mgind componente preco-total 1}
  assign de-preco-total:label in frame {&frame-name} = return-value.
 
 
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
 
  if v-row-parent <> ? then
     assign rw-saldo-terc = v-row-parent.
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-sequencia V-table-Win 
PROCEDURE pi-consiste-sequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def input parameter rw-saldo-terc  as rowid no-undo.
 
  find b-saldo-terc where rowid(b-saldo-terc) = rw-saldo-terc no-lock no-error.
 
  assign i-sequencia = 0.
 
  for each b-saldo-terc where b-saldo-terc.it-codigo = saldo-terc.it-codigo no-lock:
     if i-sequencia <= b-saldo-terc.sequencia then assign i-sequencia = b-saldo-terc.sequencia.
  end.
 
  assign  saldo-terc.sequencia:screen-value in frame {&frame-name} = string(i-sequencia + 1).
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def input parameter p-handle1 as handle.
def input parameter p-handle2 as handle.
 
assign h_v08in053 = p-handle1
       h_v06in404 = p-handle2.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pega-atributo V-table-Win 
PROCEDURE pi-pega-atributo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/****** atributos e vari veis da viewer v07in404.w ****************/
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "l-baixa-estoque").
assign l-baixa-estoque-aux = (return-value = "yes").
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "c-ct-codigo").
 
find first param-global no-lock no-error.
if avail param-global then do:
    find first conta-contab where conta-contab.ep-codigo = param-global.empresa-prin
        and conta-contab.conta-contabil = return-value
        no-lock no-error.
    if avail conta-contab then 
        assign c-ct-codigo-aux = conta-contab.ct-codigo
               c-sc-codigo-aux = conta-contab.sc-codigo.
end.
 
/****** atributos e vari veis da viewer v08in404.w ****************/
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cb-cd-trib-ipi").
 
RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cb-cd-trib-icm").
 
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pega-chave V-table-Win 
PROCEDURE pi-pega-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-emitente").
  assign i-cod-emitente-aux =  int(return-value).
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "serie-docto").
  assign c-serie-docto-aux =  return-value.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nro-docto").
  assign c-nro-docto-aux =  return-value.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nat-operacao").
  assign c-nat-operacao-aux = return-value.
  assign c-nat-operacao-aux = replace(c-nat-operacao-aux,".","").
  assign c-nat-operacao-aux = replace(c-nat-operacao-aux,"-","").
 
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
 
   find item where 
                 item.it-codigo = input frame {&frame-name} saldo-terc.it-codigo no-lock no-error.
   if not avail item then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind item 1} 
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply 'entry' to input frame {&frame-name} saldo-terc.it-codigo.
      return 'ADM-ERROR':U.
   end.
 
   find estabelec where 
                 estabelec.cod-estabel = input frame {&frame-name} saldo-terc.cod-estabel no-lock no-error.
   if not avail estabelec then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind estabelec 1} 
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply 'entry' to input frame {&frame-name} saldo-terc.cod-estabel.
      return 'ADM-ERROR':U.
   end.
 
 
   IF input frame {&frame-name} saldo-ter.nr-ord-prod <> 0 THEN DO:
 
       find ord-prod where 
                     ord-prod.nr-ord-prod = input frame {&frame-name} saldo-terc.nr-ord-prod no-lock no-error.
 
       if not avail ord-prod and item.tipo-contr <> 2 then do:
          {include/i-vldprg.i}
          {utp/ut-table.i mgind ord-prod 1} 
          run utp/ut-msgs.p (input "show":U, input 2, input return-value).
          apply 'entry' to input frame {&frame-name} saldo-terc.nr-ord-prod.
          return 'ADM-ERROR':U.
       end.
       else do:
           if ord-prod.cod-estabel <> input frame {&frame-name} saldo-terc.cod-estabel then do:
               {include/i-vldprg.i}
               run utp/ut-msgs.p (input "show":U, input 5496, input "").
               apply 'entry' to input frame {&frame-name} saldo-terc.nr-ord-prod.
               return 'ADM-ERROR':U.
           end.
           if ord-prod.estado = 8  then do:
               {include/i-vldprg.i}
               run utp/ut-msgs.p (input "show":U, input 1881, input "").
               apply 'entry' to input frame {&frame-name} saldo-terc.nr-ord-prod.
               return 'ADM-ERROR':U.     
           end.
           if ord-prod.estado = 7  then do:
               {include/i-vldprg.i}
               run utp/ut-msgs.p (input "show":U, input 1882, input "").
               apply 'entry' to input frame {&frame-name} saldo-terc.nr-ord-prod.
               return 'ADM-ERROR':U.     
           end.
       end.    
   END.
 
   if input frame {&frame-name} saldo-terc.dt-retorno = ? then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 1090, input "").
      apply 'entry' to input frame {&frame-name} saldo-terc.dt-retorno.
      return 'ADM-ERROR':U.
   end.
 
   if input frame {&frame-name} saldo-terc.dt-retorno > today then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 6101, input "").
      apply 'entry' to input frame {&frame-name} saldo-terc.dt-retorno.
      return 'ADM-ERROR':U.
   end.
 
   if (input frame {&frame-name} de-preco-total = 0 or
      input frame {&frame-name} de-preco-total = ?) and i-pais-impto-usuario = 1 then do:
      {include/i-vldprg.i}
      {utp/ut-liter.i Pre‡o_Total * C}
      run utp/ut-msgs.p (input "show":U, input 1491, input trim(return-value)).
      apply 'entry' to input frame {&frame-name} de-preco-total.
      return 'ADM-ERROR':U.
   end.
 
   if input frame {&frame-name} saldo-terc.quantidade = 0 or
      input frame {&frame-name} saldo-terc.quantidade = ? then do:
      {include/i-vldprg.i}
      {utp/ut-field.i mgind saldo-terc Quantidade 1}
      run utp/ut-msgs.p (input "show":U, input 1491, input trim(return-value)).
      apply 'entry' to input frame {&frame-name} saldo-terc.quantidade.
      return 'ADM-ERROR':U.
   end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "cod-depos" "saldo-terc" "cod-depos"}
  {src/adm/template/sndkycas.i "it-codigo" "saldo-terc" "it-codigo"}
  {src/adm/template/sndkycas.i "sequencia" "saldo-terc" "sequencia"}
  {src/adm/template/sndkycas.i "nat-operacao" "saldo-terc" "nat-operacao"}
  {src/adm/template/sndkycas.i "cod-emitente" "saldo-terc" "cod-emitente"}
  {src/adm/template/sndkycas.i "cod-refer" "saldo-terc" "cod-refer"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "saldo-terc"}

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


