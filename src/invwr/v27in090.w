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
{include/i-prgvrs.i V27IN090 2.00.00.031 } /*** "010031" 03/03/2026 08:23:54 ***/
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v27in090 MUT}
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
 
{include/i-vrtab.i estabelec}
 
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
def buffer b-doc for docum-est.
 
def var rw-saldo-terc as rowid no-undo.
 
def var i-especie     as integer no-undo.
def var i-observa     as integer no-undo initial 1.
def var i-nota-fatur  as integer no-undo.
def var i-x           as integer no-undo.
def var c-handle-aux  as character no-undo.
def var wh-programa   as handle no-undo.
def var i-docto-aux   like ser-estab.nr-ult-nota.
def var i-nro-docto   like docum-est.nro-docto.
def var c-lista-itens as char format "x(100)".
def var l-passou as l init no no-undo.
def new global shared var l-mostra-fornec as logical init no no-undo.
def var l-inclui      as logical no-undo initial no.
DEF VAR l-funcao-nfe  AS LOG         NO-UNDO.
DEF VAR log-nfse-nacional AS LOG     NO-UNDO.
{rep/re9999.i1}
{rep/re9999.i2 "new"}

def var i-empresa like param-global.empresa-prin no-undo.
{cdp/cdcfgdis.i}

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.

DEFINE VARIABLE i-cont       AS INTEGER NO-UNDO.
DEF VAR l-NT2024002 AS LOG INITIAL NO NO-UNDO.


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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.dt-emissao docum-est.dt-trans ~
docum-est.cod-estabel docum-est.estab-fisc 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS rt-key c-cod-chave-acesso ~ 
&Scoped-Define DISPLAYED-FIELDS docum-est.cod-emitente ~
docum-est.serie-docto docum-est.dt-emissao docum-est.dt-trans ~
docum-est.nro-docto docum-est.nat-operacao docum-est.esp-docto ~
docum-est.cod-estabel docum-est.estab-de-or docum-est.estab-fisc 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS fi-emitente l-reinf l-reinf40 ~
fi-nat-operacao fi-esp-natur fi-esp-docto l-movimentacao cb-cod-observa ~
i-fin-nfe c-fin-nfe fi-estabel fi-estabel-origem fi-estabel-fiscal ~
c-natureza fi-natureza c-cod-chave-acesso fi-idi-sit-nf-eletro ~
fi-ind-tip-nota-deb 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS docum-est.cod-emitente ~
docum-est.serie-docto docum-est.nro-docto docum-est.nat-operacao 
&Scoped-define ADM-ASSIGN-FIELDS docum-est.dt-emissao docum-est.dt-trans ~
docum-est.esp-docto cb-cod-observa fi-ind-tip-nota-deb docum-est.cod-estabel ~
docum-est.estab-de-or docum-est.estab-fisc c-natureza 
&Scoped-define ADM-MODIFY-FIELDS cb-cod-observa 

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
DEFINE VARIABLE cb-cod-observa AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "Ind£stria","Com‚rcio","Devolu‡Æo Cliente","Servi‡os" 
     DROP-DOWN-LIST
     SIZE 26.29 BY 1 NO-UNDO.

DEFINE VARIABLE fi-ind-tip-nota-deb AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 64.86 BY .88 NO-UNDO.

DEFINE VARIABLE l-movimentacao AS CHARACTER FORMAT "X(12)":U INITIAL "0" 
     LABEL "" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-chave-acesso AS CHARACTER FORMAT "x(60)" 
     LABEL "Chave acesso NFE" 
     VIEW-AS FILL-IN 
     SIZE 64.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-fin-nfe AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-natureza AS CHARACTER FORMAT "X.XX-XXX":U 
     LABEL "Natureza" 
     VIEW-AS FILL-IN 
     SIZE 10.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-esp-docto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-esp-natur AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 6.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-fiscal AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabel-origem AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 57.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-idi-sit-nf-eletro AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situa‡Æo NF-e" 
     VIEW-AS FILL-IN 
     SIZE 64.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nat-operacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-natureza AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 54.14 BY .88 NO-UNDO.

DEFINE VARIABLE i-fin-nfe AS INTEGER FORMAT ">":U INITIAL 0 
     LABEL "Finalid. NF-e" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 13.57.

DEFINE VARIABLE l-reinf AS LOGICAL INITIAL no 
     LABEL "REINF Servi‡os Tomados" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.29 BY .88.

DEFINE VARIABLE l-reinf40 AS LOGICAL INITIAL no 
     LABEL "REINF Reten‡äes Fonte" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.29 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.cod-emitente AT ROW 1.33 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     fi-emitente AT ROW 1.33 COL 30.43 COLON-ALIGNED NO-LABEL
     docum-est.serie-docto AT ROW 2.33 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     docum-est.dt-emissao AT ROW 2.33 COL 42.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.dt-trans AT ROW 2.33 COL 69.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     docum-est.nro-docto AT ROW 3.33 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     l-reinf AT ROW 3.33 COL 44.57 WIDGET-ID 6
     l-reinf40 AT ROW 3.33 COL 64.86 WIDGET-ID 6
     docum-est.nat-operacao AT ROW 4.33 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     fi-nat-operacao AT ROW 4.33 COL 29 COLON-ALIGNED NO-LABEL
     fi-esp-natur AT ROW 4.33 COL 77 COLON-ALIGNED NO-LABEL
     docum-est.esp-docto AT ROW 5.33 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-esp-docto AT ROW 5.33 COL 25.86 COLON-ALIGNED NO-LABEL
     l-movimentacao AT ROW 5.33 COL 67.14 COLON-ALIGNED
     cb-cod-observa AT ROW 6.33 COL 18.57 COLON-ALIGNED
     i-fin-nfe AT ROW 6.46 COL 58.72 COLON-ALIGNED WIDGET-ID 4
     c-fin-nfe AT ROW 6.46 COL 62.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     docum-est.cod-estabel AT ROW 7.46 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-estabel AT ROW 7.46 COL 25.86 COLON-ALIGNED NO-LABEL
     docum-est.estab-de-or AT ROW 8.46 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-estabel-origem AT ROW 8.46 COL 25.86 COLON-ALIGNED NO-LABEL
     docum-est.estab-fisc AT ROW 9.46 COL 18.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-estabel-fiscal AT ROW 9.46 COL 25.86 COLON-ALIGNED NO-LABEL
     c-natureza AT ROW 10.46 COL 18.57 COLON-ALIGNED
     fi-natureza AT ROW 10.46 COL 29.29 COLON-ALIGNED NO-LABEL
     c-cod-chave-acesso AT ROW 11.46 COL 18.57 COLON-ALIGNED
     fi-idi-sit-nf-eletro AT ROW 12.46 COL 18.57 COLON-ALIGNED
     fi-ind-tip-nota-deb AT ROW 13.46 COL 18.57 COLON-ALIGNED 
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
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
         HEIGHT             = 13.71
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-fin-nfe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-natureza IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR COMBO-BOX cb-cod-observa IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN docum-est.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN docum-est.cod-estabel IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.dt-emissao IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.dt-trans IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.esp-docto IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN docum-est.estab-de-or IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN docum-est.estab-fisc IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN fi-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-esp-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-esp-natur IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel-fiscal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estabel-origem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-idi-sit-nf-eletro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nat-operacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-natureza IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-fin-nfe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX l-movimentacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-reinf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-reinf40 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN docum-est.nat-operacao IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN docum-est.nro-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN docum-est.serie-docto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-ind-tip-nota-deb IN FRAME f-main
   NO-ENABLE 1                                                        */   
   
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

&Scoped-define SELF-NAME c-natureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza V-table-Win
ON F5 OF c-natureza IN FRAME f-main /* Natureza */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=c-natureza
                       &campozoom=nat-operacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza V-table-Win
ON LEAVE OF c-natureza IN FRAME f-main /* Natureza */
DO:
    do  with frame {&frame-name}:
        find first saldo-terc 
             where saldo-terc.cod-emitente  = input docum-est.cod-emitente
               and saldo-terc.nro-docto     = input docum-est.nro-docto
               and saldo-terc.serie-docto   = input docum-est.serie-docto
               and saldo-terc.nat-operacao  = input c-natureza
               and saldo-terc.cod-estabel   = input docum-est.estab-de-or
               and saldo-terc.quantidade    > 0
               and saldo-terc.tipo-sal-terc = 3 no-lock no-error.
        assign rw-saldo-terc = rowid(saldo-terc).  
        if  rw-saldo-terc <> ? then do:
            run pi-inicializa-campo in this-procedure.     
        end.
    end.
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-natureza
                     &where="natur-oper.nat-operacao = input frame {&frame-name}
                             c-natureza"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-natureza V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-natureza IN FRAME f-main /* Natureza */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-cod-observa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cod-observa V-table-Win
ON LEAVE OF cb-cod-observa IN FRAME f-main
DO:
    if  docum-est.cod-emitente:sensitive 
        in frame {&frame-name} = no then do:    /* Neste caso, o docto esta sendo alterado */
        find natur-oper where
             natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
    end.
    if avail natur-oper then do:
        RUN get-link-handle IN adm-broker-hdl
             (INPUT this-procedure, INPUT "Acha-wh2-target":U, OUTPUT c-handle-aux).
        do  i-x = 1 to num-entries(c-handle-aux):
            assign wh-programa = widget-handle(entry(i-x,c-handle-aux)). 
            if  valid-handle(wh-programa) then do:
                run pi-inicializa-campo in wh-programa
                    (input natur-oper.nat-operacao, 
                     input i-especie, 
                     input i-observa).
            end.
        end.
    end.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cod-observa V-table-Win
ON VALUE-CHANGED OF cb-cod-observa IN FRAME f-main
DO:
    assign input frame {&frame-name} cb-cod-observa
           i-observa = {ininc/i03in090.i 06 cb-cod-observa}.
    if  docum-est.cod-emitente:sensitive 
        in frame {&frame-name} = no then do:    /* Neste caso, o docto esta sendo alterado */
        find natur-oper where
             natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-emitente V-table-Win
ON F5 OF docum-est.cod-emitente IN FRAME f-main /* Emitente */
DO:
    assign l-mostra-fornec = yes
           l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                       &campo=docum-est.cod-emitente
                       &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-emitente V-table-Win
ON LEAVE OF docum-est.cod-emitente IN FRAME f-main /* Emitente */
DO:
    find emitente where 
         emitente.cod-emitente = input frame {&FRAME-NAME} docum-est.cod-emitente
         no-lock no-error.
    {include/leave.i &tabela=emitente
                     &atributo-ref=nome-emit
                     &variavel-ref=fi-emitente
                     &where="emitente.cod-emitente = input frame {&frame-name}
                             docum-est.cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.cod-emitente IN FRAME f-main /* Emitente */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-estabel V-table-Win
ON F5 OF docum-est.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
     l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=docum-est.cod-estabel
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-estabel V-table-Win
ON LEAVE OF docum-est.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-estabel
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             docum-est.cod-estabel"}
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.estab-de-or
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.estab-de-or V-table-Win
ON F5 OF docum-est.estab-de-or IN FRAME f-main /* Est Origem/Destino */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=docum-est.estab-de-or
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.estab-de-or V-table-Win
ON LEAVE OF docum-est.estab-de-or IN FRAME f-main /* Est Origem/Destino */
DO:
    if  l-inclui            and 
        natur-oper.tipo = 1 and 
        natur-oper.transf then do with frame {&frame-name}:
        find first saldo-terc 
             where saldo-terc.cod-emitente  = input docum-est.cod-emitente
               and saldo-terc.nro-docto     = input docum-est.nro-docto
               and saldo-terc.serie-docto   = input docum-est.serie-docto
               and saldo-terc.nat-operacao <> input docum-est.nat-operacao
               and saldo-terc.cod-estabel   = input docum-est.estab-de-or
               and saldo-terc.quantidade    > 0
               and saldo-terc.tipo-sal-terc = 3 no-lock no-error.
        assign rw-saldo-terc = rowid(saldo-terc).    
        if  avail saldo-terc then do: /* Indica Entrada e Transferencia */
            assign c-natureza = saldo-terc.nat-operacao.
            find last saldo-terc use-index documento
                where saldo-terc.cod-emitente  = input docum-est.cod-emitente
                  and saldo-terc.nro-docto     = input docum-est.nro-docto
                  and saldo-terc.serie-docto   = input docum-est.serie-docto
                  and saldo-terc.nat-operacao <> input docum-est.nat-operacao
                  and saldo-terc.cod-estabel   = input docum-est.estab-de-or
                  and saldo-terc.quantidade    > 0
                  and saldo-terc.tipo-sal-terc = 3 no-lock no-error.
            if  avail saldo-terc and saldo-terc.nat-operacao <> c-natureza then do:
                assign c-natureza:sensitive in frame {&frame-name} = yes.
                display c-natureza with frame {&frame-name}.
                apply "entry" to c-natureza in frame {&frame-name}.
            end.
            else
                assign c-natureza:sensitive in frame {&frame-name} = no
                       c-natureza = ?.
        end.  /* Roda a pi-inicializa-campo aqui se c-natureza est  desabilitado,
                 Caso contr rio roda no "leave" do c-natureza */
        if  c-natureza:sensitive in frame {&frame-name} = no  
        and rw-saldo-terc <> ? then do:
            run pi-inicializa-campo in this-procedure.
        end.
    end.
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-estabel-origem
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             docum-est.estab-de-or"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.estab-de-or V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.estab-de-or IN FRAME f-main /* Est Origem/Destino */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.estab-fisc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.estab-fisc V-table-Win
ON F5 OF docum-est.estab-fisc IN FRAME f-main /* Estabel Fiscal */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=docum-est.estab-fisc
                       &campozoom=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.estab-fisc V-table-Win
ON LEAVE OF docum-est.estab-fisc IN FRAME f-main /* Estabel Fiscal */
DO:
    {include/leave.i &tabela=estabelec
                     &atributo-ref=nome
                     &variavel-ref=fi-estabel-fiscal
                     &where="estabelec.cod-estabel = input frame {&frame-name}
                             docum-est.estab-fisc"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.estab-fisc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.estab-fisc IN FRAME f-main /* Estabel Fiscal */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-fin-nfe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fin-nfe V-table-Win
ON LEAVE OF i-fin-nfe IN FRAME f-main /* Finalid. NF-e */
DO:
    ASSIGN INPUT FRAME f-main i-fin-nfe.
    IF i-fin-nfe > 0 AND i-fin-nfe <= {varinc/var00187.i 05} THEN
        ASSIGN c-fin-nfe:SCREEN-VALUE IN FRAME f-main = {varinc/var00187.i 04 i-fin-nfe} .
    ELSE
        ASSIGN c-fin-nfe:SCREEN-VALUE IN FRAME f-main = "". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-movimentacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-movimentacao V-table-Win
ON LEAVE OF l-movimentacao IN FRAME f-main
DO:
  assign l-movimentacao = input frame {&frame-name} l-movimentacao.
  assign l-passou = yes.
  apply "leave" to docum-est.nat-operacao in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.nat-operacao V-table-Win
ON ENTRY OF docum-est.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
  assign l-passou = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.nat-operacao V-table-Win
ON F5 OF docum-est.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
     l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in245.w
                       &campo=docum-est.nat-operacao
                       &campozoom=nat-operacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.nat-operacao V-table-Win
ON LEAVE OF docum-est.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
    find natur-oper where 
         natur-oper.nat-operacao = input frame {&FRAME-NAME} docum-est.nat-operacao
         no-lock no-error.
 
    assign l-movimentacao:screen-value in frame {&frame-name} = ?.
    disable l-movimentacao with frame {&frame-name}.
    if  avail natur-oper then do with frame {&FRAME-NAME}:
        /*****************************************************
        **  RE0301.I19 - Definicao da Especie do documento  **
        *****************************************************/
        /* natur-oper.tipo: 1-Ent, 2-Sai
                   Valores atribuidos abaixo em sequencia: 23; 21 ou 22; 20; 21 ou 20;
                   Legenda: 20-NFD 21-NFE 22-NFS 23-NFT */
 
        if natur-oper.transf then
            assign i-especie = 23 /*"NFT"*/.
        else
            if natur-oper.terceiros then
                assign i-especie = 20 + natur-oper.tipo /*string(natur-oper.tipo,"NFE/NFS")*/.
            else do:
                if not l-passou then do:
                    if  emitente.identific = 3 
                    and natur-oper.tipo = 1    
                    and (   substr(natur-oper.nat-operacao,2,1) = "2"
                         or substr(natur-oper.nat-operacao,2,1) = "3"
                         or substr(natur-oper.nat-operacao,2,1) = "7" 
                         or substr(natur-oper.nat-operacao,2,1) = "9" ) then 
                    do:
                        enable l-movimentacao with frame {&frame-name}.
                        assign l-movimentacao:screen-value = "Fornecedor".
                        apply "entry" to l-movimentacao in frame {&frame-name}.
                        return no-apply.
                    end.
                end.
                if emitente.identific = 1 /*"C"*/  or 
                   input frame {&frame-name} l-movimentacao = "Cliente" /*l-cliente*/ then do:
                   if natur-oper.tipo = 1 then
                       assign i-especie = 20 /*"NFD"*/.
                   else assign i-especie = 1.
                end.
                else
                   assign i-especie = if natur-oper.tipo = 1 then 21 
                                      else 20.    /*string(natur-oper.tipo,"NFE/NFD")*/
            end.
 
        /* RE0301.I19 */
 
        assign fi-esp-docto   = {ininc/i03in218.i 04 i-especie}
               fi-esp-natur   = natur-oper.especie-doc
               i-observa      = if  natur-oper.tipo = 1 
                                and i-especie = 20 then 3   /* Se Entrada e NFD */
                                else 1
               cb-cod-observa = {ininc/i03in090.i 04 i-observa}.
 
        display i-especie @ docum-est.esp-docto
                fi-esp-docto
                fi-esp-natur
                cb-cod-observa.
        RUN get-link-handle IN adm-broker-hdl
             (INPUT this-procedure, INPUT "Acha-wh2-target":U, OUTPUT c-handle-aux).
        do  i-x = 1 to num-entries(c-handle-aux):
            assign wh-programa = widget-handle(entry(i-x,c-handle-aux)). 
            if  valid-handle(wh-programa) then do:
                run pi-inicializa-campo in wh-programa
                    (input natur-oper.nat-operacao, 
                     input i-especie, 
                     input i-observa).
            end.
        end.
    end.    
    else
        assign i-especie = 1.
 
    assign docum-est.estab-de-or:sensitive = (avail natur-oper and natur-oper.transf).
 
    {include/leave.i &tabela=natur-oper
                     &atributo-ref=denominacao
                     &variavel-ref=fi-nat-operacao
                     &where="natur-oper.nat-operacao = input frame {&frame-name}
                             docum-est.nat-operacao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.nat-operacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF docum-est.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.serie-docto V-table-Win
ON F5 OF docum-est.serie-docto IN FRAME f-main /* S‚rie */
OR  MOUSE-SELECT-DBLCLICK OF docum-est.serie-docto in frame {&frame-name} DO:
     l-implanta      = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in407.w
                       &campo=docum-est.serie-docto
                       &campozoom=serie}
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
  ASSIGN l-NT2024002 = CAN-FIND (FIRST funcao no-lock 
                               WHERE funcao.cd-funcao = "spp-NT2024002"
                                 AND funcao.ativo     = YES). 

  {utp/ut-field.i mgind docum-est nat-operacao 1}
  assign c-natureza:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind docum-est cod-observa 1}
  assign cb-cod-observa:label in frame {&frame-name} = return-value.
 
 IF l-NT2024002 THEN DO:
    {utp/ut-field.i mgind docum-est cod-tipo-nf-cred-deb 1}
    assign fi-ind-tip-nota-deb:label in frame {&frame-name} = return-value.   
 END.
  
 
  if docum-est.cod-emitente:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.nat-operacao:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.cod-estabel:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.estab-de-or:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.estab-fisc:load-mouse-pointer("image/lupa.cur") then .
  if docum-est.serie-docto:load-mouse-pointer("image/lupa.cur") then .
  if c-natureza:load-mouse-pointer("image/lupa.cur") then .
 
  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.
  ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

  /* Funcao Super/Minas */
  &IF DEFINED(Bf_dis_usuario_estab) &THEN
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:
         RUN cdp/cd8702.p (INPUT c-seg-usuario,
                           INPUT-OUTPUT c-cod-estabel-usuar).
      END.
  &ENDIF
  find param-re where param-re.usuario = c-seg-usuario no-lock no-error.

  ASSIGN l-funcao-nfe = IF CAN-FIND(funcao NO-LOCK WHERE funcao.cd-funcao = "SPP-NFE":U
                                                   AND   funcao.ativo = YES) THEN YES ELSE NO.

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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
 
  {utp/ut-field.i mgind docum-est nat-operacao 1}
  assign c-natureza:label in frame {&frame-name} = return-value.
  do  with frame {&frame-name}:
      find estabelec where 
           estabelec.cod-estabel = c-cod-estabel-usuar
           no-lock no-error.
      assign docum-est.cod-estabel:screen-value = c-cod-estabel-usuar
             docum-est.estab-fisc:screen-value  = c-cod-estabel-usuar
             docum-est.dt-emissao:screen-value  = string(today)
             docum-est.dt-trans:screen-value    = string(today)
             fi-estabel:screen-value            = if avail estabelec then estabelec.nome else ""
             fi-estabel-fiscal:screen-value     = if avail estabelec then estabelec.nome else "".
  end.
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
  def var i-esp-docto as integer no-undo. 
 
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
 
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
 
  if  i-nota-fatur > 0 then do with frame {&frame-name}:
      run utp/ut-msgs.p (input "show":U, input 5268,
          input docum-est.nro-docto:screen-value + "~~" + string(i-nota-fatur) ).
      assign docum-est.nro-docto:screen-value = string(i-nota-fatur).
  end.  
  assign i-esp-docto = input frame {&frame-name} docum-est.esp-docto.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  find natur-oper where
       natur-oper.nat-operacao = input frame {&frame-name} docum-est.nat-operacao
       no-lock no-error.

  assign i-empresa = param-global.empresa-prin.

  &if defined (bf_dis_consiste_conta) &then

      find estabelec where
           estabelec.cod-estabel = input frame {&frame-name} docum-est.cod-estabel no-lock no-error.

      run cdp/cd9970.p (input rowid(estabelec),
                        output i-empresa).
  &endif

  find conta-contab where
       conta-contab.ep-codigo      = i-empresa and
       conta-contab.conta-contabil = docum-est.conta-transit no-lock no-error.
 
 
  assign docum-est.ct-transit  = if avail conta-contab then conta-contab.ct-codigo else "":U.
  assign docum-est.sc-transit  = if avail conta-contab then conta-contab.sc-codigo else "":U.
 
  assign docum-est.tipo-docto  = natur-oper.tipo
         docum-est.esp-docto   = i-esp-docto
         docum-est.sit-atual   = 1. /*for‡a executar a concilia‡Æo*/
 
 
  if  docum-est.esp-docto = 21   /* NFE */
  and can-do("16,26",substring(docum-est.nat-operacao,1,2)) then do:
      assign docum-est.cod-ibge = docum-est.mod-frete + 4.
  end.
  if  l-inclui and rw-saldo-terc <> ? and natur-oper.transf and docum-est.tipo-docto = 1 then do:
      run pi-gera-itens-entrada-nft in this-procedure.
  end.
 
  run pi-seta-flags-observacao in this-procedure    /* criada no re9999.i1 */
      (input docum-est.cod-observa, input docum-est.nat-operacao).
  assign v-row-parent = rowid(docum-est).
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
  assign input frame {&frame-name} cb-cod-observa.
  assign docum-est.cod-observa = {ininc/i03in090.i 06 cb-cod-observa}.
  
  
   
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
  if  avail docum-est then do:
      find emitente where 
           emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
      find natur-oper where
           natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
      find estabelec where
           estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
      if avail emitente and avail natur-oper then do:
         assign fi-emitente     = emitente.nome-emit.
         
         if natur-oper.tipo = 1 then do:

             if (emitente.identific = 3 OR
                 emitente.identific = 1)
             and docum-est.esp-docto = 20 then 
                assign l-movimentacao:screen-value in frame {&frame-name} = "Cliente".
             else 
                if (emitente.identific = 3 OR
                    emitente.identific = 2) then
                assign l-movimentacao:screen-value in frame {&frame-name} = "Fornecedor".
         end.
      end.
      if avail natur-oper then
         assign fi-nat-operacao   = natur-oper.denominacao
                fi-esp-natur      = natur-oper.especie-doc 
                log-nfse-nacional = natur-oper.log-nfse-nacional. /*salva se a natureza ‚ NFS-e nacional*/          
      assign fi-esp-docto    = {ininc/i03in218.i 04 docum-est.esp-docto}.
      if avail estabelec then
         assign fi-estabel      = estabelec.nome.
      find estabelec where
           estabelec.cod-estabel = docum-est.estab-de-or no-lock no-error.
      assign fi-estabel-origem = if avail estabelec then estabelec.nome else "".
      find estabelec where
           estabelec.cod-estabel = docum-est.estab-fisc no-lock no-error.
      assign fi-estabel-fiscal = if avail estabelec then estabelec.nome else "".
      
  end.
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  if  avail docum-est then do with frame {&frame-name}:
      assign cb-cod-observa:screen-value = 
                            {ininc/i03in090.i 04 docum-est.cod-observa}
             i-observa = docum-est.cod-observa.
       
      /*finalidade da nota*/
      assign i-fin-nfe:screen-value in frame f-main = trim(docum-est.cod-finalidade)
             l-reinf:checked in frame f-main = if substring(docum-est.char-2,256,1) = "S" then yes else no
             l-reinf40:checked in frame f-main = if substring(docum-est.char-2,269,1) = "S" then yes else no.
             
             
      IF l-NT2024002 THEN DO:
         IF  docum-est.cod-tipo-nf-cred-deb <> ""
         AND docum-est.cod-tipo-nf-cred-deb <> ? THEN
         
            CASE i-fin-nfe:screen-value in frame f-main :
                WHEN '5' THEN    // 5 - Nota decCr‚dito 
                    ASSIGN fi-ind-tip-nota-deb:SCREEN-VALUE  = {varinc/var00201.i 04 int(docum-est.cod-tipo-nf-cred-deb)} NO-ERROR. 
                WHEN '6' THEN // 6 - Nota de d‚bito
                    ASSIGN fi-ind-tip-nota-deb:SCREEN-VALUE  = {varinc/var00199.i 04 int(docum-est.cod-tipo-nf-cred-deb)} NO-ERROR.  
                OTHERWISE
                   ASSIGN fi-ind-tip-nota-deb:SCREEN-VALUE IN FRAME {&frame-name} = ''.    
            END CASE.
         ELSE 
            ASSIGN fi-ind-tip-nota-deb:SCREEN-VALUE IN FRAME {&frame-name} = ''.    
      END.
      
             
      APPLY "LEAVE":U TO i-fin-nfe in frame f-main.
  end.
  else do with frame {&frame-name}:
      assign cb-cod-observa:screen-value = {ininc/i03in090.i 04 1}
             i-observa = 1.
      IF l-NT2024002 THEN 
         ASSIGN fi-ind-tip-nota-deb:SCREEN-VALUE  = ''.
  end.
  
  IF l-NT2024002  = NO THEN
     ASSIGN fi-ind-tip-nota-deb:HIDDEN IN FRAME {&FRAME-NAME} = YES
            fi-ind-tip-nota-deb:SCREEN-VALUE IN FRAME {&frame-name} = ''.    
 
  IF l-funcao-nfe THEN DO:
    /*** Campos para versÆo 204 a 207 ***/
    &IF  "{&bf_dis_versao_ems}"  <  "2.07"  &THEN
        ASSIGN c-cod-chave-acesso:HIDDEN IN FRAME {&FRAME-NAME} = NO
               c-cod-chave-acesso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTR(docum-est.char-1,93,60) NO-ERROR.
              
    &ELSE
        ASSIGN c-cod-chave-acesso:HIDDEN IN FRAME {&FRAME-NAME} = NO
               c-cod-chave-acesso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est.cod-chave-aces-nf-eletro NO-ERROR.
    &ENDIF
    
    &IF  "{&bf_dis_versao_ems}"  <  "2.071"  &THEN
        ASSIGN fi-idi-sit-nf-eletro:SCREEN-VALUE IN FRAME {&frame-name} = {diinc/i01di135.i 04 INT(SUBSTR(docum-est.char-1,154,2))} NO-ERROR.
              
    &ELSE
        ASSIGN fi-idi-sit-nf-eletro:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {diinc/i01di135.i 04 docum-est.idi-sit-nf-eletro} NO-ERROR.
    &ENDIF

    ASSIGN c-cod-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
           c-cod-chave-acesso:READ-ONLY IN FRAME {&FRAME-NAME} = YES.
        
  END.
  ELSE ASSIGN c-cod-chave-acesso:HIDDEN   IN FRAME {&FRAME-NAME} = YES
              fi-idi-sit-nf-eletro:HIDDEN IN FRAME {&FRAME-NAME} = YES. 

  IF log-nfse-nacional THEN
      ASSIGN c-cod-chave-acesso:HIDDEN IN FRAME {&FRAME-NAME} = NO
             c-cod-chave-acesso:SCREEN-VALUE IN FRAME {&FRAME-NAME} = docum-est.cod-chave-aces-nf-eletro
             c-cod-chave-acesso:SENSITIVE IN FRAME {&FRAME-NAME} = YES 
             c-cod-chave-acesso:READ-ONLY IN FRAME {&FRAME-NAME} = YES NO-ERROR.
  
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
 
  do  with frame {&frame-name}:
      assign docum-est.cod-estabel:sensitive = 
          ( (docum-est.cod-emitente:sensitive and param-estoq.estab-uni = no)
             or (avail docum-est and param-estoq.estab-uni = no
                 and docum-est.rec-fisico = no) ).
  end.
  if not l-inclui and avail docum-est then do:   /* alteracao */
    find natur-oper where
         natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
    if avail natur-oper then do:
        RUN get-link-handle IN adm-broker-hdl
             (INPUT this-procedure, INPUT "Acha-wh2-target":U, OUTPUT c-handle-aux).
        do  i-x = 1 to num-entries(c-handle-aux):
            assign wh-programa = widget-handle(entry(i-x,c-handle-aux)). 
            if  valid-handle(wh-programa) then do:
                run pi-inicializa-campo in wh-programa
                    (input natur-oper.nat-operacao, 
                     input docum-est.esp-docto, 
                     input docum-est.cod-observ).
            end.
        end.
        assign docum-est.estab-de-or:sensitive = natur-oper.transf.
    end.
  end.
  find first param-global no-lock no-error.
  assign docum-est.estab-fisc:sensitive  = ( param-global.modulo-of = yes and
                                             param-estoq.estab-uni  = no ).
 
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
  {utp/ut-liter.i Movimenta‡Æo_com * L}
  assign l-movimentacao:label in frame {&frame-name} = return-value.
 
  {utp/ut-liter.i Fornecedor * R}
  assign c-lista-itens = return-value + ",".
 
  {utp/ut-liter.i Cliente * R}
  assign c-lista-itens = c-lista-itens + return-value.
 
 
  do with frame {&frame-name}:
      assign cb-cod-observa:list-items = {ininc/i03in090.i 03}.
      assign l-movimentacao:list-items    = c-lista-itens.
      
  end.
 
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-itens-entrada-nft V-table-Win 
PROCEDURE pi-gera-itens-entrada-nft :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    def buffer b-rat for rat-lote.
 
    def var i-seq as integer no-undo.
 
    find saldo-terc where rowid(saldo-terc) = rw-saldo-terc no-lock no-error.
    assign i-seq = param-re.seq-item-um.
    for each componente 
       where componente.cod-emitente = saldo-terc.cod-emitente
         and componente.nat-operacao = saldo-terc.nat-operacao 
         and componente.serie-docto  = saldo-terc.serie-docto
         and componente.nro-docto    = saldo-terc.nro-docto no-lock
          by componente.sequencia:
 
        find item where item.it-codigo = componente.it-codigo no-lock no-error.
        create item-doc-est.
        assign item-doc-est.aliquota-icm = componente.aliquota-icm
               item-doc-est.aliquota-ipi = componente.aliquota-ipi
               item-doc-est.cd-trib-icm  = componente.cd-trib-icm
               item-doc-est.cd-trib-ipi  = componente.cd-trib-ipi
               item-doc-est.class-fiscal = componente.class-fiscal
               item-doc-est.cod-depos    = item.deposito-pad
               item-doc-est.cod-emitente = docum-est.cod-emitente
               item-doc-est.cod-refer    = componente.cod-refer
               item-doc-est.encerra-pa   = no
               item-doc-est.it-codigo    = componente.it-codigo
               item-doc-est.cod-localiz  = componente.cod-localiz
               item-doc-est.lote         = componente.lote
               item-doc-est.narrativa    = componente.narrativa
               item-doc-est.seq-comp     = componente.sequencia
               item-doc-est.nat-comp     = componente.nat-operacao
               item-doc-est.nat-operacao = docum-est.nat-operacao
               item-doc-est.nr-ord-prod  = 0
               item-doc-est.nro-docto    = docum-est.nro-docto
               item-doc-est.nro-comp     = componente.nro-docto
               item-doc-est.peso-liquido = componente.peso-liquido
               item-doc-est.pre-unit-mob[1]    = item-doc-est.pre-unit-mob[1]
               item-doc-est.preco-total[1]     = componente.preco-total[1]
               item-doc-est.iss-ntrib[1] = if param-estoq.tem-moeda1
                                           then componente.iss-ntrib[1] else 0
               item-doc-est.iss-ntrib[2] = if param-estoq.tem-moeda2
                                           then componente.iss-ntrib[2] else 0
               item-doc-est.qt-do-forn   = componente.qt-do-forn
               item-doc-est.quantidade   = componente.quantidade
               item-doc-est.reabre-pa    = no
               item-doc-est.reabre-pd    = no
               item-doc-est.conta-contabil = componente.conta-contabil               
               item-doc-est.ct-codigo      = componente.ct-codigo
               item-doc-est.sc-codigo      = componente.sc-codigo
               item-doc-est.sequencia    = i-seq
               item-doc-est.serie-docto  = docum-est.serie-docto
               item-doc-est.serie-comp   = componente.serie-docto
               item-doc-est.un           = componente.un.
        for each rat-lote 
           where rat-lote.cod-emitente = saldo-terc.cod-emitente
             and rat-lote.nat-operacao = saldo-terc.nat-operacao
             and rat-lote.serie-docto  = saldo-terc.serie-docto
             and rat-lote.nro-docto    = saldo-terc.nro-docto
             and rat-lote.it-codigo = item-doc-est.it-codigo 
             and rat-lote.sequencia = componente.sequencia no-lock:
            create b-rat.
            assign b-rat.cod-emitente = item-doc-est.cod-emitente
                   b-rat.serie-docto  = item-doc-est.serie-docto
                   b-rat.nro-docto    = item-doc-est.nro-docto
                   b-rat.nat-operacao = item-doc-est.nat-operacao
                   b-rat.sequencia    = i-seq
                   b-rat.cod-depos    = rat-lote.cod-depos
                   b-rat.lote         = rat-lote.lote
                   b-rat.cod-localiz  = rat-lote.cod-localiz
                   b-rat.dt-vali-lote = rat-lote.dt-vali-lote
                   b-rat.quantidade   = rat-lote.quantidade
                   b-rat.it-codigo    = rat-lote.it-codigo.
        end.
 
        /* Calculo do IPI */
        run rep/re9992.p (input rowid(item-doc-est)).
        assign item-doc-est.valor-ipi[1]  = de-IPI-item
               item-doc-est.base-ipi[1]   = de-IPI-base-item
               item-doc-est.ipi-ntrib[1]  = de-IPI-ntrib-item
               item-doc-est.ipi-outras[1] = de-IPI-outras-item.
 
        /* Calculo do ICMS */
        run rep/re9994.p ( input rowid(item-doc-est) ).  /*ICMS*/
 
        find emitente where
             emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.
        find estabelec where
             estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.
        find natur-oper where
             natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.     
 
        assign item-doc-est.valor-icm[1]   = de-ICM-item
               item-doc-est.base-icm[1]    = de-ICM-base-item
               item-doc-est.icm-ntrib[1]   = de-ICM-ntrib-item
               item-doc-est.icm-outras[1]  = de-ICM-outras-item
               item-doc-est.icm-complem[1] = de-ICM-complem-item *
                                             integer(estabelec.pais = "BRASIL" and
                                             emitente.pais = estabelec.pais and
                                             estabelec.estado <> docum-est.uf and
                                             natur-oper.consum-final).
        assign item-doc-est.base-subs[1]   = if natur-oper.subs-trib 
                                             then de-ICM-base-item else 0
               item-doc-est.vl-subs[1]     = if natur-oper.subs-trib 
                                             then de-ICM-item else 0.
 
        assign i-seq = i-seq + param-re.inc-seq.
 
    end.
 
    run rep/re9990.p (input rowid(docum-est), input yes). 
                            /* o segundo par³metro indica que a tabela docum-est serÿ atualizada
                               com o resultado do calculo dos impostos. */
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def var c-lista-handle as character no-undo.
def var i-x            as integer   no-undo.
def var h-viewer       as handle    no-undo.
 
def buffer b-doc for docum-est.
 
if  rw-saldo-terc <> ? then do with frame {&frame-name}:
    find saldo-terc where rowid(saldo-terc) = rw-saldo-terc no-lock no-error.
    find b-doc where
         b-doc.cod-emitente = saldo-terc.cod-emitente and
         b-doc.nat-operacao = saldo-terc.nat-operacao and
         b-doc.serie-docto  = saldo-terc.serie-docto  and
         b-doc.nro-docto    = saldo-terc.nro-docto    no-lock no-error.
    if  avail b-doc then do with frame {&frame-name}:
        assign cb-cod-observa = {ininc/i03in090.i 04 b-doc.cod-observa}
               i-observa      = {ininc/i03in090.i 06 cb-cod-observa}
               cb-cod-observa:screen-value       = cb-cod-observa
               docum-est.dt-emissao:screen-value = string(b-doc.dt-emissao).
    end.
    else do with frame {&frame-name}:
        assign docum-est.dt-emissao:screen-value = string(saldo-terc.dt-retorno).
    end.
    RUN get-link-handle IN adm-broker-hdl
        (INPUT this-procedure, INPUT "Acha-wh1-target":U, OUTPUT c-lista-handle).
    do  i-x = 1 to num-entries(c-lista-handle):
        assign h-viewer = widget-handle(entry(i-x,c-lista-handle)).
        run pi-entrada-transferencia in h-viewer (rw-saldo-terc).
    end.
end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-ok V-table-Win 
PROCEDURE pi-retorna-ok :
/*------------------------------------------------------------------------------
  Purpose:    Retornar para a Window (re0301a.w) se a viewer est  ok   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def output param l-viewer-ok as logical no-undo.
 
do  with frame {&frame-name}:
    find emitente where emitente.cod-emitente = input docum-est.cod-emitente
         no-lock no-error.
    ASSIGN l-viewer-ok = IF (avail emitente and i-especie > 0 
                         and input docum-est.nro-docto > "" 
                         and input docum-est.serie-docto > "" 
                         and i-observa > 0) 
                         or  (docum-est.cod-emitente:sensitive = no)
                         THEN yes ELSE no.
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
 
  def var da-transacao as date no-undo.
  def buffer b-estab for estabelec.
 
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
 
  assign input frame {&frame-name} cb-cod-observa
         i-observa = {ininc/i03in090.i 06 cb-cod-observa}.
 
  assign da-transacao = input frame {&frame-name} docum-est.dt-trans
         i-nota-fatur = 0. /* Se 0, na Assign-Record indicar  NF manual no FT */
 
  find estabelec where 
       estabelec.cod-estabel = input frame {&frame-name} docum-est.cod-estabel
       no-lock no-error.
  if  not avail estabelec then do:
      {include/i-vldprg.i} 
      {utp/ut-field.i mgind docum-est cod-estabel 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to docum-est.cod-estabel in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.          
 
  if natur-oper.transf = yes then do:
      find estabelec where 
           estabelec.cod-estabel = input frame {&frame-name} docum-est.estab-de-or
           no-lock no-error.
      if  not avail estabelec then do:
          {include/i-vldprg.i} 
          {utp/ut-field.i mgind docum-est estab-de-or 1}
          run utp/ut-msgs.p (input "show":U, input 56, input return-value).
          apply "entry" to docum-est.estab-de-or in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.          
 
  find estabelec where 
       estabelec.cod-estabel = input frame {&frame-name} docum-est.estab-fisc
       no-lock no-error.
  if  not avail estabelec then do:
      {include/i-vldprg.i} 
      {utp/ut-field.i mgind docum-est estab-fisc 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to docum-est.estab-fisc in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.          
 
  find emitente where 
       emitente.cod-emitente = input frame {&frame-name} docum-est.cod-emitente
       no-lock no-error.
  if  not avail emitente then do:
      {include/i-vldprg.i} 
      {utp/ut-field.i mgind docum-est cod-emitente 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to docum-est.cod-emitente in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.          
 
 
  find serie where serie.serie = input frame {&frame-name} docum-est.serie-docto
       no-lock no-error.
  if  not avail serie then do:
      {include/i-vldprg.i} 
      {utp/ut-table.i mgind serie 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to docum-est.serie-docto in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.     
  find ser-estab where
       ser-estab.serie = input frame {&frame-name} docum-est.serie-docto and
       ser-estab.cod-estabel = input frame {&frame-name} docum-est.cod-estabel 
       no-lock no-error.
 
  if  docum-est.cod-emitente:sensitive in frame {&frame-name} then do:
      find b-doc no-lock where
           b-doc.cod-emitente = input frame {&FRAME-NAME} docum-est.cod-emitente and
           b-doc.nat-operacao = input frame {&FRAME-NAME} docum-est.nat-operacao and
           b-doc.serie-docto  = input frame {&FRAME-NAME} docum-est.serie-docto  and
           b-doc.nro-docto    = input frame {&FRAME-NAME} docum-est.nro-docto no-error.
      if  avail b-doc then do: 
          {include/i-vldprg.i} 
          {utp/ut-table.i mgind docum-est 1}
          run utp/ut-msgs.p (input "show":U, input 7, input return-value).
          apply "entry" to docum-est.cod-emitente in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  param-global.modulo-ft and natur-oper.imp-nota then do:
          if  natur-oper.atual-estat or natur-oper.baixa-estoq then do:
              {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show":U, input 5105, input "").
              apply "entry" to docum-est.nat-operacao in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
      end.
  end.
  else do:
      find natur-oper where natur-oper.nat-operacao = docum-est.nat-operacao 
           no-lock no-error.
  end.
 
  if  natur-oper.tipo = 3 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 8723, input "").
      if  docum-est.cod-emitente:sensitive in frame {&frame-name} 
         then apply "entry" to docum-est.nat-operacao in frame {&frame-name}.
      else apply "entry" to cb-cod-observa in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
 
 
  if  natur-oper.tipo = 2 and natur-oper.terceiros = no 
  and natur-oper.transf = no and emitente.identific = 1 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5107, input "").
      apply "entry" to docum-est.nat-operacao in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  natur-oper.transf = no and natur-oper.terceiros = no
  and natur-oper.tipo = 2 and emitente.identific <> 2 then do:
      if  emitente.identific = 1 or l-movimentacao  = "Cliente" then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 5107, input "").
          apply "entry" to docum-est.esp-docto in frame {&frame-name}.
          return 'ADM-ERROR':U.  
      end.
  end.
  if  natur-oper.transf and natur-oper.tipo = 2 and param-estoq.estab-uni then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5121, input "").
      apply "entry" to docum-est.esp-docto in frame {&frame-name}.
      return 'ADM-ERROR':U.  
  end.
 
  if  (i-observa = 3 and emitente.identific = 2)
  or  ((i-observa = 1 or i-observa = 2) 
  and input frame {&frame-name} docum-est.esp-docto = 20 
  and natur-oper.tipo = 1
  and (emitente.identific = 1 or emitente.identific = 3))
  or  (emitente.identific = 3 and l-movimentacao  = "Fornecedor" and i-observa = 3)     
   then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5122, input "").
      apply "entry" to docum-est.esp-docto in frame {&frame-name}.
      return 'ADM-ERROR':U.  
  end.
  if  ( emitente.estado = estabelec.estado
        and can-do("1,5",substring(natur-oper.nat-operacao,1,1)) ) = false
  and ( emitente.estado <> estabelec.estado
        and emitente.natureza = 3
        and can-do("3,7",substring(natur-oper.nat-operacao,1,1)) ) = false
  and ( emitente.estado <> estabelec.estado
        and emitente.natureza <> 3
        and can-do("2,6",substring(natur-oper.nat-operacao,1,1)) ) = false
  then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5125, input "").
      if  return-value = "no" then do:
          apply "entry" to docum-est.esp-docto in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
  if input frame {&FRAME-NAME} docum-est.dt-emissao < (today - param-re.var-emis) or 
     input frame {&FRAME-NAME} docum-est.dt-emissao > today then do:
      {include/i-vldprg.i} 
      {utp/ut-field.i mgind docum-est dt-emissao 2}       
      run utp/ut-msgs.p (input "show":U, input 15370, input return-value).
      apply "entry" to docum-est.dt-trans in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
 
  if  da-transacao < input frame {&frame-name} docum-est.dt-emissao
  or  da-transacao <= param-estoq.mensal-ate or da-transacao > today
  or  da-transacao < (today - param-re.var-atual)  then do:
      {include/i-vldprg.i} 
      {utp/ut-field.i mgind docum-est dt-transacao 2}       
      run utp/ut-msgs.p (input "show":U, input 15370, input return-value).
      apply "entry" to docum-est.dt-trans in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
 
  if  c-natureza:sensitive in frame {&frame-name} and rw-saldo-terc = ? then do:
      {utp/ut-table.i mgind saldo-terc 1}
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      apply "entry" to c-natureza in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  l-inclui and natur-oper.tipo = 1 and natur-oper.transf and rw-saldo-terc = ? then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5128, input "").
      apply "entry" to docum-est.estab-de-or in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if natur-oper.transf and natur-oper.tipo = 1 then do: /*entrada transferˆncia*/
      if input frame {&FRAME-NAME} docum-est.estab-de-or = input frame {&FRAME-NAME} docum-est.cod-estabel then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 15371, input "").
        apply "entry" to docum-est.estab-de-or in frame {&frame-name}.
        return 'ADM-ERROR':U.
      end.
  end.
 
  if natur-oper.transf and natur-oper.tipo = 2 then do: /*sa¡da transferˆncia*/
      if input frame {&FRAME-NAME} docum-est.estab-de-or = input frame {&FRAME-NAME} docum-est.cod-estabel then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 15382, input "").
        apply "entry" to docum-est.estab-de-or in frame {&frame-name}.
        return 'ADM-ERROR':U.
      end.
      find b-estab where b-estab.cod-estabel = input docum-est.estab-de-or
          no-lock no-error.
      if not available b-estab then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 6243, input "").
        apply "entry" to docum-est.estab-de-or in frame {&frame-name}.
        return 'ADM-ERROR':U.
      end.
      if b-estab.cod-emitente <> input frame {&FRAME-NAME} docum-est.cod-emitente then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show":U, input 6245, input "").
        apply "entry" to docum-est.estab-de-or in frame {&frame-name}.
        return 'ADM-ERROR':U.
      end.
  end.
 
  if  param-global.modulo-ft and natur-oper.imp-nota and serie.forma-emis = 1 then do:
      if  ser-estab.ind-prox-dt and da-transacao > ser-estab.dt-prox-fat then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 5134, input "").
          apply "entry" to docum-est.dt-trans in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  da-transacao < ser-estab.dt-ult-fat then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p (input "show":U, input 5134, input "").
          apply "entry" to docum-est.dt-trans in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
      if  da-transacao > ser-estab.dt-ult-fat then do:
          {include/i-vldprg.i} 
          run utp/ut-msgs.p ( input "show":U, input 5135, 
                              input string(ser-estab.dt-ult-fat) ).
          if  return-value = "no" then do:
              apply "entry" to docum-est.dt-trans in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
      end.
  end.
  if  param-global.modulo-of and not 
     (param-global.modulo-ft and input frame {&frame-name} docum-est.esp-docto = 22)
      then do with frame {&frame-name}: /* 22-NFS */
      find doc-fiscal where
           doc-fiscal.cod-emitente = input docum-est.cod-emitente and
           doc-fiscal.nat-operacao = input docum-est.nat-operacao and
           doc-fiscal.serie        = input docum-est.serie-docto  and
           doc-fiscal.nr-doc-fis   = input docum-est.nro-docto    and
           doc-fiscal.cod-estabel  = input docum-est.estab-fisc no-lock no-error.
      if  avail doc-fiscal then do:
          if  doc-fiscal.dt-docto <> da-transacao then do:
              {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show":U, input 5136, input "").
              apply "entry" to docum-est.dt-trans in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
          else do:
              {include/i-vldprg.i} 
              run utp/ut-msgs.p (input "show":U, input 5137, input "").
              if  return-value = "no" then do:
                  apply "entry" to docum-est.dt-trans in frame {&frame-name}.
                  return 'ADM-ERROR':U.
              end.          
          end.
      end.     
  end.
  find param-of where 
       param-of.cod-estabel = input frame {&frame-name} docum-est.estab-fisc
       no-lock no-error.
  if  avail param-of and param-of.dt-congela <> ?
  and da-transacao <= param-of.dt-congela then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5137, input return-value).
      if  return-value = "no" then do:
          apply "entry" to docum-est.dt-trans in frame {&frame-name}.
          return 'ADM-ERROR':U.
      end.
  end.
  if  l-inclui and param-global.modulo-ft and natur-oper.imp-nota then do:
      find serie where 
           serie.serie = input frame {&frame-name} docum-est.serie-docto
           no-lock no-error.
      if  serie.forma-emis = 1 then do:
          find ser-estab where
               ser-estab.serie        = input frame {&frame-name} docum-est.serie-docto and
               ser-estab.cod-estabel  = input frame {&frame-name} docum-est.cod-estabel
               no-lock no-error.
          assign i-docto-aux = string(int(ser-estab.nr-ult-nota) + 1).
          find b-doc where
               b-doc.nro-docto    = i-docto-aux and 
               b-doc.serie-docto  = input frame {&frame-name} docum-est.serie-docto and
               b-doc.cod-emitente = input frame {&frame-name} docum-est.cod-emitente and 
               b-doc.nat-operacao = input frame {&frame-name} docum-est.nat-operacao
               no-lock no-error.
          if  i-docto-aux <> input frame {&frame-name} docum-est.nro-docto then do:
              assign i-nro-docto = input frame {&frame-name} docum-est.nro-docto.
              run utp/ut-msgs.p (input "show":U, input 5268, 
                                 input i-nro-docto + "~~" + i-docto-aux).
              assign docum-est.nro-docto:screen-value in frame {&frame-name} = i-docto-aux.
          end.
          if  avail b-doc then do: 
              {include/i-vldprg.i} 
              {utp/ut-table.i mgind docum-est 1}
              run utp/ut-msgs.p (input "show":U, input 7, input return-value).
              apply "entry" to docum-est.cod-emitente in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
      end.
  end.
 
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
  {src/adm/template/snd-list.i "docum-est"}

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

