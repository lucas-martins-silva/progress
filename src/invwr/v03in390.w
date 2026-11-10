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
{include/i-prgvrs.i V03IN390 2.00.00.026 } /*** "010026" ***/
 
 
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
 
def new global shared var gr-reservas  as rowid no-undo.
def new global shared var c-it-codigo like saldo-estoq.it-codigo   no-undo.
def new global shared var c-estab     like saldo-estoq.cod-estabel no-undo.
 
def buffer b-reservas for reservas.
 
 
def var c-un       like reservas.un                  no-undo.
def var c-depos    like reservas.cod-depos           no-undo.
def var de-quant   like reservas.quant-orig          no-undo.
def var c-label-1  as   character     format "x(20)" no-undo.
def var c-label-2  as   character     format "x(20)" no-undo.
def var de-qt-atend like reservas.quant-atend        no-undo.

{cdp/cdcfgmnt.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

def var c-servidor          as char.

def temp-table tt-reservas
     field nr-ord-produ    as integer         format ">>>,>>>,>>9"
     field it-codigo       as character       format "x(16)"
     field dt-reserva      as date            format "99/99/9999"
     field quant-orig      as decimal         format "->>>>>,>>9.9999"
     field un              as character       format "xx"
     field quant-atend     as decimal         format "->>>>>,>>9.9999"
     field quant-requis    as decimal         format ">>>>>,>>9.9999"
     field tp-atualiza     as integer         format "99"
     field lote-serie      as character       format "x(10)"
     field op-codigo       as integer         format ">>>>9"
     field cod-depos       as character       format "x(3)"
     field emite-requis    as logical         format "Sim/Nao"
     field estado          as integer         format ">9"
     field quant-aloc      as decimal         format "->>>>>,>>9.9999"
     field item-pai        as character       format "x(16)"
     field quant-terc      as decimal         format ">>>>>,>>>9.9999"
     field origem          as integer         format ">9"
     field cod-roteiro     as character       format "x(16)"
     field tipo-sobra      as integer         format ">9"
     field cod-refer       as character       format "x(8)"
     field cd-lubr         as character       format "x(8)"
     field nr-ord-refer    as integer         format ">>>,>>>,>>9"
     field nr-req-sum      as integer         format ">>>,>>>,>>9"
     field cod-localiz     as character       format "x(10)"
     field quant-aplic     as decimal         format ">>>>>,>>9.9999"
     field cons-mrp        as logical         format "Sim/Nao"
     field char-1          as character       format "x(100)"
     field char-2          as character       format "x(100)"
     field dec-1           as decimal         format "->>>>>>>>>>>9.99999999"
     field dec-2           as decimal         format "->>>>>>>>>>>9.99999999"
     field int-1           as integer         format "->>>>>>>>>9"
     field int-2           as integer         format "->>>>>>>>>9"
     field log-1           as logical         format "Sim/Nao"
     field log-2           as logical         format "Sim/Nao"
     field data-1          as date            format "99/99/9999"
     field data-2          as date            format "99/99/9999"
     field check-sum       as character       format "x(20)"
     field cod-lista-compon as character      format "X(16)"
     field num-id-reservas as integer         format ">>>,>>>,>>9".

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
&Scoped-define EXTERNAL-TABLES reservas
&Scoped-define FIRST-EXTERNAL-TABLE reservas


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR reservas.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS reservas.cod-refer reservas.dt-reserva ~
reservas.lote-serie reservas.cd-lubr reservas.cod-localiz 
&Scoped-define ENABLED-TABLES reservas
&Scoped-define FIRST-ENABLED-TABLE reservas
&Scoped-define DISPLAYED-TABLES reservas
&Scoped-define FIRST-DISPLAYED-TABLE reservas
&Scoped-Define ENABLED-OBJECTS c-cod-depos de-quant-orig rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS reservas.op-codigo reservas.it-codigo ~
reservas.cod-refer reservas.dt-reserva reservas.lote-serie reservas.cd-lubr ~
reservas.cod-localiz 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-item fi-referencia-descricao ~
c-cod-depos c-descr-depos de-quant-orig fi-unid-med c-descr-lubr ~
c-local-nome 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS reservas.op-codigo reservas.it-codigo 
&Scoped-define ADM-ASSIGN-FIELDS c-cod-depos de-quant-orig 
&Scoped-define ADM-MODIFY-FIELDS c-cod-depos de-quant-orig 

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


/* Menu Definitions                                                     */
DEFINE MENU PUP-MN-it-codigo TITLE "Zoom Item"
       MENU-ITEM m_It_equipto   LABEL "Zoom Componentes do Equipamento"
       MENU-ITEM m_Zoom_Itens   LABEL "Zoom de Itens" .

DEFINE MENU ZoomDepos 
       MENU-ITEM m_ZoomDep      LABEL "Zoom de Dep¢sitos"
       MENU-ITEM m_ZoomSal      LABEL "Zoom de Saldos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE c-descr-depos AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-lubr AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-local-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE de-quant-orig AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     LABEL "Qtde Reserva":R15 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88.

DEFINE VARIABLE fi-referencia-descricao AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-med AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.33.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     reservas.op-codigo AT ROW 1.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     reservas.it-codigo AT ROW 2.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-item AT ROW 2.17 COL 39 COLON-ALIGNED NO-LABEL
     reservas.cod-refer AT ROW 3.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     fi-referencia-descricao AT ROW 3.75 COL 33.86 COLON-ALIGNED HELP
          "Descricao da Referencia" NO-LABEL
     reservas.dt-reserva AT ROW 4.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     reservas.lote-serie AT ROW 4.75 COL 64.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     c-cod-depos AT ROW 5.75 COL 21 COLON-ALIGNED
     c-descr-depos AT ROW 5.75 COL 29 COLON-ALIGNED NO-LABEL
     de-quant-orig AT ROW 6.75 COL 21 COLON-ALIGNED
     fi-unid-med AT ROW 6.75 COL 40 COLON-ALIGNED NO-LABEL
     reservas.cd-lubr AT ROW 7.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-lubr AT ROW 7.75 COL 34 COLON-ALIGNED NO-LABEL
     reservas.cod-localiz AT ROW 8.83 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     c-local-nome AT ROW 8.83 COL 37 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.reservas
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
         HEIGHT             = 9.04
         WIDTH              = 88.86.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-depos IN FRAME f-main
   2 3                                                                  */
ASSIGN 
       c-cod-depos:POPUP-MENU IN FRAME f-main       = MENU ZoomDepos:HANDLE.

/* SETTINGS FOR FILL-IN c-descr-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-lubr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-local-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-quant-orig IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN fi-referencia-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-unid-med IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN reservas.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
ASSIGN 
       reservas.it-codigo:POPUP-MENU IN FRAME f-main       = MENU PUP-MN-it-codigo:HANDLE.

/* SETTINGS FOR FILL-IN reservas.op-codigo IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON F5 OF c-cod-depos IN FRAME f-main /* Dep¢sito */
DO:
          {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=c-cod-depos
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON LEAVE OF c-cod-depos IN FRAME f-main /* Dep¢sito */
DO:
   {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-descr-depos   
                   &where="deposito.cod-depos = input frame {&frame-name} c-cod-depos"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-depos IN FRAME f-main /* Dep¢sito */
DO:
     apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.cd-lubr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cd-lubr V-table-Win
ON F5 OF reservas.cd-lubr IN FRAME f-main /* Forma Lubrifica‡Æo */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in136.w"
                     &campo=reservas.cd-lubr
                     &campozoom=cd-lubr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cd-lubr V-table-Win
ON LEAVE OF reservas.cd-lubr IN FRAME f-main /* Forma Lubrifica‡Æo */
DO:
  {include/leave.i &tabela=form-lubrif
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-lubr   
                   &where="form-lubrif.cd-lubr = input frame {&frame-name} reservas.cd-lubr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cd-lubr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.cd-lubr IN FRAME f-main /* Forma Lubrifica‡Æo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-localiz V-table-Win
ON F5 OF reservas.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in189.w"
                  &tabela=reservas
                  &atributo=cod-localiz}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-localiz V-table-Win
ON LEAVE OF reservas.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  {include/leave.i &tabela=localizacao
                  &atributo-ref=descricao
                  &variavel-ref=c-local-nome
                  &where="localizacao.cod-localiz = input frame {&frame-name} reservas.cod-localiz"} 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
   apply 'F5' to self. 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-refer V-table-Win
ON F5 OF reservas.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=reservas.cod-refer
                     &campozoom = cod-refer
                     &parametros= "run pi-seta-inicial in wh-pesquisa
                     (reservas.it-codigo:screen-value)." }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-refer V-table-Win
ON LEAVE OF reservas.cod-refer IN FRAME f-main /* Referˆncia */
DO:
   assign fi-referencia-descricao = "".
   find ref-item use-index item
        where ref-item.it-codigo = input frame {&frame-name} reservas.it-codigo
          and ref-item.cod-refer = input frame {&frame-name} reservas.cod-refer
        no-lock no-error.
   if avail ref-item then do:
      find referencia of ref-item no-lock no-error.
      if avail referencia then
         assign fi-referencia-descricao = referencia.descricao.
   end. 
   display fi-referencia-descricao with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.cod-refer IN FRAME f-main /* Referˆncia */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.it-codigo V-table-Win
ON F5 OF reservas.it-codigo IN FRAME f-main /* Item Reserva */
DO:
   ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=reservas.it-codigo
                     &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.it-codigo V-table-Win
ON LEAVE OF reservas.it-codigo IN FRAME f-main /* Item Reserva */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-descricao-item   
                   &where="item.it-codigo = input frame {&frame-name} reservas.it-codigo"}
  {include/leave.i &tabela=item
                   &atributo-ref=un
                   &variavel-ref=fi-unid-med
                   &where="item.it-codigo = input frame {&frame-name} reservas.it-codigo"}
  {include/leave.i &tabela=item
                   &atributo-ref=deposito-pad
                   &variavel-ref=c-cod-depos
                   &where="item.it-codigo = input frame {&frame-name} reservas.it-codigo"}
  {include/leave.i &tabela=item
                   &atributo-ref=cod-localiz
                   &variavel-ref=reservas.cod-localiz
                   &where="item.it-codigo = input frame {&frame-name} reservas.it-codigo"}
  {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao
                   &variavel-ref=c-local-nome
                   &where="localizacao.cod-localiz = input frame {&frame-name} reservas.cod-localiz"}                  
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-descr-depos   
                   &where="deposito.cod-depos = input frame {&frame-name} c-cod-depos"}
 
      if  item.loc-unica = no then  
          assign reservas.cod-localiz:sensitive in frame {&frame-name} = yes.
      else 
          assign reservas.cod-localiz:sensitive in frame {&frame-name} = no.
 
     if  item.tipo-con-est = 4 then
         enable reservas.cod-refer with frame {&frame-name}.
     else do:
          disable reservas.cod-refer with frame {&frame-name}.
          assign reservas.cod-refer:screen-value in frame {&frame-name} = ""
                 fi-referencia-descricao:screen-value in frame {&frame-name} = "".
     end.
 
     if item.tipo-con-est > 1 then
        enable reservas.lote-serie with frame {&frame-name}.
     else     
         disable reservas.lote-serie with frame {&frame-name}.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.it-codigo IN FRAME f-main /* Item Reserva */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_It_equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_It_equipto V-table-Win
ON CHOOSE OF MENU-ITEM m_It_equipto /* Zoom Componentes do Equipamento */
DO:
  ASSIGN l-implanta = YES.
  {include/zoomvar.i &prog-zoom="inzoom/z02in049.w"
                     &campo=reservas.it-codigo
                     &campozoom=it-codigo}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_ZoomDep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_ZoomDep V-table-Win
ON CHOOSE OF MENU-ITEM m_ZoomDep /* Zoom de Dep¢sitos */
DO:
    {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                       &campo     = c-cod-depos
                       &campozoom = cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_ZoomSal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_ZoomSal V-table-Win
ON CHOOSE OF MENU-ITEM m_ZoomSal /* Zoom de Saldos */
DO:  
    assign
        l-implanta = yes
        c-it-codigo = input frame {&frame-name} reservas.it-codigo.
 
    {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = c-cod-depos
        &campo2     = reserva.cod-localiz
        &campo3     = reserva.cod-refer
        &campozoom  = cod-depos
        &campozoom2 = cod-localiz
        &campozoom3 = cod-refer}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_Itens
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_Itens V-table-Win
ON CHOOSE OF MENU-ITEM m_Zoom_Itens /* Zoom de Itens */
DO:
  apply "f5" to reservas.it-codigo in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME reservas.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.op-codigo V-table-Win
ON F5 OF reservas.op-codigo IN FRAME f-main /* Opera‡Æo */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in273.w"
                     &campo=reservas.op-codigo
                     &campozoom=cd-tarefa}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF reservas.op-codigo IN FRAME f-main /* Opera‡Æo */
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
do with frame {&frame-name}: 
  if reservas.op-codigo:load-mouse-pointer ("image/lupa.cur") then.
  if reservas.it-codigo:load-mouse-pointer ("image/rbm.cur") then.
  if reservas.cd-lubr:load-mouse-pointer ("image/lupa.cur")   then.
  if c-cod-depos:load-mouse-pointer ("image/lupa.cur") then.
  if reservas.cod-localiz:load-mouse-pointer ("image/lupa.cur") then.
  if reservas.cod-refer:load-mouse-pointer ("image/lupa.cur")  then.
  if c-cod-depos:load-mouse-pointer("image~\rbm.cur") then.
  
  {utp/ut-field.i mgind reservas cod-depos 1}
  assign c-cod-depos:label = return-value .

  {utp/ut-liter.i Qt_Reserva}
  assign de-quant-orig:label = return-value .
end.

find first param-mi no-lock no-error.

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
  {src/adm/template/row-list.i "reservas"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "reservas"}

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
 
  if  avail ord-manut then
      assign reservas.dt-reserva:screen-value in frame {&frame-name} = string(ord-manut.dt-manut).
 
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
   
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
 
    /* Ponha na pi-validate todas as valida‡äes */
    if  reservas.it-codigo:sensitive in frame {&frame-name} = yes
    and can-find (b-reservas where b-reservas.nr-ord-produ  = ord-manut.nr-ord-produ
                             and   b-reservas.op-codigo     = input frame {&frame-name} reservas.op-codigo
                             and   b-reservas.it-codigo     = input frame {&frame-name} reservas.it-codigo) then do:
        {utp/ut-table.i mgind reservas 1}
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        return 'adm-error'.
    end.
 
    if  input frame {&frame-name} reservas.op-codigo <> 0 then do:
        find ord-taref
            where ord-taref.nr-ord-produ  = ord-manut.nr-ord-produ
            and   ord-taref.cd-tarefa     = input frame {&frame-name} reservas.op-codigo
            no-lock no-error.
        if  not avail ord-taref then do:
            run utp/ut-msgs.p (input "show",
                               input 4308,
                               input return-value).
            apply 'entry' to reservas.op-codigo.
            return 'adm-error':U.
        end.
    end.
 
    find item
        where item.it-codigo = input frame {&frame-name} reservas.it-codigo
        no-lock no-error.
    if  item.cod-obsoleto = 4 /* Totalmente Obsoleto */
        then do:
        run utp/ut-msgs.p (input "show",
                           input 2585,
                           input return-value).
        apply 'entry' to reservas.it-codigo.
        return 'adm-error':U.
    end.
 
    if  item.tipo-requis = 3 then do:
        run utp/ut-msgs.p (input "show",
                           input 1675,
                           input return-value).
        apply 'entry' to reservas.it-codigo.
        return 'adm-error':U.
    end.
 
    if  item.tipo-contr = 4 then do:
        run utp/ut-msgs.p (input "show",
                           input 1673,
                           input return-value).
        apply 'entry' to reservas.it-codigo.
        return 'adm-error':U.
    end.
 
    if  input frame {&frame-name} reservas.dt-reserva < ord-manut.dt-manut
    or  input frame {&frame-name} reservas.dt-reserva > ord-manut.dt-prev then do:
        {utp/ut-field.i mgind ord-manut dt-manut 1}
        assign c-label-1 = string(ord-manut.dt-manut,"99/99/9999").
        {utp/ut-field.i mgind ord-manut dt-prev 1}
        assign c-label-2 = string(ord-manut.dt-prev,"99/99/9999").
        run utp/ut-msgs.p (input "show",
                           input 1692,
                           input c-label-1 + "~~" + c-label-2).
        apply 'entry' to reservas.dt-reserva.
        return 'adm-error':U.
    end.
 
    find deposito
        where deposito.cod-depos = input frame {&frame-name} c-cod-depos
        no-lock no-error.
    if  not avail deposito then do:
        run utp/ut-msgs.p (input "show",
                           input 530,
                           input "").
        apply 'entry' TO c-cod-depos in frame {&frame-name}.        
        return "adm-error".                            
    end. /* if not avail ... */    
 
    if  input frame {&frame-name} de-quant-orig = 0 then do:
        run utp/ut-msgs.p (input "show",
                           input 1570,
                           input "").
        apply 'entry' TO de-quant-orig in frame {&frame-name}.
        return "adm-error".                           
    end. /* if input ... */ 
 
    if not adm-new-record then
        if  reservas.quant-atend + 
            reservas.quant-aloc  +
            reservas.quant-terc  >
            input frame {&frame-name} de-quant-orig  then do:
            run utp/ut-msgs.p (input "show",
                               input 19538,
                               input "").
            apply 'entry' TO de-quant-orig in frame {&frame-name}.
            return "adm-error".                           
        end.   
 
    if  not(item.fraciona)
    and input frame {&frame-name} de-quant-orig <>
        integer(input frame {&frame-name} de-quant-orig) then do:
        run utp/ut-msgs.p (input "show",
                           input 1892,
                           input return-value).
        apply 'entry' to de-quant-orig.
        return 'adm-error':U.
    end.
 
    if  reservas.cd-lubr:sensitive in frame {&frame-name} = yes then do:
        find form-lubrif
            where form-lubrif.cd-lubr = input frame {&frame-name} reservas.cd-lubr
            no-lock no-error.
        if  not avail form-lubrif then do:
            {utp/ut-table.i mgind form-lubrif 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value).
            apply 'entry' to reservas.cd-lubr.
            return 'adm-error':U.
        end.
    end.
  
    IF  input frame {&frame-name} de-quant-orig < de-qt-atend    then do:
        run utp/ut-msgs.p (input "show",
                           input 1898,  /* Quantidade Atendida maior que a Quantidade Original */
                           input return-value).
        apply 'entry' to de-quant-orig.
        return 'adm-error':U.
    end.   
    
    &if defined(bf_mnt_ems203) &then
    
    &else    
        find ord-prod
           where ord-prod.nr-ord-prod = ord-manut.nr-ord-prod no-lock no-error.
    &endif
    
    if  reservas.cod-localiz:sensitive in frame {&frame-name} = yes
    and avail ord-prod then do:
 
        find localizacao
            where localizacao.cod-localiz = input frame {&frame-name} reservas.cod-localiz
            and   localizacao.cod-depos   = input frame {&frame-name} c-cod-depos
            and   localizacao.cod-estabel = &if defined(bf_mnt_ems203) &then ord-manut.cod-estabel &else ord-prod.cod-estabel &endif
            no-lock no-error.
        if  not avail localizacao then do:
            run utp/ut-msgs.p (input "show",
                               input 6662,
                               input "").
            apply 'entry' TO reservas.cod-localiz in frame {&frame-name}.
            return "adm-error".                           
        end. /* if input frame ... */
    end.
 
    assign c-un       = input frame {&frame-name} fi-unid-med
           c-depos    = input frame {&frame-name} c-cod-depos
           de-quant   = input frame {&frame-name} de-quant-orig.
 
    if  item.tipo-con-est = 4 then do:
        find ref-item use-index item
           where ref-item.it-codigo = input reservas.it-codigo
           and ref-item.cod-refer = input reservas.cod-refer no-lock no-error.
        if  not avail ref-item then do:
            run utp/ut-msgs.p (input "show",
                               input 529,
                               input "").
            apply 'entry' to reservas.cod-refer.
            return 'ADM-ERROR':U.
        end.
    end.
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
 
    find ord-manut
        where rowid(ord-manut) = v-row-parent
        NO-LOCK no-error.
    if  avail ord-manut  then do:
        assign reservas.nr-ord-produ = ord-manut.nr-ord-produ.
    end.
    &if defined (bf_mnt_ems203) &then
    &else
        FOR FIRST ORD-PROD FIELDS(NR-ORD-PRODU IT-CODIGO)
            WHERE ORD-PROD.NR-ORD-PRODU = ORD-MANUT.NR-ORD-PRODU NO-LOCK:
        END.    
    &endif
    assign reservas.un         = c-un
           reservas.cod-depos  = c-depos
           reservas.quant-orig = de-quant
           RESERVAS.ITEM-PAI   = &if defined (bf_mnt_ems203) &then 
                                     param-mi.it-codigo 
                                 &else ORD-PROD.IT-CODIGO &endif.
    if  item.loc-unica = yes then
        assign reservas.cod-localiz =  item.cod-localiz.
 
 
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
 
    if  avail reservas then do:
        find item
             where item.it-codigo = reservas.it-codigo no-lock no-error.
        assign c-descricao-item = if avail item then item.desc-item else "":U
               fi-unid-med = if avail item then item.un else "":U.
        
        find form-lubrif
             where form-lubrif.cd-lubr = taref-item.cd-lubr no-lock no-error.
        assign c-descr-lubr = if avail form-lubrif then form-lubrif.descricao else "":U.
        
        find deposito
            where deposito.cod-depos = INPUT FRAME {&frame-name} c-cod-depos
            no-lock no-error.
        assign c-descr-depos = if avail deposito then deposito.nome else "":U.
 
        find localizacao 
            where localizacao.cod-localiz = reservas.cod-localiz no-lock no-error.
        assign c-local-nome = if avail localizacao then localizacao.descricao else "":U.     
 
        find ref-item use-index item
           where ref-item.it-codigo = reservas.it-codigo
           and ref-item.cod-refer = reservas.cod-refer
           no-lock no-error.
        if  avail ref-item then do:
            find referencia of ref-item no-lock no-error.
            if  avail referencia then
                assign fi-referencia-descricao = referencia.descricao.
        end.
    end.
 
    IF  AVAIL reservas THEN
        ASSIGN c-cod-depos   = reservas.cod-depos
               de-quant-orig = reservas.quant-orig.
 
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
 
    find ord-manut
        where rowid(ord-manut) = v-row-parent
        NO-LOCK no-error.
    find tipo-manut
        where tipo-manut.cd-tipo = ord-manut.cd-tipo
        no-lock no-error.
    if  avail tipo-manut and tipo-manut.tp-manut = 4 then  /*LUBRIFICACAO*/
        enable reservas.cd-lubr with frame {&frame-name}.
    else do:
        assign reservas.cd-lubr:screen-value in frame {&frame-name} = " ".
        assign reservas.cd-lubr:sensitive in frame {&frame-name} = no.
    end.  
 
    if adm-new-record = no then do:
        find item where item.it-codigo = input frame {&frame-name} reservas.it-codigo no-lock no-error.
        if avail item then do:
           if item.tipo-con-est = 4 then
              enable reservas.cod-refer with frame {&frame-name}.
           else
              disable reservas.cod-refer with frame {&frame-name}.
 
           if item.loc-unica = no then
              assign reservas.cod-localiz:sensitive in frame {&frame-name} = yes.
           else 
              assign reservas.cod-localiz:sensitive in frame {&frame-name} = no.
 
           if item.tipo-con-est = 3 then
              enable reservas.lote-serie with frame {&frame-name}.
           else     
              disable reservas.lote-serie with frame {&frame-name}.
        end.
    end.                                     
 
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
         enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
 
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
   
    if  avail reservas then
        assign gr-reservas = rowid(reservas)
               de-qt-atend = reservas.quant-atend .
 
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
  def input parameter v-row-parent-externo as rowid no-undo.
 
  assign v-row-parent = v-row-parent-externo.
 
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
  {src/adm/template/snd-list.i "reservas"}

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

