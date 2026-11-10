&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V01IN579 2.00.00.023 } /*** 010023 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in579 MUT}
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
{cdp/cd0666.i} /* definiá∆o da tt-erro */

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo. 
def new global shared var gr-evento-ped as rowid no-undo.                               

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-evento-ped for evento-ped.
def buffer b1-evento-ped for evento-ped.

def var i-ordem               like evento-ped.numero-ordem.
def var i-sequencia           as   integer format "99".
def var i-ordem-ini           like evento-ped.numero-ordem.
def var i-ordem-fim           like evento-ped.numero-ordem.
def var i-seq-evento       like evento-ped.seq-evento.
def var c-event-codigo        like evento-ped.seq-evento.
def var c-event-desc          like evento-ped.des-event.
def var de-valor-conver       as dec format "->>>>,>>>,>>9.9999".
def var de-variacao-qtd       like evento-ped.qtd-prevista.
def var de-variacao-val       like evento-ped.val-previsto.
def var de-total-qtd          as dec format "->>>>,>>>,>>9.9999".
def var de-qtd-ordem          like de-total-qtd.
def var de-total-val          like evento-ped.val-previsto.
def var de-val-ordem          like de-total-val.
def var de-val-anterior       like evento-ped.val-realizado.
def var de-qtd-anterior       like evento-ped.qtd-realizada.
def var c-desc-1              as   character format "x(38)".
def var c-desc-2              as   character format "x(38)".
def var i-conta               as   integer   no-undo.
def var i-cont                as   integer.
def var l-realizado           as   logical initial no no-undo.
def var i-num-periodos        as   integer init 1.
def var i-prox-ent            as   integer.
def var da-data-prev          like evento-ped.dat-prev-ent.
def var i-total-perc          as   integer   no-undo.
def var l-erro-co             as logical no-undo.
def var l-msg-tela            as logical no-undo.

def new shared var c-cod-estabel        like estabelec.cod-estabel.
def new global shared var c-nr-contrato like item-contrat.nr-contrato no-undo.
def new global shared var gr-it-codigo  like ordem-compra.it-codigo no-undo.
def var g-nr-contrato                   like contrato-for.nr-contrato no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES evento-ped
&Scoped-define FIRST-EXTERNAL-TABLE evento-ped


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR evento-ped.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS evento-ped.cod-estabel 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}
&Scoped-define ENABLED-TABLES evento-ped
&Scoped-define FIRST-ENABLED-TABLE evento-ped
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS evento-ped.dt-evento ~
evento-ped.num-seq-item evento-ped.numero-ordem evento-ped.cod-estabel ~
evento-ped.seq-evento 
&Scoped-Define DISPLAYED-OBJECTS c-contrato c-des-contrato i-cod-tipo-contr ~
c-tipo c-it-codigo c-item c-estabelec 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS evento-ped.dt-evento c-contrato ~
evento-ped.num-seq-item evento-ped.numero-ordem evento-ped.cod-estabel ~
evento-ped.seq-evento 
&Scoped-define ADM-ASSIGN-FIELDS evento-ped.dt-evento c-contrato ~
evento-ped.num-seq-item evento-ped.numero-ordem evento-ped.cod-estabel ~
evento-ped.seq-evento 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
nr-contrat||y|mgind.evento-ped.nr-contrat
numero-ordem||y|mgind.evento-ped.numero-ordem
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "nr-contrat,numero-ordem"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-contrato &if defined(bf_mat_contratos) &then
                                 AS INTEGER FORMAT ">>>>>>>>9":U
                           &else AS CHARACTER FORMAT "X(12)":U
                           &endif
     LABEL ""
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-contrato AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabelec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-tipo-contr AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Tipo Contrato" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     evento-ped.dt-evento AT ROW 1.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-contrato AT ROW 2.25 COL 20 COLON-ALIGNED
     c-des-contrato AT ROW 2.25 COL 29 COLON-ALIGNED NO-LABEL
     i-cod-tipo-contr AT ROW 3.25 COL 20 COLON-ALIGNED HELP
          "Tipo de Contrato"
     c-tipo AT ROW 3.25 COL 29 COLON-ALIGNED NO-LABEL
     evento-ped.num-seq-item AT ROW 4.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     c-it-codigo AT ROW 4.25 COL 28.14 COLON-ALIGNED HELP
          "C¢digo do Item" NO-LABEL
     c-item AT ROW 4.25 COL 42.14 COLON-ALIGNED NO-LABEL
            VIEW-AS FILL-IN 
            SIZE 44.86 BY .88
     evento-ped.numero-ordem AT ROW 5.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     evento-ped.cod-estabel AT ROW 6.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     c-estabelec AT ROW 6.25 COL 27 COLON-ALIGNED NO-LABEL
     evento-ped.seq-evento AT ROW 6.25 COL 79 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.evento-ped
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
         HEIGHT             = 6.58
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

/* SETTINGS FOR FILL-IN c-contrato IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN c-des-contrato IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estabelec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evento-ped.cod-estabel IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN evento-ped.dt-evento IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN i-cod-tipo-contr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN evento-ped.num-seq-item IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN evento-ped.numero-ordem IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN evento-ped.seq-evento IN FRAME f-main
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

&Scoped-define SELF-NAME c-contrato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-contrato V-table-Win
ON F5 OF c-contrato IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in065.w
                     &campo=c-contrato
                     &campozoom=nr-contrato}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-contrato V-table-Win
ON LEAVE OF c-contrato IN FRAME f-main
DO:

  {include/leave.i &tabela=contrato-for
                   &atributo-ref=des-contrat
                   &variavel-ref=c-des-contrato
                   &where="contrato-for.nr-contrato =
                           input frame {&frame-name} c-contrato"}
    
find contrato-for where contrato-for.nr-contrato = input frame {&frame-name} c-contrato no-lock no-error.
if available contrato-for then do:
   assign c-des-contrato = contrato-for.des-contrat
          i-cod-tipo-contr = contrato-for.cod-tipo-contr.
   find tipo-contrat where tipo-contrat.cod-tipo-contr = 
        input frame {&frame-name} i-cod-tipo-contr no-lock no-error.
   if available tipo-contrat then
      assign c-tipo = tipo-contrat.des-tipo-contrat.
   display c-des-contrato
           i-cod-tipo-contr
           c-tipo with frame {&frame-name}.    
end.

run pi-ordem.
run pi-numera-evento.
run notify ('pi-recebe-item, group-assign-target').

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-contrato V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-contrato IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-estabel V-table-Win
ON F5 OF evento-ped.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta = yes 
         c-nr-contrato = input frame {&frame-name} c-contrato.
  {include/zoomvar.i &prog-zoom=adzoom/z03ad107.w
                     &campo=evento-ped.cod-estabel
                     &campozoom=cod-estabel}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-estabel V-table-Win
ON LEAVE OF evento-ped.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-estabelec
                   &where="estabelec.cod-estabel =
                           input frame {&frame-name} evento-ped.cod-estabel"}

run pi-ordem.
run pi-numera-evento.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF evento-ped.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-tipo-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-tipo-contr V-table-Win
ON F5 OF i-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in576.w
                   &campo=i-cod-tipo-contr
                   &campozoom=cod-tipo-contr}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-tipo-contr V-table-Win
ON LEAVE OF i-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
{include/leave.i &tabela=tipo-contrat  
                 &atributo-ref=des-tipo-contrat
                 &variavel-ref=c-tipo
                 &where="tipo-contrat.cod-tipo-contr =
                         input frame {&frame-name} i-cod-tipo-contr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-tipo-contr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-tipo-contr IN FRAME f-main /* Tipo Contrato */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.num-seq-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.num-seq-item V-table-Win
ON F5 OF evento-ped.num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
  assign l-implanta = yes.
  assign g-nr-contrato = input frame {&frame-name} c-contrato.
  {include/zoomvar.i &prog-zoom=inzoom/z02in582.w
                     &campo=evento-ped.num-seq-item
                     &campozoom=num-seq-item}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.num-seq-item V-table-Win
ON LEAVE OF evento-ped.num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
    {include/leave.i &tabela=item-contrat
                     &atributo-ref=num-seq-item
                     &variavel-ref=c-item
                     &where="item-contrat.num-seq-item =
                             input frame {&frame-name} evento-ped.num-seq-item"}



find first item-contrat where item-contrat.num-seq-item = 
                        input frame {&frame-name} evento-ped.num-seq-item 
                        and item-contrat.nr-contrat =
                        input frame {&frame-name} c-contrato
                        no-lock no-error.


if avail item-contrat then
    assign gr-it-codigo = item-contrat.it-codigo.

/*if  not available item-contrat then do:
 *     run utp/ut-msgs.p(input "show",
 *                      input 7835, 
 *                      input ""). /* Sequencia de item nao cadastrada. */
 *     return no-apply.
 * end.*/

/*


if item-contrat.ind-sit-item <> 2 then
    /* 9999.i "Situacao do item do Contrato Invalida. */
if item-contrat.log-libera = no then
    /* 9999.i "Item Inativo no Contrato. */
if  not item-contrat.log-control-event then
    /* 9999.i "Item nao controlado por evento. */

*/

if avail item-contrat then do:
   find item where item.it-codigo = item-contrat.it-codigo 
   no-lock no-error.

   if  available item then 
       display item.desc-item @ c-item
               item.it-codigo @ c-it-codigo with frame {&frame-name}.

   if adm-new-record then do with frame {&frame-name}:
      assign evento-ped.numero-ordem:sensitive = item-contrat.ind-tipo-control = 2
             evento-ped.cod-estabel:sensitive  = item-contrat.ind-tipo-control = 1.
   end.
end.

run pi-ordem.
run pi-numera-evento.
run notify ('pi-recebe-item, group-assign-target').


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.num-seq-item V-table-Win
ON MOUSE-SELECT-DBLCLICK OF evento-ped.num-seq-item IN FRAME f-main /* SeqÅància Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME evento-ped.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.numero-ordem V-table-Win
ON F5 OF evento-ped.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:


  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z19in274.w
                   &campo=evento-ped.numero-ordem
                   &campozoom=numero-ordem}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.numero-ordem V-table-Win
ON LEAVE OF evento-ped.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:

find first ordem-compra where
    ordem-compra.numero-ordem = input frame {&frame-name} evento-ped.numero-ordem
    no-lock no-error.
if available ordem-compra then 
    disp ordem-compra.cod-estabel @ evento-ped.cod-estabel with frame {&frame-name}. 
    
run pi-numera-evento.
run notify ('pi-recebe-item, group-assign-target').
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL evento-ped.numero-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF evento-ped.numero-ordem IN FRAME f-main /* Ordem Compra */
DO:
  apply 'F5' to self.
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

if c-contrato:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if evento-ped.num-seq-item:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if evento-ped.numero-ordem:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if evento-ped.cod-estabel:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if evento-ped.numero-ordem:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

{utp/ut-field.i mgind evento-ped nr-contrato 1}
assign c-contrato:label in frame {&frame-name} = trim(return-value).

{utp/ut-liter.i Modalidade}
assign i-cod-tipo-contr:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "evento-ped"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "evento-ped"}

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
  
  assign evento-ped.dt-evento:screen-value in frame {&frame-name} = string (today).

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
  
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .


if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */


  if adm-new-record = yes then
     assign evento-ped.dt-evento = input frame {&frame-name} evento-ped.dt-evento
            evento-ped.ind-sit-event = 1.
         
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

assign evento-ped.nr-contrato = input frame {&frame-name} c-contrato.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

assign c-cod-estabel = evento-ped.cod-estabel.

find first medicao-contrat 
     where medicao-contrat.numero-ordem = evento-ped.numero-ordem
       and medicao-contrat.num-seq-event = evento-ped.seq-evento 
       and medicao-contrat.log-rec-medicao = yes
       no-lock no-error.

if avail medicao-contrat then do:
   run utp/ut-msgs.p (input "show",
                      input 8685, /* Evento possui Recebimentos efetuados */
                      input "").
   return "adm-error".
end.

find first item-contrat 
     where item-contrat.num-seq-item = evento-ped.num-seq-item 
       and item-contrat.nr-contrat   = evento-ped.nr-contrat
       no-lock no-error.
       
if not avail item-contrat then do:
   {utp/ut-table.i mgind item-contrat 1}
   run utp/ut-msgs.p (input "show",
                      input 56,
                      input return-value).
   return "adm-error".
end.
   
if evento-ped.ind-sit-event = 2 then do:
   if evento-ped.ind-dest-event = 2 then do:
      run utp/ut-msgs.p (input "show",
                         input 8687, /* Evento ja antecipado nao pode ser eliminado*/
                         input "").
      return "adm-error".
   end.
   else do:
        run utp/ut-msgs.p (input "show",
                           input 8688, /* Evento ja realizado! Confirma eliminacao? */
                           input "").
        if return-value = "no" then return "adm-error".
   end.
end.

assign de-valor-conver = 0.
if item-contrat.mo-codigo <> 0 then 
   run cdp/cd0812.p (input item-contrat.mo-codigo,
                     input 0,
                     input evento-ped.val-realizado,
                     input item-contrat.dat-cotac,
                     output de-valor-conver).
   if de-valor-conver = 0 or
      de-valor-conver = ? then assign
      de-valor-conver = evento-ped.val-realizado.

   run cnp/cnapi003.p (input rowid(item-contrat),
                       input (evento-ped.qtd-realizada * (-1) *
                              integer(item-contrat.ind-tipo-control <> 2)),
                       input (de-valor-conver * (-1) *
                              integer(item-contrat.ind-tipo-control <> 2)),
                       input (evento-ped.qtd-realizada * (-1) *
                              integer(item-contrat.log-control-event) *
                              integer(evento-ped.ind-sit-event = 2)),
                       input (de-valor-conver * (-1) *
                              integer(item-contrat.log-control-event) *
                              integer(evento-ped.ind-sit-event = 2)),
                       input 0,
                       input 0,
                       input c-cod-estabel,
                       output l-msg-tela,
                       output l-erro-co,
                       input-output table tt-erro).                   
   find first tt-erro no-lock no-error. 
      if avail tt-erro then 
      run cdp/cd0666.w (input table tt-erro).                                           
                     
   if l-erro-co then do:
      run utp/ut-msgs.p (input "show",
                         input 8797,
                         input "").
      return "adm-error".
   end.
   
   for each  medicao-contrat 
       where medicao-contrat.nr-contrat = evento-ped.nr-contrat 
         and medicao-contrat.num-seq-item = evento-ped.num-seq-item 
         and medicao-contrat.numero-ordem = evento-ped.numero-ordem
         and medicao-contrat.num-seq-event = evento-ped.seq-evento EXCLUSIVE-LOCK:
        delete medicao-contrat.
   end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  
  disable all with frame {&frame-name}.
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

if available evento-ped and adm-new-record = no then do:
    assign c-contrato = evento-ped.nr-contrato.
    disp c-contrato with frame {&frame-name}.
end.

if available evento-ped then do:
    assign i-ordem = evento-ped.numero-ordem.
    
    find contrato-for where contrato-for.nr-contrato = input frame {&frame-name} c-contrato
        no-lock no-error.
    if available contrato-for then do:
        assign c-des-contrato      = contrato-for.des-contrat
               i-cod-tipo-contr = contrato-for.cod-tipo-contr.
        find tipo-contrat where tipo-contrat.cod-tipo-contr = 
            input frame {&frame-name} i-cod-tipo-contr
            no-lock no-error.
        if available tipo-contrat then
            assign c-tipo = tipo-contrat.des-tipo-contrat.
        display c-des-contrato
                i-cod-tipo-contr
                c-tipo with frame {&frame-name}.
    end.
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  run notify ('pi-recebe-item, group-assign-target').
  if adm-new-record then run pi-numera-evento.

if adm-new-record = no then 
    disable evento-ped.cod-estabel with frame {&frame-name}.
    
  
if avail evento-ped then do:
    find item-contrat 
        where item-contrat.nr-contrato = evento-ped.nr-contrato
          and item-contrat.num-seq-item = evento-ped.num-seq-item
        no-lock no-error.
    if avail item-contrat then
        if item-contrat.ind-tipo-control = 2 then
            enable evento-ped.numero-ordem with frame {&frame-name}.
end.
  

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
  
  assign gr-evento-ped = rowid (evento-ped).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-numera-evento V-table-Win 
PROCEDURE pi-numera-evento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if input frame {&frame-name} c-contrato <> ""      and
   input frame {&frame-name} c-contrato <> ?       and
   input frame {&frame-name} c-contrato <> " "     and
   input frame {&frame-name} evento-ped.numero-ordem <> ""     and
   input frame {&frame-name} evento-ped.numero-ordem <> "0.00" and
   input frame {&frame-name} evento-ped.numero-ordem <> ?      and
   input frame {&frame-name} evento-ped.num-seq-item <> ""     and
   input frame {&frame-name} evento-ped.num-seq-item <> "0"    and
   input frame {&frame-name} evento-ped.num-seq-item <> ?      then do:
   
    /* ---------- Numeracao de Evento -------------- */
    assign i-seq-evento = 1.
    
    find first b1-evento-ped where 
        b1-evento-ped.nr-contrato = input frame {&frame-name}
        c-contrato and
        b1-evento-ped.num-seq-item = input frame {&frame-name} evento-ped.num-seq-item and
        b1-evento-ped.numero-ordem = input frame {&frame-name} evento-ped.numero-ordem 
        no-lock no-error.
        
    if  available b1-evento-ped then do:
        find last b1-evento-ped where 
            b1-evento-ped.nr-contrato = input frame {&frame-name} 
            c-contrato and
        b1-evento-ped.num-seq-item = input frame {&frame-name} 
            evento-ped.num-seq-item and
            b1-evento-ped.numero-ordem = input frame {&frame-name} 
            evento-ped.numero-ordem and
            b1-evento-ped.seq-evento >= input frame {&frame-name}
            evento-ped.seq-evento no-lock no-error.
              
        if avail b1-evento-ped then do:
            if b1-evento-ped.seq-evento < 999999 then
                assign i-seq-evento = b1-evento-ped.seq-evento + 1.
            if b1-evento-ped.seq-evento = 999999 then do:
                run utp/ut-msgs.p (input "show",
                                   input 8361, 
                                   input "").
                /* Nao ha numeracao disponivel */
                return "adm-error".
            end.
            else assign evento-ped.seq-evento:screen-value = string (i-seq-evento).
        end.
    end.
    else assign evento-ped.seq-evento:screen-value = string (i-seq-evento).

    /* ------------------------------------------------------ */
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ordem V-table-Win 
PROCEDURE pi-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if input frame {&frame-name} c-contrato <> ""  and
   input frame {&frame-name} c-contrato <> ?   and
   input frame {&frame-name} c-contrato <> " " and
   input frame {&frame-name} evento-ped.cod-estabel <> ""  and
   input frame {&frame-name} evento-ped.cod-estabel <> " " and
   input frame {&frame-name} evento-ped.cod-estabel <> ? then do:
    
    find first param-contrat no-lock no-error.
    find item-contrat 
        where item-contrat.num-seq-item = input frame {&frame-name} evento-ped.num-seq-item
          and item-contrat.nr-contrato =  input frame {&frame-name} c-contrato
        no-lock no-error.
    if avail item-contrat then do:
    if item-contrat.ind-tipo-control = 1 then do:
        find first pedido-compr where 
                   pedido-compr.nr-contrat = input frame {&frame-name}
                   c-contrato and
                   pedido-compr.cod-estabel = input frame {&frame-name}
                   evento-ped.cod-estabel no-lock no-error.
        if not avail pedido-compr then do:
          /* Estabelecimento nao habilitado para o Contrato */
           run utp/ut-msgs.p(input "show",
                             input 7840, 
                             input "").
           return "adm-error".
        end.
           
        if contrato-for.ind-control-rec = 1 then 
            find first ordem-compra where 
                ordem-compra.nr-contrato  = input frame {&frame-name}
                c-contrato and   
                ordem-compra.cod-estabel = input frame {&frame-name}
                evento-ped.cod-estabel and   
                ordem-compra.it-codigo   = param-contrat.it-codigo
                no-lock no-error.
        else 
            find first ordem-compra use-index estabel where
                ordem-compra.nr-contrato   = input frame {&frame-name} 
                c-contrato and
                ordem-compra.num-seq-item = input frame {&frame-name}
                evento-ped.num-seq-item and
                ordem-compra.cod-estabel = input frame {&frame-name}
                evento-ped.cod-estabel no-lock no-error.
        if  available ordem-compra then do:
        
            assign i-ordem = ordem-compra.numero-ordem.
            display i-ordem @ evento-ped.numero-ordem with frame {&frame-name}.
        
        end.
        else do:
            run utp/ut-msgs.p (input "show" ,
                               input 7841   ,
                               input ""     ).
            /* 7841  Item nao habilitado para o estabelecimento */
            return "adm-error".
        end.
    end.
    end.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-contrato V-table-Win 
PROCEDURE pi-passa-contrato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-nr-contrato like evento-ped.nr-contrato.

assign p-nr-contrato = input frame {&frame-name} c-contrato.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-rowid V-table-Win 
PROCEDURE pi-passa-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output parameter p-item-contrat as rowid.
def output parameter p-contrato-for as rowid.

find item-contrat where item-contrat.num-seq-item = input frame {&frame-name}
     evento-ped.num-seq-item and item-contrat.nr-contrat = input frame {&frame-name}
     c-contrato no-lock no-error.

find contrato-for where contrato-for.nr-contrato = input frame {&frame-name}
     c-contrato no-lock no-error.

if available item-contrat then
    assign p-item-contrat = rowid(item-contrat).
    
if available contrato-for then
    assign p-contrato-for = rowid(contrato-for).


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
find first b-evento-ped
    where b-evento-ped.nr-contrat   = input frame {&frame-name} c-contrato and
          b-evento-ped.num-seq-item = input frame {&frame-name} evento-ped.num-seq-item and
          b-evento-ped.numero-ordem = input frame {&frame-name} evento-ped.numero-ordem and
          b-evento-ped.seq-evento   = input frame {&frame-name} evento-ped.seq-evento
    no-lock no-error.
if available b-evento-ped then do:
    if adm-new-record = yes then do:
        {include/i-vldprg.i}
        {utp/ut-liter.i Evento * R}
        run utp/ut-msgs.p(input "show",
                          input 1, 
                          input return-value).  /* Evento j† cadastrado */
        apply 'entry' to c-contrato in frame {&frame-name}.
        return "adm-error".        
    end.
end.

if adm-new-record = yes then do:
    {utp/ut-liter.i Contrato * R}
    find contrato-for where contrato-for.nr-contrato = input 
        frame {&frame-name} c-contrato no-lock no-error.
    if  not available contrato-for then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 56, 
                          input return-value).  /* Contrato nao Cadastrado */
        apply "entry" to c-contrato in frame {&frame-name}.
        return "adm-error".
    end.
end.

if  avail contrato-for then do:
    if not ((contrato-for.dt-ini-validade <= today and
             contrato-for.dt-ter-validade >= today) and
             contrato-for.ind-sit-contrat = 2) then do:
        {include/i-vldprg.i}     
        run utp/ut-msgs.p(input "show",
                         input 7834, 
                         input "").  /* Contrato nao emitido ou vencido. */
        apply 'entry' to c-contrato in frame {&frame-name}.                         
        return "adm-error".
    end.
end.                  

find item-contrat where item-contrat.num-seq-item = 
                        input frame {&frame-name} evento-ped.num-seq-item 
                        and item-contrat.nr-contrat =
                        input frame {&frame-name} c-contrato 
                        no-lock no-error.
if  not available item-contrat then do:
    {include/i-vldprg.i}
    run utp/ut-msgs.p(input "show",
                      input 7835, 
                      input ""). /* Sequencia de item nao cadastrada. */
    apply 'entry' to evento-ped.num-seq-item in frame {&frame-name}.                      
    return "adm-error".
end.

if item-contrat.ind-sit-item <> 2 then do:
   {include/i-vldprg.i}
    run utp/ut-msgs.p(input "show",
                      input 7836, 
                      input ""). /* Situacao do item do Contrato Invalida. */
    apply 'entry' to evento-ped.num-seq-item in frame {&frame-name}.                       
    return "adm-error".
end.

if item-contrat.log-libera = no then do:
  {include/i-vldprg.i}
   run utp/ut-msgs.p(input "show",
                     input 7838, 
                     input ""). /* Item Inativo no Contrato. */
   apply 'entry' to evento-ped.num-seq-item in frame {&frame-name}.                      
   return "adm-error". 
end.

if input frame {&frame-name} c-contrato:sensitive = no then do:
    if  not item-contrat.log-control-event then do:
       {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                         input 7839, 
                         input ""). /* item nao controlado por evento. */
        apply 'entry' to evento-ped.num-seq-item in frame {&frame-name}.                          
        return "adm-error". 
    end.
end.

if adm-new-record = no then do:
     find first medicao-contrat where
             medicao-contrat.nr-contrat = evento-ped.nr-contrat and
             medicao-contrat.num-seq-item = evento-ped.num-seq-item and
             medicao-contrat.num-seq-event = evento-ped.seq-evento and
             medicao-contrat.log-rec-medicao = yes no-lock no-error.

    if avail medicao-contrat then 
        find first medicao-contrat where 
            medicao-contrat.nr-contrat = evento-ped.nr-contrat and
            medicao-contrat.num-seq-item = evento-ped.num-seq-item and
            medicao-contrat.num-seq-event = evento-ped.seq-evento and
            medicao-contrat.log-rec-medicao = no no-lock no-error.
    if avail medicao-contrat and medicao-contrat.log-rec-medicao = yes then do:
      {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show",
                          input  8310,
                          input ""). /* Evento ja Recebido */
       apply 'entry' to c-contrato in frame {&frame-name}.                           
       return "adm-error".
    end.
end.

find first pedido-compr where 
           pedido-compr.nr-contrat = input frame {&frame-name}
           c-contrato and
           pedido-compr.cod-estabel = input frame {&frame-name}
           evento-ped.cod-estabel no-lock no-error.
if not avail pedido-compr then do:
  {include/i-vldprg.i}
   run utp/ut-msgs.p(input "show",
                     input 7840, 
                     input ""). /* Estabelecimento nao habilitado para o Contrato */
    apply 'entry' to evento-ped.cod-estabel in frame {&frame-name}.                      
    return "adm-error". 
end.
 
if adm-new-record = yes then do:
    if contrato-for.ind-control-rec = 1 then 
        find first ordem-compra 
            where ordem-compra.nr-contrato  = input frame {&frame-name}
                                              c-contrato
            and   ordem-compra.cod-estabel = input frame {&frame-name}
                                              evento-ped.cod-estabel
            and   ordem-compra.it-codigo   = param-contrat.it-codigo
            no-lock no-error.
    else do:
        find first ordem-compra use-index estabel where
            ordem-compra.nr-contrato   = input frame {&frame-name} 
            c-contrato and
            ordem-compra.num-seq-item = input frame {&frame-name}
            evento-ped.num-seq-item and
            ordem-compra.cod-estabel = input frame {&frame-name}
            evento-ped.cod-estabel no-lock no-error.
    end.
    if  not available ordem-compra then do:
       {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 7841, 
                          input ""). /* Item nao habilitado para o estabelecimento */
        apply 'entry' to evento-ped.num-seq-item in frame {&frame-name}.                          
        /*return "adm-error". */
    end.
end.

for each b-evento-ped 
    where b-evento-ped.nr-contrat = 
          input frame {&frame-name} c-contrato and
          b-evento-ped.num-seq-item =
          input frame {&frame-name} evento-ped.num-seq-item and
          b-evento-ped.numero-ordem = 
          input frame {&frame-name} evento-ped.numero-ordem
          no-lock: 
          
          assign de-total-qtd = de-total-qtd +
                                b-evento-ped.qtd-prevista
                 de-total-val = de-total-val +
                                b-evento-ped.val-previsto.
end.
assign de-qtd-ordem = 0
       de-val-ordem = 0.
if item-contrat.ind-tipo-control = 2 then do:
    for each prazo-compra where 
        prazo-compra.numero-ordem = 
        input frame {&frame-name} evento-ped.numero-ordem
        and prazo-compra.situacao = 2 no-lock:
        
        assign de-qtd-ordem = prazo-compra.qtd-do-forn +
                                           de-qtd-ordem             
               de-val-ordem = de-val-ordem +
                                           (prazo-compra.qtd-do-forn *
                                            item-contrat.pre-unit-for).
    end.
 
    if (de-total-qtd >= de-qtd-ordem) or 
       (de-total-val >= de-val-ordem) then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p(input "show",
                         input 7842, 
                         input ""). /* Total de eventos ultrapassa saldo da Ordem */
       apply 'entry' to evento-ped.numero-ordem in frame {&frame-name}.                     
       return "adm-error". 
    end.
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
  {src/adm/template/sndkycas.i "nr-contrat" "evento-ped" "nr-contrat"}
  {src/adm/template/sndkycas.i "numero-ordem" "evento-ped" "numero-ordem"}

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
  {src/adm/template/snd-list.i "evento-ped"}

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


